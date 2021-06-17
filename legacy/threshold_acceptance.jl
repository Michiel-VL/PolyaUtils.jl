# Threshold-acceptance metaheuristics are algorithms which employ a modification to the acceptance mechanism of the search procedure.
# In particular, 


struct Timer{F}
    f::F
    times::Vector{UInt64}
end

# Accessors
func(t::Timer) = t.f
times(t::Timer) = t.times

# Constructors
Timer(f::Function) = Timer{f}(f, UInt64[])
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

struct Logger{F,A}
    f::F
    logs::Vector{A}
    argidx::Int
end

# Accessors
func(l::Logger) = l.f
logs(l::Logger) = l.logs

# Constructors
Logger(f::Function, ::Type{A}, idx) where A = Logger{f,A}(A[],idx)
Logger(f, ::Type{A}, idx) where A = Logger{typeof(f),A}(A[], idx)
# Functionality
function (l::Logger)(args...)
    log = args[l.argidx]
    push!(l.logs, log)
    return func(l)(args...)
end

Base.empty!(l::Logger) = empty!(l.logs)

## Experiment

t = Timer(+)
l = Logger(t,Int,1)

