# Exemple : cas d'usage « Déclarer un sinistre »

Exemple volontairement court, en TypeScript. Le même découpage s'applique à tout langage.

## shared/ : les génériques

```ts
// shared/result.ts
export class Result<T> {
  private constructor(readonly ok: boolean, readonly value?: T, readonly error?: DomainError) {}
  static ok<T>(value: T) { return new Result<T>(true, value); }
  static fail<T>(error: DomainError) { return new Result<T>(false, undefined, error); }
}

// shared/domain-error.ts
export abstract class DomainError extends Error {
  abstract readonly code: string;
}

// shared/base-repository.ts
export interface BaseRepository<T, Id = string> {
  findById(id: Id): Promise<T | undefined>;
  save(entity: T): Promise<void>;
}
```

## domain/ : entité et port

```ts
// domain/sinistre/sinistre.ts
export class ContratInactif extends DomainError { readonly code = 'CONTRAT_INACTIF'; }

export class Sinistre {
  private constructor(
    readonly id: string,
    readonly contratId: string,
    readonly dateSurvenance: Date,
    readonly statut: 'DECLARE' | 'EN_INSTRUCTION' | 'CLOS',
  ) {}

  static declarer(id: string, contrat: Contrat, dateSurvenance: Date): Result<Sinistre> {
    if (!contrat.couvre(dateSurvenance)) return Result.fail(new ContratInactif());
    return Result.ok(new Sinistre(id, contrat.id, dateSurvenance, 'DECLARE'));
  }
}

// domain/sinistre/sinistre.repository.ts  (port)
export interface SinistreRepository extends BaseRepository<Sinistre> {}
```

## application/ : le cas d'usage

```ts
// application/sinistre/declarer-sinistre.ts
export class DeclarerSinistre {
  constructor(
    private readonly sinistres: SinistreRepository,
    private readonly contrats: ContratRepository,
    private readonly ids: GenerateurId,
  ) {}

  async executer(commande: DeclarerSinistreCommande): Promise<Result<Sinistre>> {
    const contrat = await this.contrats.findById(commande.contratId);
    if (!contrat) return Result.fail(new ContratIntrouvable(commande.contratId));

    const resultat = Sinistre.declarer(this.ids.suivant(), contrat, commande.dateSurvenance);
    if (resultat.ok) await this.sinistres.save(resultat.value!);
    return resultat;
  }
}
```

## infrastructure/ : l'adaptateur

```ts
// infrastructure/sinistre/sinistre.pg-repository.ts
export class PgSinistreRepository implements SinistreRepository {
  constructor(private readonly db: Pool) {}

  async findById(id: string) {
    const { rows } = await this.db.query('SELECT * FROM sinistre WHERE id = $1', [id]);
    return rows[0] ? toDomain(rows[0]) : undefined;
  }

  async save(sinistre: Sinistre) {
    await this.db.query(
      'INSERT INTO sinistre (id, contrat_id, date_survenance, statut) VALUES ($1, $2, $3, $4)',
      [sinistre.id, sinistre.contratId, sinistre.dateSurvenance, sinistre.statut],
    );
  }
}
```

## presentation/ : le controller

```ts
// presentation/sinistre/sinistre.controller.ts
export class SinistreController {
  constructor(private readonly declarerSinistre: DeclarerSinistre) {}

  async declarer(req: Request): Promise<ApiResponse<SinistreDto>> {
    const commande = validerDeclaration(req.body); // DTO d'entrée validé
    const resultat = await this.declarerSinistre.executer(commande);
    return resultat.ok
      ? ApiResponse.created(toSinistreDto(resultat.value!))
      : ApiResponse.fromError(resultat.error!); // gestion d'erreurs centralisée
  }
}
```

## Assemblage (point d'entrée)

```ts
// main.ts
const declarerSinistre = new DeclarerSinistre(
  new PgSinistreRepository(pool),
  new PgContratRepository(pool),
  new UuidGenerateur(),
);
router.post('/api/v1/sinistres', req => new SinistreController(declarerSinistre).declarer(req));
```

## Ce que montre l'exemple

- Le domaine ne connaît ni PostgreSQL ni HTTP.
- Le cas d'usage se teste avec de faux repositories en mémoire, sans base.
- `Result<T>`, `BaseRepository<T>` et `ApiResponse<T>` sont écrits une fois dans `shared/`.
- Changer de base de données ne touche qu'un adaptateur.
