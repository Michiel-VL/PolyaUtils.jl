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
