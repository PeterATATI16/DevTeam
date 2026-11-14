#!/usr/bin/env bash
# devteam — hook PostToolUse (Edit|Write|MultiEdit)
# Formate / linte le fichier modifié avec l'outil du projet s'il est disponible.
# Portable : Linux, macOS, Windows (Git Bash). Ne bloque jamais : sort toujours en 0,
# sauf si DEVTEAM_LINT_FEEDBACK=1 et que le linter signale des erreurs (code 2 :
# l'erreur est alors transmise à Claude, l'édition reste appliquée).
#
# Variables :
#   DEVTEAM_HOOK_DISABLE=1   désactive complètement le hook
#   DEVTEAM_LINT_FEEDBACK=1  renvoie les erreurs de lint restantes à Claude

[ "${DEVTEAM_HOOK_DISABLE:-0}" = "1" ] && exit 0

input="$(cat 2>/dev/null || true)"

# --- Extraction de tool_input.file_path (jq, sinon python, sinon sed) -------------
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

# Chemins Windows (C:\…) → format Git Bash si possible
case "$file" in
  [A-Za-z]:\\*|[A-Za-z]:/*) command -v cygpath >/dev/null 2>&1 && file="$(cygpath -u "$file")" ;;
esac
[ -f "$file" ] || exit 0

# Racine du projet : dépôt git du fichier, sinon cwd de la session
dir="$(dirname "$file")"
root="$(cd "$dir" 2>/dev/null && git rev-parse --show-toplevel 2>/dev/null)"
[ -z "$root" ] && root="${cwd:-$dir}"
cd "$root" 2>/dev/null || exit 0

# Ignorer docs, dépendances, fichiers générés (chemin relatif à la racine du projet)
rel="/${file#"$root"/}"
case "$rel" in
  */node_modules/*|*/.git/*|*/vendor/*|*/dist/*|*/build/*|*/.dart_tool/*|/docs/*) exit 0 ;;
esac

has() { command -v "$1" >/dev/null 2>&1; }
log=""
status=0
run() {  # exécute sans jamais faire échouer le hook, mémorise la sortie
  local out
  out="$("$@" 2>&1)" || { status=1; log="$log
\$ $*
$out"; }
}

ext="${file##*.}"
case "$ext" in
  js|jsx|ts|tsx|mjs|cjs|vue|svelte|css|scss|json|html)
    if [ -x node_modules/.bin/prettier ]; then run node_modules/.bin/prettier --write --log-level warn "$file"; fi
    case "$ext" in js|jsx|ts|tsx|mjs|cjs|vue|svelte)
      if [ -x node_modules/.bin/eslint ]; then run node_modules/.bin/eslint --fix "$file"; fi ;;
    esac
    if [ -x node_modules/.bin/biome ] && [ -f biome.json -o -f biome.jsonc ]; then run node_modules/.bin/biome check --write "$file"; fi
    ;;
  py)
    if has ruff; then run ruff format -q "$file"; run ruff check --fix -q "$file"
    elif has black; then run black -q "$file"
    fi
    ;;
  dart)
    has dart && run dart format "$file" ;;
  go)
    has gofmt && run gofmt -w "$file" ;;
  rs)
    has rustfmt && run rustfmt --edition 2021 "$file" ;;
  kt|kts)
    has ktlint && run ktlint -F "$file" ;;
  sh|bash)
    has shfmt && run shfmt -w "$file" ;;
  *) exit 0 ;;
esac

if [ "$status" -ne 0 ] && [ "${DEVTEAM_LINT_FEEDBACK:-0}" = "1" ]; then
  printf 'devteam : le linter signale des problèmes dans %s :%s\n' "$file" "$log" >&2
  exit 2
fi
exit 0
