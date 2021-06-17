function selection_block(neigh_sel, neigh_acc, dur; W=300, active=false )
    d, c, t = block_template(W, active=active)
    selection(c, neigh_sel, neigh_acc)
    timing(t, dur)
    finish()
    preview()
end

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

function sampling(c_block, N)
    W = c_block.width; H = c_block.height
    x_offset = W / 20
    y_offset = H / 20
    iW = W-2*x_offset
    iH = H-2*y_offset
    G = c_block.upperleft + Point(x_offset, y_offset)
    origin(G + Point(iW/2, iH/2))
    tiler = Tiler(W,H,size(N)..., margin=W/20)
    sethue(.92, .92, .92)
    for (pos, n) in tiler
        circle(pos, iW/size(N,1)/2, :fill)
    end
end
