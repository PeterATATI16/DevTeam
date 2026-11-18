---
name: style-equipe
description: "À utiliser pour tout livrable (texte, documentation, code, maquette, interface). Interdit les tics d'écriture et de design typiques des IA et impose une organisation rigoureuse."
---

# Style de l'équipe : rigueur, sobriété, organisation

Ces règles s'appliquent à **tous** les agents et à **tous** les livrables : documents de
`docs/`, code, commentaires, messages de commit, maquettes et interfaces.
Elles ne sont pas négociables.

## 1. Interdictions formelles à l'écrit

### Tirets longs
- **Interdit** : le tiret cadratin `—` et le tiret demi-cadratin `–`, partout
  (texte, titres, tableaux, commentaires, libellés d'interface, commits).
- On les remplace par la ponctuation normale : virgule, deux-points, parenthèses, point.
- Seul le trait d'union `-` est autorisé (mots composés, listes, plages `1-3`, options CLI).

| ❌ À éviter | ✅ À faire |
|---|---|
| `US-012 — Déclarer un sinistre` | `US-012 : Déclarer un sinistre` |
| `Le module est prêt — il reste les tests.` | `Le module est prêt. Il reste les tests.` |
| `Sprint 1 – Socle technique` | `Sprint 1 : socle technique` |
| `R-03 — BLOQUANT — controller.ts:42` | `R-03 \| Bloquant \| controller.ts:42` |

Le hook du plugin signale tout tiret long écrit dans un fichier : il doit être corrigé
immédiatement.

### Autres tics à bannir
- Emojis décoratifs dans les titres, le code, les commits ou l'interface.
  Tolérés seulement comme marqueurs fonctionnels : tableaux de statut (✅ ❌) et
  rubriques du rapport COO (✅ 🔄 ⛔ ❓ ⚠️ ➡️), dont le format est fixe.
- Formules creuses : « Il est important de noter que », « N'hésitez pas à »,
  « Plongeons dans », « En somme », « robuste et évolutif », « solution complète ».
- Gras sur une phrase sur deux : le gras est réservé à un mot clé par paragraphe au plus.
- Listes de trois adjectifs pour faire riche (« simple, rapide et intuitif »).
- Introductions et conclusions qui répètent le contenu.
- Points d'exclamation dans la documentation technique.

## 2. Écrire clair

- Phrases courtes : une idée par phrase.
- Le fait d'abord, l'explication ensuite.
- Chiffres et noms précis plutôt qu'adjectifs (« 200 ms » et non « rapide »).
- Vocabulaire du glossaire de `docs/produit/specs.md`, identique partout.

## 3. Organisation obligatoire

### Documents
- Chaque document suit **son modèle** de `templates/`, sections dans l'ordre, sans en
  supprimer. Une section sans contenu porte la mention « Sans objet » ou « Aucun point. ».
- Titres hiérarchisés sans saut de niveau (`#`, puis `##`, puis `###`).
- Un document = un sujet. Au-delà de 300 lignes, on découpe et on relie.
- Les identifiants sont stables et uniques : `US-001`, `EF-01`, `RG-01`, `R-01`, `QA-01`, ADR `0001`.
- Chaque livrable indique en tête : auteur (rôle), date, version ou itération, statut.

### Fichiers et dossiers
- Noms en `kebab-case`, sans accents ni espaces (`declarer-sinistre.ts`, `0003-choix-postgresql.md`).
- Chaque fichier est à sa place (skill `clean-architecture`, section « Où placer un fichier ? »).
- Pas de fichier fourre-tout (`misc`, `divers`, `utils2`, `new`, `final-v2`).
- Pas de fichier temporaire ou de brouillon laissé dans le dépôt.

### Classement de `docs/` par département
`docs/` est rangé par département, comme une entreprise. **Rien à la racine de `docs/`**, à
part le plan de classement `docs/README.md` (modèle `templates/docs-README.md`).

| Département | Contenu |
|---|---|
| `docs/direction/` | `decisions-ceo.md`, `equipe.md`, `rapports-coo/<auteur>/` |
| `docs/gestion-projet/` | `suivi.md`, `etat-equipe.md`, `tickets.md`, `tickets/` |
| `docs/produit/` | `specs.md`, `backlog.md`, `stories/` |
| `docs/architecture/` | `architecture.md`, `adr/` |
| `docs/design/` | `maquettes/` |
| `docs/qualite/` | `revues/`, `qa/` |
| `docs/securite/` | audits de sécurité |
| `docs/exploitation/` | `deploiement.md` |
| `docs/documentation/` | `api.md` |

Un nouveau document va dans le département de son auteur. S'il n'entre dans aucun, on ne
crée pas de fichier à la racine : on le signale à l'orchestrateur. Ancienne organisation
détectée (fichiers à la racine de `docs/`) : proposer `/devteam:organiser`.

### Réponse à l'orchestrateur
- Toujours le format de sortie défini dans le prompt de l'agent, rien de plus.
- Liste des fichiers produits avec leur chemin exact.

## 4. Interfaces et maquettes : pas de « look IA »

Une interface doit ressembler à un produit conçu pour **ce** métier, pas à un gabarit
généré. Les tics visuels interdits et les règles à appliquer sont détaillés dans
[references/ui-sans-look-ia.md](references/ui-sans-look-ia.md). À lire **avant** toute
maquette, tout écran ou tout composant.

En résumé :
- ❌ dégradés violet/indigo, verre dépoli, ombres et halos partout, emojis comme icônes,
  « hero » centré avec titre géant, grilles de cartes identiques, coins très arrondis
  partout, textes de remplissage marketing.
- ✅ design system du projet, palette sobre et justifiée, hiérarchie par la typographie
  et l'espacement, densité adaptée au métier, vrais libellés et vraies données d'exemple,
  composants cohérents d'un écran à l'autre.

## Checklist avant de rendre un livrable

1. [ ] Aucun `—` ni `–` dans les fichiers produits ou modifiés.
2. [ ] Aucun emoji décoratif, aucune formule creuse.
3. [ ] Le document suit son modèle, sections dans l'ordre, en-tête renseigné.
4. [ ] Les fichiers sont nommés en `kebab-case` et rangés au bon endroit.
5. [ ] Pour une interface : la checklist de `references/ui-sans-look-ia.md` est validée.
