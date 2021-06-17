"""
    Timer{F}

Logger struct which wraps around a function `F` and internally logs the runtime of each call to the function. Use `times(t::Timer)` to get the logs (in ns, stored as UInt64).

```@example
julia> f(a,b) = a+b

julia> timedf = Timer(f)

julia> for i in 1:3
    timedf(rand(), rand())
end;

julia> times(timedf)
3-element Array{UInt64,1}:
 0x00000000000a94bf
 0x0000000000098f38
 0x0000000000098f38
```

"""
struct Timer{F}
    f::F
    times::Vector{UInt64}
end

# Accessors
func(t::Timer) = t.f
times(t::Timer) = t.times

μs(t) = Float64(t/10^3)
# Constructors
Timer(f::Function) = Timer{typeof(f)}(f, UInt64[])
Timer(f) = Timer{typeof(f)}(f, UInt64[])

# Functionality
function (t::Timer)(args...)
    t0 = time_ns()
    res = func(t)(args...)
    t1 = time_ns()
    push!(t.times, t1-t0)
    return res
end

Base.empty!(t::Timer) = empty!(t.times)

## Logger

struct InputLogger{F,A}
    f::F
    logs::Vector{A}
    argidx::Int
end

# Accessors
func(l::InputLogger) = l.f
logs(l::InputLogger) = l.logs

# Constructors
InputLogger(f::Function, ::Type{A}, idx) where A = InputLogger{f,A}(f, A[],idx)
InputLogger(f, ::Type{A}, idx) where A = InputLogger{typeof(f),A}(f, A[], idx)
# Functionality
function (l::InputLogger)(args...)
    log = args[l.argidx]
    push!(l.logs, log)
    return func(l)(args...)
end

Base.empty!(l::InputLogger) = empty!(l.logs)

## OutputLogger

struct OutputLogger{F,A}
    f::F
    logs::Vector{A}
    argidx::Int
end
# Accessors
func(l::OutputLogger) = l.f
logs(l::OutputLogger) = l.logs

# Constructors
OutputLogger(f::Function, ::Type{A}, idx) where A = OutputLogger{f,A}(f, A[], idx)
OutputLogger(f, ::Type{A}, idx) where A = OutputLogger{typeof(f),A}(f, A[], idx)

function(l::OutputLogger)(args...)
    ret = func(l)(args...)
    push!(logs(l), ret[l.argidx])
    return ret
end

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