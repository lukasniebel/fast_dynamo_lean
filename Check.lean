module

public import FastDynamo

/-!
# Release surface

A curated tour of the development: the statement layer and the headline
theorems first, then the principal endpoint of each layer, top down, then
the proof route and the dynamical half of Theorem 1.2, then the resistive
semigroup of Appendix A, the ideal induction equation in weak form and the
vanishing-diffusivity limit of Remark 1.7, and last Theorem 1.2 in the form of
the Challenge statement (`Challenge.lean`).  This is not a log of everything
that is proved — that is `FastDynamo/AxiomAudit.lean`, which inspects all 1114
audited declarations.
The purpose here is to let a reader see, in one screen per layer, what the
library proves and how the layers connect to one another.

`scripts/audit.sh` elaborates this file with `-D warningAsError=true`, so it
doubles as the warning-clean smoke test of the public API: this file is outside
the Lake library, so that step is the only one that compiles it, and there every
warning — `declaration uses 'sorry'` included — is an error.  The gate also
requires every `#check`ed name below to appear in
`scripts/audited-declarations.txt`, hence to carry a `#print axioms` report; the
sections here follow the sections there.  The `#print` commands interleaved with
the `#check`s of statement-level definitions and structures are not cross-checked
against that list: they are there so that a reader of this file alone sees the
conjunction each such statement abbreviates.
-/

-- --------------------------------------------------------------------------
-- 1. Statement layer and main theorem
-- --------------------------------------------------------------------------

-- The reduced-operator target the global construction has to deliver.  `#check`
-- on a `def … : Prop` prints only `: Prop`, so each statement-layer constant is
-- also `#print`ed: the conjunction a reader has to trust is then visible here.
#check FastDynamo.MainReducedTarget
#print FastDynamo.MainReducedTarget
-- The spectral half of the paper's Theorem 1.2, spelled out clause by clause.
#check FastDynamo.MainPhysicalConclusion
-- Statement-level reduction: the reduced target already implies every clause.
#check FastDynamo.mainPhysicalConclusion_of_mainReducedTarget
-- Headline 1: the reduced-operator target is proved.
#check FastDynamo.mainReducedTarget_holds
-- Headline 2: the spectral half of Theorem 1.2 holds.
#check FastDynamo.mainPhysicalConclusion_holds
-- The same statement under the name `main_theorem_spectral`.
#check FastDynamo.main_theorem_spectral
-- The per-diffusivity clauses, separated from the outer existentials.
#check FastDynamo.MainReducedClauses
#check FastDynamo.MainPhysicalClauses
-- The strengthened statement: explicit witnesses, explicit bounds, the growth-rate
-- clause, the semigroup orbit and the unique solution of the real datum, every admissible
-- cell, normalisation, velocity regularity, literal three-torus.
#check FastDynamo.MainTheoremStrengthened
#print FastDynamo.MainTheoremStrengthened
-- Headline 3: the strengthened statement holds.
#check FastDynamo.main_theorem_strengthened
-- The growth floor equals `Re(centre Γ) − radius Γ` and is at least 288.
#check FastDynamo.mainGrowthFloor_eq
#check FastDynamo.mainGrowthFloor_ge_numeric
-- Proposition 7.1 in eigenpair form at every admissible cell index of the chain.
#check FastDynamo.MainEveryAdmissibleCellClauses
#check FastDynamo.mainEveryAdmissibleCellClauses_holds
#check FastDynamo.exists_growing_eigenpair_of_admissible_index
-- The spectral half of the theorem with a velocity of `W^{1,∞}` norm at most one ...
#check FastDynamo.mainPhysicalConclusionNormalized_holds
-- ... realised by the named witness `normalizedVelocity mainVelocity`.
#check FastDynamo.mainPhysicalClauses_normalizedVelocity
-- The chart-side representative of the velocity is differentiable, smooth off the
-- accumulation point, Lipschitz, and not C¹.
#check FastDynamo.mainVelocityChartRepresentative_qualitative
-- Its `ℤ²`-periodisation is what the torus-side representative pulls back to, at
-- every point of the plane, and it is not C¹ either.
#check FastDynamo.mainVelocityTorusRepresentative_transverseTorusPoint_eq_periodized
#check FastDynamo.not_continuousAt_fderiv_mainVelocityPeriodizedRepresentative
-- The magnetic clauses on the literal three-torus, stated inside `L²(Torus 3)`: the norm law
-- of the transported real trajectory, whose complexification is the orbit of the transported
-- real datum under the induction semigroup on `L²_σ(Torus 3; ℂ³)`.
#check FastDynamo.MainLiteralTorusClauses
#print FastDynamo.MainLiteralTorusClauses
#check FastDynamo.mainLiteralTorusClauses_holds
-- `cor:magnetic-scale` at the theorem's witnesses: `|K_ε| ≍ ε^{-1/2}` and `L_B ≍ √ε`, with two
-- constants and the spectral clauses of the theorem at every `0 < ε ≤ ε₀`.
#check FastDynamo.main_theorem_magnetic_scale
-- The definitions of §1.1: `u` is a dynamo at `ε` when `γ(u, ε) > 0`, a fast dynamo when
-- `liminf_{ε ↓ 0} γ(u, ε) > 0`, a slow dynamo when `γ(u, ε) > 0` for small `ε` but
-- `γ(u, ε) → 0` ...
#check FastDynamo.IsDynamoAt
#print FastDynamo.IsDynamoAt
#check FastDynamo.IsFastDynamo
#print FastDynamo.IsFastDynamo
#check FastDynamo.IsSlowDynamo
#print FastDynamo.IsSlowDynamo
-- ... and the constructed velocity is a fast dynamo.
#check FastDynamo.isFastDynamo_mainVelocity
-- Theorem 1.2 for the normalised velocity `ũ = u / max {1, ‖u‖_{W^{1,∞}}}` (Remark 1.6),
-- with every clause: spectral, growth rate, semigroup orbit and solution, dynamical.
#check FastDynamo.MainTheoremNormalized
#print FastDynamo.MainTheoremNormalized
#check FastDynamo.mainTheoremNormalized_holds

-- --------------------------------------------------------------------------
-- 2. Finish layer: reduced eigenpair to real strong solution
-- --------------------------------------------------------------------------

-- The bundle recording a real, divergence-free, growing strong solution.
#check FastDynamo.RealStrongModeCertificate
-- Every reduced eigenpair with positive real part yields such a certificate.
#check FastDynamo.realStrongModeCertificate_of_reducedEigenpair
-- The realified H² curve solves the physical (curl-form) induction equation.
#check FastDynamo.realifiedEigenTrajectoryH2_isPhysicalStrongSolution
-- Exact norm law ‖B(t)‖ = e^{t Re λ} ‖B_in‖ at every real time.
#check FastDynamo.norm_realAxialTrajectory
-- The real curve never vanishes.
#check FastDynamo.realAxialTrajectory_ne_zero
-- Uniform lower bound e^{t γ₀} ‖B_in‖ ≤ ‖B(t)‖ for t ≥ 0.
#check FastDynamo.realAxialTrajectory_norm_lower_bound
-- Auxiliary solenoidality: axially independent unstable modes are solenoidal.
#check FastDynamo.axiallyIndependent_eigenpair_solenoidal
-- ... so the auxiliary eigenmode is divergence free.
#check FastDynamo.productInductionEigenpair_solenoidal
-- Magnetic-length lower bound from the stretching energy inequality.
#check FastDynamo.complexAxialMagneticLength_lower_of_energy
-- Sharpness: with negative diffusivity a growing non-solenoidal mode exists.
#check FastDynamo.exists_positive_nonsolenoidal_eigenpair_of_negative_diffusivity
-- Remark 1.5 (`rem:scope-intro`): the mode, the real datum and the real solution have zero
-- spatial mean ...
#check FastDynamo.hasZeroMean_realifiedEigenTrajectoryH2
-- ... and Remark 1.4: if `Im λ ≠ 0`, the real part of the mode is not an eigenmode.
#check FastDynamo.not_isEigenpair_productRealPartH2

-- --------------------------------------------------------------------------
-- 3. Whole-plane elliptic regularity
-- --------------------------------------------------------------------------

-- H² elliptic regularity for the flat whole-plane Laplacian.
#check FastDynamo.exists_wholePlaneH2_of_laplacian_eq_l2

-- --------------------------------------------------------------------------
-- 4. Parametrix and Riesz calculus
-- --------------------------------------------------------------------------

-- The results of this layer are checked in section 9, in the order of the proof route.

-- --------------------------------------------------------------------------
-- 5. Global velocity, placement and parameters
-- --------------------------------------------------------------------------

-- The geometric scale family covering every small diffusivity.
#check FastDynamo.exists_scale_selection
-- Each diffusivity is matched by a scale ...
#check FastDynamo.ScaleFamily.exists_matching_scale
-- ... realised by a matching cell of the family ...
#check FastDynamo.ScaleFamily.exists_matchingCell
-- ... whose core embeds in the torus through a placement chart.
#check FastDynamo.ScaleFamily.TorusCellPlacement.exists_matchingCell_with_torusPlacedCore
-- The placement chart is injective where it is used.
#check FastDynamo.transverseTorusPoint_injectiveOn_placementChart
-- Transport of whole-plane H² data to the torus ...
#check FastDynamo.TorusChartH2.wholePlaneChartToTransverseH2
-- ... intertwining the transverse Laplacian.
#check FastDynamo.TorusChartH2.transverseLaplacianFromH2_wholePlaneChartToTransverseH2
-- The concrete global velocity as a W¹,∞ field on the torus ...
#check FastDynamo.ScaleFamily.TorusCellPlacement.FullVelocityConcrete.parameterizedFullGlobalW1Inf
-- ... is nonzero.
#check FastDynamo.ScaleFamily.TorusCellPlacement.FullVelocityConcrete.parameterizedFullGlobalW1Inf_ne_zero

-- --------------------------------------------------------------------------
-- 6. Local seed and Bessel functions
-- --------------------------------------------------------------------------

-- The order-zero Wronskian identity for the modified Bessel functions.
#check FastDynamo.ModifiedBessel.orderZeroWronskian_eq_one_div
-- The Ponomarenko dispersion function in closed Bessel form.
#check FastDynamo.ModifiedBessel.ponomarenkoDispersion_eq_neg_two_div_mul_deriv_I1_mul_K1
-- The scale ratios the seed requires exist.
#check FastDynamo.LocalSeedParameters.exists_scaleRatios

-- --------------------------------------------------------------------------
-- 7. Operators
-- --------------------------------------------------------------------------

-- The reduced axial induction operator, written out.
#check FastDynamo.reducedInductionAction_apply
-- Eigenpairs of the fixed axial sector are eigenpairs of the reduction.
#check FastDynamo.fixedSectorInductionEigenpair_iff
-- The axial lift turns reduced eigenpairs into auxiliary ones ...
#check FastDynamo.productInductionEigenpair_axialLiftH2_iff_reduced
-- ... and auxiliary eigenpairs into physical (curl-form) ones.
#check FastDynamo.productInductionEigenpair_to_physical
-- The Riesz projection attached to a resolvent contour.
#check FastDynamo.HasResolventOn.rieszProjection
-- An eigenpair generates a strong solution of the abstract evolution equation.
#check FastDynamo.DomainOperator.isStrongSolution_eigenTrajectory
-- The spectral circle used throughout stays right of the growth floor.
#check FastDynamo.SpectralCircle.growthFloor_le_re
-- The spectrum of a partially defined operator: the points where `z − T` has no bounded
-- two-sided inverse (Appendix A).
#check FastDynamo.LinearPMap.spectrum
-- The resolvent of a domain operator is holomorphic on its (open) resolvent set.
#check FastDynamo.DomainOperator.analyticOnNhd_inverse_pencil
-- The embedding `H²(T² × T) ↪ L²(T² × T)` is compact.
#check FastDynamo.isCompactOperator_productH2Embedding

-- --------------------------------------------------------------------------
-- 8. Analysis and Fourier foundations
-- --------------------------------------------------------------------------

-- Fourier analysis/synthesis on the transverse torus.
#check FastDynamo.transverseScalarFourierAnalysis_synthesis
-- The transverse H² space embeds injectively into L².
#check FastDynamo.transverseH2Embedding_injective
-- So does the product (torus × axial) H² space.
#check FastDynamo.productH2Embedding_injective
-- Divergence freedom in Fourier coordinates.
#check FastDynamo.productDivergenceFromH2_eq_zero_iff
-- Compactness of the L² section operator (the Rellich input).
#check FastDynamo.isCompactOperator_l2SectionOperator
-- Realification commutes with the complexified embedding.
#check FastDynamo.complexifyProductR3L2_realPartL2
-- Semigroup realisation: an eigenpair's orbit grows at its own rate.
#check FastDynamo.DomainOperatorSemigroupRealization.eigenpair_orbit_and_growth
-- Uniqueness of forward strong solutions of the reduced induction operator.
#check FastDynamo.reducedInductionOperator_forwardStrongSolutionsUnique
-- The a priori energy bound behind it: growth at most e^{‖∇⊥ u‖_∞ t}.
#check FastDynamo.DomainOperator.norm_embedding_le_exp_of_isForwardStrongSolution
-- An eigenvalue bounds the growth rate of a realising semigroup from below ...
#check FastDynamo.DomainOperatorSemigroupRealization.re_le_growthBound_of_eigenpair
-- ... and, with no semigroup at all, the growth floor on the operator domain.
#check FastDynamo.DomainOperator.re_le_strongSolutionGrowthFloor_of_eigenpair
-- At the main witnesses that floor is sandwiched: γ₀ ≤ γ_str(A_{ε,K}) ≤ ‖∇⊥ u‖_∞.
#check FastDynamo.mainGrowthFloor_le_strongSolutionGrowthFloor_le
-- The abstract Hille–Yosida theorem: a resolvent ray plus a dense domain generate a
-- C₀-semigroup realising the operator, with the exponential bound of the ray's constant.
#check FastDynamo.exists_stronglyContinuousSemigroup_of_hilleYosidaRay
-- The displayed formal adjoint is the Hilbert adjoint of the reduced operator.
#check FastDynamo.reducedInductionOperator_isAdjointRealization
-- The generation estimate it feeds: ‖(r - A_{ε,K})⁻¹‖ ≤ (r - ‖∇⊥u‖_∞)⁻¹ on the real ray.
#check FastDynamo.norm_stateResolvent_reducedInductionOperator_realRay_le
-- Uniqueness of forward strong solutions at the all-frequency (product) induction operator.
#check FastDynamo.productInductionOperator_forwardStrongSolutionsUnique
-- Uniqueness of the semigroup at the all-frequency (product) level: any semigroup realising
-- the product induction operator equals the constructed one.
#check FastDynamo.productInductionSemigroup_unique
-- The all-frequency induction operator generates a C₀-semigroup on the product L² space
-- which leaves the solenoidal subspace invariant; its restriction is transported to
-- L²_σ(T³; ℂ³), and γ(u, ε) is the growth bound of that semigroup.
#check FastDynamo.productInductionRealization
#check FastDynamo.gamma
-- Every solenoidal H² datum evolves along a curve that at every t ≥ 0 is a solenoidal H²
-- field solving the paper's curl-form induction equation curl(u × B) + εΔB in H⁻².
#check FastDynamo.productL2ToHMinus2_domainOrbit_eq_physical
-- The growth-rate clause of thm:main, γ(u, ε) ≥ γ₀ (whose liminf form is
-- eq:main-growth-conclusion), at the constructed velocity for every 0 < ε ≤ ε₀, with the
-- ceiling γ(u, ε) ≤ ‖∇⊥u‖_∞.
#check FastDynamo.gamma_ge_gamma0
#check FastDynamo.mainGrowthFloor_le_gamma_le_stretching
-- γ(u, ε) is the paper's limit lim_{t→∞} t⁻¹ log ‖e^{tL}‖ (`eq:semigroup-growth-rate`), in
-- `[−∞, ∞)`, for every divergence-free u and every ε > 0 ...
#check FastDynamo.gamma_tendsto
-- ... and at the constructed velocity it is a real number between γ₀ and ‖∇⊥u‖_∞, for every
-- 0 < ε ≤ ε₀.
#check FastDynamo.mainGrowthFloor_le_gamma_lim
-- "Its solution" of eq:main-thm-growth: the real datum B_in^ε = Re V^ε is the
-- initial state of a semigroup orbit, that orbit is the explicit real curve B^ε(t) ...
#check FastDynamo.realifiedEigenTrajectoryH2_isStrongSolution
#check FastDynamo.productInductionSemigroup_realifiedEigenTrajectoryH2
#check FastDynamo.solenoidalInductionSemigroup_realifiedEigenTrajectoryH2
-- ... and it obeys the exact growth law ‖e^{tL}B_in‖ = e^{t Re λ}‖B_in‖ on L²_σ.
#check FastDynamo.norm_solenoidalInductionSemigroup_realAxialOrbit
-- The orbit clauses, together with the uniqueness of the solution (section 11): every
-- solution of the curl-form equation with the real datum is that orbit and obeys the same
-- law; with the spectral clauses at the same triple, they are packaged as a field of the
-- strengthened theorem.
#check FastDynamo.MainSemigroupOrbitClauses
#check FastDynamo.mainSemigroupOrbitClauses_holds

-- --------------------------------------------------------------------------
-- 9. The proof route
-- The chain of the paper as it is traversed: the
-- two-component local seed, the parameter chain, the two-summand parametrix on
-- a selected cell, the global spectral transfer, the finish bridge, and the
-- statement layer of the dynamical half of Theorem 1.2 (proved in section 10).
-- --------------------------------------------------------------------------

-- `lem:jump-horizontal-mode`: the certified growing mode at `N = 2π`.
#check FastDynamo.HorizontalMode.exists_horizontalMode_eigenpair_two_pi
-- `prop:local-seed`: the two-component seed record and its inhabitant at `k_* = 1`.
#check FastDynamo.HorizontalMode.exists_localSeedC2_two_pi
#check FastDynamo.HorizontalMode.localSeedC2
#check FastDynamo.HorizontalMode.globalSeedInterface
-- §2.3: in the open right half-plane the spectrum of the horizontal operator `A_w` is the set
-- of its eigenvalues.
#check FastDynamo.HorizontalWeakForm.mem_horizontalSpectrum_iff
-- The parameter chain `q → τ → K₀` (the order of choices of §3.1), and the
-- chosen one.
#check FastDynamo.exists_globalParameterChoice
#check FastDynamo.HorizontalMode.mainParameterChoice
-- `lem:torus-sector-basic`: the two-component horizontal induction operator.
#check FastDynamo.horizontalInductionOperator_basic
-- `lem:exact-renormalization` (`eq:scaling`) in its two-component form on
-- `H²(ℝ²;ℂ²)`: `U_n⁻¹ A^{(n)}_{ε,n} U_n = 𝓛_{δ_n} − iτ`, as an eigenpair
-- equivalence ...
#check FastDynamo.exactScalingC2_eigenpair_iff
-- ... and in the direction that transports a selected eigenpair to the local one.
#check FastDynamo.exactScalingC2_selectedEigenpair_to_local
-- `prop:background-resolvent`: the background resolvent on the shifted contour ...
#check FastDynamo.ScaleFamily.TorusCellPlacement.BackgroundParameters.resolvent
-- ... holomorphic on an open neighbourhood of the shifted region (a clause the paper does not
-- state) ...
#check FastDynamo.ScaleFamily.TorusCellPlacement.BackgroundParameters.exists_isOpen_hasResolventOn_analyticOnNhd
-- ... and `cor:scaled-local-resolvents`, the rescaled seed resolvent on the same one.
#check FastDynamo.scaledLocalResolventOnShiftedContour
-- `lem:parametrix-error`: the two-summand parametrix identity
-- `(z − A_{ε,K_n})R_app(z) = id + E_n(z)` ...
#check FastDynamo.TorusTwoSummandParametrix.TwoSummandParametrixData.right_error_identity
-- ... and the norm bound on the error `E_n(z)` that makes it a parametrix.
#check FastDynamo.TorusParametrixError.norm_error_le
-- `lem:global-contour-resolvent`: `Γ_τ ⊂ ρ(A_{ε,K_n})` from the two-summand parametrix ...
#check FastDynamo.TorusChartC2Transfer.selectedCellGlobalContourResolvent
-- ... discharged at the constructed velocity.
#check FastDynamo.HorizontalMode.mainSelectedCellResolvent
-- `lem:global-riesz-nonzero`: the Riesz projection does not vanish at the placed witness.
#check FastDynamo.TorusGlobalRieszNonzero.rieszProjection_ne_zero_cell
-- `prop:global-spectral-transfer` at one selected cell ...
#check FastDynamo.TorusGlobalSpectralTransfer.exists_growing_reducedInduction_eigenpair_cell
-- ... and at every matching cell of the parameter chain.
#check FastDynamo.HorizontalMode.exists_growing_reducedInduction_eigenpair_matchingCell
-- `lem:axial-recovery`: the finish bridge from two to three components.
#check FastDynamo.exists_reducedInductionEigenpair_of_horizontalEigenpair
-- `lem:real-axial-mode` (`eq:real-part-norm`): `‖Re(e^{iφ}e^{2πiKx₃}b)‖² = ½‖b‖²` ...
#check FastDynamo.phaseAxialFieldL2_norm_sq
-- ... hence independent of the phase ...
#check FastDynamo.phaseAxialFieldL2_norm_sq_eq
-- ... and no phase can kill the real part of a nonzero mode.
#check FastDynamo.phaseAxialFieldL2_ne_zero
-- The three witnesses at the parameter chain: `u`, `ε₀ = δ₊/K₀²`, `γ₀ = g_* ≥ (3/4)(448 − 4π²)`.
#check FastDynamo.chainVelocity
#check FastDynamo.chainEps0_eq
#check FastDynamo.chainGrowthFloor
#check FastDynamo.chainGrowthFloor_ge_three_quarters
-- The statement layer of the dynamical half of Theorem 1.2 (its last sentence):
-- `h_top(Φ_t) = 0` and `lim t⁻¹ log ‖𝒯₀(t)‖ = 0`, one existential over `Φ`, `DΦ`, `T`, with
-- `∀ t, Continuous (Φ t)` alongside the entropy clause because the paper's `h_top` is
-- defined for continuous self-maps (§1.2) ...
#check FastDynamo.MainTheoremDynamicalClauses
#print FastDynamo.MainTheoremDynamicalClauses
#print FastDynamo.MainTheoremDynamical
-- ... projected from the Lagrangian bundle of `prop:particle-flow` + `cor:ideal-growth` ...
#check FastDynamo.MainLagrangianClauses
#print FastDynamo.MainLagrangianClauses
#print FastDynamo.MainTheoremLagrangian
#check FastDynamo.tendsto_inv_mul_log_opNorm_of_two_sided_bounds
#check FastDynamo.MainLagrangianClauses.toMainTheoremDynamicalClauses
-- ... and joined to the spectral half in `MainTheoremComplete`, three fields.
#check FastDynamo.MainTheoremComplete
#print FastDynamo.MainTheoremComplete
#check FastDynamo.mainTheoremComplete_of_lagrangian
-- ... and the growth gap `γ_id(u) = 0 < γ₀ ≤ liminf_{ε ↓ 0} γ(u, ε)`, which joins the last
-- clause of Theorem 1.2 to `eq:main-growth-conclusion`; the paper states it as no single result.
#check FastDynamo.HasVanishingIdealGrowthRate
#check FastDynamo.HasVanishingIdealOperatorGrowthRate
#check FastDynamo.ideal_resistive_gap
#check FastDynamo.ideal_resistive_gap_at_diffusivity

-- --------------------------------------------------------------------------
-- 10. The dynamical half of Theorem 1.2
-- The Lagrangian side: the particle flow in closed form, its entropy, its
-- Jacobian and the ideal induction group it transports, then the assembly at
-- the constructed velocity and the final theorems.
-- --------------------------------------------------------------------------

-- `prop:particle-flow`: the closed-form flow solves `d/dt Φ_t(x) = u(Φ_t(x))`
-- with `Φ_0 = id`, at the general parameters.
#check FastDynamo.ScaleFamily.TorusCellPlacement.isParticleFlow_literalFlow
-- ... and it is *the* flow: a Lipschitz velocity on `T³` has at most one particle flow
-- (the paragraph opening §4), by Grönwall on the periodic lifts ...
#check FastDynamo.IsParticleFlow.unique
-- ... hence `literalFlow` is the unique one at the general parameters ...
#check FastDynamo.ScaleFamily.TorusCellPlacement.literalFlow_unique
-- ... and `mainLiteralFlow` is the paper's `Φ_t` at the theorem's velocity.
#check FastDynamo.mainLiteralFlow_unique
#check FastDynamo.existsUnique_isParticleFlow_mainLiteralVelocity
-- Non-vacuity of the ideal clauses: the state space `L²_σ(T³;ℂ³)` is not the zero space ...
#check FastDynamo.exists_ne_zero_literalSolenoidalSubspace
-- ... so the per-datum rate `t⁻¹ log (‖𝒯₀(t)B‖/‖B‖) → 0` is asserted of a non-zero datum.
#check FastDynamo.exists_ne_zero_mainIdealGroup_rate
-- The Lipschitz-iterate criterion on `T³`: a map whose `m`-th iterate is `C(1 + m)`-Lipschitz
-- has zero cover entropy (proved by a covering count; the proof of `prop:particle-flow` cites
-- the iterate formula and the Lipschitz entropy bound of Hasselblatt–Katok instead) ...
#check FastDynamo.coverEntropy_eq_zero_of_lipschitz_iterate
-- ... applied to every time map of the flow: `h_top(Φ_t) = 0`.
#check FastDynamo.ScaleFamily.TorusCellPlacement.coverEntropy_literalFlow_eq_zero
-- Liouville, pointwise from the closed formula: `Φ_t` preserves the volume of `Torus 3`.
#check FastDynamo.ScaleFamily.TorusCellPlacement.measurePreserving_literalFlow
-- Gradient orthogonality on the literal torus: `∫ ⟪∇w, B⟫ = 0` for every solenoidal `B`
-- and every `C¹` periodic test function `w` ...
#check FastDynamo.inner_gradient_eq_zero_of_mem_literalSolenoidalSubspace
-- ... which is what makes `L²_σ(T³)` invariant under the Cauchy transport, hence the
-- corestricted ideal group `𝒯₀(t) : L²_σ → L²_σ` ...
#check FastDynamo.ScaleFamily.TorusCellPlacement.idealGroup
-- ... a `C₀`-group with the Cauchy representation tying it to the flow.
#check FastDynamo.ScaleFamily.TorusCellPlacement.isIdealInductionGroup_idealGroup
-- The witnesses at the chain's parameters: `Φ` and `𝒯₀` of the theorem's own velocity.
#check FastDynamo.mainLiteralFlow
#check FastDynamo.mainIdealGroup
-- `MainLagrangianClauses` of the constructed velocity at every admissible parameter tuple.
#check FastDynamo.ScaleFamily.TorusCellPlacement.mainLagrangianClauses_literalVelocity
-- `eq:explicit-particle-flow` for the theorem's own flow, with the centre
-- speed g_n(0) = ℓ_n U + a_n (the sentence after it in `prop:particle-flow`) ...
#check FastDynamo.ScaleFamily.TorusCellPlacement.cellAxialSpeed_cellCenter
#check FastDynamo.mainLiteralFlow_eq_cell_of_mem_bufferDisk
-- ... and its fixed points: outside the cells (the buffer discs), on their boundaries, and on
-- the accumulation circle {p_∞} × T (the last sentence of `prop:particle-flow`).
#check FastDynamo.ScaleFamily.TorusCellPlacement.literalFlow_eq_self_of_forall_not_mem_bufferDisk
#check FastDynamo.mainLiteralFlow_eq_self_of_accumulationPoint
-- The optimal Lipschitz constant `Lip(F)` and the clause lim |t|⁻¹ log Lip(Φ_t) = 0
-- (`prop:particle-flow`), squeezed between the linear bound and its reciprocal.
#check FastDynamo.lipConst
#check FastDynamo.ScaleFamily.TorusCellPlacement.lipConst_literalFlow_le
#check FastDynamo.ScaleFamily.TorusCellPlacement.inv_flowLipschitzBound_le_lipConst_literalFlow
#check FastDynamo.tendsto_abs_inv_mul_log_lipConst_mainLiteralFlow
-- The two dynamical clauses at the named witnesses (the last sentence of `thm:main`).
#check FastDynamo.forall_hasZeroTopologicalEntropy_mainLiteralFlow
#check FastDynamo.hasVanishingIdealOperatorGrowthRate_mainLiteralVelocity
-- Headline 4: `prop:particle-flow` + `cor:ideal-growth` at the constructed velocity ...
#check FastDynamo.mainTheoremLagrangian_holds
-- ... and the dynamical half of Theorem 1.2 itself.
#check FastDynamo.mainTheoremDynamical_holds
-- Headline 5: Theorem 1.2 in full, all three fields.
#check FastDynamo.mainTheoremComplete_holds
-- The growth gap with no hypothesis: `γ_id(u) = 0 < γ₀ ≤ liminf_{ε ↓ 0} γ(u, ε)` ...
#check FastDynamo.ideal_resistive_gap_holds
-- ... and its sharper fixed-`ε` packaging, `γ₀ ≤ γ(u, ε)` at every `0 < ε ≤ ε₀`.
#check FastDynamo.ideal_resistive_gap_at_diffusivity_holds

-- --------------------------------------------------------------------------
-- 11. The resistive semigroup: §1.1 and Appendix A
-- The energy identity, the generator of the induction semigroup on L²_σ, Lemma A.1,
-- and the uniqueness of the solution of the induction equation.
-- --------------------------------------------------------------------------

-- `eq:energy-competition`: ½ d/dt ‖B‖² = Re ⟪B, (B·∇)u⟫ − ε‖∇B‖² along strong solutions.
#check FastDynamo.hasDerivAt_half_norm_sq_of_isForwardStrongSolution
-- The generator of a C₀-semigroup, and the semigroup is determined by it.
#check FastDynamo.StronglyContinuousSemigroup.generator
#check FastDynamo.StronglyContinuousSemigroup.ext_of_generator_eq
-- The generator of the induction semigroup on L²_σ is L_{ε,u} with domain H² ∩ L²_σ ...
#check FastDynamo.generator_solenoidalInductionSemigroup
-- ... whose values are the curl form curl(u × B) + εΔB, read in H⁻².
#check FastDynamo.productL2ToHMinus2_generator_solenoidalInductionSemigroup
-- Analytic semigroups, defined by a holomorphic extension to an open sector.
#check FastDynamo.IsAnalyticSemigroup
-- γ(u, ε) = sup Re σ(L_{ε,u}), and the supremum is attained at an eigenvalue.
#check FastDynamo.gamma_eq_iSup_re_spectrum
#check FastDynamo.exists_eigenvalue_re_eq_gamma
-- Lemma A.1 (`lem:semigroup-spectral-growth`) as one statement, for every divergence-free u
-- and every ε > 0: generation by L_{ε,u} on H² ∩ L²_σ, analyticity, compact resolvent,
-- compact semigroup, spectral mapping, γ(u, ε) = lim = sup Re σ(L_{ε,u}), attained.
#check FastDynamo.SemigroupSpectralGrowth
#print FastDynamo.SemigroupSpectralGrowth
#check FastDynamo.semigroupSpectralGrowth_holds
-- "Its solution" (`thm:main`): forward strong solutions of the curl-form equation are
-- unique ...
#check FastDynamo.productPhysicalInductionOperator_forwardStrongSolutionsUnique
-- ... and every one with datum in L²_σ is the semigroup orbit.
#check FastDynamo.productH2Embedding_eq_solenoidalInductionSemigroup_of_isForwardStrongSolution

-- --------------------------------------------------------------------------
-- 12. The ideal induction equation: weak form, existence, uniqueness
-- --------------------------------------------------------------------------

-- Weak solutions of ∂ₜB + (u·∇)B − (B·∇)u = 0 on [−T, T], tested against smooth periodic
-- fields, and solution groups on L²_σ: groups of operators all of whose orbits are weak
-- solutions.
#check FastDynamo.IsIdealWeakSolution
#print FastDynamo.IsIdealWeakSolution
#check FastDynamo.IsIdealSolutionGroup
#print FastDynamo.IsIdealSolutionGroup
-- `eq:flow-variational-equation`: DΦ_t = id + ∫₀ᵗ ∇u(Φ_s) DΦ_s ds, at every point and time.
#check FastDynamo.ScaleFamily.TorusCellPlacement.flowFDeriv_eq_one_add_integral
-- Existence: the Cauchy group 𝒯₀ is a solution group ...
#check FastDynamo.ScaleFamily.TorusCellPlacement.isIdealSolutionGroup_idealGroup
-- ... uniqueness: a weak solution vanishing at time 0 vanishes, so 𝒯₀ is the only one ...
#check FastDynamo.ScaleFamily.TorusCellPlacement.IsIdealWeakSolution.eq_zero
#check FastDynamo.ScaleFamily.TorusCellPlacement.IsIdealSolutionGroup.eq_idealGroup
-- ... in particular at the theorem's velocity: 𝒯₀ is *the* solution group.
#check FastDynamo.existsUnique_isIdealSolutionGroup_mainLiteralVelocity

-- --------------------------------------------------------------------------
-- 13. Remark 1.7: the vanishing-diffusivity limit
-- --------------------------------------------------------------------------

-- The Friedrichs commutator lemma on the literal torus: Σⱼ [∂ⱼJ_δ, vⱼ] → 0 uniformly on
-- compact sets as δ ↓ 0, for a Lipschitz, divergence-free velocity.
#check FastDynamo.tendsto_friedrichsCommutator
-- The resistive evolution e^{tL_{ε,u}}B of the theorem's velocity ...
#check FastDynamo.resistiveEvolution
-- ... converges to the ideal solution 𝒯₀(t)B as ε ↓ 0, uniformly in t ∈ [0, T].
#check FastDynamo.tendstoUniformlyOn_resistiveEvolution_mainIdealGroup

-- --------------------------------------------------------------------------
-- 14. Theorem 1.2 in the form of the Challenge statement
-- --------------------------------------------------------------------------

-- The definitions of `Challenge.lean`, repeated in `FastDynamo/Palomar/Statement.lean`, name
-- the library's objects: the solenoidal subspace `L2σ` is the library's `L²_σ(T³)` ...
#check FastDynamo.L2σ_eq_literalSolenoidalSubspace
-- ... and the Challenge's flows are the library's particle flows.
#check FastDynamo.isFlow_iff_isParticleFlow
-- The velocity is Lipschitz and divergence free in the Fourier sense.
#check FastDynamo.exists_lipschitzWith_mainLiteralVelocity
#check FastDynamo.isDivergenceFree_mainLiteralVelocity
-- For every ε > 0 an induction semigroup exists; for 0 < ε ≤ ε₀ there is an eigenmode ...
#check FastDynamo.exists_isInductionSemigroup_mainLiteralVelocity
#check FastDynamo.exists_eigenmode_mainLiteralVelocity
-- ... which gives, for every induction semigroup, the growth clause and the real solution.
#check FastDynamo.eigenmode_clauses
-- The flow exists, and every time map of every flow is continuous with zero entropy.
#check FastDynamo.exists_isFlow_mainLiteralVelocity
#check FastDynamo.forall_isFlow_mainLiteralVelocity_continuous_coverEntropy
-- The ideal equation has exactly one solution group, and t⁻¹ log ‖𝒯₀(t)‖ → 0.
#check FastDynamo.exists_unique_isIdealGroup_mainLiteralVelocity
-- Every clause but the ideal one at the witnesses, and the Challenge statement itself.
#check FastDynamo.challenge_clauses_mainLiteralVelocity
#check FastDynamo.challenge_statement
