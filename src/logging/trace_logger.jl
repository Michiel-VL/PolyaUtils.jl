"""
    TraceLogger{M,V}

Logs a move, movedelta, acceptance and timestamp every time Δ is called. Must be used in a Cassette-context MetaheuristicLogging.
"""
struct TraceLogger{M,V}
    moves::Vector{M}
    deltas::Vector{V}
    accepted::Vector{Bool}
    times::Vector{UInt64}
end

TraceLogger(::Type{M}, ::Type{V}) where {M,V} = TraceLogger(M[], V[], Bool[], UInt64[])

function log!(l::TraceLogger, move, Δv,a, t)
    push!(l.times, t)
    push!(l.moves, move)
    push!(l.accepted, a)
    push!(l.deltas, Δv)
    nothing
end

function Base.empty!(t::TraceLogger)
    empty!(t.moves)
    empty!(t.accepted)
    empty!(t.deltas)
    empty!(t.times)
    return t
end

Tables.istable(::TraceLogger) = true
Tables.rowaccess(::Type{TraceLogger{M,V}}) where {M,V} = true
Tables.columnaccess(::Type{TraceLogger{M,V}}) where {M,V} = false


function Tables.rows(t::TraceLogger{M,V}) where{M,V}
    map( x-> (iteration = x[1], move = x[2], Δv = x[3], accepted = x[4], Δt = x[5]), Iterators.zip(eachindex(t.moves), t.moves, t.deltas, t.accepted, Float64.(t.times)))
end



