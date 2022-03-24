module QuantumCheckers

using StatsBase
using LinearAlgebra

include("objects.jl")

export Qubit, Checkers

include("propagation.jl")

export propagate, probabilities_propagation, locate!

include("spinState.jl")

export update_spin!


end # module QuantumCheckers
