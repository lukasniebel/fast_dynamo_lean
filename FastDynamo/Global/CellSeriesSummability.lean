module

public import FastDynamo.Local.ParameterizedHelicalProfile
public import FastDynamo.Analysis.WholePlaneL4FormPerturbationHolder
public import FastDynamo.Operator.FormCoercivityConstants
public import FastDynamo.Analysis.WholePlaneH1AntiDual
public import FastDynamo.Operator.RieszProjectionCalculus
public import FastDynamo.Global.TorusCellPlacement

/-!
# Summability of cell families bounded by the axial scales

Two comparison principles for Banach-valued cell families: a family bounded by a constant
times the axial amplitudes `f.axialAmplitude tau n`, or by a constant times the axial-gradient
majorant `f.axialGradientScale tau n`, is summable.  `Global/TorusFullVelocityConcrete.lean`
uses them for the `L∞` summability of the placed axial cell values and derivatives.
-/

@[expose] public section

namespace FastDynamo

noncomputable section

open Filter
open scoped BigOperators Topology

namespace ScaleFamily

variable {p : LocalSeedParameters} {r : ScaleRatios p}

/-! ## Generic comparison principles for cell fields -/

/-- A Banach-valued cell family bounded by the axial-amplitude scale is
summable. -/
theorem summable_of_norm_le_axialAmplitude
    {E : Type*} [NormedAddCommGroup E] [CompleteSpace E]
    (f : ScaleFamily r) (tau : ℝ) (u : ℕ → E) (C : ℝ)
    (hu : ∀ n, ‖u n‖ ≤ C * f.axialAmplitude tau n) : Summable u :=
  (f.summable_axialAmplitude tau).mul_left C |>.of_norm_bounded hu

/-- A Banach-valued derivative cell family bounded by the axial-gradient
scale is summable. -/
theorem summable_of_norm_le_axialGradientScale
    {E : Type*} [NormedAddCommGroup E] [CompleteSpace E]
    (f : ScaleFamily r) (tau : ℝ) (u : ℕ → E) (C : ℝ)
    (hu : ∀ n, ‖u n‖ ≤ C * f.axialGradientScale tau n) : Summable u :=
  (f.summable_axialGradientScale tau).mul_left C |>.of_norm_bounded hu

end ScaleFamily

end

end FastDynamo
