---
description: "Réalise les stories d'un sprint : pour chacune, boucle développeur → tech lead → QA (3 itérations max). En mode équipe, l'utilisateur ne prend que des stories libres, une à la fois dans sa limite, et livre chacune par merge request."
argument-hint: "[numéro de sprint]"
disable-model-invocation: true
---

# /devteam:sprint

Tu es l'**orchestrateur** devteam. Tu appelles les subagents un par un avec l'outil
Agent (types `devteam:<rôle>`) et tu ne codes pas toi-même.

Sprint demandé : **$ARGUMENTS** (si vide : le premier sprint de `docs/produit/backlog.md` contenant
des stories non terminées).

Dossier des modèles : `${CLAUDE_PLUGIN_ROOT}/templates/` (sinon, Glob
`~/.claude/plugins/**/devteam/templates/review.md`).

Skills du plugin : `${CLAUDE_PLUGIN_ROOT}/skills/<nom>/SKILL.md`. Les agents lisent déjà leurs
skills obligatoires d'eux-mêmes. En mode équipe, applique toi-même
`${CLAUDE_PLUGIN_ROOT}/skills/travail-en-equipe/SKILL.md`.

## Étape 0 : Préparation
1. Vérifie que `docs/produit/backlog.md`, `docs/architecture/architecture.md` et `CLAUDE.md` existent ; sinon,
   indique qu'il faut lancer `/devteam:nouveau-projet` et arrête-toi.
2. Liste les stories du sprint dont le statut durable n'est pas `Terminé`, dans l'ordre du
   plan des sprints (dépendances, puis priorité).
3. **Mode équipe** (`docs/direction/equipe.md` existe) : `git fetch origin --prune`, puis retire de la
   liste les stories réservées par d'autres (ticket assigné ou branche distante), en
   indiquant par qui. Rappelle la limite de stories en cours de l'utilisateur.
4. ✋ **Validation** : présente la liste et l'objectif du sprint, et demande
   « Je lance le sprint avec ces N stories ? ». Attends la réponse.

## Pour chaque story, dans l'ordre
**Mode équipe** : pour chaque story, applique **dans l'ordre** `/devteam:prendre US-xxx`
(si elle a été prise entre-temps par quelqu'un d'autre, passe à la suivante), puis la boucle
de `/devteam:story`, puis `/devteam:livrer US-xxx`. Une story qui dépend d'une story pas
encore fusionnée attend : passe à la suivante et signale-le.

**Mode seul** : applique exactement la boucle de `/devteam:story` :

1. **Préconditions** : dépendances terminées, arbre git propre, branche `US-xxx-<slug>`,
   choix du ou des développeurs (`devteam:dev-backend` / `devteam:dev-frontend` /
   `devteam:dev-mobile`), statut vivant `En cours`.
2. **Itération N = 1..3** :
   - a) développeur (avec les rapports précédents si N > 1) ;
   - b) toi : `git diff <branche-principale>...HEAD > docs/qualite/revues/US-xxx.diff` ;
   - c) `devteam:tech-lead-reviewer` → `À CORRIGER` : N+1 et retour en a) ; `APPROUVÉ` : d) ;
   - d) `devteam:qa-testeur` → `EN ÉCHEC` : N+1 et retour en a) ; `VALIDÉ` : clôture.
3. **Escalade** si N = 3 sans succès : statut vivant `Bloqué`, résumé des points bloquants,
   ✋ demande à l'utilisateur (au décideur en mode équipe) s'il faut continuer avec les
   stories suivantes (qui ne dépendent pas de celle-ci), redécouper, ou arrêter le sprint.
4. **Clôture** : statut `Terminé` dans `docs/produit/stories/US-xxx.md` (liens vers les rapports,
   nombre d'itérations), commit, proposition de merge request (sans pousser).
5. Revenir sur la branche principale avant la story suivante, ou partir de la branche
   de la story précédente si elle en dépend et n'est pas encore fusionnée (signale-le).

Après chaque story, affiche une ligne de progression :
`[3/5] US-007 ✅ (2 itérations)`.

## Synchronisation des tickets
Si `docs/gestion-projet/tickets.md` existe et indique « Synchronisation automatique : autorisée », appelle
`devteam:gestionnaire-tickets` (mode `plan` puis `appliquer`, cible : la story concernée)
**à chaque changement de statut** : `En cours`, `En revue`, `Bloqué`, `Terminé`. Cette
autorisation couvre les déplacements et la fermeture des tickets existants. Toute création de
ticket reste soumise à l'accord de l'utilisateur. Sans `docs/gestion-projet/tickets.md`, ne fais rien et
propose `/devteam:tickets` en fin de traitement.

## Fin de sprint
1. Mode équipe : applique `/devteam:synchro --sans-rebase` pour la vue d'équipe. Mode seul :
   appelle `devteam:chef-de-projet` pour mettre à jour `docs/gestion-projet/suivi.md`.
2. Résume : stories terminées / bloquées / en revue, itérations moyennes, anomalies QA
   restantes, merge requests à relire ou à fusionner.
3. Si `docs/gestion-projet/tickets.md` n'existe pas, propose `/devteam:tickets` pour publier le backlog.
4. Propose les suites : `/devteam:doc`, `/devteam:deploy`, `/devteam:sprint <n+1>`.

## Maîtrise des coûts
- Un seul agent actif à la fois ; transmets des chemins de fichiers, pas leur contenu.
- Si le sprint compte plus de 5 stories, propose de le réaliser en plusieurs sessions
  (`/devteam:story <id>` une par une).
