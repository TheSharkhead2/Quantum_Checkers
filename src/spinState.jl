# define relevant operators 
const CNOT = [
    1 0 0 0; 
    0 1 0 0
    0 0 0 1;
    0 0 1 0;
]

const Swap = [
    1 0 0 0;
    0 0 1 0;
    0 1 0 0;
    0 0 0 1;
]

const Hadamard = (1/sqrt(2)) * [
    1 1;
    1 -1;
]

const I2 = [
    1 0;
    0 1;
]

const PauliX = [
    0 1;
    1 0;
]

const PauliY = [
    0 -1*im;
    1*im 0;
]

const PauliZ = [
    1 0;
    0 -1;
]

"""
Takes in a state immedietly after a position measurement and updates the spin 
state accordingly

"""
function update_spin!(gameBoard::Checkers)
    swapped = false # flag to indicate if qubits were swapped

    agreeCoord = false # flag to indicate if qubits agree on one of their coordinates (used for applying paulies)

    if ((gameBoard.q1.x == gameBoard.q2.x) || (gameBoard.q1.y == gameBoard.q2.y)) && !((gameBoard.q1.x == gameBoard.q2.x) && (gameBoard.q1.y == gameBoard.q2.y)) # if the qubits agree on 1 and only 1 coordinate
        if gameBoard.q1.x == gameBoard.q2.x # if it was the x coordinates that agreed 
            if gameBoard.q1.y < gameBoard.q2.y # if the first qubit has the lower value, swap required 
                gameBoard.spinState = Swap * gameBoard.spinState # swap spin state
                swapped = true # set swapped flag to true
            end # if  
        else # if it was the y coordinates that agreed
            if gameBoard.q1.x < gameBoard.q2.x # if the first qubit has the lower value, swap required 
                gameBoard.spinState = Swap * gameBoard.spinState # swap spin state
                swapped = true # set swapped flag to true
            end # if  
        end # if

        gameBoard.spinState = CNOT * gameBoard.spinState # apply CNOT gate to qubits (controlled by the one with the larger value )
        agreeCoord = true # set agreeCoord flag to true

    else # if they don't agree, pick a random qubit to be passed through an Hadamard gate 
        if rand() > 0.5 # 50% of the time, pick qubit 1 
            gameBoard.spinState = kron(Hadamard, I2) * gameBoard.spinState # apply Hadamard gate to qubit 1
        else # 50% of the time, pick qubit 2
            gameBoard.spinState = kron(I2, Hadamard) * gameBoard.spinState # apply Hadamard gate to qubit 2
        end # if
    end # if

    if swapped # if the qubits' spin was swapped, swap back
        gameBoard.spinState = Swap * gameBoard.spinState # swap spin state
    end # if

    if agreeCoord # if they agreed (CNOT was applied), then return integer 1 for qubit 1 was left alone and 2 for qubit 2 was left alone 
        if swapped # if they were swapped, qubit 1 was altered 
            return 2 # return qubit left alone 
        else # if they were not swapped, qubit 2 was altered
            return 1 # return qubit left alone 
        end # if
    else # if they didn't agree, return 0 to indicate player can't apply pauli on this position measurement
        return 0 # return qubit left alone 
    end # if

end # function update_spin!


"""
Measures spin of spin state with a specific pauli matrix being applied to either qubit 1 or qubit 2

# Parameters 
- gameBoard::Checkers 
    - the game state 
- pauliMatrix::String
    - "x", "y", or "z"
- qubit::Int
    - 1 or 2

"""
function measure_spin!(gameBoard::Checkers, pauliMatrix::String, qubit::Int)
    if pauliMatrix == "x" # if measuring the pauliX matrix
        if qubit == 1 # if applying to qubit 1
            observable = kron(PauliX, I2) # apply pauliX to qubit 1
        else # otherwise apply to qubit 2 
            observable = kron(I2, PauliX)
        end # if
    elseif pauliMatrix == "y"
        if qubit == 1 # if applying to qubit 1
            observable = kron(PauliY, I2) # apply pauliY to qubit 1
        else # otherwise apply to qubit 2 
            observable = kron(I2, PauliY)
        end # if
    else # if measuring the pauliZ matrix
        if qubit == 1 # if applying to qubit 1
            observable = kron(PauliZ, I2) # apply pauliZ to qubit 1
        else # otherwise apply to qubit 2 
            observable = kron(I2, PauliZ)
        end # if
    end # if

    eigenvectors = Complex.(eigvecs(observable)) # get eigenvectors of observable
    eigenvalues = eigvals(observable) # get eigenvalues of observable

    measurementProbabilities = Float64.([inner_product(eigenvectors[1:4, n], gameBoard.spinState)*inner_product(gameBoard.spinState, eigenvectors[1:4, n]) for n ∈ 1:4]) # get probabilities of measuring each eigenvalue this is: P(λᵢ) = ⟨A|λᵢ⟩⋅⟨λᵢ|A⟩ where A is the observable and λᵢ is the eigenvalue/vector

    indexes = [n for n ∈ 1:4] # get indexes of eigenvalues (easier to use because state needs to change to eigenvector)

    measuredSpin = sample(indexes, Weights(measurementProbabilities)) # sample the eigenvalue to measure based on probabilities

    gameBoard.spinState = eigenvectors[1:4, measuredSpin] # change spin state to eigenvector corresponding to measured spin

    eigenvalues[measuredSpin] # return -1 or +1 (the measured spin)

end # function measure_spin!