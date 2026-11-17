module

public import FastDynamo

/-!
# Axiom audit

The release trust surface.  `FastDynamo` (the root module) already imports every
module of the development, so this file needs no other import; running it after a
successful build prints the transitive axiom dependencies of every audited
declaration.

`scripts/audit.sh` elaborates this module and pipes the report through
`scripts/check-axiom-audit.awk`, which fails the release gate unless

* every dependency is one of `propext`, `Classical.choice`, `Quot.sound`, and
* the *set* of reported declarations is exactly the checked-in list in
  `scripts/audited-declarations.txt`.

So this file and that list must change together; regenerate the list with
`scripts/regenerate-audited-declarations.sh` after editing the commands below.

## Organisation

The commands are grouped in fourteen sections.  Sections 1–8 follow the layers of the
development, top down: statement, finish, whole-plane elliptic regularity, parametrix,
global velocity and parameters, local seed, operators, analysis foundations.  Sections 9–13
follow the paper: the proof route (section 9), its dynamical half (section 10), the
resistive semigroup of §1.1 and Appendix A with the uniqueness of the solution (section 11),
the ideal induction equation in weak form (section 12), and the vanishing-diffusivity limit
of Remark 1.7 (section 13).  Section 14 covers Theorem 1.2 in the form of the Challenge statement
(`FastDynamo/Palomar/`).  Within a section the targets come in blocks, each introduced by
a comment saying what it covers; sections 9–13 order their blocks by the stage of the
paper rather than alphabetically.

## Line length

A `#print axioms` command names a single declaration and cannot be wrapped, so
the lines below exceed the project's usual line-length budget.

## Coverage policy

Audited here is every *headline* declaration — the statement layer, the main
theorems, and the named conclusions of each stage — together with every
definition on the route to them, so that no object a statement depends on can
hide an axiom.  Routine companions are omitted:
`rfl` or `simp` restatements of an audited declaration, `_apply` lemmas,
instances that only repackage an audited fact, and purely local bookkeeping
steps inside a proved theorem.  Their axiom profile is implied by the audited
declarations that consume them, since `#print axioms` is transitive.

## No namespaces

Every target is written fully qualified and this module opens no namespace and
enters no section, so the printed names match the audited list verbatim; the
release gate checks that the two agree.
-/

-- --------------------------------------------------------------------------
-- 1. Statement layer and main theorem
-- The paper's Theorem 1.2 as it is stated here, the scaling parameters of the
-- reduction between the local and the selected pictures, the headline theorems
-- that discharge the statement, `cor:magnetic-scale` at the theorem's witnesses,
-- the dynamo definitions of §1.1, and Theorem 1.2 for the normalised velocity
-- (Remark 1.6).
-- --------------------------------------------------------------------------

#print axioms FastDynamo.MainPhysicalConclusion
#print axioms FastDynamo.MainReducedTarget
#print axioms FastDynamo.WholePlaneExactScalingParameters.axialShift_eq
#print axioms FastDynamo.WholePlaneExactScalingParameters.epsilon_mul_inv_ell_sq
#print axioms FastDynamo.WholePlaneExactScalingParameters.epsilon_mul_physicalWave_sq
#print axioms FastDynamo.WholePlaneExactScalingParameters.physicalWave_mul_ell
#print axioms FastDynamo.mainPhysicalConclusion_holds
#print axioms FastDynamo.mainPhysicalConclusion_of_mainReducedTarget
#print axioms FastDynamo.mainReducedTarget_holds
#print axioms FastDynamo.main_theorem_spectral
#print axioms FastDynamo.MainReducedClauses
#print axioms FastDynamo.MainPhysicalClauses
#print axioms FastDynamo.mainPhysicalClauses_of_mainReducedClauses
#print axioms FastDynamo.MainTheoremStrengthened
#print axioms FastDynamo.main_theorem_strengthened
#print axioms FastDynamo.main_theorem_explicit_witnesses
#print axioms FastDynamo.mainPhysicalConclusionNormalized_holds
#print axioms FastDynamo.mainPhysicalClauses_normalizedVelocity
#print axioms FastDynamo.MainEveryAdmissibleCellClauses
#print axioms FastDynamo.mainEveryAdmissibleCellClauses_holds
#print axioms FastDynamo.MainLiteralTorusClauses
#print axioms FastDynamo.mainLiteralTorusClauses_holds
#print axioms FastDynamo.mainVelocityChartRepresentative_qualitative
#print axioms FastDynamo.lipschitzWith_mainVelocityChartRepresentative
#print axioms FastDynamo.lipschitzWith_mainVelocityTorusRepresentative
#print axioms FastDynamo.mainLiteralVelocity
#print axioms FastDynamo.lipschitzWith_mainLiteralVelocity
#print axioms FastDynamo.transverseW1InfValue_mainVelocity_ae
#print axioms FastDynamo.mainVelocityPeriodizedRepresentative
#print axioms FastDynamo.mainVelocityTorusRepresentative_transverseTorusPoint_eq_periodized
#print axioms FastDynamo.mainVelocityPeriodizedRepresentative_eq_chart
#print axioms FastDynamo.differentiable_mainVelocityPeriodizedRepresentative
#print axioms FastDynamo.contDiffAt_mainVelocityPeriodizedRepresentative
#print axioms FastDynamo.fderiv_mainVelocityPeriodizedRepresentative_accumulationPoint
#print axioms FastDynamo.not_continuousAt_fderiv_mainVelocityPeriodizedRepresentative
#print axioms FastDynamo.lipschitzWith_mainVelocityPeriodizedRepresentative
#print axioms FastDynamo.mainVelocity
#print axioms FastDynamo.mainEps0
#print axioms FastDynamo.mainGrowthFloor
#print axioms FastDynamo.mainEps0_eq
#print axioms FastDynamo.mainReducedClauses_holds
#print axioms FastDynamo.mainPhysicalClauses_holds
#print axioms FastDynamo.mainGrowthFloor_eq
#print axioms FastDynamo.mainGrowthFloor_ge_numeric
#print axioms FastDynamo.MainReducedTargetNormalized
#print axioms FastDynamo.MainPhysicalConclusionNormalized
#print axioms FastDynamo.exists_normalized_mainReducedClauses
#print axioms FastDynamo.mainPhysicalConclusionNormalized_of_mainReducedTarget
-- The spectral clauses at one diffusivity and one eigenpair, and `cor:magnetic-scale`
-- at the witnesses of the theorem: `|K| ≍ ε^{-1/2}` and `L_B ≍ √ε` with two constants.
#print axioms FastDynamo.MainPhysicalClausesAt
#print axioms FastDynamo.mainPhysicalClausesAt_of_reducedEigenpair
#print axioms FastDynamo.complexAxialMagneticLength
#print axioms FastDynamo.realPhaseAxialMagneticLength
#print axioms FastDynamo.main_theorem_magnetic_scale
-- The definitions of §1.1: dynamo at `ε` (`γ(u, ε) > 0`), fast dynamo
-- (`liminf_{ε ↓ 0} γ(u, ε) > 0`), slow dynamo; the constructed velocity is a fast dynamo.
#print axioms FastDynamo.IsDynamoAt
#print axioms FastDynamo.IsFastDynamo
#print axioms FastDynamo.IsSlowDynamo
#print axioms FastDynamo.IsFastDynamo.not_isSlowDynamo
#print axioms FastDynamo.isDynamoAt_mainVelocity
#print axioms FastDynamo.isFastDynamo_mainVelocity
-- Theorem 1.2 for the normalised velocity `ũ = u / M`, `M = max {1, ‖u‖_{W^{1,∞}}}`
-- (Remark 1.6), with all clauses, and its ingredients: the time rescaling of a
-- semigroup, `L_{ε,ũ} = M⁻¹ L_{Mε,u}`, `e^{tL_{ε,ũ}} = e^{(t/M)L_{Mε,u}}`,
-- `γ(ũ, ε) = M⁻¹ γ(u, Mε)`, the rescaled flow and ideal group.
#print axioms FastDynamo.velocityNormalizer
#print axioms FastDynamo.normalizedVelocity
#print axioms FastDynamo.StronglyContinuousSemigroup.timeRescale
#print axioms FastDynamo.StronglyContinuousSemigroup.growthBound_timeRescale
#print axioms FastDynamo.DomainOperatorSemigroupRealization.timeRescale
#print axioms FastDynamo.productInductionAction_smul
#print axioms FastDynamo.productInductionAction_normalizedVelocity
#print axioms FastDynamo.productInductionSemigroup_smul
#print axioms FastDynamo.solenoidalInductionSemigroup_smul
#print axioms FastDynamo.literalInductionSemigroup_smul
#print axioms FastDynamo.literalInductionSemigroup_normalizedVelocity
#print axioms FastDynamo.gamma_normalizedVelocity
#print axioms FastDynamo.normalizedGrowthFloor_le_gamma
#print axioms FastDynamo.normalizedGrowthFloor_le_liminf_gammaOf
#print axioms FastDynamo.mainSemigroupOrbitClauses_normalizedVelocity
#print axioms FastDynamo.IsParticleFlow.timeRescale
#print axioms FastDynamo.IsIdealInductionGroup.timeRescale
#print axioms FastDynamo.MainTheoremDynamicalClauses.smul
#print axioms FastDynamo.MainLagrangianClauses.smul
#print axioms FastDynamo.normalizedLiteralVelocity
#print axioms FastDynamo.transverseW1InfValue_normalizedVelocity_ae
#print axioms FastDynamo.normalizedLiteralVelocity_eq
#print axioms FastDynamo.isIdealInductionGroup_normalizedLiteralVelocity
#print axioms FastDynamo.normalizedLiteralFlow_unique
#print axioms FastDynamo.normalizedTheoremDynamical_holds
#print axioms FastDynamo.normalizedTheoremLagrangian_holds
#print axioms FastDynamo.MainTheoremNormalized
#print axioms FastDynamo.mainTheoremNormalized_holds

-- --------------------------------------------------------------------------
-- 2. Finish layer
-- From a reduced eigenpair to the real, divergence-free strong solution of
-- the induction equation: its exact norm law, its growth floor, the
-- solenoidality of the physical mode, the magnetic-length bounds, the
-- negative-diffusivity counterexample, the zero mean of the constructed fields
-- (Remark 1.5) and Remark 1.4 on the real part of the mode.
-- --------------------------------------------------------------------------

#print axioms FastDynamo.ConditionalModeCertificate
#print axioms FastDynamo.RealStrongModeCertificate
#print axioms FastDynamo.ReducedInductionMagneticScale.epsilon_mul_norm_sq_productGradient_le_stretching
#print axioms FastDynamo.ScaleFamily.matching_fourierIndex_lower
#print axioms FastDynamo.complexAxialMagneticLength_lower_of_energy
#print axioms FastDynamo.conditionalModeCertificate_of_reducedEigenpair
#print axioms FastDynamo.exists_positive_nonsolenoidal_eigenpair_of_negative_diffusivity
#print axioms FastDynamo.axiallyIndependent_eigenpair_solenoidal
#print axioms FastDynamo.axiallyIndependent_positive_eigenfunction_solenoidal
#print axioms FastDynamo.magneticLength_lower_of_energy
#print axioms FastDynamo.negativeDiffusivity_auxiliary_eigenpair
#print axioms FastDynamo.norm_realAxialTrajectory
#print axioms FastDynamo.productInductionAction_divergence_eq_zero
#print axioms FastDynamo.productInductionEigenpair_divergence_eq_zero
#print axioms FastDynamo.productInductionEigenpair_solenoidal
#print axioms FastDynamo.realAxialTrajectory_eq_realPart_complexExp
#print axioms FastDynamo.realAxialTrajectory_ne_zero
#print axioms FastDynamo.realAxialTrajectory_norm_lower_bound
#print axioms FastDynamo.realPhaseAxialMagneticLength_eq_complex
#print axioms FastDynamo.complexifyProductR3L2_phaseAxialGradientL2
#print axioms FastDynamo.realStrongModeCertificate_of_reducedEigenpair
#print axioms FastDynamo.realifiedEigenTrajectoryH2
#print axioms FastDynamo.realifiedEigenTrajectoryH2_isPhysicalStrongSolution
#print axioms FastDynamo.realifiedEigenTrajectoryH2_isStrongSolution
#print axioms FastDynamo.realifiedEigenTrajectoryH2_zero
#print axioms FastDynamo.norm_complexifyR3
#print axioms FastDynamo.norm_complexifyProductR3L2
#print axioms FastDynamo.complexifyProductR3L2_eq_zero_iff
-- `rem:scope-intro` (Remark 1.5): the constructed fields have zero spatial mean.
#print axioms FastDynamo.HasZeroMean
#print axioms FastDynamo.productCoeffCLM_zero_zero_eq_integral
#print axioms FastDynamo.hasZeroMean_axialLiftH2
#print axioms FastDynamo.HasZeroMean.realPart
#print axioms FastDynamo.hasZeroMean_realifiedEigenTrajectoryH2
#print axioms FastDynamo.hasZeroMean_complexify_realAxialTrajectory
#print axioms FastDynamo.hasZeroMean_complexify_realAxialInitialField
-- Remark 1.4: if `Im λ ≠ 0`, the real part of a magnetic eigenmode is not an eigenmode.
#print axioms FastDynamo.productInductionAction_eq_smul_of_physicalEigenpair
#print axioms FastDynamo.not_isEigenpair_productRealPartH2

-- --------------------------------------------------------------------------
-- 3. Whole-plane elliptic regularity
-- An L² field whose distributional Laplacian is an L² datum has an H² lift.
-- --------------------------------------------------------------------------

#print axioms FastDynamo.DomainOperator.adjointRealization_and_closedGraph_of_formalAdjoint_reference
#print axioms FastDynamo.DomainOperator.hasResolventAt_of_compactStateResolvent_of_pencil_injective
#print axioms FastDynamo.exists_wholePlaneH2_of_laplacian_eq_l2

-- --------------------------------------------------------------------------
-- 4. Parametrix and Riesz calculus
-- The explicit second-derivative bound of the output cut-off, the shifted
-- background contour, and the growing eigenpairs at matching cells and at
-- admissible indices.
-- --------------------------------------------------------------------------

#print axioms FastDynamo.ParametrixExplicitCutoff.norm_outputCutoff_iteratedFDeriv_two_le
#print axioms FastDynamo.backgroundShiftedContour
#print axioms FastDynamo.exists_growing_eigenpair_of_matchingCell
#print axioms FastDynamo.exists_growing_eigenpair_of_admissible_index

-- --------------------------------------------------------------------------
-- 5. Global velocity, placement and parameters
-- Scale selection and matching cells, the torus charts and placed cutoffs,
-- the global parameter choice, and the concrete global velocity field.
-- --------------------------------------------------------------------------

#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.AxialWeakTransfer.hasFourierWeakDerivative
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.EuclideanCellSourceCertificate.hasFourierWeakTransfer
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.EuclideanCellSourceCertificate.integral_euclideanMonomial_mul_firstDerivativeCoord
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.FullVelocityConcrete.norm_parameterizedFullGlobalEuclideanRealSource_le_dist_sq
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.FullVelocityConcrete.parameterizedFullGlobalEuclideanRealSource_hasFDerivAt_accumulationPoint
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.FullVelocityConcrete.parameterizedFullGlobalTorusFirstDerivative_eq_rescaledLocalCopy_of_mem_core
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.FullVelocityConcrete.parameterizedFullGlobalTorusSource_eq_cell_add_axialShift_of_mem_core
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.FullVelocityConcrete.parameterizedFullGlobalTorusSource_eq_rescaledLocalCopy_add_axialShift_of_mem_core
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.FullVelocityConcrete.parameterizedFullGlobalW1Inf
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.FullVelocityConcrete.parameterizedFullGlobalW1Inf_isTransverseDivergenceFree
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.FullVelocityConcrete.parameterizedFullGlobalW1Inf_ne_zero
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.axialOffsetGlobalTorusDerivative_eq_zero_of_representative_core
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.axialOffsetGlobalTorus_eq_axialAmplitude_of_representative_core
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.exists_matchingCell_with_placedCore
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.exists_matchingCell_with_torusPlacedCore
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.nonempty
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.norm_parameterizedHelicalGlobalTorusFirstDerivative_le
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.norm_parameterizedHelicalGlobalTorusSource_le
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.parameterizedHelicalGlobalTorusFirstDerivative_transverseDivergence
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.tendsto_integral_parameterizedHelicalPartialTorusFirstDerivative
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.tendsto_integral_parameterizedHelicalPartialTorusSource
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.torusPeriodizedExtension_eq_zero_of_not_mem_torusLocalCoreDisk
#print axioms FastDynamo.ScaleFamily.adjacent_ratio_bounds
#print axioms FastDynamo.ScaleFamily.axial_wavenumber_match
#print axioms FastDynamo.ScaleFamily.exists_ge
#print axioms FastDynamo.ScaleFamily.exists_matchingCell
#print axioms FastDynamo.ScaleFamily.exists_matching_scale
#print axioms FastDynamo.ScaleFamily.iUnion_diffusivityInterval
#print axioms FastDynamo.ScaleFamily.neighboring_intervals_overlap
#print axioms FastDynamo.ScaleFamily.summable_of_norm_le_axialGradientScale
#print axioms FastDynamo.TorusChartH2.transverseLaplacianFromH2_wholePlaneChartToTransverseH2
#print axioms FastDynamo.TorusChartH2.wholePlaneChartToTransverseH2
#print axioms FastDynamo.exists_scale_selection
#print axioms FastDynamo.transverseTorusPoint_injectiveOn_placementChart
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.FullVelocityConcrete.GlobalVelocityQualitative
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.FullVelocityConcrete.parameterizedFullGlobalEuclideanRealSource_qualitative
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.FullVelocityConcrete.contDiffAt_parameterizedFullGlobalEuclideanRealSource
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.FullVelocityConcrete.differentiable_parameterizedFullGlobalEuclideanRealSource
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.FullVelocityConcrete.fderiv_parameterizedFullGlobalEuclideanRealSource_accumulationPoint
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.FullVelocityConcrete.norm_fderiv_parameterizedFullGlobalEuclideanRealSource_le
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.FullVelocityConcrete.lipschitzWith_parameterizedFullGlobalEuclideanRealSource
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.FullVelocityConcrete.not_continuousAt_fderiv_parameterizedFullGlobalEuclideanRealSource
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.FullVelocityConcrete.parameterizedFullGlobalRealTorusSource_eq_transverseDescent
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.FullVelocityConcrete.lipschitzWith_parameterizedFullGlobalRealTorusSource
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.FullVelocityConcrete.lipschitzWith_literalVelocity_parameterizedFullGlobalRealTorusSource
#print axioms FastDynamo.UnitBoxPeriodization.periodization
#print axioms FastDynamo.UnitBoxPeriodization.lipschitzWith_periodization
#print axioms FastDynamo.UnitBoxPeriodization.eventuallyEq_translate
#print axioms FastDynamo.transverseTorusPoint
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.FullVelocityConcrete.supportedInPlacementChart_parameterizedFullGlobalEuclideanRealSource
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.FullVelocityConcrete.parameterizedFullGlobalRealTorusSource_transverseTorusPoint
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.FullVelocityConcrete.parameterizedFullGlobalPeriodizedRealSource_eventuallyEq_accumulationPoint
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.FullVelocityConcrete.differentiable_parameterizedFullGlobalPeriodizedRealSource
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.FullVelocityConcrete.contDiffAt_parameterizedFullGlobalPeriodizedRealSource
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.FullVelocityConcrete.fderiv_parameterizedFullGlobalPeriodizedRealSource_accumulationPoint
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.FullVelocityConcrete.not_continuousAt_fderiv_parameterizedFullGlobalPeriodizedRealSource

-- --------------------------------------------------------------------------
-- 6. Local seed and Bessel functions
-- The Ponomarenko seed: modified Bessel functions, their Wronskians and Gaussian
-- moments, the dispersion function, the derivative jump of the radial mode, the
-- seed velocity coefficients, the scale ratios and the scaling parameters of a
-- matching cell.
-- --------------------------------------------------------------------------

#print axioms FastDynamo.LocalSeedParameters.exists_scaleRatios
#print axioms FastDynamo.ModifiedBessel.I0_analyticAt
#print axioms FastDynamo.ModifiedBessel.I0_hasDerivAt_recurrence
#print axioms FastDynamo.ModifiedBessel.I0_series_radius
#print axioms FastDynamo.ModifiedBessel.I1_eq_half_mul_I0_sub_I2
#print axioms FastDynamo.ModifiedBessel.I1_hasDerivAt
#print axioms FastDynamo.ModifiedBessel.I2_analyticAt
#print axioms FastDynamo.ModifiedBessel.I2_hasDerivAt_recurrence
#print axioms FastDynamo.ModifiedBessel.K0_conj
#print axioms FastDynamo.ModifiedBessel.K1_eq_exp_neg_mul_integral_normalizedGaussianKernel
#print axioms FastDynamo.ModifiedBessel.K1_eq_z_div_two_mul_K2_sub_K0
#print axioms FastDynamo.ModifiedBessel.K2_conj
#print axioms FastDynamo.ModifiedBessel.analyticOnNhd_K0
#print axioms FastDynamo.ModifiedBessel.analyticOnNhd_K2
#print axioms FastDynamo.ModifiedBessel.besselCross_eq_two_div_sq
#print axioms FastDynamo.ModifiedBessel.deriv_I2_mul_K2_sub_I2_mul_deriv_K2_eq_one_div
#print axioms FastDynamo.ModifiedBessel.exp_neg_mul_pi_mul_I1_eq_z_mul_integral_quadraticKernel_Ioi
#print axioms FastDynamo.ModifiedBessel.hasDerivAt_K0
#print axioms FastDynamo.ModifiedBessel.hasDerivAt_K0_eq_K0_sub_K2
#print axioms FastDynamo.ModifiedBessel.hasDerivAt_K1_eq_neg_K0_add_K2
#print axioms FastDynamo.ModifiedBessel.hasDerivAt_K2
#print axioms FastDynamo.ModifiedBessel.hasDerivAt_K2_eq_K0_sub_K2
#print axioms FastDynamo.ModifiedBessel.integrable_K0Integrand
#print axioms FastDynamo.ModifiedBessel.integrable_K2Integrand
#print axioms FastDynamo.ModifiedBessel.integral_complexGaussianFourthMoment
#print axioms FastDynamo.ModifiedBessel.integral_complexGaussianSecondMoment
#print axioms FastDynamo.ModifiedBessel.integral_realGaussianFourthMoment_eq_three_mul_halfLine_div_sq
#print axioms FastDynamo.ModifiedBessel.integral_realGaussianSixthMoment
#print axioms FastDynamo.ModifiedBessel.orderZeroWronskian_eq_one_div
#print axioms FastDynamo.ModifiedBessel.ponomarenkoDispersion_eq_neg_two_div_mul_deriv_I1_mul_K1
#print axioms FastDynamo.ModifiedBesselBoundaryBehavior.modifiedBessel_K012_radial_exponential_bounds
#print axioms FastDynamo.PolarHessianCalculus.phaseSquareRadialProductSecondPartialValue_trace
#print axioms FastDynamo.PonomarenkoRealRadialBridge.realDerivativeJump_eq_boundaryDerivativeJump
#print axioms FastDynamo.ScaleFamily.MatchingCell.exactScalingParameters
#print axioms FastDynamo.lineDeriv_wholePlaneCoordMulSchwartz
#print axioms FastDynamo.parameterizedSmoothedVelocity_coefficients_hasWeakGradient
#print axioms FastDynamo.ponomarenkoDispersion_analyticOnNhd
#print axioms FastDynamo.ponomarenkoIntegralSecondKind
#print axioms FastDynamo.squaredRadiusHelicalVelocityCoefficients_hasWeakGradient
#print axioms FastDynamo.squaredRadiusHelicalVelocity_transverseDivergence
#print axioms FastDynamo.volume_ponomarenkoSmoothingClosedAnnulus
#print axioms FastDynamo.wholePlaneSchwartzVelocityCoefficients_hasWeakGradient

-- --------------------------------------------------------------------------
-- 7. Operators
-- The reduced, auxiliary and physical induction operators, associated forms,
-- domain-operator resolvent and Riesz calculus, compactness, the
-- whole-plane local forms, the resolvent set and spectrum of a partially defined
-- operator, holomorphy of resolvents, and the compact embedding of `H²` in `L²`.
-- --------------------------------------------------------------------------

#print axioms FastDynamo.DomainOperator.isStrongSolution_eigenTrajectory
#print axioms FastDynamo.DomainOperator.propagatedInverse_left_inv
#print axioms FastDynamo.DomainOperator.propagatedInverse_right_inv
#print axioms FastDynamo.DomainOperator.resolventCorrection_isUnit_of_pointwise_twoSidedInverse
#print axioms FastDynamo.HasResolventOn.circleIntegrable_stateResolvent
#print axioms FastDynamo.HasResolventOn.embedding_comp_domainRieszProjection
#print axioms FastDynamo.HasResolventOn.isCompactOperator_rieszProjection_of_compact_difference
#print axioms FastDynamo.HasResolventOn.op_comp_domainRieszProjection
#print axioms FastDynamo.HasResolventOn.resolventKernelCircleExchange_of_separated
#print axioms FastDynamo.HasResolventOn.rieszProjection
#print axioms FastDynamo.HasResolventOn.rieszProjection_isIdempotentElem_of_isOpen_common_resolvent
#print axioms FastDynamo.HasResolventOn.rieszSpectralMoment_mem_rieszProjection_range
#print axioms FastDynamo.HasResolventOn.stateResolvent_hasDerivAt
#print axioms FastDynamo.HasResolventOn.stateResolvent_sub_stateResolvent
#print axioms FastDynamo.SpectralCircle.closedRegion_re_pos
#print axioms FastDynamo.SpectralCircle.growthFloor_le_re
#print axioms FastDynamo.WholePlaneVelocityCoefficients.HasWeakGradient.hasWholePlaneLInfWeakGradient
#print axioms FastDynamo.associatedFormProdDomain_relation_apply
#print axioms FastDynamo.associatedFormProdEmbedding_injective
#print axioms FastDynamo.eventually_norm_reducedInductionLowerOrder_comp_diffusionInverseRay_lt_one
#print axioms FastDynamo.fixedSectorInductionAction_intertwines
#print axioms FastDynamo.fixedSectorInductionEigenpair_iff
#print axioms FastDynamo.fixedSectorInductionPencil_intertwines
#print axioms FastDynamo.inverse_comp_reducedInductionDiffusionPencil
#print axioms FastDynamo.norm_transverseDerivFromH2_comp_reducedInductionDiffusionInverse_le
#print axioms FastDynamo.norm_transverseH2Embedding_comp_reducedInductionDiffusionInverse_le
#print axioms FastDynamo.productInductionAction_apply
#print axioms FastDynamo.productInductionAction_axialLiftH2
#print axioms FastDynamo.productInductionAction_productRealPartH2
#print axioms FastDynamo.productInductionAction_toHMinus2_eq_physical
#print axioms FastDynamo.productInductionEigenpair_axialLiftH2_iff_fixedSector
#print axioms FastDynamo.productInductionEigenpair_axialLiftH2_iff_reduced
#print axioms FastDynamo.productInductionEigenpair_to_physical
#print axioms FastDynamo.productInductionPencil_axialLiftH2
#print axioms FastDynamo.productPhysicalInductionAction_productRealPartH2_of_divergenceFree
#print axioms FastDynamo.reducedInductionAction_apply
#print axioms FastDynamo.reducedInductionDiffusionPencil_comp_inverse
#print axioms FastDynamo.wholePlaneH1AntiDualToTempered_associatedFormPivot_embedding
#print axioms FastDynamo.wholePlaneH1AntiDualToTempered_associatedFormPivot_firstDerivative
#print axioms FastDynamo.reducedInductionAction_smul
#print axioms FastDynamo.reducedInductionOperator_isEigenpair_smul_iff
#print axioms FastDynamo.isTransverseDivergenceFree_smul
#print axioms FastDynamo.norm_normalizedVelocity_le_one
#print axioms FastDynamo.mainReducedClauses_smul
-- Resolvent set and spectrum of a partially defined operator (Appendix A): resolvents as
-- bounded two-sided inverses of `z − T`, compactness of one resolvent propagates to all, and
-- then the spectrum consists of eigenvalues; a domain operator as a partially defined map.
#print axioms FastDynamo.LinearPMap.IsResolvent
#print axioms FastDynamo.LinearPMap.resolventSet
#print axioms FastDynamo.LinearPMap.spectrum
#print axioms FastDynamo.LinearPMap.IsResolvent.isCompactOperator_of_isResolvent
#print axioms FastDynamo.LinearPMap.mem_spectrum_of_eigenvector
#print axioms FastDynamo.LinearPMap.exists_eigenvector_of_mem_spectrum
#print axioms FastDynamo.DomainOperator.toLinearPMap
#print axioms FastDynamo.DomainOperator.mem_toLinearPMap_domain_iff
#print axioms FastDynamo.DomainOperator.toLinearPMap_apply_embedding
#print axioms FastDynamo.DomainOperator.isResolvent_stateResolvent
-- Holomorphy of the resolvent on the (open) resolvent set of a domain operator, and
-- strong holomorphy plus local boundedness implies holomorphy in operator norm.
#print axioms FastDynamo.DomainOperator.resolventSet
#print axioms FastDynamo.DomainOperator.analyticOnNhd_inverse_pencil
#print axioms FastDynamo.DomainOperator.resolventSetResolvent
#print axioms FastDynamo.DomainOperator.analyticOnNhd_resolventSetResolvent_inv
#print axioms FastDynamo.differentiableOn_of_forall_apply
-- Compactness of the embedding `H²(T² × T) ↪ L²(T² × T)` (Rellich, by diagonal truncation).
#print axioms FastDynamo.isCompactOperator_lpDiagonal
#print axioms FastDynamo.isCompactOperator_productH2Embedding

-- --------------------------------------------------------------------------
-- 8. Analysis and Fourier foundations
-- Sobolev spaces on the torus and on the plane, Fourier analysis and weak
-- derivatives, the Ladyzhenskaya/GNS estimates, and the compactness tools
-- they feed; first, the dynamics foundations they support: strong solutions and their
-- uniqueness, Hille–Yosida generation, the induction semigroups and the growth rate
-- γ(u, ε), and growth bounds of semigroups.
-- --------------------------------------------------------------------------

#print axioms FastDynamo.DomainOperatorSemigroupRealization.eigenpair_orbit_and_growth
-- The dynamics foundations, in blocks ordered by module rather than alphabetically.
-- `Dynamics/StrongSolutionUniqueness.lean`: the a priori energy bound and uniqueness of
-- forward strong solutions, for every reduced fixed-sector operator.
#print axioms FastDynamo.DomainOperator.hasDerivAt_embedding_of_isForwardStrongSolution
#print axioms FastDynamo.DomainOperator.continuousOn_norm_embedding_sq_of_isForwardStrongSolution
#print axioms FastDynamo.DomainOperator.hasDerivAt_norm_embedding_sq_of_isForwardStrongSolution
#print axioms FastDynamo.DomainOperator.isForwardStrongSolution_sub
#print axioms FastDynamo.DomainOperator.norm_embedding_sq_le_exp_of_isForwardStrongSolution
#print axioms FastDynamo.DomainOperator.norm_embedding_le_exp_of_isForwardStrongSolution
#print axioms FastDynamo.DomainOperator.forwardStrongSolutionsUnique_of_re_inner_le
#print axioms FastDynamo.re_inner_reducedInductionAction_le
-- The formal adjoint of the reduced induction operator.
#print axioms FastDynamo.reducedInductionStretchingTranspose
#print axioms FastDynamo.reducedInductionAdjointAction
#print axioms FastDynamo.reducedInductionAdjointOperator
#print axioms FastDynamo.reducedInductionOperator_formalAdjointPairing
#print axioms FastDynamo.re_inner_reducedInductionAdjointAction_le
#print axioms FastDynamo.reducedInductionAdjointOperator_forwardStrongSolutionsUnique
-- The reduced operator's resolvent on the right half-plane.
#print axioms FastDynamo.reducedInductionOperator_isAdjointRealization_and_isClosedGraph
#print axioms FastDynamo.reducedInductionOperator_isAdjointRealization
#print axioms FastDynamo.reducedInductionOperator_pencil_bijective_of_lt_re
#print axioms FastDynamo.exists_reducedInductionOperator_resolventOn_rightHalfPlane
#print axioms FastDynamo.reducedInductionRightHalfPlaneResolvent
#print axioms FastDynamo.norm_stateResolvent_reducedInductionOperator_rightHalfPlane_le
#print axioms FastDynamo.norm_stateResolvent_reducedInductionOperator_realRay_le
-- Operator exponentials for the Hille–Yosida development.
#print axioms FastDynamo.HilleYosida.norm_exp_le
#print axioms FastDynamo.HilleYosida.hasDerivAt_exp_apply
-- The resolvent ray: derived resolvent identities and the Yosida limit r R(r) x → x.
#print axioms FastDynamo.resolvent_identity
#print axioms FastDynamo.HasResolventOn.commute_stateResolvent
#print axioms FastDynamo.HilleYosidaRay.ofHalfPlane
#print axioms FastDynamo.HilleYosidaRay.tendsto_smul_stateResolvent
-- Yosida approximants and their semigroups.
#print axioms FastDynamo.tendsto_yosida_embedding
#print axioms FastDynamo.norm_approx_le
#print axioms FastDynamo.hasDerivAt_approx_apply
#print axioms FastDynamo.norm_approx_sub_approx_le
-- Convergence of the approximant semigroups: the limit operators and their laws.
#print axioms FastDynamo.HilleYosidaRay.semigroupOperator
#print axioms FastDynamo.norm_semigroupOperator_le
#print axioms FastDynamo.semigroupOperator_add
#print axioms FastDynamo.continuousOn_semigroupOperator_apply
-- The generated semigroup, its realization of the operator, and the Hille–Yosida theorem.
#print axioms FastDynamo.HilleYosidaRay.semigroup
#print axioms FastDynamo.tendsto_semigroup_apply
#print axioms FastDynamo.HilleYosidaRay.norm_semigroup_le
#print axioms FastDynamo.HilleYosidaRay.growthBound_le
#print axioms FastDynamo.HilleYosidaRay.domainOrbit
#print axioms FastDynamo.isForwardStrongSolution_domainOrbit
#print axioms FastDynamo.HilleYosidaRay.realization
#print axioms FastDynamo.HilleYosidaRay.semigroup_spec
#print axioms FastDynamo.exists_stronglyContinuousSemigroup_of_hilleYosidaRay
#print axioms FastDynamo.re_le_growthBound_of_hilleYosidaRay_of_eigenpair
#print axioms FastDynamo.HilleYosidaRay.semigroup_unique
-- Invariance of closed subspaces under the generated semigroup, and its restriction.
#print axioms FastDynamo.exp_mem_of_mem
#print axioms FastDynamo.HilleYosidaRay.semigroup_mem_of_closed_resolvent_invariant
#print axioms FastDynamo.HilleYosidaRay.restrictedSemigroup
#print axioms FastDynamo.HilleYosidaRay.norm_restrictedSemigroup_le
#print axioms FastDynamo.HilleYosidaRay.growthBound_restrictedSemigroup_le
-- The Hille–Yosida ray of the reduced induction operator.
#print axioms FastDynamo.reducedInductionHilleYosidaRay
#print axioms FastDynamo.reducedInductionHilleYosidaRay_spectralSet
#print axioms FastDynamo.norm_stateResolvent_reducedInductionHilleYosidaRay_le
-- The axial Hilbert-sum decomposition of the product space (sector assembly).
#print axioms FastDynamo.isHilbertSum_axialLiftL2
#print axioms FastDynamo.axialDecomposition
#print axioms FastDynamo.axialSectorProjL2
-- The axial sector decomposition of the product H² domain (sector assembly).
#print axioms FastDynamo.axialSectorProjH2
#print axioms FastDynamo.norm_axialSectorProjH2_le
#print axioms FastDynamo.axialSectorProjH2_axialLiftH2
#print axioms FastDynamo.hasSum_axialLiftH2_axialSectorProjH2
#print axioms FastDynamo.axialSectorProjL2_productInductionAction
#print axioms FastDynamo.re_inner_productInductionAction_le
#print axioms FastDynamo.productInductionOperator_forwardStrongSolutionsUnique
-- The uniform-in-K sector estimate (sector assembly).
#print axioms FastDynamo.productH2Weight_le_diffusion_bound_times_symbol
#print axioms FastDynamo.norm_axialMultiplier_mul_inverseSymbol_le
#print axioms FastDynamo.exists_uniform_sigma_norm_lowerOrder_comp_diffusionInverse_le_half
#print axioms FastDynamo.norm_axialLiftH2_le_graph
-- The solenoidal subspace of the product space and its resolvent invariance
-- (sector assembly).
#print axioms FastDynamo.productSolenoidalSubspace
#print axioms FastDynamo.mem_productSolenoidalSubspace_iff
#print axioms FastDynamo.isClosed_productSolenoidalSubspace
#print axioms FastDynamo.stateResolvent_mem_productSolenoidalSubspace_of_re_pos
#print axioms FastDynamo.stateResolvent_mem_productSolenoidalSubspace
#print axioms FastDynamo.productH2Embedding_mem_productSolenoidalSubspace_of_isEigenpair
-- The product-level resolvent assembled from the sector resolvents, and its
-- Hille–Yosida ray (sector assembly).
#print axioms FastDynamo.productInductionPencil_axialLiftH2_eq_axialLiftL2
#print axioms FastDynamo.exists_hasSum_axialLiftH2_of_summable_norm_sq
#print axioms FastDynamo.productResolventInv
#print axioms FastDynamo.hasSum_productResolventInv
#print axioms FastDynamo.axialSectorProjH2_productResolventInv
#print axioms FastDynamo.continuousOn_productResolventInv
#print axioms FastDynamo.productInductionHalfPlaneResolvent
#print axioms FastDynamo.norm_stateResolvent_productInduction_le
#print axioms FastDynamo.productHilleYosidaRay
-- The all-frequency induction semigroup, its solenoidal restriction, and the eigen-orbit
-- lower bound (sector assembly).
#print axioms FastDynamo.productInductionSemigroup
#print axioms FastDynamo.productInductionRealization
#print axioms FastDynamo.productInductionSemigroup_unique
#print axioms FastDynamo.norm_productInductionSemigroup_le
#print axioms FastDynamo.growthBound_productInductionSemigroup_le
#print axioms FastDynamo.re_le_growthBound_productInductionSemigroup_of_eigenpair
#print axioms FastDynamo.stateResolvent_productHilleYosidaRay_mem_productSolenoidalSubspace
#print axioms FastDynamo.productInductionSemigroup_mem_productSolenoidalSubspace
#print axioms FastDynamo.productInductionRealization_domainOrbit_mem_productSolenoidalSubspace
#print axioms FastDynamo.productL2ToHMinus2_domainOrbit_eq_physical
#print axioms FastDynamo.solenoidalInductionSemigroup
#print axioms FastDynamo.norm_solenoidalInductionSemigroup_le
#print axioms FastDynamo.growthBound_solenoidalInductionSemigroup_le
#print axioms FastDynamo.exp_re_le_norm_solenoidalInductionSemigroup
#print axioms FastDynamo.re_le_growthBound_solenoidalInductionSemigroup_of_eigenpair
-- "Its solution": the real datum's orbit under the semigroup, and the exact growth law
-- `eq:main-thm-growth` of Theorem 1.2 (sector assembly).
#print axioms FastDynamo.productInductionSemigroup_realifiedEigenTrajectoryH2
#print axioms FastDynamo.solenoidalInductionSemigroup_realifiedEigenTrajectoryH2
#print axioms FastDynamo.norm_solenoidalInductionSemigroup_realAxialOrbit
#print axioms FastDynamo.MainSemigroupOrbitClauses
#print axioms FastDynamo.mainSemigroupOrbitClauses_of_mainReducedClauses
#print axioms FastDynamo.mainSemigroupOrbitClauses_holds
-- The growth rate `γ(u,ε)` on `L²_σ(T³;ℂ³)` and the growth-rate clause of `thm:main`
-- (sector assembly).
#print axioms FastDynamo.literalSolenoidalSubspace
#print axioms FastDynamo.isClosed_literalSolenoidalSubspace
#print axioms FastDynamo.literalSolenoidalSubspaceCompleteSpace
#print axioms FastDynamo.solenoidalToLiteral
#print axioms FastDynamo.literalInductionSemigroup
#print axioms FastDynamo.norm_literalInductionSemigroup_le
#print axioms FastDynamo.growthBound_literalInductionSemigroup
#print axioms FastDynamo.gamma
#print axioms FastDynamo.gamma_le_stretching
#print axioms FastDynamo.gamma_ne_top
#print axioms FastDynamo.gamma_ge_gamma0
#print axioms FastDynamo.mainGrowthFloor_le_gamma_le_stretching
#print axioms FastDynamo.gamma_ne_bot
-- The growth rate is the paper's limit `lim t⁻¹ log ‖e^{tL}‖` (`eq:semigroup-growth-rate`)
-- for every divergence-free velocity and every ε > 0, in `[−∞, ∞)`; it is a real number
-- exactly when there is an exponential minorant, and at the constructed velocity that
-- real limit is sandwiched between γ₀ and ‖∇⊥u‖∞.
#print axioms FastDynamo.gamma_tendsto
#print axioms FastDynamo.gamma_ne_bot_iff
#print axioms FastDynamo.gamma_tendsto_real
#print axioms FastDynamo.mainGrowthFloor_le_gamma_lim
-- Uniqueness and the a priori bound for the reduced operator, the growth bound of a
-- semigroup and its two-sided comparison with exponentials, and realization uniqueness.
#print axioms FastDynamo.reducedInductionOperator_forwardStrongSolutionsUnique
#print axioms FastDynamo.reducedInductionOperator_norm_embedding_le_exp
#print axioms FastDynamo.StronglyContinuousSemigroup.growthBound
#print axioms FastDynamo.StronglyContinuousSemigroup.growthBound_le_of_norm_le
#print axioms FastDynamo.StronglyContinuousSemigroup.le_growthBound_of_norm_ge
#print axioms FastDynamo.StronglyContinuousSemigroup.operator_eq_of_realization
#print axioms FastDynamo.StronglyContinuousSemigroup.eq_of_realization
-- Restriction to an invariant subspace, conjugation by an isometry, and comparison.
#print axioms FastDynamo.StronglyContinuousSemigroup.growthBound_mono_of_norm_le
#print axioms FastDynamo.StronglyContinuousSemigroup.restrict
#print axioms FastDynamo.StronglyContinuousSemigroup.norm_restrict_le
#print axioms FastDynamo.StronglyContinuousSemigroup.growthBound_restrict_le
#print axioms FastDynamo.StronglyContinuousSemigroup.congr
#print axioms FastDynamo.StronglyContinuousSemigroup.norm_congr
#print axioms FastDynamo.StronglyContinuousSemigroup.growthBound_congr
-- The growth bound of every C₀-semigroup on a Banach space is a limit:
-- t⁻¹ log ‖S t‖ → growthBound S = inf_{t > 0} t⁻¹ log ‖S t‖ in `[−∞, ∞)` (local
-- boundedness by Banach–Steinhaus, then the subadditivity argument), finite exactly when
-- there is an exponential minorant, and then the real-valued limit.
#print axioms FastDynamo.StronglyContinuousSemigroup.growthExponent
#print axioms FastDynamo.StronglyContinuousSemigroup.exists_norm_operator_le
#print axioms FastDynamo.StronglyContinuousSemigroup.growthBound_eq_iInf
#print axioms FastDynamo.StronglyContinuousSemigroup.tendsto_growthExponent
#print axioms FastDynamo.StronglyContinuousSemigroup.growthBound_ne_top
#print axioms FastDynamo.StronglyContinuousSemigroup.growthBound_ne_bot_iff
#print axioms FastDynamo.StronglyContinuousSemigroup.exists_growthBound_eq_and_tendsto
-- Eigenvalues bound growth from below; the growth floor of the initial-value problem on
-- the domain, the scalar sanity check, and the sandwich at the main witnesses.
#print axioms FastDynamo.DomainOperatorSemigroupRealization.re_le_growthBound_of_eigenpair
#print axioms FastDynamo.DomainOperator.strongSolutionGrowthFloor
#print axioms FastDynamo.DomainOperator.strongSolutionGrowthFloor_le_of_norm_le
#print axioms FastDynamo.DomainOperator.le_strongSolutionGrowthFloor_of_eventually_exp_le
#print axioms FastDynamo.DomainOperator.re_le_strongSolutionGrowthFloor_of_eigenpair
#print axioms FastDynamo.scalarSemigroup
#print axioms FastDynamo.scalarOperator
#print axioms FastDynamo.scalarOperator_isEigenpair
#print axioms FastDynamo.scalarOperator_forwardStrongSolutionsUnique
#print axioms FastDynamo.scalarRealization
#print axioms FastDynamo.reducedInductionOperator_strongSolutionGrowthFloor_le
#print axioms FastDynamo.mainGrowthFloor_le_strongSolutionGrowthFloor
#print axioms FastDynamo.mainGrowthFloor_le_strongSolutionGrowthFloor_le
-- The analysis and Fourier foundations proper, sorted alphabetically.
#print axioms FastDynamo.HasWholePlaneL2WeakDerivative.closed_of_tendsto
#print axioms FastDynamo.TransverseSmoothBumpH2CutoffConcrete.secondOrderFourierWeight_hasPolynomialGrowth
#print axioms FastDynamo.TransverseSmoothBumpPeriodization.torusIntegral_mFourier_mul_periodization_eq_fourier
#print axioms FastDynamo.TransverseSmoothBumpPeriodization.transverseScalarCoeff_torusLatticePeriodizationL2
#print axioms FastDynamo.TransverseSmoothH2CutoffMultiplier.summableFourierPeriodicSecondOrderCutoff
#print axioms FastDynamo.WholePlaneRadialExponential.memLp_two_unitExterior_of_norm_le_radialExponential
#print axioms FastDynamo.complexToAntiDual_apply_apply
#print axioms FastDynamo.complexifyProductR3L2_realPartL2
#print axioms FastDynamo.countable_wholePlaneUnitCircleSliceExceptional
#print axioms FastDynamo.denseRange_h1CoeffSchwartzToGraph
#print axioms FastDynamo.denseRange_productH2Embedding
#print axioms FastDynamo.eLpNorm_four_wholePlaneScalarH1_le
#print axioms FastDynamo.exists_schwartz_tendsto_wholePlaneScalarH1
#print axioms FastDynamo.fourierInv_wholePlaneL2ToTempered
#print axioms FastDynamo.fourier_lineDeriv_wholePlaneBasis_eq_momentum
#print axioms FastDynamo.fourier_wholePlaneL2ToTempered
#print axioms FastDynamo.h1CoeffSchwartzToPhysical_deriv_toLp
#print axioms FastDynamo.h1CoeffSchwartzToPhysical_toLp
#print axioms FastDynamo.h1CoeffToGraph_surjective
#print axioms FastDynamo.h1CoeffToValueL2_hasWeakDerivative
#print axioms FastDynamo.h1Recover_distribution_identity
#print axioms FastDynamo.hasDerivAt_schwartz_smul_wholePlaneSliceEquiv
#print axioms FastDynamo.hasWholePlaneIntegralWeakDerivative_of_ae_fiberwise_product
#print axioms FastDynamo.hasWholePlaneL2WeakDerivative_mul_h1
#print axioms FastDynamo.hasWholePlaneL2WeakDerivative_mul_schwartz
#print axioms FastDynamo.inner_scalarAxialLiftL2
#print axioms FastDynamo.integral_wholePlaneUnitCircle_coordinate_smul_eq_setIntegral
#print axioms FastDynamo.isCompactOperator_l2SectionOperator
#print axioms FastDynamo.isCompactOperator_of_compact_approximation
#print axioms FastDynamo.isCompactOperator_of_list_rankOne_approximation
#print axioms FastDynamo.isCompactOperator_wholePlaneBandLimitedRestrictionFromCoeff
#print axioms FastDynamo.isCompactOperator_wholePlaneScalarLocalizationH1_of_ae_zero_off
#print axioms FastDynamo.isCompactOperator_wholePlaneScalarRestrictionH1
#print axioms FastDynamo.isCompactOperator_wholePlaneScalarRestrictionH1_of_bandLimited_cores
#print axioms FastDynamo.lineDeriv_wholePlaneRescaleTempered
#print axioms FastDynamo.lineDeriv_wholePlaneRescaleTest
#print axioms FastDynamo.map_wholePlane_inv_smul_volume
#print axioms FastDynamo.measurePreserving_wholePlaneAffine
#print axioms FastDynamo.memSobolev_iff_exists_wholePlaneSobolev
#print axioms FastDynamo.mem_productH2Submodule_iff
#print axioms FastDynamo.mem_transverseH2Submodule_iff
#print axioms FastDynamo.norm_axialLiftL2
#print axioms FastDynamo.norm_operatorMulL2_apply_apply_le
#print axioms FastDynamo.norm_sq_wholePlaneRescaleH2
#print axioms FastDynamo.norm_wholePlaneH1HighFrequencyTail_operator_le
#print axioms FastDynamo.norm_wholePlaneRescale
#print axioms FastDynamo.norm_wholePlaneRescaleH2_le
#print axioms FastDynamo.norm_wholePlaneScalarCutoffL2_le_one
#print axioms FastDynamo.phaseAxialFieldL2_ne_zero
#print axioms FastDynamo.phaseAxialFieldL2_norm_sq
#print axioms FastDynamo.phaseAxialFieldL2_norm_sq_eq
#print axioms FastDynamo.productAxialDerivFromH2_axialLiftH2
#print axioms FastDynamo.productC3L2_ext_coeff
#print axioms FastDynamo.productCoeffCLM_axialLiftL2
#print axioms FastDynamo.productCoeffCLM_productAxialDerivFromH2
#print axioms FastDynamo.productCoeffCLM_productH2Embedding_axialLiftH2
#print axioms FastDynamo.productCoeffCLM_productLaplacianFromH2
#print axioms FastDynamo.productCoeffCLM_productTransverseDerivFromH2
#print axioms FastDynamo.productDivergenceFromH2_eq_zero_iff
#print axioms FastDynamo.productDivergenceFromH2_productRealPartH2
#print axioms FastDynamo.productFrequencyDivergenceCoeff_laplacian
#print axioms FastDynamo.productH2Embedding_injective
#print axioms FastDynamo.productH2Embedding_productRealPartH2
#print axioms FastDynamo.productInductionLowerField_add_velocityDiv_eq_weakCurl
#print axioms FastDynamo.productLaplacianFromH2_axialLiftH2
#print axioms FastDynamo.productScalarFourierAnalysisNested_eq_inner
#print axioms FastDynamo.productScalarFourierAnalysisNested_synthesis
#print axioms FastDynamo.productScalarH1Embedding_productDivergenceH1
#print axioms FastDynamo.productScalarH1ToHMinus1_pair_self_re
#print axioms FastDynamo.productScalarH1_velocityAxial_weakLeibniz
#print axioms FastDynamo.productScalarH1_velocityCoord_weakLeibniz
#print axioms FastDynamo.productScalarL2_ext_coeff
#print axioms FastDynamo.productScalarL2_ext_nested_coeff
#print axioms FastDynamo.productScalarWeakEigenfunction_eq_zero
#print axioms FastDynamo.productScalarWeakLaplacian_pair_self_re_nonpos
#print axioms FastDynamo.productTransverseDerivFromH2_axialLiftH2
#print axioms FastDynamo.productWeakDivergence_laplacian
#print axioms FastDynamo.productWeakDivergence_productInductionAction
#print axioms FastDynamo.productWeakDivergence_velocityTimesScalar_pair_re_eq_zero
#print axioms FastDynamo.realPart_axialLiftPointwise_norm_sq
#print axioms FastDynamo.scalarVectorMulL2_coeffPullback_rescale
#print axioms FastDynamo.scalarVectorMul_axialLift
#print axioms FastDynamo.transverseC3L2_ext_coeff
#print axioms FastDynamo.transverseCoeffCLM_transverseDerivFromH2
#print axioms FastDynamo.transverseCoeffCLM_transverseLaplacianFromH2
#print axioms FastDynamo.transverseDerivFromH2_hasFourierDerivative
#print axioms FastDynamo.transverseH2Embedding_injective
#print axioms FastDynamo.transverseLaplacianFromH2_hasFourierLaplacian
#print axioms FastDynamo.transverseScalarCoeffCLM_eq_inner
#print axioms FastDynamo.transverseScalarFourierAnalysis_synthesis
#print axioms FastDynamo.transverseScalarL2_ext_coeff
#print axioms FastDynamo.vectorScalarMulL2_coeffPullback_rescale
#print axioms FastDynamo.vectorScalarMul_axialLift
#print axioms FastDynamo.volume_unitAddTorus_eq_haar
#print axioms FastDynamo.wholePlaneCoordH1
#print axioms FastDynamo.wholePlaneCoordLInf_coeffPullback
#print axioms FastDynamo.wholePlaneCoordTempered_l2
#print axioms FastDynamo.wholePlaneCoordTempered_linf
#print axioms FastDynamo.wholePlaneFourierAnalysis_synthesis
#print axioms FastDynamo.wholePlaneFourierSynthesis_analysis
#print axioms FastDynamo.wholePlaneH1AntiDualToSobolevMinusOne_injective
#print axioms FastDynamo.wholePlaneH1AntiDualToSobolevMinusOne_pair
#print axioms FastDynamo.wholePlaneH1AntiDualToTempered_injective
#print axioms FastDynamo.wholePlaneH1CoeffRecovery_h1CoeffToGraph
#print axioms FastDynamo.wholePlaneH1Embedding_injective
#print axioms FastDynamo.wholePlaneH1Embedding_scalarMulH1
#print axioms FastDynamo.wholePlaneH1FirstDerivative_scalarMulH1
#print axioms FastDynamo.wholePlaneH1LowFrequencyFromCoeff_ae_eq_fourierTransformInv
#print axioms FastDynamo.wholePlaneH1LowFrequencyFromCoeff_ae_eq_integral
#print axioms FastDynamo.wholePlaneH1LowFrequencyNat_norm_convergence
#print axioms FastDynamo.wholePlaneH1LowFrequency_add_highFrequencyTail
#print axioms FastDynamo.wholePlaneH1_integrationByParts
#print axioms FastDynamo.wholePlaneH1_memSobolev_one
#print axioms FastDynamo.wholePlaneH2Embedding_injective
#print axioms FastDynamo.wholePlaneH2Embedding_rescaleH2
#print axioms FastDynamo.wholePlaneH2FirstDerivative_rescaleH2
#print axioms FastDynamo.wholePlaneH2H1_fixedNAxialPairing
#print axioms FastDynamo.wholePlaneH2H1_fixedNGradientLaplacian_integrationByParts
#print axioms FastDynamo.wholePlaneH2H1_gradientLaplacian_integrationByParts
#print axioms FastDynamo.wholePlaneH2H1_integrationByParts
#print axioms FastDynamo.wholePlaneH2SecondDerivative_rescaleH2
#print axioms FastDynamo.wholePlaneL2ToTempered_h1CoeffToValueL2
#print axioms FastDynamo.wholePlaneL2ToTempered_injective
#print axioms FastDynamo.wholePlaneL2ToTempered_rescale
#print axioms FastDynamo.wholePlaneLaplacian_rescaleH2
#print axioms FastDynamo.wholePlaneLaplacian_scalarMulC3H2
#print axioms FastDynamo.wholePlaneLaplacian_toTempered
#print axioms FastDynamo.wholePlaneRescaleH2CLE
#print axioms FastDynamo.wholePlaneRescaleH2CLE_symm_apply
#print axioms FastDynamo.wholePlaneRescaleH2_inverse_apply
#print axioms FastDynamo.wholePlaneRescaleH2_inverse_apply_right
#print axioms FastDynamo.wholePlaneRescaleLinearIsometryEquiv_symm_apply
#print axioms FastDynamo.wholePlaneRescale_coe_ae
#print axioms FastDynamo.wholePlaneRescale_inverse_apply
#print axioms FastDynamo.wholePlaneRescale_inverse_apply_right
#print axioms FastDynamo.wholePlaneScalarCutoff_comp_h1LowFrequency
#print axioms FastDynamo.wholePlaneScalarH1ToL4_coe_ae
#print axioms FastDynamo.wholePlaneScalarMulL2_coe_ae
#print axioms FastDynamo.wholePlane_fourierSynthesis_ae_eq_fourierTransformInv
-- The literal three-torus: the measure-preserving identification with the product torus,
-- the transported real solution and its growth law, complexification on `Torus 3` and its
-- compatibility with the transport, the literal velocity, and the descent
-- of periodic functions from the plane to the transverse torus.
#print axioms FastDynamo.productToLiteral
#print axioms FastDynamo.measurePreserving_productToLiteral
#print axioms FastDynamo.toLiteralL2
#print axioms FastDynamo.toLiteralR3L2
#print axioms FastDynamo.toLiteralC3L2
#print axioms FastDynamo.literalRealTrajectory
#print axioms FastDynamo.norm_literalRealTrajectory
#print axioms FastDynamo.literalRealTrajectory_ne_zero
#print axioms FastDynamo.literalRealTrajectory_norm_lower_bound
#print axioms FastDynamo.literalRealTrajectory_zero
#print axioms FastDynamo.norm_literalRealTrajectory_eq_exp_mul_norm_zero
#print axioms FastDynamo.literalRealTrajectory_norm_lower_bound_zero
#print axioms FastDynamo.complexifyLiteralR3L2
#print axioms FastDynamo.toLiteralC3L2_complexifyProductR3L2
#print axioms FastDynamo.literalVelocity
#print axioms FastDynamo.LatticePeriodic.IsPeriodic
#print axioms FastDynamo.transverseDescent
#print axioms FastDynamo.lipschitzWith_transverseDescent

-- --------------------------------------------------------------------------
-- 9. The proof route
-- The layers of the paper in the order they are traversed: the
-- two-component local seed and its certified eigenvalue, the parameter
-- chain, the two-summand parametrix on a selected cell, the global spectral
-- transfer, the finish bridge, and the witnesses of Theorem 1.2 built from them.
-- --------------------------------------------------------------------------
-- the order-one Bessel product bound, the dispersion segment and the certified interface data
-- of the proof of `lem:jump-horizontal-mode` (§2.2)
#print axioms FastDynamo.norm_ponomarenkoOrderOneProduct_mul_sub_half_le_three_div_re_sq
#print axioms FastDynamo.norm_ponomarenkoSegmentDispersion_sub_inv_cube_le
#print axioms FastDynamo.exists_ponomarenkoSegmentDispersionRe_eq_zero
#print axioms FastDynamo.modifiedBessel_denominators_ne_zero_on_segment
#print axioms FastDynamo.exists_certifiedInterfaceData_of_segment
#print axioms FastDynamo.exists_certifiedInterfaceData_two_pi
-- the background multiplier's scalar algebra and the transverse weighted Leibniz rule (§6)
#print axioms FastDynamo.abs_backgroundMultiplierF_le_one
#print axioms FastDynamo.backgroundMultiplierF_phase_lower_bound
#print axioms FastDynamo.exists_backgroundTau
#print axioms FastDynamo.re_inner_weightedTransverseState_neg_laplacian_ge
#print axioms FastDynamo.re_inner_weightedTransverseState_neg_laplacian_ge_young
#print axioms FastDynamo.re_inner_weightedTransverseState_axialMultiplier
#print axioms FastDynamo.abs_re_inner_weightedPart_transport_le
-- the radial axial plateau of the placed velocity (`eq:global-u`, §3.3)
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.axialPlateauBump
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.axialPlateauRadial
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.axialPlateau_eq_axialPlateauRadial
-- `lem:torus-sector-basic`: the two-component horizontal induction operator (§5)
#print axioms FastDynamo.horizontalProjL2_reducedInductionAction
#print axioms FastDynamo.eventually_hasResolventOn_horizontalInductionOperator_expRay
#print axioms FastDynamo.pencilFredholmIndexZeroOn_horizontalInductionOperator
#print axioms FastDynamo.horizontalInductionOperator_basic
-- `lem:exact-renormalization`: the two-component scaling `eq:scaling` on `H²(ℝ²;ℂ²)` (§5)
#print axioms FastDynamo.exactScalingC2_eigenpair_iff
#print axioms FastDynamo.exactScalingC2_selectedEigenpair_to_local
-- the weighted coercivity of the background pencil and the background velocity and multiplier
-- (proof of `prop:background-resolvent`, §6)
#print axioms FastDynamo.re_inner_horizontalInductionTransport_eq_zero
#print axioms FastDynamo.horizontalInductionPencil_apply_eq
#print axioms FastDynamo.re_inner_weightedTransverseState_horizontalInductionPencil_ge
#print axioms FastDynamo.BackgroundCoercivity.re_inner_pencil_ge
#print axioms FastDynamo.BackgroundCoercivity.pencil_injective
#print axioms FastDynamo.BackgroundCoercivity.norm_add_sqrt_eps_gradientEnergy_le
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.selectedBackgroundVelocity_isTransverseDivergenceFree
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.norm_transverseW1InfHorizontalDeriv_selectedBackgroundVelocity_le
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.backgroundCell_hasFourierWeakDerivative
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.backgroundMultiplier
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.norm_backgroundMultiplier_value_le_one
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.gradSupNormSq_backgroundMultiplier_le
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.exists_backgroundShiftedGlobalTorus_sub_one_eq
-- `lem:axial-recovery`: the finish bridge from two to three components (§8)
#print axioms FastDynamo.fixedSectorDivergenceCoeff_reducedInductionAction
#print axioms FastDynamo.transverseCoordL2_reducedInductionAction
#print axioms FastDynamo.transverseSnocH2
#print axioms FastDynamo.axialRecoveredComponent_coeff_equation
#print axioms FastDynamo.axialRecoveredCertificate_eq
#print axioms FastDynamo.exists_reducedInductionEigenpair_of_horizontalEigenpair
-- `prop:global-spectral-transfer`, the eigenvalue extraction (§7)
#print axioms FastDynamo.ParametrixNeumannCorrection.ne_zero_of_inner_contour_test
#print axioms FastDynamo.HorizontalSpectralExtraction.isCompactOperator_rieszProjection_horizontalInduction
#print axioms FastDynamo.HorizontalSpectralExtraction.finiteDimensional_rieszProjection_range_horizontalInduction
#print axioms FastDynamo.HorizontalSpectralExtraction.exists_growthFloor_horizontalInduction_eigenpair_of_rieszProjection_ne_zero
-- `prop:background-resolvent` and `cor:scaled-local-resolvents` (§6)
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.pairEuclideanDist_representative_le_of_mem_torusLocalCoreDisk
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.backgroundShiftedGlobalTorus_sub_one_eq_of_mem_torusLocalCoreDisk
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.BackgroundParameters.phase_bound
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.BackgroundParameters.transport_bound
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.BackgroundParameters.coercivity
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.BackgroundParameters.exists_hasResolventOn_shiftedRegion
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.BackgroundParameters.resolvent
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.BackgroundParameters.norm_resolvent_le
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.BackgroundParameters.sqrt_eps_mul_sqrt_gradientEnergy_resolvent_le
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.BackgroundParameters.backgroundResolventData
-- in addition to `prop:background-resolvent`: the background resolvent is holomorphic on an
-- open neighbourhood of the shifted region
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.BackgroundParameters.exists_isOpen_hasResolventOn_analyticOnNhd
#print axioms FastDynamo.scaledLocalResolvent
#print axioms FastDynamo.scaledLocalResolventOnShiftedContour
#print axioms FastDynamo.norm_embedding_scaledLocalResolventInv_le
#print axioms FastDynamo.sqrt_epsilon_mul_norm_deriv_scaledLocalResolventInv_le
-- the two-summand parametrix, its cut-offs, commutators and error (§7.1)
#print axioms FastDynamo.ParametrixCutoffs.backgroundCutoff_eq_zero_of_dist_le
#print axioms FastDynamo.ParametrixCutoffs.backgroundCutoff_eq_one_of_radius_le_dist
#print axioms FastDynamo.ParametrixCutoffs.norm_cutoff_coordinateDerivative_sum_le
#print axioms FastDynamo.ParametrixCutoffs.norm_cutoff_iteratedFDeriv_two_sum_le
#print axioms FastDynamo.ParametrixCutoffs.backgroundCutoff_mul_one_sub_inputCutoff
#print axioms FastDynamo.ParametrixCutoffs.cutoff_partition
#print axioms FastDynamo.ParametrixCutoffs.HorizontalParametrixCutoffs.partition
#print axioms FastDynamo.HorizontalCutoffCommutator.commutator_apply
#print axioms FastDynamo.HorizontalCutoffCommutator.commutator_apply_of_velocityVanishesOnGradient
#print axioms FastDynamo.HorizontalCutoffCommutator.norm_commutator_apply_le_explicitScale
#print axioms FastDynamo.TorusTwoSummandParametrix.pencil_comp_twoSummandParametrix
#print axioms FastDynamo.TorusTwoSummandParametrix.TwoSummandParametrixData.right_error_identity
#print axioms FastDynamo.TorusTwoSummandParametrix.TwoSummandParametrixData.error_eq
#print axioms FastDynamo.TorusTwoSummandParametrix.TwoSummandParametrixData.transfer_rightError_eq
#print axioms FastDynamo.TorusParametrixError.norm_error_le
#print axioms FastDynamo.TorusParametrixError.norm_stateParametrix_apply_le
#print axioms FastDynamo.TorusParametrixError.globalContourResolvent
#print axioms FastDynamo.TorusParametrixError.globalContourResolvent_inv
#print axioms FastDynamo.TorusParametrixError.exists_scale_threshold
-- the parameter chain `(v, I, Gamma, cG, g_*, f_*, L_*, q, vartheta) -> tau -> K_0` (§3)
#print axioms FastDynamo.SpectralCircle.imaginaryBound
#print axioms FastDynamo.SpectralCircle.abs_im_le_imaginaryBound
#print axioms FastDynamo.GlobalSeedInterface.axialShift
#print axioms FastDynamo.GlobalSeedInterface.axialShift_pos
#print axioms FastDynamo.ScaleFamily.exists_ge_chartPacking_supportFit_bufferRadius_zero_lt
#print axioms FastDynamo.ScaleFamily.exists_ge_chartPacking_supportFit_ell_zero_lt_and_bufferRadius_zero_lt
#print axioms FastDynamo.GlobalParameterChoice.tau_pos
#print axioms FastDynamo.GlobalParameterChoice.axialAmplitude_match
#print axioms FastDynamo.GlobalParameterChoice.eps0_formula
#print axioms FastDynamo.GlobalParameterChoice.eps0_pos
#print axioms FastDynamo.GlobalParameterChoice.matchingCell
#print axioms FastDynamo.GlobalParameterChoice.matchingCell_lower
#print axioms FastDynamo.GlobalParameterChoice.matchingCell_upper
#print axioms FastDynamo.GlobalParameterChoice.fourierIndex_ne_zero
#print axioms FastDynamo.GlobalParameterChoice.errorSmall_cell
#print axioms FastDynamo.GlobalParameterChoice.backgroundParameters
#print axioms FastDynamo.GlobalParameterChoice.velocity
#print axioms FastDynamo.GlobalParameterChoice.velocity_isTransverseDivergenceFree
#print axioms FastDynamo.GlobalParameterChoice.velocity_ne_zero
#print axioms FastDynamo.exists_globalParameterChoice
#print axioms FastDynamo.nonempty_globalParameterChoice
-- the placed C2 cut-offs and the periodised Schwartz cut-off (§7.1)
#print axioms FastDynamo.SchwartzPeriodicCutoff.cutoff
#print axioms FastDynamo.SchwartzPeriodicCutoff.cutoff_value_coeff
#print axioms FastDynamo.SchwartzPeriodicCutoff.cutoff_gradient_coeff
#print axioms FastDynamo.SchwartzPeriodicCutoff.cutoff_laplacian_coeff
#print axioms FastDynamo.SchwartzPeriodicCutoff.fourierSample_schwartzLaplacian
#print axioms FastDynamo.SchwartzPeriodicCutoff.cutoff_value_ae_representative
#print axioms FastDynamo.SchwartzPeriodicCutoff.cutoff_gradient_ae_representative
#print axioms FastDynamo.SchwartzPeriodicCutoff.cutoff_laplacian_ae_representative
#print axioms FastDynamo.SchwartzPeriodicCutoff.norm_cutoff_value_le
#print axioms FastDynamo.SchwartzPeriodicCutoff.norm_cutoff_gradient_le
#print axioms FastDynamo.SchwartzPeriodicCutoff.norm_cutoff_laplacian_le
#print axioms FastDynamo.SchwartzPeriodicCutoff.norm_schwartzLaplacian_apply_le
#print axioms FastDynamo.SchwartzPeriodicCutoff.lineDerivOp_realSchwartz_apply
#print axioms FastDynamo.SchwartzPeriodicCutoff.norm_iteratedFDeriv_realSchwartz
#print axioms FastDynamo.HorizontalCutoffMultiplier.verticalZeroExtendL2_transverseVecLaplacianFromH2
#print axioms FastDynamo.HorizontalCutoffMultiplier.horizontalProjH2_verticalZeroExtendH2
#print axioms FastDynamo.HorizontalCutoffMultiplier.ofPeriodic
#print axioms FastDynamo.HorizontalCutoffMultiplier.complement
#print axioms FastDynamo.TorusPlacedCutoffC2.placedCutoffs
#print axioms FastDynamo.TorusPlacedCutoffC2.outputMul_comp_inputMul
#print axioms FastDynamo.TorusPlacedCutoffC2.backgroundMul_comp_inputComplement
#print axioms FastDynamo.TorusPlacedCutoffC2.norm_outputMul_gradient_le
#print axioms FastDynamo.TorusPlacedCutoffC2.norm_backgroundMul_gradient_le
#print axioms FastDynamo.TorusPlacedCutoffC2.norm_outputMul_laplacian_le
#print axioms FastDynamo.TorusPlacedCutoffC2.norm_backgroundMul_laplacian_le
#print axioms FastDynamo.TorusPlacedCutoffC2.velocityVanishesOnGradient_outputMul
#print axioms FastDynamo.TorusPlacedCutoffC2.velocityVanishesOnGradient_backgroundMul
#print axioms FastDynamo.TorusPlacedCutoffC2.stateMul_comp_horizontalInductionAction_congr
#print axioms FastDynamo.TorusPlacedCutoffC2.backgroundMul_agreement
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.closedHalfBufferBall_subset_iocFundamentalBox
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.placedParametrixCutoffs
#print axioms FastDynamo.TorusTwoSummandParametrix.BackgroundParametrixData.ofTorusBackgroundResolventData
-- the C2 chart transports and `lem:global-contour-resolvent` (§7.1)
#print axioms FastDynamo.WholePlaneHorizontalFibre.fibreH2
#print axioms FastDynamo.WholePlaneHorizontalFibre.fibreTempered_l2
#print axioms FastDynamo.WholePlaneHorizontalFibre.wholePlaneHorizontalProjL2_selectedWholePlaneInductionAction
#print axioms FastDynamo.TorusChartC2Transfer.restrictInputC2
#print axioms FastDynamo.TorusChartC2Transfer.extendStateC2
#print axioms FastDynamo.TorusChartC2Transfer.extendDomainC2
#print axioms FastDynamo.TorusChartC2Transfer.transverseH2Embedding_comp_extendDomainC2
#print axioms FastDynamo.TorusChartC2Transfer.extendStateC2_comp_restrictInputC2
#print axioms FastDynamo.TorusChartC2Transfer.wholePlaneVerticalZeroExtendL2_restrictInputC2
#print axioms FastDynamo.TorusChartActionBridge.reducedInductionAction_chart
#print axioms FastDynamo.TorusChartC2Transfer.outputCutoffMulL2_selectedAction_auxMul
#print axioms FastDynamo.TorusChartC2Transfer.localizationCommutatorC2_eq_horizontalCutoffCommutator
#print axioms FastDynamo.TorusChartC2Transfer.norm_transverseVecDerivFromH2_extendDomainC2_le
#print axioms FastDynamo.TorusChartC2Transfer.selectedLocalResolventData
#print axioms FastDynamo.TorusChartC2Transfer.selectedCellParametrixData
#print axioms FastDynamo.TorusChartC2Transfer.selectedCellGlobalContourResolvent
-- `prop:local-seed`: the two-component seed record and its inhabitant at `N = 2 pi` (§2.3)
#print axioms FastDynamo.norm_formPencilGraphPair_le
#print axioms FastDynamo.norm_formPencilDomainInverse_le
#print axioms FastDynamo.norm_formPencilHasResolventOn_inv_le
#print axioms FastDynamo.norm_le_of_mem_sphere
#print axioms FastDynamo.HasResolventOn.rieszProjection_congr_of_domains
#print axioms FastDynamo.HorizontalWeakForm.norm_horizontalDeltaHasResolventOn_inv_le
#print axioms FastDynamo.HorizontalWeakForm.HorizontalNeumannData.norm_contourResolvent_inv_le
#print axioms FastDynamo.HorizontalWeakForm.norm_horizontalLaplacianDatum_le
#print axioms FastDynamo.HorizontalWeakForm.norm_horizontalStrongPairMap_le_bound
#print axioms FastDynamo.HorizontalWeakForm.horizontalStrongResolvent_stateResolvent
#print axioms FastDynamo.HorizontalWeakForm.horizontalStrongResolvent_rieszProjection
#print axioms FastDynamo.HorizontalWeakForm.horizontalLocalResolventBoundOfBounds
#print axioms FastDynamo.LocalSeedC2.exists_localSeedC2_of_data
#print axioms FastDynamo.LocalSeedC2.scaledResolvent
#print axioms FastDynamo.HorizontalMode.exists_localSeedC2_two_pi
#print axioms FastDynamo.HorizontalMode.localSeedC2
#print axioms FastDynamo.HorizontalMode.localSeedC2_kStar
#print axioms FastDynamo.HorizontalMode.localSeedC2_wavenumber
#print axioms FastDynamo.HorizontalMode.seedGrowthFloorBound_le_localSeedC2_growthFloor
#print axioms FastDynamo.HorizontalMode.globalSeedInterface
-- §2.3: in the open right half-plane the spectrum of the horizontal operator `A_w` consists
-- of isolated eigenvalues (index zero of `𝔸_w(z)` gives a non-zero kernel)
#print axioms FastDynamo.HorizontalWeakForm.horizontalSpectrum
#print axioms FastDynamo.HorizontalWeakForm.isDiscrete_horizontalSpectrum
#print axioms FastDynamo.HorizontalWeakForm.exists_ne_zero_horizontalPencilForm_eq_zero
#print axioms FastDynamo.HorizontalWeakForm.exists_isEigenpair_of_mem_horizontalSpectrum
#print axioms FastDynamo.HorizontalWeakForm.mem_horizontalSpectrum_iff
-- the placed witness, `eq:selected-contour-identity` and `lem:global-riesz-nonzero` (§7.2)
#print axioms FastDynamo.TorusSelectedWitness.vanishesOutsideDisk_scaledWitness
#print axioms FastDynamo.TorusSelectedWitness.extendStateC2_coe_ae
#print axioms FastDynamo.TorusSelectedWitness.torusToWholePlane_verticalZeroExtend_extendStateC2
#print axioms FastDynamo.TorusSelectedWitness.torusToWholePlane_verticalZeroExtend_extendStateC2_of_support
#print axioms FastDynamo.TorusSelectedWitness.norm_extendStateC2_of_support
#print axioms FastDynamo.TorusSelectedWitness.inner_extendStateC2_of_support
#print axioms FastDynamo.TorusSelectedWitness.inputMul_stateMul_extendStateC2_of_support
#print axioms FastDynamo.TorusSelectedWitness.outputMul_stateMul_extendStateC2_of_support
#print axioms FastDynamo.TorusSelectedWitness.restrictInputC2_extendStateC2_of_support
#print axioms FastDynamo.TorusSelectedWitness.norm_placedWitness
#print axioms FastDynamo.TorusSelectedWitness.inputMul_stateMul_placedWitness
#print axioms FastDynamo.TorusSelectedWitness.outputMul_stateMul_placedWitness
#print axioms FastDynamo.TorusSelectedWitness.restrictInputC2_placedWitness
#print axioms FastDynamo.TorusSelectedWitness.inner_placedWitness_extendStateC2
#print axioms FastDynamo.TorusSelectedContourIdentity.circleIntegral_translate
#print axioms FastDynamo.TorusSelectedContourIdentity.inner_stateParametrix_eq_of_witness
#print axioms FastDynamo.TorusSelectedContourIdentity.innerTest_contourOperator
#print axioms FastDynamo.TorusSelectedContourIdentity.innerTest_rieszProjection
#print axioms FastDynamo.TorusSelectedContourIdentity.inner_contourOperator_eq_of_pointwise
#print axioms FastDynamo.TorusSelectedContourIdentity.SelectedCellData.parametrix
#print axioms FastDynamo.TorusSelectedContourIdentity.inner_stateParametrix_placedWitness
#print axioms FastDynamo.TorusSelectedContourIdentity.inner_contourOperator_placedWitness
#print axioms FastDynamo.TorusGlobalRieszNonzero.norm_stateResolvent_sub_stateParametrix_le_of_inv
#print axioms FastDynamo.TorusGlobalRieszNonzero.norm_rieszProjection_sub_contourOperator_le_of_inv
#print axioms FastDynamo.TorusGlobalRieszNonzero.abs_re_inner_sub_le
#print axioms FastDynamo.TorusGlobalRieszNonzero.cellContourResolvent
#print axioms FastDynamo.TorusGlobalRieszNonzero.norm_rieszProjection_sub_contourOperator_le_cell
#print axioms FastDynamo.TorusGlobalRieszNonzero.re_inner_contourOperator_placedWitness_gt_half
#print axioms FastDynamo.TorusGlobalRieszNonzero.re_inner_rieszProjection_placedWitness_gt_quarter
#print axioms FastDynamo.TorusGlobalRieszNonzero.rieszProjection_ne_zero_cell
#print axioms FastDynamo.TorusGlobalSpectralTransfer.exists_growing_horizontalInduction_eigenpair_cell
#print axioms FastDynamo.TorusGlobalSpectralTransfer.exists_growing_reducedInduction_eigenpair_cell
-- the velocity agreement on the selected cell, the error target `< 1/4` of the proof of
-- `lem:global-riesz-nonzero`, the main parameter choice and the theorem's witnesses (§3, §7)
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.closedThreeQuarterBufferBall_subset_iocFundamentalBox
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.parameterizedHelicalCellSource_eq_zero_of_le_pairEuclideanDist
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.torusSource_eq_source_transverseIocRepresentative
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.parameterizedHelicalGlobalTorusSource_dichotomy
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.transverseVelocityLocalized_parameterizedFullGlobalW1Inf
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.value_agrees_selectedBackgroundVelocity_off_core
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.deriv_agrees_selectedBackgroundVelocity_off_core
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.rescaledHelicalCoefficients_value_ae
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.rescaledHelicalCoefficients_deriv_ae
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.chartCoefficientAgreement_parameterizedFullGlobalW1Inf
#print axioms FastDynamo.GlobalSeedInterface.errorConstant
#print axioms FastDynamo.GlobalSeedInterface.errorTarget
#print axioms FastDynamo.GlobalSeedInterface.mul_errorTarget_div_lt_quarter
#print axioms FastDynamo.GlobalParameterChoice.scaleErrorMajorant_lt_errorTarget
#print axioms FastDynamo.HorizontalMode.mainParameterChoice
#print axioms FastDynamo.HorizontalMode.mainParameterChoice_eps0_formula
#print axioms FastDynamo.LocalSeedC2.matchingCellShiftedContourResolvent
#print axioms FastDynamo.HorizontalMode.mainSelectedCellResolvent
#print axioms FastDynamo.chainVelocity
#print axioms FastDynamo.chainEps0
#print axioms FastDynamo.chainGrowthFloor
#print axioms FastDynamo.chainEps0_eq
#print axioms FastDynamo.chainGrowthFloor_ge_three_quarters
#print axioms FastDynamo.chainVelocity_isTransverseDivergenceFree
-- the final assembly: the witnesses of Theorem 1.2 at the parameter chain, the
-- every-cell transfer, and the statement layer of the dynamical half (last sentence of
-- `thm:main`)
#print axioms FastDynamo.HorizontalMode.exists_horizontalMode_eigenpair_two_pi
#print axioms FastDynamo.HorizontalMode.localSeedC2_angularSpeed_pos
#print axioms FastDynamo.HorizontalMode.globalSeedInterface_angularSpeed_ne_zero
#print axioms FastDynamo.LocalSeedC2.matchingCellSeedBound
#print axioms FastDynamo.LocalSeedC2.matchingCellBackgroundDatum
#print axioms FastDynamo.LocalSeedC2.matchingCellData
#print axioms FastDynamo.LocalSeedC2.exists_growing_reducedInduction_eigenpair_matchingCell
#print axioms FastDynamo.HorizontalMode.exists_growing_reducedInduction_eigenpair_matchingCell
#print axioms FastDynamo.mainVelocity_isTransverseDivergenceFree
#print axioms FastDynamo.mainVelocity_ne_zero
#print axioms FastDynamo.mainEps0_pos
#print axioms FastDynamo.seed_kStar
#print axioms FastDynamo.seed_wavenumber
#print axioms FastDynamo.mainGrowthFloor_pos
#print axioms FastDynamo.mainGrowthFloor_ge_three_quarters
#print axioms FastDynamo.seed_angularSpeed_ne_zero
#print axioms FastDynamo.literalTorusPoint
#print axioms FastDynamo.IsLiteralTorusLift
#print axioms FastDynamo.IsParticleFlow
#print axioms FastDynamo.HasZeroTopologicalEntropy
#print axioms FastDynamo.IsIdealInductionGroup
#print axioms FastDynamo.MainLagrangianClauses
#print axioms FastDynamo.HasVanishingIdealGrowthRate
#print axioms FastDynamo.MainLagrangianClauses.hasVanishingIdealGrowthRate
#print axioms FastDynamo.HasVanishingIdealOperatorGrowthRate
#print axioms FastDynamo.MainLagrangianClauses.hasVanishingIdealOperatorGrowthRate
#print axioms FastDynamo.tendsto_inv_mul_log_opNorm_of_two_sided_bounds
#print axioms FastDynamo.MainTheoremDynamicalClauses
#print axioms FastDynamo.MainLagrangianClauses.toMainTheoremDynamicalClauses
#print axioms FastDynamo.MainTheoremLagrangian
#print axioms FastDynamo.MainTheoremDynamical
#print axioms FastDynamo.MainTheoremComplete
#print axioms FastDynamo.mainTheoremComplete_of_lagrangian
#print axioms FastDynamo.gammaOf
#print axioms FastDynamo.mainGrowthFloor_le_liminf_gammaOf
#print axioms FastDynamo.ideal_resistive_gap
#print axioms FastDynamo.ideal_resistive_gap_at_diffusivity

-- the shared fibre and multiplier layer used by several of the sections above
#print axioms FastDynamo.horizontalProjPoint
#print axioms FastDynamo.norm_horizontalProjPoint_le
#print axioms FastDynamo.verticalZeroExtendPoint
#print axioms FastDynamo.inner_verticalZeroExtendPoint
#print axioms FastDynamo.compLpL_scalarVectorMulL2
#print axioms FastDynamo.transverseCoordL2_scalarVectorMulTransverseVec
#print axioms FastDynamo.isCompactOperator_finsetSum
#print axioms FastDynamo.associatedFormPivot_comp_scalarVectorMulL2
#print axioms FastDynamo.complexToAntiDual_complexFormOperator
#print axioms FastDynamo.isInvertible_of_isComplexCoercive
#print axioms FastDynamo.analyticAt_smul_const
#print axioms FastDynamo.unitCircleSurfaceValue

-- --------------------------------------------------------------------------
-- 10. The dynamical half of Theorem 1.2
-- The Lagrangian side of the proof route: the particle flow in closed
-- form, the Lipschitz-iterate entropy criterion, Liouville and the Jacobian,
-- the Cauchy transport operator and the ideal induction group on the
-- solenoidal subspace, then the assembly at the constructed velocity and the
-- final theorems (the last sentence of `thm:main`, `prop:particle-flow`,
-- `cor:ideal-growth`).
-- --------------------------------------------------------------------------

#print axioms FastDynamo.coverEntropy_eq_zero_of_lipschitz_iterate
#print axioms FastDynamo.inner_gradient_eq_zero_of_mem_literalSolenoidalSubspace
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.literalFlow
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.flowCL
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.isParticleFlow_literalFlow
#print axioms FastDynamo.IsParticleFlow.unique
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.literalFlow_unique
#print axioms FastDynamo.mainLiteralFlow_unique
#print axioms FastDynamo.existsUnique_isParticleFlow_mainLiteralVelocity
#print axioms FastDynamo.exists_ne_zero_literalSolenoidalSubspace
#print axioms FastDynamo.exists_ne_zero_mainIdealGroup_rate
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.coverEntropy_literalFlow_eq_zero
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.measurePreserving_literalFlow
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.flowFDeriv
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.idealTransport
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.idealGroup
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.dynamicalCL
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.isIdealInductionGroup_idealGroup
#print axioms FastDynamo.mainLiteralFlow
#print axioms FastDynamo.mainIdealGroup
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.mainLagrangianClauses_literalVelocity
-- `eq:explicit-particle-flow`, the fixed points and the optimal Lipschitz constant.
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.cellAngularSpeed_cellCenter
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.cellAxialSpeed_cellCenter
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.planePeriodizedAxialShift_eq_of_mem_pairUnitIocBox
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.literalFlow_eq_cell_of_mem_bufferDisk
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.literalFlow_eq_self_of_forall_not_mem_bufferDisk
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.forall_not_mem_bufferDisk_accumulationPoint_sub_intCast
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.literalFlow_eq_self_of_accumulationPoint
#print axioms FastDynamo.lipschitzConstants
#print axioms FastDynamo.lipConst
#print axioms FastDynamo.bddBelow_lipschitzConstants
#print axioms FastDynamo.lipConst_le_of_dist_le
#print axioms FastDynamo.inv_le_lipConst_of_leftInverse
#print axioms FastDynamo.tendsto_abs_inv_mul_log_of_two_sided
#print axioms FastDynamo.half_ne_zero_unitAddCircle
#print axioms FastDynamo.exists_ne_torusThree
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.lipConst_literalFlow_le
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.inv_flowLipschitzBound_le_lipConst_literalFlow
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.flowLipschitzBound_le_flowCL_mul
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.tendsto_abs_inv_mul_log_lipConst_literalFlow
#print axioms FastDynamo.mainLiteralFlow_eq_cell_of_mem_bufferDisk
#print axioms FastDynamo.mainLiteralFlow_eq_self_of_accumulationPoint
#print axioms FastDynamo.tendsto_abs_inv_mul_log_lipConst_mainLiteralFlow
#print axioms FastDynamo.forall_hasZeroTopologicalEntropy_mainLiteralFlow
#print axioms FastDynamo.hasVanishingIdealOperatorGrowthRate_mainLiteralVelocity
#print axioms FastDynamo.mainTheoremLagrangian_holds
#print axioms FastDynamo.mainTheoremDynamical_holds
#print axioms FastDynamo.mainTheoremComplete_holds
#print axioms FastDynamo.ideal_resistive_gap_holds
#print axioms FastDynamo.ideal_resistive_gap_at_diffusivity_holds

-- --------------------------------------------------------------------------
-- 11. The resistive semigroup: §1.1 and Appendix A
-- The energy identity `eq:energy-competition`, the generator of a C₀-semigroup,
-- analytic semigroups, compactness and spectral mapping, then their application to the
-- induction semigroup on `L²_σ`: the generator is `L_{ε,u}` on `H² ∩ L²_σ`, and Lemma A.1
-- (`lem:semigroup-spectral-growth`) as one statement; last, the uniqueness of the solution
-- of the induction equation ("its solution" in `thm:main`).
-- --------------------------------------------------------------------------

-- `eq:energy-competition`: `½ d/dt ‖B‖² = Re ⟪B, (B·∇)u⟫ − ε‖∇B‖²` along strong solutions
-- of the auxiliary induction operator, and along the real solution of the theorem.
#print axioms FastDynamo.productGradientEnergy
#print axioms FastDynamo.inner_productH2Embedding_laplacian_eq_neg_gradientEnergy
#print axioms FastDynamo.re_inner_productInductionAction_eq
#print axioms FastDynamo.hasDerivAt_half_norm_sq_of_isForwardStrongSolution
#print axioms FastDynamo.hasDerivAt_half_norm_sq_of_isStrongSolution
#print axioms FastDynamo.realStrongSolution_hasDerivAt_half_norm_sq
-- The generator of a C₀-semigroup: difference quotients, domain and values, density of the
-- domain, the derivative of orbits, eigenvectors, uniqueness of the semigroup with a given
-- generator, the generator of a restriction, and the generator of the Hille–Yosida semigroup.
#print axioms FastDynamo.StronglyContinuousSemigroup.diffQuotient
#print axioms FastDynamo.StronglyContinuousSemigroup.generator
#print axioms FastDynamo.StronglyContinuousSemigroup.mem_generator_domain_iff
#print axioms FastDynamo.StronglyContinuousSemigroup.generator_eq_iff
#print axioms FastDynamo.StronglyContinuousSemigroup.apply_mem_generator_domain
#print axioms FastDynamo.StronglyContinuousSemigroup.hasDerivWithinAt_apply
#print axioms FastDynamo.StronglyContinuousSemigroup.dense_generator_domain
#print axioms FastDynamo.StronglyContinuousSemigroup.apply_eq_cexp_smul_of_generator_eq_smul
#print axioms FastDynamo.StronglyContinuousSemigroup.ext_of_generator_eq
#print axioms FastDynamo.StronglyContinuousSemigroup.mem_generator_restrict_domain_iff
#print axioms FastDynamo.StronglyContinuousSemigroup.generator_restrict_apply
#print axioms FastDynamo.HilleYosidaRay.generator_semigroup
-- Analytic semigroups: the open sector, holomorphic extensions to it, analyticity from a
-- numerical-range sector condition (Yosida approximants in complex time, angle π/4), and
-- restriction to a closed invariant subspace.
#print axioms FastDynamo.openSector
#print axioms FastDynamo.AnalyticExtension
#print axioms FastDynamo.IsAnalyticSemigroup
#print axioms FastDynamo.HilleYosidaRay.sectorExtension
#print axioms FastDynamo.HilleYosidaRay.isAnalyticSemigroup_of_sectorial
#print axioms FastDynamo.IsAnalyticSemigroup.restrict
-- Compactness and spectrum: an analytic semigroup maps into the generator's domain for
-- t > 0, so a compact resolvent makes `S t` compact; spectral mapping
-- `σ(S t) \ {0} = exp(t σ(G))` and growth bound = spectral bound, attained at an eigenvalue.
#print axioms FastDynamo.IsAnalyticSemigroup.exists_generator_comp
#print axioms FastDynamo.IsAnalyticSemigroup.isCompactOperator
#print axioms FastDynamo.StronglyContinuousSemigroup.exp_re_mul_le_norm
#print axioms FastDynamo.StronglyContinuousSemigroup.cexp_mem_spectrum
#print axioms FastDynamo.IsAnalyticSemigroup.exists_cexp_eq_of_mem_spectrum
#print axioms FastDynamo.IsAnalyticSemigroup.spectrum_diff_zero
#print axioms FastDynamo.IsAnalyticSemigroup.growthBound_eq_iSup
-- The induction operator: transport–stretching form of the auxiliary action, the energy
-- inequality and the sector estimate of its numerical range.
#print axioms FastDynamo.productInductionTransport
#print axioms FastDynamo.productInductionAction_eq_transport
#print axioms FastDynamo.productGradientEnergy_nonneg
#print axioms FastDynamo.re_inner_productInductionAction_le_sub
#print axioms FastDynamo.re_inner_productInductionTransport_skew
#print axioms FastDynamo.exists_productInduction_sectorial
-- The generator of the induction semigroup on `L²_σ`: `L_{ε,u}` with domain `H² ∩ L²_σ`
-- (`solenoidalInductionOperator`), equal to the curl form `curl(u × B) + εΔB` in `H⁻²`;
-- the only semigroup with that generator, and its resolvent.
#print axioms FastDynamo.solenoidalH2
#print axioms FastDynamo.mem_solenoidalH2_iff
#print axioms FastDynamo.productInductionAction_mem_productSolenoidalSubspace
#print axioms FastDynamo.solenoidalInductionOperator
#print axioms FastDynamo.generator_productInductionSemigroup
#print axioms FastDynamo.generator_solenoidalInductionSemigroup
#print axioms FastDynamo.mem_generator_solenoidalInductionSemigroup_domain_iff
#print axioms FastDynamo.productL2ToHMinus2_generator_solenoidalInductionSemigroup
#print axioms FastDynamo.eq_solenoidalInductionSemigroup_of_generator_eq
#print axioms FastDynamo.gamma_eq_growthBound_of_generator_eq
#print axioms FastDynamo.exists_isResolvent_generator_solenoidalInductionSemigroup_eq
-- Conservation of the mean: `L_{ε,u}` has range in the mean-zero fields, so
-- `‖e^{tL}‖ ≥ 1`, `0 ≤ γ(u, ε)`, and `γ(u, ε)` is a real limit for every u and ε > 0.
#print axioms FastDynamo.hasZeroMean_productInductionAction
#print axioms FastDynamo.exists_productSolenoidal_mean_eq_one
#print axioms FastDynamo.one_le_norm_solenoidalInductionSemigroup
#print axioms FastDynamo.zero_le_gamma
#print axioms FastDynamo.gamma_eq_lim
-- The ingredients of Lemma A.1 at the induction semigroup: analyticity, compact resolvent,
-- compactness for t > 0, spectral mapping, `0 ∈ σ(L_{ε,u})`, `γ = sup Re σ(L_{ε,u})`,
-- attained at an eigenvalue.
#print axioms FastDynamo.isAnalyticSemigroup_solenoidalInductionSemigroup
#print axioms FastDynamo.exists_isResolvent_generator_solenoidalInductionSemigroup
#print axioms FastDynamo.isCompactOperator_of_isResolvent_generator_solenoidalInductionSemigroup
#print axioms FastDynamo.isCompactOperator_solenoidalInductionSemigroup
#print axioms FastDynamo.spectrum_solenoidalInductionSemigroup_diff_zero
#print axioms FastDynamo.zero_mem_spectrum_generator_solenoidalInductionSemigroup
#print axioms FastDynamo.gamma_eq_iSup_re_spectrum
#print axioms FastDynamo.exists_eigenvalue_re_eq_gamma
-- Lemma A.1 (`lem:semigroup-spectral-growth`) together with the facts of §1.1 on γ(u, ε),
-- as one statement, for every divergence-free u and every ε > 0.
#print axioms FastDynamo.SemigroupSpectralGrowth
#print axioms FastDynamo.semigroupSpectralGrowth_holds
-- "Its solution": the divergence of a forward strong solution of the curl-form equation
-- obeys a heat equation, the resolvent is bounded from the Fourier `H⁻²`, so every forward
-- strong solution with datum in `L²_σ` is the semigroup orbit and forward strong solutions
-- are unique; along such a solution `eq:energy-competition` holds.
#print axioms FastDynamo.productHMinus2Synthesis
#print axioms FastDynamo.exists_productH2_sub_laplacian_eq
#print axioms FastDynamo.exists_norm_stateResolvent_productInductionTransport_le
#print axioms FastDynamo.exists_norm_stateResolvent_le_productL2ToHMinus2
#print axioms FastDynamo.hasDerivWithinAt_comp_of_norm_le
#print axioms FastDynamo.productHMinus2DivergenceFunctional
#print axioms FastDynamo.productDivergenceFromH2_eq_zero_of_isForwardStrongSolution
#print axioms FastDynamo.isForwardStrongSolution_productPhysicalInductionOperator_domainOrbit
#print axioms FastDynamo.productH2Embedding_eq_productInductionSemigroup_of_isForwardStrongSolution
#print axioms FastDynamo.productPhysicalInductionOperator_forwardStrongSolutionsUnique
#print axioms FastDynamo.productH2Embedding_eq_solenoidalInductionSemigroup_of_isForwardStrongSolution
#print axioms FastDynamo.hasDerivAt_half_norm_sq_of_isForwardStrongSolution_physical

-- --------------------------------------------------------------------------
-- 12. The ideal induction equation: weak form, existence, uniqueness
-- The notion of weak solution and of solution group of `∂ₜB + (u·∇)B − (B·∇)u = 0`
-- on the literal torus, the velocity gradient of the constructed velocity, the variational
-- equation `eq:flow-variational-equation` of the flow, the Cauchy group as a solution group,
-- Lipschitz test fields, and the uniqueness of weak solutions and of the solution group
-- (proof of `cor:ideal-growth`).
-- --------------------------------------------------------------------------

-- The weak form: `∇v` on the lift, advection, stretching, test fields, weak solutions on
-- `[−T, T]`, solution groups on `L²_σ`, and their behaviour under time rescaling.
#print axioms FastDynamo.literalFDeriv
#print axioms FastDynamo.literalAdvection
#print axioms FastDynamo.literalStretch
#print axioms FastDynamo.literalFDeriv_literalTorusPoint
#print axioms FastDynamo.literalAdvection_literalTorusPoint
#print axioms FastDynamo.IsIdealTestField
#print axioms FastDynamo.IsIdealWeakSolution
#print axioms FastDynamo.IsIdealSolutionGroup
#print axioms FastDynamo.literalStretchLInf
#print axioms FastDynamo.literalStretchL2
#print axioms FastDynamo.IdealWeakIdentity
#print axioms FastDynamo.idealWeakIdentity_iff
#print axioms FastDynamo.IsIdealWeakSolution.timeRescale
#print axioms FastDynamo.IsIdealSolutionGroup.timeRescale
-- The derivative of the constructed velocity: the periodised field is differentiable at
-- every point with the stored derivatives, and divergence-free pointwise; on the literal
-- torus its gradient is bounded, measurable, trace-free, and the stretching is bounded on L².
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.FullVelocityConcrete.fderiv_parameterizedFullGlobalPeriodizedRealSource_apply_pairBasis
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.FullVelocityConcrete.transverseW1InfDeriv_parameterizedFullGlobalW1Inf_ae_eq_fderiv
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.FullVelocityConcrete.fderiv_parameterizedFullGlobalPeriodizedRealSource_transverseDivergence
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.hasFDerivAt_literalVelocity_lift
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.norm_literalFDeriv_literalVelocity_le
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.measurable_literalFDeriv_literalVelocity
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.sum_literalFDeriv_literalVelocity_diag
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.continuous_literalFDeriv_literalVelocity_literalFlow
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.literalStretchL2_coe_ae
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.norm_literalStretchL2_le
-- `eq:flow-variational-equation`: `DΦ_t = id + ∫₀ᵗ ∇u(Φ_s) DΦ_s ds` at every point and time,
-- its time derivative, and `DΦ_t(x) u(x) = u(Φ_t x)`.
#print axioms FastDynamo.flowDeriv_apply_eq_add_integral
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.flowFDeriv_eq_one_add_integral
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.hasDerivAt_flowFDeriv
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.flowFDeriv_apply_literalVelocity
-- Existence: every Cauchy orbit `𝒯₀(t)B` is a weak solution, and the Cauchy group is a
-- solution group.
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.hasDerivAt_integral_inner_idealTransport
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.isIdealWeakSolution_idealTransport
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.isIdealSolutionGroup_idealGroup
-- Test fields: the smooth test fields are dense in L², and the weak identity extends to
-- fields with Lipschitz, everywhere differentiable lift.
#print axioms FastDynamo.dense_idealTestFieldL2
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.idealWeakIdentity_of_isIdealTestField
#print axioms FastDynamo.IdealWeakIdentity.of_tendsto
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.IsIdealWeakSolution.weakIdentity_of_lipschitz
-- Uniqueness: a weak solution vanishing at time 0 vanishes on `[−T, T]` (the tested
-- characteristic identity and Grönwall), so the Cauchy group is the only solution group,
-- in particular at the theorem's velocity.
#print axioms FastDynamo.eq_zero_of_le_mul_abs_intervalIntegral
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.inner_flowCompL2_eq_intervalIntegral
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.norm_le_mul_abs_intervalIntegral
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.IsIdealWeakSolution.eq_zero
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.IsIdealSolutionGroup.eq_idealGroup
#print axioms FastDynamo.ScaleFamily.TorusCellPlacement.existsUnique_isIdealSolutionGroup
#print axioms FastDynamo.isIdealSolutionGroup_mainIdealGroup
#print axioms FastDynamo.existsUnique_isIdealSolutionGroup_mainLiteralVelocity

-- --------------------------------------------------------------------------
-- 13. Remark 1.7: the vanishing-diffusivity limit
-- The mollifier and the Friedrichs commutator on the literal torus, the bridge between
-- the product picture of the resistive semigroup and the literal picture of the ideal
-- group, and the limit `e^{tL_{ε,u}}B → 𝒯₀(t)B` as `ε ↓ 0`, uniformly on `[0, T]`.
-- --------------------------------------------------------------------------

-- The mollifier `J_δ` on `L²(T³; ℂ³)`: translations, the kernel, `J_δ` and its derivatives,
-- their Fourier symbols, `‖J_δ‖ ≤ 1` and `J_δ → id` strongly.
#print axioms FastDynamo.literalTranslate
#print axioms FastDynamo.continuous_literalTranslate_apply
#print axioms FastDynamo.mollifierBump
#print axioms FastDynamo.mollifierKernel
#print axioms FastDynamo.kernelTranslateIntegral
#print axioms FastDynamo.literalMollify
#print axioms FastDynamo.literalMollifyDeriv
#print axioms FastDynamo.translationPhase
#print axioms FastDynamo.mollifierSymbol
#print axioms FastDynamo.inner_flatTorus3FourierBasis_literalMollify
#print axioms FastDynamo.inner_flatTorus3FourierBasis_literalMollifyDeriv
#print axioms FastDynamo.norm_literalMollify_le
#print axioms FastDynamo.tendsto_literalMollify
#print axioms FastDynamo.exists_bound_sq_mul_mollifierSymbol
-- The Friedrichs commutator `Σⱼ [∂ⱼJ_δ, vⱼ]` for a Lipschitz velocity: bounded uniformly in
-- δ, and tending to 0 uniformly on compact sets when `div v = 0`.
#print axioms FastDynamo.literalComponentSymbol
#print axioms FastDynamo.literalComponentMul
#print axioms FastDynamo.literalComponentMul_coe_ae
#print axioms FastDynamo.friedrichsCommutator
#print axioms FastDynamo.exists_norm_friedrichsCommutator_le
#print axioms FastDynamo.tendsto_friedrichsCommutator
-- The bridge: `J_δ` as a map into the product `H²`, the induction action on mollified
-- fields in literal coordinates, the derivative of the mollified ideal orbit, and the
-- literal induction semigroup in product coordinates.
#print axioms FastDynamo.productMollifyBound
#print axioms FastDynamo.productMollifySymbol
#print axioms FastDynamo.productMollifyCoeffs
#print axioms FastDynamo.productMollifyL2
#print axioms FastDynamo.productMollifyH2
#print axioms FastDynamo.productH2Embedding_productMollifyH2
#print axioms FastDynamo.toLiteralC3L2_productInductionAction_productMollifyH2
#print axioms FastDynamo.hasDerivAt_literalMollify_mainIdealGroup
#print axioms FastDynamo.literalInductionSemigroup_apply_coe
-- The limit: the energy estimate against the mollified ideal orbit, the error bound at
-- fixed δ and ε, and Remark 1.7.
#print axioms FastDynamo.resistiveEvolution
#print axioms FastDynamo.norm_productInductionSemigroup_sub_literalMollify_le
#print axioms FastDynamo.norm_mainIdealGroup_sub_resistiveEvolution_le
#print axioms FastDynamo.tendstoUniformlyOn_resistiveEvolution_mainIdealGroup

-- --------------------------------------------------------------------------
-- 14. Theorem 1.2 in the form of the Challenge statement
-- The dictionary between the definitions of the Challenge statement
-- (`FastDynamo/Palomar/Statement.lean`) and the library's objects, the clauses of
-- the statement at the witnesses of the library, and the statement itself.
-- --------------------------------------------------------------------------

-- Fourier coefficients, `L²_σ` and `H²`.
#print axioms FastDynamo.l2_ext_mFourierCoeff
#print axioms FastDynamo.hasSum_norm_sq_l2
#print axioms FastDynamo.mem_L2σ_iff
#print axioms FastDynamo.L2σ_eq_literalSolenoidalSubspace
#print axioms FastDynamo.literalSolenoidalEquivL2σ
#print axioms FastDynamo.memH2_iff_exists_productH2
-- The velocity and the particle flow.
#print axioms FastDynamo.exists_lipschitzWith_mainLiteralVelocity
#print axioms FastDynamo.isDivergenceFree_mainLiteralVelocity
#print axioms FastDynamo.isFlow_iff_isParticleFlow
#print axioms FastDynamo.exists_isFlow_mainLiteralVelocity
#print axioms FastDynamo.isFlow_mainLiteralVelocity_eq
#print axioms FastDynamo.forall_isFlow_mainLiteralVelocity_continuous_coverEntropy
-- The induction semigroup and the eigenmode.
#print axioms FastDynamo.inductionRHS_eq_of_productL2ToHMinus2_eq
#print axioms FastDynamo.challengeInductionSemigroup
#print axioms FastDynamo.isInductionSemigroup_mainLiteralVelocity
#print axioms FastDynamo.exists_isInductionSemigroup_mainLiteralVelocity
#print axioms FastDynamo.mainLiteralEigenmode_clauses
#print axioms FastDynamo.exists_eigenmode_mainLiteralVelocity
-- Eigenmodes of an arbitrary induction semigroup: the orbit, growth, the real solution.
#print axioms FastDynamo.isInductionSemigroup_apply_eigenmode
#print axioms FastDynamo.forall_exp_mul_le_norm_of_eigenmode
#print axioms FastDynamo.exists_realPart_eigenmode
#print axioms FastDynamo.eigenmode_clauses
-- The ideal solution group: the Fourier symbol, existence, uniqueness, the rate.
#print axioms FastDynamo.mFourierCoeff_literalStretchL2_sub_eq_inductionRHS
#print axioms FastDynamo.challengeIdealGroup
#print axioms FastDynamo.isIdealGroup_challengeIdealGroup
#print axioms FastDynamo.tendsto_inv_mul_log_norm_challengeIdealGroup
#print axioms FastDynamo.isIdealSolutionGroup_of_isIdealGroup
#print axioms FastDynamo.isIdealGroup_eq_challengeIdealGroup
#print axioms FastDynamo.exists_unique_isIdealGroup_mainLiteralVelocity
-- The statement.
#print axioms FastDynamo.challenge_clauses_mainLiteralVelocity
#print axioms FastDynamo.challenge_statement_of_isIdealGroup
#print axioms FastDynamo.challenge_statement
