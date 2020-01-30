function selection(c_block, n_sel, n_acc)
    tot_sel = sum(n_sel)
    W = c_block.width; H = c_block.height
    x_offset = W / 20
    y_offset = H / 20
    iW = W-2*x_offset
    iH = H-2*y_offset
    G = c_block.upperleft + Point(x_offset, y_offset)
    offstep = y_offset / length(n_sel)
    step = (iH - y_offset)/length(n_sel)
    sethue(.92, .92, .92)

    for i in 0:length(n_sel)-1
        p = G + Point(0, i*step)
        greenW = n_acc[i+1]*iW
        redW = iW-greenW
        setcolor(sethue("green")...,1)
        rect(p, greenW, (step-offstep), :fill)
        setcolor(sethue("red")..., .5)
        rect(p+Point(greenW,0), redW, (step-offstep), :fill)
        setcolor(sethue("lightgrey")...,1)
    end
end

"""
    sampler()

"""
function sampler(block, Ndims; key=:sampler)
    margin = 0.005*block.width
    p0 = block.upperleft + Point(margin, margin)
    w_area = block.width - 2*margin
    h_area = block.height - 2*margin
    radius_op = min(((w_area, h_area) ./ Ndims)...)/2
    retZero = p0 + Point(w_area/2, h_area/2)
    origin(retZero)
    tiler = Tiler(w_area, h_area, Ndims..., margin = 0)
    for (pos, n) in tiler
        operator(pos, radius_op/2)
    end
    origin(0,0)
    return key => (retZero, reshape(first.(collect(tiler)), Ndims...), radius_op)
end

function sampling_data(block, ops,  deltas)
    p0, points, radius_op = block
    origin(p0)
    min_δ = minimum(deltas)
    max_δ = maximum(deltas)
    mapper = construct_mapper(min_δ, max_δ)
    cL = max(length(deltas),2)
    colorrangeR = range(RGB(1,1,1), stop = RGB(1,0,0), length = cL+1)
    colorrangeG = range(RGB(1,1,1), stop = RGB(0,1,0), length = cL+1)
    for (i, op) in enumerate(ops)
        if deltas[i] > 0
            operator(points[op...], radius_op; cval=RGB(1,0,0))
        else
            operator(points[op...], radius_op; cval=RGB(0,1,0))
        end
    end
    origin(0,0)
end

function time_data(block, rel_value::Number; cval = "green")
    origin(block.upperleft)
    sethue(cval)
    rect(O, block.width*rel_value, block.height, :fill)
    origin(0,0)
end

function time_data(block, rel_vals::Array{T,1}; cvals = range(RGB(0,1,0), stop=RGB(1,0,0), length=100)) where T <: Number
    stepsize = block.width / (length(rel_vals))
    origin(block.upperleft)
    for i in 1:length(rel_vals)
        p = Point((i-1)*stepsize, 0)
        setcolor(cvals[Int(ceil(rel_vals[i]*100))])
        rect(p, stepsize, block.height*rel_vals[i], :fill)
    end
    origin(0,0)
end

"""
    operator(p::Point, r::Number; cval="grey")

    Display an operator-δ at point p, with radius r. By default the operator is colored grey, but a color can be passed
"""
function operator(p,r;cval=RGBA(.9,.9,.9,1))
    if isnothing(cval)
        setcolor(SETTINGS.INACTIVE_COLOR)
    else
        setcolor(cval)
    end
    circle(p, r..., :fill)
end

function delta_block(block, deltas)
    w_margin = 0.02*block.width
    h_margin = 0.02*block.height
    W = block.width - 2*w_margin
    H = block.height - 2*h_margin
    zeroH = max(0,maximum(deltas)) * H
    @show zeroH
    p0 = block.upperleft + Point(w_margin, h_margin) + Point(0, zeroH)
    origin(p0)
    setdash("dash")
    setline(2)
    setcolor(SETTINGS.DEFAULT_COLOR)
    line(O, O + Point(W,0), :stroke)
    setdash("solid")
    stepsize = W/length(deltas)
    for i in 1:length(deltas)
        if deltas[i] < 0
            setcolor(RGB(0,1,0))
        else
            setcolor(RGB(1,0,0))
        end
        p = O + Point((i-1)*stepsize,0)
        line(p, p+Point(0,-deltas[i]*(H-zeroH)),:stroke)
    end
end

function acceptance_block(block, deltas, bounds, bests)
    w_margin = 0.02*block.width
    h_margin = 0.02*block.height
    W = block.width - 2*w_margin
    H = block.height - 2*h_margin
    zeroH = max(0,maximum(deltas)) * H
    @show zeroH
    p0 = block.upperleft + Point(w_margin, h_margin) + Point(0, zeroH)
    origin(p0)
    setdash("dash")
    setline(2)
    setcolor(SETTINGS.DEFAULT_COLOR)
    line(O, O + Point(W,0), :stroke)
    setdash("solid")
    stepsize = W/length(deltas)
    for i in 1:length(deltas)
        if deltas[i] < 0
            setcolor(RGB(0,1,0))
        else
            setcolor(RGB(1,0,0))
        end
        p = O + Point((i-1)*stepsize,0)
        line(p, p+Point(0,-deltas[i]*(H-zeroH)),:stroke)
    end
end
