# using Revise
using Test
using Logging
using ExSu
# using LarSurf
# Logging.configure(level==Logging.Debug)


# include("../src/LarSurf.jl")
# include("../src/block.jl")

@testset "to_csv" begin
    ExSu.add_to_csv((:jedna=>[1], :dva=>[2]), "test1.csv")
    @test isfile("test1.csv")
    ExSu.add_to_csv((:jedna=>1, :dva=>2), "test2.csv")
    @test isfile("test2.csv")
end
