#!/usr/bin/env bash
# devteam : hook PreToolUse (Bash)
#
# Bloque, avant exécution, les commandes git contraires à la skill conventions-git :
#   - commit contenant une ligne d'attribution (Co-Authored-By, « Generated with »)
#     ou une mention de Claude ;
#   - commit dont le résumé commence par un préfixe de type (feat:, fix(x):, docs: …) ;
#   - création de branche préfixée par un type (feat/, feature/, fix/, docs/ …) ;
#   - en mode équipe (docs/equipe.md présent) : commit ou push sur la branche principale.
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
  cwd="$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null)"
elif command -v python3 >/dev/null 2>&1 || command -v python >/dev/null 2>&1; then
  py="$(command -v python3 || command -v python)"
  cmd="$(printf '%s' "$input" | "$py" -c "import json,sys
try: print(json.load(sys.stdin).get('tool_input',{}).get('command',''))
except Exception: pass" 2>/dev/null)"
  cwd="$(printf '%s' "$input" | "$py" -c "import json,sys
try: print(json.load(sys.stdin).get('cwd',''))
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
# Les corps de heredoc sont retirés : un script ou un fichier écrit par la commande peut citer
# « git checkout -b feature/… » sans que la commande elle-même crée une branche.
cmd_hors_heredoc="$cmd"
if command -v perl >/dev/null 2>&1; then
  cmd_hors_heredoc="$(DEVTEAM_CMD="$cmd" perl -0777 -e '
    my $c = $ENV{DEVTEAM_CMD};
    $c =~ s/(<<-?\s*[\x27"]?(\w+)[\x27"]?[^\n]*\n).*?\n\s*\2\s*(?=\n|$)/$1/gs;
    print $c;' 2>/dev/null)"
fi
if printf '%s' "$cmd_hors_heredoc" | grep -Eq "(checkout[[:space:]]+(-b|-B)|switch[[:space:]]+(-c|-C|--create)|branch([[:space:]]+-[a-zA-Z]+)*|worktree[[:space:]]+add.*[[:space:]]-b)[[:space:]]+[\"']?($TYPES)/"; then
  ajouter "Nom de branche préfixé par un type. Utilise l'identifiant traité : US-012-declaration-sinistre, QA-02-taille-photo, cadrage-initial."
fi

# --- Commit ---------------------------------------------------------------------------
if printf '%s' "$cmd" | grep -Eq '(^|[[:space:];&|(])git([[:space:]]+-[cC][[:space:]]+[^[:space:]]+)*[[:space:]]+commit([[:space:]]|$)'; then
  # On n'examine que le message du commit, pas le reste de la ligne de commande (sinon un
  # « claude -p » ou un chemin cité ailleurs dans la même commande serait pris pour le message).
  # Message : arguments de -m / --message, corps des heredocs, contenu du fichier -F.
  if command -v perl >/dev/null 2>&1; then
    texte="$(DEVTEAM_CMD="$cmd" perl -0777 -e '
      my $c = $ENV{DEVTEAM_CMD};
      $c =~ /\bgit\b[^\n;&|]*?\bcommit\b/ or exit 0;
      my $s = substr($c, $-[0]);
      while ($s =~ /(?:-m|--message)(?:=|\s+)(?:"((?:[^"\\]|\\.)*)"|\x27([^\x27]*)\x27|(\S+))/gs) {
        print((defined $1 ? $1 : defined $2 ? $2 : $3), "\n");
      }
      while ($s =~ /<<-?\s*[\x27"]?(\w+)[\x27"]?[^\n]*\n(.*?)\n\s*\1\s*(?:\n|$)/gs) { print "$2\n"; }
    ' 2>/dev/null)"
  else
    texte="$cmd"  # sans perl : examen de toute la commande (plus prudent, parfois trop strict)
  fi
  # Message fourni par fichier (-F chemin ou --file=chemin)
  fichier="$(printf '%s' "$cmd" | sed -nE "s/.*(-F|--file)[= ]+[\"']?([^\"' ]+).*/\2/p" | head -n1)"
  if [ -n "$fichier" ] && [ "$fichier" != "-" ] && [ -f "$fichier" ]; then
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

# --- Mode équipe : rien directement sur la branche principale ------------------------
# Dépôt visé : chemin de « git -C <chemin> » s'il est donné, sinon le cwd de la session.
depot="$(printf '%s' "$cmd" | sed -nE "s/.*git[[:space:]]+-C[[:space:]]+[\"']?([^\"' ]+).*/\1/p" | head -n1)"
[ -z "$depot" ] && depot="${cwd:-.}"
racine="$(git -C "$depot" rev-parse --show-toplevel 2>/dev/null)"
if [ -n "$racine" ] && [ -f "$racine/docs/equipe.md" ]; then
  principale="$(sed -nE 's/^\| *Branche principale *\| *`?([^`| ]+)`? *\|.*/\1/p' "$racine/docs/equipe.md" | head -n1)"
  [ -z "$principale" ] && principale="main"
  courante="$(git -C "$depot" branch --show-current 2>/dev/null)"
  # Commande composée qui change de branche avant d'agir (git switch -c US-012-… && git commit) :
  # la branche à considérer est la dernière branche cible de la commande.
  cible="$(printf '%s' "$cmd_hors_heredoc" | grep -Eo '(switch([[:space:]]+(-c|-C|--create))?|checkout([[:space:]]+(-b|-B))?)[[:space:]]+[^-[:space:];&|][^[:space:];&|]*' | tail -n1 | awk '{print $NF}')"
  [ -n "$cible" ] && courante="$cible"
  if printf '%s' "$cmd" | grep -Eq '(^|[[:space:];&|(])git([[:space:]]+-[cC][[:space:]]+[^[:space:]]+)*[[:space:]]+commit([[:space:]]|$)' \
     && [ "$courante" = "$principale" ]; then
    ajouter "Mode équipe : commit interdit sur la branche principale « $principale ». Réserve une story (/devteam:prendre) ou crée une branche, puis livre par merge request."
  fi
  if printf '%s' "$cmd" | grep -Eq "(^|[[:space:];&|(])git([[:space:]]+-[cC][[:space:]]+[^[:space:]]+)*[[:space:]]+push([[:space:]]|$)" \
     && { printf '%s' "$cmd" | grep -Eq "[[:space:]:]$principale([[:space:]]|$)" \
          || { [ "$courante" = "$principale" ] \
               && printf '%s' "$cmd" | grep -Eq 'push([[:space:]]+-[^[:space:]]+)*([[:space:]]+[^-[:space:];&|][^[:space:];&|]*)?[[:space:]]*($|[;&|])'; }; }; then
    ajouter "Mode équipe : push interdit vers la branche principale « $principale ». Pousse ta branche de story et ouvre une merge request (/devteam:livrer)."
  fi
fi

if [ -n "$motifs" ]; then
  printf 'devteam (skill conventions-git) : commande git refusée.%s\nCorrige la commande puis relance-la.\n' "$motifs" >&2
  exit 2
fi
exit 0
