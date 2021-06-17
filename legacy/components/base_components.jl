"""
    `Component`

Any visualization of an algorithmic component must derive from this abstract type.
"""

abstract type Component end
upperleft(c::Component) = upperleft(baseshape(c))
width(c::Component) = width(baseshape(c))
height(c::Component) = height(baseshape(c))
input(c::Component) = c.input
output(c::Component) = c.output

function draw(c::C) where C <: Component
    b = baseshape(c)
    draw(b)
    draw(input(c))
    draw(output(c))
end

function connect(origin::Component, destination::Component)
    Connector(output(origin), input(destination))
end


"""
    `SimpleComponent <: Component`

The most basic component provides a component-block with one input-pin and one output-pin.
"""
struct SimpleComponent <: Component
    block::Block
    input::Pin
    output::Pin
end

baseshape(sc::SimpleComponent) = sc.block

function SimpleComponent(p0::Point, w, h)
    b = Block(p0, w, h)
    input = Pin(p0 + Point(0, h/2), h/50)
    output = Pin(p0 + Point(w, h/2), h/50)
    return SimpleComponent(b, input, output)
end


"""
    `TimedComponent{C <: Component} <: Component`

Add a timebar to component by wrapping the component in this struct. Position of the timebar can be either `:N` or `:S`, for above or below the component respectively. This can be set through the keyword `orientation = :N`.
"""
struct TimedComponent{C <: Component} <: Component
    component::C
    time_block::Block
    orientation::Symbol
end

"""
    `component(tc::TimedComponent)`

Returns the component contained in this struct.
"""
component(tc::TimedComponent) = tc.component
timeblock(tc::TimedComponent) = tc.time_block
baseshape(tc::TimedComponent) = baseshape(component(tc))
input(tc::TimedComponent) = input(component(tc))
output(tc::TimedComponent) = output(component(tc))


function TimedComponent(component::C; orientation= :S) where C
    p0 = upperleft(component)
    if orientation == :N
        p0 += Point(0, - 2/10*height(component))
    elseif orientation == :S
        p0 += Point(0, 11/10*height(component))
    end
    block = Block(p0, width(component), height(component)/10)
    tc = TimedComponent(component, block, orientation)
    return tc
end

function draw(c::TimedComponent)
    draw(component(c))
    draw(timeblock(c))
end

"""
    `Sampler{S} <: Component`

Construct the basis of a sampling-visualization. Samplers are parametric on the type of the space they sample from. By default, a sampler visualization is constructed by reshaping the full space of elements to a 2D-matrix, which is displayed.
"""
struct Sampler{C <: Component, S} <: Component
     inner_component:: Component
     N::S
     space::Array{ActionPoint,1}
end

function Sampler(N, l)
    dim = Int(ceil(sqrt(l)))
    space = [ActionPoint()]
end


abstract type Template end

struct SimpleTemplate <: Template
    input::Pin
    output::Pin
    connectors::Dict{Connector, Component}
    components::Array{Component,1}
end

input(s::SimpleTemplate) = s.input
output(s::SimpleTemplate) = s.output
connectors(s::SimpleTemplate) = keys(s.connectors)
components(s::SimpleTemplate) = s.components
getcomponent(s::SimpleTemplate, v) = s.components[v]

function destinations(s, pin)
    _D = Dict{Connector, Component}
    _C = connectors(s)
    for (conn, comp) in pairs(_C)
        if input(conn) == pin
            _D[conn] = comp
        end
    end
    return _D
end
