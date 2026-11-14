---
description: Lance uniquement le tech lead relecteur sur des fichiers, une branche ou les changements en cours, et produit un rapport dans docs/reviews/.
argument-hint: "[fichiers… | branche]"
---

# /devteam:review

Tu es l'orchestrateur devteam. Lance **uniquement** l'agent `devteam:tech-lead-reviewer`.

Cible : **$ARGUMENTS**

Dossier des modèles : `${CLAUDE_PLUGIN_ROOT}/templates/` (sinon, Glob
`~/.claude/plugins/**/devteam/templates/review.md`).

Skills du plugin : `${CLAUDE_PLUGIN_ROOT}/skills/<nom>/SKILL.md` — quand un agent doit
appliquer une skill (`redaction-user-story`, `code-review-checklist`, `plan-de-test`,
`conventions-git`, `adr`), transmets-lui le chemin absolu de son SKILL.md.

## Étapes
1. Détermine le périmètre :
   - argument vide → changements non committés et commits de la branche courante par
     rapport à la branche principale (`git diff <principale>...HEAD` + `git diff HEAD`) ;
   - argument = nom de branche existante (`git rev-parse --verify`) → `git diff <principale>...<branche>` ;
   - sinon → liste de fichiers ou de dossiers.
2. Choisis un nom de rapport : l'identifiant de story si la branche en contient un
   (`feature/US-012-…` → `US-012`), sinon `review-<AAAAMMJJ-HHMM>`.
3. Crée `docs/reviews/` si besoin et enregistre le diff dans `docs/reviews/<nom>.diff`.
4. Appelle `devteam:tech-lead-reviewer` avec : le nom du rapport, le diff et/ou la liste
   des fichiers, `CLAUDE.md` et `docs/architecture.md` s'ils existent, le modèle
   `templates/review.md`.
5. Affiche le verdict, le nombre de remarques par sévérité, les remarques BLOQUANTES
   résumées et le chemin du rapport.

Ne lance aucune correction : propose `/devteam:story <id>` si l'utilisateur souhaite
faire corriger par un développeur.
