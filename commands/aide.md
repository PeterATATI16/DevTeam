---
description: "Explique l'équipe virtuelle devteam, ses commandes et le déroulé type d'un projet."
argument-hint: "[commande]"
---

# /devteam:aide

Affiche à l'utilisateur l'aide ci-dessous, en français, de façon lisible. Si un argument
est fourni (`$ARGUMENTS`), détaille seulement la commande correspondante. N'appelle
aucun agent.

## Mode CEO (le plus simple)
Vous êtes le CEO et vous ne parlez qu'au COO, en langage naturel. Pour l'activer :
`{ "agent": "devteam:coo" }` dans `.claude/settings.json` du projet, ou `claude --agent devteam:coo`,
ou `/devteam:coo` dans la session en cours. Aucune autre commande n'est nécessaire.

## L'équipe
| Rôle | Agent | Livrables |
|---|---|---|
| Business Analyst | `devteam:business-analyst` | `docs/specs.md`, `docs/backlog.md` |
| Product Owner | `devteam:product-owner` | priorités MoSCoW, MVP, sprints |
| Architecte | `devteam:architecte` | `docs/architecture.md`, `docs/adr/`, `CLAUDE.md` |
| Designer UX/UI | `devteam:ux-ui-designer` | `docs/maquettes/` |
| Dev backend | `devteam:dev-backend` | API, BD, logique métier + tests |
| Dev frontend | `devteam:dev-frontend` | interfaces web + tests |
| Dev mobile | `devteam:dev-mobile` | écrans Flutter (par défaut) + tests |
| Tech lead | `devteam:tech-lead-reviewer` | `docs/reviews/<story>.md` (lecture seule) |
| QA | `devteam:qa-testeur` | tests, `docs/qa/<story>.md` |
| Expert cybersécurité | `devteam:expert-cybersecurite` | audit `docs/securite/<cible>.md` (lecture seule) |
| DevOps | `devteam:devops` | Docker, `.gitlab-ci.yml`, déploiement |
| Rédacteur technique | `devteam:redacteur-technique` | README, `docs/api.md`, CHANGELOG |
| Chef de projet | `devteam:chef-de-projet` | `docs/suivi.md` |

## Les commandes
| Commande | Rôle |
|---|---|
| `/devteam:nouveau-projet <besoin>` | BA → PO → ✋ → Architecte → ✋ → Designer |
| `/devteam:sprint [n]` | Toutes les stories du sprint : dev → revue → QA (3 itérations max) |
| `/devteam:story <id>` | La même boucle pour une seule story |
| `/devteam:review [fichiers\|branche]` | Revue de code seule |
| `/devteam:tests [id]` | QA seul |
| `/devteam:securite [id\|branche\|tout]` | Audit de sécurité seul |
| `/devteam:deploy [env]` | DevOps, confirmation avant toute action irréversible |
| `/devteam:doc [périmètre]` | Documentation |
| `/devteam:statut` | Point d'avancement |
| `/devteam:coo [instruction]` | Mode CEO : la session devient le COO |
| `/devteam:aide [commande]` | Cette aide |

## Déroulé type
1. `/devteam:nouveau-projet "Application de gestion des sinistres…"` → valider specs, puis architecture.
2. `/devteam:sprint 1` (ou `/devteam:story US-001` pour avancer story par story).
3. `/devteam:statut` régulièrement.
4. `/devteam:securite tout`, puis `/devteam:doc`, puis `/devteam:deploy staging`.
5. Sprint suivant.

## Standards imposés à tous les agents
| Skill | Contenu | Utilisée par |
|---|---|---|
| `clean-code` | simplicité, lisibilité, générique au bon moment (règle de trois) | développeurs, architecte, QA, DevOps |
| `clean-architecture` | couches, emplacement des fichiers, `shared/`, proportionnalité | développeurs, architecte |
| `code-review` | grille et format Bloquant / À améliorer / Suggestion | tech lead, expert cybersécurité |
| `style-equipe` | aucun tiret long, aucune interface au « look IA », organisation stricte | tous les agents |

## Principes
- Les agents ne se parlent pas directement : ils échangent par les fichiers de `docs/`
  et le `CLAUDE.md` du projet. La session principale orchestre.
- Points de validation humaine (✋) : après les specs, après l'architecture, avant un
  sprint, après 3 itérations sans succès, avant toute action irréversible.
- Aucun agent ne pousse de code ni ne déploie sans votre accord.
- Coût : préférez `/devteam:story` à `/devteam:sprint` sur de gros sprints, et les
  commandes à rôle unique (`review`, `tests`, `doc`, `statut`) quand c'est suffisant.
