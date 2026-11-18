---
description: "Livre une story terminée (mode équipe) : resynchronisation avec la branche principale, tests complets, statut Terminé, poussée de la branche, merge request avec relecteur humain, ticket en revue."
argument-hint: "[US-xxx]"
disable-model-invocation: true
---

# /devteam:livrer

Tu es l'orchestrateur devteam. Lis et applique `${CLAUDE_PLUGIN_ROOT}/skills/travail-en-equipe/SKILL.md`
(section 6), ses commandes `${CLAUDE_PLUGIN_ROOT}/skills/travail-en-equipe/references/commandes.md`
et `${CLAUDE_PLUGIN_ROOT}/skills/conventions-git/SKILL.md`.

Story : **$ARGUMENTS** (si vide : celle de la branche courante `US-xxx-…`).

## Étapes
1. Vérifie que tu es sur la branche de la story et que l'arbre est propre.
2. Vérifie les préconditions : `docs/reviews/US-xxx.md` au verdict `APPROUVÉ` et
   `docs/qa/US-xxx.md` au verdict `VALIDÉ`, pour la dernière itération. Sinon, propose
   `/devteam:story US-xxx` et arrête-toi.
3. `git fetch origin && git rebase origin/<principale>`.
   - Conflit sur un fichier de code : appelle le développeur concerné (`devteam:dev-*`) pour
     le résoudre, puis relance la revue (`devteam:tech-lead-reviewer`) sur le diff mis à jour.
   - Conflit sur un fichier partagé dont l'utilisateur n'est pas propriétaire : garde la
     version de `main` et signale-le.
4. Relance **toute** la suite de tests (commande de `CLAUDE.md`). En échec : appelle
   `devteam:qa-testeur`, puis le développeur, et ne livre pas.
5. Dans `docs/stories/US-xxx.md` : statut `Terminé`, liens vers la revue et la QA, nombre
   d'itérations, responsable. Commit `Livraison de US-xxx` avec la ligne `Story : US-xxx`.
6. Prépare la description de la merge request dans `docs/reviews/US-xxx-mr.md` (non
   versionné) : contexte, changements, vérifications, `Closes #n` si un ticket existe.
   Choisis le relecteur humain : un autre membre de `docs/equipe.md` ayant le bon rôle, le
   moins chargé en relectures ouvertes.
7. ✋ Affiche ce qui va partir (branche, titre, relecteur, nombre de commits) et demande
   l'accord. Puis : `git push --force-with-lease`, création de la merge request, ticket en
   `statut::en-revue`.
8. Donne le lien de la merge request. Rappelle que la fusion est faite par une personne
   autorisée, après approbation humaine, et que le ticket se fermera à la fusion.
9. Propose `/devteam:prendre` pour la suite (si la limite de stories en cours le permet).
