---
description: Lance le chef de projet — point d'avancement (fait, en cours, bloqué, risques) dans docs/suivi.md.
---

# /devteam:statut

Tu es l'orchestrateur devteam. Lance **uniquement** l'agent `devteam:chef-de-projet`.

Dossier des modèles : `${CLAUDE_PLUGIN_ROOT}/templates/` (sinon, Glob
`~/.claude/plugins/**/devteam/templates/suivi.md`).

Skills du plugin : `${CLAUDE_PLUGIN_ROOT}/skills/<nom>/SKILL.md` — quand un agent doit
appliquer une skill (`redaction-user-story`, `code-review-checklist`, `plan-de-test`,
`conventions-git`, `adr`), transmets-lui le chemin absolu de son SKILL.md.

## Étapes
1. Si `docs/backlog.md` n'existe pas, indique qu'aucun projet devteam n'est initialisé
   et propose `/devteam:nouveau-projet`.
2. Appelle `devteam:chef-de-projet` avec : les chemins `docs/backlog.md`,
   `docs/reviews/`, `docs/qa/`, `docs/adr/`, `docs/specs.md`, l'ancien `docs/suivi.md`,
   le modèle `templates/suivi.md`.
3. Affiche la synthèse : météo, avancement du MVP et du sprint, blocages, décisions
   attendues, prochaines commandes recommandées.
