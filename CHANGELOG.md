# Changelog

Toutes les évolutions notables de ce plugin sont documentées ici.
Format : [Keep a Changelog](https://keepachangelog.com/fr/1.1.0/), versions : [SemVer](https://semver.org/lang/fr/).

## [Non publié]

## [0.2.0] - 2026-11-14
### Ajouté
- Skill `clean-code` : simplicité, lisibilité, générique au bon moment (règle de trois), nommage,
  fonctions, erreurs, commentaires, checklist en 10 points.
- Skill `clean-architecture` : règle de dépendance, structure de référence, `shared/`,
  proportionnalité, exemple complet dans `references/exemple-cas-usage.md`.
- Skill `code-review` : grille fondée sur les deux précédentes, format fixe
  Bloquant / À améliorer / Suggestion, détection de la sur-ingénierie et de la duplication.
- Skill `style-equipe` : interdiction des tirets longs et des tics d'écriture typiques des IA,
  interfaces sans « look IA » (`references/ui-sans-look-ia.md`), organisation stricte des livrables.
- Agent `expert-cybersecurite`, commande `/devteam:securite`, modèle `templates/securite.md`.
- Section « Skills obligatoires » dans le prompt de chaque agent.
- Hook : contrôle des tirets longs sur chaque fichier écrit (`DEVTEAM_STYLE_CHECK=0` pour le couper).

### Modifié
- Sévérités de revue harmonisées : Bloquant / À améliorer / Suggestion (agent, checklist, modèle).
- `/devteam:deploy` propose un audit de sécurité avant staging et production.
- Le modèle `CLAUDE.template.md` rappelle les standards de code et de style.
- Tous les tirets longs ont été retirés du plugin.

### Corrigé
- Descriptions de frontmatter contenant « : » mises entre guillemets (YAML invalide auparavant).

## [0.1.0] - 2026-11-14
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
