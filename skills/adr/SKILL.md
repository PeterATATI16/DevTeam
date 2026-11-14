---
name: adr
description: "Format et cycle de vie des Architecture Decision Records (ADR) dans docs/adr/. À utiliser pour documenter, remplacer ou relire une décision d'architecture."
---

# Architecture Decision Records (ADR)

## Quand écrire un ADR
Pour toute décision structurante, coûteuse à changer : langage, framework, base de
données, style d'architecture, authentification, hébergement, format d'API, stratégie de
tests, choix d'une bibliothèque centrale.

## Nommage
`docs/adr/NNNN-titre-court-en-kebab-case.md`, numérotation continue sur 4 chiffres
(`0001-choix-postgresql.md`). Un ADR = une décision.

## Format (inspiré de Michael Nygard / MADR)
```markdown
# ADR-0003 : Utiliser PostgreSQL comme base de données principale

- **Statut** : Proposé | Accepté | Déprécié | Remplacé par ADR-00xx
- **Date** : 2026-11-14
- **Décideurs** : architecte, validé par <utilisateur>
- **Stories concernées** : US-001, US-012

## Contexte
Faits et contraintes qui imposent une décision (exigences ENF-xx, volumétrie,
compétences de l'équipe, coûts, réglementation).

## Options envisagées
1. **PostgreSQL** : (+) transactions, JSONB, écosystème ; (-) administration.
2. **MongoDB** : (+) schéma souple ; (-) intégrité relationnelle pour les contrats.
3. **SQLite** : (+) simplicité ; (-) concurrence d'écriture.

## Décision
Nous retenons PostgreSQL 16 parce que …

## Conséquences
- Positives : …
- Négatives / risques : …
- Actions : ajouter le service au docker-compose (devops), migrations via … (dev-backend).
```

## Cycle de vie
- Un ADR **accepté n'est jamais réécrit** : pour changer d'avis, créer un nouvel ADR et
  passer l'ancien à « Remplacé par ADR-00xx ».
- Un ADR passe de « Proposé » à « Accepté » après le point de validation de l'architecture.
- `docs/architecture.md` liste tous les ADR avec leur statut.

## Contrôle qualité
- [ ] Au moins deux options réellement envisagées.
- [ ] Le contexte cite des exigences vérifiables.
- [ ] Les conséquences négatives sont assumées explicitement.
