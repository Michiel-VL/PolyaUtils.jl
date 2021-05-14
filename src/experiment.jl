"""
    AnalysisExperiment{P,H}

Represents solving instances of instance generator of type `P` with heuristic `H` as a repeatable experiment, with the goal of gathering data to analyse the performance of heuristic `H`.
"""
struct AnalysisExperiment{P, H}
    name::String
    instance_generator::P
    solver_initializer::H
end

name(e::AnalysisExperiment) = e.name
instance_generator(e::AnalysisExperiment) = e.instance_generator
new_solver(e::AnalysisExperiment) = e.solver_initializer(args) 

function run_once(e::AnalysisExperiment, s₀, p; solver_args)
    heuristic = new_solver(e)
    t₀= time_ns()
    sₙ = heuristic(s₀, p)
    tₙ = time_ns()
    Δt = parse(Float64, (tₙ-t₀)*10^-3)
    return sₙ, Δt
end
    



"""
    run_experiment(e::AnalysisExperiment, n=1; resample=true, save=false, save_name=identity)

Run the AnalysisExperiment `e` `n` times and return the results of the experiment. 

## Keywords
- `resample`: if `true` a new instance is generated for each `n` 
- `save`: if `true` the instance and algorithm are saved

"""
function run_experiment(e::AnalysisExperiment, n=1; resample=true)
    P = instance_generator(e)

    p = P()
    for i in 1:n

end



struct ComparisonExperiment{P,H}
    name::String
    instance_generator::P
    solvers::AbstractVector{H}
    results::Dict
end


struct ExperimentResults{T,H}
    instance_names::Vector{String}
    solvers::Vector{H}
    v_init::Vector{T}
    v_final::Vector{T}
    runtimes::Vector{Float64}
end

Tables.istable(::ExperimentResults) = true
Tables.rowaccess(::Type{ExperimentResults{T,H}}) where {T,H} = true
Tables.columnaccess(::Type{ExperimentResults{T,H}}) where {T,H} = false

function Tables.rows(e::ExperimentResults{M,V})
    map(x -> (  inst_name = x[1],
                solver = x[2],
                v_init = x[3],
                v_final = x[4],
                runtime = x[5]), Iterators.zip( e.instance_names, 
                                                e.solvers, 
                                                e.v_init, 
                                                e.v_final, 
                                                e.runtimes))
end



