# customs names should take care to set nodedata & edgedata to appropriate values.
# nodedata:
#   nodedata[1] should be the objective value of the selected solution
#   nodedata[2] should be the 'accept' param (0 or 1), 1 if the selected solution will be accepted as the new incumbent solution
#   all other elements in this vector are optional
# edgedata:
#   all elements in this vector are optional
function metagraph(st::SearchTrace; nodedata::Vector{Symbol}=[:v_s, :accept, :it, :output], edgedata::Vector{Symbol}=[:operator, :params])
    mg = MetaDiGraph(SimpleDiGraph())
    origin = 1
    add_vertex!(mg)
    set_prop!(mg, 1, :v, st.v_init)
    set_prop!(mg, 1, :it, 0)
    objval = nodedata[1]
    accept = nodedata[2]
    for i in 1:size(st.df, 1)
        # add a node for all iterations, this will be vertex(mg, i+1)
        add_vertex!(mg)
        # every node should have all its metadata
        set_prop!(mg, i+1, :v, st.df[i, objval])
        for j in 3:length(nodedata)
            set_prop!(mg, i+1, nodedata[j], st.df[i, nodedata[j]])
        end
        # add the "parent" node in the connected graph
        add_edge!(mg, origin, i+1)
        for j in 1:length(edgedata)
                set_prop!(mg, origin, i+1, edgedata[j], st.df[i, edgedata[j]])
        end
        # if this node was accepted, it becomes the new parent!
        if st.df[i, accept] == 1
            origin = i+1
        end
    end
    set_prop!(mg, :lastaccept, st.df[size(st.df, 1), accept])
    mg
end

# for non-default DataFrame column names, please supply a dfsymbols::Vector{Symbol} list where
#   dfsymbols[1] = "accept" column name, (shows whether this solution was accepted or not during the search)
#   dfsymbols[2] = name of column with the objective values of the selected solution
#   dfsymbols[3] = name of column with the objective values of the incumbent solution
#   dfsymbols::Vector{Symbol}= [:accept, :v_s, :v_i]
# all other indices of dfsymbols will be ignored.

# accept column name can be specified using the accept param
# current solution objval column name can be specified using the curr_obj param
# incumbent solution value column name can be specified using the  inc_obj param

function to_df(mg::MetaDiGraph; accept::Symbol = :accept, curr_obj::Symbol = :v_s, inc_obj::Symbol = :v_i)
    # extract all column names edge(1, 2) into empty df to set types
    edgepairs = collect(props(mg, 1, 2))
    df_cons_edge = map(prop -> (prop[1] => Vector{typeof(prop[2])}()), edgepairs)

    # same for nodes, but collect datatype of (:v) and filter this line out to know type of inc_obj
    v_example = filter(prop -> prop[1] == :v, collect(props(mg, 2)))[1][2]

    nodepairs = copy(collect(props(mg, 2)))
    push!(nodepairs, (inc_obj => v_example))
    push!(nodepairs, (accept => get_prop(mg, :lastaccept)))

    df_cons_node = map(prop -> (prop[1] => Vector{typeof(prop[2])}()), nodepairs)

    df = DataFrame(union(df_cons_edge, df_cons_node))
    # now we should populate this.
    for vertex in outneighbors(mg, 1)
        fill!(df, mg, inc_obj, accept; cv=vertex)
    end
    rename!(df, :v => curr_obj)
    df[size(df, 1), accept] = get_prop(mg, :lastaccept)
    df
end

# cv = currentvertex
function fill!(df::DataFrame, mg::MetaDiGraph, inc_obj::Symbol, accept::Symbol; cv::Int=2)
    parent = inneighbors(mg, cv)[1]
    edgedict = copy(props(mg, parent, cv))
    nodedict = copy(props(mg, cv))
    push!(nodedict, inc_obj => props(mg, parent)[:v])
    haschildren = length(outneighbors(mg, cv)) > 0
    push!(nodedict, accept => haschildren)
    push!(df, Dict(union(edgedict, nodedict)))
    for nb in outneighbors(mg, cv)
        fill!(df, mg, inc_obj, accept; cv = nb)
    end
end

function isaccepted(mg::MetaDiGraph, vertex::Int)
    if vertex == 1 
        return true
    elseif vertex == nv(mg)
        return get_prop(mg, :lastaccept)
    end
    length(outneighbors(mg, vertex)) > 0
end
