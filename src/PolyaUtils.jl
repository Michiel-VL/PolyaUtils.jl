module PolyaUtils

using Reexport
using CSV
using Tables
using TikzPictures
using MetaGraphs
using JSON3
using JSONTables

@reexport using DataFrames
@reexport using Graphs
@reexport using PrettyTables
@reexport using Luxor
using RecipesBase

    export  SearchTrace,
            OperatorTrace,
            operator_trace,
            search_structure,
            readst,
            dummy_data,
            descent_path,
            operator_trace,
            enumerationorder,
            visualizemoves,
            tolatex,
            as_tex,
            as_svg,

            read,
            write,
            to_df,
            metagraph,
            lineplot,
            objective_plot




include("analysis/search_trace.jl")
include("analysis/io.jl")
include("analysis/graph.jl")

include("io.jl") # read in data
include("visualization/neighborhood.jl")
include("visualization/search_structure.jl")
include("visualization/tolatex.jl")
include("plotting/operator_plots.jl")
include("plotting/objective_plots.jl")
include("analysis/dummy_data.jl")
include("analysis/evaluation.jl")

include("logging/trace_logger.jl")
# include("logging/context.jl")

#cdb

include("plotting/base.jl")
end
