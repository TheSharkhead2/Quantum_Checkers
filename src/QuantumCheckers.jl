module QuantumCheckers

include("objects.jl")

export Qubit, Checkers

include("propagation.jl")

export propagate, probabilities_propagation


end # module QuantumCheckers
