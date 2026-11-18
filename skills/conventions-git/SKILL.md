---
name: conventions-git
description: "Conventions git de l'équipe : nommage des branches, messages de commit en français sans préfixe de type ni attribution, merge requests GitLab. À utiliser pour créer une branche, committer ou préparer une merge request."
---

# Conventions git

## Interdictions formelles
- **Aucune attribution d'outil ou d'IA** : jamais de ligne `Co-Authored-By`, jamais de
  mention de Claude, d'une IA, d'un modèle ou d'un outil de génération, ni dans les commits,
  ni dans les branches, ni dans les merge requests.
- **Aucun préfixe de type** : pas de `feat:`, `fix:`, `docs:`, `chore:`, `test:`, `ci:`,
  `refactor:`, avec ou sans portée (`feat(auth):`).
- **Aucune branche préfixée par un type** : pas de `feat/`, `feature/`, `fix/`, `docs/`,
  `chore/`, `hotfix/`.

Le hook `controle-git.sh` du plugin bloque toute commande `git commit` ou création de branche
qui enfreint ces règles.

## Branches
Une branche porte **l'identifiant de ce qu'elle traite**, suivi d'un slug court.

| Contenu | Modèle | Exemple |
|---|---|---|
| Une user story | `US-<id>-<slug>` | `US-012-declaration-sinistre` |
| Une anomalie QA | `QA-<id>-<slug>` | `QA-02-taille-photo` |
| Une vulnérabilité | `SEC-<id>-<slug>` | `SEC-01-controle-acces-sinistres` |
| Cadrage, documentation, outillage | `<slug>` | `cadrage-initial`, `pipeline-gitlab` |

- Slug en minuscules, sans accents, mots séparés par des tirets, 5 mots au plus.
- La branche principale (`main`) est protégée : on n'y committe jamais directement.

| ❌ À éviter | ✅ À faire |
|---|---|
| `feature/US-012-declaration` | `US-012-declaration-sinistre` |
| `fix/upload` | `QA-02-taille-photo` |
| `docs/cadrage` | `cadrage-initial` |

## Messages de commit
```
<Résumé en français, commençant par un nom d'action, 72 caractères au plus>

<Corps facultatif : pourquoi le changement, en phrases courtes ou en liste.>

Story : US-012
```
- Le résumé commence par un nom d'action : « Ajout », « Correction », « Suppression »,
  « Refonte », « Mise à jour », « Documentation », « Tests », « Création ».
- Pas de point final dans le résumé, pas d'emoji, pas de tiret long.
- La ligne `Story : US-xxx` (ou `Anomalie : QA-xx`, `Vulnérabilité : SEC-xx`) relie le commit
  au backlog.

| ❌ À éviter | ✅ À faire |
|---|---|
| `feat(sinistres): add upload` | `Ajout de la déclaration de sinistre avec photos` |
| `fix: bug` | `Correction du refus des photos de plus de 10 Mo` |
| `docs: update` | `Mise à jour de la documentation de l'API sinistres` |
| `WIP`, `modifs`, `final v2` | `Tests du refus des contrats résiliés` |
| (corps) `Co-Authored-By: …` | (aucune ligne d'attribution) |

Règles : un commit = un changement cohérent qui compile et passe les tests ; pas de
fichier généré, de secret ou de `.env`.

## Merge requests GitLab
**Titre** : le résumé du commit principal suivi de l'identifiant, ex.
`Déclaration de sinistre en ligne (US-012)`.

**Description** :
```markdown
## Contexte
US-012 : Déclarer un sinistre en ligne (lien vers docs/produit/stories/US-012.md)

## Changements
- …

## Vérifications
- Revue : docs/qualite/revues/US-012.md : APPROUVÉ (itération 2)
- QA : docs/qualite/qa/US-012.md : VALIDÉ
- [ ] Pipeline vert
- [ ] Migrations testées
- [ ] Documentation mise à jour

Closes #<numéro d'issue GitLab si existant>
```
Options : *Delete source branch*, *Squash commits* selon la convention du projet,
au moins un approbateur humain. Aucune mention d'outil ou d'IA dans la description.

Création en ligne de commande (à proposer, jamais exécuter sans accord) :
```bash
git push -u origin US-012-declaration-sinistre \
  -o merge_request.create -o merge_request.target=main \
  -o merge_request.title="Déclaration de sinistre en ligne (US-012)"
```
ou `glab mr create --fill --target-branch main`.

## Interdits pour les agents
`git push` sans accord, `git push --force`, `git reset --hard` sur une branche partagée,
réécriture de `main`, `--no-verify`.
