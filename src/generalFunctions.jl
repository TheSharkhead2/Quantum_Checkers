"""
Define inner product

"""
function inner_product(a::Vector{ComplexF64}, b::Vector{ComplexF64})
    a = conj.(a) # take term-wise complex conjugate of each item in a (bra vector)

    sum(a .* b) # take term-wise product of each item in a and b and then sum it
end # function inner_product

"""
Computer move logic

# Parameters
- gameBoard::Checkers
    - the game state
- updatingQubit::Int
    - Qubit left alone 1 or 2
- strat::String, optional 
    - "rand" --> randomly pick nothing, pauliX, pauliY, pauliZ
"""
function computer_move(gameBoard::Checkers, updatingQubit::Int; strat::String="rand")
    moveMapping = Dict(1=>"x", 2=>"y", 3=>"z", 4=>"I") # map move to pauli matrix or identity (do nothing)
    if strat == "rand"
        movePick = rand(1:4) # pick a random move 
    end # if 

    moveMapping[movePick] # get the pauli matrix corresponding to the move picked
end # function computer_move