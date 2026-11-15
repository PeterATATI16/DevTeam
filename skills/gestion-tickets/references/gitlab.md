# Commandes GitLab (`glab`)

Toutes les commandes s'exécutent dans le dépôt du projet. `glab` déduit le projet de `origin`
(gitlab.com ou instance interne). Vérifier la syntaxe avec `glab <commande> --help` en cas
d'erreur, car elle varie selon la version de `glab`.

## Connexion
```bash
glab auth status
```
Pour une instance interne, l'utilisateur se connecte avec `glab auth login --hostname <hôte>`.

## Lecture (phase « plan »)
```bash
glab issue list --all --per-page 100 --output json
glab label list --per-page 100
glab api "projects/:fullpath/milestones?state=all"
glab api "projects/:fullpath/boards"
```

## Labels et milestones (activation)
```bash
glab label create --name "statut::en-cours" --color "#1F6FEB" --description "Story en cours"
glab api "projects/:fullpath/milestones" -X POST -f title="Sprint 1" -f description="<Sprint Goal>"
```
La forme `clé::valeur` rend les labels exclusifs : poser `statut::en-cours` retire
automatiquement `statut::a-faire`.

## Tableau (activation)
Un tableau dont les listes sont les labels `statut::…` déplace les cartes tout seul.
```bash
# Tableau existant (souvent « Development »), ou en créer un
glab api "projects/:fullpath/boards" -X POST -f name="devteam"

# Une liste par label de statut (identifiant du label obtenu par glab api "projects/:fullpath/labels")
glab api "projects/:fullpath/boards/<BOARD_ID>/lists" -X POST -f label_id=<LABEL_ID>
```
Ordre des listes : `statut::a-faire`, `statut::en-cours`, `statut::en-revue`, `statut::bloque`,
`statut::termine`. La liste « Closed » existe par défaut.

## Création d'un ticket
```bash
glab issue create \
  --title "US-012 : Déclarer un sinistre en ligne" \
  --description "$(cat docs/tickets/US-012.md)" \
  --label "statut::a-faire,priorite::must,perimetre::back,estimation::m" \
  --milestone "Sprint 1" --yes
```
Le corps est préparé dans `docs/tickets/US-012.md` (modèle `templates/ticket.md`). La commande
affiche l'URL : en extraire le numéro (IID).

## Mise à jour et déplacement
```bash
glab issue update 12 --label "statut::en-cours"
glab issue update 12 --milestone "Sprint 2"
glab issue update 12 --description "$(cat docs/tickets/US-012.md)"
glab issue note 12 --message "Bloqué : en attente de la validation du format des pièces jointes."
```

## Fermeture et réouverture
```bash
glab issue note 12 --message "Story terminée. ..."
glab issue update 12 --label "statut::termine"
glab issue close 12

glab issue reopen 12
glab issue note 12 --message "Story rouverte : anomalie QA-03."
```
Une merge request dont la description contient `Closes #12` ferme aussi le ticket à la fusion.
