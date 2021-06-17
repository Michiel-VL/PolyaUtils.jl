#= Permutation composition by aggregating on a specific base type is a WIP. Currently the  =#



############################################################################
## Permutation Base ##
##########################
abstract type PermutationOperator end
"""

"""
struct Permutation <: PermutationOperator 
    repr::Vector{Tuple{Int,Int}}
    n::Int
end

# Accessors

# Constructor

function Permutation(v::Vector{Int})
    inner = Tuple{Int,Int}[]
    for (i,e) in enumerate(v)
        if i != e
            push!(inner,(i, e))
        end
    end
    Permutation(inner, length(v))
end

# Vector Interface
Base.size(p::Permutation) = (p.n,)
Base.length(p::Permutation) = p.n

function Base.getindex(p::Permutation, i)
    idx = findfirst(x->first(x) == i, p.repr)
    if isnothing(idx)
        return i
    else
        return last(p.repr[idx])
    end
end

# Functionality

function apply!(m::Permutation, s)
    k = 1
    p = m.repr
    while k <= length(m)
        i,e = p[k]

end



# Printing

function Base.show(io::IO, p::Permutation)
    v = [i for i in 1:length(p)]
    for (i,e) in p.repr
        v[i] = e
    end
    print(io, "Permutation", v)
end



############################################################################
## Permutation Identity ##
##########################

"""
    Identity <: PermutationOperator

Represents the identity-function.
"""
struct IdentityPermutation <: PermutationOperator end

# Accessors
ϕ(m::IdentityPermutation) = nothing

# Constructors

# Identity
identity(::Type{IdentityPermutation}) = IdentityPermutation()
isidentity(m::IdentityPermutation) = true

# inverse
inverse(m::IdentityPermutation) = m

# functionality
apply!(m::IdentityPermutation, s) = s


############################################################################
## Permutation Identity ##
##########################


# Operator application

A::AbstractVector * O::AbstractPermutation = apply!(A, O)
function *(P1::A, P2::A) where A <: AbstractPermutation

end

P1::Permutation * P2::Permutation = apply!(p1.cols, P2)


# Operator composition

# Operator printing

function Base.replace_in_print_matrix(
    A::AbstractPermutation,
    i::Integer,
    j::Integer,
    s::AbstractString
)
    A[i,j] ? s : Base.replace_with_center_mark(s)

end

printdense(A::AbstractPermutation) = println("$(typeof(A)) - $(ϕ(A))") 


struct Permutation{N} <: AbstractPermutation
    cols::Vector{Int}
    n::Int
end

# Constructors
Permutation(c::Vector{Int}) = Permutation(c, length(c))
Permutation(n::Int) = Permutation([i for i in 1:n], n)
# Array Interface
Base.size(p::Permutation) = (p.n, p.n)
Base.getindex(p::Permutation, i) = getindex(p, p.c[i])


Base.identity(::Type{Permutation}, n) = Permutation(n)


function Base.inv(p::Permutation)
    c = Vector{Int}(undef, p.n)
    for (i, e) in enumerate(p.cols)
        c[e] = i
    end
    return Permutation(c)
end

Base.transpose(p::Permutation) = inv(p)




# Constructors
# Array Interface
# Operations
    # application
    # identity
    # inverse
    # transpose
    # composition

