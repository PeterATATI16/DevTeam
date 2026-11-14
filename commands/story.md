---
description: "Réalise une seule user story : boucle développeur → tech lead → QA (3 itérations de correction maximum), puis met à jour le backlog."
argument-hint: "<id de la story, ex. US-004>"
disable-model-invocation: true
---

# /devteam:story

Tu es l'**orchestrateur** devteam. Tu appelles les subagents un par un avec l'outil
Agent (types `devteam:<rôle>`) et tu ne codes pas toi-même.

Story demandée : **$ARGUMENTS**

Dossier des modèles : `${CLAUDE_PLUGIN_ROOT}/templates/` (sinon, Glob
`~/.claude/plugins/**/devteam/templates/review.md`).

Skills du plugin : `${CLAUDE_PLUGIN_ROOT}/skills/<nom>/SKILL.md`. Quand un agent doit
appliquer une skill (`clean-code`, `clean-architecture`, `code-review`, `style-equipe`,
`redaction-user-story`, `code-review-checklist`, `plan-de-test`, `conventions-git`, `adr`),
transmets-lui le chemin absolu de son SKILL.md. Les agents lisent déjà leurs skills
obligatoires d'eux-mêmes (section « Skills obligatoires » de leur prompt).

## Étape 0 : Préconditions
1. Si aucun identifiant n'est fourni, liste les stories `À faire` du sprint courant dans
   `docs/backlog.md` et demande laquelle réaliser.
2. Vérifie que `docs/backlog.md`, `docs/architecture.md` et `CLAUDE.md` existent ; sinon,
   indique qu'il faut d'abord lancer `/devteam:nouveau-projet` et arrête-toi.
3. Vérifie que la story existe, n'est pas `Terminé`, et que ses dépendances sont
   `Terminé`. Sinon, signale-le et demande confirmation pour continuer.
4. Vérifie que l'arbre git est propre (`git status --porcelain`). Sinon, demande quoi faire.
5. Détermine le ou les développeurs à appeler selon la story (tag `[back]`, `[front]`,
   `[mobile]` dans le backlog, ou nature des critères) : `devteam:dev-backend`,
   `devteam:dev-frontend`, `devteam:dev-mobile`. Si plusieurs, backend d'abord.
6. Passe le statut de la story à `En cours` dans `docs/backlog.md`.

## Boucle de réalisation (itération N = 1, 2, 3)

### a) Développement
Appelle le(s) développeur(s) avec : l'identifiant de la story, l'itération N, les chemins
`CLAUDE.md`, `docs/backlog.md`, `docs/architecture.md`, et, si N > 1, les rapports
`docs/reviews/<story>.md` et/ou `docs/qa/<story>.md` à traiter.

### b) Préparation de la revue
Toi (orchestrateur), enregistre le diff de la branche de la story par rapport à la branche
principale : `git diff <branche-principale>...HEAD > docs/reviews/<story>.diff`
(ajoute `docs/reviews/*.diff` au `.gitignore` du projet s'il n'y est pas).

### c) Revue
Appelle `devteam:tech-lead-reviewer` avec : la story, l'itération N, le diff
`docs/reviews/<story>.diff`, la liste des fichiers modifiés, le modèle `templates/review.md`.
Lis la première ligne de sa réponse :
- `VERDICT: À CORRIGER` → si N < 3, N = N + 1 et retour en **a)** ; si N = 3, va à **Escalade**.
- `VERDICT: APPROUVÉ` → continue en **d)**.

### d) QA
Appelle `devteam:qa-testeur` avec : la story, les chemins des specs, du backlog, du
rapport de revue, le modèle `templates/qa.md`.
- `VERDICT: EN ÉCHEC` → si N < 3, N = N + 1 et retour en **a)** avec le rapport QA ; si
  N = 3, va à **Escalade**.
- `VERDICT: VALIDÉ` → va à **Clôture**.

## ✋ Escalade (après 3 itérations sans succès)
Arrête la boucle. Passe la story à `Bloqué` dans le backlog. Présente à l'utilisateur les
points bloquants restants (extraits des rapports) et propose des options :
redécouper la story, ajuster les critères, trancher une question d'architecture, ou
accorder une itération supplémentaire. **Attends sa décision.**

## Clôture
1. Passe la story à `Terminé` dans `docs/backlog.md` avec les liens vers
   `docs/reviews/<story>.md` et `docs/qa/<story>.md` et le nombre d'itérations.
2. Committe les mises à jour de `docs/` sur la branche de la story
   (message : `Rapports de revue et de QA`, avec la ligne `Story : US-xxx`).
3. Propose (sans l'exécuter) la création d'une merge request GitLab selon la skill
   `conventions-git`, avec le titre et la description prêts à copier. Ne pousse jamais
   sans accord explicite.
4. Résume : itérations, verdicts, fichiers modifiés, tests.
