# Documentation du projet

Ce dossier est la mémoire partagée de l'équipe devteam. Il est **rangé par département**.
Aucun fichier ne se dépose à la racine de `docs/`, à part ce plan de classement.

```
docs/
├── README.md              plan de classement (ce fichier)
├── direction/             décisions et pilotage par le COO
│   ├── decisions-ceo.md   journal des décisions du CEO (ajout seul)
│   ├── equipe.md          mode équipe : membres, décideur, règles
│   └── rapports-coo/      rapports du COO, un dossier par personne
├── gestion-projet/        avancement et tickets
│   ├── suivi.md           point d'avancement (chef de projet)
│   ├── etat-equipe.md     vue d'équipe calculée (non versionnée)
│   ├── tickets.md         plateforme et correspondance story / ticket (ajout seul)
│   └── tickets/           corps des tickets
├── produit/               ce qu'on construit
│   ├── specs.md           cahier des charges (business analyst)
│   ├── backlog.md         index : MVP, sprints, priorités (product owner)
│   └── stories/           une user story par fichier
├── architecture/          comment on le construit
│   ├── architecture.md    stack, structure, données, API (architecte)
│   └── adr/               décisions d'architecture
├── design/                à quoi ça ressemble
│   └── maquettes/         parcours, écrans, design system
├── qualite/               preuves de qualité
│   ├── revues/            rapports de revue de code (tech lead)
│   └── qa/                rapports de test (QA)
├── securite/              audits de sécurité (expert cybersécurité)
├── exploitation/          mise en service
│   └── deploiement.md     procédure, variables, retour arrière (DevOps)
└── documentation/         documentation de référence
    └── api.md             documentation de l'API (rédacteur technique)
```

| Département | Propriétaires | Lecteurs principaux |
|---|---|---|
| `direction/` | COO, décideur | toute l'équipe |
| `gestion-projet/` | chef de projet, gestionnaire des tickets | toute l'équipe |
| `produit/` | business analyst, product owner | architecte, designer, développeurs, QA |
| `architecture/` | architecte | développeurs, DevOps, sécurité |
| `design/` | designer UX/UI | développeurs frontend et mobile |
| `qualite/` | tech lead, QA | développeurs, décideur |
| `securite/` | expert cybersécurité | développeurs, DevOps, décideur |
| `exploitation/` | DevOps | décideur, exploitants |
| `documentation/` | rédacteur technique | utilisateurs de l'API, nouveaux arrivants |
