# Deviations of the formalisation from the paper

This document lists every respect in which the Lean statements and the Lean arguments of this
repository differ from the paper *A fast dynamo with zero topological entropy* (L. Niebel,
arXiv:2608.02586v3).  The paper is cited by its LaTeX labels
(`thm:main`, `eq:global-u`, …) and, where it helps, by its printed numbers; unlabelled passages
are located relative to a label or a section.  Lean names are given without the `FastDynamo.`
namespace prefix where this is unambiguous; every file path is relative to the repository root.

**How to read an entry.**  Each entry has a stable identifier (A1, B3, C2.4, CA.1, D3, E2, …), a
short title and the paper label(s) concerned, then **Paper:** what the paper states or does
there, **Lean:** what the formalisation states or does, with the declaration names and files,
and **Effect:** one of the words below, with a sentence on consequences where useful.

* **stronger** — the Lean statement implies the paper's (more clauses, weaker hypotheses, an
  explicit value where the paper asserts existence).
* **weaker** / **narrower** — the Lean statement proves less, or proves it for a smaller class
  of objects.
* **different form** — an equivalent or incomparable formulation of the same content, or the
  same words read in a different model.
* **different route** — the same statement, proved by a different argument.
* **not formalised** — a statement, clause or proof step of the paper with no Lean counterpart.
* **choice** — the Lean fixes something the paper leaves free (a cut-off, a radius, a numeral),
  or keeps free something the paper fixes.

Part A lists the standing conventions and modelling choices that affect how *every* Lean
statement is read.  Part B goes through Theorem 1.2 clause by clause, together with Remark 1.6
(the theorem for the normalised velocity) and the Challenge statement `Challenge.lean`, the form
of the theorem in mathlib's terms (B14).  Part C goes through the other statements of §1, then
§§2–8 and Appendix A, statements first and arguments second in each section.  Part D lists the
four items of the paper that are not formalised — Conjecture 1.1 and Remarks 1.3, 7.5 and 8.4 —
and whether the proof of Theorem 1.2 depends on them.  Part E lists material of the
formalisation that the paper does not contain.

A statement of the paper with no entry here is formalised as stated in the paper, up to the
conventions of Part A.  A clause that is formalised only in a weaker or a different form is an
entry of Part B or C, not of Part D.  The blueprint (`blueprint/`) repeats each deviation in a
paragraph directly after the node concerned; `CORRESPONDENCE.md` maps every statement of the paper to its
Lean declarations and marks the rows that carry a deviation.

---

## Part A — Standing conventions and modelling choices

**A1. The velocity class: axially independent `W^{1,∞}` fields on `T²`.** \
**Paper:** velocities are `u ∈ W^{1,∞}(T³;ℝ³)` with `Div u = 0` (§1.1, `thm:main`,
`lem:semigroup-spectral-growth`); the constructed `u` is independent of `x₃`
(`lem:global-velocity`). \
**Lean:** every velocity is an element of `TransverseRealW1Inf`
(`FastDynamo/Analysis/TransverseW1Inf.lean`): a real field `T² → ℝ³` together with two `L^∞`
fields that are its weak horizontal derivatives, the derivative relation being imposed on every
Fourier coefficient (a closed "Fourier graph" subspace of `L^∞ × (L^∞)²`).  It is read on
`T³` as an `x₃`-independent field.  Divergence-freeness is `IsTransverseDivergenceFree u`
(`∂₁u₁ + ∂₂u₂ = 0` for the stored weak derivatives; `FastDynamo/Analysis/WeakLeibnizVelocity.lean`),
which is `Div u = 0` for an `x₃`-independent field.  The norm is the norm of this graph
space, `‖u‖ = max(‖u‖_∞, ‖∂₁u‖_∞, ‖∂₂u‖_∞)` with `‖·‖_∞` the essential supremum of the
Euclidean norm; it is a `W^{1,∞}` norm (`∂₃u = 0`), and the paper does not fix one.
`W^{1,∞}` is not identified with the Lipschitz class in general; for the constructed velocity a
Lipschitz representative is proved separately (B1, C3.5). \
**Effect:** existential statements about the velocity (Theorem 1.2) are **stronger**; statements
quantified over all velocities are **narrower** — this matters for `γ(u,ε)` and the notions of
dynamo, which Lean defines only for `x₃`-independent `u` (B3, C1.2), and for Lemma A.1, which
Lean proves for `x₃`-independent `u` (CA.1).  `lem:torus-sector-basic` and `lem:axial-recovery`
are stated in the paper for `x₃`-independent velocities already.

**A2. The three-torus: the product model `T² × T`, and what is transported to `Torus 3`.** \
**Paper:** everything lives on `T³ = ℝ³/ℤ³`. \
**Lean:** the operator theory, the eigenmodes and the induction equation live on the product model
`ProductTorus3 = TransverseTorus × AxialCircle` (`FastDynamo/Conventions.lean`).  A
measure-preserving identification with the literal torus `Torus 3 = Fin 3 → UnitAddCircle`
(`toLiteralC3L2`, `FastDynamo/Analysis/LiteralThreeTorus.lean`) transports: the velocity
(`literalVelocity`, the axial extension of a torus representative), the real magnetic trajectory and
its norm law (`literalRealTrajectory`), the solenoidal subspace (`literalSolenoidalSubspace`, A5)
and the induction semigroup (`literalInductionSemigroup`); on `Torus 3` the complexified real
trajectory is the orbit of the transported real datum under `literalInductionSemigroup` for `t ≥ 0`
(`MainLiteralTorusClauses`, B7).  The particle flow, the ideal group, the weak form of the ideal
induction equation (C4.4), the variational equation of the flow (C4.8) and the vanishing-diffusivity
limit of Remark 1.7 (C1.5) are stated on `Torus 3` directly; there the derivative of a velocity is
the derivative of its `ℤ³`-periodic lift (`literalFDeriv`,
`FastDynamo/Dynamics/IdealWeakForm.lean`).  The resistive induction operators are not transported to
`Torus 3`: the eigenvalue equation, divergence-freeness of the eigenmode, the curl-form equation,
its strong solutions and their uniqueness, and Lemma A.1 are stated in the product model only (the
proof of Remark 1.7 transports the action of the auxiliary operator on mollified fields,
`toLiteralC3L2_productInductionAction_productMollifyH2`). \
**Effect:** **different form**.  Statements about the magnetic field read the paper's `T³` as
`T² × T`; the transport is an isometry, so norms and growth bounds are unchanged.

**A3. Measure.** \
**Paper:** "the Lebesgue measure" on `T³ = ℝ³/ℤ³` (total mass one), §1.1. \
**Lean:** the product of the Haar probability measures on `T²` and `T`; `volume` on `Torus 3`
is the Haar probability measure; the identification of A2 is measure preserving. \
**Effect:** none — the same measure.

**A4. Sobolev spaces as Fourier graph spaces.** \
**Paper:** `H¹`, `H²`, `H⁻¹` on `T²`, `T³`, `ℝ²` in the usual sense. \
**Lean:** `H²` and `H¹` are closed Fourier graph spaces (a function together with its weak
derivatives, related coefficientwise; e.g. `TransverseC3H2`, `ProductC3H2`), negative-order
spaces are Fourier-weighted spaces (`ProductC3HMinus2`), and weak derivatives and the divergence
are Fourier-defined (`productDivergenceFromH2`).  On the whole plane the analogous spaces are
built from the Fourier transform (`FastDynamo/Analysis/WholePlaneSobolev.lean`). \
**Effect:** **different form** of the same spaces.

**A5. `L²_σ` is a Fourier-defined subspace.** \
**Paper:** `L²_σ(T³) := {B ∈ L²(T³;ℂ³) : Div B = 0}` (§1.1). \
**Lean:** `productSolenoidalSubspace` (`FastDynamo/Dynamics/Assembly/SolenoidalSubspace.lean`) is
cut out of `L²(T² × T;ℂ³)` by Fourier constraint functionals; `literalSolenoidalSubspace`
(`FastDynamo/Dynamics/Assembly/MainGrowthRate.lean`) is its image under `toLiteralC3L2`.  On
`Torus 3` it is characterised in Fourier form: a field `B` lies in it if and only if
`Σ_i 2πi m_i ⟨e_m, B_i⟩ = 0` for every frequency `m ∈ ℤ³`
(`sum_inner_flatTorus3FourierBasis_eq_zero`, `mem_literalSolenoidalSubspace_of_sum_inner_eq_zero`),
i.e. the distributional divergence of `B` tested against the characters vanishes; gradients of
functions with `C¹` periodic lift are orthogonal to it
(`inner_gradient_eq_zero_of_mem_literalSolenoidalSubspace`,
`FastDynamo/Dynamics/Ideal/GradientOrthogonality.lean`).  It is closed and non-zero
(`exists_ne_zero_literalSolenoidalSubspace`). \
**Effect:** **different form**; the semigroup and the ideal group of Theorem 1.2 act on this
subspace.

**A6. The operators: weak curl form, auxiliary operator, realisation on `L²_σ`, sector operators.** \
**Paper:** one induction operator `L_{ε,u}B = curl(u × B) + εΔB` on `L²_σ` with domain
`H² ∩ L²_σ` (`eq:physical-generator`); the horizontal sector operator `A_{ε,K}` on
`L²(T²;ℂ²)` (`eq:torus-sector`). \
**Lean:** five operators.
* `productPhysicalInductionOperator u ε` (`FastDynamo/Operator/Compatibility.lean`): the curl
  form, computed weakly, as a bounded map `H² → H⁻²` on all of `H²` (no solenoidal constraint
  on the domain).  This is the operator of the eigenvalue and strong-solution clauses of
  Theorem 1.2; those identities hold in `H⁻²`.
* `productInductionOperator u ε` (`FastDynamo/Operator/Product.lean`): the *auxiliary* operator
  `εΔB − (u·∇)B + (B·∇)u` on `L²(T² × T;ℂ³)` with domain `H²`.  It differs from the curl form
  by `u Div B` and agrees with it on divergence-free fields
  (`productInductionAction_toHMinus2_eq_physical`).  It generates a semigroup on all of `L²`
  whose restriction to `L²_σ` is the semigroup of Lemma A.1 (CA.2).  The paper has no such
  operator.
* `solenoidalInductionOperator u hu ε` (`FastDynamo/Dynamics/Assembly/SolenoidalGenerator.lean`):
  the paper's `L_{ε,u}` on `L²_σ` with domain `H² ∩ L²_σ` (the divergence-free `H²` fields
  `solenoidalH2`), with values the auxiliary action, which lies in `L²_σ` on that domain
  (`productInductionAction_mem_productSolenoidalSubspace`); embedded in `H⁻²` it is the curl
  form.  It is the generator of the semigroup that defines `γ` (B3, CA.1).
* `reducedInductionOperator u ε K` (`FastDynamo/Operator/FixedSector.lean`): the operator on
  `ℂ³`-valued fields in the axial Fourier sector `K`.  The paper has no such operator.
* `horizontalInductionOperator u ε K` (`FastDynamo/Operator/HorizontalSector.lean`): the
  paper's two-component `A_{ε,K}`; the horizontal projection intertwines the two actions,
  `π⊥(A₃b) = A_{ε,K}(π⊥b)` (`horizontalProjL2_reducedInductionAction`).

**Effect:** **different form**.  The spectral half of the proof runs on the two-component
operator as in the paper and is then lifted to the `ℂ³` sector operator and the product operator.

**A7. Operator conventions.** \
**Lean:** an operator is a `DomainOperator`: a bounded map from a complete domain space (here
always a Fourier graph space) into the ambient space, with an injective embedding
(`FastDynamo/Operator/Domain.lean`).  `IsEigenpair A λ b` means `A b = λ b` in the ambient
space *and* `b ≠ 0`.  `HasResolventOn A S` is a chosen two-sided inverse of `z − A` at every
`z ∈ S` together with continuity on `S` (not holomorphy).  `IsStrongSolution`
(`FastDynamo/Operator/Evolution.lean`) asks for the derivative identity at every real time;
`IsForwardStrongSolution` (`FastDynamo/Dynamics/StronglyContinuousSemigroup.lean`) at every
`t ≥ 0`, one-sided within `[0, ∞)`.  The generator of a `C₀`-semigroup is a partially defined
map `X →ₗ.[ℂ] X` (`StronglyContinuousSemigroup.generator`,
`FastDynamo/Dynamics/SemigroupGenerator.lean`), and for such maps `LinearPMap.resolventSet` is
the set of `z` at which `z − T` has a bounded two-sided inverse, `LinearPMap.spectrum` its
complement (`FastDynamo/Operator/UnboundedResolvent.lean`); for the closed generators of
Lemma A.1 this is the usual spectrum. \
**Effect:** **different form**; see C6.1 for the continuous resolvent of
`prop:background-resolvent` used in §7 and the holomorphic resolvent that Lean proves in addition.

**A8. Inner products.** \
**Paper:** inner products are linear in the first argument (§1.1). \
**Lean:** Mathlib's `inner` is conjugate-linear in the first argument; `paperInner`
(`FastDynamo/Conventions.lean`) reverses the arguments.  Where the paper tests `⟨P f, f⟩` the
Lean statements test `inner (P f) f` or `⟨f, Q f⟩`
(`FastDynamo/Global/TorusSelectedContourIdentity.lean`); only real parts are used, and they agree. \
**Effect:** **different form**, no change of content.

**A9. The axial wave number `N = 2π k_*`.** \
**Paper:** the local model of §2 lives in the axial mode `e^{2πi x₃}`: `eq:horizontal-induction`
and `eq:local-generator` contain `4π²` and `2πi`; correspondingly `K_n ℓ_n = 1`,
`ℓ_n = 1/K_n`, `ε₀ = δ₊/K₀²` (§3.2), and `U = −Ω/(2π)` (`eq:jump-flow`). \
**Lean:** the local operators carry a wave number `N` (`δ(Δ⊥ − N²) … − iN v₃ …`); the seed
records carry `N = 2π k_*` with a positive integer `k_*` (`LocalSeedParameters.kStar`,
`FastDynamo/Local/SeedParameters.lean`), the global chain has `ℓ_n = k_*/K_n`,
`2πK_nℓ_n = N` (`ScaleFamily.axial_wavenumber_match`), `ε₀ = δ₊k_*²/K₀²`, `U = −Ω/N`.  The
seed that enters Theorem 1.2 is taken at `k_* = 1`, i.e. `N = 2π`
(`exists_localSeedC2_two_pi`, `globalSeedInterface_kStar`), where every formula is the
paper's. \
**Effect:** **choice** (a generalisation); at `k_* = 1` nothing differs.

**A10. Explicit witnesses and explicit constants.** \
**Paper:** Theorem 1.2 asserts existence of `u, ε₀, γ₀`; many intermediate statements say
"sufficiently large" or "a constant `C`". \
**Lean:** Theorem 1.2 is proved at closed-term witnesses — `mainVelocity`, `mainEps0`,
`mainGrowthFloor` (`FastDynamo/Global/MainTheoremWitnesses.lean`), `mainLiteralVelocity`,
built from the parameter chain `mainParameterChoice`
(`FastDynamo/Global/GlobalParameterChoiceConcrete.lean`).  Most thresholds and constants are
explicit numbers or formulas; each is recorded in Part C where it occurs. \
**Effect:** **stronger** (an explicit witness gives the existential).

---

## Part B — The main theorem (Theorem 1.2, `thm:main`)

The Lean statement is spread over several predicates, all at the witnesses of A10:
`MainPhysicalClauses` (`FastDynamo/Main.lean`), the fields `growthRate`, `semigroupOrbit`,
`literalTorus`, … of `MainTheoremStrengthened` (`FastDynamo/MainTheoremStrengthened.lean`),
`MainSemigroupOrbitClauses` (`FastDynamo/Dynamics/Assembly/SemigroupOrbit.lean`),
`MainTheoremDynamicalClauses` and `MainLagrangianClauses` (`FastDynamo/Dynamics/ParticleFlow.lean`).
`MainTheoremComplete` collects them and `mainTheoremComplete_holds`
(`FastDynamo/Dynamics/MainLagrangianClauses.lean`) proves it; `mainPhysicalConclusion_holds`
(alias `main_theorem_spectral`, `FastDynamo/MainTheorem.lean`) is the existential form of the
spectral half.  `MainTheoremNormalized` (`FastDynamo/MainTheoremNormalized.lean`) restates every
clause for the normalised velocity of Remark 1.6 (B10).  `challenge_statement`
(`FastDynamo/Palomar/Main.lean`) proves the theorem a second time, as one proposition in terms of
mathlib and fourteen short definitions: the Challenge statement of `Challenge.lean` (B14).

| Clause of `thm:main` | Lean | Effect | Entry |
|---|---|---|---|
| real autonomous `u ∈ W^{1,∞}(T³;ℝ³)`, `Div u = 0` | `mainVelocity : TransverseRealW1Inf`, `mainVelocity_isTransverseDivergenceFree`, `mainVelocity_ne_zero`; `mainLiteralVelocity` on `Torus 3` | stronger, different form | B1 |
| ∃ `ε₀ > 0`, `γ₀ > 0` | explicit `mainEps0 = δ₊/K₀²`, `mainGrowthFloor = g_*` | stronger | B2, B11 |
| `γ(u,ε) ≥ γ₀` for `0 < ε ≤ ε₀` | `gamma_ge_gamma0` (field `growthRate`) | different form | B3, B4 |
| `liminf_{ε↓0} γ(u,ε) ≥ γ₀` (`eq:main-growth-conclusion`) | `mainGrowthFloor_le_liminf_gammaOf`; `isFastDynamo_mainVelocity` | as the row above | B3, B4, C1.2 |
| for `0 < ε ≤ ε₀`: `K_ε ≠ 0`, `λ_ε`, `0 ≠ b^ε ∈ H²(T²;ℂ³)` | `MainPhysicalClauses` | identical | — |
| `V^ε ∈ H² ∩ L²_σ`, `L_{ε,u}V^ε = λ_εV^ε`, `Re λ_ε ≥ γ₀` | `axialLiftH2 K b`, `productDivergenceFromH2 … = 0`, `(productPhysicalInductionOperator u ε).IsEigenpair` | different form, extra clauses | B5 |
| `B_in^ε = Re V^ε ∈ H²(T³;ℝ³) ∩ L²_σ`, non-zero | `realAxialInitialField … ≠ 0`, `productRealPartH2`, `realifiedEigenTrajectoryH2` | identical (product model) | — |
| "its solution" obeys `eq:main-thm-growth` for `t ≥ 0` | `MainPhysicalClauses` (a strong solution, all `t ∈ ℝ`); `MainSemigroupOrbitClauses` (the semigroup orbit, and every forward strong solution with that datum, `t ≥ 0`, with `MainPhysicalClausesAt` at the same triple); `MainLiteralTorusClauses` (on `Torus 3`, the orbit under `literalInductionSemigroup`, `t ≥ 0`) | different form; stronger in time | B6, B7, B13 |
| `h_top(Φ_t) = 0`, `t ∈ ℝ` | `MainTheoremDynamicalClauses mainLiteralVelocity` | different form | B8 |
| `lim t⁻¹ log ‖𝒯₀(t)‖ = 0` | same predicate | different form | B9 |
| (one velocity, one set of witnesses for all clauses) | clauses in separate predicates | different form | B2 |
| Remark 1.6: the theorem for `ũ = u/M` | `MainTheoremNormalized`, `mainTheoremNormalized_holds` | different form | B10 |
| the whole theorem, as one proposition in mathlib's terms (`Challenge.lean`) | `FastDynamoChallenge.fast_dynamo_zero_entropy` (`Solution.lean`), `challenge_statement` | different form; growth clause equivalent | B14 |

**B1. The velocity.**  (`thm:main`, first sentence; `lem:global-velocity`) \
**Paper:** some real, autonomous `u ∈ W^{1,∞}(T³;ℝ³)` with `Div u = 0`. \
**Lean:** `mainVelocity : TransverseRealW1Inf` (A1) with `IsTransverseDivergenceFree` and
`mainVelocity ≠ 0`; the existential `MainPhysicalConclusion` asserts axial independence (by the
type) and `u ≠ 0`, which are properties of the paper's construction, not clauses of the
theorem.  The dynamical clauses are stated for `mainLiteralVelocity : Torus 3 → ℝ³`
(`FastDynamo/MainTheoremStrengthened.lean`), defined as `literalVelocity` of a torus
representative `mainVelocityTorusRepresentative`, which represents the value of `mainVelocity`
almost everywhere (`transverseW1InfValue_mainVelocity_ae`) and is Lipschitz
(`lipschitzWith_mainLiteralVelocity`). \
**Effect:** **stronger** existential, **different form**: the spectral and the dynamical
clauses are about two Lean objects linked by definition and by an a.e. identity.

**B2. Shape of the statement: explicit witnesses, several predicates.**  (`thm:main`) \
**Paper:** one sentence `∃ u, ε₀, γ₀` followed by clauses about the same `V^ε`, `B_in^ε`. \
**Lean:** in the library's own terms there is no single proposition of the form
`∃ u ε₀ γ₀, (all clauses)`; the Challenge statement (B14) is one, in mathlib's terms.  The clauses
are fields and theorems at the explicit witnesses of A10, and the per-diffusivity predicates
`MainPhysicalClauses`, `MainSemigroupOrbitClauses`, `MainLiteralTorusClauses` each carry their
own existential `∃ K λ b`.  Each of them includes the reduced eigenpair
`(reducedInductionOperator u ε K).IsEigenpair λ b` from which the others are derived
(`mainPhysicalClauses_of_mainReducedClauses`, `mainSemigroupOrbitClauses_of_mainReducedClauses`).
`MainSemigroupOrbitClauses` contains `MainPhysicalClausesAt u γ₀ ε K λ b` at its own triple, so
the eigenmode clause, the real datum, the semigroup orbit and the uniqueness clause ("its
solution") hold at one `(K, λ, b)`; the triple of `MainLiteralTorusClauses` is the one of
`mainSemigroupOrbitClauses_holds` (by its proof, not by its statement), and the field
`physicalClauses` repeats the spectral clauses with a separately chosen triple. \
**Effect:** **different form**.  The existential form of the spectral half alone is
`mainPhysicalConclusion_holds`; at one triple, every clause of the spectral half and "its
solution" are `MainSemigroupOrbitClauses` (field `semigroupOrbit`).

**B3. `γ(u,ε)` is the growth bound of the semigroup of Lemma A.1, transported to `Torus 3`.**
(`eq:semigroup-growth-rate`, `thm:main`, `eq:main-growth-conclusion`) \
**Paper:** `γ(u,ε) = lim_{t→∞} t⁻¹ log ‖e^{tL_{ε,u}}‖_{L²_σ→L²_σ}`, for the analytic semigroup
that `L_{ε,u}` with domain `H² ∩ L²_σ` generates on `L²_σ(T³)` (§1.1,
`lem:semigroup-spectral-growth`). \
**Lean:** `gamma u hu hε` (`FastDynamo/Dynamics/Assembly/MainGrowthRate.lean`) is the growth
bound of `literalInductionSemigroup`, the transport by `toLiteralC3L2` to
`literalSolenoidalSubspace` (A5) of the semigroup `solenoidalInductionSemigroup` on
`productSolenoidalSubspace`.  That semigroup is the one of Lemma A.1 (CA.1): its generator is
`solenoidalInductionOperator u hu ε`, the realisation of `L_{ε,u}` with domain the divergence-free
`H²` fields (`generator_solenoidalInductionSemigroup`), whose values, embedded in `H⁻²`, are the
curl form (`productL2ToHMinus2_generator_solenoidalInductionSemigroup`, A6), and every
`C₀`-semigroup on `L²_σ` with this generator is this semigroup
(`eq_solenoidalInductionSemigroup_of_generator_eq`); so `γ` is the growth bound of every such
semigroup (`gamma_eq_growthBound_of_generator_eq`).  The transport is isometric, so the operator
norms and the growth bound are those of the product semigroup
(`growthBound_literalInductionSemigroup`).  `gamma` is defined for axially independent
divergence-free `u` only (A1) and is `EReal`-valued (B4). \
**Effect:** **different form** (the product model, read on `Torus 3` through an isometry).

**B4. `γ` is defined as a `limsup` and proved to be a limit.**  (`eq:semigroup-growth-rate` and
the sentence after it) \
**Paper:** `γ` is a limit, which exists for every `C₀`-semigroup by subadditivity and local
boundedness (Engel–Nagel IV.2.2). \
**Lean:** `StronglyContinuousSemigroup.growthBound` (`FastDynamo/Dynamics/GrowthBound.lean`) is
the `limsup` in `EReal` of `t⁻¹ log ‖S(t)‖`, with value `⊥` where `S(t)` vanishes (this
integrand is `growthExponent`).  For every `C₀`-semigroup on a Banach space it is a limit and
the infimum over `t > 0` (`StronglyContinuousSemigroup.tendsto_growthExponent`, `growthBound_eq_iInf`,
`FastDynamo/Dynamics/GrowthBoundLimit.lean`), the paper's sentence after
`eq:semigroup-growth-rate`, with the limit taken in `[−∞, ∞)`.  For `γ` the limit holds at
every `(u, ε)` (`gamma_tendsto`, `FastDynamo/Dynamics/Assembly/MainGrowthRateLimit.lean`), and
it is a real number `L` with `0 ≤ L ≤ ‖∇⊥u‖_∞` (`gamma_eq_lim`,
`FastDynamo/Dynamics/Assembly/InductionMeanConservation.lean`; the field `gamma_tendsto` of
`SemigroupSpectralGrowth`).  The liminf of `eq:main-growth-conclusion` is taken of the total
extension `gammaOf` (value `0` for `ε ≤ 0`) along `𝓝[>] 0`
(`mainGrowthFloor_le_liminf_gammaOf`). \
**Effect:** **different form**, equivalent: the `limsup` is a limit.

**B5. The eigenmode clause.**  (`eq:main-spectral-conclusion`) \
**Paper:** `V^ε = e^{2πiK_εx₃}b^ε ∈ H²(T³;ℂ³) ∩ L²_σ`, `L_{ε,u}V^ε = λ_εV^ε`. \
**Lean:** `V = axialLiftH2 K b : ProductC3H2`, `productDivergenceFromH2 V = 0`, and
`(productPhysicalInductionOperator u ε).IsEigenpair λ V`, an identity in `H⁻²` (A6) between
`L²` elements; `MainPhysicalClauses` also asserts the eigenpairs of `reducedInductionOperator`
and of `productInductionOperator`.  The clause is not restated for the realisation
`solenoidalInductionOperator` of `L_{ε,u}` on `L²_σ` (A6); since `V` is divergence-free and an
eigenvector of `productInductionOperator`, whose action that realisation carries, it is an
eigenvector of it by definition. \
**Effect:** **different form** with **extra** clauses; the content of the paper's clause is
present.

**B6. "Its solution".**  (`eq:main-thm-growth`) \
**Paper:** the solution with datum `B_in^ε` obeys the norm law.  The paper names no solution
class; its well-posedness statement is the generation of the semigroup (§1.1, Lemma A.1), and its
proof of `thm:main` writes the solution down (`B^ε(t) = e^{α_εt} Re(e^{iω_εt}V^ε)`) and bounds
`‖e^{tL_{ε,u}}‖` below by `‖B^ε(t)‖/‖B_in^ε‖`, i.e. reads it as the semigroup orbit. \
**Lean:** three statements.  (a) `MainPhysicalClauses`: the explicit real curve
`realifiedEigenTrajectoryH2 λ V` is a strong solution of the curl-form equation in `H⁻²`
(`IsStrongSolution`, every `t ∈ ℝ`), real and divergence-free at every time.
(b) `MainSemigroupOrbitClauses` (`FastDynamo/Dynamics/Assembly/SemigroupOrbit.lean`, field
`semigroupOrbit`): `B_in^ε` lies in `productSolenoidalSubspace`, is non-zero, and its orbit under
`solenoidalInductionSemigroup`, the semigroup of Lemma A.1 (B3), *is* that curve for `t ≥ 0` and
obeys the norm law.  (c) The last conjunct of `MainSemigroupOrbitClauses`: every forward strong
solution `w` of the curl-form operator `productPhysicalInductionOperator u ε` with
`w(0) = B_in^ε` equals that orbit for every `t ≥ 0`, obeys the norm law and the lower bound
`e^{tγ₀}‖B_in^ε‖ ≤ ‖w(t)‖`
(`productH2Embedding_eq_solenoidalInductionSemigroup_of_isForwardStrongSolution`, from
`productPhysicalInductionOperator_forwardStrongSolutionsUnique`,
`FastDynamo/Dynamics/Assembly/PhysicalInductionUniqueness.lean`).  The solution class of (c):
curves `w : ℝ → H²(T² × T;ℂ³)` whose image in the Fourier model of `H⁻²` has derivative
`εΔw(t) + curl(u × w(t))` within `[0, ∞)` at every `t ≥ 0` (one-sided at `t = 0`,
`IsForwardStrongSolution`, A7); no divergence condition is imposed on the curve; the torus is the
product model and the velocity axially independent.  The uniqueness theorem holds for every
divergence-free `u : TransverseRealW1Inf` and `ε > 0`, without condition on the data.
`MainSemigroupOrbitClauses` also contains `MainPhysicalClausesAt` at its triple, so the curve of
(a) — a strong solution, hence a forward strong solution of the curl form — is the solution `w`
of (c) and the orbit of (b) for the same `(K, λ, b)`.  On `Torus 3`, `MainLiteralTorusClauses`
carries (b) (B7) but not (c), and the corollary `main_theorem_magnetic_scale` (C8.2) carries
neither.  The argument is B13. \
**Effect:** **different form** (a solution class the paper does not name) and **stronger** (the
definite article is a uniqueness theorem in that class).

**B7. The norm law at every real time, and further clauses.**  (`eq:main-thm-growth`) \
**Paper:** `‖B^ε(t)‖ = e^{t Re λ_ε}‖B_in^ε‖` for `t ≥ 0`. \
**Lean:** `MainPhysicalClauses` and `MainLiteralTorusClauses` assert it for every `t ∈ ℝ`, add
that the curve never vanishes and the lower bound `e^{tγ₀}‖B_in‖ ≤ ‖B(t)‖` for `t ≥ 0`, and
`MainLiteralTorusClauses` restates the norm statements in `L²(Torus 3;ℝ³)` for the transported
curve `literalRealTrajectory K λ b`.  For that curve it also asserts the solution property on
`Torus 3`: a datum `B_in ∈ literalSolenoidalSubspace` equal to the complexification
(`complexifyLiteralR3L2`) of the curve at time `0`, whose orbit under
`literalInductionSemigroup` — the semigroup whose growth bound is `γ` (B3) — is the
complexification of the curve at every `t ≥ 0`.  The proof transports the product-model orbit
identity of B6(b) through `solenoidalToLiteral` and `toLiteralC3L2_complexifyProductR3L2`. \
**Effect:** **stronger**.

**B8. Topological entropy.**  (`thm:main`, last sentence; §1.2; `prop:particle-flow`) \
**Paper:** `h_top` of a continuous self-map of a compact metric space, defined by reference to
Hasselblatt–Katok §2.5e; `Φ_t` is the (unique) particle flow of `u`. \
**Lean:** `HasZeroTopologicalEntropy F := Dynamics.coverEntropy F Set.univ = 0` (Mathlib's cover
entropy on the uniform space `Torus 3`); `MainTheoremDynamicalClauses` carries an explicit conjunct
`∀ t, Continuous (Φ t)`.  `Φ` is existentially quantified as a flow satisfying `IsParticleFlow` (ODE
along periodic lifts) inside `IsIdealInductionGroup`; at the witnesses it is `mainLiteralFlow`,
proved to be the only such flow (`existsUnique_isParticleFlow_mainLiteralVelocity`). On a compact
metric space cover entropy is the Bowen–Dinaburg entropy; the bridge to another definition is not
invoked.  The proof route is C4.7. \
**Effect:** **different form**.

**B9. The ideal solution group.**  (`thm:main`, last display; §1.2; `cor:ideal-growth`) \
**Paper:** `𝒯₀(t)` is *the* solution group of the ideal induction equation on `L²_σ(T³)`. \
**Lean:** `MainTheoremDynamicalClauses` quantifies existentially over a group `T` on
`literalSolenoidalSubspace` (A5) satisfying `IsIdealInductionGroup`
(`FastDynamo/Dynamics/ParticleFlow.lean`): group laws, strong continuity, the Cauchy formula
`eq:ideal-cauchy-formula` coordinatewise, `DΦ_t` the a.e. Fréchet derivative of a periodic lift
of `Φ_t`, measure preservation of `Φ_t`, and the fields `solutionGroup` (`T` is a solution group
of the ideal induction equation, `IsIdealSolutionGroup`) and `unique` (every solution group is
`T`).  So `T` is *the* solution group, in the weak sense of C4.4.  At the witnesses
`T = mainIdealGroup` (`existsUnique_isIdealSolutionGroup_mainLiteralVelocity`,
`FastDynamo/Dynamics/MainLagrangianClauses.lean`).  The norm is the operator norm on
`literalSolenoidalSubspace`; `lim` is `Filter.Tendsto … atTop`. \
**Effect:** **different form** (the notion of solution of C4.4; the existential over a group
characterised by uniqueness).

**B10. Remark 1.6 (normalisation).** \
**Paper:** with `M = max{1, ‖u‖_{W^{1,∞}}}`, `ũ = u/M`, Theorem 1.2 holds for `ũ` with
`ε₀/M`, `γ₀/M`; `γ(ũ,ε) = M⁻¹γ(u,Mε)`; the flow and ideal group of `ũ` are those of `u` at
time `t/M`; every conclusion survives. \
**Lean:** `MainTheoremNormalized`, proved by `mainTheoremNormalized_holds`
(`FastDynamo/MainTheoremNormalized.lean`), at `ũ = normalizedVelocity mainVelocity =
M⁻¹ mainVelocity`, `M⁻¹ = velocityNormalizer mainVelocity`: `‖ũ‖ ≤ 1`
(`norm_normalizedVelocity_le_one`); the action identity `A_{ε,ũ} = M⁻¹A_{Mε,u}`
(`productInductionAction_normalizedVelocity`); the semigroup identity
`e^{tL_{ε,ũ}} = e^{(t/M)L_{Mε,u}}` on `L²_σ` (`literalInductionSemigroup_normalizedVelocity`,
through `StronglyContinuousSemigroup.timeRescale`, `FastDynamo/Dynamics/SemigroupTimeRescaling.lean`)
and `γ(ũ,ε) = M⁻¹γ(u,Mε)` (`gamma_normalizedVelocity`,
`FastDynamo/Dynamics/Assembly/NormalizedGrowthRate.lean`); every clause of Theorem 1.2 for `ũ`
with `M⁻¹ε₀`, `M⁻¹γ₀` — `MainPhysicalClauses`, the growth-rate clause and its liminf form
(`normalizedGrowthFloor_le_gamma`, `normalizedGrowthFloor_le_liminf_gammaOf`),
`MainSemigroupOrbitClauses` (B6) and the dynamical clauses; and for the literal velocity
`normalizedLiteralVelocity = M⁻¹ mainLiteralVelocity`: its particle flow is
`t ↦ Φ_{t/M}`, the only one (`normalizedLiteralFlow_unique`), `t ↦ 𝒯₀(t/M)` is its ideal
induction group in the sense of `IsIdealInductionGroup`, hence its unique solution group
(`isIdealInductionGroup_normalizedLiteralVelocity`, `IsIdealInductionGroup.timeRescale`,
`FastDynamo/Dynamics/NormalizedLagrangianClauses.lean`), and `MainLagrangianClauses` hold for it.
Differences: `M = max(1, ‖u‖)` uses the norm of `TransverseRealW1Inf` (A1); the paper does not
specify the norm `‖u‖_{W^{1,∞}}`, and every identity holds for any `M > 0`.  The action identity is
stated for the auxiliary action `productInductionAction` on all of `H²`, which on divergence-free
fields is the action of `solenoidalInductionOperator` (A6); the paper states it for `L_{ε,u}` on
`H² ∩ L²_σ`.  `MainLagrangianClauses` for `ũ` carry the constant `(1 + M⁻¹)C_L`
(`MainLagrangianClauses.smul`); the paper restates no constants.  The fields `normalized` and
`normalizedWitness` of `MainTheoremStrengthened` (`MainPhysicalConclusionNormalized`,
`mainPhysicalClauses_normalizedVelocity`, `reducedInductionOperator_isEigenpair_smul_iff`,
`FastDynamo/Operator/ReducedInductionScaling.lean`) are the spectral clauses alone. \
**Effect:** **different form**; every conclusion of the remark is present.

**B11. Additional content of the Lean statement.**
`MainTheoremStrengthened` and `MainTheoremComplete` also assert: `mainEps0 = δ₊/K₀²` (the
paper's choice in §3.2) and `mainGrowthFloor = g_*` (the paper's choice in the proof of
`thm:main`), with `mainGrowthFloor ≥ (3/4)(448 − 4π²) ≥ 288` (C2.3); the ceiling
`γ(u,ε) ≤ ‖∇⊥u‖_∞` (`gamma_le_stretching`); Proposition 7.1 in eigenpair form at every
admissible cell (`MainEveryAdmissibleCellClauses`); the regularity of the velocity (C3.5); the
literal-torus clauses (B7); and, as `MainLagrangianClauses`, `prop:particle-flow` and the
per-datum bounds of `cor:ideal-growth`.  `ideal_resistive_gap_holds` packages
`γ_id(u) = 0 < γ₀ ≤ liminf γ(u,ε)`, a chain whose three members the paper states separately. \
**Effect:** **stronger** (extra clauses).

**B12. Argument for the growth-rate clause.**  (proof of `thm:main`) \
**Paper:** divides the exact growth law of the real datum by `‖B_in^ε‖` to get
`‖e^{tL}‖ ≥ e^{α_εt}`, hence `γ ≥ α_ε ≥ γ₀`. \
**Lean:** `gamma_ge_gamma0` uses the complex eigenmode `V^ε` instead: the reduced eigenpair is
lifted to an eigenpair of the auxiliary operator, `V^ε` is placed in `productSolenoidalSubspace` by
the auxiliary solenoidality theorem
(`productH2Embedding_mem_productSolenoidalSubspace_of_isEigenpair`: eigenfunctions of the auxiliary
operator with `Re λ > 0` are divergence-free, E2), and
`re_le_growthBound_solenoidalInductionSemigroup_of_eigenpair` gives `Re λ ≤ γ`. \
**Effect:** **different route**, same inequality.

**B13. Argument for "its solution".**  (`eq:main-thm-growth`; B6) \
**Paper:** gives no uniqueness argument; it identifies the explicit curve `B^ε(t)` with the
semigroup orbit. \
**Lean:** the curve is the semigroup orbit by uniqueness of forward strong solutions of the
auxiliary operator (C8.4).  Uniqueness for the curl form
(`productPhysicalInductionOperator_forwardStrongSolutionsUnique`,
`FastDynamo/Dynamics/Assembly/PhysicalInductionUniqueness.lean`) is reduced to it in three
steps: the divergence of a forward strong solution solves, Fourier mode by Fourier mode, the heat
equation `ċ = −4π²ε|ξ|²c`, because the curl term has no divergence, so divergence-free data stay
divergence-free (`productDivergenceFromH2_eq_zero_of_isForwardStrongSolution`); on divergence-free
fields the curl form is the `H⁻²` embedding of the auxiliary action
(`productInductionAction_toHMinus2_eq_physical`); the resolvent `R(r)` of the auxiliary operator
is bounded from the `H⁻²` norm (`exists_norm_stateResolvent_le_productL2ToHMinus2`,
`FastDynamo/Dynamics/Assembly/NegativeSobolevResolvent.lean`, from the energy inequality and the
skewness of transport), so `R(r)` applied to the difference of two solutions is a forward strong
solution of the auxiliary operator with zero datum, hence zero
(`productInductionOperator_forwardStrongSolutionsUnique`, E3), and `R(r)` is injective. \
**Effect:** **different route** (an argument the paper does not give).

**B14. The Challenge statement.**  (`thm:main`) \
**Paper:** Theorem 1.2 as printed, with the objects of §1.1: `W^{1,∞}` velocities, `L²_σ(T³)`,
`H²`, the operator `L_{ε,u} = curl(u × ·) + εΔ` with domain `H² ∩ L²_σ`, the growth rate
`γ(u,ε)`, the particle flow and `h_top`, the ideal solution group `𝒯₀`. \
**Lean:** `Challenge.lean` states the theorem as `FastDynamoChallenge.fast_dynamo_zero_entropy`,
with mathlib's notions and fourteen definitions of its own (`T3`, `R3`, `C3`, `L2`, `toTorus`,
`re3`, `IsDivergenceFree`, `gradChar`, `L2σ`, `MemH2`, `inductionRHS`, `IsInductionSemigroup`,
`IsIdealGroup`, `IsFlow`); `FastDynamo/Palomar/Statement.lean` repeats these definitions
character for character, and `Solution.lean` proves the theorem by `challenge_statement`
(`FastDynamo/Palomar/Main.lean`) at `mainLiteralVelocity`, `mainEps0`, `mainGrowthFloor`.  The
library's results, proved in the product model `T² × T` (A2), are transported to
`UnitAddTorus (Fin 3)`, which is the type `Torus 3` of the library, by the modules of
`FastDynamo/Palomar/` (`docs/MODULE_MAP.md`).  Compared with the printed theorem:

1. The velocity is a function `u : T3 → ℝ³` with `∃ L, LipschitzWith L u` instead of a
   `W^{1,∞}` class (for a continuous representative the two agree), and `div u = 0` is
   `∑ᵢ mᵢ ûᵢ(m) = 0` for every `m ∈ ℤ³` (`IsDivergenceFree`), the distributional condition. —
   equivalent.
2. `L²_σ` is the orthogonal complement in `L²(T³;ℂ³)` of the fields `e^{2πim·x} m`
   (`L2σ`, equal to the library's `literalSolenoidalSubspace`:
   `L2σ_eq_literalSolenoidalSubspace`); `B ∈ H²` is `∑_m |m|⁴ |B̂(m)|² < ∞` (`MemH2`). —
   equivalent.
3. `L_{ε,u}B` is given by its Fourier coefficients
   `2πi ∑ⱼ mⱼ ((uᵢBⱼ)^(m) − (uⱼBᵢ)^(m)) − 4π²ε|m|² B̂ᵢ(m)` (`inductionRHS`), the divergence form
   `curl(u × B)ᵢ = ∑ⱼ ∂ⱼ(uᵢBⱼ − uⱼBᵢ)` of the curl, so that identities are identities of
   distributions. — equivalent.
4. `γ(u,ε)` is not defined.  The clause quantifies over every strongly continuous semigroup `S`
   on `L2σ` whose generator agrees with `L_{ε,u}` on `H² ∩ L²_σ` (`IsInductionSemigroup`: every
   `B ∈ H² ∩ L²_σ` has a right derivative at `0` with the coefficients of `L_{ε,u}B`), asserts
   that one exists, and states `e^{γ₀t} ≤ ‖S(t)‖` for every `t ≥ 0`.  The library proves Lemma
   A.1 for velocities independent of `x₃` (CA.1), which covers the velocity of the theorem, and
   the semigroup it gives, transported to `L2σ`, is such an `S`
   (`isInductionSemigroup_mainLiteralVelocity`).  That it is the only one — `L_{ε,u}` with
   domain `H² ∩ L²_σ` is a generator, and a generator has no proper extension that is again a
   generator — is a standard argument that is not formalised for this notion; the compared
   theorem does not use it, and its clauses hold for every such `S`.  For a `C₀`-semigroup,
   `γ = lim_{t→∞} t⁻¹ log ‖S(t)‖ = inf_{t>0} t⁻¹ log ‖S(t)‖` (for the library's semigroups:
   `growthBound_eq_iInf`), so `e^{γ₀t} ≤ ‖S(t)‖` for every `t ≥ 0` is equivalent to
   `γ(u,ε) ≥ γ₀`, and it gives the `liminf`. — equivalent.
5. The eigenmode `V^ε = e^{2πiK_εx₃} b^ε` with `0 ≠ b^ε ∈ H²(T²;ℂ³)` is a non-zero `V ∈ L2σ` with
   `MemH2 V` whose Fourier coefficients vanish off the plane `m₃ = K`; `L_{ε,u}V = λV` is the
   identity `inductionRHS u ε V = λ V̂` at every frequency, that is, in the sense of
   distributions. — equivalent.
6. "Its solution" is the orbit `S(t)B_in` for `t ≥ 0`, for every `S` as in item 4 (B6): it is
   `Re(e^{tλ}V)` almost everywhere and has norm `e^{t Re λ}‖B_in‖`.  Real fields are elements of
   `L²(T³;ℂ³)` with real entries: `B_in` is a field of `L2σ` equal almost everywhere to
   `x ↦ Re V(x)` (`re3`). — equivalent.
7. The flow is characterised through the periodic lift: `Φ_0 = id` and every trajectory is the
   image of an integral curve of `a ↦ u(a mod ℤ³)` (`IsFlow`, equivalent to the library's
   `IsParticleFlow`: `isFlow_iff_isParticleFlow`).  Existence is asserted and the entropy clause
   holds for every such flow, with every `Φ_t` continuous; topological entropy is mathlib's
   `Dynamics.coverEntropy` (Bowen–Dinaburg entropy, through covers by dynamical balls; B8). —
   different form.
8. `𝒯₀` is the unique strongly continuous group of operators on `L2σ` whose orbits solve
   `∂ₜB = curl(u × B)` tested against the characters and integrated in time
   (`IsIdealGroup`: `B̂ᵢ(t)(m) − B̂ᵢ(s)(m) = ∫ₛᵗ inductionRHS u 0 B(τ) m i dτ`); existence,
   uniqueness and `t⁻¹ log ‖𝒯₀(t)‖ → 0` are asserted.  Every such group is, after transport, a
   solution group in the sense of C4.4 (`isIdealSolutionGroup_of_isIdealGroup`), hence
   `mainIdealGroup`. — different form.
9. One existential block `∃ u ε₀ γ₀` carries every clause, and for each `ε` one triple
   `(K, λ, V)` carries the eigenmode, the real datum and its solution (contrast B2). — different
   form.
10. Not stated in the compared theorem, and proved in the library: the explicit `ε₀` and `γ₀`
    with `γ₀ ≥ 288` (B11), the independence of `u` of `x₃` and `u ≠ 0` (B1), Remark 1.5 (C1.4),
    Lemma A.1 (Appendix A), Remarks 1.6 and 1.7 (B10, C1.5), Corollary 8.3 (C8.2).

**Effect:** **different form**.  The growth clause is equivalent to the paper's at each
`0 < ε ≤ ε₀` (item 4); the other items are equivalent readings of the paper's notions.

---

## Part C — Section by section

Theorem 1.2 and Remark 1.6 are Part B.  The facts on `γ(u,ε)` stated in §1.1 — generation,
the existence of the limit `eq:semigroup-growth-rate`, `γ(u,ε) = sup Re σ(L_{ε,u})` and its
attainment at an eigenvalue — are clauses of Lemma A.1 in Lean (B4, CA.1).

### §1 — Definitions and remarks

#### Statements

**C1.1. The energy identity.**  (`eq:energy-competition`) \
**Paper:** formally, `½ d/dt ‖B(t)‖₂² = ∫ B·(B·∇)u dx − ε‖∇B‖₂²` for a solution of
`eq:induction`. \
**Lean:** `FastDynamo/Dynamics/EnergyIdentity.lean`, for the auxiliary operator on the product
torus and a divergence-free `u : TransverseRealW1Inf`: the operator form
`Re⟨B, A_{ε,u}B⟩ = Re⟨B, (B·∇)u⟩ − ε‖∇B‖₂²` for every `B ∈ H²` and every `ε`
(`re_inner_productInductionAction_eq`), with `‖∇B‖₂²` the sum of the squared `L²` norms of the
three weak derivatives (`productGradientEnergy`); the dynamical form along strong solutions of
the auxiliary operator at every time (`hasDerivAt_half_norm_sq_of_isStrongSolution`) and along
its forward strong solutions at every `t > 0`
(`hasDerivAt_half_norm_sq_of_isForwardStrongSolution`); its instance at the real solution
`B^ε(t)` of Theorem 1.2 (`realStrongSolution_hasDerivAt_half_norm_sq`); and the dynamical form
for the curl form itself: along every forward strong solution `w` of
`productPhysicalInductionOperator u ε` with `ε > 0` and `Div w(0) = 0`, at every `t > 0`
(`hasDerivAt_half_norm_sq_of_isForwardStrongSolution_physical`,
`FastDynamo/Dynamics/Assembly/PhysicalInductionUniqueness.lean`; such a `w` is the semigroup
orbit, B13).  The fields are complex and the real part of the `L²` pairing replaces
`∫ B·(B·∇)u` (they agree for a real field); the pairing is Mathlib's, conjugate linear in the
first slot (A8), which does not change its real part.  The auxiliary forms do not assume
`Div B = 0`, but off divergence-free fields the auxiliary operator is not `L_{ε,u}` (A6), so
they say nothing more about the paper's equation; on divergence-free fields, where the
auxiliary and the curl forms agree, they are the paper's identity. \
**Effect:** **different form**, **stronger** in that the identity is proved rather than a formal
computation.

**C1.2. Dynamo, fast dynamo, slow dynamo.**  (§1.1) \
**Paper:** `u` is a dynamo at diffusivity `ε` when `γ(u,ε) > 0`, a fast dynamo when
`liminf_{ε↓0} γ(u,ε) > 0`, a slow dynamo when `γ(u,ε) > 0` for every sufficiently small `ε` and
`γ(u,ε) → 0`. \
**Lean:** `IsDynamoAt`, `IsFastDynamo`, `IsSlowDynamo`
(`FastDynamo/Dynamics/Assembly/FastDynamo.lean`), for divergence-free `u : TransverseRealW1Inf`
(A1), in terms of `gamma` and its total extension `gammaOf` (B4), with limits along `𝓝[>] 0` in
`EReal`.  The constructed velocity is a dynamo at every `0 < ε ≤ ε₀` (`isDynamoAt_mainVelocity`)
and a fast dynamo (`isFastDynamo_mainVelocity`); no fast dynamo is a slow dynamo
(`IsFastDynamo.not_isSlowDynamo`), which the paper does not state. \
**Effect:** **different form**; **narrower** in the class of velocities (A1).

**C1.3. Remark 1.4: the real part of the eigenmode is not an eigenmode.**  (the remark after
`rem:subsequent-resolution`) \
**Paper:** if `Im λ_ε ≠ 0`, `Re V^ε` is not an eigenfunction of `L_{ε,u}`. \
**Lean:** `not_isEigenpair_productRealPartH2` (`FastDynamo/Finish/RealPartNotEigenmode.lean`):
for every divergence-free `u : TransverseRealW1Inf`, every `ε`, and every divergence-free
eigenpair `(λ, V)` of the curl-form operator `productPhysicalInductionOperator u ε` with
`Im λ ≠ 0`, `Re V` is an eigenvector of that operator for no eigenvalue.  It uses that `V` is
divergence-free, the paper's definition of a magnetic eigenmode, but not that `Re V` is. \
**Effect:** **different form** (product model, `H⁻²` realisation of A6), **stronger** (every
eigenmode, not only `V^ε`).

**C1.4. Remark 1.5: zero spatial mean.**  (`rem:scope-intro`) \
**Paper:** since `K_ε ≠ 0`, every magnetic field constructed in the paper has zero spatial mean;
the other sentences of the remark say which objects depend on `ε`, list what is not asserted,
and state the regularity of the velocity (C3.5). \
**Lean:** `HasZeroMean V` (`FastDynamo/Finish/ZeroMean.lean`): the zeroth Fourier coefficient
of every component of the product-torus field `V` vanishes, which is its integral
(`productCoeffCLM_zero_zero_eq_integral`).  Proved for the axial mode `e^{2πiKx₃}b` with `K ≠ 0`
(`hasZeroMean_axialLiftH2`), its real part (`HasZeroMean.realPart`), and the real solution
`B^ε(t)` as the `H²` representative and as the explicit real `L²` curve
(`hasZeroMean_realifiedEigenTrajectoryH2`, `hasZeroMean_complexify_realAxialTrajectory`,
`hasZeroMean_complexify_realAxialInitialField`), for every `K ≠ 0`, `λ`, `b`.  Real fields are
read in `ℂ³` through their complexification; the mean is taken for the product measure (A3). \
**Effect:** **different form**.

**C1.5. Remark 1.7: the vanishing-diffusivity limit.** \
**Paper:** for each `B_in ∈ L²_σ`, `e^{tL_{ε,u}}B_in → 𝒯₀(t)B_in` strongly in `L²` as `ε ↓ 0`,
uniformly on bounded time intervals in `[0, ∞)`.  The remark follows Theorem 1.2 and Remark 1.6
and does not name the velocity. \
**Lean:** `tendstoUniformlyOn_resistiveEvolution_mainIdealGroup B T`
(`FastDynamo/Dynamics/VanishingDiffusivity/Limit.lean`): for every `B` in
`literalSolenoidalSubspace` and every `T`, `resistiveEvolution ε t B → mainIdealGroup t B` as
`ε → 0⁺` (`𝓝[>] 0`), uniformly in `t ∈ [0, T]`, in the norm of `L²(Torus 3;ℂ³)`.  The velocity is
the one constructed in the paper (`mainVelocity`, read on `Torus 3` as `mainLiteralVelocity`);
`mainIdealGroup` is its ideal solution group (B9, C4.3).  `resistiveEvolution ε t` is
`literalInductionSemigroup mainVelocity _ hε (Real.toNNReal t)` for `ε > 0`, the semigroup of
Lemma A.1 transported to `Torus 3` (B3); it is `0` for `ε ≤ 0` and clamps negative times to `0`,
conventions the limit along `ε → 0⁺` on `[0, T]` does not see.  Uniform convergence on every
`[0, T]` is the paper's uniformity on bounded time intervals.  No statement is made for other
velocities. \
**Effect:** **different form**, for the velocity of Theorem 1.2 only (**narrower** if the remark is
read for every Lipschitz divergence-free velocity).

#### Arguments

**C1.6. Route of Remark 1.7.** \
**Paper:** the Trotter–Kato approximation theorem (Engel–Nagel III.4.8) and the Friedrichs
commutator lemma (DiPerna–Lions, Lemma II.1). \
**Lean:** a direct energy estimate against the mollified ideal orbit; Trotter–Kato is not used.
For a mollification scale `δ`, the resistive semigroup is started at `J_δB`
(`productMollifyH2`, `FastDynamo/Dynamics/VanishingDiffusivity/ProductBridge.lean`) and compared
with `J_δ𝒯₀(t)B`, which is differentiable in `t` (`hasDerivAt_literalMollify_mainIdealGroup`,
from the weak form of C4.4); the difference starts at `0` and solves the resistive equation up
to the residual `εΔJ_δ𝒯₀(t)B + K_δ𝒯₀(t)B + (Str J_δ − J_δ Str)𝒯₀(t)B`, `K_δ` the Friedrichs
commutator (`toLiteralC3L2_productInductionAction_productMollifyH2`,
`norm_productInductionAction_productMollifyH2_sub_le`); dissipativity
(`re_inner_productInductionAction_le`) and Grönwall bound the difference by the residual
(`norm_productInductionSemigroup_sub_literalMollify_le`); on the compact orbit
`{𝒯₀(t)B : t ∈ [0, T]}` the commutator and the mollification errors are uniformly small for
small `δ` (`tendsto_friedrichsCommutator`, `tendstoUniformlyOn_literalMollify`); `δ` is chosen
first and then `ε` (`norm_mainIdealGroup_sub_resistiveEvolution_le`).  The commutator lemma is
proved on `Torus 3`, in `L²`, for the commutator `K_δ = Σ_j [∂_jρ_δ ∗ ·, v_j]`
(`friedrichsCommutator`, `FastDynamo/Analysis/LiteralFriedrichsCommutator.lean`) of a Lipschitz
velocity `v` whose periodic lift is differentiable at every point with pointwise vanishing
divergence (`exists_norm_friedrichsCommutator_le`, a bound uniform in `0 < δ ≤ 1`, and
`tendsto_friedrichsCommutator`, convergence to `0` uniformly on compact sets of `L²`), with the
mollifier `J_δ = literalMollify δ` of `FastDynamo/Analysis/LiteralTorusMollifier.lean` (E10); the
paper's velocity satisfies these hypotheses (`lipschitzWith_mainLiteralVelocity`,
`differentiable_literalVelocity_lift`, `sum_literalFDeriv_literalVelocity_diag`). \
**Effect:** **different route**.

### §2 — The local model

#### Statements

**C2.1. Shape of the sectorial estimate.**  (§2.1, `eq:sectorial-estimate-b` and the display after
it) \
**Paper:** `Re 𝔩_w(b,b) ≥ ½‖∇⊥b‖² − C‖b‖²` and `|Im 𝔩_w(b,b)| ≤ Re 𝔩_w(b,b) + C‖b‖²`. \
**Lean:** `horizontalWeakForm_garding` and `horizontalWeakForm_abs_im_le`:
`|Im 𝔩_w(b,b)| ≤ C'‖b‖²_{H¹}` with `C' = horizontalImaginaryConstant N w = (5 + |N|)‖w‖_∞`; after
the Gårding shift, `horizontalShiftedWeakForm_sectorial` gives
`|Im 𝔩| ≤ 2C' Re 𝔩` (`FastDynamo/Local/HorizontalWeakForm.lean`). \
**Effect:** **different form**; both give a closed sectorial form.  The imaginary-part bound
with slope one is formalised only in this form, with slope `2C'` after the shift.

**C2.2. The jump flow.**  (`eq:jump-flow`) \
**Paper:** `V⁰ = 1_{r<1}(Ωre_θ + Ue₃)`, `U = −Ω/(2π)`. \
**Lean:** `horizontalJumpVelocity` uses `1_{r≤1}` (equal almost everywhere) and `U = −Ω/N`
(A9). \
**Effect:** none in content.

**C2.3. Lemma 2.1: explicit numerals and the side clauses.**  (`lem:jump-horizontal-mode`,
`eq:local-eigenvalue`) \
**Paper:** `κ = ϱ(1+it)`, `t ∈ [½,¾]`, `ϱ` "sufficiently large"; `Re λ_* ≥ (7/16)ϱ² − 4π² > 0`
"increasing `ϱ` if necessary".  The eigenfunction has the form `e^{iθ}(B_re_r + B_θe_θ)`, is
smooth on each side of `r = 1` and decays exponentially. \
**Lean:** `exists_certifiedInterfaceData_of_segment`
(`FastDynamo/Local/PonomarenkoSegmentRoot.lean`) works for `ϱ ≥ 32` under the hypothesis `N² <
(7/16)ϱ²`, with an explicit remainder; it is applied at `N = 2π`, `ϱ = 32`
(`exists_certifiedInterfaceData_two_pi`), giving `Re λ_* ≥ 448 − 4π²`
(`exists_horizontalMode_eigenpair_two_pi`, `FastDynamo/Local/HorizontalModeEigenpair.lean`).  The
side clauses are separate declarations: smoothness inside (`horizontalInteriorField_contDiff`) and
outside (`horizontalExteriorField_contDiffAt`), and decay in the form of an exponential `L²` tail
bound (`horizontalMode_tail_le`). \
**Effect:** **choice** (`ϱ = 32`; the paper fixes no `ϱ`) and **stronger** (explicit bound);
the decay clause is in **different form** (an integrated tail bound).

**C2.4. Hypothesis of the compactness step.**  (§2.3) \
**Paper:** `w ∈ L^∞(ℝ²;ℝ³)` with compact support in `D(0,R_w)`; Rellich on `D(0,R_w)`. \
**Lean:** `w = 0` a.e. outside a measurable set of finite measure; local Rellich for such sets
(E9). \
**Effect:** **stronger** (weaker hypothesis).

**C2.5. Spectral isolation.**  (§2.3, analytic Fredholm paragraph) \
**Paper:** `𝔸_w(z)` is invertible off a discrete subset of `{Re z > 0}`; at each exceptional
point index zero gives a non-zero kernel, identified with `ker(z − A_w)`; hence the spectrum
of `A_w` there consists of isolated eigenvalues (no multiplicity is asserted). \
**Lean:** `horizontalSpectrum` is *defined* as the set of `z` with `Re z > 0` at which the
form pencil `𝔸_w(z)` is not invertible; `isDiscrete_horizontalSpectrum` and
`exists_punctured_ball_isInvertible_horizontalPencilForm`
(`FastDynamo/Local/HorizontalModeIsolation.lean`) prove its discreteness, and
`mem_horizontalSpectrum_iff` (`FastDynamo/Local/HorizontalSpectrumEigenvalue.lean`) identifies
it with the set of eigenvalues of the form operator `A_w` in `{Re z > 0}`, with eigenvectors in
the form-operator domain `HorizontalFormDomain`, the paper's `D(A_w)`
(`exists_isEigenpair_of_mem_horizontalSpectrum`: the Fredholm alternative for the compact part
of the factorisation `𝔸_w(z) = F_z(1 − K(z))` gives a non-zero null vector, i.e. index zero in
the form "injective implies invertible").  In addition the Riesz projection of every isolating
circle has finite rank (`finiteDimensional_projection_range`,
`FastDynamo/Local/HorizontalModeContour.lean`). \
**Effect:** **different form** (the spectrum is defined through the form pencil and identified
with the eigenvalues) and **stronger** (finite rank, which is not used downstream).

**C2.6. Choice of the contour `Γ`.**  (§2.3, `eq:spectral-gap`) \
**Paper:** any positively oriented circle whose closed interior `𝒢` lies in `{Re z > 0}` and
isolates `λ_*`. \
**Lean:** a circle centred at `λ_*` of radius at most `Re λ_*/4` (`HorizontalIsolation.radius_le`,
`modeIsolation`), so that `g_* ≥ (3/4) Re λ_*`; with C2.3, `g_* ≥ (3/4)(448 − 4π²) ≥ 288`
(`seedGrowthFloorBound`, `mainGrowthFloor_ge_three_quarters`, `mainGrowthFloor_ge_numeric`). \
**Effect:** **choice**.

**C2.7. The smoothed velocity `v_h`.**  (`eq:smooth-local-velocity`) \
**Paper:** `0 < h < 1/2` and some smooth radial cut-off `χ_h` with the stated properties. \
**Lean:** a concrete cut-off, `Real.smoothTransition` of the squared radius
(`FastDynamo/Local/ParameterizedRadialSmoothing.lean`); `v_h` is a Schwartz field
(`parameterizedSmoothedVelocity`).  The width ranges over `(0,1)` (`PonomarenkoSmoothingWidth`). \
**Effect:** **choice**; the record admits more widths than the paper (see C2.8).

**C2.8. Proposition 2.2.**  (`prop:local-seed`, `eq:local-continuation-bound`,
`eq:local-spectral-witness`) \
**Paper:** `h ∈ (0,½)`, `f_* ∈ C_c^∞(ℝ²;ℂ²)` with `‖f_*‖ = 1`, `supp f_* ⊂ D(0,L_*)`,
`L_* > 0`; the uniform bound is `L² → H¹`. \
**Lean:** `LocalSeedC2` (`FastDynamo/Local/LocalSeedC2.lean`), inhabited by
`exists_localSeedC2_two_pi` (`FastDynamo/Local/LocalSeedC2Concrete.lean`).  `f_*` is a unit
`L²` field vanishing a.e. outside `D(0,L_*)` — the renormalised indicator truncation of a unit
vector of `Ran P⁰` (`exists_horizontalSeedWitness`, `FastDynamo/Local/HorizontalSeedWitness.lean`);
`L_* ≥ 1`; the width satisfies `h ≤ ½` at the concrete witness (`h = ½` is not excluded) and
`h ∈ (0,1)` in the record; the uniform bound is `L² → H²`. \
**Effect:** **weaker** for `f_*` (no smoothness; nothing downstream uses it) and for `h`
(nothing downstream uses `h < ½`); **stronger** for the resolvent bound.

#### Arguments

**C2.9. Cross-normalised Bessel branches.**  (proof of `lem:jump-horizontal-mode`,
`eq:bessel-solutions`) \
**Paper:** `C_± I_ν(κr)/I_ν(κ)` inside, `C_± K_ν(κr)/K_ν(κ)` outside, normalised by
`S = C₊ + C₋ = 1`; the denominators are non-zero by `eq:bessel-product-expansion`. \
**Lean:** `K_ν(κ)I_ν(κr)` inside and `I_ν(κ)K_ν(κr)` outside, which match at `r = 1`
identically; the Lean mode is a non-zero constant multiple of the paper's.  The values
`I_ν(κ), K_ν(κ)`, `ν = 0,1,2`, are proved non-zero on the whole segment by collapse identities
and `|κ| > 3` (`modifiedBessel_denominators_ne_zero_on_segment`), not from the expansion, and
`b ≠ 0` is read off from `K₀(κ) ≠ 0` (`horizontalModeL2_ne_zero`). \
**Effect:** **different route**.

**C2.10. The dispersion asymptotics.**  (`eq:bessel-product-expansion`, display after
`eq:dispersion`) \
**Paper:** quotes the DLMF product expansions for `ν ∈ {0,2}` with an unquantified
`O(ϱ⁻⁵)`. \
**Lean:** proves `‖ϱ³𝒟(ϱ(1+it)) − (1+it)⁻³‖ ≤ 225/(4ϱ²)` for `ϱ ≥ 2`, `|t| ≤ ¾`, through
the order-one product `zI₁(z)K₁(z)` and the identity `z³𝒟(z) = 2z − 4zI₁K₁`, a sectorised
estimate from Gaussian representations and a Cauchy estimate
(`FastDynamo/Local/PonomarenkoSegmentDispersion.lean`,
`FastDynamo/Local/PonomarenkoSectorOrderOneProduct.lean`).  The intermediate-value step and the
choice `Ω = −2/Im 𝒟(κ)` are the paper's; Lean records `Im(1+it)⁻³ ≤ −1/3` where the paper
uses `< 0`. \
**Effect:** **different route**, with explicit constants.

**C2.11. `F_z` is an isomorphism.**  (§2.3) \
**Paper:** by the Fourier multiplier `(z + |ξ|² + 4π²)⁻¹`. \
**Lean:** by coercivity and Lax–Milgram (`freeHorizontalFormEquiv`,
`FastDynamo/Local/HorizontalFormOperator.lean`). \
**Effect:** **different route**.

**C2.12. The analytic Fredholm theorem is proved, not cited.**  (§2.3) \
**Paper:** cites [GGK90, XI, Cor. 8.4]; Rellich's theorem and compactness of the adjoint are
quoted. \
**Lean:** codiscreteness of the invertible locus on a connected domain is proved from local scalar
reductions — a finite-rank regularisation and a determinant
(`AnalyticFredholm.LocalScalarReductionCover`,
`FastDynamo/Operator/AnalyticFredholm.lean`,
`FastDynamo/Operator/AnalyticFredholmContinuation.lean`, applied in
`FastDynamo/Local/HorizontalModeIsolation.lean`); Schauder's theorem (`isCompactOperator_adjoint`,
`FastDynamo/Operator/CompactAdjoint.lean`) and local Rellich are proved in the repository (E9). \
**Effect:** **different route** (self-contained proofs of quoted theorems).

**C2.13. Domain identification.**  (proof of `prop:local-seed`, "whence `b ∈ H²`") \
**Lean:** supplies the whole-plane Fourier elliptic-regularity step
(`FastDynamo/Local/HorizontalFormStrongIdentification.lean`). \
**Effect:** none in content (a step the paper leaves implicit).

### §3 — The velocity field on `T³`

#### Statements

**C3.1. The axial cut-off `ϑ`.**  (§3.3) \
**Paper:** any `ϑ ∈ C_c^∞([0,∞))`, `0 ≤ ϑ ≤ 1`, `ϑ = 1` on `[0,¾]`, `supp ϑ ⊂ [0,1)`. \
**Lean:** a concrete such cut-off built from `Real.smoothTransition`
(`ScaleFamily.TorusCellPlacement.axialPlateauBump`,
`FastDynamo/Global/TorusAxialVelocityChartFields.lean`). \
**Effect:** **choice**.

**C3.2. The placement chart.**  (§3.3) \
**Paper:** the square `(−¼,¼) × (¼,¾)`; the placement shows that every cell `D(p_n,R_n)` lies in
it. \
**Lean:** its right half `(0,¼) × (¼,¾)` (`placementChart`,
`FastDynamo/Global/TorusCellPlacement.lean`), which contains every cell; the fundamental box
is `(0,1]²`. \
**Effect:** **choice**; the same discs.

**C3.3. The radius `R_v`.**  (§3.3) \
**Paper:** any `R_v ≥ L_*` with `supp v ∪ supp ∇v ⊂ D(0,R_v)`. \
**Lean:** `R_v = max(1+h, L_*)` (`GlobalSeedInterface.placementRadius`,
`FastDynamo/Global/GlobalParameterChoice.lean`); the placement is made once at `R_v` and read
back at radius `1+h` (`ScaleFamily.TorusCellPlacement.restrictSupportRadius`). \
**Effect:** **choice**.

**C3.4. Explicit thresholds on `K₀` and `τ`.**  (§3.2, §3.3, `eq:chart-packing`,
`eq:local-support-in-buffer`; summary paragraph at the end of §7.2) \
**Paper:** "`K₀` sufficiently large" for the packing; the explicit sufficient condition
`K₀ > (10R_v)²` for the core containment; `τ` from `eq:axial-separation-choice`. \
**Lean:** the parameter record `GlobalParameterChoice`
(`FastDynamo/Global/GlobalParameterChoice.lean`) has fields for the joint placement (packing and
core containment), `eq:background-diffusion-small` and `eq:error-small`, in the paper's order (seed
data, `q`, `ϑ`, `τ`, `K₀`).  The core containment is obtained from `R₀ < 1/(10(R_v+1))`, i.e. `K₀ >
k_*(10(R_v+1))²` (`exists_ge_chartPacking_supportFit_bufferRadius_zero_lt`,
`ScaleFamily.supportScale_lt_tenth_buffer`), slightly larger than the paper's threshold; the packing
threshold is explicit.  `τ` and `K₀` are closed terms of `mainParameterChoice`. \
**Effect:** **choice** (explicit, sufficient thresholds).

**C3.5. Lemma 3.1 and §3.4: where the regularity statements live.**  (`lem:global-velocity`,
`rem:scope-intro`, `sec:lipschitz-obstruction`) \
**Paper:** `u` is smooth away from `{p_∞} × T`, differentiable on that circle with derivative
zero, Lipschitz; `Du` is discontinuous on the circle, so `u ∉ C¹`. \
**Lean:** `W^{1,∞}` membership is by type (A1).  The qualitative statements are proved for
the chart-side representative `mainVelocityChartRepresentative` (`GlobalVelocityQualitative`)
and its `ℤ²`-periodisation `mainVelocityPeriodizedRepresentative`
(`differentiable_mainVelocityPeriodizedRepresentative`,
`contDiffAt_mainVelocityPeriodizedRepresentative`,
`fderiv_mainVelocityPeriodizedRepresentative_accumulationPoint`,
`not_continuousAt_fderiv_mainVelocityPeriodizedRepresentative`,
`FastDynamo/MainTheoremStrengthened.lean`), not as smoothness on the manifold `T³`; the
Lipschitz property is proved on `T²` and on `Torus 3`.  `u ≠ 0` is proved for `τ > 0`, which
holds at the witnesses. \
**Effect:** **different form** (statements on the plane representative and its periodisation).

#### Arguments

**C3.6. `W^{1,∞}` membership.**  (proof of `lem:global-velocity`) \
**Paper:** `u` is differentiable everywhere with `‖Du‖ ≤ ‖∇v‖_∞ + η_ax`; mean-value theorem on
the periodic lift; the weak derivative of a Lipschitz function agrees a.e. with the classical
one. \
**Lean:** the first two steps as in the paper, with an explicit constant
`mainVelocityLipschitzBound` and a further factor `2` for the periodisation
(`lipschitzWith_mainLiteralVelocity`); the last step is replaced by constructing the Fourier graph
element directly (a dominated limit of Fourier coefficients for the helical part, an absolutely
convergent `L^∞` series for the axial part; `FastDynamo/Global/TorusFullVelocityConcrete.lean`,
`FastDynamo/Global/TorusGlobalVelocityRegularity.lean`). \
**Effect:** **different route**.

**C3.7. Minor points of §3.**  The distance bound to `p_∞` is proved in the strict form
`> 3R_n` (paper `≥ 3R_n`); §3.4 extracts only the entry `Ω` of `Du(p_n)`, which suffices for the
discontinuity.  **Effect:** none.

### §4 — Particle dynamics and the ideal group

#### Statements

**C4.1. Renderings in Proposition 4.1.**  (`prop:particle-flow`, `eq:linear-flow-lipschitz`) \
**Paper:** `Lip` is the optimal Lipschitz constant (§1.2); `Lip(Φ_t) + Lip(Φ_t⁻¹) ≤ C_L(1+|t|)`;
`lim_{|t|→∞} |t|⁻¹ log Lip(Φ_t) = 0`. \
**Lean:** the bound is stated with existentially quantified admissible constants for `Φ_t` and
`Φ_{−t}`, together with `Φ_{−t} ∘ Φ_t = id` as a separate clause (`MainLagrangianClauses`,
`forall_literalFlow_neg_literalFlow`); the optimal constant is `lipConst`, an `sInf` not proved
to be attained (`FastDynamo/Dynamics/Flow/LipschitzRate.lean`); `|t| → ∞` is
`Filter.cocompact ℝ` (`tendsto_abs_inv_mul_log_lipConst_literalFlow`); `C_L` is explicit
(`flowCL`, `dynamicalCL`). \
**Effect:** **different form**, equivalent.

**C4.2. The explicit formula and the fixed points.**  (`eq:explicit-particle-flow`) \
**Paper:** the formula for `y ∈ D(p_n,R_n)` in the chart; points outside the cells, on their
boundaries and on the accumulation circle are fixed. \
**Lean:** `literalFlow_eq_cell_of_mem_bufferDisk` for the fundamental-box representative of the
horizontal point; `literalFlow_eq_self_of_forall_not_mem_bufferDisk` under the hypothesis that
every integer translate misses every buffer disc; `literalFlow_eq_self_of_accumulationPoint`
(`FastDynamo/Dynamics/Flow/TorusFlow.lean`). \
**Effect:** **different form**, the same points.

**C4.3. Corollary 4.2: the solution group and its bounds.**  (`cor:ideal-growth`) \
**Paper:** for the velocity of `eq:global-u`, the statement concerns *the* solution group `𝒯₀`
of the ideal induction equation on `L²_σ(T³)` and asserts the two-sided bounds
`eq:ideal-group-growth` with the constant `C_L` of `eq:linear-flow-lipschitz`, `γ_id(u) = 0`,
the per-datum bounds and the per-datum zero rate. \
**Lean:** the group `idealGroup`, built from the Cauchy formula
(`FastDynamo/Dynamics/Ideal/IdealGroup.lean`), is a solution group in the sense of C4.4
(`isIdealSolutionGroup_idealGroup`, `FastDynamo/Dynamics/Ideal/WeakSolution.lean`) and the only
one (`IsIdealSolutionGroup.eq_idealGroup`, `existsUnique_isIdealSolutionGroup`,
`FastDynamo/Dynamics/Ideal/WeakSolutionUniqueness.lean`), at every admissible parameter tuple of
the construction; `isIdealInductionGroup_idealGroup` packages this with the Cauchy formula
(`IsIdealInductionGroup`, B9), and `existsUnique_isIdealSolutionGroup_mainLiteralVelocity` is
the statement at the witnesses.  The bounds and rates are `norm_idealGroup_bounds` and
`tendsto_inv_mul_log_norm_idealGroup`, with one constant for the Lipschitz and the group bounds
(C4.1); the group acts on `literalSolenoidalSubspace` (A5). \
**Effect:** **different form** (the notion of solution group of C4.4); the bounds are as stated.

**C4.4. The ideal induction equation: weak solutions and solution groups.**  (§1.2, the
statement of `cor:ideal-growth`, its proof) \
**Paper:** `𝒯₀` is "the solution group on `L²_σ(T³)` of the ideal induction equation"
`∂_tB + (u·∇)B − (B·∇)u = 0`, `Div B = 0`; the proof of `cor:ideal-growth` verifies the weak form
`d/dt⟨𝒯₀(t)B, φ⟩ = ⟨(𝒯₀(t)B·∇)u, φ⟩ + ⟨𝒯₀(t)B, (u·∇)φ⟩` for almost every `t` and
`φ ∈ C^∞(T³;ℂ³)`, and proves uniqueness among distributional solutions `W ∈ C([−T,T];L²)`. \
**Lean:** `FastDynamo/Dynamics/IdealWeakForm.lean`, on `Torus 3`.  `IsIdealWeakSolution v T W`:
`W : ℝ → L²(Torus 3;ℂ³)` is continuous on `[−T, T]` and, for every test field `φ` with smooth
periodic lift (`IsIdealTestField`) and all `s, t ∈ [−T, T]`,
`⟨W(t), φ⟩ − ⟨W(s), φ⟩ = ∫_s^t (⟨(W·∇)v, φ⟩ + ⟨W, (v·∇)φ⟩)`, pairings written `∫⟪φ, ·⟫`.
`IsIdealSolutionGroup v G`: `G` is a one-parameter group of operators on
`literalSolenoidalSubspace` (`G 0 = id`, `G(s+t) = G(s)G(t)`) all of whose orbits are weak
solutions on every `[−T, T]`.  Differences: the identity is tested against smooth spatial fields
and integrated in time, and its equivalence with space–time test functions is not formalised;
`Div B = 0` is not part of the notion of weak solution; `∇v` is the pointwise derivative of the
periodic lift of `v` (`literalFDeriv`, A2); the integrals are Bochner integrals.  The notions are
defined for every `v : Torus 3 → ℝ³`; existence and uniqueness of the solution group are proved
for the velocity of the paper, at every admissible parameter tuple of the construction (C4.3),
not for general Lipschitz velocities.  The uniqueness of weak solutions
(`IsIdealWeakSolution.eq_zero`) holds for `L²`-valued solutions without divergence condition.
The Cauchy group solves the weak form for every datum in `L²`, not only in `L²_σ`
(`isIdealWeakSolution_idealTransport`). \
**Effect:** **different form** of the notion of solution; **narrower** in the velocities for which
the solution group is constructed and shown to be unique.

#### Arguments

**C4.5. The flow is written down, not obtained from ODE theory.**  (opening of §4, proof of
`prop:particle-flow`) \
**Paper:** existence and uniqueness of `Φ_t` from the global Lipschitz bound
(Cauchy–Lipschitz); `eq:explicit-particle-flow` is derived by following a trajectory. \
**Lean:** `eq:explicit-particle-flow` *defines* `literalFlow`
(`FastDynamo/Dynamics/Flow/PeriodizedFlowData.lean`), and `isParticleFlow_literalFlow`
verifies the ODE by differentiating it; no existence theorem for ODEs is used.  Uniqueness is
proved separately by Grönwall on the universal cover (`IsParticleFlow.unique`,
`FastDynamo/Dynamics/Flow/ParticleFlowUniqueness.lean`) and is not used in the proof of any
clause of Theorem 1.2. \
**Effect:** **different route**.

**C4.6. The Lipschitz bound.**  (proof of `prop:particle-flow`) \
**Paper:** the natural lift of `Φ_t` is Lipschitz by Lemma 3.1, its derivative comes from
differentiating `eq:explicit-particle-flow`, and the uniform bound `‖DΦ_t‖ ≤ C(1+|t|)` gives
`Lip(Φ_t) ≤ C(1+|t|)`. \
**Lean:** the flow is shown differentiable at *every* point, including the accumulation circle
(by a quadratic-decay argument), then `lipschitzWith_of_nnnorm_fderiv_le`; uniform displacement
bounds `‖d_{n,t}‖_∞ ≤ C_tℓ_n` are also used (`FastDynamo/Dynamics/Flow/PlaneFlowLipschitz.lean`,
`FastDynamo/Dynamics/Flow/PlaneFlowRegularity.lean`). \
**Effect:** **different route**.

**C4.7. Zero entropy.**  (proof of `prop:particle-flow`, last paragraph) \
**Paper:** `m h_top(Φ_s) = h_top(Φ_{ms}) ≤ 3 log(C_L(1+m|s|))` by the power rule and the
Lipschitz entropy bound [Hasselblatt–Katok, §2.5f(3), Prop. 2.5.5]. \
**Lean:** neither the power rule nor `h ≤ 3 log Lip` is used.  The criterion
`coverEntropy_eq_zero_of_lipschitz_iterate` (`FastDynamo/Analysis/EntropyCriterion.lean`) — if
every iterate `F^[m]` is `C(1+m)`-Lipschitz then the cover entropy vanishes — is proved by a
grid-cover count (`FastDynamo/Analysis/TorusNet.lean`) and fed with
`lipschitzWith_literalFlow_iterate` (`FastDynamo/Dynamics/Flow/Entropy.lean`). \
**Effect:** **different route**.

**C4.8. Derivative, variational equation, Jacobian and measure preservation.**  (proof of
`cor:ideal-growth`, `eq:flow-variational-equation`) \
**Paper:** Cauchy–Lipschitz, Rademacher and the chain rule give `eq:flow-variational-equation`
a.e.; Liouville's formula and `Div u = 0` give `det DΦ_t = 1` a.e.; the area formula gives
measure preservation; the chain rule `DΦ_{t+s} = DΦ_t(Φ_s)DΦ_s` a.e. \
**Lean:** the closed block-matrix derivative `flowFDeriv` is the Fréchet derivative of the lift
at every point (`hasFDerivAt_literalFlowLift`; no Rademacher), with the chain rule everywhere
(`FastDynamo/Dynamics/Flow/FlowDerivative.lean`, `FastDynamo/Dynamics/Flow/PeriodizedFlowSymbol.lean`).  The variational
equation `DΦ_t(a) = id + ∫_0^t ∇u(Φ_s(a))DΦ_s(a) ds` holds at every point and every time
(`flowFDeriv_eq_one_add_integral`, with the derivative form `hasDerivAt_flowFDeriv`,
`FastDynamo/Dynamics/Flow/VariationalEquation.lean`), `∇u` being the pointwise derivative of the
lift of the velocity (`literalFDeriv`); it is proved by differentiating the integral form of the
ODE in the initial point under the integral sign (`flowDeriv_apply_eq_add_integral`: dominated
convergence and mean-value bounds), without Cauchy–Lipschitz.  The identity
`DΦ_t(x)u(x) = u(Φ_t(x))` is `flowFDeriv_apply_literalVelocity`.
`det DΦ_t = 1` is computed pointwise from the formula (`det_fderiv_planeTransverseFlow`), without
Liouville and without `Div u = 0`; measure preservation follows by a plane change of variables
(`planeMeasurePreserving_of_det_fderiv_eq_one`), invariance of the fundamental box and a
skew-product argument for the axial shear (`FastDynamo/Dynamics/Flow/MeasurePreserving.lean`). \
**Effect:** **different route**; the variational equation is proved at every point (the paper:
almost every point).

**C4.9. Preservation of the divergence constraint.**  (proof of `cor:ideal-growth`) \
**Paper:** tests against `∇ψ`, moves `Φ_t` onto `ψ`, and extends to `ψ∘Φ_t ∈ H¹` by density. \
**Lean:** orthogonality to gradients via characters and Parseval, applied to truncated smooth
flows `Φ^{(N)}`, then an `L²` limit (`FastDynamo/Dynamics/Ideal/Truncated*.lean`,
`FastDynamo/Dynamics/Ideal/SolenoidalInvariance.lean`, `FastDynamo/Dynamics/Ideal/GradientOrthogonality.lean`). \
**Effect:** **different route**.

**C4.10. The Cauchy group solves the weak form.**  (proof of `cor:ideal-growth`, "Formula
`eq:ideal-cauchy-formula` solves the ideal induction equation") \
**Paper:** writes `⟨𝒯₀(t)B, φ⟩` by measure preservation as an integral over the initial point
and differentiates it using `eq:flow-variational-equation`, for almost every `t`. \
**Lean:** `isIdealWeakSolution_idealTransport` (`FastDynamo/Dynamics/Ideal/WeakSolution.lean`):
the same change of variables `x = Φ_t(a)` and the Cauchy formula; differentiation under the
integral sign with a dominating bound `C‖B(a)‖`, the pointwise derivative of
`s ↦ ⟪φ(Φ_s a), DΦ_s(a)B(a)⟫` coming from the derivative of the lift of the flow and from
`hasDerivAt_flowFDeriv` (C4.8) (`hasDerivAt_inner_literalFlow_flowFDerivC`); the derivative
`d/dt ∫⟪φ, 𝒯₀(t)B⟫` is obtained at *every* `t` (`hasDerivAt_integral_inner_idealTransport`) and
integrated by the fundamental theorem of calculus into the time-integrated identity of C4.4, for
every `B ∈ L²`. \
**Effect:** the paper's route, at every time instead of almost every time.

**C4.11. Uniqueness of weak solutions.**  (proof of `cor:ideal-growth`, "Uniqueness follows from
the same characteristic argument") \
**Paper:** for a distributional solution `W ∈ C([−T,T];L²)` with `W(0) = 0`, Ambrosio–Crippa
(Proposition 2.3), applied componentwise after periodic extension, gives the characteristic
identity `W(t,Φ_t(a)) = ∫_0^t ∇u(Φ_s(a))W(s,Φ_s(a)) ds` a.e.; Grönwall forward and backward
gives `W = 0`. \
**Lean:** `IsIdealWeakSolution.eq_zero` (`FastDynamo/Dynamics/Ideal/WeakSolutionUniqueness.lean`)
does not use Ambrosio–Crippa.  The weak identity is extended from smooth test fields to fields
whose periodic lift is Lipschitz and differentiable at every point, by Fourier partial sums
(integration by parts against the characters, Parseval convergence of the partial sums of `φ`
and of its derivatives; `IsIdealWeakSolution.weakIdentity_of_lipschitz`, `dense_idealTestFieldL2`,
`FastDynamo/Dynamics/Ideal/LipschitzTestFields.lean`).  Tested against the Lipschitz fields
`ψ∘Φ_{−σ}`, it gives the characteristic identity in tested form
`⟨ψ, W(t)∘Φ_t⟩ = ∫_0^t ⟨ψ∘Φ_{−τ}, (W(τ)·∇)u⟩ dτ` for smooth `ψ`
(`inner_flowCompL2_eq_intervalIntegral`); density of the test fields and the isometry of
composition with `Φ_t` give `‖W(t)‖ ≤ ‖S‖ |∫_0^t ‖W‖|`, `S = literalStretchL2 u` the stretching
`B ↦ (B·∇)u` as an operator on `L²` (`norm_le_mul_abs_intervalIntegral`),
and Grönwall's inequality forward and backward in time gives `W = 0`
(`eq_zero_of_le_mul_abs_intervalIntegral`).  `IsIdealSolutionGroup.eq_idealGroup` applies this
to the difference of the orbits of two solution groups. \
**Effect:** **different route**.

**C4.12. Strong continuity.**  (proof of `cor:ideal-growth`) \
**Paper:** `∫|DΦ_t(a)B(a) − B(Φ_t(a))|² da → 0` for smooth `B`, then density. \
**Lean:** separates off the substitution `B ∘ Φ_{−t}` (strongly continuous by density of
continuous data), leaving `∫|DΦ_t(a)B(a) − B(a)|²`, handled by dominated convergence
(`FastDynamo/Dynamics/Ideal/StrongContinuity.lean`). \
**Effect:** **different route**.

**C4.13. The operator bound.**  (proof of `cor:ideal-growth`) \
**Paper:** `‖𝒯₀(t)B‖ ≤ Lip(Φ_t)‖B‖` by measure preservation. \
**Lean:** bounds `‖𝒯₀(t)B‖` by an `L^∞` bound of the symbol `DΦ_t` (`norm_idealGroup_apply_le`),
then weakens to the common constant `dynamicalCL`. \
**Effect:** **different route**.

### §5 — The horizontal operator on `T²` and the scaling identity

#### Statements

**C5.1. Lemma 5.1 without `div⊥ w⊥ = 0`.**  (`lem:torus-sector-basic`) \
**Paper:** for `w ∈ W^{1,∞}(T²;ℝ³)` with `div⊥ w⊥ = 0`: `A_{ε,K}[w]` is closed, has non-empty
resolvent set, graph norm equivalent to the `H²` norm, compact resolvent, and `z − A` is
Fredholm of index zero `H² → L²` for every `z`. \
**Lean:** `horizontalInductionOperator_basic u ε K hε : HorizontalTorusSectorBasic u ε K`
(`FastDynamo/Operator/HorizontalSectorBasic.lean`) for an arbitrary `u : TransverseRealW1Inf`, with
no divergence hypothesis.  The graph-norm clause is bundled one way, `‖b‖_{H²} ≤ ‖(z−A)⁻¹‖(|z|‖b‖ +
‖Ab‖)` at every resolvent point (the converse is continuity of the embedding and of the action);
compactness is stated for every available resolvent; index zero for every `z`
(`isFredholm_horizontalInductionPencil`, `index_horizontalInductionPencil_eq_zero`). \
**Effect:** **stronger** (no divergence hypothesis).

**C5.2. Lemma 5.2.**  (`lem:exact-renormalization`, `eq:scaling`) \
**Paper:** `U_n⁻¹A^{(n)}_{ε,n}U_n = 𝓛_{δ_n} − iτ` as operators with domain `H²`, with
`K_nℓ_n = 1`. \
**Lean:** for an arbitrary scaling record `WholePlaneExactScalingParameters`
(`δ = ε/ℓ²`, `N = 2πKℓ`, `τ = 2πKa`); since `U_n` is two maps (an `L²` isometry and an `H²`
equivalence), the identity is a conjugation of each summand, of the action, of the embedding and
of the pencil (`exactScalingC2_selectedOperator_pencil_conjugated`,
`FastDynamo/Reduction/ExactScalingC2.lean`), not an equality of `DomainOperator`s.  The
eigenpair correspondence `exactScalingC2_eigenpair_iff` is added. \
**Effect:** **different form**, more general (A9), with an extra clause.

#### Arguments

**C5.3. Route of Lemma 5.1.**  (proof of `lem:torus-sector-basic`) \
**Paper:** `z − A` differs from the isomorphism `id − εΔ⊥ : H² → L²` by an `H¹ → L²`-bounded,
hence compact, operator, so index zero; injectivity of `z₀ − A` for real
`z₀ > ‖∇⊥w⊥‖_∞` by a coercivity estimate that uses `div⊥ w⊥ = 0` and real `w₃`;
surjectivity from index zero; bounded inverse theorem; compact embedding. \
**Lean:** a resolvent point from a Neumann series along the real ray around the exact
Fourier-diagonal inverse of the diffusion part (the lower-order terms composed with it decay
like `σ^{−1/2}` and `σ^{−1}`; `FastDynamo/Operator/HorizontalSectorBasic.lean`,
`FastDynamo/Operator/FixedSectorLowerOrderDecay.lean`); index zero at
every `z` from the compact-base-point factorisation `z − A = [1 + (z−z₀)(z₀−A)⁻¹](z₀−A)` on the
ambient `L²` (`FastDynamo/Operator/CompactBaseFredholm.lean`).  Neither coercivity nor
`div⊥ w⊥ = 0` is used. \
**Effect:** **different route**, giving C5.1.

### §6 — The background resolvent

#### Statements

**C6.1. Continuity and holomorphy of the background resolvent.**
(`prop:background-resolvent`) \
**Paper:** `𝒢_τ ⊂ ρ(A^bg_{ε,n})` and the bound `eq:bg-resolvent`; the proposition asserts nothing
about the dependence of the resolvent on `z`. \
**Lean:** two statements.  `BackgroundParameters.exists_hasResolventOn_shiftedRegion`
(`FastDynamo/Global/TorusBackgroundResolvent.lean`) gives `HasResolventOn` (A7): pointwise
two-sided inverses on `𝒢_τ` and continuity on `𝒢_τ`; this is the resolvent used in §7, whose
contour integrals need only continuity.  `BackgroundParameters.exists_isOpen_hasResolventOn_analyticOnNhd`
(`FastDynamo/Global/TorusBackgroundResolventHolomorphic.lean`) gives an open set `U ⊇ 𝒢_τ`, the
resolvent set of `A^bg_{ε,n}`, on which the domain-valued resolvent `L² → H²` is analytic in
operator norm and agrees on `𝒢_τ` with the former; analyticity holds on the whole resolvent set
(`DomainOperator.analyticOnNhd_inverse_pencil`,
`FastDynamo/Operator/ResolventSetHolomorphy.lean`). \
**Effect:** **stronger** (extra clauses: continuity on `𝒢_τ`, and analyticity as a map into
operators `L² → H²` on an open set containing `𝒢_τ`, a separate theorem about a second resolvent
object agreeing with the first on `𝒢_τ`).

**C6.2. Explicit `τ₀`, `K₀`-condition and constants.**  (`prop:background-resolvent`,
`eq:axial-separation-choice`, `eq:background-diffusion-small`, `eq:bg-resolvent`) \
**Paper:** "there exists `τ₀`", "for all sufficiently large `K₀`", constants `C`, `C₀`, `C₁`;
`M = max_{ζ∈𝒢}|Im ζ|`. \
**Lean:** the record `BackgroundParameters` (`FastDynamo/Global/TorusBackgroundParameters.lean`)
requires `τ ≥ backgroundTauThreshold = max(2M²/g_*, 2(C₀+1)/c_q²)` (which gives both halves of
`eq:axial-separation-choice`) and `C₁δ₊ℓ₀ ≤ g_*/4` with `C₁ = backgroundDiffusionConstant = 18
L_ϑ²`, `L_ϑ = axialPlateauLipschitzConstant` a Lipschitz constant of `ϑ`; `C₀` is an explicit
formula (`FastDynamo/Global/TorusBackgroundWeightedEnergy.lean`); the resolvent constant is
`backgroundResolventConstant g = √2/g + 2/√g` at `g = g_*/2`; `M` is any upper bound for `|Im ζ|` on
`𝒢`. \
**Effect:** **choice** (explicit thresholds) and **stronger** (explicit constants).

**C6.3. Corollary 6.2: the gradient bound per coordinate.**  (`cor:scaled-local-resolvents`,
`eq:local-gradient`) \
**Lean:** `sqrt_epsilon_mul_norm_deriv_scaledLocalResolventInv_le`
(`FastDynamo/Global/WholePlaneScaledLocalResolvent.lean`) bounds `√ε‖∂_jR_n(z)f‖` for
`j = 0,1`, which gives the displayed bound with a factor `√2`; the underlying seed bound is
`L² → H²` (C2.8). \
**Effect:** **different form**, equivalent up to the constant.

#### Arguments

**C6.4. The multiplier-gradient defect.**  (proof of `prop:background-resolvent`, estimate of
`I₁` in `eq:background-testing`) \
**Paper:** majorises the defect by `∫|∇⊥β_n||h||∇⊥h|` (pointwise Cauchy–Schwarz in the index
`j`) and absorbs it by Young. \
**Lean:** majorises the exact defect `Σ_j Im⟨(∂_jβ)h, ∂_jh⟩` by `Σ_j ‖(∂_jβ)h‖₂‖∂_jh‖₂`
(Cauchy–Schwarz in `L²`, one `j` at a time; `transverseWeightedGradientDefect`,
`re_inner_weightedTransverseState_neg_laplacian_ge`,
`FastDynamo/Analysis/TransverseWeightedDiffusion.lean`) and absorbs it by the same Young step;
`‖∇β‖²_∞` becomes `TransverseScalarW1Inf.gradSupNormSq β = Σ_j‖∂_jβ‖²_∞`. \
**Effect:** **different route**; the two majorants are incomparable, the resulting bound for
`I₁` has the paper's form.

**C6.5. Bookkeeping of the four-term identity.**  (`eq:background-testing`,
`eq:background-coercivity`) \
**Paper:** `I₁` diffusion, `I₂` zeroth order, `I₃` weighted transport, `I₄` stretching and
local axial multiplier; `eq:background-coercivity` drops `ε(2πK_n)²‖h‖²`. \
**Lean:** splits the pairing into the five terms of `horizontalInductionPencil_apply_eq`
(`FastDynamo/Global/TorusBackgroundWeightedEnergy.lean`); the zeroth-order and local axial terms
are estimated together, with the phase bound `eq:background-phase-positive` merged with the
local axial bound of `eq:background-local-coefficients`; the stretching is bounded with the
factor `2` (`|(1+iβ)h| ≤ 2|h|`); the non-negative term `ε(2πK_n)²‖h‖²` is kept;
`BackgroundCoercivity` asks only `τc_q²/2 ≥ C₀`. \
**Effect:** **different route**, same estimate.

**C6.6. The multiplier `β_n`.**  (`eq:background-multiplier`, `eq:background-multiplier-bounds`) \
**Paper:** `s_n, β_n ∈ W^{1,∞}` and the bounds by the chain rule. \
**Lean:** `β_n + 1 = Σ_m (F(r_mϑ_m) + 1)` as a disjoint-support series summable in `L^∞`, with no
`W^{1,∞}` chain rule; explicitly `F'(s) = (3−s)/(1+s)³`, `|F'| ≤ 3` and an explicit bound for
`√ε‖∇β_n‖` of the form `C√δ₊ d(K₀)` (`FastDynamo/Global/BackgroundMultiplierScalarAlgebra.lean`,
`FastDynamo/Global/TorusBackgroundMultiplier.lean`). \
**Effect:** **different route**.

### §7 — The approximate inverse and the unstable eigenvalue

#### Statements

**C7.1. Proposition 7.1 per cell, with explicit hypotheses.**  (`prop:global-spectral-transfer`,
`eq:scaled-witness-support`) \
**Paper:** `K₀` can be chosen so that for every `0 < ε ≤ ε₀` and every admissible `n`,
`Γ_τ ⊂ ρ(A_{ε,K_n})`, `Q_{ε,n} ≠ 0`, and there is an eigenvalue inside `Γ_τ` with real part at
least `g_*`. \
**Lean:** `exists_growing_horizontalInduction_eigenpair_cell`
(`FastDynamo/Global/TorusGlobalSpectralTransfer.lean`) for one cell given as `SelectedCellData`,
with the two numerical smallness conditions as explicit hypotheses and the support fit in the
non-strict form `L_*ℓ_n ≤ R_n/5`; the hypotheses are discharged at the witnesses in
`FastDynamo/Global/GlobalSpectralTransferConcrete.lean`
(`exists_growing_reducedInduction_eigenpair_matchingCell`) and at every admissible cell in
`FastDynamo/Global/GlobalSpectralTransferAllCells.lean`.  The conclusion is an eigenpair; the
every-cell clause `MainEveryAdmissibleCellClauses` keeps only the eigenvalue with `Re λ ≥ g_*`
(lifted to three components). \
**Effect:** **different form**; the resolvent inclusion and `Q ≠ 0` are separate lemmas (C7.2,
C7.3).

**C7.2. Explicit constants in Lemmas 7.2 and 7.3.**  (`lem:parametrix-error`,
`lem:global-contour-resolvent`, `eq:explicit-error`, `eq:error-small`) \
**Paper:** constants `C`, `C_app`; `0 < η_* < ½` with `(length Γ/2π)C_app η_*/(1−η_*) < ¼`;
"for all sufficiently large `K₀`". \
**Lean:** `parametrixErrorConstant = (2√2C'₁ + 2C'₂)(C_bg + C_loc)` with `C'₁, C'₂` the cut-off
derivative constants (`commutatorErrorConstant`), `C_app = C_bg + C_loc`
(using `‖1−φ_n‖ ≤ 1`; `approximateInverseConstant`); `η_* = errorTarget = min(½, (100(1+K))⁻¹)`,
`K = (1+r_Γ)(1+C_app)` (`mul_errorTarget_div_lt_quarter`,
`FastDynamo/Global/GlobalParameterChoiceConcrete.lean`); `eq:error-small` is imposed on the
explicit majorant `C(√ℓ₀ + ℓ₀) < η_*` (`exists_scale_threshold`,
`FastDynamo/Global/TorusParametrixError.lean`).  The derivative bounds of all three cut-offs are
proved (the paper states them for `ψ_n, χ_n`). \
**Effect:** **choice**/**stronger** (explicit).

**C7.3. Lemma 7.4.**  (`lem:global-riesz-nonzero`, `eq:global-projection-error`) \
**Paper:** states `Q_{ε,n} ≠ 0`; the bound `< ¼` and `Re⟨Qf_n,f_n⟩ > ¼` are in the proof. \
**Lean:** `rieszProjection_ne_zero_cell` and also
`re_inner_rieszProjection_placedWitness_gt_quarter`; the projection error is bounded in operator
norm (`norm_rieszProjection_sub_contourOperator_le_cell`) with the explicit majorant
`cellErrorMajorant` in the role of `η_*` (`FastDynamo/Global/TorusGlobalRieszNonzero.lean`). \
**Effect:** **stronger** (an extra clause).

#### Arguments

**C7.4. The selected summand of `𝓡_app`.**  (`eq:Rapp`, proof of `lem:parametrix-error`) \
**Paper:** extends `φ_nf` by zero, applies the resolvent on `ℝ²` for the selected cell, multiplies
by `ψ_n` and restricts to the torus. \
**Lean:** both summands are instances of one localised-summand algebra
(`FastDynamo/Global/TorusTwoSummandParametrix.lean`) with the partition hypothesis
`χ_n(1−φ_n) + ψ_nφ_n = id`; the selected output is transported as `ψ̃_n·(R_n(z)φ_n·)` with an
auxiliary cut-off `ψ̃_n ≡ 1` on `supp ψ_n` (`FastDynamo/Global/TorusChartC2AuxiliaryCutoff.lean`,
`FastDynamo/Global/TorusSelectedCellChartAgreement.lean`).  The commutator formula is proved with the transport
term `−(u⊥·∇χ)h` and specialised to the paper's case `u⊥·∇χ = 0`
(`FastDynamo/Global/HorizontalCutoffCommutator.lean`). \
**Effect:** **different route**.

### §8 — Recovery of the magnetic field

#### Statements

**C8.1. Lemma 8.1 in sector form.**  (`lem:axial-recovery`) \
**Paper:** concludes on `T³`: `0 ≠ V ∈ H²(T³;ℂ³) ∩ L²_σ`, `L_{ε,u}V = λV`. \
**Lean:** `exists_reducedInductionEigenpair_of_horizontalEigenpair`
(`FastDynamo/Finish/AxialRecovery.lean`) concludes that `b = (h, b₃)` is an eigenvector of
`reducedInductionOperator u ε K` with `fixedSectorDivergence K b = 0` and `productDivergenceFromH2
(axialLiftH2 K b) = 0`; the curl-form identity on the product torus is derived downstream
(`productInductionEigenpair_to_physical`, `FastDynamo/Operator/Compatibility.lean`;
`realStrongModeCertificate_of_reducedEigenpair`, `FastDynamo/Finish/RealSolution.lean`), in `H⁻²`
(A6). \
**Effect:** **different form**.

**C8.2. Corollary 8.3 at the witnesses, with explicit constants.**  (`cor:magnetic-scale`) \
**Paper:** for the eigenmode `V^ε` of Theorem 1.2 there are `c, C > 0` independent of `ε`
with `cε^{−1/2} ≤ |K_ε| ≤ Cε^{−1/2}` and `c√ε ≤ L_B^ε ≤ C√ε` for `0 < ε ≤ ε₀`, and `B_in^ε`
has the same magnetic length; the proof uses `L_B ≤ 1/(2π|K|)` and `√(ε/M_u) ≤ L_B` with
`M_u = ess sup ‖∇u‖_op`. \
**Lean:** `main_theorem_magnetic_scale` (`FastDynamo/Finish/MagneticScaleMain.lean`): there are
`c, C > 0` such that for every `0 < ε ≤ mainEps0` some triple `(K, λ, b)` satisfies the spectral
clauses of Theorem 1.2 (`MainPhysicalClausesAt`, the body of `MainPhysicalClauses`, at
`mainVelocity` and `mainGrowthFloor`) together with `cε^{−1/2} ≤ |K| ≤ Cε^{−1/2}`,
`c√ε ≤ L_B ≤ C√ε`, and equality of the magnetic length of the real part of `V = e^{2πiKx₃}b` at
every phase — in particular of `B_in = Re V` — with `L_B`.  The constants are explicit,
`c = min(√δ₋, M^{−1/2})` and `C = max(√δ₊, 1/(2π√δ₋))`.  The triple is the eigenpair at the matching
cell of the parameter chain, `K = K_n` with `k_* = 1` (A9).  The proof instantiates the general
bounds of `FastDynamo/Finish/MagneticScale.lean`: `k_*√(δ₋/ε) ≤ K_n ≤ k_*√(δ₊/ε)` at every matching
cell (`ScaleFamily.matching_fourierIndex_lower`, `ScaleFamily.matching_fourierIndex_upper`);
`L_B ≤ 1/(2π|K|)` for every axial mode (`complexAxialMagneticLength_le`); `√(ε/M) ≤ L_B` for every
reduced eigenpair with `Re λ ≥ 0` at a divergence-free velocity and `ε > 0`
(`complexAxialMagneticLength_lower`, `complexAxialMagneticLength_lower_of_energy`); and the equality
for the real part (`realPhaseAxialMagneticLength_eq_complex`).  Differences: `L_B = ‖V‖₂/‖∇V‖₂` is
`complexAxialMagneticLength K b`, with `‖∇V‖₂` the `L²` norm of the three weak derivatives of the
product-torus field (`productGradientFromH2`); the magnetic length of the real field at a phase
(`realPhaseAxialMagneticLength`) takes as its gradient the real parts, at that phase, of the
derivative amplitudes of the complex mode (`phaseAxialGradientL2`), which is the weak gradient of
the real `H²` field: complexified, its components are those of
`productGradientFromH2 (productRealPartH2 (e^{iθ} • axialLiftH2 K b))`
(`complexifyProductR3L2_phaseAxialGradientL2`).
`M = ‖transverseStretchingCoefficient mainVelocity‖` is the `L^∞` norm of the matrix field
`b ↦ (b·∇⊥)u`, i.e. the essential supremum of `‖Du(x)‖_op`, the paper's `M_u` (an unfolding of the
definitions, not a Lean lemma).  The triple is existentially quantified in this statement as in
`MainPhysicalClauses`; that it is the triple of `MainSemigroupOrbitClauses` is not stated (B2), and
the clause "its solution" of B6(c) is not part of it. \
**Effect:** **different form**, **stronger** (explicit constants).

#### Arguments

**C8.3. Route of Lemma 8.1: the scalar equation for `b₃`.**  (proof of `lem:axial-recovery`) \
**Paper:** `V ∈ H¹` is divergence-free by construction; `F = λV − εΔV − curl(u×V) ∈ H⁻¹`;
`curl(u×V) = (V·∇)u − (u·∇)V`, `F⊥ = 0`, `Div F = 0 = ∂_{x₃}F₃ = 2πiKF₃` in distributions,
so `F = 0`; elliptic regularity gives `V ∈ H²`. \
**Lean:** takes the sector divergence of `A_{ε,K}h = λh` through the transport–stretching
divergence identity `Div[−(w·∇)F + (F·∇)w] = −w·∇ Div F`, obtaining the scalar equation
`(λ − S)b₃ = (h·∇⊥)u₃` with right-hand side in `L²`; `b₃ ∈ H²` follows from the Fourier multiplier
bound `ε(1+4π²|n|²) ≤ ε(4π²|n|² + (2πK)²)` for `K ≠ 0`
(`FastDynamo/Finish/AxialRecoveryDivergence.lean`, `FastDynamo/Finish/AxialRecoveryRegularity.lean`).  No `H⁻¹`
object and no elliptic-regularity theorem is used; the curl form of A6 lives in `H⁻²` against
`H²`, one derivative below the paper's `H⁻¹`–`H¹` pairing. \
**Effect:** **different route**.

**C8.4. The real solution and its identification.**  (proof of `thm:main`) \
**Paper:** writes `B^ε(t) = e^{α_εt}Re(e^{iω_εt}V^ε)` as "its solution", since the coefficients
are real. \
**Lean:** the complex solution `e^{tλ}V` is produced by scalar exponentiation and its real part
is shown to be a strong solution of the auxiliary and of the curl-form operator
(`realifiedEigenTrajectoryH2_isStrongSolution`, `FastDynamo/Finish/RealSolution.lean`); it is
identified with the semigroup orbit through uniqueness of forward strong solutions of the
auxiliary operator (`productInductionSemigroup_realifiedEigenTrajectoryH2`, E3). \
**Effect:** **different route** (an identification the paper makes without a uniqueness theorem).

### Appendix A — The semigroup

#### Statements

**CA.1. Lemma A.1.**  (`lem:semigroup-spectral-growth`; the facts on `γ` stated in §1.1) \
**Paper:** for every divergence-free `u ∈ W^{1,∞}(T³;ℝ³)` and `ε > 0`, `L_{ε,u}` with domain
`H² ∩ L²_σ` generates an analytic `C₀`-semigroup on `L²_σ`; its resolvent is compact, `e^{tL}` is
compact for `t > 0`, `eq:compact-semigroup-spectral-mapping` holds for `t > 0`,
`γ(u,ε) = max{Re λ : λ ∈ σ(L_{ε,u})}` (`eq:growth-rate-spectral-bound`; §1.1: the supremum is
attained at an eigenvalue). \
**Lean:** `SemigroupSpectralGrowth u hu hε`, proved for every divergence-free
`u : TransverseRealW1Inf` and every `ε > 0` by `semigroupSpectralGrowth_holds`
(`FastDynamo/Dynamics/Assembly/SemigroupSpectralGrowth.lean`), about
`solenoidalInductionSemigroup u hu hε` (`FastDynamo/Dynamics/Assembly/ProductSemigroup.lean`) on
`productSolenoidalSubspace`.  Its fields: `generator_eq` (the generator is
`solenoidalInductionOperator u hu ε`, A6); `generator_curlForm` (embedded in the Fourier model of
`H⁻²`, the generator's value at `B` is the curl form `productPhysicalInductionAction u ε B`);
`generator_unique` (every `C₀`-semigroup on `L²_σ` with that generator is this one); `analytic`
(`IsAnalyticSemigroup … (π/4)`); `resolventSet_nonempty` and `isCompactOperator_resolvent` (every
resolvent is compact); `isCompactOperator_semigroup`; `spectralMapping`; `gamma_tendsto` (`γ` is a
real number and the limit `eq:semigroup-growth-rate`, B4); `gamma_eq_iSup`; `zero_mem_spectrum`;
`exists_eigenvalue_re_eq_gamma` (some `λ ∈ σ(L)` with `Re λ = γ` has a non-zero eigenvector).
Differences:
* *Model and velocities.*  Product torus and Fourier-defined `L²_σ` (A2, A5); axially independent
  velocities only (A1).  `γ` is the growth bound of the isometric transport
  `literalInductionSemigroup` (B3); the other clauses are stated for the product semigroup and
  not restated for the transport.
* *The operator.*  The generator takes values in the auxiliary action
  `productInductionAction u ε`, which on divergence-free `H²` fields is the curl form read in
  `H⁻²` (`productInductionAction_toHMinus2_eq_physical`); `generator_curlForm` records this, and
  the embedding `L² → H⁻²` is injective.  An equivalent formulation.
* *Analyticity.*  `IsAnalyticSemigroup S δ` (`FastDynamo/Dynamics/AnalyticSemigroup.lean`):
  `0 < δ ≤ π/2` and an operator family `z ↦ T(z)` (`AnalyticExtension`) that agrees with `S` on
  `[0, ∞)`, satisfies `T(z + w) = T(z)T(w)` on the open sector `|arg z| < δ`, is holomorphic
  there in the operator norm, and converges strongly to the identity as `z → 0` within every
  smaller sector — Engel–Nagel, Definition II.4.5; the angle `π/4` is exhibited, where the
  paper names none.
* *Spectrum.*  `LinearPMap.spectrum` (A7) of the generator as a partially defined map; the
  spectrum of `e^{tL}` is Mathlib's `spectrum`.
* *Extra clauses.*  `generator_curlForm`, `generator_unique`, `resolventSet_nonempty` (so that
  compactness of the resolvent is not vacuous), `gamma_tendsto` (stated in §1.1, not in the lemma),
  `zero_mem_spectrum` (a step of the paper's proof; it makes the supremum one over a non-empty
  set), and the eigenvector in the attainment clause (§1.1 says "at an eigenvalue"). \
**Effect:** **different form**, **narrower** in the velocities (A1), **stronger** in the extra
clauses.

#### Arguments

**CA.2. Generation.**  (proof of `lem:semigroup-spectral-growth`, first paragraph) \
**Paper:** `εΔ` with domain `H² ∩ L²_σ` generates an analytic semigroup on `L²_σ`, `curl(u × ·)`
is infinitesimally `εΔ`-bounded, and Engel–Nagel III.2.10 gives generation of an analytic
semigroup by `L_{ε,u}`. \
**Lean:** the auxiliary operator generates a `C₀`-semigroup on all of `L²(T² × T;ℂ³)` by the
Hille–Yosida theorem in quasi-contractive form, from a real-ray resolvent bound
`‖R(r)‖ ≤ (r − M)⁻¹` proved sector by sector and assembled over all axial frequencies as a
Hilbert sum (`HilleYosidaRay.semigroup`, `FastDynamo/Dynamics/HilleYosida/Semigroup.lean`;
`FastDynamo/Dynamics/Assembly/`); its generator is identified with the operator
(`HilleYosidaRay.generator_semigroup`, `FastDynamo/Dynamics/HilleYosida/GeneratorIdentification.lean`);
`L²_σ` is invariant, and the generator of the restricted semigroup is the part of the generator
in `L²_σ` (`StronglyContinuousSemigroup.generator_restrict_apply`,
`FastDynamo/Dynamics/SemigroupGenerator.lean`), which is `solenoidalInductionOperator`
(`generator_solenoidalInductionSemigroup`, `FastDynamo/Dynamics/Assembly/SolenoidalGenerator.lean`).
Uniqueness of the semigroup with a given generator is the Engel–Nagel II.1.4 argument
(`StronglyContinuousSemigroup.ext_of_generator_eq`). \
**Effect:** **different route**: Hille–Yosida, generator identification and restriction
(Engel–Nagel II.2.3) instead of perturbation of `εΔ` (Engel–Nagel III.2.10).

**CA.3. Analyticity, compactness, spectral mapping, growth bound, attainment.**  (proof of
`lem:semigroup-spectral-growth`, second paragraph; the sentence after `eq:semigroup-growth-rate`) \
**Paper:** analyticity from Engel–Nagel III.2.10; compact resolvent from the equivalence of the
graph norm with the `H²` norm and the compact embedding `H² ↪ L²`; immediate compactness from
analyticity and Engel–Nagel II.4.29; spectral mapping and growth bound = spectral bound from
Engel–Nagel IV.3.11 and IV.3.12; `0 ∈ σ(L)` because `∫ L B = 0` and `L²_σ` contains non-zero
constants; attainment from Engel–Nagel V.3.2 (finitely many spectral points in `{Re z ≥ 0}`); the
limit `eq:semigroup-growth-rate` from Engel–Nagel IV.2.2. \
**Lean:**
* *Analyticity.*  A sector condition on the numerical range,
  `|Im⟨B, AB⟩| ≤ ω‖B‖² − Re⟨B, AB⟩` (`exists_productInduction_sectorial`,
  `FastDynamo/Dynamics/Assembly/ProductInductionEnergy.lean`), passes to the Yosida approximants of
  the Hille–Yosida construction; their exponentials, in complex time, converge on the closed
  sector `|Im z| ≤ Re z` (`HilleYosidaRay.isAnalyticSemigroup_of_sectorial`,
  `FastDynamo/Dynamics/HilleYosida/AnalyticGeneration.lean`); strong holomorphy and local
  boundedness give holomorphy in operator norm (`differentiableOn_of_forall_apply`,
  `FastDynamo/Operator/StrongHolomorphy.lean`); analyticity passes to the restriction to `L²_σ`
  (`IsAnalyticSemigroup.restrict`).
* *Compact resolvent.*  The resolvent factors through the compact embedding
  `H²(T² × T) → L²` (`isCompactOperator_productH2Embedding`,
  `FastDynamo/Operator/ProductH2Compact.lean`), as in the paper; compactness at one point gives it
  at every point by the resolvent identity.
* *Immediate compactness.*  Proved from analyticity directly: `S(t)` maps into the domain of the
  generator with `L S(t)` bounded (`IsAnalyticSemigroup.exists_generator_comp`), so
  `S(t) = R(r)(r − L)S(t)` is compact (`IsAnalyticSemigroup.isCompactOperator`,
  `FastDynamo/Dynamics/AnalyticSemigroupGenerator.lean`); Engel–Nagel II.4.29 is not used.
* *Spectral mapping and the spectral bound.*  A point-spectrum argument
  (`IsAnalyticSemigroup.spectrum_diff_zero`, `IsAnalyticSemigroup.growthBound_eq_iSup`,
  `FastDynamo/Dynamics/SemigroupSpectralMapping.lean`) instead of Engel–Nagel IV.3.11, IV.3.12 and
  V.3.2: the non-zero spectrum of the compact operator `S(t)` consists of eigenvalues (Fredholm
  alternative); each eigenspace is finite-dimensional and invariant under the bounded operator
  `L S(t)`, which therefore has an eigenvector there, an eigenvector of `L`; with a compact
  resolvent every point of `σ(L)` is an eigenvalue; an eigenvector gives
  `‖S(t)‖ ≥ e^{t Re λ}`, so the growth bound `ω₀` is finite, and Gelfand's formula for `S(1)`
  identifies `e^{ω₀}` with its spectral radius, attained at some `e^{λ}`, `λ ∈ σ(L)`; this gives
  `γ = sup Re σ(L)` and its attainment at an eigenvalue at once.
* *`0 ∈ σ(L)`.*  Conservation of the mean, as in the paper: the mean of the auxiliary action
  vanishes on divergence-free `H²` fields (`hasZeroMean_productInductionAction`,
  `FastDynamo/Dynamics/Assembly/InductionMeanConservation.lean`) and `L²_σ` contains a unit field of
  mean one (`exists_productSolenoidal_mean_eq_one`); the same conservation gives
  `‖e^{tL}‖ ≥ 1` (`one_le_norm_solenoidalInductionSemigroup`), hence `γ ≥ 0` and `γ ≠ −∞`.
* *The limit.*  For every `C₀`-semigroup on a Banach space, `t⁻¹ log ‖S(t)‖` converges to the
  growth bound, which is its infimum over `t > 0` (`StronglyContinuousSemigroup.tendsto_growthExponent`,
  `growthBound_eq_iInf`, `FastDynamo/Dynamics/GrowthBoundLimit.lean`), local boundedness coming
  from the Banach–Steinhaus theorem: the argument of Engel–Nagel IV.2.2, with the value `−∞`
  allowed.  For `γ` the limit is real because `‖e^{tL}‖ ≥ 1` (`gamma_eq_lim`). \
**Effect:** **different route** (analyticity, immediate compactness, spectral mapping, spectral
bound and attainment); the paper's route for the compact resolvent, `0 ∈ σ(L)` and the limit.

---

## Part D — Not formalised

For each item: whether the proof of Theorem 1.2 depends on it, in the paper and in Lean.  These
are the only statements of the paper with no Lean counterpart.

**D1. Conjecture 1.1** (`conj:smooth-fast-dynamo`).  A conjecture about smooth velocities.
Paper: no.  Lean: no.

**D2. Remark 1.3** (`rem:subsequent-resolution`).  Literature and a question.
Paper: no.  Lean: no.

**D3. Remark 7.5** (`rem:flexible-buffer-scales`).  Lean fixes `R_n = √ℓ_n`
(`ScaleFamily.bufferRadius`), the paper's own choice.  Paper: no.  Lean: no.

**D4. Remark 8.4** (comparison with the resistive scale `√ε`).  Paper: no.  Lean: no.

---

## Part E — Material of the formalisation that is not in the paper

**E1. `C₀`-semigroup theory.**  Mathlib has no `C₀`-semigroup theory; the formalisation
proves the parts the paper quotes from Engel–Nagel.  Strongly continuous semigroups, restriction
to invariant subspaces and transport along isometries (`FastDynamo/Dynamics/StronglyContinuousSemigroup.lean`,
`FastDynamo/Dynamics/SemigroupRestriction.lean`); growth bounds (`FastDynamo/Dynamics/GrowthBound.lean`) and the limit
`t⁻¹ log ‖S(t)‖ → ω₀` for every `C₀`-semigroup on a Banach space, with local boundedness from
Banach–Steinhaus (`StronglyContinuousSemigroup.tendsto_growthExponent`, `growthBound_eq_iInf`,
`FastDynamo/Dynamics/GrowthBoundLimit.lean`; B4); generators, their domains, derivatives of orbits,
uniqueness of the semigroup with a given generator and the generator of a restriction
(`FastDynamo/Dynamics/SemigroupGenerator.lean`); Hille–Yosida generation through Yosida approximants
(`HilleYosidaRay.semigroup`, `FastDynamo/Dynamics/HilleYosida/Semigroup.lean`; the existence and uniqueness
theorems `exists_stronglyContinuousSemigroup_of_hilleYosidaRay`, `HilleYosidaRay.semigroup_unique`,
`FastDynamo/Dynamics/HilleYosida/Generation.lean`) and the identification of the generator
(`FastDynamo/Dynamics/HilleYosida/GeneratorIdentification.lean`); analytic semigroups, their generation from
a sector condition and their restriction (`FastDynamo/Dynamics/AnalyticSemigroup.lean`,
`FastDynamo/Dynamics/HilleYosida/AnalyticGeneration.lean`), the regularising effect `S(t)X ⊆ D(G)` and
immediate compactness (`FastDynamo/Dynamics/AnalyticSemigroupGenerator.lean`); the spectral mapping theorem
and growth bound = spectral bound for analytic semigroups with compact resolvent
(`FastDynamo/Dynamics/SemigroupSpectralMapping.lean`); time rescaling (`FastDynamo/Dynamics/SemigroupTimeRescaling.lean`,
B10); the resolvent set and spectrum of a partially defined operator
(`FastDynamo/Operator/UnboundedResolvent.lean`, A7).  The routes are those of CA.2 and CA.3.

**E2. The auxiliary operator and the auxiliary solenoidality theorem.**  The operators of A6
not in the paper; eigenfunctions of the auxiliary operator with `Re λ > 0` and `ε ≥ 0` are
divergence-free (`productInductionEigenpair_solenoidal`, `FastDynamo/Finish/RealSolution.lean`;
`productH2Embedding_mem_productSolenoidalSubspace_of_isEigenpair`; used in B12), and the
hypothesis `ε ≥ 0` is sharp (`exists_positive_nonsolenoidal_eigenpair_of_negative_diffusivity`,
`FastDynamo/Finish/NegativeDiffusivity.lean`).

**E3. Uniqueness of forward strong solutions.**  For the reduced and the auxiliary operator
(`reducedInductionOperator_forwardStrongSolutionsUnique`,
`productInductionOperator_forwardStrongSolutionsUnique`; used in B13 and C8.4), with the energy
inequality `re_inner_reducedInductionAction_le` (`Re⟨B, AB⟩ ≤ ‖∇⊥u‖_∞‖B‖²`,
`FastDynamo/Dynamics/StrongSolutionUniqueness.lean`) and a strong-solution growth floor `strongSolutionGrowthFloor`
(`FastDynamo/Dynamics/GrowthBound.lean`), which is not the paper's `γ`; `FastDynamo/Dynamics/MainGrowthFloor.lean`
evaluates it at the witnesses.

**E4. The entropy criterion** (`coverEntropy_eq_zero_of_lipschitz_iterate`; C4.7).

**E5. Uniqueness of the particle flow** (`IsParticleFlow.unique`,
`existsUnique_isParticleFlow_mainLiteralVelocity`, `FastDynamo/Dynamics/Flow/ParticleFlowUniqueness.lean`;
C4.5).  The main theorem does not use it: the inverse law is a clause of
`MainLagrangianClauses`.  Remark 1.6 uses it for the flow of the normalised velocity (B10).

**E6. Explicit numerals and constants.**  `ϱ = 32`, `Re λ_* ≥ 448 − 4π²`, the factor `¾`,
`γ₀ ≥ (3/4)(448 − 4π²) ≥ 288`, `C_L`, `τ₀`, `C₁`, `η_*`, … (C2.3, C2.6, C3.4, C6.2, C7.2).
They are the witnesses of the main theorem.

**E7. Non-vacuity and finiteness statements.**  `exists_ne_zero_literalSolenoidalSubspace`,
`exists_ne_zero_mainIdealGroup_rate`, `gamma_ne_top`, `gamma_ne_bot`, the ceiling
`gamma_le_stretching`.  The ceiling is a field of `MainTheoremStrengthened`; none of these enters
the proof of a clause of Theorem 1.2.

**E8. Packagings.**  The every-admissible-cell clauses (`MainEveryAdmissibleCellClauses`,
`exists_growing_eigenpair_of_admissible_index`), the ideal–resistive gap
(`ideal_resistive_gap_holds`, `ideal_resistive_gap_at_diffusivity_holds`), and the qualitative
regularity of the velocity collected in `MainTheoremStrengthened` (B11).

**E9. Proofs of quoted standard results.**  Local Rellich compactness
(`FastDynamo/Analysis/WholePlaneBandLimited*.lean`, `FastDynamo/Analysis/WholePlaneLocalCompactness*.lean`), Schauder's
theorem (`FastDynamo/Operator/CompactAdjoint.lean`), the analytic Fredholm theorem (C2.12;
`FastDynamo/Operator/AnalyticFredholm.lean`, `FastDynamo/Operator/AnalyticFredholmContinuation.lean`,
`FastDynamo/Operator/FiniteDimensionalDeterminant.lean`), Atkinson theory (`FastDynamo/Operator/CompactAtkinson*.lean`,
`FastDynamo/Operator/CompactBaseFredholm.lean`), the modified Bessel functions with their Gaussian
representations, recurrences and Wronskian (`FastDynamo/Local/ModifiedBessel*.lean`), periodic and
whole-plane Sobolev and Fourier towers (`FastDynamo/Fourier/`, `FastDynamo/Analysis/`), the identification of
`T² × T` with `Torus 3` (`FastDynamo/Analysis/LiteralThreeTorus*.lean`), Rellich's theorem on the product
torus (`isCompactOperator_productH2Embedding`, `FastDynamo/Operator/ProductH2Compact.lean`), holomorphy in
operator norm from strong holomorphy and local boundedness (`FastDynamo/Operator/StrongHolomorphy.lean`),
holomorphy of the resolvent on the resolvent set (`FastDynamo/Operator/ResolventSetHolomorphy.lean`; C6.1),
and a Friedrichs commutator lemma on `Torus 3` (`FastDynamo/Analysis/LiteralFriedrichsCommutator.lean`;
C1.6, E10).

**E10. Mollification on the literal three-torus.**  Translations of `L²(Torus 3;ℂ³)`, the
mollifier `J_δ = literalMollify δ` with its Fourier symbol, `‖J_δ‖ ≤ 1` and `J_δ → id` strongly
and uniformly on compact sets, and the convolutions with the derivatives of the kernel
(`literalTranslate`, `mollifierKernel`, `literalMollifyDeriv`, `norm_literalMollify_le`,
`tendsto_literalMollify`, `FastDynamo/Analysis/LiteralTorusMollifier.lean`;
`tendstoUniformlyOn_literalMollify`, `FastDynamo/Dynamics/VanishingDiffusivity/Limit.lean`); the mollifier as a map
`L² → H²` of the product model (`productMollifyH2`,
`FastDynamo/Dynamics/VanishingDiffusivity/ProductBridge.lean`).  They serve the proof of Remark 1.7 (C1.6),
which the paper argues without a mollifier.
