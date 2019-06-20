# using Revise
using Test
using Logging
using ExSu
using CSV
using DataFrames

# using LarSurf
# Logging.configure(level==Logging.Debug)


# include("../src/LarSurf.jl")
# include("../src/block.jl")

@testset "simple write to csv" begin
    fn1 = "test1.csv"
    fn2 = "test2.csv"
    if isfile(fn1) rm(fn1) end
    ExSu.add_to_csv((:one=>[1], :two=>[2]), fn1)
    @test isfile(fn1)

    if isfile(fn2) rm(fn2) end
    ExSu.add_to_csv((:one=>1, :two=>2), fn2)
    df = CSV.read(fn2)
    display(df)
    @test isfile(fn2)
end

@testset "write, write again, add new cols" begin
    fn3 = "test3.csv"
    if isfile(fn3) rm(fn3) end
    ExSu.add_to_csv((:one=>1, :two=>2), fn3)
    # Check adding to file
    @info "adding to file"
    ExSu.add_to_csv((:one=>1, :two=>2), fn3)
    df = CSV.read(fn3)
    @test size(df) == (2, 2)
    # Check add not existing rows
    ExSu.add_to_csv((:one=>1, :three=>3), fn3)
    df = CSV.read(fn3)
    @test size(df) == (3, 3)

    # Check add multiple values at a time
    ExSu.add_to_csv(Dict(:one=>[1,1], :three=>[3,3]), fn3)
    df = CSV.read(fn3)
    @test size(df) == (5, 3)
end



@testset "test basics" begin
    df = DataFrame(Dict(:A=>1, :B=>"foo"))
    ExSu.add_missing_cols!(df, Dict(:A=>1, :C=>3))
    @test size(df) == (1,3)
    # display(df)
end
