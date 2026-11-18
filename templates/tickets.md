# Suivi des tickets

> Tenu par : gestionnaire-tickets. **Ajout seul** pour la correspondance et le journal
> (`merge=union`) : le statut vivant de chaque story se lit sur la plateforme, pas ici.

## Configuration
| Paramètre | Valeur |
|---|---|
| Plateforme | GitHub \| GitLab |
| Dépôt | `<owner/repo>` ou `<groupe/projet>` |
| Hôte | `github.com` \| `gitlab.com` \| `<instance interne>` |
| Tableau | GitHub Projects n° `<N>` (propriétaire `<OWNER>`) \| tableau GitLab `<BOARD_ID>` \| aucun |
| Identifiants du tableau | projet `<PROJECT_ID>`, champ Status `<FIELD_ID>`, options : À faire `<id>`, En cours `<id>`, En revue `<id>`, Bloqué `<id>`, Terminé `<id>` |

## Autorisation
- **Activation et créations** : accordées par le CEO le AAAA-MM-JJ (décision `D-xxx`).
- **Synchronisation automatique** (déplacements et fermetures des tickets existants après un
  changement de statut d'une story) : autorisée | non autorisée.

## Correspondance
| Story | Ticket | URL | Créé le |
|---|---|---|---|
| US-001 | #1 | <url> | AAAA-MM-JJ |

## Journal
| Date | Par | Mode | Actions | Résultat |
|---|---|---|---|---|
| AAAA-MM-JJ HH:MM | <initiales> | appliquer | 5 créations, 0 déplacement, 0 fermeture | 5 / 5 réussies |
