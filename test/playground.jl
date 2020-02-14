using PolyaViz


sc1 = SimpleComponent(Point(100,100), 100,100)
sc2 = SimpleComponent(Point(250,100), 100,100)

Sampler{Int}(Point(50,50), 100,100)
c = connect(sc1, sc2)

Drawing(500,400)

draw(sc1)
draw(sc2)
draw(c)

finish()
preview()
