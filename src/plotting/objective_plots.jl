# Implements following functions
# - descent path: monotonically decreasing states visited (best solution throughout search)
# - acceptance path (current solution throughout search)

@recipe function descent_path(trace::DataFrame, type::Type{SearchTrace}; xax = :iteration, yax = :value)
    ldf = df[:, :accepted .== true & :delta .<= 0]
    x = ldf[:,xax]
    y = ldf[:,yax]
       
    seriestype --> :scatter
    return x,y
end