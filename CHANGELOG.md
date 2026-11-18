# Changelog

Toutes les évolutions notables de ce plugin sont documentées ici.
Format : [Keep a Changelog](https://keepachangelog.com/fr/1.1.0/), versions : [SemVer](https://semver.org/lang/fr/).

## [Non publié]

## [0.6.0] - 2026-11-18
### Ajouté
- **Mode équipe** : plusieurs personnes sur le même dépôt, chacune avec sa session et son COO.
  Activé par `docs/equipe.md` (membres, décideur, limite de stories en cours, branche principale).
- Skill `travail-en-equipe` : propriétaires des fichiers, statut durable et statut vivant,
  réservation, resynchronisation, livraison, décisions à plusieurs, vue d'équipe.
- Commandes `/devteam:equipe` (initialiser, ajouter, migrer), `/devteam:prendre` (réservation
  exclusive par commit poussé sans forcer et ticket assigné), `/devteam:livrer` (tests complets,
  merge request avec relecteur humain), `/devteam:synchro` (qui fait quoi, conflits probables).
- Modèles `equipe.md`, `story.md`, `gitattributes`, `CODEOWNERS`.
- Hook git : en mode équipe, commit et push refusés sur la branche principale.

### Modifié
- **`docs/` rangé par département** : `direction/`, `gestion-projet/`, `produit/`,
  `architecture/`, `design/`, `qualite/`, `securite/`, `exploitation/`, `documentation/`, avec
  un plan de classement `docs/README.md` (modèle `templates/docs-README.md`). Plus aucun fichier
  à la racine de `docs/`. Les rapports de revue passent de `reviews/` à `qualite/revues/`.
- Commande `/devteam:organiser` : range un projet existant (déplacements par `git mv`, une
  story par fichier, journaux en ajout seul, liens mis à jour, contrôle de complétude).
- Une story par fichier (`docs/stories/US-xxx.md`) ; `docs/backlog.md` devient l'index du PO.
  Les anciens projets restent lisibles ; `/devteam:equipe migrer` les convertit.
- Journal des décisions et suivi des tickets en ajout seul, fusionnés sans conflit
  (`merge=union`), identifiants de décision uniques `D-AAAAMMJJ-HHMM-<initiales>`.
- Rapports du COO rangés par auteur (`docs/rapports-coo/<auteur>/`).
- `story` et `sprint` gèrent la réservation et la livraison en mode équipe ; le COO identifie
  son interlocuteur et fait proposer les décisions au décideur.
- La synchronisation des tickets ne fait jamais reculer un statut vivant ni ne change la
  personne assignée.

### Corrigé
- Hook git : il n'examine plus que le message du commit (`-m`, heredoc, fichier `-F`) et non toute
  la ligne de commande ; un `claude -p` ou un chemin cité ailleurs ne déclenche plus de refus.
- Hook git : un script écrit par heredoc qui cite une création de branche préfixée n'est plus pris
  pour une vraie création de branche ; une commande composée qui change de branche avant de
  committer est jugée sur la branche cible.

## [0.5.0] - 2026-11-15
### Ajouté
- Agent `gestionnaire-tickets` et commande `/devteam:tickets` : publication des user stories en
  tickets GitHub (`gh`) ou GitLab (`glab`) selon le dépôt, labels de priorité, périmètre,
  estimation et statut, milestones par sprint, déplacement sur le tableau, fermeture des
  stories terminées. Fonctionnement en deux temps (plan, puis application après accord).
- Skill `gestion-tickets` avec les commandes de référence pour GitHub et GitLab.
- Modèles `templates/tickets.md` (configuration, correspondance, journal) et `templates/ticket.md`.
- Synchronisation des tickets à chaque changement de statut dans `story` et `sprint`, si elle
  est autorisée dans `docs/tickets.md`.
- README : sections « Mettre à jour le plugin » et « Tickets GitHub et GitLab ».

### Modifié
- La version n'est plus déclarée que dans `plugin.json`, comme le recommande la documentation
  des marketplaces.

## [0.4.0] - 2026-11-14
### Modifié
- Skill `conventions-git` réécrite : branches nommées par l'identifiant traité
  (`US-012-declaration-sinistre`), commits en français commençant par un nom d'action,
  sans préfixe de type (`feat:`…) ni ligne d'attribution, sans mention d'IA.
- Agents développeurs, commandes, checklist de revue et modèle `CLAUDE.template.md` alignés
  sur cette convention.

### Ajouté
- Hook `PreToolUse` `controle-git.sh` qui refuse les commits et branches non conformes
  (`DEVTEAM_GIT_CHECK=0` pour le couper).

## [0.3.0] - 2026-11-14
### Ajouté
- Mode CEO : agent `coo`, interlocuteur unique du CEO, prévu pour tourner comme session
  principale (`"agent": "devteam:coo"` dans `.claude/settings.json` ou `claude --agent devteam:coo`).
- Commande `/devteam:coo` pour endosser le rôle dans une session déjà ouverte.
- Rapport COO au format fixe avec bloc « DÉCISION REQUISE », enregistré dans
  `docs/rapports-coo/` (modèle `templates/rapport-coo.md`).
- Journal des décisions du CEO `docs/decisions-ceo.md` (modèle `templates/decisions-ceo.md`).
- README : sections « Mode CEO » et « Feuille de route » (phase 2 : Microsoft Teams, non implémentée).

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
