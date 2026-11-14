---
name: code-review
description: "À utiliser pour relire du code produit par un agent ou un humain."
---

# Revue de code : grille de l'équipe

La revue vérifie que le code respecte les skills `clean-code` et `clean-architecture`,
puis la sécurité (détail OWASP dans la skill `code-review-checklist`).
On signale **autant la sur-ingénierie que la duplication** : les deux nuisent à la lisibilité.

## 1. Grille de revue

### Simplicité
- [ ] La solution est la plus simple qui réponde au besoin (KISS).
- [ ] Rien n'est construit pour un besoin hypothétique (YAGNI).
- [ ] Aucun code « astucieux » là où du code direct suffit.

### Généricité (dans les deux sens)
- [ ] **Duplication** : aucune logique métier dupliquée ; un motif présent 3 fois est factorisé.
- [ ] Les briques existantes de `shared/` sont réutilisées au lieu d'être réécrites.
- [ ] **Sur-ingénierie** : aucune abstraction à usage unique (interface sans deuxième
      implémentation prévue, factory pour un seul type, couche qui ne fait que déléguer).
- [ ] Chaque générique est plus simple à lire que le code dupliqué qu'il remplace.

### Nommage
- [ ] Fonctions = verbes, classes = noms, booléens = questions.
- [ ] Aucune abréviation, aucun nom vague (`data`, `manager`, `util2`).

### Structure
- [ ] Fonctions courtes (environ 20 lignes), une responsabilité, 3 paramètres au plus.
- [ ] Retours anticipés plutôt que `if` imbriqués ; pas d'effet de bord caché.
- [ ] Classes cohérentes, faiblement couplées, composition plutôt qu'héritage.

### Respect des couches
- [ ] `domain/` n'importe aucun framework.
- [ ] Les controllers appellent des cas d'usage ; ils n'accèdent pas à la base.
- [ ] Les dépendances externes passent par des ports et des adaptateurs.
- [ ] Les API exposent des DTO, pas des entités.
- [ ] Chaque fichier est dans le bon dossier ; le nombre de couches est proportionné.

### Tests
- [ ] Chaque critère d'acceptation a un test, y compris les cas d'erreur.
- [ ] Les cas d'usage sont testés sans infrastructure réelle.
- [ ] Aucun test désactivé ou affaibli.

### Gestion des erreurs
- [ ] Exceptions typées ; aucun `catch` vide ; aucun `null` injustifié.
- [ ] Erreurs techniques traduites en erreurs métier à la frontière.
- [ ] Gestion centralisée côté API (pas un `try/catch` par route).

### Sécurité
- [ ] Points OWASP de la skill `code-review-checklist` vérifiés.

### Style et organisation
- [ ] Règles de la skill `style-equipe` respectées (aucun tiret long, UI sans tics « IA »).

## 2. Sévérités

| Sévérité | Quand l'utiliser |
|---|---|
| **Bloquant** | Faille de sécurité, bug, critère d'acceptation non respecté, test manquant sur un critère, violation de la règle de dépendance, logique métier dupliquée, secret dans le code. |
| **À améliorer** | Sur-ingénierie, fonction trop longue, nommage trompeur, mauvais dossier, gestion d'erreur faible, duplication technique répétée. |
| **Suggestion** | Amélioration de lisibilité facultative, alternative plus simple, détail de style. |

**Verdict** : **À CORRIGER** s'il existe au moins un Bloquant ou plus de 3 « À améliorer » ;
sinon **APPROUVÉ**.

## 3. Format de sortie (fixe)

Chaque point contient : identifiant, fichier, ligne, problème, correction proposée.

```markdown
## Bloquant
- **R-01** `src/presentation/sinistre/sinistre.controller.ts:42`
  - Problème : le controller exécute une requête SQL ; la règle de dépendance est violée.
  - Correction proposée : déplacer la requête dans `PgSinistreRepository` et appeler le cas
    d'usage `DeclarerSinistre`.

## À améliorer
- **R-02** `src/shared/sinistre-validator-factory.ts:1`
  - Problème : sur-ingénierie. Une factory et une interface pour un seul validateur.
  - Correction proposée : remplacer par une fonction `validerSinistre()` ; factoriser quand
    un deuxième cas apparaîtra.
- **R-03** `src/application/contrat/lister-contrats.ts:18`
  - Problème : pagination recopiée pour la troisième fois.
  - Correction proposée : utiliser `paginate<T>()` de `shared/`.

## Suggestion
- **R-04** `src/domain/sinistre/sinistre.ts:12`
  - Problème : `chk()` n'exprime pas l'intention.
  - Correction proposée : renommer en `estCouvertA(date)`.
```

S'il n'y a rien dans une catégorie, écrire « Aucun point. » sous son titre.

## 4. Règles du relecteur

- Chaque remarque est **actionnable** : une correction précise, pas « à revoir ».
- On juge le code, pas l'auteur.
- On ne bloque pas pour une préférence personnelle : c'est une Suggestion.
- On ne corrige pas soi-même : on décrit la correction.
- Dans une itération suivante, on vérifie d'abord chaque Bloquant précédent.
