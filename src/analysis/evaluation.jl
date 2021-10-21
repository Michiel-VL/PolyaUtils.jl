# List of analysis for performance evaluation of search processes
# Ideally short functions

"""primal_integral(v, t; )

Compute the primal integral 
"""
function primal_integral(v, t; BKS = 0, T = 1000)
    return 100*(sum(v[i-1](t[i] - t[i-1]) + v[end]*T-t[end], 1:length(v)) / (T * BKS) - 1)
end