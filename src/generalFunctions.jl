"""
Define inner product

"""
function inner_product(a::Vector{ComplexF64}, b::Vector{ComplexF64})
    a = conj.(a) # take term-wise complex conjugate of each item in a (bra vector)

    sum(a .* b) # take term-wise product of each item in a and b and then sum it
end # function inner_product