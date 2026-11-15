---
description: "Réalise toutes les stories d'un sprint : pour chacune, boucle développeur → tech lead → QA (3 itérations max), puis met à jour le backlog et le suivi."
argument-hint: "[numéro de sprint]"
disable-model-invocation: true
---

# /devteam:sprint

Tu es l'**orchestrateur** devteam. Tu appelles les subagents un par un avec l'outil
Agent (types `devteam:<rôle>`) et tu ne codes pas toi-même.

Sprint demandé : **$ARGUMENTS** (si vide : le premier sprint contenant des stories non
terminées dans `docs/backlog.md`).

Dossier des modèles : `${CLAUDE_PLUGIN_ROOT}/templates/` (sinon, Glob
`~/.claude/plugins/**/devteam/templates/review.md`).

Skills du plugin : `${CLAUDE_PLUGIN_ROOT}/skills/<nom>/SKILL.md`. Quand un agent doit
appliquer une skill (`clean-code`, `clean-architecture`, `code-review`, `style-equipe`,
`redaction-user-story`, `code-review-checklist`, `plan-de-test`, `conventions-git`, `adr`),
transmets-lui le chemin absolu de son SKILL.md. Les agents lisent déjà leurs skills
obligatoires d'eux-mêmes (section « Skills obligatoires » de leur prompt).

## Étape 0 : Préparation
1. Vérifie que `docs/backlog.md`, `docs/architecture.md` et `CLAUDE.md` existent ; sinon,
   indique qu'il faut lancer `/devteam:nouveau-projet` et arrête-toi.
2. Liste les stories du sprint non `Terminé`, triées par dépendances puis priorité
   (Must d'abord).
3. ✋ **Validation** : présente la liste et l'objectif du sprint, et demande
   « Je lance le sprint avec ces N stories ? ». Attends la réponse.

## Pour chaque story, dans l'ordre
Applique exactement la boucle de `/devteam:story` :

1. **Préconditions** : dépendances terminées, arbre git propre, choix du ou des
   développeurs (`devteam:dev-backend` / `devteam:dev-frontend` / `devteam:dev-mobile`),
   statut `En cours`.
2. **Itération N = 1..3** :
   - a) développeur (avec les rapports précédents si N > 1) ;
   - b) toi : `git diff <branche-principale>...HEAD > docs/reviews/<story>.diff` ;
   - c) `devteam:tech-lead-reviewer` → `À CORRIGER` : N+1 et retour en a) ; `APPROUVÉ` : d) ;
   - d) `devteam:qa-testeur` → `EN ÉCHEC` : N+1 et retour en a) ; `VALIDÉ` : clôture.
3. **Escalade** si N = 3 sans succès : statut `Bloqué`, résumé des points bloquants,
   ✋ demande à l'utilisateur s'il faut continuer avec les stories suivantes (qui ne
   dépendent pas de celle-ci), redécouper, ou arrêter le sprint. Attends la réponse.
4. **Clôture** : statut `Terminé` dans le backlog (liens vers les rapports, nombre
   d'itérations), commit des rapports, proposition de merge request (sans pousser).
5. Revenir sur la branche principale avant la story suivante, ou partir de la branche
   de la story précédente si elle en dépend et n'est pas encore fusionnée (signale-le).

Après chaque story, affiche une ligne de progression :
`[3/5] US-007 ✅ (2 itérations)`.

## Synchronisation des tickets
Si `docs/tickets.md` existe et indique « Synchronisation automatique : autorisée », appelle
`devteam:gestionnaire-tickets` (mode `plan` puis `appliquer`, cible : la story concernée) **à chaque
changement de statut** de la story dans le backlog : `En cours`, `En revue`, `Bloqué`, `Terminé`.
Cette autorisation couvre les déplacements et la fermeture des tickets existants. Toute création
de ticket reste soumise à l'accord de l'utilisateur. Sans `docs/tickets.md`, ne fais rien et
propose `/devteam:tickets` en fin de traitement.

## Fin de sprint
1. Appelle `devteam:chef-de-projet` pour mettre à jour `docs/suivi.md`.
2. Résume : stories terminées / bloquées, itérations moyennes, anomalies QA restantes,
   merge requests à créer.
3. Si `docs/tickets.md` n'existe pas, propose `/devteam:tickets` pour publier le backlog.
4. Propose les suites : `/devteam:doc`, `/devteam:deploy`, `/devteam:sprint <n+1>`.

## Maîtrise des coûts
- Un seul agent actif à la fois ; transmets des chemins de fichiers, pas leur contenu.
- Si le sprint compte plus de 5 stories, propose de le réaliser en plusieurs sessions
  (`/devteam:story <id>` une par une).
