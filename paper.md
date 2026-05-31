# hamiltonian-lean: Formal Proofs of Hamiltonian Mechanics and Liouville's Theorem in Lean 4

Ben Cassie  
ORCID: 0009-0004-1899-7627  
2026-06-01

## Abstract

`hamiltonian-lean` is a Lean 4 / Mathlib library formalising core algebraic consequences of Hamiltonian mechanics on phase space `Real x Real` for one degree of freedom. The development packages Hamilton's equations, chain-rule hypotheses, smooth observables, the Poisson bracket, first integrals, mixed partial symmetry, Hamiltonian flow Jacobians, and proves energy conservation, first-integral conservation, divergence-freeness of Hamiltonian vector fields, and Liouville's theorem. The proof method separates calculus prerequisites into setup structures and machine-checks the downstream Hamiltonian algebra. The formal development contains zero `sorry`, zero `admit`, and uses standard Lean/Mathlib axioms only.

## 1. Introduction

Hamiltonian mechanics describes conservative dynamics through a scalar Hamiltonian function `H(q,p)`. For a single degree of freedom, the state is a point of phase space `Real x Real`, where `q` is position and `p` is momentum. The dynamics are given by Hamilton's equations:

```text
q'(t) = dH/dp(q(t), p(t))
p'(t) = -dH/dq(q(t), p(t)).
```

These equations immediately imply several classical structural facts. The Hamiltonian is conserved along its own flow. Any observable whose Poisson bracket with the Hamiltonian vanishes is a first integral. The Hamiltonian vector field is divergence-free when mixed partial derivatives agree. Consequently, Hamiltonian flow preserves phase-space volume, the content of Liouville's theorem.

The repository formalises these results in Lean 4. It does not attempt to derive all analytic regularity from a differentiability hierarchy. Instead, it bundles the needed chain-rule expansions, mixed partial symmetry, and Jacobian evolution equation as hypotheses, then proves the Hamiltonian consequences from those assumptions.

## 2. Mathematical Setting

The core structure `HamiltonianSetup` contains a Hamiltonian

```text
H : Real x Real -> Real
```

partial derivative oracles `dH_dq` and `dH_dp`, a trajectory `q, p : Real -> Real`, derivative oracles `q'` and `p'`, Hamilton's equations, and the chain-rule identity for `d/dt H(q(t),p(t))`.

The structure `SmoothObservable` packages an observable `f : Real x Real -> Real` together with partial derivative oracles `df_dq` and `df_dp`. The Poisson bracket is defined by

```text
poissonBracket f g z =
  f.df_dq z * g.df_dp z - f.df_dp z * g.df_dq z.
```

`FirstIntegralSetup` extends `HamiltonianSetup` with an observable `F` and a chain-rule identity for `F(q(t),p(t))`. `LiouvilleSetup` extends the Hamiltonian setup with mixed second partials, Clairaut symmetry, a flow map, a Jacobian determinant, the initial condition `jacobian 0 z = 1`, and the standard Jacobian evolution equation.

## 3. Main Theorems

The conservation module proves energy conservation:

```text
hamilton_energy_conservation:
  HasDerivAt (fun t => S.H (S.q t, S.p t)) 0 t.
```

It also proves antisymmetry in the special self-bracket case:

```text
poisson_bracket_self_zero:
  poissonBracket obs obs z = 0.
```

The first-integral theorem states:

```text
hamilton_first_integral:
  (forall z, poissonBracket I.F I.toHamiltonianSetup.toObservable z = 0)
  -> HasDerivAt (fun t => I.F.f (I.q t, I.p t)) 0 t.
```

The Liouville module proves that the Hamiltonian vector field is divergence-free:

```text
hamiltonian_divergence_free:
  L.d2H_dqdp z - L.d2H_dpdq z = 0.
```

The final theorem is Liouville's theorem:

```text
liouville_theorem:
  L.jacobian t z = 1.
```

## 4. Proof Sketch

The energy-conservation proof expands the chain-rule hypothesis:

```text
dH/dt = dH/dq * q' + dH/dp * p'.
```

Hamilton's equations replace `q'` by `dH/dp` and `p'` by `-dH/dq`. The two products cancel by commutativity of multiplication, and Lean closes the algebraic goal by ring normalization.

The first-integral proof is the same calculation with an arbitrary observable `F`. After applying its chain-rule hypothesis and Hamilton's equations, the derivative becomes exactly the Poisson bracket `{F,H}` evaluated along the trajectory. The theorem assumes this bracket vanishes everywhere, so the derivative is zero.

For Liouville's theorem, the divergence of the Hamiltonian vector field is represented as `d2H_dqdp - d2H_dpdq`. Clairaut symmetry makes this quantity zero. The Jacobian evolution equation then says that the time derivative of the Jacobian determinant is zero. Since the Jacobian is `1` at time `0`, it is identically `1`.

## 5. Relation to Sibling Libraries

`hamiltonian-lean` belongs to the dynamical-systems side of the Lean proof suite. `kuramoto-lean`, DOI `10.5281/zenodo.20468619`, formalises finite-N synchronisation dynamics and Lyapunov-style identities. `lotka-volterra-lean`, DOI `10.5281/zenodo.20474669`, treats population dynamics and invariants. `lyapunov-odes-lean`, DOI `10.5281/zenodo.20475912`, and `lasalle-lean`, DOI `10.5281/zenodo.20476034`, provide general stability and invariance-principle patterns. `barbalat-lean`, DOI `10.5281/zenodo.20480607`, proves another route from differential inequalities to asymptotic conclusions.

The present repository is complementary: rather than proving convergence to an attractor, it proves conservation and volume preservation. Together these libraries cover dissipative and conservative proof patterns for finite-dimensional dynamics.

## 6. Conclusion

`hamiltonian-lean` provides a compact Lean 4 formalisation of Hamiltonian mechanics on `Real x Real`. It defines Hamiltonian systems, observables, the Poisson bracket, first-integral setups, and Liouville setups, then proves energy conservation, first-integral conservation, divergence-freeness, and Liouville's theorem. Future work could extend the development to `Real^n x Real^n`, formalise symplectic forms directly, and connect the bundled calculus assumptions to Mathlib differentiability theorems.

## References

Arnold, V. I. (1989). *Mathematical Methods of Classical Mechanics*. Springer.

Marsden, J. E. and Ratiu, T. S. (1999). *Introduction to Mechanics and Symmetry*. Springer.

The Mathlib Community. (2024). *The Lean Mathematical Library*. GitHub repository. <https://github.com/leanprover-community/mathlib4>

Cassie, B. (2026). *kuramoto-lean: A Sorry-Free Lean 4 Library for Finite-N Kuramoto Synchronisation Dynamics*. Zenodo. <https://doi.org/10.5281/zenodo.20468619>

Cassie, B. (2026). *lotka-volterra-lean: Formal Proofs of Hamiltonian Conservation and Positive Invariance in Lean 4*. Zenodo. <https://doi.org/10.5281/zenodo.20474669>

Cassie, B. (2026). *lyapunov-odes-lean*. Zenodo. <https://doi.org/10.5281/zenodo.20475912>

Cassie, B. (2026). *lasalle-lean*. Zenodo. <https://doi.org/10.5281/zenodo.20476034>

Cassie, B. (2026). *barbalat-lean: Formal Proofs of Barbalat's Lemma in Lean 4*. Zenodo. <https://doi.org/10.5281/zenodo.20480607>
