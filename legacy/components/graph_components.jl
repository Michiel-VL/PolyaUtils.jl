function template_base()
    g = DiGraph()
    n_to_c = Dict{Int, Symbol}()
    c_to_n = Dict{Symbol, Int}()
    return (graph = g, components = n_to_c, nodes = c_to_n)
end

function add_node!(template, node_name)
    add_vertex!(template.graph)
    node_idx = length(vertices(template.graph))
    template.components[node_idx] = node_name
    template.nodes[node_name] = node_idx
    return true
end

function add_connector!(template, origin, destination)
    add_edge!(template.graph, template.nodes[origin], template.nodes[destination])
end

function convert_template!(W, H, mh_type)
    if mh_type == :SA
       return construct_SA(W,H, )
    end
end

function next_components(template, node_name)
    idx = template.nodes[node_name]
    outneighbors(template.graph)
end
