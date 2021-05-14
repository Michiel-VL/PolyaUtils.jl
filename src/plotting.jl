@recipe function operator_trace(trace::AbstractArray{<:Polya.AbstractOperator})
    x, y = align(ϕ.(trace))
    seriestype --> :scatter
    x, y
end

@recipe function operator_trace(N::Neighborhood)
    x, y = align(ϕ.(N))
    seriestype --> :scatter
    x, y
end

function align(Φ) 
    r = Int[]
    iterset = Int[]
    cnt = 1
    for el in Φ
        push!(r, el...)
        push!(iterset, ntuple(x->cnt, length(el))...)
        cnt+=1
    end
    return iterset, r
end




"""
    VarView{M}

Type to interpret series of operators as an induced change in the permutation
"""
struct VarView{M} <: AbstractMatrix{Int}
    sol_length::Int
    moves::Vector{M}
end

Base.size(v::VarView) = (v.sol_length, length(v.moves))
Base.getindex(v::VarView, i,j) = effect_move(v, j)[i]
function effect_move(v::VarView, i)
    V = collect(1:v.sol_length)
    apply!(v.moves[i], V)
    return map( x -> x[1] - x[2], Iterators.zip(V, 1:v.sol_length))
end

# TODO
# 1. VariablePlot

function asmatrix(iter, dims...)
    M = zeros(Int, dims...)
    for (i,e) in enumerate(iter)
        M[ϕ(e)...] = i
    end
    return M
end