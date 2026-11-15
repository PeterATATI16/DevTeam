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
- Branches `US-xxx-slug`, commits en français sans préfixe de type (`feat:`…) ni ligne
  d'attribution `Co-Authored-By`, sans mention d'IA (skill `conventions-git`).
- Tests obligatoires pour chaque critère d'acceptation ; couverture ≥ 80 % sur le code métier.
- Secrets uniquement via variables d'environnement (`.env.example` à jour).
- Standards de code : skills devteam `clean-code` (simplicité, lisibilité, générique au bon moment)
  et `clean-architecture` (couches domain, application, infrastructure, presentation, shared).
- Avant d'écrire du code, chercher une brique réutilisable dans `src/shared/`.
- Style (skill `style-equipe`) : aucun tiret long dans le texte, le code ou l'interface ;
  aucune interface au « look IA » (dégradés violets, verre dépoli, emojis comme icônes).

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
| docs/securite/ | Audits de sécurité | expert-cybersecurite |
| docs/rapports-coo/ | Comptes rendus au CEO | coo |
| docs/decisions-ceo.md | Journal des décisions du CEO | coo |
| docs/tickets.md, docs/tickets/ | Tickets GitHub ou GitLab, correspondance et journal | gestionnaire-tickets |
