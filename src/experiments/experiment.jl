function single_solve(state, solve!, problem)
    t0 = time_ns()
    state = solve!(state, problem)
    t1 = time_ns()
    t_exec = to_micros(t1-t0)
    return state, t_exec
end

to_micros(t) = Float64(t/10^3)


function construct_solver(A, N)
    return (s, p) -> algo = A() ; return algo(s, N, p) end
end