/-
  HamiltonianLean.Conservation
  ============================
  Conservation laws for Hamiltonian systems.

  * `hamilton_energy_conservation` — energy is constant along trajectories.
  * `poisson_bracket_self_zero`   — {H, H} = 0.
  * `hamilton_first_integral`     — if {F, H} = 0 then F is constant along trajectories.
-/
import HamiltonianLean.Defs

noncomputable section

open Real

/-! ## Energy conservation -/

/-
The time-derivative of the energy H(q(t), p(t)) along a Hamiltonian trajectory is zero.

Proof: by the chain rule and Hamilton's equations,
  dH/dt = ∂H/∂q · q' + ∂H/∂p · p'
        = ∂H/∂q · (∂H/∂p) + ∂H/∂p · (−∂H/∂q)
        = 0.
-/
theorem hamilton_energy_conservation (S : HamiltonianSetup) (t : ℝ) :
    HasDerivAt (fun t => S.H (S.q t, S.p t)) 0 t := by
  convert S.energy_deriv t using 1;
  rw [ S.hamilton_q, S.hamilton_p ] ; ring

/-! ## Poisson bracket of H with itself -/

/-
{H, H} = 0, since {H, H} = ∂H/∂q · ∂H/∂p − ∂H/∂p · ∂H/∂q = 0.
-/
theorem poisson_bracket_self_zero (obs : SmoothObservable) (z : ℝ × ℝ) :
    poissonBracket obs obs z = 0 := by
  unfold poissonBracket; ring;

/-! ## First integrals -/

/-
If the Poisson bracket {F, H} vanishes identically, then F is conserved
    along the Hamiltonian trajectory: d/dt F(q(t), p(t)) = 0.

Proof: by the chain rule and Hamilton's equations,
  dF/dt = ∂F/∂q · q' + ∂F/∂p · p'
        = ∂F/∂q · (∂H/∂p) + ∂F/∂p · (−∂H/∂q)
        = {F, H}
        = 0.
-/
theorem hamilton_first_integral (I : FirstIntegralSetup)
    (hPoisson : ∀ z : ℝ × ℝ,
      poissonBracket I.F I.toHamiltonianSetup.toObservable z = 0)
    (t : ℝ) :
    HasDerivAt (fun t => I.F.f (I.q t, I.p t)) 0 t := by
  convert I.F_deriv t using 1;
  rw [ ← hPoisson ];
  rw [ I.hamilton_q, I.hamilton_p ] ; ring_nf!;
  rfl

end