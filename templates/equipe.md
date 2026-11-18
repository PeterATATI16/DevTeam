# Équipe du projet

> Ce fichier active le **mode équipe** de devteam. Il se modifie par merge request.
> Skill de référence : `travail-en-equipe`.

## Règles
| Paramètre | Valeur |
|---|---|
| Branche principale | `main` |
| Décideur (CEO) | <nom> |
| Stories en cours par personne (maximum) | 2 |
| Approbations humaines par merge request | 1 |
| Réservation des stories | tickets (si `docs/tickets.md` existe) et branches distantes |

## Membres
| Nom | Initiales | E-mail git | Identifiant plateforme | Rôles | Peut fusionner |
|---|---|---|---|---|---|
| <Prénom Nom> | PA | <email utilisé par git config user.email> | @<login> | décideur, dev-backend | oui |
| <Prénom Nom> | | | @<login> | dev-frontend | non |

Rôles possibles : décideur, product-owner, architecte, designer, dev-backend, dev-frontend,
dev-mobile, qa, devops.

## Propriétaires des fichiers partagés
| Fichiers | Propriétaire | Relecture obligatoire |
|---|---|---|
| `docs/specs.md`, `docs/stories/` (création) | product-owner ou décideur | décideur |
| `docs/backlog.md` | product-owner | décideur |
| `docs/architecture.md`, `docs/adr/` | architecte | décideur |
| `docs/equipe.md`, `CODEOWNERS`, `.gitattributes` | décideur | décideur |
