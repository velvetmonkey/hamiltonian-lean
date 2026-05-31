# hamiltonian-lean

[![Lean 4](https://img.shields.io/badge/Lean-4.28.0-blue)](https://lean-lang.org/)
[![Mathlib](https://img.shields.io/badge/Mathlib-v4.28.0-purple)](https://github.com/leanprover-community/mathlib4)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Proofs](https://img.shields.io/badge/proofs-proven%20%2F%200%20sorry-brightgreen)](HamiltonianLean)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.20481428.svg)](https://doi.org/10.5281/zenodo.20481428)

**hamiltonian-lean: Formal Proofs for Hamiltonian Mechanics in Lean 4**

Lean 4 formal proofs for Hamiltonian mechanics on `ℝ × ℝ` with one degree of freedom. The development covers Hamilton's equations, Hamiltonian energy conservation, smooth observables, the Poisson bracket, first integrals, divergence-freeness of Hamiltonian vector fields, and Liouville volume preservation.

**Zero sorry statements.** Standard axioms only (`propext`, `Classical.choice`, `Quot.sound`).

## Why it matters

Hamiltonian mechanics is the geometric formulation of conservative classical mechanics. A Hamiltonian `H(q,p)` defines the dynamics through:

```text
q'(t) = ∂H/∂p(q(t), p(t))
p'(t) = -∂H/∂q(q(t), p(t))
```

These equations imply central conservation laws. The Hamiltonian itself is conserved along trajectories, observables whose Poisson bracket with `H` vanishes are first integrals, and the Hamiltonian flow preserves phase-space volume.

This library machine-checks those algebraic consequences in Lean 4. Calculus prerequisites such as chain-rule expansions and Clairaut symmetry are bundled as hypotheses in setup structures, while the downstream physical reasoning is proved from those hypotheses.

## Setting

The library works on phase space `ℝ × ℝ`. A `HamiltonianSetup` contains:

- a Hamiltonian `H : ℝ × ℝ -> ℝ`;
- partial derivative oracles `dH_dq` and `dH_dp`;
- a trajectory `(q, p) : ℝ -> ℝ × ℝ`;
- derivative oracles `q'` and `p'`;
- Hamilton's equations;
- a chain-rule hypothesis for `d/dt H(q(t), p(t))`.

`SmoothObservable` packages a phase-space observable with its partial derivatives. The Poisson bracket is:

```text
poissonBracket F G z =
  F_q z * G_p z - F_p z * G_q z
```

`FirstIntegralSetup` extends the Hamiltonian setup with an observable and its chain-rule data. `LiouvilleSetup` extends it with mixed second partials, Clairaut symmetry, a Hamiltonian flow map, and its Jacobian determinant.

## Main results

Energy conservation:

```text
HasDerivAt (fun t => H(q(t), p(t))) 0 t
```

First integral criterion:

```text
{F, H} = 0 everywhere
---------------------
HasDerivAt (fun t => F(q(t), p(t))) 0 t
```

Liouville theorem:

```text
jacobian t z = 1
```

## Project structure

```text
HamiltonianLean/
├── Defs.lean         — HamiltonianSetup, SmoothObservable,
│                       poissonBracket, FirstIntegralSetup,
│                       LiouvilleSetup
├── Conservation.lean — energy conservation, Poisson self-bracket,
│                       first integrals
└── Liouville.lean    — divergence-free Hamiltonian vector field,
                        Liouville theorem
HamiltonianLean.lean  — Root module
```

## Theorem inventory

| # | Name | Statement |
|---|------|-----------|
| 1 | `hamilton_energy_conservation` | Along a Hamiltonian trajectory, `HasDerivAt (fun t => S.H (S.q t, S.p t)) 0 t` |
| 2 | `poisson_bracket_self_zero` | For any observable `obs`, `poissonBracket obs obs z = 0` |
| 3 | `hamilton_first_integral` | If `poissonBracket I.F I.toHamiltonianSetup.toObservable z = 0` for all `z`, then `HasDerivAt (fun t => I.F.f (I.q t, I.p t)) 0 t` |
| 4 | `hamiltonian_divergence_free` | For a Liouville setup, `L.d2H_dqdp z - L.d2H_dpdq z = 0` |
| 5 | `liouville_theorem` | For a Liouville setup, `L.jacobian t z = 1` |

## Dependencies

- Lean 4.28.0
- Mathlib v4.28.0

## Related work

- [barbalat-lean](https://github.com/velvetmonkey/barbalat-lean) — Lean 4 Barbalat and Lyapunov-Barbalat convergence
- [lyapunov-odes-lean](https://github.com/velvetmonkey/lyapunov-odes-lean) — Lean 4 Lyapunov arguments for ODEs
- [lotka-volterra-lean](https://github.com/velvetmonkey/lotka-volterra-lean) — Lean 4 population dynamics invariants
- [kuramoto-lean](https://github.com/velvetmonkey/kuramoto-lean) — Lean 4 finite-N synchronisation dynamics

## Acknowledgements

Proofs in this library were generated using [Aristotle](https://aristotle.harmonic.fun), an AI proof assistant for Lean 4 and Mathlib. The proof discipline — zero sorry, standard axioms only — was specified by the author and enforced by the Lean type checker.

## Author

Ben Cassie · [@thevelvetmonke](https://x.com/thevelvetmonke)
