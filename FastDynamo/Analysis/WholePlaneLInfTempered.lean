module

public import FastDynamo.Analysis.WholePlaneCoefficientScaling

/-!
# Whole-plane `L∞` coefficients as tempered distributions

This module defines the canonical embedding `wholePlaneLInfToTempered` of whole-plane `L∞`
coefficients into tempered distributions.

The module is separate from `FastDynamo/Analysis/WholePlaneCoefficientScaling.lean` for build
weight: that module sits under some one hundred and seventy dependents, and no declaration
there refers to the `L∞` embedding.
-/

@[expose] public section

namespace FastDynamo

noncomputable section

open MeasureTheory
open scoped ENNReal LineDeriv SchwartzMap

open scoped LineDeriv SchwartzMap

section LInfTempered

variable (F : Type*) [NormedAddCommGroup F] [InnerProductSpace ℂ F]
  [CompleteSpace F]

/-- The canonical embedding of whole-plane `L∞` coefficients into tempered
distributions. -/
def wholePlaneLInfToTempered :
    WholePlaneLInf F →L[ℂ] 𝓢'(WholePlane, F) :=
  MeasureTheory.Lp.toTemperedDistributionCLM F volume ∞

end LInfTempered

end

end FastDynamo
