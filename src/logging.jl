"""
    TraceLogger{M,V}

Logs a move, movedelta and timestamp every time Δ is called. Must be used in a Cassette-context MetaheuristicLogging.
"""
struct TraceLogger{M,V}
    moves::Vector{M}
    deltas::Vector{V}
    times::Vector{UInt64}
end

TraceLogger(::Type{M}, ::Type{V}) where {M,V} = TraceLogger(M[], V[], UInt64[])

function log!(l::TraceLogger, move, Δv, t)
    push!(l.moves, move)
    push!(l.deltas, Δv)
    push!(l.times, t)
    nothing
end

function Base.empty!(t::TraceLogger)
    empty!(t.moves)
    empty!(t.deltas)
    empty!(t.times)
    return t
end

Tables.istable(::TraceLogger) = true
Tables.rowaccess(::Type{TraceLogger{M,V}}) where {M,V} = true
Tables.columnaccess(::Type{TraceLogger{M,V}}) where {M,V} = false


function Tables.rows(t::TraceLogger{M,V}) where{M,V}
    map( x-> (  iteration = x[1], 
                move = x[2], 
                Δv = x[3], 
                Δt = x[4]), Iterators.zip(  eachindex(t.moves), 
                                            t.moves, 
                                            t.deltas, 
                                            Float64.(t.times)))
end
