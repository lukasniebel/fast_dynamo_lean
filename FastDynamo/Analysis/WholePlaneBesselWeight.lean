module

public import FastDynamo.Analysis.WholePlaneSobolev
public import FastDynamo.Analysis.AntiDual
public import FastDynamo.Analysis.BoundedOperatorMultiplier
public import FastDynamo.Analysis.WholePlaneCoordinateDistributions

/-!
# The order-one Bessel weight on the whole plane

This file defines the order-one Bessel weight `(1+|ξ|²)^(1/2)` (`wholePlaneBesselOneWeight`).
-/

@[expose] public section

namespace FastDynamo

noncomputable section

open MeasureTheory
open scoped ENNReal FourierTransform LineDeriv SchwartzMap

/-- The order-one Bessel weight `(1+|ξ|²)^(1/2)`. -/
def wholePlaneBesselOneWeight (xi : WholePlane) : ℝ :=
  Real.sqrt (1 + ‖xi‖ ^ 2)

end

end FastDynamo
