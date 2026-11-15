# Commandes GitHub (`gh`)

Toutes les commandes s'exécutent dans le dépôt du projet. `gh` déduit le dépôt de `origin`.
Vérifier la syntaxe avec `gh <commande> --help` en cas d'erreur.

## Connexion
```bash
gh auth status
```
Pour les tableaux (Projects), le jeton doit avoir la portée `project` :
```bash
gh auth refresh -s project
```
Ces deux commandes sont lancées par l'utilisateur s'il faut se connecter.

## Lecture (phase « plan »)
```bash
gh issue list --state all --limit 500 --json number,title,state,labels,milestone,url
gh label list --limit 200 --json name
gh api repos/{owner}/{repo}/milestones?state=all --jq '.[].title'
```

## Labels et milestones (activation)
```bash
gh label create "statut::en-cours" --color 1F6FEB --description "Story en cours" --force
gh api repos/{owner}/{repo}/milestones -f title="Sprint 1" -f description="<Sprint Goal>"
```
Couleurs conseillées : statut en bleu ou gris, `statut::bloque` en rouge (`D1242F`),
`statut::termine` en vert (`1A7F37`), priorités en dégradé de neutres.

## Création d'un ticket
```bash
gh issue create \
  --title "US-012 : Déclarer un sinistre en ligne" \
  --body-file docs/tickets/US-012.md \
  --label "statut::a-faire" --label "priorite::must" --label "perimetre::back" --label "estimation::m" \
  --milestone "Sprint 1"
```
Le corps est préparé dans un fichier (`docs/tickets/US-012.md`, modèle `templates/ticket.md`)
pour éviter les problèmes de guillemets. La commande affiche l'URL : en extraire le numéro.

## Mise à jour et déplacement
```bash
gh issue edit 12 --remove-label "statut::a-faire" --add-label "statut::en-cours"
gh issue edit 12 --milestone "Sprint 2"
gh issue edit 12 --body-file docs/tickets/US-012.md
gh issue comment 12 --body "Bloqué : en attente de la validation du format des pièces jointes."
```

## Fermeture et réouverture
```bash
gh issue close 12 --reason completed --comment "Story terminée. ..."
gh issue close 15 --reason "not planned" --comment "Hors périmètre (Won't) : <justification>."
gh issue reopen 12 --comment "Story rouverte : anomalie QA-03."
```

## Tableau (GitHub Projects), si configuré
Paramètres dans `docs/tickets.md` : numéro du projet `N`, propriétaire `OWNER`.
```bash
# Ajouter le ticket au projet (renvoie l'identifiant de l'élément)
gh project item-add N --owner OWNER --url https://github.com/OWNER/REPO/issues/12 --format json

# Identifiants du projet, du champ Status et de ses options (une seule fois, à noter dans docs/tickets.md)
gh project view N --owner OWNER --format json --jq '.id'
gh project field-list N --owner OWNER --format json

# Déplacer la carte : changer l'option du champ Status
gh project item-edit --id <ITEM_ID> --project-id <PROJECT_ID> \
  --field-id <STATUS_FIELD_ID> --single-select-option-id <OPTION_ID>
```
Options du champ « Status » attendues : À faire, En cours, En revue, Bloqué, Terminé. Si elles
n'existent pas, demander à l'utilisateur de les créer dans l'interface du projet (opération
manuelle unique), puis noter leurs identifiants dans `docs/tickets.md`.
