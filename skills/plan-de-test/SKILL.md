---
name: plan-de-test
description: Stratégie de test (pyramide, niveaux, données) et matrice de traçabilité critères d'acceptation → cas de test. À utiliser pour planifier, écrire ou évaluer les tests d'une story ou d'un projet.
---

# Plan de test

## Pyramide de tests
| Niveau | Cible | Proportion | Outils typiques |
|---|---|---|---|
| Unitaires | fonctions, services, composants isolés | ~70 % | Jest/Vitest, pytest, JUnit, `flutter test` |
| Intégration | API + base de données, modules entre eux | ~20 % | Supertest, pytest + testcontainers, Spring Test |
| End-to-end | parcours utilisateur complets | ~10 % | Playwright, Cypress, `integration_test` Flutter |

Compléments selon le risque : sécurité (dépendances, SAST), accessibilité (axe),
performance (k6) sur les parcours critiques.

## Dériver les cas de test d'un critère
Pour chaque critère Given/When/Then :
1. **Nominal** : le critère tel quel.
2. **Limites** : valeurs aux bornes (0, 1, max, max + 1, vide, très long).
3. **Erreurs** : données invalides, ressource absente, droits insuffisants.
4. **Sécurité** : accès à la ressource d'un autre utilisateur, injection, non authentifié.

## Matrice de traçabilité (à inclure dans docs/qa/<story>.md)
| Critère | Cas | Type | Niveau | Fichier de test | Résultat |
|---|---|---|---|---|---|
| CA-1 | TC-01 Déclaration complète acceptée | Nominal | Intégration | `tests/api/sinistres.test.ts` | ✅ |
| CA-2 | TC-02 Contrat résilié refusé | Erreur | Intégration | idem | ✅ |
| CA-3 | TC-03 Photo de 10 Mo + 1 octet refusée | Limite | Unitaire | `tests/unit/upload.test.ts` | ❌ |
| — | TC-04 Accès au sinistre d'un autre assuré → 404 | Sécurité | Intégration | idem | ✅ |

## Données de test
- Jeux de données créés par les tests eux-mêmes (fabriques), nettoyés après.
- Aucune donnée réelle ou personnelle ; dates fixées (horloge simulée).
- Services externes simulés (mocks/stubs) ; pas d'appel réseau externe.

## Critères de sortie
- 100 % des critères d'acceptation couverts et passants.
- Aucune régression sur la suite complète.
- Couverture des lignes ≥ seuil défini dans `CLAUDE.md` (80 % par défaut sur le code métier).

## Rapporter une anomalie
```
QA-02 — Majeure — CA-3
Étapes : joindre un fichier de 10 485 761 octets à la déclaration.
Attendu : refus avant envoi avec « Taille maximale : 10 Mo ».
Obtenu : envoi accepté, erreur 500 côté serveur.
Test : tests/unit/upload.test.ts › "refuse au-delà de 10 Mo"
```
