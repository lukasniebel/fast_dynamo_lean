module

public import FastDynamo

/-!
# Theorem 1.2: the proof of the Challenge statement

The theorem `FastDynamoChallenge.fast_dynamo_zero_entropy` of `Challenge.lean`, with the same
statement and docstring, proved by `FastDynamo.challenge_statement`
(`FastDynamo/Palomar/Main.lean`).  The definitions the statement uses (`T3`, `R3`, `C3`, `L2`,
`toTorus`, `re3`, `IsDivergenceFree`, `gradChar`, `L2σ`, `MemH2`, `inductionRHS`,
`IsInductionSemigroup`, `IsIdealGroup`, `IsFlow`, in the namespace `FastDynamoChallenge`) are
those of `FastDynamo/Palomar/Statement.lean`, which repeats the definitions of `Challenge.lean`
character for character; `scripts/check-challenge-text.py` checks both textual identities.
-/

@[expose] public section

noncomputable section

namespace FastDynamoChallenge

open MeasureTheory UnitAddTorus Filter Topology
open scoped NNReal

/-- **Theorem 1.2 of Niebel, arXiv:2608.02586v3.**  There are a Lipschitz, divergence-free,
autonomous velocity `u : 𝕋³ → ℝ³` and constants `ε₀, γ₀ > 0` such that:

1. *(fast dynamo)* for every `0 < ε ≤ ε₀`, the induction semigroup `e^{t L_{ε,u}}` on `L²_σ`
   exists and `‖e^{t L_{ε,u}}‖_{L²_σ → L²_σ} ≥ e^{γ₀ t}` for all `t ≥ 0`; equivalently, the
   paper's growth rate `γ(u, ε) = lim t⁻¹ log ‖e^{t L_{ε,u}}‖` is `≥ γ₀`, and hence
   `liminf_{ε↓0} γ(u, ε) ≥ γ₀`;
2. *(eigenmode)* for every `0 < ε ≤ ε₀` there are `K ≠ 0`, `λ` with `Re λ ≥ γ₀`, and
   `0 ≠ V ∈ H² ∩ L²_σ` of the form `V(y, x₃) = e^{2πiKx₃} b(y)` (all Fourier coefficients
   with `m₃ ≠ K` vanish) with `L_{ε,u} V = λ V`;
3. *(growing real solution)* the real datum `B_in = Re V ∈ H² ∩ L²_σ` is non-zero, and its
   solution `e^{t L_{ε,u}} B_in` is `Re (e^{tλ} V)`, with `‖B(t)‖₂ = e^{t Re λ} ‖B_in‖₂`;
4. *(zero entropy)* the particle flow `Φ` of `u` exists, and every time-`t` map is continuous
   with topological entropy `0`;
5. *(no ideal growth)* the ideal induction equation has exactly one solution group `𝒯₀` on
   `L²_σ`, and `t⁻¹ log ‖𝒯₀(t)‖_{L²_σ → L²_σ} → 0` as `t → ∞`.

The paper states clause 1 for `0 < ε ≤ ε₀` as `γ(u, ε) ≥ γ₀`.  Here it is stated in the form
`‖e^{t L_{ε,u}}‖ ≥ e^{γ₀ t}` for all `t ≥ 0`, which for a `C₀`-semigroup is equivalent to
`γ(u, ε) ≥ γ₀`, since `γ(u, ε) = inf_{t>0} t⁻¹ log ‖e^{t L_{ε,u}}‖`.  Topological entropy is
mathlib's `Dynamics.coverEntropy`, the definition of topological entropy through covers by
dynamical balls (Bowen–Dinaburg), stated for uniform spaces; that on a compact metric space it is
the topological entropy the paper refers to (Hasselblatt–Katok, §2.5e) is a standard fact,
not a theorem of mathlib. -/
theorem fast_dynamo_zero_entropy :
    ∃ u : T3 → R3, (∃ L, LipschitzWith L u) ∧ IsDivergenceFree u ∧
    ∃ ε₀ γ₀ : ℝ, 0 < ε₀ ∧ 0 < γ₀ ∧
    (∀ ε, 0 < ε → ε ≤ ε₀ →
      (∃ S, IsInductionSemigroup u ε S) ∧
      (∀ S, IsInductionSemigroup u ε S → ∀ t : ℝ≥0, Real.exp (γ₀ * t) ≤ ‖S t‖) ∧
      ∃ (K : ℤ) (lam : ℂ) (V : L2σ),
        K ≠ 0 ∧ γ₀ ≤ lam.re ∧ V ≠ 0 ∧ MemH2 ⇑(V : L2) ∧
        (∀ m i, m 2 ≠ K → mFourierCoeff (fun x => (V : L2) x i) m = 0) ∧
        (∀ m i, inductionRHS u ε ⇑(V : L2) m i =
          lam * mFourierCoeff (fun x => (V : L2) x i) m) ∧
        ∃ Bin : L2σ, Bin ≠ 0 ∧ MemH2 ⇑(Bin : L2) ∧
          ⇑(Bin : L2) =ᵐ[volume] (fun x => re3 ((V : L2) x)) ∧
          ∀ S, IsInductionSemigroup u ε S → ∀ t : ℝ≥0,
            ⇑(S t Bin : L2) =ᵐ[volume] (fun x => re3 (Complex.exp (t * lam) • (V : L2) x)) ∧
            ‖S t Bin‖ = Real.exp (t * lam.re) * ‖Bin‖) ∧
    (∃ Φ, IsFlow u Φ) ∧
    (∀ Φ, IsFlow u Φ → ∀ t, Continuous (Φ t) ∧ Dynamics.coverEntropy (Φ t) Set.univ = 0) ∧
    ∃ T, IsIdealGroup u T ∧ (∀ T', IsIdealGroup u T' → T' = T) ∧
      Tendsto (fun t : ℝ => t⁻¹ * Real.log ‖T t‖) atTop (𝓝 0) := by
  exact FastDynamo.challenge_statement

end FastDynamoChallenge
