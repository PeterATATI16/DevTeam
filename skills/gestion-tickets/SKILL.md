---
name: gestion-tickets
description: "Synchronisation du backlog (docs/backlog.md) avec les tickets GitHub ou GitLab : création, mise à jour, déplacement sur le tableau selon le statut, fermeture. À utiliser pour publier ou tenir à jour les tickets d'un projet."
---

# Gestion des tickets GitHub et GitLab

Le backlog `docs/backlog.md` est la **source de vérité**. Les tickets en sont le reflet :
on modifie le backlog, puis on synchronise. On ne modifie jamais le backlog à partir d'un
ticket, sauf pour y noter le numéro du ticket.

## 1. Détecter la plateforme

```bash
git remote get-url origin
```

| L'URL contient | Plateforme | Outil | Connexion |
|---|---|---|---|
| `github.com` (ou GitHub Enterprise) | GitHub | `gh` | `gh auth status` |
| `gitlab` (gitlab.com ou instance interne) | GitLab | `glab` | `glab auth status` |

- Si `docs/tickets.md` fixe déjà la plateforme, elle l'emporte.
- Outil absent : indiquer `brew install gh` ou `brew install glab` (sinon le site officiel).
- Non connecté : indiquer `gh auth login` ou `glab auth login`. **Jamais** de jeton ni de
  mot de passe saisi ou stocké par l'agent.
- Commandes exactes par plateforme : [references/github.md](references/github.md) et
  [references/gitlab.md](references/gitlab.md). En cas d'erreur de syntaxe, vérifier avec
  `gh <commande> --help` ou `glab <commande> --help` avant de réessayer.

## 2. Correspondance backlog et tickets

| Backlog | Ticket |
|---|---|
| `US-012 : Déclarer un sinistre` | Titre `US-012 : Déclarer un sinistre` |
| « En tant que… », critères, dépendances, règles | Description (modèle `templates/ticket.md`) |
| Priorité Must / Should / Could / Won't | Label `priorite::must` … `priorite::wont` |
| Tags `[back]` `[front]` `[mobile]` `[devops]` | Labels `perimetre::back` … |
| Estimation S / M / L / XL | Label `estimation::s` … |
| Sprint N | Milestone `Sprint N` |
| Statut | Label `statut::…`, colonne du tableau, ouvert ou fermé (section 3) |

Les mêmes noms de labels servent sur les deux plateformes. Sur GitLab, la forme `clé::valeur`
crée des labels exclusifs : un ticket n'a qu'un seul `statut::…` à la fois. Sur GitHub, l'agent
retire lui-même l'ancien label de statut.

## 3. Statuts et déplacements

| Statut du backlog | Label | Colonne du tableau | État du ticket |
|---|---|---|---|
| À faire | `statut::a-faire` | À faire | ouvert |
| En cours | `statut::en-cours` | En cours | ouvert |
| En revue | `statut::en-revue` | En revue | ouvert |
| Bloqué | `statut::bloque` | Bloqué | ouvert + commentaire « Bloqué : <cause> » |
| Terminé | `statut::termine` | Terminé | **fermé** (terminé) + commentaire de clôture |
| Won't | `priorite::wont` | aucune | **fermé** (non planifié) + justification |

Commentaire de clôture d'une story terminée :
```
Story terminée.
- Revue : docs/reviews/US-012.md (APPROUVÉ, itération 2)
- QA : docs/qa/US-012.md (VALIDÉ)
- Merge request : <lien si connue>
```

- **Tableau GitLab** : un tableau avec une liste par label `statut::…` déplace les cartes
  automatiquement quand le label change. L'agent crée ces listes à l'activation si elles
  n'existent pas.
- **Tableau GitHub** : si un projet (Projects) est configuré dans `docs/tickets.md`, l'agent
  ajoute chaque ticket au projet et met à jour son champ « Status ». Sans projet, les labels
  suffisent.
- Un ticket **rouvert à tort** (story pas terminée) est rouvert, avec un commentaire.
- Un ticket présent sur la plateforme mais **absent du backlog** n'est jamais supprimé :
  il est signalé dans le rapport.

## 4. Fichier de suivi `docs/tickets.md`

Créé à l'activation (modèle `templates/tickets.md`). Il contient :
- la plateforme, le dépôt, le projet ou tableau éventuel ;
- l'autorisation de synchronisation donnée par le CEO (date, référence `D-xxx`) ;
- la table de correspondance `US-xxx` ↔ numéro et URL du ticket, dernier statut synchronisé ;
- le journal des synchronisations.

Dans `docs/backlog.md`, sous chaque story, l'agent renseigne seulement la ligne
`**Ticket** : #12`.

## 5. Synchronisation en deux temps (obligatoire)

1. **Plan** (aucun appel en écriture) : comparer le backlog, `docs/tickets.md` et l'état réel
   des tickets (lecture par `gh` ou `glab`). Produire la liste exacte des actions :
   créer, modifier, déplacer, fermer, rouvrir, avec la commande prévue pour chacune.
2. **Application**, seulement après accord :
   - la **première activation** et toute **création** de tickets exigent l'accord explicite de
     l'utilisateur (ou du CEO via le COO) ;
   - une fois l'activation autorisée et notée dans `docs/tickets.md`, les **déplacements et
     fermetures** des tickets existants qui suivent un changement de statut du backlog sont
     couverts par cette autorisation.
   - Exécuter les actions une par une, s'arrêter à la première erreur, noter le résultat.

**Idempotence** : relancer la synchronisation sans changement du backlog ne produit aucune
action. On retrouve un ticket par la table de correspondance, sinon par son titre `US-xxx`.

## 6. Règles de contenu
- Contenu en français, sans tiret long, sans emoji, sans mention d'IA ni d'outil de génération.
- Aucune donnée personnelle réelle, aucun secret dans un ticket ou un commentaire.
- Les critères d'acceptation deviennent des cases à cocher `- [ ]`, cochées `- [x]` quand la QA
  les a validés.

## Checklist
1. [ ] Plateforme détectée, outil installé, connexion vérifiée.
2. [ ] Le plan liste chaque action avec sa commande, avant toute écriture.
3. [ ] Aucune création sans accord explicite ; autorisation de synchronisation notée.
4. [ ] Chaque story a un seul label `statut::…`, cohérent avec le backlog.
5. [ ] Stories terminées : ticket fermé avec commentaire de clôture.
6. [ ] `docs/tickets.md` et la ligne `**Ticket**` du backlog sont à jour.
7. [ ] Une seconde synchronisation à vide ne produit aucune action.
