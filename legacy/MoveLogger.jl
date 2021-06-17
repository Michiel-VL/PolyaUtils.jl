"""
    MoveLogger

Logs the selection time, parameters and Δv of each selected move.

# Available functions:
- logtime(l)
- logmove(l, m)
- logΔv(l, Δv)
- log(l, m, Δv) = composition of the three previous

# Example Usage
```julia
logtime(l)
m, Δv = ..... # select a move here
log(l, m, Δv)
```
"""
struct MoveLogger{M,Φ,V}
    timing::Vector{UInt}
    move_id::Vector{Int}
    ϕset::Vector{Φ}
    ΔV::Vector{V}

    function MoveLogger{M,Φ,V}() where {M,Φ,V}
        t = UInt[]
        mid = Int[]
        ϕset = Φ[]
        vset = V[]
        return new{M,Φ,V}(t,mid, ϕset, vset)
    end
end

# Constructor
MoveLogger(m::AbstractOperator, obj) = MoveLogger{typeof(m), typeof(ϕ(m)), eltype(obj)}()
function MoveLogger(M, obj)
    tuple(typeof(M))
end

logtime(l::MoveLogger) = push!(l.timing,time_ns())
logmove(l::MoveLogger{M,Φ,V}, m) where {M <: AbstractOperator,Φ,V}= push!(l.ϕset, ϕ(m))

function logmove(l::MoveLogger, m)
    push!(l.ϕset, ϕ(m))
    for (i,T) in enumerate(l.movetype)
        if T == typeof(m)
            push!(l.move_id, T)
            break
        end
    end
end

logΔv(l::MoveLogger, Δv) = push!(l.ΔV, Δv)

function log(l::MoveLogger, m, Δv)
    logtime(l)
    logmove(l, m)
    logΔv(l, Δv)
end

function results(l::MoveLogger)
    iter = Iterators.zip(l.timing[1:2:end-1], l.timing[2:2:end])
    timings = Array{Int,1}(undef, length(l.timing) ÷ 2)
    for (i,(t0, t1)) in enumerate(iter)
        timings[i] = Int(t1-t0)
    end
    return to_df(l, timings)
end

to_df(l::MoveLogger{M,Φ,V}, timings) where {M <: AbstractOperator,Φ,V} = DataFrame(:time => timings, :move => fill(M, length(timings)), :ϕ => l.ϕset, :Δv => l.ΔV)

to_df(l::MoveLogger{M,Φ,V}, timings) where {M,Φ,V} = DataFrame( :time => timings,
                                                                :move => map(x -> M[x], l.move_id),
                                                                :ϕ => l.ϕset,
                                                                :Δv => l.ΔV
                                                                )