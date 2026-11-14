---
name: clean-architecture
description: "À utiliser pour concevoir un nouveau projet, un module ou une fonctionnalité, et pour décider où placer un fichier."
---

# Clean architecture : où va chaque chose

Objectif : une structure claire, où chaque fichier a une place évidente et où le métier
ne dépend d'aucun framework. Toujours appliquée **avec proportionnalité** (voir section 5).

## 1. Règle de dépendance

```
presentation  ──►  application  ──►  domain  ◄──  infrastructure
```

- Les dépendances pointent **vers le domaine**, jamais l'inverse.
- `domain` n'importe **aucun** framework, ORM, client HTTP ni bibliothèque d'infrastructure.
- `application` ne connaît que `domain` (et `shared`).
- `infrastructure` et `presentation` dépendent des couches internes, jamais entre elles
  pour la logique métier.

| ❌ À éviter | ✅ À faire |
|---|---|
| `import { Entity } from 'typeorm'` dans `domain/` | Entité pure dans `domain/`, mapping ORM dans `infrastructure/` |
| Un controller qui écrit en base | Le controller appelle un cas d'usage |
| Un cas d'usage qui appelle `axios` | Le cas d'usage appelle un port, l'adaptateur appelle `axios` |

## 2. Structure de référence

```
src/
├── domain/          # entités, value objects, interfaces (ports)
├── application/     # cas d'usage (une classe = une action métier)
├── infrastructure/  # DB, API externes, implémentations des ports
├── presentation/    # controllers, routes, UI
└── shared/          # génériques réutilisables (BaseRepository<T>, Result<T>, erreurs, utils)
```

Organisation interne : **par fonctionnalité** à l'intérieur de chaque couche dès que le
projet dépasse quelques entités.

```
src/domain/sinistre/{sinistre.ts, statut-sinistre.ts, sinistre.repository.ts}
src/application/sinistre/{declarer-sinistre.ts, valider-indemnisation.ts}
src/infrastructure/sinistre/{sinistre.pg-repository.ts}
src/presentation/sinistre/{sinistre.controller.ts}
```

### Où placer un fichier ?

| Le fichier contient… | Dossier |
|---|---|
| Une règle métier, une entité, un value object | `domain/` |
| Une interface vers l'extérieur (repository, notifieur, paiement) | `domain/` (port) |
| Une action métier qui orchestre (déclarer, valider, clôturer) | `application/` |
| SQL, ORM, appel HTTP, fichiers, file de messages | `infrastructure/` |
| Route, controller, validation d'entrée HTTP, écran, composant | `presentation/` |
| Un générique sans métier, réutilisé ≥ 2 fois | `shared/` |
| Configuration, injection des dépendances | racine (`main`, `container`) |

## 3. Ports, adaptateurs, injection, DTO

- **Port** : une interface déclarée par le domaine (`SinistreRepository`, `Notifieur`).
- **Adaptateur** : son implémentation technique dans `infrastructure/` (`PgSinistreRepository`).
- **Injection de dépendances** : les cas d'usage reçoivent leurs ports par le constructeur.
  On assemble tout en un seul endroit (point d'entrée ou conteneur).
- **DTO aux frontières** : `presentation` reçoit et renvoie des DTO ; les entités du
  domaine ne sortent jamais telles quelles d'une API.
- Les mappers (`toDto`, `toDomain`) sont des fonctions simples, réutilisables, testées.

## 4. Le dossier `shared/`

- Contient les **briques génériques** : `BaseRepository<T>`, `Result<T>`, `ApiResponse<T>`,
  `paginate<T>()`, erreurs de base, validateurs, mappers génériques, utilitaires de date.
- C'est **le premier endroit à consulter** avant d'écrire du nouveau code.
- Il ne contient **aucune** règle métier. Une brique qui parle de « sinistre » n'est pas
  dans `shared/`.
- On y place une brique quand la règle de trois est atteinte (skill `clean-code`).

## 5. Proportionnalité

Ne jamais ajouter une couche qui n'apporte rien.

| Taille du projet | Structure |
|---|---|
| Script, outil ponctuel | un fichier ou `src/` + `tests/` |
| Petit CRUD sans règle métier | `src/{routes, services, shared}` (2 ou 3 dossiers) |
| Application avec règles métier | structure complète à 5 dossiers |
| Plusieurs domaines | structure complète, découpée par fonctionnalité |

- ❌ À éviter : 5 couches, des ports et un conteneur d'injection pour une API de 3 routes.
- ✅ À faire : commencer allégé, et extraire `domain/` quand les règles métier apparaissent.
- Tout écart à la structure de référence est noté dans `docs/architecture.md` (ou un ADR).

## 6. Exemple complet d'un cas d'usage

Voir [references/exemple-cas-usage.md](references/exemple-cas-usage.md) : entité, port,
cas d'usage, adaptateur et controller pour « Déclarer un sinistre », en TypeScript.

## Checklist

1. [ ] `domain/` n'importe aucun framework.
2. [ ] Chaque cas d'usage est une classe, une action métier, avec ses ports injectés.
3. [ ] Toute dépendance externe passe par un port et un adaptateur.
4. [ ] Les API exposent des DTO, jamais des entités.
5. [ ] Les génériques sont dans `shared/`, sans métier.
6. [ ] Le nombre de couches est proportionné au projet.
7. [ ] Chaque fichier est à la place indiquée par le tableau « Où placer un fichier ? ».
