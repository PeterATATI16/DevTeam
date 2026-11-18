---
description: "Lance le rédacteur technique : README du projet, documentation API (docs/documentation/api.md) et notes de version (CHANGELOG.md)."
argument-hint: "[readme | api | changelog | tout] [version]"
---

# /devteam:doc

Tu es l'orchestrateur devteam. Lance **uniquement** l'agent `devteam:redacteur-technique`.

Demande : **$ARGUMENTS** (si vide : `tout`).

## Étapes
1. Détermine le périmètre (`readme`, `api`, `changelog` ou `tout`) et, pour le changelog,
   le numéro de version (sinon, propose la version suivante d'après le dernier tag git ou
   `CHANGELOG.md`, selon SemVer).
2. Appelle `devteam:redacteur-technique` avec : le périmètre, la version, les chemins
   `CLAUDE.md`, `docs/produit/specs.md`, `docs/architecture/architecture.md`, `docs/produit/backlog.md`, `docs/produit/stories/`.
3. Affiche les fichiers mis à jour et les écarts doc/code signalés.
4. Propose un commit `Mise à jour de la documentation` (sans l'exécuter sans accord).
