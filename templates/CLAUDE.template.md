# <Nom du projet>

<Une phrase : ce que fait l'application et pour qui.>

## Stack
- Backend : …
- Base de données : …
- Frontend : …
- Mobile : …
- CI/CD : GitLab CI (`.gitlab-ci.yml`)

## Commandes
| Action | Commande |
|---|---|
| Installer | `…` |
| Lancer en local | `docker compose up` |
| Tests | `…` |
| Lint | `…` |
| Formatage | `…` |
| Build | `…` |

## Structure
```
backend/   …
frontend/  …
mobile/    …
docs/      mémoire partagée de l'équipe devteam
```

## Conventions
- Code et identifiants en anglais, documentation et messages utilisateur en français.
- Branches `feature/US-xxx-slug`, commits Conventional Commits (skill `conventions-git`).
- Tests obligatoires pour chaque critère d'acceptation ; couverture ≥ 80 % sur le code métier.
- Secrets uniquement via variables d'environnement (`.env.example` à jour).

## Mémoire partagée (docs/)
| Fichier | Contenu | Auteur |
|---|---|---|
| docs/specs.md | Cahier des charges | business-analyst |
| docs/backlog.md | Stories, priorités, sprints, statuts | BA, PO, devs |
| docs/architecture.md | Architecture, données, API | architecte |
| docs/adr/ | Décisions d'architecture | architecte |
| docs/maquettes/ | Maquettes HTML/CSS | ux-ui-designer |
| docs/reviews/ | Rapports de revue | tech-lead-reviewer |
| docs/qa/ | Rapports de test | qa-testeur |
| docs/suivi.md | Avancement, risques | chef-de-projet |
