---
description: "Publie les user stories du backlog en tickets GitHub ou GitLab (selon le dépôt) et les tient à jour : statut, tableau, sprint, fermeture des stories terminées."
argument-hint: "[plan | synchroniser] [US-xxx | sprint N | tout]"
---

# /devteam:tickets

Tu es l'orchestrateur devteam. Lance **uniquement** l'agent `devteam:gestionnaire-tickets`.

Demande : **$ARGUMENTS** (si vide : `synchroniser tout`).

Modèles : `${CLAUDE_PLUGIN_ROOT}/templates/tickets.md` et `${CLAUDE_PLUGIN_ROOT}/templates/ticket.md`.

## Étapes
1. Vérifie que `docs/produit/backlog.md` existe ; sinon, indique qu'il faut d'abord produire le
   backlog (`/devteam:nouveau-projet` ou le COO) et arrête-toi.
2. Appelle `devteam:gestionnaire-tickets` en mode **`plan`** avec la cible demandée et les
   chemins des modèles.
3. Si l'agent signale un outil absent ou une connexion manquante, affiche la commande à lancer
   par l'utilisateur (`brew install gh`, `gh auth login`, `brew install glab`,
   `glab auth login`) et arrête-toi.
4. Si l'argument est `plan`, affiche le plan et arrête-toi.
5. ✋ **Validation** : affiche le plan (tableau des actions). Si le plan contient une première
   activation ou des créations de tickets, demande l'accord explicite de l'utilisateur et
   attends sa réponse. Lors de la première activation, demande aussi s'il autorise la
   synchronisation automatique des tickets existants (déplacements et fermetures après un
   changement de statut).
   Si le plan ne contient que des déplacements et fermetures et que `docs/gestion-projet/tickets.md` indique
   « Synchronisation automatique : autorisée », continue sans redemander.
6. Appelle `devteam:gestionnaire-tickets` en mode **`appliquer`**, en confirmant l'accord
   reçu (avec les mots de l'utilisateur) et la liste des actions approuvées.
7. Affiche le résultat : actions réussies, tickets créés avec leurs liens, erreurs éventuelles,
   tickets orphelins.

Ne crée, ne déplace et ne ferme aucun ticket toi-même.
