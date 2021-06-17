global const COLSET = ["values", "movename", "moveparam", "accepted", "timestamp"]


"""
    readst(fname)

Read a search string from a csv-file
"""
function readst(fname)
    @assert endswidth(fname, ".csv")
    st = CSV.read(fname, DataFrame)
    c = copy(colset)
    for v in names(st)
        if v ∈ colset
            @info "Found column $v"
            pop!(c)
        end
    end
    if !isempty(s)
        s = "Following columns were not found:\n"
        for v in c
            s * "- $(v)\n"
        end 
        s = "Currently, PolyaUtils relies on the existence of columns with the aforementioned names. Not all functionality will be available to you with current naming. Either provide a new csv-file, or rename the appropriate columns using `rename(st, namedict)`. See the documentation of the `rename`-function in DataFrames for more information."
        @info s
        
    end
    return st   
end

"""
    compute_deltas(values, acceptance)


"""
function compute_deltas(values, acceptance)
    # maintain a current value, which is updated every time a move is accepted
    v_curr = first(values)
    Δ = Vector{eltype(values)}(undef, length(values))
    for (i,v) in enumerate(values)
        Δ[i] = v - v_curr
        if acceptance[i]
            v_curr = v
        end
    end
    return Δ
end

#=
function compute_tsli(times, acceptance)
    t_curr = first(times)
end=#
"""
    vcurr(df)

Compute the current state objective value for each step in the search trace
"""
function vcurr(df)
    I = Iteratros.zip(df.accepted, df.values)
    accumulate( (c,n) -> n[1] ? n[2] : c, I, init  = first(df.values))
end

"""
    vbest(df)

Compute the best state objective value for each step in the search trace
"""
vbest(df) = accumulate(min, df.vcurr, init = first(df.vcurr))

"""
    add_columns!(df)

Adds the columns required to generate plots. Following columns are added:
- iteration: Iteration number in the trace, where each iteration is associated with exactly one move
- delta: Difference in objective value between the current solution and the proposed alternative
- 
"""
function add_columns!(df)
    V = eltype(df.value)
    df.iteration = 1:size(df,1)
    df.vcurr = [first(df.value)] * vcurr(df) # Current objective value
    df.vbest = [first(df.value)] * vbest(df) # Best objective value
    df.Δv = df.vcurr - df.value              # Objective delta
    rankdict = rankingdict(df.values)
    ranker = v -> rankdict[v]
    df["ranking"] = ranker.(df.values)       # Rank the 
    return df
end


finalcols = ["iteration", "movetype", "moveparam", "value", "accepted", "timestamp", "improvementstep"]


improving(df) =  df[df.Δv .<= zero(eltype(df.Δv)) .& df.accepted, :]
strictlyimproving(df) = improving(df)[df.Δv .< zero(eltype(df.Δv)), :]

