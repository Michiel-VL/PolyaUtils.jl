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
