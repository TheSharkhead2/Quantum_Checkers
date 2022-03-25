Base.include(Main, "./QuantumCheckers.jl")

using .Main.QuantumCheckers

using Colors

HEIGHT = 1200 
WIDTH = 1800
BACKGROUND = colorant"black"

initialQubitState = Complex.(zeros(5,5)) # empty state matrix 
initialQubitState[3, 3] = 1.0 # set initial state to have absolute position at 0,0 

qubit1 = Qubit(0, 0, copy(initialQubitState), Float64.(copy(initialQubitState))) # create qubit 1 
qubit2 = Qubit(0, 0, copy(initialQubitState), Float64.(copy(initialQubitState))) # create qubit 2

# define initial spin state of two qubits
initialSpinState = Complex.([
    0 
    1/(sqrt(2)) * 1 
    1/(sqrt(2)) * -1
    0
])

const N = 10000.0 # factor as affecting time increments

propagated = false # flag to indicate whether or not qubits have been propagated (to prevent NaN probabilities and maintain even propagation time) 

gameBoard = Checkers(initialSpinState, qubit1, qubit2) # create game board with qubits

spinStateLabel = TextActor("Spin State = ", "arialbd"; font_size=40, color=Int[255, 255, 255, 255])
spinStateLabel.pos = (900, 200)

spinState1 = TextActor("you don't see this", "ariali"; font_size=20, color=Int[255, 255, 255, 255])
spinState1.pos = (1160, 80)

spinState2 = TextActor("you don't see this", "ariali"; font_size=20, color=Int[255, 255, 255, 255])
spinState2.pos = (1160, 160)

spinState3 = TextActor("you don't see this", "ariali"; font_size=20, color=Int[255, 255, 255, 255])
spinState3.pos = (1160, 240)

spinState4 = TextActor("you don't see this", "ariali"; font_size=20, color=Int[255, 255, 255, 255])
spinState4.pos = (1160, 320)

# generate all probability text for qubit 1 
probabilitiesQubit1 = reshape([TextActor(" ", "ariali"; font_size=15, color=Int[255, 0, 0, 255]) for _ ∈ 1:25], (5,5)) # create 5x5 array of placeholder text elements

# set all positions for qubit 1 probabilities
for (indices, probabilityActor) ∈ pairs(probabilitiesQubit1)
    probabilityActor.pos = (52 + (indices[1]-1) * 150, 52 + (indices[2] - 1) * 150)
end # for 

# generate all probability text for qubit 2 
probabilitiesQubit2 = reshape([TextActor(" ", "ariali"; font_size=15, color=Int[0, 0, 255, 255]) for _ ∈ 1:25], (5,5)) # create 5x5 array of placeholder text elements

# set all positions for qubit 2 probabilities 
for (indices, probabilityActor) ∈ pairs(probabilitiesQubit2)
    probabilityActor.pos = (52 + (indices[1]-1) * 150, 180 + (indices[2] - 1) * 150)
end # for

function on_key_down(g::Game, key)
    global spinState1, spinState2, spinState3, spinState4
    global propagated
    global probabilitiesQubit1, probabilitiesQubit2
    if key == Keys.SPACE
        locate!(gameBoard.q1) # measure qubit 1
        locate!(gameBoard.q2) # measure qubit 2

        update_spin!(gameBoard) # update spin state

        propagated = false # reset propagated flag

        # update spin state text 
        spinState1 = TextActor("$(round(real(gameBoard.spinState[1]); sigdigits=4)) + $(round(imag(gameBoard.spinState[1]); sigdigits=4))i", "ariali"; font_size=20, color=Int[255, 255, 255 ,255])
        spinState1.pos = (1160, 80)
        spinState2 = TextActor("$(round(real(gameBoard.spinState[2]); sigdigits=4)) + $(round(imag(gameBoard.spinState[2]); sigdigits=4))i", "ariali"; font_size=20, color=Int[255, 255, 255 ,255])
        spinState2.pos = (1160, 160)
        spinState3 = TextActor("$(round(real(gameBoard.spinState[3]); sigdigits=4)) + $(round(imag(gameBoard.spinState[3]); sigdigits=4))i", "ariali"; font_size=20, color=Int[255, 255, 255 ,255])
        spinState3.pos = (1160, 240)
        spinState4 = TextActor("$(round(real(gameBoard.spinState[4]); sigdigits=4)) + $(round(imag(gameBoard.spinState[4]); sigdigits=4))i", "ariali"; font_size=20, color=Int[255, 255, 255 ,255])
        spinState4.pos = (1160, 320)

        # update probabilities text for qubit 1
        for (indices, probability) ∈ pairs(gameBoard.q1.P)
            probabilitiesQubit1[indices[1], indices[2]] = TextActor("$(round(probability; sigdigits=4))", "ariali"; font_size=15, color=Int[255, 0, 0, 255])
            probabilitiesQubit1[indices[1], indices[2]].pos = (52 + (indices[1]-1) * 150, 52 + (indices[2] - 1) * 150)
        end # for

        # update probabilities text for qubit 2
        for (indices, probability) ∈ pairs(gameBoard.q2.P)
            probabilitiesQubit2[indices[1], indices[2]] = TextActor("$(round(probability; sigdigits=4))", "ariali"; font_size=15, color=Int[50, 50, 255, 255])
            probabilitiesQubit2[indices[1], indices[2]].pos = (52 + (indices[1]-1) * 150, 180 + (indices[2] - 1) * 150)
        end # for

    end # if 
end # function on_key_down

function update()
    global propagated
    # propagate qubit states
    if !propagated
        timePassing = rand(2:2:20) # random even time between 2 and 20
        println("propagating qubits with ", timePassing, " time increments")
        gameBoard.q1.S = propagate(timePassing, N, gameBoard.q1.S)
        gameBoard.q2.S = propagate(timePassing, N, gameBoard.q2.S)
        propagated = true 
    end # if 

    # println(gameBoard.q1.S)
    # println(gameBoard.q2.S)
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

    # draw label for spin state 
    draw(spinStateLabel)

    # draw lines for spin state vector 
    draw(Line(1150, 70, 1150, 370), colorant"white")
    draw(Line(1350, 70, 1350, 370), colorant"white")

    # draw tiny aesthetic lines for spin state vector 
    draw(Line(1150, 70, 1155, 70), colorant"white")
    draw(Line(1150, 370, 1155, 370), colorant"white")
    draw(Line(1350, 70, 1345, 70), colorant"white")
    draw(Line(1350, 370, 1345, 370), colorant"white")

    # draw spin state vector components
    draw(spinState1)
    draw(spinState2)
    draw(spinState3)
    draw(spinState4)

    # draw probabilities for qubit 1
    for q1Prob ∈ probabilitiesQubit1
        draw(q1Prob)
    end # for

    # draw probabilities for qubit 2
    for q2Prob ∈ probabilitiesQubit2
        draw(q2Prob)
    end # for

end # function draw