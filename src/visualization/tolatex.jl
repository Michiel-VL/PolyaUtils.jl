"""
    tolatex(iter; order = true)

Generate a TikzPicture object visualizing the order on a quadratic neighborhood
"""
function tolatex(iter; order = true)
    preprocess = preprocessor()
    Φ = preprocess(iter)
    sb = IOBuffer()
    el_dim = length(first(iter))
    max_val = 0
    for i in 1:el_dim
        max_val = max(max_val, maximum(map(x->x[i], iter)))
    end
    neigh_header(sb) # Add header containing appropriate tikzstyles
    quad_neigh(sb, max_val) # Draw parameter space
    order && neigh_order(sb, Φ) # Add elements and arrows
    latex_string = String(take!(sb))
    close(sb)
    return TikzPicture(latex_string)
end

as_tex(tp, fname) = save(TEX(fname, limit_to=:picture), tp)
as_svg(tp, fname) = save(SVG(fname), tp)

function neigh_header(sb)
    println(sb, "\\tikzstyle{arrow} = [thick, ->, >=stealth]")
    println(sb, "\\tikzstyle{op} = [circle, draw=black, fill=black, minimum width = .05cm, inner sep = 1];")
end

function quad_neigh(sb, n)
    grid =  
    """
    \\foreach \\x in {1,...,$n}{
        \\foreach \\y in {1,...,$n}{
            \\node[op] (oper \\x_\\y) at (\\x,  -\\y) {};
        }
    }
    \\foreach \\x in {1,...,$n}{
	\\draw (0, -\\x) node[text=gray] {\\x};
	\\draw (\\x, 0) node[text=gray] {\\x};
}
    """
    println(sb, grid)
end

function neigh_order(sb, Φ)
    edges = 
    """
    \\foreach \\s / \\d in {$(Φ)}{
        \\draw[arrow] (oper \\s) -- (oper \\d);
    }
    """
    println(sb, edges)
end


"""
    preprocessor()

Returns a function which -- upon executing on an order -- returns a tikz-compatible string.
"""
function preprocessor()
    zipper = iter -> begin v = collect(iter); Iterators.zip(v[1:end-1], v[2:end]) end
    parser = param -> join(map(x->join(x, "_"), param), "/")
    return Φ -> join(map(Φ -> parser(Φ), zipper(Φ)), ", ")
end