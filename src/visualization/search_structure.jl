### Visualize the whole search structure of a problem

function search_structure(st)


end


"""
    search_structure(v0, trace)


"""
function search_structure(v0, trace, draw_vertex, draw_edge, draw_active; cell_width = 20, cell_height = 20, fname = "sstructure.svg", dir = :min, rev = false)
    X, Y, Qa, Qd = generate_coordinates(v0, trace, dir = dir, rev = rev)
    m = last(X)
    n = maximum(Y)

    @show n, m
    @show X
    @show Y
    @show Qa
    @show Qd
    d = Drawing((m+3)*cell_width, (n+3)*cell_height, fname)
    
    origin()
    sethue("black")
    setfont("STIX Two Math", 12)
    background("white")
    
    t = Table(n, m, cell_width, cell_height)
    drawgrid(t)

    # Drawing
    foreach((x,y) -> draw_vertex(t[x,y]), Y,X)
    foreach(e -> draw_edge(t[e[1]...], t[e[2]...]), Qd)
    foreach(e -> draw_active(t[e[1]...], t[e[2]...]), Qa)
    

    finish()
    preview()
end

function drawgrid(t)
    n,m = size(t)
    o = t[n,1]
    x = t[n,m] + Point(20,0)
    y = t[1,1] - Point(0,20)
    sethue("lightgray")
    setline(1)
    hline = y -> line(t[1,y], t[n,y], :stroke)
    vline = x -> line(t[x,1], t[x,m], :stroke)
    foreach(idx -> hline(idx), 1:m)
    foreach(idx -> vline(idx), 1:n)
    setline(4)
    sethue("black")
    tickdrawer = p -> circle(p, 1, :fill)
    axis(o, x, "𝓷"; ticks = t[n,:], drawticks = tickdrawer)
    axis(o, y, "𝓡"; ticks = t[:,1], drawticks = tickdrawer)

end

function axis(t0, t1, l1; ticks = nothing, drawticks = x -> x, valign = "center", halign = "center")
    arrow(t0, t1)
    foreach( d -> drawticks(d), ticks)
    settext(l1, t1)
end




"""
    generate_searchcoordinates(v0, trace::TraceLogger)

Given an initial solution and a search trace, compute the coordinates required to display the search process as the search for an improving path through the ranked search space.
"""
function generate_coordinates(v0, trace; dir = :min, rev = true)
    A = trace.accepted
    V = compute_objectives(v0, trace.deltas, A)
    R = rank_objectives(V, dir = dir, rev = rev)
    curr = (1,R[v0])
    it = 1
    X = Vector{Int}(undef,length(V))
    Y = Vector{Int}(undef,length(V))
    Qa = Vector{Tuple{Tuple{Int,Int},Tuple{Int,Int}}}()
    Qd = Vector{Tuple{Tuple{Int,Int},Tuple{Int,Int}}}()
    for (i,v) in enumerate(V)
        X[i] = it
        Y[i] = R[v]
        node = (R[v], it)
        if i != 1
            if A[i]
                it += 1
                push!(Qa, (curr,node))
                curr = node
            else
                push!(Qd, (curr,node))
            end
        end
    end
    return X,Y,Qa,Qd
end

"""

"""
function rank_objectives(V; dir = :min, rev = false)
    if dir == :min
        Vsorted = unique(sort(V, rev = rev))
    else
        Vsorted = unique(sort(V, rev = !rev))
    end 
    return Dict(Vsorted .=> 1:length(Vsorted))
end

##
"""
    compute_objectives(v0, Δv, acceptance)

Compute the objective value of each solution considered in a search trace, baced on the v0, move-Δs and acceptance.
"""
function compute_objectives(v0, ΔV, A)
    vc = v0
    V = Array{eltype(ΔV), 1}(undef, length(ΔV)+1)
    V[1] = vc
    pushfirst!(A, true)
    for (i,Δv,a) in Iterators.zip(1:length(ΔV), ΔV, A)
        V[i+1] = vc + Δv
        if a
            vc += Δv
        end
    end
    return V
end


###