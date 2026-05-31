import Lake
open Lake DSL

require "leanprover-community" / "mathlib" @ git "v4.28.0"

package «HamiltonianLean» where

@[default_target]
lean_lib «HamiltonianLean» where
