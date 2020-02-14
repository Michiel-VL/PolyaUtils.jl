"""
    structs of this type `T <: BaseShape` provide the most lowlevel parts of the algorithmic templates. These components are what will be drawn on the screen.
"""
abstract type BaseShape end

mutable struct Block <: BaseShape
    upperleft::Point
    width::Float64
    height::Float64
end

getpoints(b::Block) = [ upperleft(b),
                        upperleft(b) + Point(width(b), 0),
                        upperleft(b) + Point(width(b), width(b)),
                        upperleft(b) + Point(0, height(b))]

upperleft(b::Block)  = b.upperleft
width(b::Block) = b.width
height(b::Block) = b.height
anchor(b::Block) = upperleft(b)

function draw(b::Block; color="white")
    rect(anchor(b), width(b), height(b), :stroke)
    setcolor(color)
    rect(anchor(b), width(b), height(b), :fill)
    setcolor("black")
end

"""
    `Pin <: BaseShape` functions as a connector-pin, which allows for easy definition of computational flows.
"""
mutable struct Pin <: BaseShape
    p::Point
    r::Float64
end

anchor(p::Pin) = p.p
radius(p::Pin) = p.r

function draw(p::Pin)
    circle(anchor(p), radius(p), :fill)
end

"""
    `Connector <: BaseShape` the dual of `Pin`, serving as the component that brings everything together. Use it to connect two pins.
"""
mutable struct Connector <: BaseShape
    input::Pin
    output::Pin
end

input(c::Connector) = c.input
output(c::Connector) = c.output

function draw(c::Connector)
    setline(1)
    line(input(c).p, output(c).p, :stroke)
    setline(2)
end


"""
    `ActionPoint <: BaseShape`


"""
mutable struct ActionPoint <: BaseShape
    p::Point
    r::Float64
end

anchor(p::ActionPoint) = p.p
radius(p::ActionPoint) = p.r
