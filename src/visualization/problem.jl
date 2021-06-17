function problemstructure(v, draw_vertex; cell_width=10, cell_height = 10, fname="pstruct.svg")
    n = sum(v)
    d = Drawing((n+1)*cell_width, (n+1)*cell_height, fname)
    t = Table(n+1, n, cell_width, cell_height)
    sethue("black")
    line(t[1:1], t[n:1], :stroke)
    settext("\\mathbb{N}", t[1,1], valign = "bottom", halign="right")
    for (i,val) in enumerate(v)
        for s in 1:val
            draw_vertex(t[s, i])
        end
    end
    finish()
    preview()
end