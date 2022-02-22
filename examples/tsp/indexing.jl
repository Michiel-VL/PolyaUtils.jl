struct CyclicIndex{T <: Integer}
    stop::T
end

CyclicIndex(idx::Base.OneTo) = CyclicIndex(idx.stop)

Base.first(::CyclicIndex) = (1,2)
Base.last(c::CyclicIndex) = (c.stop, 1)
Base.eltype(::Type{CyclicIndex{T}}) where T = Tuple{T,T} 

Base.length(c::CyclicIndex) = c.stop
Base.size(c::CyclicIndex) = (length(c), )

function Base.getindex(c::CyclicIndex, i)
    0 < i < c.stop && (i, i+1) 
    return (i, 1)
end

Base.iterate(c::CyclicIndex) = c.stop <= 0 ? nothing : first(c), 1

function Base.iterate(c::CyclicIndex, state)
    v = state + 1
    v == c.stop + 1 && return nothing 
    v == c.stop && return (v, 1), v
    return (v, v + 1), v
end


struct EdgeIter{T,N, V <: AbstractArray{T,N}}
    v::V
end

Base.length(e::EdgeIter) = length(e.v)
Base.eltype(::Type{EdgeIter{T, N, V}}) where {N,T,V} = Tuple{T,T}

function Base.first(e::EdgeIter)
    if isempty(e.v)
        return nothing
    elseif length(e.v) == 1
        return (e.v[1], e.v[1])
    else
        return (e.v[1],e.v[2])
    end
end

Base.last(e::EdgeIter) = (e.v[end], e.v[1])

Base.iterate(e::EdgeIter) = first(e), 1

function Base.iterate(e::EdgeIter, state)
    sn = state + 1
    sn == length(e.v) + 1 && return nothing
    sn == length(e.v) && return last(e), sn
    return (e.v[sn], e.v[sn + 1]), sn
end