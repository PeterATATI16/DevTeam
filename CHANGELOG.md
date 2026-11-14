# Changelog

Toutes les évolutions notables de ce plugin sont documentées ici.
Format : [Keep a Changelog](https://keepachangelog.com/fr/1.1.0/) — versions : [SemVer](https://semver.org/lang/fr/).

## [Non publié]

## [0.1.0] — 2026-11-14
### Ajouté
- 12 agents : business-analyst, product-owner, architecte, ux-ui-designer, dev-backend,
  dev-frontend, dev-mobile, tech-lead-reviewer, qa-testeur, devops, redacteur-technique,
  chef-de-projet.
- 9 commandes : `nouveau-projet`, `sprint`, `story`, `review`, `tests`, `deploy`, `doc`,
  `statut`, `aide`, avec points de validation humaine et boucle dev → revue → QA limitée
  à 3 itérations.
- 5 skills : redaction-user-story, code-review-checklist, plan-de-test, conventions-git, adr.
- Hook `PostToolUse` de formatage/lint automatique, non bloquant et portable.
- Modèles de la mémoire partagée : specs, backlog, architecture, ADR, revue, QA, suivi, CLAUDE.md.
- Manifeste `plugin.json` et `marketplace.json` pour l'installation via git.
