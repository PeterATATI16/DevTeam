---
description: Lance le rédacteur technique — README du projet, documentation API (docs/api.md) et notes de version (CHANGELOG.md).
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
   `CLAUDE.md`, `docs/specs.md`, `docs/architecture.md`, `docs/backlog.md`.
3. Affiche les fichiers mis à jour et les écarts doc/code signalés.
4. Propose un commit `docs: mise à jour de la documentation` (sans l'exécuter sans accord).
