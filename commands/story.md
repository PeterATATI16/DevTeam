---
description: "Réalise une seule user story : boucle développeur → tech lead → QA (3 itérations de correction maximum). En mode équipe, sur la story réservée par l'utilisateur, puis livraison par merge request."
argument-hint: "<id de la story, ex. US-004>"
disable-model-invocation: true
---

# /devteam:story

Tu es l'**orchestrateur** devteam. Tu appelles les subagents un par un avec l'outil
Agent (types `devteam:<rôle>`) et tu ne codes pas toi-même.

Story demandée : **$ARGUMENTS**

Dossier des modèles : `${CLAUDE_PLUGIN_ROOT}/templates/` (sinon, Glob
`~/.claude/plugins/**/devteam/templates/review.md`).

Skills du plugin : `${CLAUDE_PLUGIN_ROOT}/skills/<nom>/SKILL.md`. Les agents lisent déjà leurs
skills obligatoires d'eux-mêmes. En mode équipe, applique toi-même
`${CLAUDE_PLUGIN_ROOT}/skills/travail-en-equipe/SKILL.md`.

**Fichier de la story** : `docs/stories/US-xxx.md`. Ancien format (stories détaillées dans
`docs/backlog.md`, pas de dossier `docs/stories/`) : lis la story dans `docs/backlog.md`,
continue normalement, et propose `/devteam:equipe migrer` à la fin.

## Étape 0 : Préconditions
1. Si aucun identifiant n'est fourni : en mode équipe, prends la story de la branche courante
   `US-xxx-…`, sinon propose `/devteam:prendre` ; en mode seul, liste les stories `À faire` du
   sprint courant (`docs/backlog.md`) et demande laquelle réaliser.
2. Vérifie que `docs/backlog.md`, `docs/architecture.md` et `CLAUDE.md` existent ; sinon,
   indique qu'il faut d'abord lancer `/devteam:nouveau-projet` et arrête-toi.
3. Vérifie que la story existe, que son statut durable n'est pas `Terminé`, et que ses
   dépendances sont `Terminé`. Sinon, signale-le et demande confirmation pour continuer.
4. Vérifie que l'arbre git est propre (`git status --porcelain`). Sinon, demande quoi faire.
5. **Branche de travail** :
   - mode équipe (`docs/equipe.md` existe) : la story doit être **réservée par l'utilisateur**
     (branche courante `US-xxx-…`, ticket assigné à lui ou branche distante créée par lui).
     Sinon, applique d'abord la procédure de `/devteam:prendre`. Si elle est réservée par
     quelqu'un d'autre, arrête-toi et dis par qui ;
   - mode seul : crée la branche `US-xxx-<slug>` depuis la branche principale si tu n'y es pas.
6. Détermine le ou les développeurs selon le périmètre de la story (`[back]`, `[front]`,
   `[mobile]`, ou nature des critères) : `devteam:dev-backend`, `devteam:dev-frontend`,
   `devteam:dev-mobile`. Si plusieurs, backend d'abord.
7. Statut vivant `En cours` : sur le ticket si `docs/tickets.md` existe (section suivante),
   sinon dans le fichier de la story, sur la branche.

## Synchronisation des tickets
Si `docs/tickets.md` existe et indique « Synchronisation automatique : autorisée », appelle
`devteam:gestionnaire-tickets` (mode `plan` puis `appliquer`, cible : la story) **à chaque
changement de statut** : `En cours`, `En revue`, `Bloqué`, `Terminé`. Cette autorisation
couvre les déplacements et la fermeture des tickets existants. Toute création de ticket reste
soumise à l'accord de l'utilisateur. Sans `docs/tickets.md`, ne fais rien et propose
`/devteam:tickets` en fin de traitement.

## Boucle de réalisation (itération N = 1, 2, 3)

### a) Développement
Appelle le(s) développeur(s) avec : l'identifiant de la story, l'itération N, les chemins
`CLAUDE.md`, `docs/stories/US-xxx.md`, `docs/architecture.md`, et, si N > 1, les rapports
`docs/reviews/US-xxx.md` et/ou `docs/qa/US-xxx.md` à traiter.

### b) Préparation de la revue
Toi (orchestrateur), enregistre le diff de la branche de la story par rapport à la branche
principale : `git diff <branche-principale>...HEAD > docs/reviews/US-xxx.diff`
(ajoute `docs/reviews/*.diff` au `.gitignore` du projet s'il n'y est pas).

### c) Revue
Appelle `devteam:tech-lead-reviewer` avec : la story, l'itération N, le diff
`docs/reviews/US-xxx.diff`, la liste des fichiers modifiés, le modèle `templates/review.md`.
Lis la première ligne de sa réponse :
- `VERDICT: À CORRIGER` → si N < 3, N = N + 1 et retour en **a)** ; si N = 3, va à **Escalade**.
- `VERDICT: APPROUVÉ` → continue en **d)**.

### d) QA
Appelle `devteam:qa-testeur` avec : la story, les chemins `docs/specs.md`,
`docs/stories/US-xxx.md`, le rapport de revue, le modèle `templates/qa.md`.
- `VERDICT: EN ÉCHEC` → si N < 3, N = N + 1 et retour en **a)** avec le rapport QA ; si
  N = 3, va à **Escalade**.
- `VERDICT: VALIDÉ` → va à **Clôture**.

## ✋ Escalade (après 3 itérations sans succès)
Arrête la boucle. Statut vivant `Bloqué` (ticket, ou fichier de la story sur la branche).
Présente à l'utilisateur les points bloquants restants (extraits des rapports) et propose des
options : redécouper la story, ajuster les critères, trancher une question d'architecture, ou
accorder une itération supplémentaire. En mode équipe, ces arbitrages reviennent au
**décideur** de `docs/equipe.md`. **Attends la décision.**

## Clôture
1. Committe les rapports `docs/reviews/US-xxx.md` et `docs/qa/US-xxx.md` sur la branche de la
   story (message : `Rapports de revue et de QA`, avec la ligne `Story : US-xxx`).
2. **Mode équipe** : propose `/devteam:livrer US-xxx` (resynchronisation, tests complets,
   statut `Terminé`, merge request avec relecteur humain). Ne pousse rien ici.
3. **Mode seul** : dans `docs/stories/US-xxx.md`, statut `Terminé`, liens vers les rapports,
   nombre d'itérations ; commit. Puis propose (sans l'exécuter) la poussée et la merge
   request selon la skill `conventions-git`. Ne pousse jamais sans accord explicite.
4. Résume : itérations, verdicts, fichiers modifiés, tests.
