module QuantumCheckers

using StatsBase

include("objects.jl")

export Qubit, Checkers

include("propagation.jl")

export propagate, probabilities_propagation, locate!


end # module QuantumCheckers
