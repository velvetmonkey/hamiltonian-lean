/-
  HamiltonianLean.Defs
  ====================
  Core definitions for Hamiltonian mechanics on ℝ × ℝ (one degree of freedom).

  We bundle:
  • The Hamiltonian H and its partial-derivative oracles ∂H/∂q, ∂H/∂p.
  • A trajectory (q, p) satisfying Hamilton's equations.
  • Calculus prerequisites (chain-rule, Clairaut symmetry) as hypotheses so that
    the downstream theorems are genuine algebraic proofs.
-/
import Mathlib

noncomputable section

open Real

/-! ### Hamiltonian Setup -/

/-- A complete Hamiltonian system on ℝ × ℝ with one degree of freedom.

Fields:
* `H`        — the Hamiltonian function on phase space (q, p).
* `dH_dq`, `dH_dp` — partial derivative oracles for H.
* `q`, `p`   — the trajectory components.
* `q'`, `p'` — time-derivatives of the trajectory.
* `hamilton_q`, `hamilton_p` — Hamilton's equations of motion.
* `energy_deriv` — chain-rule expansion for d/dt H(q(t), p(t)). -/
structure HamiltonianSetup where
  /-- The Hamiltonian H : ℝ × ℝ → ℝ. -/
  H     : ℝ × ℝ → ℝ
  /-- ∂H/∂q evaluated at a phase-space point. -/
  dH_dq : ℝ × ℝ → ℝ
  /-- ∂H/∂p evaluated at a phase-space point. -/
  dH_dp : ℝ × ℝ → ℝ
  /-- Position coordinate as a function of time. -/
  q     : ℝ → ℝ
  /-- Momentum coordinate as a function of time. -/
  p     : ℝ → ℝ
  /-- Time-derivative of q. -/
  q'    : ℝ → ℝ
  /-- Time-derivative of p. -/
  p'    : ℝ → ℝ
  /-- Hamilton's equation: q'(t) = ∂H/∂p(q(t), p(t)). -/
  hamilton_q : ∀ t : ℝ, q' t = dH_dp (q t, p t)
  /-- Hamilton's equation: p'(t) = −∂H/∂q(q(t), p(t)). -/
  hamilton_p : ∀ t : ℝ, p' t = -(dH_dq (q t, p t))
  /-- Chain rule: d/dt H(q(t),p(t)) = ∂H/∂q · q'(t) + ∂H/∂p · p'(t).
      This is a standard calculus fact bundled as data. -/
  energy_deriv : ∀ t : ℝ,
    HasDerivAt (fun t => H (q t, p t))
      (dH_dq (q t, p t) * q' t + dH_dp (q t, p t) * p' t) t

/-! ### Smooth function with partial derivatives -/

/-- A smooth real-valued function on phase space equipped with partial derivative oracles.
    Used for observables / first integrals. -/
structure SmoothObservable where
  /-- The function f : ℝ × ℝ → ℝ. -/
  f     : ℝ × ℝ → ℝ
  /-- ∂f/∂q. -/
  df_dq : ℝ × ℝ → ℝ
  /-- ∂f/∂p. -/
  df_dp : ℝ × ℝ → ℝ

/-! ### Poisson bracket -/

/-- The Poisson bracket of two observables on ℝ × ℝ:
    {f, g}(q, p) = (∂f/∂q)(∂g/∂p) − (∂f/∂p)(∂g/∂q). -/
def poissonBracket (f g : SmoothObservable) : ℝ × ℝ → ℝ :=
  fun z => f.df_dq z * g.df_dp z - f.df_dp z * g.df_dq z

/-- Extract a `SmoothObservable` from a `HamiltonianSetup`. -/
def HamiltonianSetup.toObservable (S : HamiltonianSetup) : SmoothObservable where
  f     := S.H
  df_dq := S.dH_dq
  df_dp := S.dH_dp

/-! ### Extended setup for first integrals -/

/-- A first-integral setup: a Hamiltonian system together with an observable F
    and its chain-rule expansion along the trajectory. -/
structure FirstIntegralSetup extends HamiltonianSetup where
  /-- The observable F. -/
  F : SmoothObservable
  /-- Chain rule: d/dt F(q(t),p(t)) = ∂F/∂q · q'(t) + ∂F/∂p · p'(t). -/
  F_deriv : ∀ t : ℝ,
    HasDerivAt (fun t => F.f (q t, p t))
      (F.df_dq (q t, p t) * q' t + F.df_dp (q t, p t) * p' t) t

/-! ### Liouville setup -/

/-- Setup for Liouville's theorem.  Bundles second-order partial derivatives
    and Clairaut symmetry, plus the Hamiltonian flow map and its Jacobian. -/
structure LiouvilleSetup extends HamiltonianSetup where
  /-- ∂²H/∂q∂p -/
  d2H_dqdp : ℝ × ℝ → ℝ
  /-- ∂²H/∂p∂q -/
  d2H_dpdq : ℝ × ℝ → ℝ
  /-- Clairaut's theorem: mixed partials are equal. -/
  clairaut : ∀ z : ℝ × ℝ, d2H_dqdp z = d2H_dpdq z
  /-- The Hamiltonian flow map φ_t : ℝ × ℝ → ℝ × ℝ. -/
  flow : ℝ → ℝ × ℝ → ℝ × ℝ
  /-- Jacobian determinant of the flow map. -/
  jacobian : ℝ → ℝ × ℝ → ℝ
  /-- At time 0 the Jacobian determinant is 1 (identity map). -/
  jacobian_zero : ∀ z : ℝ × ℝ, jacobian 0 z = 1
  /-- The time derivative of the Jacobian determinant equals
      (divergence of X_H) × jacobian.
      Since div X_H = ∂²H/∂q∂p − ∂²H/∂p∂q, this becomes
      (d2H_dqdp − d2H_dpdq)(flow t z) * jacobian t z. -/
  jacobian_deriv : ∀ (z : ℝ × ℝ) (t : ℝ),
    HasDerivAt (fun s => jacobian s z)
      ((d2H_dqdp (flow t z) - d2H_dpdq (flow t z)) * jacobian t z) t

end
