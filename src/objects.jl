"""
Qubit object 

"""
mutable struct Qubit 
    x::Int # represents last measured x position, x ∈ {-2, -1, 0, 1, 2}
    y::Int # represents last measured y position, y ∈ {-2, -1, 0, 1, 2}
    S::Matrix{ComplexF64} # represents state of qubit
    P::Matrix{Float64} # represents probability of being at each location for the last measurement (purely for display purposes)
end # struct Qubit

"""
The general game object

"""
mutable struct Checkers
    spinState::Vector{ComplexF64} # represents combined spin state of qubits
    q1::Qubit # represents qubit 1
    q2::Qubit # represents qubit 2
end # struct Checkers