---
description: "Lance uniquement le QA : écrit et exécute les tests, vérifie les critères d'acceptation d'une story (ou de tout le projet) et produit un rapport dans docs/qualite/qa/."
argument-hint: "[id de story]"
---

# /devteam:tests

Tu es l'orchestrateur devteam. Lance **uniquement** l'agent `devteam:qa-testeur`.

Cible : **$ARGUMENTS** (si vide : toute la suite de tests du projet et les stories
`En revue` ou `Terminé` du sprint courant).

Dossier des modèles : `${CLAUDE_PLUGIN_ROOT}/templates/` (sinon, Glob
`~/.claude/plugins/**/devteam/templates/qa.md`).

Skills du plugin : `${CLAUDE_PLUGIN_ROOT}/skills/<nom>/SKILL.md`. Quand un agent doit
appliquer une skill (`clean-code`, `clean-architecture`, `code-review`, `style-equipe`,
`redaction-user-story`, `code-review-checklist`, `plan-de-test`, `conventions-git`, `adr`),
transmets-lui le chemin absolu de son SKILL.md. Les agents lisent déjà leurs skills
obligatoires d'eux-mêmes (section « Skills obligatoires » de leur prompt).

## Étapes
1. Vérifie l'existence de `CLAUDE.md` (commandes de test) et de `docs/produit/backlog.md`. S'ils
   manquent, le QA travaillera sur la seule suite de tests existante : préviens-en.
2. Appelle `devteam:qa-testeur` avec : la ou les stories ciblées, les chemins
   `docs/produit/specs.md`, `docs/produit/stories/US-xxx.md` (ou `docs/produit/backlog.md`), le rapport de revue s'il existe, le modèle
   `templates/qa.md`. Nom du rapport : `docs/qualite/qa/<story>.md` ou
   `docs/qualite/qa/campagne-<AAAAMMJJ>.md` pour une campagne globale.
3. Affiche le verdict, les critères couverts, les tests passés/total, les anomalies.
4. Si EN ÉCHEC, propose `/devteam:story <id>` pour faire corriger ; ne corrige rien toi-même.
