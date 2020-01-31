module PolyaViz


export  pin,
        connector,
        block,
        timed_block,
        # Extras
        default_settings,
        template_example,
        # MH
        sampler,
        selection,
        sampling_data,
        time_data,
        operator,
        # Graph
        template_base,
        add_node!,
        add_connector!,
        convert_template!,
        next_components,
        SA_template

using Luxor, LightGraphs, Colors



include("components/settings.jl")
include("components/graph_components.jl")
include("components/network_components.jl")
include("components/mh_components.jl")
include("templates.jl")
include("extra.jl")

const SETTINGS = default_settings()





end # module
