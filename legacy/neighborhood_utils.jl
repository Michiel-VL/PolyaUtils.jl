function compute_Δ(N::SquareMatrixIterator, state, problem)
    A = zeros(objtype(problem), dimension(N), dimension(N))
    for m in N
        A[ϕ(m)...] = compute_Δ(m, state, objective(problem))
    end
    return A
end


"""
    iterate_all(N)

Simple function iterating over all operators in a neighborhood, to be used for testing purposes only.
"""
function iterateall(N)
    i = 0
    for m in N
        i += ϕ(m)[1]
    end
    return i
end
