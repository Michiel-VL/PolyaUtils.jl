# Visualization of iterators:
# - Focus on two-dimensional iterators
# - Show occupation: Which pairs are in the iterator => nodes
# - Show order: What is the order of the pairs? => edges
# - Use drawing-functions for nodes and edges
# - 


function setup(W, filename)
    Drawing(W, W, "fig/$filename")
    origin()
    sethue("black")
    fontface("Lato")
    fontsize(12)
end

function neighborhood_structure(N_::MoveIter{M}, R; movelabels=true, arrows=true) where M <: Move
    ID = typeof(N_)
    N = collect(N_)
    m = first(N)
    prev = Point(R,0)
    n = length(N)
    sethue("black")
    for i in 1:length(N)
        curr = polar(R,2*π/n*i)
        circle(curr, 1, :fill)
        if movelabels
            label(string(ϕ(m)), :S, prev)
        end
        if arrows
            Luxor.arrow(prev, curr)
        else
            line(prev, curr, :stroke)
        end
        m = successor(m,N_)
        prev = curr
    end
    setdash("dash")
    fontsize(20)
    label("N(s) = $ID($n)", :E, polar(R+60,-π/2))
    Luxor.arrow(O,polar(R,0), linewidth=2)
    label("first(N)", :E, polar(R+60,0))
    circle(O, 4, :fill)
    label("s", :N, O)
end

function neighborhood_Δ(N::MoveIter, R, p) where M <: Move
    N = collect(N)
    Δv = δ.(Ref(p), N)
    proj_Δ = Δv / maximum(Δv) .* 50

    m = first(N)
    n = length(N)
    setdash("solid")
    for i in 1:length(N)
        if proj_Δ[i] > 0
            setcolor(sethue("red")...,.3)
            curr = polar(R,2*π/n*i)
            Luxor.arrow(curr, polar(R-proj_Δ[i],2*π/n*i))
            m = successor(m)
        end
    end
    for i in 1:length(N)
        if proj_Δ[i] < 0
            setcolor(sethue("green")...,.8)
            curr = polar(R,2*π/n*i)
            Luxor.arrow(curr, polar(R-proj_Δ[i],2*π/n*i))
            m = successor(m)
        end
    end

end

function block_template(W; active=false, mode=:snapshot, fname="block_template")
    d = Drawing(W, W+W/5, "fig/"*fname*".svg")
    background("white")
    setline(3)
    sethue("black")
    x0 = W/10; xW = 4/5*W
    y0 = W/10; yW = 4/5*W
    rect(x0,y0,xW,yW, :stroke)

    if active
        sethue("red")
        points = [Point(x,y) for x in [x0,x0+xW], y in [y0,y0+yW]]
        x_off = x0/5*2
        y_off = y0/5*2
        line(Point(x0-x_off,y0), points[1], :stroke)
        line(points[1], Point(x0,y0-y_off), :stroke)

        line(Point(x0+xW,y0-y_off), points[2], :stroke)
        line(points[2], Point(x0+xW+x_off,y0), :stroke)

        line(Point(x0-x_off,y0+yW), points[3], :stroke)
        line(points[3], Point(x0,y0+yW+y_off), :stroke)

        line(Point(x0+xW,y0+yW+y_off), points[4], :stroke)
        line(points[4], Point(x0+xW+x_off,y0+yW), :stroke)
        sethue("black")
    end
    sethue("lightgrey")
    rect(x0, y0+yW+W/10, xW, W/10, :stroke)
    c_block = (upperleft = Point(x0,y0), width = xW, height = yW)
    t_block = (upperleft = Point(x0, W), width = xW, height = W/10)
    return d, c_block, t_block
end

function timing(t_block, rel_dur)
    W = t_block.width; H = t_block.height
    p = t_block.upperleft
    sethue(rel_dur, 1-rel_dur, 0)
    rect(p, rel_dur*W, H, :fill)
end
