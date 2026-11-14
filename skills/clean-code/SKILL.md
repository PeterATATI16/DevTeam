---
name: clean-code
description: "À utiliser avant d'écrire ou de modifier du code, quel que soit le langage."
---

# Clean code : les standards de l'équipe

Priorités, dans cet ordre : **simplicité, lisibilité, code générique et réutilisable,
structure claire**. En cas de conflit entre deux règles, la plus haute dans cette liste gagne.

Avant d'écrire une ligne : cherche dans `shared/` (ou l'équivalent du projet) une brique
qui fait déjà le travail. Voir la skill `clean-architecture`.

## 1. Simplicité d'abord

- **KISS** : la solution la plus simple qui répond au besoin réel.
- **YAGNI** : rien pour un besoin hypothétique. Pas d'option, de paramètre ou de couche « au cas où ».
- **Lisible plutôt qu'astucieux** : un collègue doit comprendre le code en une lecture.

```ts
// ❌ À éviter : astucieux, illisible
const ok = !!(u && u.r?.some(x => ~['admin','gest'].indexOf(x)));

// ✅ À faire : l'intention est lisible
const ROLES_AUTORISES = ['admin', 'gestionnaire'];
const peutValider = user?.roles.some(role => ROLES_AUTORISES.includes(role)) ?? false;
```

## 2. Générique, mais au bon moment

- **Règle de trois** : on rend générique quand le même motif apparaît **2 à 3 fois**, pas avant.
- Outils de généricité : types génériques, classes de base, fonctions utilitaires,
  services paramétrables.
- Exemples attendus dans `shared/` :
  - `BaseRepository<T>` : `findById`, `findAll`, `save`, `delete` communs à toutes les entités ;
  - `ApiResponse<T>` : enveloppe unique des réponses (`data`, `error`, `meta`) ;
  - `paginate<T>(items, page, size)` : pagination unique ;
  - validateurs et mappers réutilisables (`toDto`, `fromDto`) ;
  - gestion d'erreurs centralisée (un middleware ou un handler, pas un `try/catch` par route).
- **Garde-fou** : l'abstraction doit être **plus simple à lire** que le code dupliqué
  qu'elle remplace. Sinon, on ne l'introduit pas.

```ts
// ❌ À éviter : trois fonctions identiques à un type près
function paginerSinistres(list: Sinistre[], page: number) { /* ... */ }
function paginerContrats(list: Contrat[], page: number) { /* ... */ }

// ✅ À faire : une fonction générique, aussi simple à lire
function paginate<T>(items: T[], page: number, size = 20): Page<T> {
  const start = (page - 1) * size;
  return { items: items.slice(start, start + size), page, total: items.length };
}
```

```ts
// ❌ À éviter : sur-ingénierie pour un seul usage
class SinistreValidatorFactoryProvider { /* ... */ }

// ✅ À faire : une fonction suffit tant qu'il n'y a qu'un cas
function validerSinistre(sinistre: NouveauSinistre): Result<NouveauSinistre> { /* ... */ }
```

## 3. Nommage

- Les noms expriment l'intention.
- **Fonctions = verbes** : `calculerFranchise`, `envoyerNotification`.
- **Classes = noms** : `Sinistre`, `DeclarationService`.
- **Booléens = question** : `estActif`, `aDesPieces`, `peutValider`.
- Pas d'abréviation, pas de nom vague.

| ❌ À éviter | ✅ À faire |
|---|---|
| `data`, `info`, `obj`, `tmp` | `sinistre`, `montantIndemnise` |
| `manager`, `helper`, `util2` | `CalculateurFranchise`, `formaterMontant` |
| `calc()`, `proc()` | `calculerDelaiInstruction()` |
| `flag`, `check` | `estExpire`, `verifierCouverture()` |

## 4. Fonctions

- **Une seule responsabilité.** Si le nom contient « et », découpe.
- **Courtes** : environ 20 lignes au maximum.
- **0 à 3 paramètres.** Au-delà, un objet nommé.
- **Retours anticipés** plutôt que des `if` imbriqués.
- **Pas d'effet de bord caché** : une fonction `getX` ne modifie rien.

```ts
// ❌ À éviter : imbrication, 5 paramètres
function traiter(s, u, d, m, notif) {
  if (s) { if (u.actif) { if (m > 0) { /* ... */ } } }
}

// ✅ À faire : objet en paramètre, retours anticipés
function indemniser({ sinistre, gestionnaire, montant }: Indemnisation): Result<Paiement> {
  if (!gestionnaire.estActif) return Result.fail(new AccesRefuse());
  if (montant <= 0) return Result.fail(new MontantInvalide(montant));
  return Result.ok(creerPaiement(sinistre, montant));
}
```

## 5. Classes et modules

- **SOLID**, en particulier :
  - responsabilité unique : une classe a une seule raison de changer ;
  - inversion de dépendances : on dépend d'interfaces (ports), pas d'implémentations.
- **Composition plutôt qu'héritage.** L'héritage est réservé aux vraies relations « est un »
  et aux classes de base génériques (`BaseRepository<T>`).
- **Forte cohésion** : ce qui change ensemble vit ensemble.
- **Faible couplage** : un module expose peu, importe peu.

## 6. Erreurs

- **Exceptions typées** (`SinistreIntrouvable`, `ContratExpire`), jamais `throw new Error("erreur")`.
- **Jamais de `catch` vide.** On traite, on journalise ou on relance.
- **Pas de `null` retourné sans raison** : préférer `Result<T>`, `Optional<T>`, une liste vide
  ou une exception explicite.
- Les erreurs techniques sont traduites en erreurs métier à la frontière (adaptateur).

```ts
// ❌ À éviter
try { await repo.save(s); } catch (e) {}

// ✅ À faire
try {
  await repo.save(sinistre);
} catch (error) {
  throw new EnregistrementImpossible('sinistre', sinistre.id, { cause: error });
}
```

## 7. Commentaires

- Ils expliquent le **pourquoi**, jamais le **quoi**.
- Pas de code commenté : git garde l'historique.

```ts
// ❌ À éviter
// incrémente i
i++;

// ✅ À faire
// L'assureur exige 2 jours ouvrés de délai de rétractation (art. L112-9).
const DELAI_RETRACTATION_JOURS = 2;
```

## 8. DRY

- **Aucune logique métier dupliquée.** Une règle de gestion vit à un seul endroit.
- La duplication de quelques lignes techniques est tolérée tant que la règle de trois
  n'est pas atteinte.

## Checklist avant de rendre le code

1. [ ] J'ai cherché une brique existante dans `shared/` avant d'écrire.
2. [ ] La solution est la plus simple possible ; rien n'est ajouté « au cas où ».
3. [ ] Chaque nom exprime l'intention, sans abréviation ni nom vague.
4. [ ] Chaque fonction fait une chose, en environ 20 lignes et 3 paramètres au plus.
5. [ ] Pas de `if` imbriqués là où un retour anticipé suffit.
6. [ ] Aucune logique métier n'est dupliquée ; un motif répété 3 fois est factorisé.
7. [ ] Aucune abstraction n'est plus compliquée que le code qu'elle remplace.
8. [ ] Les erreurs sont typées ; aucun `catch` vide ; aucun `null` injustifié.
9. [ ] Les commentaires expliquent le pourquoi ; aucun code commenté.
10. [ ] Le linter, le formateur et les tests passent.
