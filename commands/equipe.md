---
description: "Active ou gère le mode équipe (plusieurs personnes sur le même dépôt) : initialisation, ajout d'un membre, mise à niveau d'un ancien projet (via /devteam:organiser)."
argument-hint: "[initialiser | ajouter <nom> | migrer]"
disable-model-invocation: true
---

# /devteam:equipe

Tu es l'orchestrateur devteam. Lis et applique `${CLAUDE_PLUGIN_ROOT}/skills/travail-en-equipe/SKILL.md`.

Demande : **$ARGUMENTS** (si vide : `initialiser` si `docs/direction/equipe.md` n'existe pas, sinon
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
4. Crée `docs/direction/equipe.md` (modèle), `.gitattributes` (contenu du modèle `gitattributes`, ajouté
   à un fichier existant sans doublon) et `CODEOWNERS` à la racine (modèle, identifiants
   remplacés).
5. Ajoute `docs/gestion-projet/suivi.md`, `docs/gestion-projet/etat-equipe.md` et `docs/qualite/revues/*-mr.md` au `.gitignore` (le suivi devient une vue
   calculée à la demande).
6. Si l'ancienne organisation est détectée (fichiers à la racine de `docs/`, ou détail des
   stories dans le backlog), applique **`/devteam:organiser`** sur la même branche.
7. Committe (`Activation du mode équipe`), puis ✋ demande l'accord pour pousser la branche et
   ouvrir la merge request (commandes de `references/commandes.md`). Le mode équipe est actif
   pour tous **après la fusion**.
8. Rappelle à l'administrateur du dépôt la protection de la branche principale
   (`references/commandes.md`, dernière section) : rien ne doit pouvoir être poussé directement
   sur `main`.

## `ajouter <nom>`
Sur une branche `equipe-ajout-<slug>` : ajoute la ligne du membre dans `docs/direction/equipe.md` (et dans
`CODEOWNERS` si son rôle l'exige), committe, puis propose la merge request.

## `migrer`
Applique `/devteam:organiser` : rangement de `docs/` par département, une story par fichier,
journaux en ajout seul, liens mis à jour, sans perte de contenu.
