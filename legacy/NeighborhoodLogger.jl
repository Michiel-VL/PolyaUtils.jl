struct NeighborhoodLogger{N, M} <: AbstractNeighborhood{M}
    neigh::N
    log::Vector{String}
    tag::String
end

# Accessors
logs(ln::NeighborhoodLogger) = ln.log
neighborhood(ln::NeighborhoodLogger) = ln.neigh
iterator(ln::NeighborhoodLogger) = iterator(neighborhood(ln))

logstring(ln::NeighborhoodLogger, m) = ln.tag*join(params(m), ":")

# Iterator Interface
function Base.first(n::NeighborhoodLogger)
    m = first(neighborhood(n))
    push!(logs(n), logstring(n,m))
    return m
end

function Base.last(n::NeighborhoodLogger)
    m = last(neighborhood(n))
    push!(logs(n), logstring(n, m))
    return m
end

Base.length(n::NeighborhoodLogger) = length(neighborhood(n))
Base.size(n::NeighborhoodLogger) = size(neighborhood(n))
Base.eltype(n::NeighborhoodLogger) = eltype(neighborhood(n))

# Constructor
NeighborhoodLogger(n::AbstractNeighborhood, tag) = NeighborhoodLogger(n, eltype(n)[], tag)
logged(n::AbstractNeighborhood, tag = string(eltype(n))) = NeighborhoodLogger(n, tag)

# Functionality
Base.identity(n::NeighborhoodLogger) = identity(neighborhood(n))
Base.zero(n::NeighborhoodLogger) = zero(neighborhood(n))

sample(n::NeighborhoodLogger) = sample(neighborhood(n))
construct(n::NeighborhoodLogger, ϕ) = construct(neighborhood(n), ϕ)

function Base.iterate(n::NeighborhoodLogger)
    m = iterate(neighborhood(n))
    push!(logs(n), logstring(n,m[1]))
    return m
end

function Base.iterate(n::NeighborhoodLogger, state)
    m = iterate(neighborhood(n), state)
    isnothing(m) && return nothing
    push!(logs(n), logstring(n, m[1]))
    return m
end