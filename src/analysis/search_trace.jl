using DataFrames

mutable struct SearchTrace{S, V}
    # should include at least the starting objective-value
    # OPTIONAL: representation
    s_init::S # 
    v_init::V
    
    # column titles for all iteration information
    # iteration info itself should contain as many fields per entry as SearchTrace.columns
    df::DataFrame
end

SearchTrace(v) = SearchTrace(nothing, v, basedf(eltype(v)))
SearchTrace(s, v) = SearchTrace(s, v, basedf(eltype(v)))

function init!(st::SearchTrace, s, v)
    st.s_init = copy(s)
    st.v_init = v
    empty!(st.df)
end

function init!(st::SearchTrace{Nothing, V}, s, v) where {V}
    st.v_init = v
    empty!(st.df)
end

function Base.push!(st::SearchTrace, data::Tuple)
    push!(st.df, data)
    return st
end

basedf(V) = DataFrame(basecols(V))

basecols(V) = [:it => Int[], :op => Function[], :params => Tuple[], :v_i => V[], :v_s => V[], :accept => Bool[]]

function accepted(st::SearchTrace; accept::Symbol = :accept)
    filterdf(st, accept)
end

function accepted!(st::SearchTrace; accept::Symbol = :accept)
    filterdf!(st, accept)
end

function improving(st::SearchTrace; output::Symbol = :output)
    filterdf(st, output)
end

function improving!(st::SearchTrace; output::Symbol = :output)
    filterdf!(st, output)
end

function filterdf(st::SearchTrace, symbol::Symbol)
    SearchTrace(st.s_init, st.v_init, st.df[st.df[:, symbol], :])
end

function filterdf!(st::SearchTrace, symbol::Symbol)
    st.df = st.df[st.df[:, symbol], :]
end

function filterdf(st::SearchTrace, filter)
    SearchTrace(st.s_init, st.v_init, st.df[filter, :])
end

function filterdf!(st::SearchTrace, filter)
    st.df = st.df[filter, :]
end

