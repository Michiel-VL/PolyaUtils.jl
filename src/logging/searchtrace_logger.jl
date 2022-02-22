mutable struct SearchTraceLogger{S,V}
    st::SearchTrace{S,V}
    it::Int
end

SearchTraceLogger(v) = SearchTraceLogger(SearchTrace(v), 1)


function init!(stl::SearchTraceLogger, s, v)
    stl.it = 1
    init!(stl.st, s, v)
    return stl
end

function init!(stl::SearchTraceLogger{Nothing, V}, s, v) where {S, V}
    stl.it = 1
    init!(stl.st, s, v)
    return stl
end

function init!(stl::SearchTraceLogger, v)
    stl.it = 1
    init!(stl.st, v)
    return stl
end


function log!(stl::SearchTraceLogger, data...)
    push!(stl, data)
    return stl
end