function template_example(image_width, image_height; fname ="")
    if fname != ""
        Drawing(image_width,image_height, fname)
    else
        Drawing(image_width, image_height)
    end
    W = 4/6 * image_width
    H = W*5/4
    background(SETTINGS.BG_COLOR)
    template = timed_block(Point(W/4,W/4), W,W*5/4)
    fontface("Lato")
    fontsize(image_width/30)
    pin(template.pins.input, 5)
    connector(template.pins.input - Point(W/8,0), template.pins.input)
    label("INPUT", :N, template.pins.input- Point(W/8,0),offset=10)
    label("COMPONENT PROFILE", :N, template.block_dims.upperleft + Point(template.block_dims.width/2,template.block_dims.height/2),offset=-8)
    pin(pins.output,5)
    connector(template.pins.output, template.pins.output + Point(W/8,0))
    label("OUTPUT", :N, template.pins.output + Point(W/8,0), offset=10)
    label("TIME PROFILE", :N, template.time_dims.upperleft + Point(template.time_dims.width/2,template.time_dims.height/2),offset=-8)
    return template
end
