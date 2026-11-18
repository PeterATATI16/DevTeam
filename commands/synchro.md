---
description: "Vue d'équipe (mode équipe) : qui fait quoi, merge requests à relire, stories bloquées ou libres, conflits probables entre branches. Remet aussi la branche courante à jour."
argument-hint: "[--sans-rebase]"
---

# /devteam:synchro

Tu es l'orchestrateur devteam. Lis et applique `${CLAUDE_PLUGIN_ROOT}/skills/travail-en-equipe/SKILL.md`
(section 8) et ses commandes `${CLAUDE_PLUGIN_ROOT}/skills/travail-en-equipe/references/commandes.md`.

Options : **$ARGUMENTS**

## Étapes
1. `git fetch origin --prune`.
2. Si la branche courante est une branche de story et que l'option `--sans-rebase` n'est pas
   donnée : `git rebase origin/<principale>` (arbre propre requis). En cas de conflit,
   arrête le rebase (`git rebase --abort`), liste les fichiers en conflit et propose de les
   traiter avec le développeur concerné.
3. Collecte, en lecture seule :
   - les stories en cours et leur responsable (tickets `statut::en-cours` et personnes
     assignées ; sinon branches `origin/US-*` et leurs auteurs) ;
   - les merge requests ouvertes, leurs relecteurs et leur ancienneté ;
   - les stories bloquées (`statut::bloque`) ;
   - les stories libres prêtes à prendre (statut `À faire`, dépendances terminées, non réservées) ;
   - les conflits probables : fichiers modifiés à la fois par deux branches de story ouvertes.
4. Écris ce relevé dans `docs/etat-equipe.md` (non versionné, ajoute-le au `.gitignore`), puis
   appelle `devteam:chef-de-projet` avec ce fichier et `docs/stories/` pour produire
   `docs/suivi.md` (non versionné en mode équipe).
5. Affiche une vue courte :

```
### Équipe : AAAA-MM-JJ HH:MM
| Personne | En cours | En revue | À relire pour les autres |
|---|---|---|---|
| Peter | US-012 (2 j) | US-009 | MR !14 (US-011, Awa) |

- ⛔ Bloqué : …
- ⚠️ Conflits probables : US-012 et US-014 modifient `src/domain/sinistre/sinistre.ts`
- ➡️ Prochaines stories libres : US-015 (Must), US-016 (Should)
```
6. Si des conflits probables existent, recommande aux deux responsables de se coordonner
   (ordre de fusion, découpage) avant d'aller plus loin.
