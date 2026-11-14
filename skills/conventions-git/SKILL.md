---
name: conventions-git
description: "Conventions git de l'équipe : nommage des branches, messages Conventional Commits, merge requests GitLab (titre, description, checklist). À utiliser pour créer une branche, committer ou préparer une merge request."
---

# Conventions git

## Branches
| Type | Modèle | Exemple |
|---|---|---|
| Fonctionnalité | `feature/US-<id>-<slug>` | `feature/US-012-declaration-sinistre` |
| Correctif | `fix/<id-ou-slug>` | `fix/QA-02-taille-photo` |
| Documentation | `docs/<slug>` | `docs/cadrage` |
| Technique | `chore/<slug>` | `chore/ci-gitlab` |
| Urgence prod | `hotfix/<slug>` | `hotfix/fuite-logs` |

- La branche principale (`main`) est protégée : on n'y committe jamais directement.
- Slug en minuscules, sans accents, mots séparés par des tirets.

## Messages de commit : Conventional Commits 1.0
```
<type>(<portée>): <résumé à l'impératif, ≤ 72 caractères>

<corps facultatif : pourquoi, pas comment>

Refs: US-012
```
Types : `feat`, `fix`, `docs`, `test`, `refactor`, `perf`, `build`, `ci`, `chore`,
`style`, `revert`. Changement incompatible : `feat!:` ou pied `BREAKING CHANGE: …`.

Exemples :
- `feat(sinistres): permettre la déclaration avec photos`
- `fix(auth): empêcher l'énumération des comptes à la connexion`
- `test(sinistres): couvrir le refus des contrats résiliés`
- `ci: ajouter l'analyse des dépendances au pipeline`

Règles : un commit = un changement cohérent qui compile et passe les tests ; pas de
fichier généré, de secret ou de `.env`.

## Merge requests GitLab
**Titre** : identique au commit principal, ex. `feat(sinistres): déclaration en ligne (US-012)`.

**Description** :
```markdown
## Contexte
US-012 : Déclarer un sinistre en ligne (lien vers docs/backlog.md)

## Changements
- …

## Vérifications
- Revue : docs/reviews/US-012.md : APPROUVÉ (itération 2)
- QA : docs/qa/US-012.md : VALIDÉ
- [ ] Pipeline vert
- [ ] Migrations testées
- [ ] Documentation mise à jour

Closes #<numéro d'issue GitLab si existant>
```
Options : *Delete source branch*, *Squash commits* selon la convention du projet,
au moins un approbateur humain.

Création en ligne de commande (à proposer, jamais exécuter sans accord) :
```bash
git push -u origin feature/US-012-declaration-sinistre \
  -o merge_request.create -o merge_request.target=main \
  -o merge_request.title="feat(sinistres): déclaration en ligne (US-012)"
```
ou `glab mr create --fill --target-branch main`.

## Interdits pour les agents
`git push` sans accord, `git push --force`, `git reset --hard` sur une branche partagée,
réécriture de `main`, `--no-verify`.
