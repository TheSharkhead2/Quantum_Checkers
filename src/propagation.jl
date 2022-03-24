"""
Determines difference from previous location (x, y) to new location (u, v). 
Necessary as (-2, -2) is only a difference of (-1, -1) from (2, 2) (the grid
wraps itself). 

"""
function get_difference(x::Int, y::Int, u::Int, v::Int)
    noAdjustDiffX = u-x # get difference without wrapping X
    noAdjustDiffY = v-y # get difference without wrapping Y

    # we know difference can't be more than 2 in any direction
    if noAdjustDiffX < -2 
        diffX = 5 + noAdjustDiffX # adjust for wrapping around the other way 
    elseif noAdjustDiffX > 2 
        diffX = noAdjustDiffX - 5 # adjust for wrapping around the other way 
    else 
        diffX = noAdjustDiffX # no adjustment needed
    end

    if noAdjustDiffY < -2 
        diffY = 5 + noAdjustDiffY # adjust for wrapping around the other way
    elseif noAdjustDiffY > 2
        diffY = noAdjustDiffY - 5 # adjust for wrapping around the other way
    else 
        diffY = noAdjustDiffY # no adjustment needed
    end
    
    (diffX, diffY)

end # function get_difference

"""
Propagates Schrodinger equation across all points for k time increments

"""
function propagate(k::Int, N::Float64, S::Matrix{ComplexF64})
    if k == 0 # base case, 0 time has passed, probability of being in a certain location is the same as now (no time, no change)
        return S
    end # if

    previousStates = propagate(k-1, N, S) # get previous states at time step previous

    newStates = Complex.(zeros(size(S))) # create new matrix to store new states

    # loop through all grid locations 
    for u ∈ -2:2 
        for v ∈ -2:2
            newState = 0.0 # initialize state of u, v to be 0

            # loop through all previous states
            for j ∈ -2:2 
                for k ∈ -2:2 
                    # get x and y difference from this location 
                    (diffX, diffY) = get_difference(j, k, u, v) # u, v location you are moving to... j, k previous location

                    newState += previousStates[j+3, k+3] * exp((im * (diffX^2 + diffY^2) * N)/2) # add state from j, k, multipled by "propagation factor," to new state at u, v
                end # for
            end # for

            newStates[u+3, v+3] = newState # update new state at this location
        end # for 
    end # for 

    return newStates # return new states

end # function propagate

"""
Get probabilities of being at a location at an arbrirary state 

"""
function probabilities(S::Matrix{ComplexF64})
    nonAdjustedProbabilities = real.(conj.(S) .* S) # get probabilities not adjusted to add to 1 (convert to real as no longer need imaginary part, it will always be 0)

    sumProbabilities = sum(nonAdjustedProbabilities) # sum all probabilities to get scalar 

    nonAdjustedProbabilities ./ sumProbabilities # divide each probability by scalar to get probability of being in each location

end # function probabilities

"""
Propagates Schrodinger equation from initial fixed point (x, y) for k time increments. 
Returns matrix of probabilities for each possible new location

"""
function probabilities_propagation(x::Int, y::Int, k::Int, N::Float64)
    S = Complex.(zeros(5,5)) # create empty state matrix 
    S[x+3, y+3] = 1.0 # set initial fixed point to be 1 (known location)

    propagatedStates = propagate(k, N, S) # get propagated states 

    probabilities(propagatedStates) # get probabilities of being at all locations from this state

end # function probabilities_propagation

"""
Measures position of qubit based on current state and collapses the qubit's 
position state

"""
function locate!(q::Qubit)
    # get probabilities of being at each location 
    qubitProbabilities = probabilities(q.S)

    locations = [(k, j) for j ∈ 1:5 for k ∈ 1:5] # get all possible locations as tuples in order that julia collapses matrix 

    # convert probability matrix to vector 
    qubitProbabilities = vec(qubitProbabilities)

    location = sample(locations, Weights(qubitProbabilities)) # sample location based on probabilities

    q.x = location[1] - 3 # update qubit's x position
    q.y = location[2] - 3 # update qubit's y position

    qubitState = Complex.(zeros(5,5)) # empty state 
    qubitState[location[1], location[2]] = 1.0 # set new state to be 1 at new location (collapse qubit state to just this location) 

    q.S = qubitState # update qubit's state 

    q

end # function locate!