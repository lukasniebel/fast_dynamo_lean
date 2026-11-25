# FastDynamo

A machine-checked **Lean 4** formalisation of the paper

> Lukas Niebel,
> [*A fast dynamo with zero topological entropy*](https://arxiv.org/abs/2608.02586v3),
> arXiv:2608.02586v3.

The main theorem of the paper, Theorem 1.2, is proved in full, up to the
[deviations recorded below](#deviations-from-the-paper): its growth-rate clause, its
spectral clauses, the norm law for the solution with the real datum, and its two dynamical
clauses. So are the other statements of the paper: Lemma A.1 on the induction semigroup; in §1
the energy identity, the notions of dynamo and fast dynamo, and Remarks 1.4–1.7 (among them
Theorem 1.2 for the normalised velocity and the vanishing-diffusivity limit); and every
proposition, lemma and corollary of §§2–8, Corollary 8.3 on the magnetic length scale at the
eigenmodes of Theorem 1.2 included. The development is built on
[mathlib](https://github.com/leanprover-community/mathlib4) alone. Where the formal statements or
the formal arguments are not literally those of the paper, the difference is recorded: in summary
[below](#deviations-from-the-paper), and completely in [`DEVIATIONS.md`](DEVIATIONS.md).

- **About 129,000 lines of Lean** in 411 modules.
- **No `sorry`** and no `admit` anywhere in the library.
- **No custom axiom.** Every audited declaration depends only on `propext`, `Classical.choice`
  and `Quot.sound`; this is checked for 1114 declarations by
  [`FastDynamo/AxiomAudit.lean`](FastDynamo/AxiomAudit.lean) and the release gate.
- **The Challenge statement.** [`Challenge.lean`](Challenge.lean) states Theorem 1.2 with
  mathlib notions and fourteen short definitions, and [`Solution.lean`](Solution.lean) proves it
  from the library; see [The Challenge statement](#the-challenge-statement).
- Pinned to Lean `v4.35.0` and mathlib `v4.35.0`.

## What is proved

The paper constructs an autonomous, divergence-free Lipschitz velocity field `u` on the flat
three-torus which is a *fast dynamo*: the kinematic induction equation
`∂ₜB = curl(u × B) + εΔB` has solutions growing at an exponential rate bounded below uniformly as
the magnetic diffusivity `ε` tends to zero. At the same time the particle flow of `u` has zero
topological entropy, and the ideal (`ε = 0`) induction equation has no exponential growth. The
construction is multiscale: a Ponomarenko-type helical flow with an unstable eigenvalue is placed,
rescaled, in disjoint cells accumulating at one circle, so that for every small `ε` one cell is at
the resistive scale `√ε`.

The question whether the growth rate survives the limit `ε ↓ 0` goes back to Vainshtein and
Zel'dovich; for autonomous velocities on the flat three-torus it is the conjecture recorded as
Problem 1994-28 in *Arnold's Problems* (Conjecture 1.1 of the paper), which asks for a smooth
velocity. For sufficiently smooth velocities the absence of exponential particle stretching
excludes fast dynamo action (Vishik; Friedlander and Vishik), and the entropy bound of Klapper and
Young excludes a `C^∞` fast dynamo with zero topological entropy. The theorem shows that at
Lipschitz regularity fast dynamo action is compatible with zero topological entropy and zero
ideal exponential growth. It concerns Lipschitz velocities and does not address the smooth
conjecture, which, as Remark 1.3 of the paper records, has been resolved by Coti Zelati, Sorella
and Villringer (arXiv:2609.04153).

**Theorem 1.2** (`thm:main`), as formalised. There are a real, autonomous, divergence-free
velocity `u ∈ W^{1,∞}(T³;ℝ³)`, independent of `x₃` and non-zero, and constants `ε₀, γ₀ > 0` such that:

- *The growth rate.* `γ(u, ε) ≥ γ₀` for every `0 < ε ≤ ε₀`, hence
  `liminf_{ε↓0} γ(u, ε) ≥ γ₀`: `u` is a fast dynamo. Here
  `γ(u, ε) = lim_{t→∞} t⁻¹ log ‖e^{tL_{ε,u}}‖_{L²_σ→L²_σ}` is the growth bound of the
  `C₀`-semigroup that `L_{ε,u} = curl(u × ·) + εΔ` with domain `H² ∩ L²_σ` generates on `L²_σ`;
  the limit exists, and it is the spectral bound `sup Re σ(L_{ε,u})` (Lemma A.1, below).
- *The eigenmode.* For every `0 < ε ≤ ε₀` there are an axial index `K_ε ≠ 0`, an eigenvalue `λ_ε`
  with `Re λ_ε ≥ γ₀`, and a non-zero `b^ε ∈ H²(T²;ℂ³)` whose lift `V^ε = e^{2πiK_ε x₃} b^ε` lies in
  `H²(T³;ℂ³) ∩ L²_σ` and satisfies `L_{ε,u} V^ε = λ_ε V^ε`.
- *The growing real solution.* The real datum `B_in^ε = Re V^ε ∈ H²(T³;ℝ³) ∩ L²_σ` is non-zero, and
  its solution obeys `‖B^ε(t)‖₂ = e^{t Re λ_ε} ‖B_in^ε‖₂` for `t ≥ 0`. The orbit
  `e^{tL_{ε,u}} B_in^ε` is the explicit real curve `Re(e^{tλ_ε} V^ε)`, and every solution of the
  induction equation with datum `B_in^ε` in the class of forward strong solutions — `H²`-valued
  curves solving the curl-form equation in `H⁻²` for `t ≥ 0` (DEVIATIONS.md, B6) — is that orbit.
- *Zero entropy.* The particle flow `Φ_t` of `u` satisfies `h_top(Φ_t) = 0` for every `t ∈ ℝ`.
- *No ideal growth.* The solution group `𝒯₀` of the ideal induction equation on `L²_σ` — the
  unique group of operators on `L²_σ` whose orbits are weak solutions — satisfies
  `lim_{t→∞} t⁻¹ log ‖𝒯₀(t)‖_{L²_σ→L²_σ} = 0`.

The velocity, `ε₀` and `γ₀` are explicit closed terms, and `γ₀ ≥ 288`.

**Further results of the paper**, as formalised:

- *Lemma A.1* (`lem:semigroup-spectral-growth`). For every divergence-free `u ∈ W^{1,∞}`
  independent of `x₃` and every `ε > 0`, `L_{ε,u}` with domain `H² ∩ L²_σ` generates an analytic
  `C₀`-semigroup on `L²_σ`, the only one with this generator; its resolvent is compact,
  `e^{tL_{ε,u}}` is compact for `t > 0`, `σ(e^{tL_{ε,u}}) \ {0} = e^{tσ(L_{ε,u})}`, and
  `γ(u, ε)` is a real limit, equal to `sup Re σ(L_{ε,u})`, which is attained at an eigenvalue.
- *Remark 1.6* (normalisation). With `M = max{1, ‖u‖_{W^{1,∞}}}` and `ũ = u/M`:
  `L_{ε,ũ} = M⁻¹ L_{Mε,u}`, `γ(ũ, ε) = M⁻¹ γ(u, Mε)`, the particle flow and the ideal group of `ũ`
  are those of `u` at time `t/M`, and every clause of Theorem 1.2 holds for `ũ` with `ε₀/M` and
  `γ₀/M`; in particular `‖ũ‖_{W^{1,∞}} ≤ 1`.
- *Remark 1.7* (vanishing diffusivity). For every `B_in ∈ L²_σ` and every `T > 0`,
  `e^{tL_{ε,u}} B_in → 𝒯₀(t) B_in` in `L²` as `ε ↓ 0`, uniformly for `t ∈ [0, T]`.
- *Corollary 8.3* (magnetic scale). There are `c, C > 0` such that for every `0 < ε ≤ ε₀` the
  eigenmode of Theorem 1.2 can be taken with `c ε^{−1/2} ≤ |K_ε| ≤ C ε^{−1/2}` and
  `c √ε ≤ L_B^ε ≤ C √ε`, where `L_B^ε = ‖V^ε‖₂/‖∇V^ε‖₂`; the real datum has the same magnetic
  length.
- *§1.1 and the other remarks of §1.* The energy identity `eq:energy-competition`; the
  definitions of dynamo, fast dynamo and slow dynamo, with `u` a dynamo at every
  `0 < ε ≤ ε₀`; Remark 1.4 (the real part of an eigenmode with non-real eigenvalue is not an
  eigenmode) and Remark 1.5 (zero spatial mean, the regularity of `u`).
- *§§2–8.* Every proposition, lemma and corollary, among them the identification of the spectrum
  of the local operator with its eigenvalues (§2.3), and in the proof of Corollary 4.2 the
  variational equation of the flow, the weak form of the ideal induction equation and the
  uniqueness of its weak solutions.

## Main results

The statement layer is in [`FastDynamo/Main.lean`](FastDynamo/Main.lean),
[`FastDynamo/MainTheorem.lean`](FastDynamo/MainTheorem.lean),
[`FastDynamo/MainTheoremStrengthened.lean`](FastDynamo/MainTheoremStrengthened.lean) and
[`FastDynamo/MainTheoremNormalized.lean`](FastDynamo/MainTheoremNormalized.lean); the
paper-to-Lean map is [`CORRESPONDENCE.md`](CORRESPONDENCE.md). All names below are in the
namespace `FastDynamo`.

* **`mainTheoremComplete_holds : MainTheoremComplete`** — Theorem 1.2 in full (up to the
  [deviations](#deviations-from-the-paper)), at the explicit
  witnesses `mainVelocity`, `mainEps0`, `mainGrowthFloor`: the conjunction of the strengthened
  statement and the dynamical clauses.
* **`mainPhysicalConclusion_holds`** (alias `main_theorem_spectral`) — the spectral half in
  existential form: the velocity, the constants, and for every `0 < ε ≤ ε₀` the eigenmode and the
  real solution with its exact norm law.
* **`main_theorem_strengthened : MainTheoremStrengthened`** — the same with closed terms, together
  with the growth-rate clause and the semigroup orbit:
  `ε₀ = δ₊/K₀²` (`mainEps0_eq`), `γ₀ = g_*`, the minimum of `Re ζ` over the disc bounded by the
  isolating circle of the local model (`mainGrowthFloor_eq`), with `γ₀ ≥ (3/4)(448 − 4π²) ≥ 288`
  (`mainGrowthFloor_ge_three_quarters`, `mainGrowthFloor_ge_numeric`); the eigenvalue in *every*
  admissible cell; the regularity of the velocity (Lipschitz, differentiable everywhere, smooth
  away from the accumulation circle, not `C¹`); the spectral clauses for the normalised velocity;
  and the magnetic clauses on the literal three-torus `Torus 3`: the norm law of the transported
  real curve, which is the orbit of the transported real datum under the semigroup on
  `L²_σ(Torus 3)`.
* **`gamma_ge_gamma0`**, **`mainGrowthFloor_le_liminf_gammaOf`**,
  **`mainGrowthFloor_le_gamma_le_stretching`** — the growth-rate clause, its `liminf` form, and the
  two-sided bound `γ₀ ≤ γ(u, ε) ≤ ‖∇⊥u‖_∞`; **`isFastDynamo_mainVelocity`** — the same in the
  terminology of §1.1: the velocity is a fast dynamo (`IsFastDynamo`).
* **`semigroupSpectralGrowth_holds : SemigroupSpectralGrowth u hu hε`** — Lemma A.1, for every
  divergence-free `u : TransverseRealW1Inf` and every `ε > 0`, about the semigroup
  `solenoidalInductionSemigroup` on `L²_σ`: its generator is `L_{ε,u}` with domain `H² ∩ L²_σ`
  and determines it, it is analytic of angle `π/4`, resolvent and semigroup are compact, the
  spectral mapping theorem, `γ` as a limit and as the spectral bound, attained at an eigenvalue.
* **`mainSemigroupOrbitClauses_holds`** — `B_in^ε ∈ L²_σ`, its orbit under the induction
  semigroup is the explicit curve `B^ε(t)` with the norm law for `t ≥ 0`, and every forward strong
  solution of the curl-form equation with datum `B_in^ε` is that orbit (from
  `productPhysicalInductionOperator_forwardStrongSolutionsUnique`): "*its* solution"; the
  spectral clauses hold at the same `(K_ε, λ_ε, b^ε)`.
* **`mainTheoremDynamical_holds`**, **`mainTheoremLagrangian_holds`** — the two dynamical clauses,
  and with them the content of `prop:particle-flow` and `cor:ideal-growth` at the velocity: the
  particle flow exists, `Lip(Φ_t) + Lip(Φ_t⁻¹) ≤ C_L(1 + |t|)`, and
  `‖B‖/(C_L(1+|t|)) ≤ ‖𝒯₀(t)B‖ ≤ C_L(1+|t|)‖B‖`.
* **`existsUnique_isIdealSolutionGroup_mainLiteralVelocity`** — the ideal induction equation of
  the velocity has exactly one solution group on `L²_σ`, `mainIdealGroup`, the group of the
  Cauchy formula.
* **`mainTheoremNormalized_holds : MainTheoremNormalized`** — Remark 1.6: every clause of
  Theorem 1.2 for `normalizedVelocity mainVelocity`, with the identities for the operator, the
  semigroup, `γ`, the flow and the ideal group.
* **`tendstoUniformlyOn_resistiveEvolution_mainIdealGroup`** — Remark 1.7 at the velocity of
  Theorem 1.2.
* **`main_theorem_magnetic_scale`** — Corollary 8.3: explicit `c, C > 0` and, for every
  `0 < ε ≤ ε₀`, an eigenmode satisfying the spectral clauses of Theorem 1.2 with the two-sided
  bounds on `|K|` and on the magnetic length.
* **`ideal_resistive_gap_holds`** — the gap between the ideal growth rate `0` and the resistive
  growth rate `≥ γ₀`.
* **`challenge_statement`** — Theorem 1.2 as one proposition in mathlib's terms, the statement of
  [`Challenge.lean`](Challenge.lean); see the next section.

The formalisation follows the paper section by section: the local model (§2,
`lem:jump-horizontal-mode`, `prop:local-seed`), the velocity field on `T³` (§3,
`lem:global-velocity`), the particle dynamics and the ideal group (§4), the horizontal operator on
`T²` and the scaling identity (§5), the background resolvent (§6), the approximate inverse and the
non-zero Riesz projection (§7), the recovery of the magnetic field (§8), and the semigroup
(Appendix A).
[`docs/MODULE_MAP.md`](docs/MODULE_MAP.md) lists the modules for each section.

## The Challenge statement

[`Challenge.lean`](Challenge.lean) is a short, self-contained statement of Theorem 1.2 that uses
only mathlib and fourteen definitions of its own, each with a docstring, so that a reader can check
what is claimed without reading the library. Its theorem `FastDynamoChallenge.fast_dynamo_zero_entropy`
ends in `sorry`: the file is the statement, not the proof.
[`Solution.lean`](Solution.lean) repeats the theorem, with the same statement and docstring, and
proves it by `FastDynamo.challenge_statement` from
[`FastDynamo/Palomar/Main.lean`](FastDynamo/Palomar/Main.lean). Its definitions are those of
[`FastDynamo/Palomar/Statement.lean`](FastDynamo/Palomar/Statement.lean), which repeats the
definitions of `Challenge.lean` character for character;
[`scripts/check-challenge-text.py`](scripts/check-challenge-text.py), run by the release gate,
checks both textual identities. [`comparator.json`](comparator.json) names the two modules, the
compared theorem and the permitted axioms `propext`, `Quot.sound`, `Classical.choice`, for
[Comparator](https://github.com/leanprover/comparator), which checks that the theorem of
`Solution.lean` has the type of the theorem of `Challenge.lean` (with the same definitions) and
uses no other axiom. [`formalization.yaml`](formalization.yaml) records the provenance, sources,
classification, production process, review and the differences from the paper in the
`formalization.yaml` v0.4 format.

**The theorem in words.** There are a Lipschitz, divergence-free, autonomous velocity
`u : T³ → ℝ³` on `T³ = ℝ³/ℤ³` and constants `ε₀, γ₀ > 0` such that, for every diffusivity
`0 < ε ≤ ε₀`:

- a strongly continuous semigroup `S` on `L²_σ` whose generator agrees with
  `L_{ε,u} = curl(u × ·) + εΔ` on `H² ∩ L²_σ` exists, and every such semigroup satisfies
  `‖S(t)‖ ≥ e^{γ₀t}` for all `t ≥ 0` (so `u` is a fast dynamo);
- there are `K ≠ 0`, `λ` with `Re λ ≥ γ₀` and a non-zero `V ∈ H² ∩ L²_σ` whose Fourier
  coefficients vanish off `m₃ = K` (that is, `V = e^{2πiKx₃} b(y)`), with `L_{ε,u}V = λV`;
- the real datum `B_in = Re V` lies in `H² ∩ L²_σ` and is non-zero, and for every such semigroup
  `S(t)B_in = Re(e^{tλ}V)` and `‖S(t)B_in‖ = e^{t Re λ}‖B_in‖` for `t ≥ 0`;

and moreover the particle flow `Φ` of `u` exists, and every time map of every particle flow is
continuous and has topological entropy zero; the ideal equation `∂ₜB = curl(u × B)` has exactly
one solution group `𝒯₀` on `L²_σ`, and `t⁻¹ log ‖𝒯₀(t)‖ → 0` as `t → ∞`. The witnesses are
`mainLiteralVelocity`, `mainEps0` and `mainGrowthFloor`.

**How it differs from Theorem 1.2 as printed** (in full: [`DEVIATIONS.md`](DEVIATIONS.md), B14).

1. The velocity is a Lipschitz function rather than a `W^{1,∞}` class, and divergence-free means
   `∑ᵢ mᵢ ûᵢ(m) = 0` for all `m ∈ ℤ³` — equivalent.
2. `L²_σ` is the orthogonal complement of the gradients of the Fourier characters, and `H²` is
   defined by Fourier weights — equivalent.
3. `L_{ε,u}` is given by its Fourier symbol, with the curl in the divergence form
   `curl(u × B)ᵢ = ∑ⱼ ∂ⱼ(uᵢBⱼ − uⱼBᵢ)` — equivalent.
4. `γ(u,ε)` is not defined: the clause asserts a semigroup whose generator agrees with `L_{ε,u}`
   on `H² ∩ L²_σ` and bounds `‖S(t)‖ ≥ e^{γ₀t}` for every such semigroup and every `t ≥ 0`. The
   library proves Lemma A.1 for velocities independent of `x₃` (DEVIATIONS.md, CA.1), which
   covers the velocity of the theorem, and the semigroup `e^{tL_{ε,u}}` it gives is such a
   semigroup. That it is the only one (a generator has no proper extension that is again a
   generator) is a standard argument that is not formalised for this notion; the compared
   theorem does not use it, and its clauses hold for every such semigroup. Since
   `γ(u,ε) = inf_{t>0} t⁻¹ log ‖e^{tL_{ε,u}}‖` for a `C₀`-semigroup, the bound is equivalent to
   `γ(u,ε) ≥ γ₀`, and it gives the `liminf` clause — equivalent.
5. The eigenmode is given by its Fourier support on `m₃ = K`; `b ≠ 0`, `b ∈ H²` become `V ≠ 0`,
   `V ∈ H²`; the eigen-equation holds in the sense of distributions.
6. "Its solution" is the semigroup orbit for `t ≥ 0`; real fields are `ℂ³`-valued with real
   entries.
7. The flow is characterised through integral curves of the periodic lift of `u`; existence is
   asserted, and the entropy clause holds for every such flow. Topological entropy is mathlib's
   `Dynamics.coverEntropy`, the Bowen–Dinaburg entropy defined through covers by dynamical balls.
8. The ideal group is the unique strongly continuous group on `L²_σ` whose orbits solve
   `∂ₜB = curl(u × B)` tested against the Fourier characters and integrated in time.
9. One existential block `∃ u ε₀ γ₀`, and one triple `(K, λ, V)` for each `ε`.
10. Not part of the compared theorem, but proved in the library (see
    [What is proved](#what-is-proved)): the explicit `ε₀` and `γ₀ ≥ 288`, the independence of `u`
    of `x₃`, `u ≠ 0`, Remark 1.5, Lemma A.1, Remarks 1.6 and 1.7, Corollary 8.3.

The library proves the theorem in its product model `T² × T` (deviation 1 below); the modules of
[`FastDynamo/Palomar/`](FastDynamo/Palomar/) transport the results to mathlib's
`UnitAddTorus (Fin 3)`, which is the library's `Torus 3`, and identify the fourteen definitions
with the library's objects ([`docs/MODULE_MAP.md`](docs/MODULE_MAP.md)).

**Checking it with Comparator.** After `scripts/bootstrap-lean.sh` and a build,

```bash
bash scripts/verify-comparator.sh
```

runs `lake comparator` of the pinned toolchain with the configuration of `comparator.json`. It
builds and exports `Challenge` and `Solution` inside a [bubblewrap](https://github.com/containers/bubblewrap)
sandbox, so `bwrap` must be installed and able to create user namespaces; it checks the
statement, the axioms, and the exported proof with Lean's kernel and with the independent kernels
NanoDa and con-ron that the toolchain bundles, and ends with `Your solution is okay!`. The release
gate does not run it, since CI runners may lack user namespaces; it builds `Challenge` and
`Solution` and checks the textual identities above.

## Deviations from the paper

[`DEVIATIONS.md`](DEVIATIONS.md) lists every respect in which the Lean statements and proofs
differ from the paper, with stable identifiers; a statement of the paper with no entry there is
formalised as stated. The deviations to know before relying on the headline theorems:

1. **The model** (A1, A2, A5, A6): velocities are axially independent, in a Fourier-graph
   `W^{1,∞}`; the magnetic field lives on the product torus `T² × T`, and norms, the semigroup and
   `γ` are transported isometrically to `Torus 3`, where the particle flow, the ideal equation and
   Remark 1.7 are stated; `L²_σ` is Fourier-defined; `L_{ε,u}` is the curl form computed weakly
   `H² → H⁻²`, and on `L²_σ` the operator with domain the divergence-free `H²` fields whose values
   are the transport–stretching action, equal there to the curl form. Lemma A.1 and the notions of
   dynamo are therefore stated for axially independent velocities only (CA.1, C1.2).
2. **Solution classes** (B6, C4.4): "its solution" of Theorem 1.2 is read in the class of forward
   strong solutions of the curl-form equation (`H²`-valued, the equation in `H⁻²` for `t ≥ 0`), a
   class the paper does not name; the solutions of the ideal equation are weak solutions,
   `C([−T, T]; L²)` curves satisfying the equation tested against smooth fields and integrated in
   time, and a solution group is a group of operators on `L²_σ` all of whose orbits are weak
   solutions.
3. **Scope of the ideal results** (C4.3, C4.4, C4.11, C1.5): existence and uniqueness of the ideal
   solution group are proved for the velocity of the paper, and Remark 1.7 for the velocity of
   Theorem 1.2 — not for general Lipschitz velocities.
4. **The growth rate** (B3, B4): `γ(u, ε)` is defined as the `limsup` in `EReal` of
   `t⁻¹ log ‖e^{tL}‖`, of the semigroup of Lemma A.1 read on `Torus 3`, and proved to be a limit.
5. **Shape of the statement** (A10, B2): explicit witnesses; the clauses sit in several
   predicates with separate existentials over `K, λ, b`. The predicate of the semigroup orbit
   contains the spectral clauses at its own triple, so the eigenmode, the real datum and its
   solution are stated for one `(K, λ, b)`; the literal-torus clauses and Corollary 8.3 (C8.2)
   choose their triple separately.
6. **Entropy** (B8, C4.7): Mathlib's cover entropy, proved zero by a Lipschitz-iterate criterion
   instead of the power rule and `h ≤ 3 log Lip`.
7. **Choices** (A9, C2.3, C2.6, C2.8): `N = 2πk_*` with `k_*` a parameter (`k_* = 1` is the
   paper's `e^{2πix₃}`); `ϱ = 32`, whence `Re λ_* ≥ 448 − 4π²`, `γ₀ ≥ 288`; the seed `f_*` is
   `L²`, not `C_c^∞`; cut-offs, radii and thresholds are explicit (C3.1–C3.4, C6.2, C7.2).
8. **Different forms** of single statements: Remark 1.6 with the norm of `TransverseRealW1Inf`
   and the operator identity for the transport–stretching action (B10); analyticity of angle
   `π/4` and the spectrum of a partially defined operator in Lemma A.1 (CA.1, A7); the spectrum of
   `A_w` in §2.3 defined through the form pencil (C2.5); the regularity of `u` for a plane
   representative (C3.5); Lemma 5.2 as conjugations (C5.2).
9. **Different routes** (B12, B13, C1.6, C2.9–C2.12, C3.6, C4.5–C4.9, C4.11–C4.13, C5.3,
   C6.4–C6.6, C7.4, C8.3, C8.4, CA.2, CA.3): among others Hille–Yosida, identification of the
   generator and restriction to `L²_σ` instead of perturbation of `εΔ`; a point-spectrum argument
   for the spectral mapping theorem; an energy estimate with a mollifier instead of Trotter–Kato;
   Lipschitz test fields and Grönwall instead of Ambrosio–Crippa; a closed-form flow; the scalar
   route for `b₃` in Lemma 8.1.
10. **Stronger clauses** (B7, C1.1, C1.3, C5.1, C6.1, C8.2): the norm law for all real `t`; the
    energy identity as a theorem, also along solutions of the curl-form equation; Remark 1.4 for
    every eigenmode; Lemma 5.1 without the hypothesis `div⊥ w⊥ = 0`; continuity of the background
    resolvent of Proposition 6.1 on `𝒢_τ` and its analyticity on a neighbourhood, which the
    proposition does not state; explicit `c, C` in Corollary 8.3.
11. **Not formalised** (Part D): Conjecture 1.1 and Remarks 1.3, 7.5 and 8.4. The proof of
    Theorem 1.2 depends on none of them.

## Guarantees

- **No `sorry`, no escape hatches.** The release gate [`scripts/audit.sh`](scripts/audit.sh)
  strips comments and strings from every source file of the library, `Check.lean`,
  `CheckDecls.lean` and `Solution.lean` and rejects `sorry`, `sorryAx`, `admit`, the
  declaration keywords `axiom`, `opaque`, `constant`, `unsafe`, `extern`, `partial def`, and
  `implemented_by`, `native_decide`, `lcProof`, `unsafeCast`, `ofReduceBool`, `ofReduceNat`,
  `trustCompiler`. It requires every module except
  [`FastDynamo/AxiomAudit.lean`](FastDynamo/AxiomAudit.lean), which the gate elaborates on its own,
  to be imported from the root module. The library and `Solution.lean` are
  built with warnings as errors, and the library passes the Batteries linter; `Challenge.lean`
  must build with exactly one warning, its deliberate `sorry`. Every tracked `.lean` file is a
  `module` file of at most 10,000 lines, and none is a symbolic link
  ([`scripts/check-lean-sources.py`](scripts/check-lean-sources.py)).
- **Axioms.** [`FastDynamo/AxiomAudit.lean`](FastDynamo/AxiomAudit.lean) prints the axioms of
  1114 declarations; the gate fails unless each depends on no axiom other than `propext`,
  `Classical.choice`, `Quot.sound`, and unless the *set* of reported declarations equals the
  checked-in list [`scripts/audited-declarations.txt`](scripts/audited-declarations.txt).
- **Release surface.** [`Check.lean`](Check.lean) is a curated list of 197 `#check`
  commands: the statement layer and the headline theorems, then the principal results of each
  section in the order of the proof. Every one of them is on the audited list, and the file is
  elaborated with warnings as errors.
- **Non-vacuity.** The witnesses are explicit and carry a numeral (`γ₀ ≥ 288`); the state space
  `L²_σ` of the dynamical clauses is not the zero space
  (`exists_ne_zero_literalSolenoidalSubspace`); the particle flow is unique
  (`IsParticleFlow.unique`), and so are the solution with the real datum
  (`productPhysicalInductionOperator_forwardStrongSolutionsUnique`) and the ideal solution group
  (`existsUnique_isIdealSolutionGroup_mainLiteralVelocity`).
- **Pinned toolchain.** Lean `v4.35.0` and mathlib `v4.35.0`, with every dependency revision
  recorded in [`lake-manifest.json`](lake-manifest.json).

## Building

The Lean toolchain is pinned in [`lean-toolchain`](lean-toolchain) (`leanprover/lean4:v4.35.0`)
and every dependency revision in [`lake-manifest.json`](lake-manifest.json). With
[elan](https://github.com/leanprover/elan) installed, the standard commands build the library:

```bash
lake exe cache get   # prebuilt mathlib
lake build
```

The project itself is compiled from source; on four cores this takes about a quarter of an hour.
Afterwards `import FastDynamo` loads the whole development.

The repository also carries a self-contained toolchain, which the release gate uses and which
needs no elan. On Linux x86-64, [`scripts/bootstrap-lean.sh`](scripts/bootstrap-lean.sh)
downloads the official Lean `v4.35.0` release archive into `.toolchains/` and verifies its
checksum, compiles a small `LD_PRELOAD` library from
[`scripts/proc_exe_shim.c`](scripts/proc_exe_shim.c) (Lean locates its installation through
`/proc/self/exe`; the library answers that lookup where procfs is not mounted), fetches the
dependencies pinned in `lake-manifest.json`, checks the mathlib revision, and downloads the
mathlib cache. It needs `curl`, `sha256sum`, `tar`, `unzstd`, `cc`, `git` and `flock`.
[`scripts/lake`](scripts/lake) and [`scripts/lean`](scripts/lean) are wrappers that run `lake`
and `lean` of that installation with the library preloaded and the cache directory set.

```bash
./scripts/bootstrap-lean.sh
```

The release gate builds the library with warnings as errors and runs the checks of
[Guarantees](#guarantees); on four cores it takes about a quarter of an hour.

```bash
LEAN_NUM_THREADS=4 bash scripts/audit.sh
```

## Repository layout

```
FastDynamo/             the library
  Main.lean, MainTheorem.lean, MainTheoremStrengthened.lean, MainTheoremNormalized.lean
                        the statement layer and the headline theorems
  Local/                §2: the local model on the plane
  Global/               §3, §6, §7: the velocity, the background resolvent, the transfer
  Reduction/            §5: the scaling
  Finish/               §8 and the remarks of §1: axial recovery, the real solution,
                        the magnetic scale, zero mean
  Dynamics/             §1, §4 and Appendix A: C₀-semigroups, the energy identity,
                        the particle flow and the ideal equation
    Flow/               the particle flow and its variational equation
    Ideal/              the ideal solution group, its weak form and uniqueness
    HilleYosida/        Hille–Yosida generation, also of analytic semigroups
    Assembly/           the induction semigroup, Lemma A.1, γ(u, ε), "its solution"
    VanishingDiffusivity/  Remark 1.7
  Operator/             operator theory: forms, sectors, Fredholm, Riesz projections
  Analysis/, Fourier/   Sobolev spaces, multipliers, Fourier analysis on the torus and the plane
  Palomar/              Theorem 1.2 in the form of the Challenge statement
  Conventions.lean      the torus, scalar and vector conventions
  AxiomAudit.lean       the axiom report
FastDynamo.lean         the root module, importing the whole library
Challenge.lean          Theorem 1.2 in mathlib's terms: the statement, ending in `sorry`
Solution.lean           the same theorem, proved from the library
comparator.json         the Comparator configuration: modules, theorem, permitted axioms
formalization.yaml      provenance, sources, process and review (formalization.yaml v0.4)
Check.lean              the release surface
CheckDecls.lean         the check that every declaration cited in the blueprint exists
CORRESPONDENCE.md       paper ↔ Lean, statement by statement
DEVIATIONS.md           every deviation from the paper
docs/MODULE_MAP.md      section of the paper ↔ modules
blueprint/              the Lean blueprint
home_page/              the landing page of the documentation site
scripts/                the release gate, the pinned toolchain and the Comparator check
```

## Blueprint

[`blueprint/`](blueprint/) is a Lean blueprint built with
[leanblueprint](https://github.com/PatrickMassot/leanblueprint), with one chapter per section of
the paper and one for its appendix. Each node carries the statement, the Lean declarations that
formalise it, and its dependencies; where the Lean statement or proof differs from the paper, a
paragraph directly after the node says how. Every node is formalised. The statements of the paper
without a node are exactly the four that are not formalised: Conjecture 1.1 and Remarks 1.3, 7.5
and 8.4.

To build it, install `leanblueprint` (it needs a TeX distribution and Graphviz) and run
`leanblueprint web` or `leanblueprint pdf` from the repository root. The release gate checks that
every declaration cited in the blueprint exists in the built library.

The workflow [`.github/workflows/blueprint.yml`](.github/workflows/blueprint.yml), which runs on
every push to `main` and deploys nothing, builds the blueprint (web and pdf) and the API
documentation and assembles them with [`home_page/`](home_page/), the landing page, into the
`documentation-site` artifact of the run.

## How this was built

The Lean code, the blueprint and the documentation were written by AI coding agents (Anthropic's
Claude models, run through Claude Code); the author of the paper supplied the paper, directed and
supervised the work and set its policies. Lean checks the proofs against the formal statements;
the correspondence between those statements and the paper is documented in
[`CORRESPONDENCE.md`](CORRESPONDENCE.md) and [`DEVIATIONS.md`](DEVIATIONS.md). The author
reviewed that the statements are the intended theorems; each public statement, the Challenge
statement among them, was compared with the paper by independent AI review passes. This is not
external peer review.

## Author and citation

The formalisation accompanies the paper of [**Lukas Niebel**](https://lukasniebel.github.io). To
cite it, use [`CITATION.cff`](CITATION.cff).

## Acknowledgements

Lukas Niebel is funded by SNSF Starting Grant TMSGI2_226018 and by the Deutsche
Forschungsgemeinschaft (DFG, German Research Foundation) under Germany's Excellence Strategy
EXC 2044/2–390685587, Mathematics Münster: Dynamics–Geometry–Structure.

## License

The Lean code in this repository is copyright 2026 Lukas Niebel and is licensed under the Apache
License 2.0; see [`LICENSE`](LICENSE).
