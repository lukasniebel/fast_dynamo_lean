# The module map

This is the map of the development: which Lean modules realise which section of the paper,
*A fast dynamo with zero topological entropy* (L. Niebel, arXiv:2608.02586v3).  The
blueprint under `blueprint/` is the same map with the statements attached, one node per
statement, and `CORRESPONDENCE.md` lists the Lean declaration of every numbered statement.
Section numbers below are the paper's; statements and displays are cited by their LaTeX labels.
Every one of the 411 modules under `FastDynamo/` appears below, by name.  Paths in the tables
are relative to `FastDynamo/`.

Conventions.  `C2 = EuclideanSpace ℂ (Fin 2)`; the transverse torus is `T²` and the
three-torus is modelled as the product `T² × T`; `H²` spaces are Fourier graph spaces;
`W^{1,∞}` is `TransverseRealW1Inf`, a value plus two derivative fields in `L^∞` tied by the
Fourier weak-derivative identities.

## The shape of the proof

```
  §2 local seed  ──►  §3 global velocity  ──►  §5 horizontal operator + scaling
                                                     │
                                                     ├──► §6 background resolvent on 𝒢_τ
                                                     │            │
                                                     └────────────┴──► §7 two-summand
                                                                        parametrix,
                                                                        Riesz projection ≠ 0
                                                                             │
                                                                             ▼
                                                                       §8 axial recovery,
                                                                       real solution,
                                                                       Theorem 1.2
```

§4, the particle dynamics and the ideal induction group, hangs off §3 alone: it needs the
global velocity and nothing else, and it supplies the two dynamical clauses of Theorem 1.2 and
the weak form and uniqueness of the ideal solution group.  Appendix A, the semigroup lemma,
supplies the semigroup that the growth-rate clause is about, and the uniqueness of its orbits.
Remark 1.7, the vanishing-diffusivity limit, needs both the semigroup and the ideal group.

The parameters are chosen in the order the paper states in §3.1 and in the summary paragraph
after the proof of `prop:global-spectral-transfer`, and nothing feeds back.  First the seed data
`(v, I, Γ, 𝒢, g_*, f_*, L_*)` of `prop:local-seed`; then the ratio `1 < q < √(δ₊/δ₋)` and the
axial cut-off `ϑ`; then the axial shift `τ` of `eq:axial-separation-choice` (in Lean a closed
term in data that involve neither `τ` nor `K₀`); finally one base index `K₀`, large enough for
five monotone thresholds: the integer-ratio bound `q + K₀⁻¹ < √(δ₊/δ₋)` of `eq:ratio-choice`,
the chart packing `eq:chart-packing`, the core containment `R_v ℓ_n < R_n/10` of
`eq:local-support-in-buffer` at `R_v = max(1+h, L_*)`, the background diffusion clause
`eq:background-diffusion-small` and the parametrix error clause `eq:error-small`.  The witness
support `L_* ℓ_n < R_n/5` of `eq:scaled-witness-support` is not a sixth threshold: it follows
from the core containment because `R_v ≥ L_*`.

## §1 — the statement layer

| module | content |
|---|---|
| `Main.lean` | `MainReducedClauses`, `MainReducedTarget`, `MainPhysicalClauses`, `MainPhysicalConclusion`: the spectral half of `thm:main`, clause by clause, and the reduction of the physical clauses to the reduced target |
| `MainTheorem.lean` | `mainReducedTarget_holds`, `mainPhysicalConclusion_holds` (alias `main_theorem_spectral`) |
| `Global/MainTheoremWitnesses.lean` | the witnesses `mainVelocity`, `mainEps0`, `mainGrowthFloor`, `ε₀ = δ₊/K₀²`, `γ₀ ≥ (3/4)(448 − 4π²) ≥ 288`, `mainReducedClauses_holds` |
| `Global/ParameterChainWitnesses.lean` | the same three witnesses read off the parameter chain `mainParameterChoice` |
| `MainTheoremStrengthened.lean` | `MainTheoremStrengthened` and `main_theorem_strengthened`: explicit constants, the regularity of the velocity, `MainLiteralTorusClauses`, `MainEveryAdmissibleCellClauses`, the growth-rate clause (`growthRate`, `growthRate_le`), the uniqueness-carrying orbit clauses (`semigroupOrbit`, `MainSemigroupOrbitClauses`), the normalised velocity; `MainTheoremComplete` and the conditional forms `mainTheoremComplete_of_lagrangian`, `ideal_resistive_gap`, `ideal_resistive_gap_at_diffusivity` |
| `MainTheoremNormalized.lean` | Theorem 1.2 for the normalised velocity of Remark 1.6 (the remark after `rem:scope-intro`): `MainTheoremNormalized`, `mainTheoremNormalized_holds`, every clause of `thm:main` for `ũ = normalizedVelocity mainVelocity` with threshold `ε₀/M` and floor `γ₀/M`, and the identities `L_{ε,ũ} = M⁻¹ L_{Mε,u}`, `γ(ũ, ε) = M⁻¹ γ(u, Mε)` |
| `Dynamics/Assembly/FastDynamo.lean` | the definitions of §1.1: `IsDynamoAt`, `IsFastDynamo`, `IsSlowDynamo` in terms of `γ(u, ε)`; `isDynamoAt_mainVelocity`, `isFastDynamo_mainVelocity` (the fast-dynamo property of `thm:main`, `eq:main-growth-conclusion`), `IsFastDynamo.not_isSlowDynamo` |
| `Dynamics/MainLagrangianClauses.lean` | the endpoints without hypothesis `mainTheoremLagrangian_holds`, `mainTheoremDynamical_holds`, `mainTheoremComplete_holds`, `ideal_resistive_gap_holds`, `ideal_resistive_gap_at_diffusivity_holds` |
| `Operator/ReducedInductionScaling.lean` | homogeneity of the reduced operator; the normalised velocity of the remark after `rem:scope-intro` |
| `Conventions.lean` | global conventions: the spaces, the fibres and the names used throughout |
| `AxiomAudit.lean` | `#print axioms` for every audited declaration; checked by `scripts/audit.sh` |

`MainTheoremStrengthened.lean` defines `mainLiteralVelocity` and therefore cannot import the
flow without a cycle; that is why the implication forms `ideal_resistive_gap` and
`mainTheoremComplete_of_lagrangian` are there and the endpoints without hypothesis are in
`Dynamics/MainLagrangianClauses.lean`.  The `ideal_resistive_gap*` theorems state the
ideal–resistive contrast that the paper carries inside Theorem 1.2 rather than as a statement of
its own: the left member is the last clause of the theorem and the right member the growth
clause.  `ideal_resistive_gap_at_diffusivity_holds` gives `γ₀ ≤ γ(u,ε)` at each
`0 < ε ≤ ε₀`, not only in the lower limit.

## §2 — the local seed (`prop:local-seed`)

The weak form and the operator on `ℂ²`, `Local/`:

| module | content |
|---|---|
| `Local/WholePlaneC2.lean` | the `ℂ²` substrate on the plane (`L²`, `H¹`, `H²`, Rellich, `H¹ ↪ L⁴`) |
| `Local/HorizontalWeakForm.lean` | `𝔩_w` of `eq:jump-sectorial-form`, boundedness, Gårding `eq:sectorial-estimate-b`, the imaginary-part bound, sectoriality |
| `Local/HorizontalFormOperator.lean` | `A_w` via `Operator/AssociatedForm.lean`; the pencil `𝔸_w(z) = F_z + K_w`; compactness of the velocity terms |
| `Local/HorizontalFormCompactness.lean` | compactness of the lower-order form `K_w` and the analytic Fredholm factorisation `𝔸_w(z) = F_z(1 + F_z⁻¹K_w)` |
| `Local/HorizontalFormResolvent.lean` | the inverse of `𝔸_w(z)` restricted to `L²` is the resolvent `(z − A_w)⁻¹` |
| `Local/HorizontalSpectrumEigenvalue.lean` | the analytic Fredholm paragraph of §2.3: every point of `horizontalSpectrum N w` is an eigenvalue of `A_w`, `mem_horizontalSpectrum_iff`, and these eigenvalues are isolated (`isDiscrete_horizontalSpectrum`) |

The Ponomarenko mode: Bessel functions, the dispersion relation and the radial calculation,
`Local/`:

| module | content |
|---|---|
| `Local/ModifiedBessel.lean` | `I₀`, `I₁`, `I₂` from Mathlib's regularised hypergeometric series |
| `Local/ModifiedBesselIRecurrence.lean` | differentiation and recurrence identities for `I₀, I₁, I₂` |
| `Local/ModifiedBesselIIntegral.lean` | the cosine-integral representation of `I₁` |
| `Local/ModifiedBesselIGaussian.lean` | Gaussian coordinates for the `I₁` integral |
| `Local/ModifiedBesselK.lean` | `K₀`, `K₂` by their hyperbolic integrals |
| `Local/ModifiedBesselKAnalytic.lean` | analyticity of `K₀`, `K₂` on the right half-plane |
| `Local/ModifiedBesselKRecurrence.lean` | derivative recurrences, `K₁`, by improper integration by parts |
| `Local/ModifiedBesselKODE.lean` | the modified Bessel equations for `K₀`, `K₁`, `K₂` |
| `Local/ModifiedBesselKGaussian.lean` | Gaussian coordinates for the `K₁` integral |
| `Local/ModifiedBesselKSecondOrderGaussian.lean` | second-order Gaussian expansion of the `K₁` amplitude |
| `Local/ModifiedBesselGaussianMoments.lean` | half-line Gaussian moments for the order-one estimates |
| `Local/ModifiedBesselHigherGaussianMoments.lean` | higher half-line Gaussian moments |
| `Local/ModifiedBesselWronskian.lean` | normalised Wronskians, `orderZeroWronskian_eq_one_div` |
| `Local/ModifiedBesselBoundaryBehavior.lean` | behaviour of the radial branches at the origin and at infinity |
| `Local/PonomarenkoSectorOrderOneProduct.lean`, `Local/PonomarenkoSegmentDispersion.lean` | the sector estimate `‖zI₁K₁ − ½‖ ≤ 3/(Re z)²` and `ϱ³𝒟(ϱ(1+it)) = (1+it)⁻³ + O(ϱ⁻²)` |
| `Local/PonomarenkoSegmentRoot.lean` | the intermediate-value root `t_ϱ ∈ (1/2, 3/4)`, `Ω = −2/Im 𝒟(κ)`, the certificate at `N = 2π`, `ϱ = 32`, `Re λ_* ≥ 448 − 4π²` |
| `Local/PonomarenkoFreeOmegaInterface.lean` | `CertifiedInterfaceData`, `TransverseInterfaceLaws`, `jumpAxialSpeed` |
| `Local/PonomarenkoCrossNormalizedJump.lean` | the cross-normalised radial branches, matching at `r = 1` without denominators |
| `Local/PonomarenkoCrossNormalizedAxial.lean` | the exterior axial branch `axialOutside` |
| `Local/PonomarenkoRealRadialBridge.lean` | real-radial boundary derivatives of the cross-normalised branches |
| `Local/PonomarenkoCrossNormalizedRadialODE.lean` | the transverse bulk equation reduced to modified Bessel equations in `r` |
| `Local/PolarHessianCalculus.lean` | polar Hessian estimates on the punctured plane |
| `Local/PonomarenkoCartesianInteriorDerivative.lean` | derivatives of the interior origin profiles |
| `Local/PonomarenkoOriginProfiles.lean` | smoothness of the interior field through the polar axis |
| `Local/PonomarenkoCartesianExteriorDerivative.lean` | Cartesian derivatives of the exterior Bessel field |
| `Local/PonomarenkoCartesianExteriorPhysicalDerivative.lean` | derivatives of the physical components of the exterior branches |
| `Local/PonomarenkoExteriorSecondDerivative.lean` | second Cartesian partials of the exterior field |
| `Local/PonomarenkoExteriorSecondPartialBounds.lean` | exponential bounds for the second partials of the exterior branches |
| `Local/ComplexRadius.lean` | the complex radius `complexRadius` of the Cartesian formulas |
| `Local/PonomarenkoCartesianExteriorDecay.lean` | exponential decay of the exterior radial branches |
| `Local/PonomarenkoExteriorDerivativeDecay.lean` | `L²` representatives of the Cartesian derivatives |
| `Local/WholePlaneSliceRadius.lean` | continuity and limits of the slice coordinates |
| `Local/PonomarenkoCartesianPolarLaplacian.lean` | the polar Laplacian of the angular modes on the punctured plane |
| `Local/PonomarenkoDispersionAnalytic.lean` | the dispersion function `𝒟` and its analyticity |
| `Local/PonomarenkoOrderOneProduct.lean` | the order-one product `zI₁(z)K₁(z)`, its analyticity, the scaled dispersion function written through it, a derivative bound by Cauchy's estimate |
| `Local/PonomarenkoGaussianFactors.lean` | Gaussian majorants for the factors of `I₁` and `K₁` |
| `Local/PonomarenkoSecondOrderProduct.lean` | the second-order Gaussian remainder of `I₁` and the first correction of the order-one product |

The discontinuous screw flow and its eigenmode, `Local/`:

| module | content |
|---|---|
| `Local/HorizontalModeBranches.lean` | the Cartesian mode `b₁ ± ib₂` from the cross-normalised branches |
| `Local/HorizontalModeH1.lean` | the mode in `H¹(ℝ²; ℂ²)`, the form domain of `𝔩_w` |
| `Local/HorizontalModeWeakIdentity.lean` | `V⁰`, the mode, its exponential tail; the weak identity reduced to bulk and interface parts |
| `Local/HorizontalModeSecondDerivatives.lean` | second Cartesian derivatives of the interior branch |
| `Local/HorizontalModeExteriorSecondDerivatives.lean` | second Cartesian derivatives of the exterior branch |
| `Local/HorizontalModeBulkIdentity.lean` | the bulk identity `Δ⊥b = κ²b` off the unit circle |
| `Local/HorizontalModeBulkL2.lean` | the bulk identity as an identity of `L²` classes |
| `Local/HorizontalModeInterface.lean`, `Local/HorizontalModeSurface.lean` | the unit-circle jump densities and their pointwise cancellation |
| `Local/HorizontalModeEigenpair.lean` | `lem:jump-horizontal-mode`: `exists_horizontalMode_eigenpair_two_pi` |

Isolation, smoothing and the seed record, `Local/`:

| module | content |
|---|---|
| `Local/HorizontalModeIsolation.lean`, `Local/HorizontalModeContour.lean` | discreteness of the spectrum in the open right half-plane; the contour `Γ`, `P⁰`, `modeIsolation` |
| `Local/SeedParameters.lean` | `LocalSeedParameters`: `N = 2πk_*`, `I = [δ₋, δ₊]`, `Γ`, `g_* > 0` |
| `Local/RadialVelocity.lean` | helical Schwartz velocities of the squared radius as velocity coefficients |
| `Local/ParameterizedHelicalProfile.lean` | the smoothed profile as a `HelicalProfile` |
| `Local/HorizontalSmoothedVelocity.lean` | `v_h` of `eq:smooth-local-velocity` and `‖v_h − V⁰‖₄ ≤ Ch^{1/4}` |
| `Local/HorizontalFormDelta.lean`, `Local/HorizontalFormPerturbation.lean`, `Local/HorizontalFormSmallness.lean` | `eq:form-small`, `z`-free |
| `Local/HorizontalFormNeumann.lean`, `Local/HorizontalDeltaResolvent.lean`, `Local/HorizontalRieszPerturbation.lean` | the Neumann series and `‖P_{h,δ} − P⁰‖ < 1/4` |
| `Local/HorizontalSeedWitness.lean` | `f_*`, `L_*` with `Re⟨P⁰f_*, f_*⟩ > 3/4` |
| `Local/HorizontalFormStrongIdentification.lean`, `Local/HorizontalSeedResolventH2.lean`, `Local/HorizontalSeedUniformResolvent.lean` | form operator = strong operator on `H²`; the uniform `L² → H²` bound, from which the paper's `L² → H¹` bound `eq:local-continuation-bound` follows |
| `Local/LocalSeedC2.lean`, `Local/LocalSeedC2Concrete.lean` | the record and its inhabitant at `k_* = 1`, `g_* ≥ (3/4)(448 − 4π²)` |
| `Local/ParameterizedRadialSmoothing.lean` | the radial cut-offs `χ_h` (widths `PonomarenkoSmoothingWidth`), the smoothed helical profile and its velocity coefficients, the smoothing annulus |
| `Local/HelicalProfile.lean` | the record `HelicalProfile` of a whole-plane helical velocity, its weak-gradient certificate and support |

The whole-plane substrate, `Analysis/` and `Operator/`:

| module | content |
|---|---|
| `Analysis/WholePlaneFourier.lean` | whole-plane `L²`, Plancherel, physical momentum |
| `Analysis/WholePlaneSobolev.lean` | Fourier models of the whole-plane Sobolev spaces of every real order |
| `Analysis/WholePlaneH2.lean` | the weak `H¹` and `H²` graph spaces on the plane |
| `Analysis/WholePlaneH2DenseEmbedding.lean` | density of the weak `H²` graph in `L²` |
| `Analysis/WholePlaneH1Core.lean` | Bessel realisation and Schwartz core of weak `H¹` |
| `Analysis/WholePlaneH1Translation.lean` | Fourier tails of weak `H¹` fields |
| `Analysis/WholePlaneH1AntiDual.lean` | ambient `H¹` anti-duals as tempered distributions |
| `Analysis/WholePlaneScaling.lean` | the affine rescaling of whole-plane `L²` (the unitary `U_n`) |
| `Analysis/WholePlaneCoefficientScaling.lean` | affine rescaling of test functions, tempered distributions and `H²` on the plane |
| `Analysis/WholePlaneCoefficientScalingCoordinateCompatibility.lean` | coordinate compatibility of the coefficient pullback |
| `Analysis/WholePlaneLInfTempered.lean` | `L∞` coefficients as tempered distributions (`wholePlaneLInfToTempered`) |
| `Analysis/WholePlaneCoordinateH1.lean` | coordinates of weak `H¹` fields, `L^∞` weak gradients and their `W^{1,∞}` certificates |
| `Analysis/WholePlaneScalarLeibniz.lean` | the scalar weak Leibniz rule |
| `Analysis/WholePlaneScalarH2Leibniz.lean` | the scalar weak Leibniz rule on `H²` |
| `Analysis/WholePlaneSliceProductRule.lean` | the product rule along coordinate slices |
| `Analysis/WholePlaneIntegralWeakDerivative.lean` | gluing complementary weak-derivative pieces in `H¹` |
| `Analysis/WholePlanePiecewiseSliceIBP.lean` | integration by parts along slices with countably many exceptional points |
| `Analysis/WholePlaneRadialExponential.lean` | radial exponential envelopes |
| `Analysis/WholePlaneExteriorCutoff.lean` | exterior cut-offs on `L²` |
| `Analysis/WholePlaneLocalCompactness.lean` | compactness of local perturbations from scalar Rellich inputs |
| `Analysis/WholePlaneLocalCompactnessUnconditional.lean` | compactness for compactly supported local coefficients |
| `Analysis/WholePlaneBandLimitedCompactness.lean` | band-limited approximations for the local Rellich theorem |
| `Analysis/WholePlaneBandLimitedRellich.lean` | local Rellich from band-limited cores |
| `Analysis/WholePlaneBandLimitedRellichUnconditional.lean` | the scalar local Rellich theorem on the plane |
| `Analysis/WholePlaneH1L4Embedding.lean`, `Analysis/WholePlaneL4FormPerturbationHolder.lean` | the embedding `H¹(ℝ²) ↪ L⁴(ℝ²)`, the space `WholePlaneC3L4` and the Hölder triple `(4,4,2)` for the `L⁴` coefficient perturbations of the local form |
| `Analysis/WholePlaneUnitCircleSurface.lean` | the unit-circle surface term (`unitCircleSurfaceValue`) |
| `Analysis/WholePlaneUnitCircleSlices.lean` | coordinate slices of the unit circle |
| `Analysis/WholePlaneUnitCircleWeightedSlices.lean` | weighted coordinate charts on the unit circle |
| `Analysis/WholePlaneUnitDiskFibreBranches.lean` | one-sided `C¹` branches and fibre-generic unit-disc sources |
| `Analysis/WholePlaneUnitDiskFibreDerivativeSource.lean` | fibre-generic unit-disc derivative sources |
| `Analysis/WholePlaneTwoJumpIntegrationByParts.lean`, `Analysis/WholePlaneUnitDiskSliceGeometry.lean` | the unit-disc case of two-jump slice integration by parts |
| `Operator/WholePlaneLocalC2.lean` | `𝓛_δ` of `eq:local-generator` and the selected whole-plane operator `eq:selected-whole-plane-operator` |
| `Operator/WholePlaneLocal.lean` | the whole-plane local induction operators on `ℂ³`-valued fields |
| `Operator/WholePlanePivotAntiDual.lean` | the form pivot of the `H¹` anti-dual as a tempered distribution |
| `Analysis/FourierMultiplierSub.lean` | differences of Fourier multipliers (`fourierMultiplierCLM_sub`) |
| `Analysis/WholePlaneCoordinateDistributions.lean` | coordinates of `ℂ³`-valued tempered distributions, `wholePlaneCoordTempered`, and their compatibility with line derivatives and the `L²` embedding |
| `Analysis/WholePlaneBesselWeight.lean` | the order-one Bessel-potential weight `wholePlaneBesselOneWeight` |
| `Global/ConstantCoefficientWeakForm.lean` | the constant-coefficient weak form `constantCoefficientWeakForm` |
| `Global/WholePlaneW1InfCertificates.lean` | `W^{1,∞}` certificates of bounded `C¹` functions on the plane |
| `Global/ConstantCoefficientBackgroundResolvent.lean` | the weak resolvent equation of the constant-coefficient operator |
| `Global/WholePlaneEllipticRegularity.lean` | tempered Laplacian identities for weak solutions of the constant-coefficient equation, and `H²` regularity of `L²` solutions of `Δu = f` (`exists_wholePlaneH2_of_laplacian_eq_l2`) |

## §3 — the velocity field on `T³` (`lem:global-velocity`)

| module | content |
|---|---|
| `Global/ScaleSelection.lean` | `ScaleRatios` (`1 < q < √(δ₊/δ₋)`), `ScaleFamily` (`K_n`, `ℓ_n`, `R_n`, `a_n`, the intervals `𝓘_n`, `ε₀`), `rounding_bound` (`q + K₀⁻¹ < √(δ₊/δ₋)`), `adjacent_ratio_bounds` (`eq:ratio-choice`), `adjacent_ratio_sq_lt` (overlap of consecutive intervals), `rounding_bound_of_le` (enlarging `K₀` preserves the bounds) |
| `Global/CellGeometry.lean` | the arithmetic of the cells: `ℓ_n`, `R_n = √ℓ_n`, the axial amplitudes `a_n` with `2πK_n a_n = τ` |
| `Global/TorusChartEmbedding.lean` | the Euclidean placement chart inside `T²` |
| `Global/TorusCellPlacement.lean` | `TorusCellPlacement`: chart packing, support fit; `restrictSupportRadius` reads a placement at a smaller support radius with the same scale family |
| `Global/TorusIocFundamentalBox.lean`, `Global/TransverseFundamentalBox.lean` | the half-open fundamental square `(0,1]²` and its measure |
| `Global/TorusHelicalSource.lean` | `u_n^loc`, the rescaled helical copies of `eq:local-copy` |
| `Global/TorusAxialVelocityChartFields.lean` | `u_n^ax = a_n ϑ(\|y − p_n\|/R_n) e₃` of `eq:axial-offset` on the chart |
| `Global/TorusAxialVelocityConcrete.lean`, `Global/TorusAxialPlateauRadial.lean` | descent of the axial velocity to `T²`; the radial taper |
| `Global/TorusAxialVelocityWeakTransfer.lean` | the weak derivatives of the axial fields after descent |
| `Global/TorusChartWeakTransfer.lean`, `Global/TorusChartFourierWeakTransfer.lean` | transfer of placed Euclidean sources to `T²`, with their Fourier weak derivatives |
| `Global/CellSeriesSummability.lean` | summability of the series of placed cell fields, from the amplitude and gradient scales |
| `Global/TorusVelocityConcrete.lean` | the helical part of `u` on `T²` |
| `Global/TorusFullVelocityConcrete.lean` | `u` of `eq:global-u` as `parameterizedFullGlobalW1Inf` |
| `Global/TorusGlobalVelocityLipschitz.lean` | the global Lipschitz bound and the periodised representative |
| `Global/TorusGlobalVelocityDerivativeBridge.lean` | the stored `W^{1,∞}` derivatives of `u` are its classical derivatives at every point of the plane, not only almost everywhere |
| `Global/TorusGlobalVelocityRegularity.lean`, `Global/TorusGlobalVelocityQualitative.lean` | differentiable everywhere, smooth off the accumulation point, `Du = 0` there, not `C¹` (along the cell centres, where `Du` is the rotation generator of angular speed `Ω`, as in §3.4), non-zero |
| `Global/PairChartRotation.lean` | rigid rotations `R_α` of the chart plane (also used in §4) |

`R_v` of the paper is `GlobalSeedInterface.placementRadius = max (1+h) L_*` in
`Global/GlobalParameterChoice.lean`, so that `R_v ≥ L_*` is the theorem
`witnessSupportRadius_le_placementRadius`; the parameter record carries the placement at that
radius as the field `jointPlacement`, `placement` is the derived reading at `1+h` used by the
velocity constructors, and `witnessSupport` (`L_* ℓ_n < R_n/5`) is a theorem rather than a
field.  Lean proves `u ∈ W^{1,∞}` by a Fourier dominated limit for the helical part and an
absolutely summable `L∞` series for the axial part, not by the paper's "the weak derivative of a
Lipschitz function agrees a.e. with its classical derivative"; the global Lipschitz bound and the
pointwise vanishing of the classical divergence are proved as the paper proves them.

## §4 — particle dynamics and the ideal induction group

`Dynamics/ParticleFlow.lean` is the statement layer (`IsLiteralTorusLift`, `IsParticleFlow`,
`HasZeroTopologicalEntropy`, `IsIdealInductionGroup`, `MainLagrangianClauses`, the two
vanishing-rate predicates, and `MainTheoremDynamicalClauses`, which is literally the two
dynamical clauses of `thm:main` and a projection of `MainLagrangianClauses`).
`IsIdealInductionGroup` has the fields of the Cauchy group (`particleFlow`, `hasFDerivAt`,
`measurePreserving`, `group_zero`, `group_add`, `strongly_continuous`, `cauchy`) and the two
fields `solutionGroup` (every orbit is a weak solution of the ideal induction equation,
`IsIdealSolutionGroup`) and `unique` (no other group of operators on `L²_σ` has this property).
Two towers prove it.

The flow, `Dynamics/Flow/` and the analysis it needs, bottom up:

| module | content |
|---|---|
| `Analysis/LiteralThreeTorus.lean` | the literal `Torus 3`, `literalVelocity`, the transport `toLiteralC3L2` from the product model, the complexification `complexifyLiteralR3L2` on `Torus 3` and its compatibility with the transport |
| `Analysis/LiteralTorusRepresentative.lean` | the measurable `(0,1]³` section of `ℝ³ → T³` |
| `Dynamics/Flow/RadialShear.lean` | `sup_s s·\|χ_h'(s)\|` and the axial profile bound — the two shear constants |
| `Dynamics/Flow/CellProfiles.lean` | `ω_n(r) = Ω χ_h(r/ℓ_n)`, `g_n(r) = ℓ_n U χ_h(r/ℓ_n) + a_n ϑ(r/R_n)` of `eq:particle-cell-profiles` and their gradients |
| `Dynamics/Flow/CellFlowMap.lean` | the single-cell flow `(y,x₃) ↦ (p_n + R_{tω_n(r)}(y−p_n), x₃ + t g_n(r))`, invariance of the buffer disc, `det = 1`, `‖DΦ‖` |
| `Dynamics/Flow/PlaneFlow.lean`, `Dynamics/Flow/PlaneFlowRegularity.lean` | the sum over the accumulating cells (`eq:explicit-particle-flow`), the single-cell reduction, the group law, the axial cocycle, differentiability, the `ℤ²`-periodisation |
| `Dynamics/Flow/PlaneFlowLipschitz.lean` | `flowLipschitzSlope`, `flowLipschitzBound t = 2(1 + \|t\|·slope)`, `flowCL = 4(1 + slope)` |
| `Dynamics/Flow/PeriodizedFlowData.lean` | the periodised plane-flow datum and the torus maps it generates (used for the flow and its truncations) |
| `Dynamics/Flow/PeriodizedFlowSymbol.lean` | the derivative flow, the symbol and the Cauchy transport of such a datum |
| `Analysis/LogLinearGrowth.lean` | `t⁻¹ log(C(1+t)) → 0` |
| `Dynamics/Flow/LipschitzRate.lean` | `lipConst` (the optimal constant as an `sInf`) and `lim_{\|t\|→∞} \|t\|⁻¹ log lipConst(Φ_t) = 0` along `Filter.cocompact ℝ` |
| `Dynamics/Flow/TorusFlow.lean` | the descent to `Torus 3`: `literalFlow`, `literalFlowLift`, group and iterate laws, `LipschitzWith` |
| `Analysis/TorusNet.lean`, `Analysis/EntropyCriterion.lean` | the `N³`-point `1/(2N)`-net of `T³` and `coverEntropy_eq_zero_of_lipschitz_iterate` |
| `Dynamics/Flow/Entropy.lean` | `coverEntropy_literalFlow_eq_zero` |
| `Dynamics/Flow/FlowDerivative.lean` | `flowFDeriv`, its complexification and the bound `24(1 + \|t\|·slope)` |
| `Dynamics/Flow/VariationalEquation.lean` | `eq:flow-variational-equation`: `DΦ_t(a) = Id + ∫₀ᵗ (∇u)(Φ_s(a)) DΦ_s(a) ds` at every point and every time (`hasFDerivAt_literalFlowLift`, `flowDeriv_apply_eq_add_integral`) |
| `Analysis/PlaneJacobian.lean` | measure preservation on the plane from a unit Jacobian |
| `Dynamics/Flow/MeasurePreserving.lean` | measure preservation of `Φ_t` (`measurePreserving_literalFlow`), read off the generic datum |
| `Dynamics/Flow/ParticleFlowProof.lean` | the ODE, `isParticleFlow_literalFlow` |
| `Dynamics/Flow/ParticleFlowUniqueness.lean` | `IsParticleFlow.unique` (Grönwall), `existsUnique_isParticleFlow_mainLiteralVelocity` |

The ideal induction group, `Dynamics/Ideal/` and the analysis it needs:

| module | content |
|---|---|
| `Analysis/LiteralThreeTorusGradient.lean`, `Dynamics/Ideal/GradientOrthogonality.lean` | `torusGradient`, integration by parts against the characters, `inner_gradient_eq_zero_of_mem_literalSolenoidalSubspace` |
| `Analysis/LpCompMeasurePreserving.lean` | composition with a measure-preserving map as a continuous linear map on `Lᵖ` |
| `Analysis/R3Assembly.lean`, `Analysis/R3BlockComplexify.lean` | maps into `ℝ³` from coordinates; block matrices and their complexification |
| `Dynamics/Ideal/CauchyOperator.lean` | `idealTransport t` on `L²(T³;ℂ³)` from the Cauchy formula `eq:ideal-cauchy-formula`, group law, norm bounds |
| `Dynamics/Ideal/TruncatedPlaneFlow.lean`, `Dynamics/Ideal/TruncatedFlow.lean`, `Dynamics/Ideal/TruncatedTransport.lean`, `Dynamics/Ideal/TruncatedConvergence.lean` | the flows truncated to finitely many cells (with `C^∞` lifts), their transport, and `𝒯₀^{(N)}(t)B → 𝒯₀(t)B` in `L²` |
| `Dynamics/Ideal/SolenoidalInvariance.lean` | invariance of `L²_σ(T³)` and the corestriction `idealGroup` |
| `Dynamics/Ideal/StrongContinuity.lean` | `t ↦ 𝒯₀(t)B` is continuous |
| `Dynamics/IdealWeakForm.lean` | the weak form of the ideal induction equation on `Torus 3`: `literalFDeriv`, `literalAdvection`, `literalStretch`, `IsIdealTestField`, `IsIdealWeakSolution`, `IsIdealSolutionGroup` |
| `Dynamics/Ideal/VelocityGradient.lean` | `∇u` of the constructed velocity on `Torus 3`: the stretching operator `literalStretchL2`, `∇u` as the Fréchet derivative of the lift at every point, `div u = 0` pointwise, continuity of `∇u` along trajectories |
| `Dynamics/Ideal/WeakSolution.lean` | the Cauchy formula `eq:ideal-cauchy-formula` solves the ideal induction equation in the weak form, for every datum in `L²(T³; ℂ³)` |
| `Dynamics/Ideal/LipschitzTestFields.lean` | the weak identity extends from smooth test fields to Lipschitz, everywhere differentiable ones (Fourier partial sums); density of the smooth test fields in `L²` |
| `Dynamics/Ideal/WeakSolutionUniqueness.lean` | weak solutions of the ideal induction equation in `C([−T, T]; L²)` are unique (`IsIdealWeakSolution.eq_zero`, pull-back along the flow and Grönwall), hence every solution group is `idealGroup` |
| `Dynamics/IdealWeakFormRescaling.lean` | weak solutions and solution groups of `v` give those of `c v` under `t ↦ c t` |
| `Dynamics/Ideal/IdealGroup.lean` | `isIdealInductionGroup_idealGroup`, the two-sided bounds and the per-datum rate at `dynamicalCL = 24(1 + slope)` |

`Dynamics/MainLagrangianClauses.lean` (§1 table) assembles both towers at the constructed
velocity: `mainLagrangianClauses_literalVelocity`, then the endpoints listed there, among them
`existsUnique_isIdealSolutionGroup_mainLiteralVelocity`: the group witness is the unique
solution group of the ideal induction equation of `mainLiteralVelocity`.

The normalisation of Remark 1.6 acts on the dynamical clauses by time rescaling:
`Dynamics/NormalizedLagrangianClauses.lean` proves that `t ↦ Φ_{ct}` is the particle flow of
`c v` and `t ↦ 𝒯₀(ct)` the ideal induction group of `c v` (`IsParticleFlow.timeRescale`,
`IsIdealInductionGroup.timeRescale`), carries `MainTheoremDynamicalClauses` and
`MainLagrangianClauses` along `v ↦ c v`, and reads this at `normalizedLiteralVelocity`.

## §5 — the horizontal operator on `T²` and the scaling identity

| module | content |
|---|---|
| `Fourier/PeriodicH2.lean` | the fibre-generic transverse Sobolev layer; `TransverseC2L2/H2` |
| `Fourier/PeriodicH2AxialSector.lean` | the fixed axial sector of periodic `H²` |
| `Operator/FixedSector.lean` | the reduced operator `A^{(3)}_{ε,K}` on one axial Fourier sector |
| `Operator/HorizontalProjection.lean` | the pointwise projection `ℂ³ → ℂ²` and its isometric right inverse |
| `Operator/HorizontalSector.lean` | `horizontalInductionOperator u ε K` = `eq:torus-sector`; the intertwining `π⊥ ∘ A₃ = A₂ ∘ π⊥` |
| `Operator/HorizontalSectorBasic.lean` | `lem:torus-sector-basic` for an arbitrary `u ∈ W^{1,∞}(T²;ℝ³)`, with no `div⊥ u⊥ = 0` hypothesis; resolvent point by a Neumann series, index zero from a compact base point |
| `Reduction/ExactScalingC2.lean` | `lem:exact-renormalization`: `U_n⁻¹ A^{(n)} U_n = 𝓛_{δ_n} − iτ` (`eq:scaling`) |
| `Reduction/ExactScalingParameters.lean` | the scaling record `WholePlaneExactScalingParameters`, the rescaled velocity coefficients and the scaling arithmetic |

## §6 — the background resolvent (`prop:background-resolvent`)

| module | content |
|---|---|
| `Global/BackgroundMultiplierScalarAlgebra.lean` | `F(s) = (s−1)/(1+s)²`, `\|F\| ≤ 1`, `\|sF(s)\| ≤ 1`, `\|F'\| ≤ 3`, the phase inequality `eq:background-phase-positive`, `c_q`, `τ₀` |
| `Analysis/TransverseWeightedDiffusion.lean` | the weighted diffusion integration by parts and the defect majorant |
| `Analysis/TransverseWeightedLeibniz.lean` | the weighted test field `(1 + iβ)h`, the remaining terms of `eq:background-testing`, the Young absorption |
| `Global/TorusBackgroundVelocity.lean` | `u^bg_n = u − u^loc_n` of `eq:background-velocity` and `A^bg_{ε,n}` of `eq:background-operator` |
| `Global/TorusBackgroundMultiplierCell.lean`, `Global/TorusBackgroundMultiplier.lean` | `s_n`, `β_n = F(s_n)` of `eq:background-multiplier` as a placed disjoint-support series, `eq:background-multiplier-bounds` |
| `Global/TorusBackgroundWeightedEnergy.lean` | `eq:background-coercivity` |
| `Global/TorusBackgroundParameters.lean` | `τ`, `Γ_τ = backgroundShiftedContour`, `BackgroundParameters`, the phase and transport bounds |
| `Global/TorusBackgroundResolvent.lean` | `𝒢_τ ⊂ ρ(A^bg)`: coercivity for injectivity, `lem:torus-sector-basic` for index zero, hence surjectivity, as in the paper; `eq:bg-resolvent` with `C = √2/g + 2/√g` at `g = g_*/2` |
| `Global/TorusBackgroundResolventHolomorphic.lean` | a clause that `prop:background-resolvent` does not state: the background resolvent is holomorphic on a neighbourhood of `𝒢_τ`, namely the intrinsic resolvent set (`BackgroundParameters.exists_isOpen_hasResolventOn_analyticOnNhd`) |
| `Global/WholePlaneScaledLocalResolvent.lean` | `cor:scaled-local-resolvents` |
| `Global/HorizontalTransportSkewness.lean` | `Re⟨w·∇⊥h, h⟩ = 0` on the `ℂ²` fibre |

## §7 — the parametrix and the transfer (`prop:global-spectral-transfer`)

| module | content |
|---|---|
| `Global/GlobalParameterChoice.lean` | `GlobalSeedInterface`, `GlobalParameterChoice`, the single `K₀` threshold; `exists_globalParameterChoice` |
| `Global/GlobalParameterChoiceConcrete.lean` | the constants `C_app`, `η_*`, the chosen chain `mainParameterChoice` |
| `Global/ParametrixCutoffs.lean`, `Global/ParametrixExplicitCutoffDerivatives.lean`, `Global/TorusSchwartzPeriodicCutoff.lean`, `Global/HorizontalCutoffMultiplier.lean`, `Global/TorusPlacedCutoffC2.lean`, `Global/TorusCellPlacedCutoffs.lean` | the input cut-off `φ_n` and the output cut-offs `ψ_n`, `χ_n`, their bounds `eq:parametrix-cutoff-bounds` and identities `eq:parametrix-cutoff-identities`; the paper's display bounds only `D^jψ_n` and `D^jχ_n`, and only those bounds are consumed |
| `Global/TransverseCoefficientMultipliers.lean` | supported periodic coefficient multipliers |
| `Global/HorizontalCutoffCommutator.lean` | `[A, χ]h = ε(2∇⊥χ·∇⊥h + (Δ⊥χ)h)`; the axial and stretching terms commute exactly |
| `Global/TorusChartL2Operators.lean` | bounded `L²` extension and restriction maps of the chart |
| `Global/TorusChartH2Transfer.lean` | `H²` transfer through the chart, input side and compactly supported |
| `Global/TorusSupportedH2Output.lean` | the supported output localisation on the periodic `H²` chart |
| `Global/WholePlaneHorizontalFibre.lean` | fibre transfer on the plane and the plane-side quotient identity |
| `Global/TorusChartC2Transfer.lean` | the chart transports `restrictInputC2` / `extendStateC2` / `extendDomainC2` |
| `Global/TorusChartC2AuxiliaryCutoff.lean` | the auxiliary output cut-off `ψ̃_n` and locality of the commutator |
| `Global/TorusChartC2TransportedField.lean`, `Global/TorusChartC2TransportedBounds.lean` | the transported field and its norm bounds |
| `Global/TorusChartProjectionTransport.lean`, `Global/TorusChartCutoffSupport.lean` | the commutation of the horizontal projection with the output chart transport; the support of the output cut-off jet in `D̄(p, R/2)` |
| `Global/TorusChartActionBridge.lean` | the torus and whole-plane actions agree on `supp ψ_n` |
| `Global/TorusCellSeedCoefficientBridge.lean`, `Global/TorusCellAxialPlateauBridge.lean` | the global velocity on a placed cell is the rescaled seed plus the constant axial shift |
| `Global/TorusPlacedCutoffVelocity.lean` | the velocity hypotheses of `lem:parametrix-error` at a placed cell |
| `Global/TorusTwoSummandParametrix.lean` | `R_app` of `eq:Rapp`, the right-error identity |
| `Global/TorusSelectedLocalResolventData.lean` | the selected summand of `eq:Rapp` |
| `Global/TorusBackgroundParametrixBridge.lean` | the background resolvent of §6 as the background summand |
| `Global/TorusParametrixError.lean` | `lem:parametrix-error` and `lem:global-contour-resolvent` |
| `Global/TorusSelectedWitness.lean` | `f_n = U_n f_*`, `‖f_n‖ = 1`, `φ_n f_n = ψ_n f_n = f_n`; the support fit is `GlobalParameterChoice.witnessSupport` |
| `Global/TorusSelectedContourIdentity.lean` | `eq:selected-contour-identity` |
| `Global/TorusGlobalRieszNonzero.lean` | `eq:global-projection-error`, `Re⟨Q f_n, f_n⟩ > 1/4`, `lem:global-riesz-nonzero` |
| `Global/SpectralCircleGrowthFloor.lean` | `growthFloor_le_re_of_mem_ball`: points of the disc bounded by a contour have real part at least its growth floor |
| `Global/HorizontalSpectralExtraction.lean` | the same for the horizontal operator: eigenpair with `Re λ ≥ g_*` |
| `Global/TorusGlobalSpectralTransfer.lean`, `Global/GlobalSpectralTransferConcrete.lean`, `Global/GlobalSpectralTransferAllCells.lean` | `prop:global-spectral-transfer` at one cell, at the chosen chain, and at every admissible index |
| `Global/TorusSelectedCellVelocityFacts.lean`, `Global/TorusSelectedCellChartAgreement.lean`, `Global/TorusSelectedCellParametrixData.lean` | the velocity hypotheses of the transfer, discharged at the constructed velocity |
| `Global/FrequencyRatioDichotomy.lean` | the frequency ratios `K_n/K_m` and the dichotomy `≥ q` or `≤ q⁻¹` (`nonselected_frequencyRatio_dichotomy`) |
| `Global/DomainOperatorNumericalRange.lean` | the numerical range of an operator, injectivity of a pencil from an ambient lower bound, and singleton resolvents with a state-norm bound |
| `Global/ReducedInductionEnergyIdentity.lean` | the gradient energy of the reduced operator and the real parts of its diffusion, transport and stretching terms |
| `Global/TorusLocalCoreMeasurability.lean` | membership and measurability of the local-core discs on the torus |
| `Global/PeriodicSecondOrderCutoffs.lean` | `PeriodicSecondOrderCutoff`: periodic cut-offs with bounded first and second derivatives |
| `Global/LocalizedSummandAlgebra.lean` | the localised summands of a parametrix, their commutators with the operator and their errors (`CompatibleCutoff`, `localSummand`, `localError`) |
| `Global/ParametrixNeumannCorrection.lean` | the right error of a parametrix, its Neumann correction, a resolvent from a right parametrix and Fredholm index zero (`hasResolventOnOfRightParametrixIndexZero`), and the contour operator |
| `Global/CorrectedRieszProjectionSpectralCalculus.lean`, `Global/CorrectedRieszProjectionEigenmode.lean` | an eigenpair in a disc from a non-zero Riesz projection with finite-dimensional invariant range |
| `Global/MatchingCellScalingParameters.lean` | the scaling parameters `exactScalingParameters` of the matching cell |
| `Global/TorusChartMultiplierDescent.lean` | multiplication operators and the diffusion term through the chart of a cell |
| `Global/WholePlaneCutoffCommutator.lean` | the whole-plane local action against a cut-off (`wholePlaneLocalAction_cutoffCommutator_apply`) |
| `Global/WholePlaneAESupport.lean` | `IsAEL2SupportedIn`: almost-everywhere support of `L²` fields |

## §8 — the finish

| module | content |
|---|---|
| `Finish/AxialRecoveryDivergence.lean`, `Finish/AxialRecoveryRegularity.lean`, `Finish/AxialRecovery.lean` | `lem:axial-recovery`: `b₃ = −div⊥h/(2πiK)`, the `H²` upgrade, `Div V = 0` by construction — a scalar route; the paper forms `F = λV − εΔV − curl(u×V) ∈ H⁻¹`, one derivative below the `H⁻²` realisation of the curl form in Lean |
| `Operator/Product.lean` | the auxiliary all-frequency operator on the product torus |
| `Operator/Compatibility.lean` | the curl-form operator `L_{ε,u}` into `H⁻²` and its agreement with the auxiliary one on divergence-free fields |
| `Analysis/InductionDivergence.lean` | `Div[−(u·∇)B + (B·∇)u] = −u·∇ Div B` (for the solenoidality lemma) |
| `Fourier/AxialL2.lean` | `lem:real-axial-mode` |
| `Finish/RealSolution.lean`, `Operator/Evolution.lean`, `Analysis/Realification.lean`, `Operator/RealCompatibility.lean` | `RealStrongModeCertificate`: the real datum, the norm law `eq:main-thm-growth`, the strong solution |
| `Finish/GrowingModeEvolution.lean` | the norm of an eigentrajectory (`norm_embedding_eigenTrajectory`) |
| `Finish/MagneticScaleMain.lean` | `cor:magnetic-scale` at the witnesses of `thm:main`: `main_theorem_magnetic_scale` gives `c, C > 0` with `c ε^{-1/2} ≤ \|K\| ≤ C ε^{-1/2}` and `c √ε ≤ L_B ≤ C √ε` for an eigenpair carrying the clauses of `thm:main` at every `0 < ε ≤ mainEps0`, for the complex mode and for its real part |
| `Finish/ZeroMean.lean` | Remark 1.5 (`rem:scope-intro`): the constructed magnetic fields (the mode, its real part, the real solution) have zero spatial mean, `HasZeroMean` |
| `Finish/RealPartNotEigenmode.lean` | Remark 1.4 (the unlabelled remark after `rem:subsequent-resolution`): if `Im λ ≠ 0` the real part of the complex mode is not an eigenmode of the physical induction operator (`not_isEigenpair_productRealPartH2`) |
| `Finish/MagneticScale.lean` | the general bounds behind `cor:magnetic-scale`: the index bounds of a matching cell, `L_B ≤ 1/(2π\|K\|)`, `√(ε/M_u) ≤ L_B` for an eigenpair of the reduced operator, equality of the magnetic lengths of an axial mode and of its real part, whose gradient is the weak gradient of the real field (`complexifyProductR3L2_phaseAxialGradientL2`) |
| `Finish/NegativeDiffusivity.lean` | sharpness of `0 ≤ ε` in the solenoidality lemma |

## Appendix A — the semigroup and the growth rate (`lem:semigroup-spectral-growth`)

| module | content |
|---|---|
| `Dynamics/StronglyContinuousSemigroup.lean` | strongly continuous semigroups and eigenmode growth |
| `Dynamics/GrowthBound.lean` | the growth bound and the growth floor of strong solutions |
| `Dynamics/GrowthBoundLimit.lean` | Fekete: for every `C₀`-semigroup on a Banach space, `t⁻¹ log ‖S t‖` (`growthExponent`) tends to `growthBound S = inf_{t>0} t⁻¹ log ‖S t‖` (`tendsto_growthExponent`, `growthBound_eq_iInf`); `growthBound_ne_bot_iff`, `exists_growthBound_eq_and_tendsto` |
| `Dynamics/SemigroupRestriction.lean` | restriction, isometric transport and monotonicity of the growth bound |
| `Dynamics/SemigroupTimeRescaling.lean` | the semigroup `t ↦ S(c t)`, its growth bound `c · growthBound S`, and the realisation of `c A` (for Remark 1.6) |
| `Dynamics/SemigroupGenerator.lean` | the generator of a `C₀`-semigroup as a `LinearPMap` (Engel–Nagel II.1): domain invariance, differentiability of orbits, density of the domain, `ext_of_generator_eq` (a semigroup is determined by its generator), generator of a restriction to a closed invariant subspace |
| `Operator/StrongHolomorphy.lean` | strong holomorphy plus local boundedness gives holomorphy in operator norm (`differentiableOn_of_forall_apply`) |
| `Dynamics/AnalyticSemigroup.lean` | `IsAnalyticSemigroup S δ` (holomorphic extension to the sector `Σ_δ`), restriction of analytic semigroups to closed invariant subspaces |
| `Dynamics/AnalyticSemigroupGenerator.lean` | `S(t)` maps into `D(G)` with `G S(t)` bounded; with a compact resolvent, `S(t)` is compact for `t > 0` (`IsAnalyticSemigroup.isCompactOperator`) |
| `Operator/UnboundedResolvent.lean` | resolvent set and spectrum of a partially defined operator, the notion of the paper's Appendix A; with one compact resolvent every point of the spectrum is an eigenvalue |
| `Dynamics/SemigroupSpectralMapping.lean` | for an analytic semigroup with compact resolvent: `σ(S(t)) \ {0} = exp(t σ(G))` (`IsAnalyticSemigroup.spectrum_diff_zero`) and `growthBound = sup Re σ(G)`, attained at an eigenvalue (`IsAnalyticSemigroup.growthBound_eq_iSup`) |
| `Dynamics/HilleYosida/OperatorExp.lean` | exponentials of bounded operators |
| `Dynamics/HilleYosida/ResolventRay.lean` | the real resolvent ray of a Hille–Yosida generator |
| `Dynamics/HilleYosida/YosidaApproximant.lean` | the Yosida approximants |
| `Dynamics/HilleYosida/ApproximantSemigroup.lean` | their semigroups |
| `Dynamics/HilleYosida/Convergence.lean` | the limit semigroup |
| `Dynamics/HilleYosida/Semigroup.lean` | the limit as a bundled strongly continuous semigroup |
| `Dynamics/HilleYosida/Realization.lean` | the generated semigroup realises the domain operator |
| `Dynamics/HilleYosida/Generation.lean` | the generation theorem, uniqueness, and `Re λ ≤` growth bound for eigenpairs |
| `Dynamics/HilleYosida/Invariance.lean` | invariant closed subspaces |
| `Dynamics/HilleYosida/GeneratorIdentification.lean` | the generator of the Hille–Yosida semigroup is `A` (`HilleYosidaRay.generator_semigroup`) |
| `Dynamics/HilleYosida/AnalyticGeneration.lean` | a Hille–Yosida generator whose numerical range lies in a shifted quarter sector generates a semigroup analytic of angle `π/4` (`HilleYosidaRay.isAnalyticSemigroup_of_sectorial`) |
| `Global/ReducedInductionAdjoint.lean`, `Global/ReducedInductionHalfPlaneResolvent.lean` | dissipativity of `A_{ε,K}` and of its formal adjoint; the right half-plane resolvent |
| `Dynamics/StrongSolutionUniqueness.lean` | the energy bound and uniqueness of forward strong solutions |
| `Dynamics/ReducedInductionHilleYosidaRay.lean` | the Hille–Yosida ray `reducedInductionHilleYosidaRay` of the fixed-sector operator and its resolvent bound |
| `Dynamics/Assembly/AxialHilbertSum.lean`, `Dynamics/Assembly/AxialSectorDomain.lean` | the axial Hilbert-sum decomposition of product `L²` and of `H²` |
| `Dynamics/Assembly/UniformSectorResolvent.lean` | sector resolvent bounds uniform in the axial index |
| `Dynamics/Assembly/ProductResolvent.lean` | the all-frequency resolvent |
| `Dynamics/Assembly/ProductSemigroup.lean` | the all-frequency semigroup and its restriction to `L²_σ` |
| `Dynamics/Assembly/ProductInductionEnergy.lean` | energy estimates for `productInductionOperator` with the gradient term retained, the transport bound `‖(u·∇)B‖ ≤ c‖∇B‖`, and the sector condition `\|Im ⟨B, A B⟩\| ≤ ω‖B‖² − Re ⟨B, A B⟩` |
| `Operator/ProductH2Compact.lean` | Rellich on the product torus: the embedding `ProductC3H2 → ProductC3L2` is compact |
| `Dynamics/Assembly/SolenoidalSubspace.lean` | the closed, resolvent-invariant solenoidal subspace |
| `Dynamics/Assembly/SolenoidalGenerator.lean` | the generator of `solenoidalInductionSemigroup` is `L_{ε,u}` on `L²_σ` with domain `H² ∩ L²_σ` (`generator_solenoidalInductionSemigroup`), and the semigroup with this generator is unique |
| `Dynamics/Assembly/InductionMeanConservation.lean` | conservation of the spatial mean: `1 ≤ ‖e^{t L_{ε,u}}‖`, so `0 ≤ γ(u, ε)`, and `gamma_eq_lim` |
| `Dynamics/Assembly/InductionSemigroupSpectrum.lean` | analyticity (angle `π/4`), compact resolvent, immediate compactness and the spectrum of `solenoidalInductionSemigroup`: `spectrum_solenoidalInductionSemigroup_diff_zero`, `gamma_eq_iSup_re_spectrum`, `exists_eigenvalue_re_eq_gamma` |
| `Dynamics/Assembly/SemigroupSpectralGrowth.lean` | Lemma A.1 (`lem:semigroup-spectral-growth`) with the facts on `γ(u, ε)` of §1.1 as one statement: `SemigroupSpectralGrowth`, `semigroupSpectralGrowth_holds`, for every divergence-free velocity and every `ε > 0` |
| `Dynamics/Assembly/MainGrowthRate.lean` | `γ(u,ε)` of `eq:semigroup-growth-rate` (`gamma`), `γ ≥ γ₀`, `γ ≤ ‖∇⊥u‖_∞`, the `liminf` form |
| `Dynamics/Assembly/MainGrowthRateLimit.lean` | `gamma_tendsto`: `γ(u, ε)` is the limit of `t⁻¹ log ‖e^{t L_{ε,u}}‖` for every `(u, ε)`; `mainGrowthFloor_le_gamma_lim` at the constructed velocity |
| `Dynamics/Assembly/NormalizedGrowthRate.lean` | Remark 1.6: `L_{ε,ũ} = M⁻¹ L_{Mε,u}` and `γ(ũ, ε) = M⁻¹ γ(u, Mε)`, and the growth-rate clauses at the normalised velocity |
| `Dynamics/Assembly/NegativeSobolevResolvent.lean` | the resolvent of the induction operator at real `r > ‖∇u‖_∞` is bounded from `H⁻²` to `L²` (`exists_norm_stateResolvent_le_productL2ToHMinus2`) |
| `Dynamics/Assembly/PhysicalInductionUniqueness.lean` | forward strong solutions of the curl-form operator `productPhysicalInductionOperator u ε` are unique (`productPhysicalInductionOperator_forwardStrongSolutionsUnique`), and every one with divergence-free datum is a semigroup orbit and obeys the energy identity (`hasDerivAt_half_norm_sq_of_isForwardStrongSolution_physical`) |
| `Dynamics/Assembly/SemigroupOrbit.lean` | the orbit of the real datum under the semigroup on `L²_σ` is the curve `B^ε(t)` and obeys `eq:main-thm-growth`; every forward strong solution of the curl-form equation with that datum is this orbit; with the spectral clauses at the same triple (`MainSemigroupOrbitClauses`): "its solution" of `thm:main` |
| `Dynamics/EnergyIdentity.lean` | the energy identity `eq:energy-competition`: `Re ⟨B, A_{ε,u} B⟩ = Re ⟨B, (B·∇)u⟩ − ε‖∇B‖²` (`re_inner_productInductionAction_eq`) and `d/dt ½‖B(t)‖²` along strong solutions |
| `Dynamics/MainGrowthFloor.lean` | the growth floor of the reduced equation at the main witnesses |

## Remark 1.7 — the vanishing-diffusivity limit

Remark 1.7 (the last remark of §1.2) states that `e^{tL_{ε,u}} B_in → 𝒯₀(t) B_in` strongly in
`L²`, uniformly on bounded time intervals, as `ε ↓ 0`.  The paper derives it from the
Trotter–Kato theorem and the Friedrichs commutator lemma; the Lean proof is an energy estimate
for the difference of the resistive orbit and a mollified ideal orbit.

| module | content |
|---|---|
| `Analysis/LiteralTorusMollifier.lean` | translation on `L²(T³; ℂ³)`; the mollifier `J_δ` (`literalMollify`) and `∂_j J_δ` as averages of translates and Fourier multipliers, `‖J_δ‖ ≤ 1`, `J_δ f → f` (`tendsto_literalMollify`) |
| `Analysis/LiteralFriedrichsCommutator.lean` | the Friedrichs commutator `K_δ f = ∑_j (∂_j J_δ (v_j f) − v_j ∂_j J_δ f)`: `‖K_δ‖` is bounded uniformly in `δ` for Lipschitz `v` (`exists_norm_friedrichsCommutator_le`) and `K_δ f → 0` when `div v = 0` pointwise (`tendsto_friedrichsCommutator`) |
| `Dynamics/VanishingDiffusivity/ProductBridge.lean` | the mollifier between the product `H²` graph and the literal torus (`productMollifyH2`), the induction action on `J_δ f`, and the derivative of `t ↦ J_δ 𝒯₀(t)B` |
| `Dynamics/VanishingDiffusivity/Limit.lean` | `resistiveEvolution` and `tendstoUniformlyOn_resistiveEvolution_mainIdealGroup`: for every `B ∈ L²_σ(T³; ℂ³)` and `T`, `resistiveEvolution ε t B → mainIdealGroup t B` as `ε → 0⁺`, uniformly on `[0, T]`, at the constructed velocity |

## Theorem 1.2 in the form of the Challenge statement

`Challenge.lean` at the root of the repository states Theorem 1.2 with mathlib notions and fourteen
definitions of its own (namespace `FastDynamoChallenge`): Fourier coefficients are mathlib's
`mFourierCoeff` on `UnitAddTorus (Fin 3)`, `L²_σ` is the orthogonal complement `L2σ` of the
gradients of the characters, `H²` is a condition on Fourier weights (`MemH2`), the induction
operator is its Fourier symbol in divergence form (`inductionRHS`), and the semigroup, the ideal
solution group and the particle flow are given by the properties `IsInductionSemigroup`,
`IsIdealGroup` and `IsFlow`.  The modules of `Palomar/` identify these with the objects of the
library and prove the statement; `Solution.lean` proves the theorem of `Challenge.lean` by
`challenge_statement`.  The README section *The Challenge statement* lists how the statement
differs from Theorem 1.2 as printed.

| module | content |
|---|---|
| `Palomar/Statement.lean` | the fourteen definitions of `Challenge.lean`, character for character, in the namespace `FastDynamoChallenge`; `scripts/check-challenge-text.py` checks the identity |
| `Palomar/FourierDictionary.lean` | `mFourierCoeff` against `volume`, the library's coefficients in mathlib's form, Fourier injectivity (`l2_ext_mFourierCoeff`) and Parseval (`hasSum_norm_sq_l2`) on `L2`, the gradient characters, `mem_L2σ_iff` |
| `Palomar/Solenoidal.lean` | `L2σ_eq_literalSolenoidalSubspace`; the isometries `literalSolenoidalEquivL2σ`, `productSolenoidalEquivL2σ`; conjugation of operators `conjOp` |
| `Palomar/H2Dictionary.lean` | `MemH2` and the product `H²` graph: `memH2_iff_exists_productH2`, `memH2_toLiteralC3L2_iff` |
| `Palomar/InductionSymbol.lean` | the library's curl form in `H⁻²` read through `inductionRHS` (`productPhysicalInductionAction_apply`, `inductionRHS_eq_of_productL2ToHMinus2_eq`); the eigenmode of the library on `T3` (`mainLiteralEigenmode_clauses`); the generator of the semigroup in Fourier form |
| `Palomar/Velocity.lean` | `isDivergenceFree_mainLiteralVelocity`: the velocity is divergence free on Fourier coefficients |
| `Palomar/Flow.lean` | `exists_lipschitzWith_mainLiteralVelocity`; `isFlow_iff_isParticleFlow`; `exists_isFlow_mainLiteralVelocity`, `isFlow_mainLiteralVelocity_eq`, `forall_isFlow_mainLiteralVelocity_continuous_coverEntropy` |
| `Palomar/SemigroupEigenmode.lean` | for any velocity and any `S` with `IsInductionSemigroup u ε S`: the orbit of an eigenmode (`isInductionSemigroup_apply_eigenmode`), the growth bound (`forall_exp_mul_le_norm_of_eigenmode`), the real part of an eigenmode and its orbit (`exists_realPart_eigenmode`), combined in `eigenmode_clauses` |
| `Palomar/InductionSemigroup.lean` | `challengeInductionSemigroup`, the library's semigroup on `L2σ`; `isInductionSemigroup_mainLiteralVelocity`, `exists_isInductionSemigroup_mainLiteralVelocity` |
| `Palomar/Eigenmode.lean` | `exists_eigenmode_mainLiteralVelocity`: for `0 < ε ≤ mainEps0`, an eigenmode `(K, λ, V)` in the Challenge's terms |
| `Palomar/IdealSymbol.lean` | the advective right-hand side of the library's ideal equation equals `inductionRHS u 0` on `L²_σ` (`mFourierCoeff_literalStretchL2_sub_eq_inductionRHS`) |
| `Palomar/IdealGroup.lean` | `challengeIdealGroup`, the library's `mainIdealGroup` on `L2σ`; `isIdealGroup_challengeIdealGroup`, `tendsto_inv_mul_log_norm_challengeIdealGroup` |
| `Palomar/IdealUniqueness.lean` | the Challenge's integrated equation, tested with characters, gives the library's weak solutions (`isIdealWeakSolution_of_charTestField`); `isIdealGroup_eq_challengeIdealGroup`, `exists_unique_isIdealGroup_mainLiteralVelocity` |
| `Palomar/Main.lean` | `challenge_clauses_mainLiteralVelocity`, `challenge_statement_of_isIdealGroup`, and `challenge_statement`, the statement of `Challenge.lean` proved at `mainLiteralVelocity`, `mainEps0`, `mainGrowthFloor` |

## Generic layers

Analysis on the tori, `Analysis/` and `Fourier/`:

| module | content |
|---|---|
| `Analysis/TransverseChart.lean` | the quotient map `ℝ² → T²` |
| `Analysis/TorusHaarTransport.lean` | the volume and Haar measures of `UnitAddTorus` agree |
| `Analysis/PeriodicWeakDerivative.lean`, `Analysis/PeriodicWeakDerivativeTest.lean` | Fourier characterisation of periodic weak derivatives, and its test-function form |
| `Analysis/TransverseW1Inf.lean` | `TransverseRealW1Inf`, real periodic `W^{1,∞}` velocities on `T²` |
| `Analysis/WeakLeibniz.lean`, `Analysis/WeakLeibnizAxial.lean`, `Analysis/WeakLeibnizVelocity.lean` | weak Leibniz rules for bounded coefficients; `IsTransverseDivergenceFree` |
| `Analysis/Holder.lean` | Hölder multiplication `L∞ × L² → L²` on the periodic spaces |
| `Analysis/BoundedOperatorMultiplier.lean` | operator-valued `L∞` multipliers on `L²` |
| `Analysis/TransverseVecMultipliers.lean`, `Analysis/TransverseVecMultiplierAlgebra.lean` | fibre-generic multiplier algebra on `T²` |
| `Analysis/TransverseVecCutoffMultiplier.lean` | second-order periodic cut-off multipliers at any fibre |
| `Analysis/TransverseSmoothH2CutoffMultiplier.lean` | Fourier-summable periodic `H²` cut-off multipliers |
| `Analysis/TransverseSmoothBumpPeriodization.lean` | locally finite lattice periodisation of plane bumps |
| `Analysis/TransverseSmoothBumpH2CutoffConcrete.lean` | the polynomial bound for the periodised cut-offs |
| `Analysis/BumpAffineScaling.lean` | first-order calculus for rescaled plane bumps |
| `Analysis/TransverseLocalizedNorm.lean` | support-localised norms and Hölder bounds on `T²` |
| `Analysis/ScalarSecondPartial.lean`, `Analysis/ScalarSecondPartialBridges.lean` | the scalar Cartesian second-partial layer and its two-component bridges |
| `Analysis/ProductFourier.lean` | complete Fourier analysis on `T² × T` |
| `Analysis/ProductWeakDerivative.lean` | Fourier weak derivatives on the product torus |
| `Analysis/ProductVectorCalculus.lean` | weak divergence and curl on the product torus |
| `Analysis/ProductScalarEnergy.lean` | scalar `H¹`, `H⁻¹` and the weak Laplacian |
| `Analysis/ProductDivergenceEnergy.lean` | the product divergence in the scalar energy scale |
| `Analysis/ProductTransportEnergy.lean` | skew energy of divergence-free transport |
| `Analysis/ProductH2DenseEmbedding.lean` | density of product `H²` |
| `Fourier/ProductH2.lean` | Fourier-graph `H²(T² × T; ℂ³)` and the axial lift |

Operator theory, `Operator/` and `Analysis/`:

| module | content |
|---|---|
| `Analysis/AntiDual.lean` | the complex anti-dual of a Hilbert space |
| `Analysis/ComplexForm.lean` | coercive complex forms |
| `Operator/ComplexFormAntiDual.lean` | sesquilinear forms as maps into the anti-dual |
| `Operator/AssociatedForm.lean` | operators associated with complex forms |
| `Operator/FormCoercivityConstants.lean` | complex coercivity constants of forms (`HasComplexCoercivityConstant`) |
| `Operator/ScalarCoefficientPivot.lean` | moving a bounded scalar coefficient across an `L²` pivot |
| `Analysis/AnalyticOperatorHelpers.lean` | analyticity helpers and the open right half-plane |
| `Operator/Domain.lean` | operators with a bundled Banach domain; `IsEigenpair` |
| `Operator/PointwiseResolvent.lean` | bundling pointwise inverses into a resolvent family |
| `Operator/ResolventHolomorphy.lean` | holomorphy of bundled-domain resolvents |
| `Operator/ResolventSetHolomorphy.lean` | the domain-valued resolvent is analytic on the whole intrinsic resolvent set, which is open (`DomainOperator.isOpen_resolventSet`, `DomainOperator.analyticOnNhd_resolventSetResolvent_inv`) |
| `Operator/ResolventPropagation.lean` | propagating a resolvent from one point through a resolvent correction |
| `Operator/ResolventAnnulus.lean` | uniform annular resolvents around a resolvent circle |
| `Operator/Contour.lean` | spectral circles, `growthFloor`, `backgroundShiftedContour` |
| `Operator/Riesz.lean` | Riesz projections for bundled-domain operators |
| `Operator/RieszResolventIdentity.lean` | the resolvent identity |
| `Operator/RieszProjectionCalculus.lean` | Riesz-projection calculus |
| `Operator/RieszDomainCalculus.lean` | domain-valued Riesz calculus |
| `Operator/RieszSpectralMomentCalculus.lean` | the Riesz projection commutes with its first spectral moment |
| `Operator/RieszEigenvalueLocalization.lean` | eigenvalue localisation by a Riesz contour |
| `Operator/CompactOperatorSum.lean` | finite sums of compact operators |
| `Operator/CompactAdjoint.lean` | Schauder's theorem on a Hilbert space |
| `Operator/CompactAtkinson.lean`, `Operator/CompactAtkinsonIndexZero.lean` | compact perturbations of the identity; index zero |
| `Operator/CompactBaseFredholm.lean` | the compact-base Fredholm and index-zero bridge |
| `Operator/CompactBaseInjectiveResolvent.lean` | resolvents from a compact base resolvent and injectivity |
| `Operator/AnalyticFredholm.lean`, `Operator/AnalyticFredholmContinuation.lean` | analytic Fredholm theory and its continuation |
| `Operator/FredholmIsolation.lean` | Fredholm and finite-rank spectral bridges |
| `Operator/DomainPencilFredholm.lean` | Fredholm bridges for bundled-domain pencils |
| `Operator/DomainOperatorClosedRangeAdjoint.lean` | closed range and adjoint criteria |
| `Operator/AdjointRealizationFromResolvent.lean` | maximal adjoint realisations from one resolvent pair |
| `Operator/FiniteDimensionalDeterminant.lean` | determinants on finite-dimensional ranges and the finite-dimensional invertibility criterion for scalar reductions |
| `Operator/FixedSectorBasic.lean` | closed graph and compact resolvent in a fixed sector |
| `Operator/FixedSectorDiffusionInverse.lean` | the positive-real fixed-sector diffusion inverse |
| `Operator/FixedSectorLowerOrderDecay.lean` | Fourier decay of the lower-order terms |
| `Operator/FixedSectorResolvent.lean` | a Neumann construction of a fixed-sector resolvent |
| `Operator/VerticalZeroExtend.lean` | the vertical zero-extension `ℂ² ↪ ℂ³` on transverse `L²` and `H²` |
