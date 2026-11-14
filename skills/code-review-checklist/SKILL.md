---
name: code-review-checklist
description: Checklist détaillée de revue de code (sécurité OWASP Top 10, exactitude, qualité, conventions, performance, tests) avec règles de sévérité et de verdict. À utiliser pour relire un diff ou une story.
---

# Checklist de revue de code

## Sévérités et verdict
- **BLOQUANT** : sécurité, bug, critère d'acceptation non respecté, test manquant sur un
  critère, violation d'architecture/ADR, secret versionné.
- **MAJEUR** : maintenabilité, performance, gestion d'erreur insuffisante.
- **MINEUR** : style, nommage, suggestion.
- Verdict **À CORRIGER** si ≥ 1 BLOQUANT ou > 3 MAJEURS ; sinon **APPROUVÉ**.

## 1. Exactitude fonctionnelle
- [ ] Chaque critère Given/When/Then de la story est implémenté.
- [ ] Les règles de gestion (RG-xx) sont respectées, y compris les limites.
- [ ] Les cas d'erreur renvoient le comportement attendu (code HTTP, message).

## 2. Sécurité (OWASP Top 10 — 2021)
- [ ] **A01 Contrôle d'accès** : autorisation vérifiée côté serveur sur chaque ressource
      (pas d'IDOR : l'utilisateur ne peut accéder qu'à ses données).
- [ ] **A02 Cryptographie** : mots de passe en bcrypt/argon2, TLS supposé, pas d'algorithme obsolète.
- [ ] **A03 Injection** : requêtes paramétrées, pas d'`eval`, échappement des sorties HTML,
      pas de commande shell construite avec des entrées.
- [ ] **A04 Conception** : limites de débit, validation des montants/quantités, workflow non contournable.
- [ ] **A05 Configuration** : pas de mode debug en prod, en-têtes de sécurité, CORS restreint.
- [ ] **A06 Composants** : dépendances à jour, sans vulnérabilité connue, versions épinglées.
- [ ] **A07 Authentification** : sessions/jetons expirants, pas d'énumération de comptes.
- [ ] **A08 Intégrité** : désérialisation sûre, téléchargements vérifiés.
- [ ] **A09 Journalisation** : événements de sécurité tracés, **aucune** donnée personnelle
      ni secret dans les logs.
- [ ] **A10 SSRF** : URL externes fournies par l'utilisateur validées par liste blanche.
- [ ] Aucun secret, jeton ou mot de passe en dur ; fichiers `.env` non versionnés.
- [ ] Téléversements : type, taille et nom de fichier contrôlés.

## 3. Qualité et lisibilité
- [ ] Fonctions courtes, une responsabilité ; noms explicites.
- [ ] Pas de duplication évitable, pas de code mort ni commenté.
- [ ] Erreurs gérées explicitement, pas de `catch` vide.
- [ ] Pas de nombre ou chaîne magique (constantes nommées).

## 4. Conventions
- [ ] Respect de `CLAUDE.md` (structure, nommage, formatage) et des ADR.
- [ ] Commits Conventional Commits, branche `feature/US-xxx-…`.
- [ ] Le linter et le formateur passent.

## 5. Performance
- [ ] Pas de requête N+1 ; index pour les filtres fréquents.
- [ ] Pagination sur les listes.
- [ ] Pas d'opération bloquante coûteuse dans une requête synchrone.
- [ ] Front : pas de re-rendus inutiles, images optimisées.

## 6. Tests
- [ ] Chaque critère d'acceptation a un test ; cas d'erreur couverts.
- [ ] Tests lisibles (Arrange / Act / Assert), déterministes, indépendants.
- [ ] Aucun test désactivé ou affaibli.

## 7. Données et migrations
- [ ] Migrations réversibles, sans perte de données.
- [ ] Contraintes d'intégrité (clés étrangères, unicité, non-nullité).
- [ ] Données personnelles : minimisation, durée de conservation (RGPD).

## Rédiger une remarque
```
R-03 — BLOQUANT — src/sinistres/controller.ts:42
Problème : l'endpoint GET /sinistres/:id ne vérifie pas que le sinistre appartient à l'assuré.
Pourquoi : IDOR (OWASP A01) — un assuré peut lire les sinistres d'autrui.
Correction attendue : filtrer par `assureId` de l'utilisateur authentifié ; 404 sinon ; test associé.
```
