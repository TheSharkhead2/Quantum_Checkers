"""
Qubit object 

"""
mutable struct Qubit 
    x::Int # represents last measured x position, x ∈ {-2, -1, 0, 1, 2}
    y::Int # represents last measured y position, y ∈ {-2, -1, 0, 1, 2}
end # struct Qubit

"""
The general game object

"""
mutable struct Checkers
    spinState::Vector{Float64} # represents combined spin state of qubits
    q1::Qubit # represents qubit 1
    q2::Qubit # represents qubit 2
end # struct Checkers