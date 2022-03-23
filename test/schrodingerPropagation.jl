include("../src/QuantumCheckers.jl")

using .QuantumCheckers

println(probabilities_propagation(0, 0, 2, 10.0))