struct LoggedNeighborhood{N, M} <: AbstractNeighborhood{M}
    neigh::N
    log::Vector{M}
end

# Accessors
logs(ln::LoggedNeighborhood) = ln.log
neighborhood(ln::LoggedNeighborhood) = ln.neigh
iterator(ln::LoggedNeighborhood) = iterator(neighborhood(ln))
# Iterator Interface
function Base.first(n::LoggedNeighborhood)
    m = first(neighborhood(n))
    push!(logs(n), m)
    return m
end

function Base.last(n::LoggedNeighborhood)
    m = last(neighborhood(n))
    push!(logs(n), m)
    return m
end

Base.length(n::LoggedNeighborhood) = length(neighborhood(n))
Base.size(n::LoggedNeighborhood) = size(neighborhood(n))
Base.eltype(n::LoggedNeighborhood) = eltype(neighborhood(n))

# Constructor
LoggedNeighborhood(n::AbstractNeighborhood) = LoggedNeighborhood(n, eltype(n)[])
logged(n::AbstractNeighborhood) = LoggedNeighborhood(n)

# Functionality
Base.identity(n::LoggedNeighborhood) = identity(neighborhood(n))
Base.zero(n::LoggedNeighborhood) = zero(neighborhood(n))

sample(n::LoggedNeighborhood) = sample(neighborhood(n))
construct(n::LoggedNeighborhood, ϕ) = construct(neighborhood(n), ϕ)

function Base.iterate(n::LoggedNeighborhood)
    m = iterate(neighborhood(n))
    push!(logs(n), m[1])
    return m
end

function Base.iterate(n::LoggedNeighborhood, state)
    m = iterate(neighborhood(n), state)
    isnothing(m) && return nothing
    push!(logs(n), m[1])
    return m
end