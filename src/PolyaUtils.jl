module PolyaUtils

using Polya

using Tables
using Plots
using Cassette

export  TraceLogger,
        MetaheuristicLogging




include("logging.jl")
include("context.jl")
include("plotting.jl")



end
