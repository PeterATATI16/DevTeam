# Commandes du travail en équipe

`<principale>` est la branche principale déclarée dans `docs/equipe.md` (souvent `main`).
Vérifier la syntaxe avec `gh <commande> --help` ou `glab <commande> --help` en cas d'erreur.

## Identité
```bash
git config user.email
gh api user --jq .login          # GitHub
glab api user | jq -r .username  # GitLab
```

## Disponibilité d'une story
```bash
git fetch origin --prune
git ls-remote --heads origin "US-012-*"
gh issue view 12 --json assignees,labels,state      # GitHub
glab issue view 12 --output json                    # GitLab
```

## Réservation
```bash
git switch -c US-012-declaration-sinistre origin/main
# Responsable renseigné dans docs/stories/US-012.md, puis :
git commit -am "Réservation de US-012 par Awa Diallo"
git push -u origin US-012-declaration-sinistre        # sans --force : refusé si déjà pris
gh issue edit 12 --add-assignee @me --remove-label "statut::a-faire" --add-label "statut::en-cours"
glab issue update 12 --assignee @me --label "statut::en-cours"
git ls-remote --heads origin "US-012-*"   # contrôle de la course : une seule branche attendue
```
Libérer une réservation perdue ou abandonnée :
```bash
git push origin --delete US-012-declaration-sinistre
gh issue edit 12 --remove-assignee @me --remove-label "statut::en-cours" --add-label "statut::a-faire"
glab issue update 12 --unassign --label "statut::a-faire"
```

## Resynchronisation
```bash
git fetch origin
git rebase origin/main
```

## Livraison
```bash
git push --force-with-lease origin US-012-declaration-sinistre

# GitHub
gh pr create --base main --head US-012-declaration-sinistre \
  --title "Déclaration de sinistre en ligne (US-012)" \
  --body-file docs/reviews/US-012-mr.md --reviewer <login-relecteur>
gh issue edit 12 --remove-label "statut::en-cours" --add-label "statut::en-revue"

# GitLab
glab mr create --source-branch US-012-declaration-sinistre --target-branch main \
  --title "Déclaration de sinistre en ligne (US-012)" \
  --description "$(cat docs/reviews/US-012-mr.md)" \
  --reviewer <login-relecteur> --remove-source-branch --yes
glab issue update 12 --label "statut::en-revue"
```
La description de la merge request (fichier `docs/reviews/US-012-mr.md`, non versionné)
contient `Closes #12` pour fermer le ticket à la fusion.

## Vue d'équipe
```bash
git for-each-ref --format='%(refname:short) %(authorname) %(committerdate:relative)' refs/remotes/origin/US-*
gh pr list --state open --json number,title,headRefName,author,reviewRequests
glab mr list --output json
gh issue list --label "statut::en-cours" --json number,title,assignees
glab issue list --label "statut::en-cours" --output json
git diff --name-only origin/main...origin/US-012-declaration-sinistre
```

## Protection de la branche principale (à faire une fois, par un administrateur)
- **GitHub** : Settings > Branches > règle sur `main` : « Require a pull request before
  merging », 1 approbation, « Require review from Code Owners ».
- **GitLab** : Settings > Repository > Protected branches : `main`, « Allowed to push : No one »,
  « Allowed to merge : Maintainers » ; Settings > Merge requests : 1 approbation, approbation
  des Code Owners.
