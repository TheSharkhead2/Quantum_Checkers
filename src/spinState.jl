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

end # function update_spin!

