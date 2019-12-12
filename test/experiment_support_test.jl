# using Revise
using Test
using Logging
using ExSup
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
    ExSup.add_to_csv((:one=>[1], :two=>[2]), fn1)
    @test isfile(fn1)

    if isfile(fn2) rm(fn2) end
    ExSup.add_to_csv((:one=>1, :two=>2), fn2)
    df = CSV.read(fn2)
    display(df)
    @test isfile(fn2)
end

@testset "write, write again, add new cols" begin
    fn3 = "test3.csv"
    if isfile(fn3) rm(fn3) end
    ExSup.add_to_csv((:one=>1, :two=>2), fn3)
    # Check adding to file
    @info "adding to file"
    ExSup.add_to_csv((:one=>1, :two=>2), fn3)
    df = CSV.read(fn3)
    @test size(df) == (2, 2)
    # Check add not existing rows
    ExSup.add_to_csv((:one=>1, :three=>3), fn3)
    df = CSV.read(fn3)
    @test size(df) == (3, 3)

    # Check add multiple values at a time
    ExSup.add_to_csv(Dict(:one=>[1,1], :three=>[3,3]), fn3)
    df = CSV.read(fn3)
    @test size(df) == (5, 3)
end



@testset "test basics" begin
    df = DataFrame(Dict(:A=>1, :B=>"foo"))
    ExSup.add_missing_cols!(df, Dict(:A=>1, :C=>3))
    @test size(df) == (1,3)
    # display(df)
end

@testset "write, datetime" begin
    fn4 = "test4.csv"
    if isfile(fn4) rm(fn4) end

    segmentation = zeros(Int, 3,3)
    segmentation[1,2:3] .= 1

    data = Dict()
    data["measurement 1 "] = 1.2
    ExSup.datetime_to_dict!(data)
    ExSup.segmentation_description_to_dict!(data, segmentation)
    @test length(data) > 1
    ExSup.add_to_csv(data, fn4)
    ExSup.add_to_csv((:one=>1, :three=>3), fn4)
end


@testset "extend row type" begin
    tbl1 = DataFrame((:one=>[1], :two=>[2]))
    tbl2 = DataFrame((:one=>[1.1], :two=>[2]))
    row = Dict((:one=>1.2, :two=>2))

    still_tbl1 = ExSup.extend_row_type!(tbl1, row)
    @test typeof(still_tbl1) <: DataFrame
    @test typeof(ExSup.extend_row_type!(tbl1, tbl2)) <: DataFrame
end


@testset "check type unions" begin
    fn = "test4.csv"
    if isfile(fn3) rm(fn)
    ExSup.add_to_csv((:one=>1, :two=>2), fn)
    ExSup.add_to_csv((:three=>2, :two=>2), fn)
    @test isfile(fn)
    ExSup.add_to_csv((:one=>1.3, :two=>2), fn)
    @test isfile(fn)
    ExSup.add_to_csv((:one=>missing, :two=>2), fn)
    @test isfile(fn)


end
