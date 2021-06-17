
function dummy_data(n, move_type, param_gen, D_obj)
    t = TraceLogger(String, Int)
    moves = [move_type for i in 1:n]
    ϕ = [param_gen() for i in 1:n]
    for i in 1:n
        v = rand(D_obj)
        log!(t, moves[i] * "$(ϕ[i])", v, Δv ≤ 0, time_ns())
    end
    return t
end
