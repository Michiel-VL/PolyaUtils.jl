"""
    pin(p::Point, radius::Int; active = false)

Displays a pin at point p.
"""
function pin(p, r, active = false)
    setcolor(SETTINGS.COLOR_INACTIVE)
    active && setcolor(SETTINGS.COLOR_ACTIVE)
    circle(p, r, :fill)
    setcolor(SETTINGS.DEFAULT_COLOR)
end

"""
    connector(pin1::Point, pin2::Point; active = false)

Display a connection between two pins. Can be made active. Configuration through settings.
"""
function connector(pin1, pin2; active = false)
    setcolor(SETTINGS.COLOR_INACTIVE)
    setline(SETTINGS.CONN_W_INACTIVE);
    active && begin setcolor(SETTINGS.COLOR_ACTIVE); setline(SETTINGS.CONN_W_ACTIVE); end
    Luxor.arrow(pin1, pin2, arrowheadlength=20, linewidth=5)
    setcolor(SETTINGS.DEFAULT_COLOR)
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

"""
    block(upperleft::Point, W, H; active = false)

Display a block of width `W` and height `H` at position `upperleft`.
"""
function block(upperleft, W, H; active = false)
    origin(upperleft)
    setcolor(SETTINGS.BLOCK_BG_COLOR)
    rect(O, W, H, :fill)
    setcolor(SETTINGS.COLOR_INACTIVE)
    setline(SETTINGS.CONN_W_INACTIVE)
    active && begin sethue(SETTING.COLOR_ACTIVE); setline(SETTINGS.CONN_W_ACTIVE); end
    rect(O, W, H, :stroke)
    origin(0,0)
    dims = (upperleft = upperleft, width= W, height = H)
    pins = (input = upperleft + Point(0, H/2), output = upperleft + Point(W, H/2))
    sethue(SETTINGS.DEFAULT_COLOR)
    return dims, pins
end

"""
    timed_block(upperleft::Point, W, H; active = false)

Display a block of width `W` and height `H` at position `upperleft`, together with an accompanying time-bar below.
"""
function timed_block(upperleft, W, H; active = false)
    bdims, pins = block(upperleft, W, 4H/5, active=active)
    tdims, _rest = block(upperleft + Point(0, 4H/5+H/20), W, H/10, active=active)
    return (block_dims = bdims, time_dims = tdims, pins = pins)
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
