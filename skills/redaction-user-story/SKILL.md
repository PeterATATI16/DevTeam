---
name: redaction-user-story
description: Rédiger des user stories de qualité (format « En tant que… je veux… afin de… », critères INVEST, critères d'acceptation Given/When/Then). À utiliser pour créer, découper ou relire un backlog.
---

# Rédaction de user stories

## Format
```markdown
### US-012 — Déclarer un sinistre en ligne  `[back][front]`
**En tant que** assuré connecté,
**je veux** déclarer un sinistre automobile en joignant des photos,
**afin de** lancer l'indemnisation sans me déplacer.

**Critères d'acceptation**
1. **Given** un assuré avec un contrat auto actif
   **When** il soumet une déclaration complète (date, lieu, circonstances, ≥ 1 photo)
   **Then** le sinistre est créé au statut « Déclaré » et un numéro SIN-AAAA-NNNNN est affiché.
2. **Given** un contrat résilié à la date du sinistre
   **When** l'assuré soumet la déclaration
   **Then** la déclaration est refusée avec le message « Aucun contrat actif à cette date ».
3. **Given** une photo de plus de 10 Mo
   **When** l'assuré la joint
   **Then** elle est refusée avant envoi avec l'indication de la taille maximale.

**Estimation** : M — **Dépendances** : US-003 — **Règles** : RG-04, RG-05
**Statut** : À faire — **Priorité** : — — **Sprint** : —
```

Tags de périmètre : `[back]`, `[front]`, `[mobile]`, `[devops]` — ils servent à choisir
le développeur.

## Critères INVEST
| Lettre | Critère | Question de contrôle |
|---|---|---|
| I | Indépendante | Peut-elle être livrée sans attendre une autre story non planifiée ? |
| N | Négociable | Décrit-elle un besoin, pas une solution technique figée ? |
| V | Valeur | Un utilisateur ou le métier y gagne-t-il quelque chose de visible ? |
| E | Estimable | L'équipe comprend-elle assez pour estimer ? |
| S | Small (petite) | Tient-elle dans un sprint (S, M ou L ; XL = à découper) ? |
| T | Testable | Chaque critère est-il vérifiable par un test automatisé ou manuel ? |

## Règles pour les critères d'acceptation
- 2 à 6 critères par story, au moins un cas d'erreur ou de limite.
- Valeurs concrètes et chiffrées (« 10 Mo », « 3 tentatives », « en moins de 2 s »).
- Un seul comportement par critère ; pas de « et/ou » ambigu.
- Pas de détail d'implémentation (« bouton bleu », « table SQL ») sauf exigence métier.

## Découper une story trop grosse
Par étape du parcours, par règle de gestion, par type de donnée, par cas nominal puis
cas d'erreur, par opération CRUD, par plateforme (web puis mobile).

## Anti-modèles
- « En tant que développeur, je veux une base de données » → story technique : la
  formuler comme une tâche liée à une story à valeur, ou en story technique explicite `[tech]`.
- « Le système doit être rapide » → exigence non fonctionnelle à chiffrer dans les specs.
- Critères qui reformulent la story sans condition vérifiable.
