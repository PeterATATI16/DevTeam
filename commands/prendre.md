---
description: "Réserve une story pour soi (mode équipe) : vérifie qu'elle est libre, crée et pousse sa branche, s'assigne le ticket. Sans argument, prend la prochaine story libre du sprint."
argument-hint: "[US-xxx]"
---

# /devteam:prendre

Tu es l'orchestrateur devteam. Lis et applique `${CLAUDE_PLUGIN_ROOT}/skills/travail-en-equipe/SKILL.md`
(section 4) et ses commandes `${CLAUDE_PLUGIN_ROOT}/skills/travail-en-equipe/references/commandes.md`.

Story demandée : **$ARGUMENTS** (si vide : la prochaine story libre).

## Étapes
1. Si `docs/direction/equipe.md` n'existe pas : explique que la réservation sert au travail à
   plusieurs, propose `/devteam:equipe`, puis continue simplement avec `/devteam:story`.
2. Identifie l'utilisateur (`git config user.email`) dans `docs/direction/equipe.md`. Inconnu :
   propose `/devteam:equipe ajouter` et arrête-toi.
3. Vérifie que l'arbre git est propre. Sinon, demande quoi faire de ses changements.
4. `git fetch origin --prune`. Lis `docs/produit/backlog.md` et `docs/produit/stories/` sur
   `origin/<principale>`.
5. Choisis ou vérifie la story : statut durable `À faire`, dépendances `Terminé`, libre
   (aucune personne assignée sur son ticket, aucune branche distante `US-xxx-*`). Pour une
   story demandée mais déjà prise, dis par qui et propose la suivante libre.
6. Vérifie la limite de stories en cours de l'utilisateur. Si elle est atteinte, liste ses
   stories en cours et propose de livrer d'abord.
7. Annonce en une ligne ce que tu vas faire (branche, commit de réservation, poussée, ticket
   assigné), puis réserve : branche `US-xxx-<slug>` depuis `origin/<principale>`, commit
   `Réservation de US-xxx par <nom>` (responsable dans le fichier de la story), `git push -u`
   **sans forcer**, ticket assigné à l'utilisateur en `statut::en-cours` (si `docs/gestion-projet/tickets.md`
   existe). L'utilisateur qui lance cette commande autorise ces actions.
   Si la poussée est refusée, la story vient d'être prise : supprime ta branche locale et
   recommence à l'étape 5.
8. Contrôle de la course (`git ls-remote --heads origin "US-xxx-*"`). Si une autre branche
   existe pour la même story, compare les dates des commits de réservation : la plus ancienne
   gagne. Si ce n'est pas la tienne, libère-la et recommence à l'étape 5.
9. Confirme : « US-xxx réservée par <nom>, branche `US-xxx-…` ». Propose d'enchaîner avec
   `/devteam:story US-xxx`.
