---
description: "Range un projet existant selon l'organisation actuelle de devteam : docs/ classé par département, une story par fichier, journaux en ajout seul. Aucun contenu n'est perdu."
argument-hint: "[plan]"
disable-model-invocation: true
---

# /devteam:organiser

Tu es l'orchestrateur devteam. Lis le plan de classement
`${CLAUDE_PLUGIN_ROOT}/templates/docs-README.md` et la section « Classement de `docs/` par
département » de `${CLAUDE_PLUGIN_ROOT}/skills/style-equipe/SKILL.md`.

Demande : **$ARGUMENTS** (`plan` : montrer ce qui serait fait, sans rien modifier).

## Correspondance ancienne organisation et nouvelle

| Ancien emplacement | Nouvel emplacement |
|---|---|
| `docs/decisions-ceo.md` | `docs/direction/decisions-ceo.md` |
| `docs/equipe.md` | `docs/direction/equipe.md` |
| `docs/rapports-coo/` | `docs/direction/rapports-coo/<auteur>/` |
| `docs/suivi.md`, `docs/etat-equipe.md` | `docs/gestion-projet/` |
| `docs/tickets.md`, `docs/tickets/` | `docs/gestion-projet/` |
| `docs/specs.md`, `docs/backlog.md`, `docs/stories/` | `docs/produit/` |
| `docs/architecture.md`, `docs/adr/` | `docs/architecture/` |
| `docs/maquettes/` | `docs/design/maquettes/` |
| `docs/reviews/` | `docs/qualite/revues/` |
| `docs/qa/` | `docs/qualite/qa/` |
| `docs/securite/` | `docs/securite/` (inchangé) |
| `docs/deploiement.md` | `docs/exploitation/deploiement.md` |
| `docs/api.md` | `docs/documentation/api.md` |

## Étapes
1. Vérifie que l'arbre git est propre. En mode équipe, crée la branche `organisation-docs`
   depuis la branche principale à jour (rien ne se fait sur `main`). En mode seul, propose la
   même branche.
2. **Inventaire** : liste chaque fichier de `docs/` et sa destination selon la table. Les
   fichiers qui n'entrent dans aucune ligne restent en place et sont listés à part, avec une
   proposition de département.
3. Si l'argument est `plan` : affiche l'inventaire et arrête-toi.
4. ✋ Montre l'inventaire et demande l'accord.
5. **Déplacements** avec `git mv` (l'historique de chaque fichier est conservé).
6. **Stories** : si `docs/produit/backlog.md` contient encore le détail des stories, crée un
   fichier par story `docs/produit/stories/US-xxx.md` (modèle `templates/story.md`) : contenu,
   critères, estimation, dépendances, règles, ticket, notes dev, liens de revue et de QA.
   Statut durable : `Terminé` ou `Won't` s'ils l'étaient, sinon `À faire` (les statuts vivants
   vont sur les tickets). Réécris ensuite `docs/produit/backlog.md` au format index (modèle
   `templates/backlog.md`).
7. **Journaux** : convertis `docs/direction/decisions-ceo.md` au format ajout seul (retire le
   tableau de résumé, garde chaque bloc et ses anciens identifiants `D-001`). Dans
   `docs/gestion-projet/tickets.md`, retire la colonne « Statut synchronisé » et l'en-tête
   « Dernière synchronisation ». Range les anciens rapports du COO dans un sous-dossier au nom
   de leur auteur (`git log` du fichier).
8. **Liens** : remplace dans tout le dépôt (Markdown, `CLAUDE.md`, `CODEOWNERS`,
   `.gitattributes`, `.gitignore`, README) les anciens chemins par les nouveaux.
9. Crée `docs/README.md` à partir du modèle `templates/docs-README.md`, puis supprime les anciens
   dossiers restés vides (`find docs -type d -empty -delete`).
10. **Contrôle** : même nombre de fichiers avant et après, même nombre de stories et de critères
    d'acceptation, aucun lien Markdown cassé vers `docs/`, plus aucun fichier à la racine de
    `docs/` sauf `README.md`. Affiche le bilan.
11. Committe (`Rangement de la documentation par département`). En mode équipe, propose la
    poussée et la merge request : prévenez l'équipe, car toutes les branches ouvertes devront
    se resynchroniser après la fusion (`/devteam:synchro`).
