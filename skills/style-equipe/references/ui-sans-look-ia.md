# Interfaces sans « look IA »

Objectif : des écrans qui semblent conçus par une équipe produit qui connaît le métier,
pas produits par un générateur. S'applique aux maquettes (`docs/maquettes/`), au
frontend web et au mobile.

## 1. Tics visuels interdits

| ❌ À éviter | Pourquoi |
|---|---|
| Dégradés violet, indigo ou rose, surtout en fond de page ou sur les boutons | Signature visuelle des interfaces générées |
| Effet verre dépoli (`backdrop-filter: blur`) et cartes translucides | Décoratif, nuit au contraste |
| Ombres portées et halos lumineux sur tous les éléments | Aplatit la hiérarchie |
| Coins très arrondis partout (`border-radius` ≥ 16 px sur tout) | Effet « gabarit » |
| Emojis utilisés comme icônes (🚀 📊 ✨ 💡) | Peu professionnel, rendu variable |
| Section « hero » centrée : titre géant, sous-titre, deux boutons, illustration abstraite | Inutile dans un outil métier |
| Grille de 3 ou 6 cartes identiques « icône + titre + phrase » | Remplissage, aucune information |
| Textes marketing creux (« Boostez votre productivité ») | Le métier a besoin de données, pas de slogans |
| Animations au survol sur tout, apparitions en fondu au défilement | Distrait, ralentit |
| Fond sombre avec texte néon par défaut | Choix non justifié par le besoin |
| Tout centré, beaucoup de vide, peu de contenu | Inadapté aux écrans de travail |
| Libellés en anglais ou « Lorem ipsum » | Données irréalistes, revue impossible |
| Tiret long `—` dans les libellés, ou `—` pour une valeur vide | Tic d'écriture interdit (utiliser « Non renseigné » ou une cellule vide) |

## 2. Ce qu'on fait à la place

### Partir du métier
- Chaque écran répond à une tâche précise d'un acteur des specs (instruire un dossier,
  déclarer un sinistre). Pas d'écran vitrine.
- Données d'exemple réalistes et cohérentes : vrais noms de champs, montants plausibles,
  numéros au format métier (`SIN-2026-00042`), dates au format français.
- Densité adaptée : un gestionnaire qui traite 50 dossiers par jour veut un tableau
  dense et filtrable, pas des cartes aérées.

### Système visuel sobre
- Un seul design system (`docs/maquettes/design-system.css` ou celui du projet), utilisé partout.
- Palette : neutres (gris) pour la structure, **une** couleur principale de marque,
  couleurs sémantiques réservées aux états (succès, alerte, erreur, information).
- Typographie : une famille (police système ou celle de la marque), 4 à 5 tailles au plus,
  hiérarchie par la taille et la graisse, pas par la couleur.
- Espacements sur une échelle fixe (4, 8, 12, 16, 24, 32 px).
- Rayons de bordure modestes et constants (4 à 8 px), ombres rares et légères
  (réservées aux éléments superposés : menus, modales).
- Icônes d'une seule bibliothèque cohérente (SVG en ligne), avec libellé texte quand
  l'action n'est pas évidente.

### Mise en page structurée
- Grille claire : navigation, en-tête de page (titre, fil d'Ariane, actions principales),
  zone de contenu.
- Alignement à gauche pour le texte et les formulaires ; chiffres alignés à droite
  dans les tableaux.
- Une action principale par écran, visuellement identifiable ; actions secondaires discrètes.
- Formulaires : un champ par ligne, libellé au-dessus, aide et erreur sous le champ,
  regroupement par sections nommées.
- Tableaux : en-têtes explicites, tri et filtres visibles, pagination, état vide utile
  (« Aucun dossier en attente. Les nouvelles déclarations apparaîtront ici. »).

### États toujours prévus
Chargement (squelette ou indicateur sobre), vide, erreur (message actionnable), succès,
droits insuffisants.

### Accessibilité
Contraste WCAG 2.1 AA, focus visible, navigation au clavier, cibles tactiles de 44 px
(web) ou 48 dp (mobile), libellés de formulaires, textes alternatifs.

## 3. Exemple

```css
/* ❌ À éviter */
.carte {
  background: linear-gradient(135deg, #7c3aed, #db2777);
  backdrop-filter: blur(12px);
  border-radius: 24px;
  box-shadow: 0 0 40px rgba(124, 58, 237, .5);
}

/* ✅ À faire */
.carte {
  background: var(--surface);
  border: 1px solid var(--bordure);
  border-radius: var(--rayon-sm); /* 6px */
  padding: var(--espace-4);       /* 16px */
}
```

## 4. Checklist interface

1. [ ] Aucun tic du tableau de la section 1.
2. [ ] Chaque écran correspond à une tâche d'un acteur des specs.
3. [ ] Données d'exemple réalistes, en français, au format métier.
4. [ ] Un seul design system, une seule couleur principale, échelle d'espacement respectée.
5. [ ] Une action principale par écran ; hiérarchie lisible sans la couleur.
6. [ ] Tous les états sont présents (chargement, vide, erreur, succès, droits).
7. [ ] Accessibilité AA vérifiée.
