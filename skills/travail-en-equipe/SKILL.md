---
name: travail-en-equipe
description: "Règles de collaboration quand plusieurs personnes (et leurs sessions devteam) travaillent sur le même dépôt : qui écrit quel fichier, réservation des stories, synchronisation, livraison par merge request, décisions. À utiliser avant de prendre, réaliser ou livrer une story, et avant de modifier un fichier partagé de docs/."
---

# Travailler à plusieurs sur le même dépôt

Principe : **chacun travaille sur sa branche, dans ses fichiers, et tout ce qui est partagé
passe par une merge request**. Ce qui change en permanence (qui fait quoi) vit sur la
plateforme de tickets, pas dans git.

## 1. Mode équipe et identité
- Le mode équipe est actif si `docs/equipe.md` existe (modèle `templates/equipe.md`).
- **Qui suis-je** : `git config user.email`, rapproché de la table des membres de
  `docs/equipe.md`. Inconnu : demander à l'utilisateur de s'ajouter (`/devteam:equipe ajouter`)
  avant toute réservation.
- `docs/equipe.md` désigne le **décideur** (le CEO du mode COO), les personnes autorisées à
  fusionner, la limite de stories en cours par personne (2 par défaut) et la branche
  principale.

## 2. Organisation des fichiers : chacun ses fichiers

| Fichier | Contenu | Qui l'écrit | Risque de conflit |
|---|---|---|---|
| `docs/stories/US-xxx.md` | Une story : contenu, critères, statut durable, ticket, notes | BA (création), le développeur responsable (sur sa branche) | aucun : un fichier par story |
| `docs/backlog.md` | Index : MVP, plan des sprints, priorités, sprint de chaque story | PO uniquement, par merge request | faible |
| `docs/specs.md`, `docs/architecture.md`, `docs/adr/` | Cadrage et conception | BA, architecte, par merge request relue par le décideur | faible |
| `docs/reviews/US-xxx.md`, `docs/qa/US-xxx.md` | Rapports d'une story | agents, sur la branche de la story | aucun |
| `docs/decisions-ceo.md` | Journal des décisions, ajout en fin de fichier uniquement | COO | aucun (`merge=union`) |
| `docs/rapports-coo/<auteur>/…` | Rapports du COO de chaque personne | COO de la personne | aucun |
| `docs/tickets.md` | Configuration et correspondance story / ticket, ajout uniquement | gestionnaire des tickets | aucun (`merge=union`) |
| `docs/suivi.md` | Point d'avancement | chef de projet, **non versionné** en mode équipe | aucun |

Règles :
- Ne jamais réécrire un fichier dont on n'est pas l'auteur désigné : demander à son
  propriétaire (passer par sa merge request ou un commentaire).
- Les journaux (`decisions-ceo.md`, `tickets.md`) ne s'écrivent **qu'en ajoutant** des lignes
  ou des blocs à la fin. `.gitattributes` les fusionne sans conflit (`merge=union`).
- Les identifiants créés à plusieurs sont uniques par construction : décisions
  `D-AAAAMMJJ-HHMM-<initiales>`. Les numéros de story `US-xxx` ne sont attribués que par le BA,
  dans une seule merge request à la fois.

## 3. Statut d'une story : durable ou vivant
- **Statut durable**, dans `docs/stories/US-xxx.md` sur `main` : `À faire`, `Terminé`,
  `Won't`. Il ne change que par une merge request ; la story passe à `Terminé` **dans la merge
  request qui livre le code**, donc au moment exact de la fusion.
- **Statut vivant** : `En cours`, `En revue`, `Bloqué`, et le responsable. Il vit :
  - sur la **plateforme de tickets** si `docs/tickets.md` existe (label `statut::…` et personne
    assignée) : visible par tous en temps réel ;
  - sinon, dans l'**existence de la branche** `US-xxx-…` sur `origin` (en cours) et d'une merge
    request ouverte (en revue), et dans le fichier de la story **sur sa branche**.

## 4. Réserver une story (`/devteam:prendre`)
1. `git fetch origin --prune`, puis partir de `origin/<principale>` à jour.
2. Choisir la story : celle demandée, sinon la première du sprint courant (ordre de
   `docs/backlog.md`), statut durable `À faire`, dépendances `Terminé` sur `main`, et **libre**.
3. **Libre** signifie : aucune personne assignée sur son ticket, et aucune branche distante
   `US-xxx-*` (`git ls-remote --heads origin "US-xxx-*"`).
4. Respecter la limite de stories en cours de la personne (tickets assignés `statut::en-cours`
   ou branches dont elle est l'autrice).
5. Réserver, dans cet ordre :
   - créer la branche `US-xxx-<slug>` depuis `origin/<principale>` ;
   - committer la **réservation** : dans `docs/stories/US-xxx.md`, `Responsable : <nom>` et
     (sans tickets) `Statut : En cours`, message `Réservation de US-xxx par <nom>`. Ce commit
     est propre à la personne : c'est lui qui rend la réservation exclusive ;
   - pousser **sans forcer** (`git push -u origin US-xxx-<slug>`). Si git refuse la poussée
     (la branche existe déjà avec un autre commit), la story vient d'être prise : abandonner ;
   - assigner le ticket à soi-même et le passer en `statut::en-cours`.
6. **Vérifier la course** : relancer `git ls-remote --heads origin "US-xxx-*"`. S'il existe une
   autre branche pour la même story (autre slug), la réservation dont le commit est le plus
   ancien gagne : l'autre personne supprime sa branche distante, se désassigne et en choisit
   une autre.

La personne qui lance `/devteam:prendre` (ou dit « je prends la suivante ») autorise ces
actions : commit et poussée de sa branche de réservation, assignation de son propre ticket.

## 5. Pendant le travail
- Travailler uniquement sur sa branche. Ne jamais committer sur `main` (le hook le refuse en
  mode équipe).
- Se resynchroniser au moins une fois par jour et avant de livrer :
  `git fetch origin && git rebase origin/<principale>`. En cas de conflit sur un fichier dont on
  n'est pas propriétaire, garder **la version de `main`** et prévenir son propriétaire.
- Une story bloquée : `statut::bloque` + commentaire sur le ticket (ou ligne « Bloqué : … » dans
  le fichier de la story sur la branche), puis prévenir le décideur via le COO.

## 6. Livrer une story (`/devteam:livrer`)
Préconditions : revue `APPROUVÉ` et QA `VALIDÉ` dans `docs/reviews/` et `docs/qa/`.
1. `git fetch origin && git rebase origin/<principale>`, puis relancer **toute** la suite de tests.
2. Dans `docs/stories/US-xxx.md` : statut `Terminé`, liens vers les rapports, nombre
   d'itérations. Commit sur la branche.
3. Après accord de l'utilisateur : `git push --force-with-lease` (jamais `--force`) de **sa**
   branche, puis ouverture de la merge request vers la branche principale, avec :
   titre et description de la skill `conventions-git`, `Closes #n`, un **relecteur humain**
   choisi dans `docs/equipe.md` (autre personne que l'auteur, la moins chargée).
4. Ticket en `statut::en-revue`.
5. La fusion est faite par une personne autorisée, après approbation d'un humain. Le ticket se
   ferme à la fusion (`Closes #n`).

Commandes exactes : [references/commandes.md](references/commandes.md).

## 7. Décisions à plusieurs
- Seul le **décideur** tranche les décisions de niveau CEO (stack, périmètre, compromis,
  production, dépenses).
- Le COO d'une autre personne **prépare** la décision : bloc ajouté à `docs/decisions-ceo.md`
  avec le statut `Proposée`, et question posée au décideur (commentaire sur le ticket ou la
  merge request, ou message direct de la personne).
- La réponse du décideur est ajoutée comme un nouveau bloc `Décidée` (ou `Refusée`) qui
  référence l'identifiant de la proposition. On ne modifie jamais un bloc existant.

## 8. Vue d'équipe (`/devteam:synchro`)
Calculée à la demande, jamais versionnée :
- qui fait quoi (tickets assignés ou branches `US-*` et leurs auteurs) ;
- merge requests en attente de relecture, et qui doit relire ;
- stories bloquées, stories libres prêtes à prendre ;
- conflits probables : fichiers modifiés par deux branches ouvertes
  (`git diff --name-only origin/<principale>...origin/<branche>` croisés).

## Checklist
1. [ ] Je suis identifié dans `docs/equipe.md`.
2. [ ] Je pars d'une branche à jour et je ne committe jamais sur `main`.
3. [ ] La story est réservée (branche distante, ticket assigné) avant tout code.
4. [ ] Je n'écris que les fichiers dont je suis l'auteur désigné.
5. [ ] Je me resynchronise avant de livrer et je relance tous les tests.
6. [ ] La livraison passe par une merge request relue par un autre humain.
