#!/usr/bin/env bash
# devteam : hook PreToolUse (Bash)
#
# Bloque, avant exécution, les commandes git contraires à la skill conventions-git :
#   - commit contenant une ligne d'attribution (Co-Authored-By, « Generated with »)
#     ou une mention de Claude ;
#   - commit dont le résumé commence par un préfixe de type (feat:, fix(x):, docs: …) ;
#   - création de branche préfixée par un type (feat/, feature/, fix/, docs/ …).
# Code 2 : la commande n'est pas exécutée et le motif est renvoyé à Claude, qui corrige.
# Toute autre situation : code 0, la commande s'exécute normalement.
# Portable : Linux, macOS, Windows (Git Bash).
#
# Variables :
#   DEVTEAM_HOOK_DISABLE=1  désactive tous les hooks devteam
#   DEVTEAM_GIT_CHECK=0     désactive ce contrôle

[ "${DEVTEAM_HOOK_DISABLE:-0}" = "1" ] && exit 0
[ "${DEVTEAM_GIT_CHECK:-1}" = "0" ] && exit 0

input="$(cat 2>/dev/null || true)"

# --- Lecture de tool_input.command (jq, sinon python) ------------------------------
if command -v jq >/dev/null 2>&1; then
  cmd="$(printf '%s' "$input" | jq -r '.tool_input.command // empty' 2>/dev/null)"
elif command -v python3 >/dev/null 2>&1 || command -v python >/dev/null 2>&1; then
  py="$(command -v python3 || command -v python)"
  cmd="$(printf '%s' "$input" | "$py" -c "import json,sys
try: print(json.load(sys.stdin).get('tool_input',{}).get('command',''))
except Exception: pass" 2>/dev/null)"
else
  exit 0  # impossible de lire la commande : on ne bloque pas
fi

case "$cmd" in *git*) ;; *) exit 0 ;; esac

TYPES='feat|feature|fix|bugfix|docs|doc|chore|test|tests|ci|refactor|perf|build|style|revert|hotfix'
motifs=""
ajouter() { motifs="$motifs
- $1"; }

# --- Création de branche --------------------------------------------------------------
if printf '%s' "$cmd" | grep -Eq "(checkout[[:space:]]+(-b|-B)|switch[[:space:]]+(-c|-C|--create)|branch([[:space:]]+-[a-zA-Z]+)*|worktree[[:space:]]+add.*[[:space:]]-b)[[:space:]]+[\"']?($TYPES)/"; then
  ajouter "Nom de branche préfixé par un type. Utilise l'identifiant traité : US-012-declaration-sinistre, QA-02-taille-photo, cadrage-initial."
fi

# --- Commit ---------------------------------------------------------------------------
if printf '%s' "$cmd" | grep -Eq '(^|[[:space:];&|(])git([[:space:]]+-[cC][[:space:]]+[^[:space:]]+)*[[:space:]]+commit([[:space:]]|$)'; then
  texte="$cmd"
  # Message fourni par fichier (-F chemin ou --file=chemin)
  fichier="$(printf '%s' "$cmd" | sed -nE "s/.*(-F|--file)[= ]+[\"']?([^\"' ]+).*/\2/p" | head -n1)"
  if [ -n "$fichier" ] && [ -f "$fichier" ]; then
    texte="$texte
$(cat "$fichier" 2>/dev/null)"
  fi

  if printf '%s' "$texte" | grep -Eiq 'co-authored-by|generated with'; then
    ajouter "Ligne d'attribution interdite (Co-Authored-By, « Generated with »). Supprime-la."
  fi
  # « claude » comme mot, sans compter les chemins (/claude-501/, plugins/claude…)
  if printf '%s' "$texte" | grep -Eiq '(^|[^[:alnum:]/_.-])(claude|anthropic)([^[:alnum:]/_.-]|$)'; then
    ajouter "Mention de Claude ou d'Anthropic interdite dans un message de commit."
  fi
  # Préfixe de type : après -m, ou en début de ligne (heredoc, fichier)
  if printf '%s' "$texte" | grep -Eq "(-m[[:space:]]*[\"']?|^[[:space:]]*)($TYPES)(\([^)]*\))?!?:[[:space:]]"; then
    ajouter "Préfixe de type interdit (feat:, fix:, docs: …). Commence le résumé par un nom d'action en français : « Ajout de … », « Correction de … »."
  fi
fi

if [ -n "$motifs" ]; then
  printf 'devteam (skill conventions-git) : commande git refusée.%s\nCorrige la commande puis relance-la.\n' "$motifs" >&2
  exit 2
fi
exit 0
