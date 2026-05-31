/-
  HamiltonianLean.Liouville
  =========================
  Liouville's theorem for Hamiltonian systems.

  * `hamiltonian_divergence_free` — the Hamiltonian vector field is divergence-free.
  * `liouville_theorem`          — phase-space volume is preserved (Jacobian = 1).
-/
import HamiltonianLean.Defs

noncomputable section

open Real

/-! ## Divergence-free Hamiltonian vector field -/

/-
The divergence of the Hamiltonian vector field X_H = (∂H/∂p, −∂H/∂q) is
    ∂²H/∂q∂p − ∂²H/∂p∂q, which vanishes by Clairaut's theorem on the
    symmetry of mixed partial derivatives.
-/
theorem hamiltonian_divergence_free (L : LiouvilleSetup) (z : ℝ × ℝ) :
    L.d2H_dqdp z - L.d2H_dpdq z = 0 := by
  exact sub_eq_zero_of_eq <| L.clairaut z

/-! ## Liouville's theorem -/

/-
**Liouville's theorem**: the Jacobian determinant of the Hamiltonian flow is
    identically 1 for all time, so phase-space volume is preserved.

Proof sketch:
  d/dt det(Dφ_t) = div(X_H)(φ_t(z)) · det(Dφ_t)
  Since div(X_H) = 0 (by `hamiltonian_divergence_free`), the derivative is 0,
  and at t = 0 the Jacobian is 1, so it remains 1 for all t.
-/
theorem liouville_theorem (L : LiouvilleSetup) (z : ℝ × ℝ) (t : ℝ) :
    L.jacobian t z = 1 := by
  -- By definition of $L$, we know that its Jacobian determinant is constant.
  have h_const : ∀ t, L.jacobian t z = L.jacobian 0 z := by
    intro t;
    have h_const : ∀ t, deriv (fun s => L.jacobian s z) t = 0 := by
      intro t;
      exact HasDerivAt.deriv ( L.jacobian_deriv z t ) ▸ by simp +decide [ hamiltonian_divergence_free L ] ;
    exact is_const_of_deriv_eq_zero ( fun t => L.jacobian_deriv z t |> HasDerivAt.differentiableAt ) h_const t 0;
  rw [ h_const, L.jacobian_zero ]

end