---
description: "Active ou gère le mode équipe (plusieurs personnes sur le même dépôt) : initialisation, ajout d'un membre, migration d'un ancien backlog en un fichier par story."
argument-hint: "[initialiser | ajouter <nom> | migrer]"
disable-model-invocation: true
---

# /devteam:equipe

Tu es l'orchestrateur devteam. Lis et applique `${CLAUDE_PLUGIN_ROOT}/skills/travail-en-equipe/SKILL.md`.

Demande : **$ARGUMENTS** (si vide : `initialiser` si `docs/equipe.md` n'existe pas, sinon
affiche la composition de l'équipe et les commandes utiles).

Modèles : `${CLAUDE_PLUGIN_ROOT}/templates/equipe.md`, `story.md`, `backlog.md`,
`gitattributes`, `CODEOWNERS`, `decisions-ceo.md`, `tickets.md`.

## `initialiser`
1. Vérifie que le dépôt a un `origin` (`git remote get-url origin`). Sinon, explique qu'il faut
   d'abord un dépôt partagé sur GitHub ou GitLab et arrête-toi.
2. `git fetch origin`, puis crée la branche `mode-equipe` depuis `origin/<principale>`.
3. ✋ Demande à l'utilisateur, en une fois : les membres (nom, e-mail git, identifiant
   GitHub ou GitLab, rôles, droit de fusion), le décideur, la limite de stories en cours par
   personne (2 par défaut). Propose l'utilisateur courant (`git config user.name` et
   `user.email`) comme premier membre.
4. Crée `docs/equipe.md` (modèle), `.gitattributes` (contenu du modèle `gitattributes`, ajouté
   à un fichier existant sans doublon) et `CODEOWNERS` à la racine (modèle, identifiants
   remplacés).
5. Ajoute `docs/suivi.md`, `docs/etat-equipe.md` et `docs/reviews/*-mr.md` au `.gitignore` (le suivi devient une vue
   calculée à la demande).
6. Si l'ancien format est détecté (stories détaillées dans `docs/backlog.md`, pas de
   `docs/stories/`), exécute **`migrer`** sur la même branche.
7. Committe (`Activation du mode équipe`), puis ✋ demande l'accord pour pousser la branche et
   ouvrir la merge request (commandes de `references/commandes.md`). Le mode équipe est actif
   pour tous **après la fusion**.
8. Rappelle à l'administrateur du dépôt la protection de la branche principale
   (`references/commandes.md`, dernière section) : rien ne doit pouvoir être poussé directement
   sur `main`.

## `ajouter <nom>`
Sur une branche `equipe-ajout-<slug>` : ajoute la ligne du membre dans `docs/equipe.md` (et dans
`CODEOWNERS` si son rôle l'exige), committe, puis propose la merge request.

## `migrer` (ancien backlog vers un fichier par story)
1. Pour chaque story de `docs/backlog.md`, crée `docs/stories/US-xxx.md` (modèle `story.md`) :
   contenu, critères, estimation, dépendances, règles, ticket, notes dev, liens revue et QA.
   Statut durable : `Terminé` si la story l'était, `Won't` si elle l'était, sinon `À faire`
   (les statuts vivants partent sur les tickets).
2. Réécris `docs/backlog.md` au format index (modèle `backlog.md`) : MVP, plan des sprints,
   table des stories avec priorité et sprint. Aucun contenu de story ne doit être perdu :
   compare le nombre de stories et de critères avant et après.
3. Convertis `docs/decisions-ceo.md` au format « ajout seul » : supprime le tableau de résumé,
   garde chaque bloc, ajoute aux anciens identifiants `D-001` l'équivalent daté
   (`D-001 (D-AAAAMMJJ-0000-XX)`) sans casser les références existantes.
4. Déplace les rapports `docs/rapports-coo/*.md` dans `docs/rapports-coo/<auteur>/`.
5. Si `docs/tickets.md` existe : retire la colonne « Statut synchronisé » et l'en-tête
   « Dernière synchronisation ».
6. Montre le bilan (fichiers créés, stories migrées, contrôle de complétude) avant le commit
   `Migration vers un fichier par story`.
