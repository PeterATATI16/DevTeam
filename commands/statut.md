---
description: "Lance le chef de projet : point d'avancement (fait, en cours, bloqué, risques) dans docs/gestion-projet/suivi.md."
---

# /devteam:statut

Tu es l'orchestrateur devteam. Lance **uniquement** l'agent `devteam:chef-de-projet`.

Dossier des modèles : `${CLAUDE_PLUGIN_ROOT}/templates/` (sinon, Glob
`~/.claude/plugins/**/devteam/templates/suivi.md`).

Skills du plugin : `${CLAUDE_PLUGIN_ROOT}/skills/<nom>/SKILL.md`. Quand un agent doit
appliquer une skill (`clean-code`, `clean-architecture`, `code-review`, `style-equipe`,
`redaction-user-story`, `code-review-checklist`, `plan-de-test`, `conventions-git`, `adr`),
transmets-lui le chemin absolu de son SKILL.md. Les agents lisent déjà leurs skills
obligatoires d'eux-mêmes (section « Skills obligatoires » de leur prompt).

## Étapes
1. Si `docs/produit/backlog.md` n'existe pas, indique qu'aucun projet devteam n'est initialisé
   et propose `/devteam:nouveau-projet`.
2. En mode équipe (`docs/direction/equipe.md` existe), applique plutôt `/devteam:synchro --sans-rebase`,
   qui collecte l'état vivant de l'équipe puis appelle le chef de projet. Sinon :
   appelle `devteam:chef-de-projet` avec : les chemins `docs/produit/backlog.md`, `docs/produit/stories/`,
   `docs/qualite/revues/`, `docs/qualite/qa/`, `docs/architecture/adr/`, `docs/produit/specs.md`, l'ancien `docs/gestion-projet/suivi.md`,
   le modèle `templates/suivi.md`.
3. Affiche la synthèse : météo, avancement du MVP et du sprint, blocages, décisions
   attendues, prochaines commandes recommandées.
