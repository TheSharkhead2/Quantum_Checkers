Base.include(Main, "./QuantumCheckers.jl")

using .Main.QuantumCheckers

using Colors

HEIGHT = 1200 
WIDTH = 1800
BACKGROUND = colorant"black"

initialQubitState = Complex.(zeros(5,5)) # empty state matrix 
initialQubitState[3, 3] = 1.0 # set initial state to have absolute position at 0,0 

qubit1 = Qubit(0, 0, copy(initialQubitState)) # create qubit 1 
qubit2 = Qubit(0, 0, copy(initialQubitState)) # create qubit 2

# define initial spin state of two qubits
initialSpinState = Complex.([
    0 
    1/(sqrt(2)) * 1 
    1/(sqrt(2)) * -1
    0
])

gameBoard = Checkers(initialSpinState, qubit1, qubit2) # create game board with qubits

function update()
    # println("update: ", time())
end # function update 

function draw()
    clear()
    
    # draw grid 
    lines = [Line(50, 50, 50, 800), Line(200, 50, 200, 800), Line(350, 50, 350, 800), Line(500, 50, 500, 800), Line(650, 50, 650, 800), Line(800, 50, 800, 800),
             Line(50, 50, 800, 50), Line(50, 200, 800, 200), Line(50, 350, 800, 350), Line(50, 500, 800, 500), Line(50, 650, 800, 650), Line(50, 800, 800, 800)]

    for line ∈ lines
        draw(line, colorant"white")
    end # for

    # draw qubits
    draw(Circle((gameBoard.q1.x + 2)*150 + 125, (gameBoard.q1.y + 2)*150 + 125, 50), colorant"red", fill=true)
    draw(Circle((gameBoard.q2.x + 2)*150 + 125, (gameBoard.q2.y + 2)*150 + 125, 50), colorant"blue", fill=true)

    

end # function draw