using Polya
using PolyaViz
using Test


N = Neighborhood(Swap, LowerTriMatrix(ColMajor, 3))

tag = "mymove"
loggedN = logged(N, tag)

for m in loggedN
    i = 0
end
Nlogs = logs(lggedN)

to_tag(tag) = m -> tag*join(ϕ(m), ":")
Ntags = map(to_tag(tag), collect(N))

@testset "PolyaViz.jl" begin
    # Write your own tests here.
    @test sum(map( (t1, t2) -> t1 != t2, Iterators.zip(logs(Nlogs), Ntags))) == 0
end
