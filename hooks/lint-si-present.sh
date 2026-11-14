#!/usr/bin/env bash
# devteam : hook PostToolUse (Edit|Write|MultiEdit)
#
# Deux contrôles sur le fichier que Claude vient d'écrire :
#   1. Style : signale tout tiret long (cadratin U+2014, demi-cadratin U+2013), interdit
#      par la skill style-equipe. Le message est renvoyé à Claude (code 2) pour correction.
#   2. Qualité : formate / linte le fichier avec l'outil du projet s'il est disponible.
#      Un outil absent ou en échec ne bloque jamais (code 0), sauf si
#      DEVTEAM_LINT_FEEDBACK=1 (les erreurs restantes sont alors renvoyées à Claude).
#
# Le code 2 d'un hook PostToolUse ne bloque rien : l'édition reste appliquée.
# Portable : Linux, macOS, Windows (Git Bash).
#
# Variables :
#   DEVTEAM_HOOK_DISABLE=1   désactive complètement le hook
#   DEVTEAM_STYLE_CHECK=0    désactive le contrôle des tirets longs
#   DEVTEAM_LINT_FEEDBACK=1  renvoie les erreurs de lint restantes à Claude

[ "${DEVTEAM_HOOK_DISABLE:-0}" = "1" ] && exit 0

input="$(cat 2>/dev/null || true)"

# --- Lecture d'un champ JSON de l'entrée (jq, sinon python, sinon sed) -------------
extract() {
  local key="$1"
  if command -v jq >/dev/null 2>&1; then
    printf '%s' "$input" | jq -r "$key // empty" 2>/dev/null
  elif command -v python3 >/dev/null 2>&1 || command -v python >/dev/null 2>&1; then
    local py; py="$(command -v python3 || command -v python)"
    printf '%s' "$input" | "$py" -c "import json,sys
try:
  d=json.load(sys.stdin)
  for k in '$key'.lstrip('.').split('.'): d=d.get(k) if isinstance(d,dict) else None
  print(d or '')
except Exception: pass" 2>/dev/null
  else
    local last="${key##*.}"
    printf '%s' "$input" | tr -d '\n' | sed -n "s/.*\"$last\"[[:space:]]*:[[:space:]]*\"\([^\"]*\)\".*/\1/p" | head -n1
  fi
}

file="$(extract '.tool_input.file_path')"
cwd="$(extract '.cwd')"
[ -z "$file" ] && exit 0

# Chemins Windows (C:\...) convertis au format Git Bash si possible
case "$file" in
  [A-Za-z]:\\*|[A-Za-z]:/*) command -v cygpath >/dev/null 2>&1 && file="$(cygpath -u "$file")" ;;
esac
[ -f "$file" ] || exit 0

# --- Racine du projet : dépôt git du fichier, sinon cwd de la session ----------------
dir="$(dirname "$file")"
root="$(cd "$dir" 2>/dev/null && git rev-parse --show-toplevel 2>/dev/null)"
[ -z "$root" ] && root="${cwd:-$dir}"
cd "$root" 2>/dev/null || exit 0
rel="/${file#"$root"/}"
ext="${file##*.}"

# Dépendances et fichiers générés : aucun contrôle
case "$rel" in
  */node_modules/*|*/.git/*|*/vendor/*|*/dist/*|*/build/*|*/.dart_tool/*) exit 0 ;;
esac

# --- 1. Contrôle de style : tirets longs ------------------------------------------
style_report=""
if [ "${DEVTEAM_STYLE_CHECK:-1}" = "1" ]; then
  case "$rel" in
    */skills/style-equipe/*) ;;  # la skill montre les caractères interdits en exemple
    *)
      case "$ext" in
        md|txt|html|htm|css|scss|js|jsx|ts|tsx|mjs|cjs|vue|svelte|py|dart|go|rs|java|kt|kts|php|rb|sh|bash|yml|yaml|json|sql|xml|arb)
          hits="$(LC_ALL=C grep -nF -e $'\xe2\x80\x94' -e $'\xe2\x80\x93' "$file" 2>/dev/null | head -n 10)"
          if [ -n "$hits" ]; then
            style_report="devteam (skill style-equipe) : tirets longs interdits dans $rel.
Remplace chaque tiret long par une virgule, deux-points, des parenthèses ou un point.
Lignes concernées :
$hits"
          fi
          ;;
      esac
      ;;
  esac
fi

# --- 2. Formatage / lint (pas sur la documentation) --------------------------------
has() { command -v "$1" >/dev/null 2>&1; }
lint_log=""
lint_failed=0
run() {  # exécute sans jamais faire échouer le hook, mémorise la sortie en cas d'échec
  local out
  out="$("$@" 2>&1)" || { lint_failed=1; lint_log="$lint_log
\$ $*
$out"; }
}

case "$rel" in
  /docs/*) ;;
  *)
    case "$ext" in
      js|jsx|ts|tsx|mjs|cjs|vue|svelte|css|scss|json|html)
        [ -x node_modules/.bin/prettier ] && run node_modules/.bin/prettier --write --log-level warn "$file"
        case "$ext" in js|jsx|ts|tsx|mjs|cjs|vue|svelte)
          [ -x node_modules/.bin/eslint ] && run node_modules/.bin/eslint --fix "$file" ;;
        esac
        if [ -x node_modules/.bin/biome ] && { [ -f biome.json ] || [ -f biome.jsonc ]; }; then
          run node_modules/.bin/biome check --write "$file"
        fi
        ;;
      py)
        if has ruff; then run ruff format -q "$file"; run ruff check --fix -q "$file"
        elif has black; then run black -q "$file"
        fi
        ;;
      dart)    has dart && run dart format "$file" ;;
      go)      has gofmt && run gofmt -w "$file" ;;
      rs)      has rustfmt && run rustfmt --edition 2021 "$file" ;;
      kt|kts)  has ktlint && run ktlint -F "$file" ;;
      sh|bash) has shfmt && run shfmt -w "$file" ;;
    esac
    ;;
esac

# --- Retour à Claude -----------------------------------------------------------------
feedback="$style_report"
if [ "$lint_failed" -eq 1 ] && [ "${DEVTEAM_LINT_FEEDBACK:-0}" = "1" ]; then
  feedback="$feedback
devteam : le linter signale des problèmes dans $rel :$lint_log"
fi

if [ -n "$feedback" ]; then
  printf '%s\n' "$feedback" >&2
  exit 2
fi
exit 0
