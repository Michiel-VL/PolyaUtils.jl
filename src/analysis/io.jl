function Base.read(fpath::String, ::Type{SearchTrace}; accept::Symbol = :accept)
    json_string = read(fpath, String)
    stfile = JSON3.read(json_string)

    df = DataFrame(jsontable(stfile[:trace]))
    df[!, accept] = Bool.(df[:, accept])

    rep = nothing
    if :s in keys(stfile[:initial])
        rep = stfile[:initial][:s]
    end

    st = SearchTrace(
        rep, 
        stfile[:initial][:v],
        df
    )
end

function Base.write(fpath::String, st::SearchTrace; accept::Symbol= :accept)
    open(fpath, "w") do io
        write(io, serialise(st, accept))
    end
end

function serialise(st::SearchTrace, accept::Symbol)
    st.df[!, accept] = Int8.(st.df[:, accept])
    str = string(
        "{\n" , 
            "\"initial\": { \n\t\"s\": " , serialise(st.s_init) , 
                                ", \n\t\t\"v\": " , serialise(st.v_init) , "}" ,
            ", \n\"trace\": " , serialise(st.df) , 
        "\n}"
    )
    return str
end

function serialise(st::SearchTrace{Nothing, V}, accept) where {V}
    st.df[!, accept] = Int8.(st.df[:, accept])
    str = string(
        "{\n" , 
            "\"initial\": { \n\t\"v\": " , serialise(st.v_init) , "}" ,
            ", \n\"trace\": " , serialise(st.df) ,
        "\n}"
    )
    return str
end

function serialise(df::DataFrame)
    df.op = string.(df.op)
    return arraytable(df)
end

function serialise(t::Any)
    return JSON3.write(t)
end