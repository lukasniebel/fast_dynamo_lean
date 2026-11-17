module

public import FastDynamo.Dynamics.Assembly.NormalizedGrowthRate
public import FastDynamo.Dynamics.NormalizedLagrangianClauses

/-!
# Theorem 1.2 for the normalised velocity

Remark 1.6 of the paper (the remark after `rem:scope-intro`): with
`M = max {1, ‖u‖_{W^{1,∞}}}` and `ũ = u / M`,

```
  L_{ε,ũ} = M⁻¹ L_{Mε,u},        γ(ũ, ε) = M⁻¹ γ(u, Mε),
```

Theorem 1.2 (`thm:main`) remains valid for `ũ` with the threshold `ε₀ / M` and the lower
bound `γ₀ / M`, the particle flow and the ideal induction group of `ũ` are those of `u` at time
`t / M`, and the ideal growth rate and the topological entropy stay zero; so one may require
`‖ũ‖_{W^{1,∞}} ≤ 1`.

`MainTheoremNormalized` collects all of it at `ũ = normalizedVelocity mainVelocity`, with
`M⁻¹ = velocityNormalizer mainVelocity`, reusing the predicates of the main theorem at the
normalised arguments, and `mainTheoremNormalized_holds` proves it.  The proofs are in
`FastDynamo/Dynamics/Assembly/NormalizedGrowthRate.lean` (the identities, the growth-rate and
semigroup-orbit clauses), `FastDynamo/Dynamics/NormalizedLagrangianClauses.lean` (the flow, the
ideal group and the dynamical clauses) and `FastDynamo/Operator/ReducedInductionScaling.lean`
(the spectral clauses).

**The norm.**  `‖u‖` is the norm of `TransverseRealW1Inf`,
`max(‖u‖_∞, ‖∂₁u‖_∞, ‖∂₂u‖_∞)` with `‖·‖_∞` the essential supremum of the Euclidean norm; the
paper does not fix a `W^{1,∞}` norm, and every identity below holds for any positive `M`.

**The operator.**  The first display is stated for the auxiliary all-frequency action
`productInductionAction`, the action of the generator of the semigroup behind `gamma`, as a map
on all of `H²`.  On divergence-free `H²` fields this action is the paper's curl form
`curl(u × B) + εΔB`, read in the Fourier model of `H⁻²`
(`productInductionAction_toHMinus2_eq_physical`); the paper states the identity for
`L_{ε,u}` on `H² ∩ L²_σ`.
-/

@[expose] public section

namespace FastDynamo

noncomputable section

open HorizontalMode

/-- **Theorem 1.2 for the normalised velocity** (Remark 1.6, the remark after
`rem:scope-intro`), at `ũ = normalizedVelocity mainVelocity = M⁻¹ mainVelocity` with
`M = max 1 ‖mainVelocity‖`, where `‖·‖` is the norm of `TransverseRealW1Inf`,
`max(‖u‖_∞, ‖∂₁u‖_∞, ‖∂₂u‖_∞)`, and `M⁻¹ = velocityNormalizer mainVelocity`:

* `‖ũ‖ ≤ 1`, `ũ` is divergence-free and non-zero, and the thresholds `M⁻¹ ε₀`, `M⁻¹ γ₀` are
  positive;
* the two displayed identities of the remark, `A_{ε,ũ} = M⁻¹ A_{Mε,u}` for the auxiliary
  action and `γ(ũ, ε) = M⁻¹ γ(u, Mε)`, the latter from the identity of the semigroups
  `e^{tL_{ε,ũ}} = e^{(t/M) L_{Mε,u}}` on `L²_σ(T³; ℂ³)`;
* every clause of Theorem 1.2 for `ũ` with `M⁻¹ ε₀` and `M⁻¹ γ₀`: the spectral clauses, the
  growth-rate clause for `0 < ε ≤ M⁻¹ ε₀` and its `liminf` form, the
  semigroup-orbit form of `eq:main-thm-growth` together with the same law for every solution
  of the curl-form equation with the real datum (at the triple of the spectral clauses), and
  the two dynamical clauses at the literal velocity of `ũ`;
* the literal velocity of `ũ` represents `ũ` and is `M⁻¹` times that of `u`; its particle flow
  is `t ↦ Φ_{t/M}`, the only one, and `t ↦ 𝒯₀(t/M)` is the ideal induction group for it;
  `prop:particle-flow` and `cor:ideal-growth` hold for it with the constant `(1 + M⁻¹) C_L`. -/
structure MainTheoremNormalized : Prop where
  /-- `M⁻¹ = 1 / max (1, ‖u‖)`. -/
  normalizer_eq : velocityNormalizer mainVelocity = (max 1 ‖mainVelocity‖)⁻¹
  /-- `ũ = M⁻¹ u`. -/
  velocity_eq : normalizedVelocity mainVelocity = velocityNormalizer mainVelocity • mainVelocity
  /-- The normalised velocity lies in the closed unit ball of `W^{1,∞}`. -/
  norm_le_one : ‖normalizedVelocity mainVelocity‖ ≤ 1
  /-- The normalised velocity is divergence-free. -/
  velocity_isTransverseDivergenceFree : IsTransverseDivergenceFree (normalizedVelocity mainVelocity)
  /-- The normalised velocity is non-zero. -/
  velocity_ne_zero : normalizedVelocity mainVelocity ≠ 0
  /-- The threshold `M⁻¹ ε₀` is positive. -/
  eps0_pos : 0 < velocityNormalizer mainVelocity * mainEps0
  /-- The growth floor `M⁻¹ γ₀` is positive. -/
  growthFloor_pos : 0 < velocityNormalizer mainVelocity * mainGrowthFloor
  /-- `L_{ε,ũ} = M⁻¹ L_{Mε,u}`, for the auxiliary all-frequency action. -/
  action_eq : ∀ ε : ℝ,
    productInductionAction (normalizedVelocity mainVelocity) ε =
      (velocityNormalizer mainVelocity : ℂ) •
        productInductionAction mainVelocity (max 1 ‖mainVelocity‖ * ε)
  /-- The induction semigroup of `ũ` on `L²_σ(T³; ℂ³)` at diffusivity `ε` is that of `u` at
  diffusivity `M ε` run at time `M⁻¹ t`. -/
  semigroup_eq : ∀ {ε : ℝ} (hε : 0 < ε),
    literalInductionSemigroup (normalizedVelocity mainVelocity)
        velocity_isTransverseDivergenceFree hε =
      (literalInductionSemigroup mainVelocity mainVelocity_isTransverseDivergenceFree
        (mul_pos (max_one_norm_pos mainVelocity) hε)).timeRescale
        (Real.toNNReal (velocityNormalizer mainVelocity))
  /-- `γ(ũ, ε) = M⁻¹ γ(u, M ε)`. -/
  gamma_eq : ∀ {ε : ℝ} (hε : 0 < ε),
    gamma (normalizedVelocity mainVelocity) velocity_isTransverseDivergenceFree hε =
      ((velocityNormalizer mainVelocity : ℝ) : EReal) *
        gamma mainVelocity mainVelocity_isTransverseDivergenceFree
          (mul_pos (max_one_norm_pos mainVelocity) hε)
  /-- The spectral clauses of Theorem 1.2 for `ũ` with `M⁻¹ ε₀` and `M⁻¹ γ₀`. -/
  physicalClauses :
    MainPhysicalClauses (normalizedVelocity mainVelocity)
      (velocityNormalizer mainVelocity * mainEps0)
      (velocityNormalizer mainVelocity * mainGrowthFloor)
  /-- The growth-rate clause for `ũ`: `γ(ũ, ε) ≥ M⁻¹ γ₀` for `0 < ε ≤ M⁻¹ ε₀`, the interval
  of the paper's Remark 1.6. -/
  growthRate : ∀ {ε : ℝ} (hpos : 0 < ε), ε ≤ velocityNormalizer mainVelocity * mainEps0 →
    ((velocityNormalizer mainVelocity * mainGrowthFloor : ℝ) : EReal) ≤
      gamma (normalizedVelocity mainVelocity) velocity_isTransverseDivergenceFree hpos
  /-- `eq:main-growth-conclusion` for `ũ`: `liminf_{ε ↓ 0} γ(ũ, ε) ≥ M⁻¹ γ₀`. -/
  growthRate_liminf :
    ((velocityNormalizer mainVelocity * mainGrowthFloor : ℝ) : EReal) ≤
      Filter.liminf (gammaOf (normalizedVelocity mainVelocity)
        velocity_isTransverseDivergenceFree) (nhdsWithin (0 : ℝ) (Set.Ioi 0))
  /-- `eq:main-thm-growth` for `ũ`: for the semigroup orbit of the real datum and for every
  forward strong solution of the curl-form equation with that datum, together with the
  spectral clauses `MainPhysicalClausesAt` at the same triple `(K, λ, b)`. -/
  semigroupOrbit :
    MainSemigroupOrbitClauses (normalizedVelocity mainVelocity)
      velocity_isTransverseDivergenceFree
      (velocityNormalizer mainVelocity * mainEps0)
      (velocityNormalizer mainVelocity * mainGrowthFloor)
  /-- The literal velocity of `ũ` represents `ũ`: the value of `ũ` is almost everywhere
  `M⁻¹` times the torus-side representative of `u`, whose axially independent extension is
  `normalizedLiteralVelocity`. -/
  value_ae_eq :
    (transverseW1InfValue (normalizedVelocity mainVelocity) : TransverseTorus → R3)
      =ᵐ[transverseMeasure]
        velocityNormalizer mainVelocity • mainVelocityTorusRepresentative
  /-- The literal velocity of `ũ` is `M⁻¹` times that of `u`. -/
  literalVelocity_eq :
    normalizedLiteralVelocity = velocityNormalizer mainVelocity • mainLiteralVelocity
  /-- The flow and the ideal induction group of `ũ` are those of `u` at time `M⁻¹ t`. -/
  idealGroup :
    IsIdealInductionGroup normalizedLiteralVelocity
      (fun t ↦ mainLiteralFlow (velocityNormalizer mainVelocity * t))
      (fun t ↦ ScaleFamily.TorusCellPlacement.flowFDeriv globalSeedInterface.smoothingWidth
        mainParameterChoice.placement globalSeedInterface.angularSpeed
        globalSeedInterface.axialSpeed mainParameterChoice.tau
        (velocityNormalizer mainVelocity * t))
      (fun t ↦ mainIdealGroup (velocityNormalizer mainVelocity * t))
  /-- `t ↦ Φ_{M⁻¹t}` is the only particle flow of `ũ`. -/
  flow_unique : ∀ Φ' : ℝ → Torus 3 → Torus 3, IsParticleFlow normalizedLiteralVelocity Φ' →
    Φ' = fun t ↦ mainLiteralFlow (velocityNormalizer mainVelocity * t)
  /-- The two dynamical clauses of Theorem 1.2 for `ũ`: `h_top = 0` for every time map of its
  flow, and the operator norm of its ideal group has growth rate zero. -/
  dynamical : MainTheoremDynamicalClauses normalizedLiteralVelocity
  /-- `prop:particle-flow` and `cor:ideal-growth` for `ũ`. -/
  lagrangian : MainLagrangianClauses normalizedLiteralVelocity

/-- **Theorem 1.2 holds for the normalised velocity** (Remark 1.6). -/
theorem mainTheoremNormalized_holds : MainTheoremNormalized where
  normalizer_eq := one_div _
  velocity_eq := rfl
  norm_le_one := norm_normalizedVelocity_le_one mainVelocity
  velocity_isTransverseDivergenceFree :=
    isTransverseDivergenceFree_normalizedVelocity mainVelocity_isTransverseDivergenceFree
  velocity_ne_zero := normalizedVelocity_ne_zero mainVelocity_ne_zero
  eps0_pos := mul_pos (velocityNormalizer_pos mainVelocity) mainEps0_pos
  growthFloor_pos := mul_pos (velocityNormalizer_pos mainVelocity) mainGrowthFloor_pos
  action_eq := productInductionAction_normalizedVelocity mainVelocity
  semigroup_eq := literalInductionSemigroup_normalizedVelocity mainVelocity
    mainVelocity_isTransverseDivergenceFree
  gamma_eq := gamma_normalizedVelocity mainVelocity mainVelocity_isTransverseDivergenceFree
  physicalClauses := mainPhysicalClauses_normalizedVelocity.2
  growthRate := normalizedGrowthFloor_le_gamma
  growthRate_liminf := normalizedGrowthFloor_le_liminf_gammaOf
  semigroupOrbit := mainSemigroupOrbitClauses_normalizedVelocity
  value_ae_eq := transverseW1InfValue_normalizedVelocity_ae
  literalVelocity_eq := normalizedLiteralVelocity_eq
  idealGroup := isIdealInductionGroup_normalizedLiteralVelocity
  flow_unique := fun _ h ↦ normalizedLiteralFlow_unique h
  dynamical := normalizedTheoremDynamical_holds
  lagrangian := normalizedTheoremLagrangian_holds

end

end FastDynamo
