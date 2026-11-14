---
description: "Lance le DevOps : Dockerfile, docker-compose, pipeline GitLab CI, variables d'environnement et scripts de déploiement. Demande confirmation avant toute action irréversible."
argument-hint: "[environnement : local | staging | production]"
disable-model-invocation: true
---

# /devteam:deploy

Tu es l'orchestrateur devteam. Lance l'agent `devteam:devops`.

Environnement visé : **$ARGUMENTS** (si vide : préparation uniquement, sans déploiement).

## Étapes
1. Vérifie que `docs/architecture.md` et `CLAUDE.md` existent ; sinon, signale qu'il faut
   d'abord l'architecture.
2. Vérifie dans `docs/backlog.md` / `docs/qa/` qu'aucune story incluse n'est `EN ÉCHEC` ou
   `Bloqué`. S'il y en a, ✋ préviens l'utilisateur et demande s'il faut continuer.
3. Pour `staging` ou `production` : vérifie qu'un audit `docs/securite/*.md` de moins de
   30 jours existe avec le verdict CONFORME. Sinon, ✋ propose de lancer d'abord
   `devteam:expert-cybersecurite` (comme `/devteam:securite tout`). Pour `production`, un
   verdict NON CONFORME interdit de continuer sans accord explicite de l'utilisateur.
4. Appelle `devteam:devops` avec : l'environnement visé, `CLAUDE.md`,
   `docs/architecture.md`, la consigne de **ne rien exécuter d'irréversible ni de distant**
   et de lister ces actions sous « Actions à confirmer ».
5. Présente les fichiers créés et les vérifications locales.

## ✋ Confirmation des actions irréversibles
Pour **chaque** action listée par le DevOps (push, docker push, déploiement, migration
de base, suppression de ressource…) :
1. Affiche la commande exacte, son effet, l'environnement touché et si elle est réversible.
2. Demande une confirmation explicite **action par action** (« Exécuter l'action 1 ? »).
   Une validation globale ne suffit pas pour la production.
3. N'exécute que les actions confirmées, une par une, en t'arrêtant à la première erreur.
4. Pour `production` : exige que l'utilisateur retape le nom de l'environnement
   (« production ») avant toute action.

## Fin
Résume ce qui a été préparé, exécuté, et ce qui reste à faire (variables CI à définir dans
GitLab : *Settings > CI/CD > Variables*, etc.).
