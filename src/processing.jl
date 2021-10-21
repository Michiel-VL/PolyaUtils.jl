""" 
    convert_to_changes(s, M; drop_identities = false) # todo: change function-name

Given the initial state of the solution `s` and a list of accepted moves `M`, compute for each move in `M` which changes it induced on `s`, in terms of the index set of `s`. Put differently, this function computes what parts of a solution are changed throughout a search process defined by a sequence of moves `M`.

# Usage
```julia
julia> A
2×3 Matrix{Int64}:
 1  4  4
 5  4  1

julia> M = [s -> swap!(s, i, j) for i in 1:6, j in 1:6];

julia> convert_to_changes(A, M, drop_identities = false)
36-element Vector{Any}:
 Dict{Int64, Pair{Union{Nothing, Int64}, Union{Nothing, Int64}}}()
 Dict{Int64, Pair{Union{Nothing, Int64}, Union{Nothing, Int64}}}(2 => (5 => 1), 1 => (1 => 5))
 Dict{Int64, Pair{Union{Nothing, Int64}, Union{Nothing, Int64}}}(3 => (4 => 5), 1 => (5 => 4))
 Dict{Int64, Pair{Union{Nothing, Int64}, Union{Nothing, Int64}}}()
 Dict{Int64, Pair{Union{Nothing, Int64}, Union{Nothing, Int64}}}()
 Dict{Int64, Pair{Union{Nothing, Int64}, Union{Nothing, Int64}}}(6 => (1 => 4), 1 => (4 => 1))
 Dict{Int64, Pair{Union{Nothing, Int64}, Union{Nothing, Int64}}}()
 Dict{Int64, Pair{Union{Nothing, Int64}, Union{Nothing, Int64}}}()
 Dict{Int64, Pair{Union{Nothing, Int64}, Union{Nothing, Int64}}}(2 => (1 => 5), 3 => (5 => 1))
 Dict{Int64, Pair{Union{Nothing, Int64}, Union{Nothing, Int64}}}(4 => (4 => 5), 2 => (5 => 4))
 Dict{Int64, Pair{Union{Nothing, Int64}, Union{Nothing, Int64}}}()
 ⋮
 Dict{Int64, Pair{Union{Nothing, Int64}, Union{Nothing, Int64}}}()
 Dict{Int64, Pair{Union{Nothing, Int64}, Union{Nothing, Int64}}}(5 => (1 => 4), 4 => (4 => 1))
 Dict{Int64, Pair{Union{Nothing, Int64}, Union{Nothing, Int64}}}()
 Dict{Int64, Pair{Union{Nothing, Int64}, Union{Nothing, Int64}}}(5 => (4 => 5), 6 => (5 => 4))
 Dict{Int64, Pair{Union{Nothing, Int64}, Union{Nothing, Int64}}}()
 Dict{Int64, Pair{Union{Nothing, Int64}, Union{Nothing, Int64}}}()
 Dict{Int64, Pair{Union{Nothing, Int64}, Union{Nothing, Int64}}}(6 => (4 => 1), 3 => (1 => 4))
 Dict{Int64, Pair{Union{Nothing, Int64}, Union{Nothing, Int64}}}()
 Dict{Int64, Pair{Union{Nothing, Int64}, Union{Nothing, Int64}}}(5 => (5 => 1), 6 => (1 => 5))
 Dict{Int64, Pair{Union{Nothing, Int64}, Union{Nothing, Int64}}}()
```

"""
function convert_to_changes(s, M; drop_identities = true)
    s_ = copy(s)
    D = Dict{eltype(M), Dict{eltype(eachindex(s)),  Pair{Union{eltype(s),Nothing},Union{eltype(s),Nothing}}}}()
    for m in M
        s_ = m(s_) # mutating call
        d = soldiff(s, s_)
        (!isempty(d) || !drop_identities) && push!(D, m => d)
        s  = m(s)   
    end
    return D
end

"""
    soldiff(s1::S, s2::S) where {S}

Compute for two solutions `s1` and `s2` the set of indices whose values changed, and how they changed. Works for non-equal index sets (e.g. Matrices of different dimensions).

# Usage

```julia
julia> A = rand(1:5, 2, 3)
2×3 Matrix{Int64}:
 1  1  1
 2  5  2

julia> B = rand(1:5, 2, 2)
2×2 Matrix{Int64}:
 2  1
 3  5

julia> d = soldiff(A,B)
Dict{Int64, Pair{Union{Nothing, Int64}, Union{Nothing, Int64}}} with 4 entries:
  5 => 1=>nothing
  6 => 2=>nothing
  2 => 2=>3
  1 => 1=>2
```
"""
function soldiff(s1::S, s2::S) where {S}
    #I1 = collect(eachindex(s1))
    #I2 = collect(eachindex(s2))
    I1 = eachindex(s1)
    I2 = eachindex(s2)
    I = I1 ∩ I2  # smaller set 
    I1_ = Iterators.filter(i -> i ∉ I ,I1)
    I2_ = Iterators.filter(i -> i ∉ I, I2)
    idx_to_Δ = Dict{eltype(I), Pair{Union{eltype(s1),Nothing},Union{eltype(s2),Nothing}}}()
    for i in I
        if s1[i] ≠ s2[i]
            idx_to_Δ[i] = s1[i] => s2[i]
        end
    end
    for i in I1_
        idx_to_Δ[i] = s1[i] => nothing
    end

    for i in I2_
        idx_to_Δ[i] = nothing => s2[i]
    end
    return idx_to_Δ
end