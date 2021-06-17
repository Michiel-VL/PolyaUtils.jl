#= We want to visualize neighborhoods as follows:
 For square-neighborhoods, build a grid of cells of dim x dim. Each cell which corresponds to a feasible move is marked with a circle. The color of the circle represents the objective-delta of the corresponding move. A
=#

visualizemoves(n, m, order, draw_vertex) = enumerationorder(n, m, order, draw_vertex, x->x; cell_width = cell_width, cell_height = cell_height, fname = fname)

"""
    enumerationorder(n, m, order, draw_vertex, draw_edge; cell_width = 20, cell_height = 20)

Draw the enumeration order of a quadratic neighborhood structure on an n x m grid, using draw_vertex and draw_edge to draw the parameters and sequence respectively.
"""
function enumerationorder(n, m, order, draw_vertex, draw_edge; cell_width = 20, cell_height = 20, fname = "enum.svg")
    d = Drawing((n+1)*cell_width, (m+1)*cell_height, fname)
    origin()
    sethue("black")
    setfont("STIX Two Math",12)
    background("white")
    t = Table(n+1, m+1, cell_width, cell_height)
    foreach(i -> settext("$(i-1)", t[i,1], valign = "center", halign="left") ,2:n+1)
    foreach(i -> settext("$(i-1)", t[1,i], valign="top", halign="center"), 2:n+1)
    # Drawing
    ordervertices = map(o -> o .+ (1,1), order)
    foreach(v -> draw_vertex(t[v...],v), ordervertices)
    foreach((s,d) -> draw_edge(t[s...], t[d...],s, d), ordervertices[1:end-1], ordervertices[2:end])
    finish()
    preview()
end



function drawgrid(t, cell_height, cell_width)
    rows = Iterators.zip(t[1,:] .- Point(0,cell_height ÷ 2), t[n,:] .+ Point(0, cell_height ÷ 2))
    cols = Iterators.zip(t[:,1] .- Point(cell_width ÷ 2, 0), t[:,m] .+ Point(cell_width ÷ 2, 0))
    sethue("grey")
    setline(1)
    foreach(r -> line(r..., :stroke), rows)
    foreach(c -> line(c..., :stroke), cols)
    sethue("black")
end

function draw_param(p, i; color = "black", action=:fill)
    sethue(color)
    ellipse(p, 3, 3, action)
    sethue("black")
end

function draw_order(p1, p2, s , d; color="black")
    sethue(color)
    arrow(p1, p2, arrowheadlength=7, arrowheadangle=π/10, linewidth=1)
end


##
#=


scaler(xmax, maxval) = x -> x * maxval / xmax

function visualize(N, state, problem; width = 400, height = 400, active = identity(N))
    ΔN = Δ(N, state, problem)
    vmin = abs(minimum(ΔN))
    vmax = abs(maximum(ΔN))
    cellheight, cellwidth = (height, width) ./ dims(ΔN)
    scaled = scaler(max(vmin, vmax), min(cellheight,cellwidth))

    for (i, p) in Table(dims(ΔN)..., width, height)
        if isimproving(ΔN[i], state, objective(problem))
            setcolor("green")
        elseif isequal(ΔN[i], objective(problem))
            setcolor("red")
        end
        circle(p, scaled(ΔN[i]), :fill)
    end
    if !isidentity(active)
        rectangle(t[ϕ(active)...], )
    end
end


# Attention: indexing below is inversed over the operator-parameters. I think this is due to Luxor using a row-major implementation.

function visualize_order(N::AbstractNeighborhood, n_dim; bgcolor="transparent", width = 400, height = 400, filename ="order.png")
    d = Drawing(width, height, filename)
    bgcolor != "transparent" && background(bgcolor)
    origin()
    t = drawgrid(n_dim; width = width, height = height)
    draworder(t, N)
    finish()
    preview()
end

function drawgrid(ndim; width = 400, height = 400, linecolor = "grey", textcolor = "black", fface="Computer Modern", fsize=12)
    maxdim = ndim + 1
    t = Table(maxdim, maxdim, width/maxdim, height/maxdim)
    for i in 2:maxdim
        sethue(linecolor)
        line(t[1,i] + Point(0, fsize/2), t[maxdim, i], :stroke)
        line(t[i,1]+Point(fsize/2, 0), t[i, maxdim], :stroke)
        sethue(textcolor)
        text( "$(i-1)", t[1,i], halign = :center, valign = :middle)
        text( "$(i-1)", t[i,1], halign = :center, valign = :middle)
    end
    return t
end

function draworder(t, iter; arrowcolor = "black")
    sethue(arrowcolor)
    prev = first(iter)
    transform =  m -> (ϕ(m)[2] + 1, ϕ(m)[1] + 1)
    circle(t[transform(prev)...], 5, :fill)
    for (i,m) in enumerate(iter)
        if i > 1
            arrow(t[transform(prev)...], t[transform(m)...], arrowheadangle = π/8, arrowheadlength = 5 )
        end
        prev = m
    end
    circle(t[transform(prev)...], 5, :fill)
end


# Sticking together a couple of neighborhood-orders (The specifics of what is being visualized will have to be abstracted out for later use in other visualizations...)

function visualize_order(neighborhood_set::Array; filename="composite_neighborhood.png", cell_width = 400, cell_height=400)
    images = []
    nmax = maximum(dimension.(neighborhood_set))
    for (i,N) in enumerate(neighborhood_set)
        Nw = dimension(N)/nmax * cell_width
        Nh = dimension(N)/nmax * cell_height
        push!(images, visualize_order(N, dimension(N), filename = "neigh_$(i).png", width = Nw, height = Nh))
    end
    Drawing(cell_width*size(neighborhood_set, 1), cell_height*size(neighborhood_set,2), filename)
    origin()
    t = Table(size(neighborhood_set)..., cell_width, cell_height)
    for (i,cell) in enumerate(t)
        placeimage(readpng(images[i].filename), cell[1].x, cell[1].y; centered = true)
    end
    finish()
    preview()
end
=#