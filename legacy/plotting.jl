



#= TODO: check if quiverplot can be used as plotting tool for search space
@recipe function search_structure(s0, trace::TraceLogger)
    V = compute_objectives(s0[2], trace.Δv, trace.accepted)
    R = rank_objectives(V)
    it = 1
    for (i,v) in enumerate(V)
        x = it
        y = R[v]
        if A[i]
            it+=1
        end

    end
end
=#




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