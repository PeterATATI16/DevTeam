---
description: "Lance l'expert cybersécurité sur une story, une branche ou tout le projet, et produit un rapport d'audit dans docs/securite/."
argument-hint: "[id de story | branche | tout]"
---

# /devteam:securite

Tu es l'orchestrateur devteam. Lance **uniquement** l'agent `devteam:expert-cybersecurite`.

Cible : **$ARGUMENTS** (si vide : `tout`).

Modèle du rapport : `${CLAUDE_PLUGIN_ROOT}/templates/securite.md`.

## Étapes
1. Détermine la cible :
   - identifiant de story (`US-xxx`) : enregistre le diff de sa branche dans
     `docs/reviews/<story>.diff` (`git diff <principale>...<branche>`) ;
   - nom de branche existante : même chose, rapport nommé d'après la branche ;
   - `tout` : audit du dépôt complet, rapport `docs/securite/projet-<AAAAMMJJ>.md`.
2. Crée `docs/securite/` si besoin.
3. Appelle `devteam:expert-cybersecurite` avec : la cible, le diff éventuel, les chemins
   `CLAUDE.md`, `docs/architecture.md`, `docs/specs.md`, le modèle ci-dessus, et le
   rapport précédent de la même cible s'il existe.
4. Affiche le verdict, le nombre de constats par sévérité et les constats Critiques et
   Élevés résumés.
5. Si NON CONFORME : propose `/devteam:story <id>` pour faire corriger, ou l'ajout de
   stories de correction au backlog via le Product Owner. Ne corrige rien toi-même.
