struct OperatorTrace end

@recipe function operator_trace(df::DataFrame, type::Type{OperatorTrace})
    x, y = align(df.moveparams)
    seriestype --> :scatter
    x, y
end


"""
    align(Φ)

Convert parameter-tuples into (x,y)-coordinates, where x indicates the iteration number and y the variable involved. 
"""
function align(Φ) 
    manipulated_vars = Int[]
    iteration_count = Int[]
    cnt = 1
    for el in Φ # voor elke operator-parameter
        push!(manipulated_vars, el...) # voeg alle variabele-parameters toe
        push!(iteration_count, ntuple(x -> cnt, length(el))...) # 
        cnt+=1
    end
    return iteration_count, manipulated_vars
end