# ExSup

[![Build Status](https://travis-ci.org/mjirik/ExSup.jl.svg?branch=master)](https://travis-ci.org/mjirik/ExSup.jl)
[![Coveralls](https://coveralls.io/repos/github/mjirik/ExSup.jl/badge.svg?branch=master)](https://coveralls.io/github/mjirik/ExSup.jl?branch=master)

Package make support for experiments outputs. The experiment result is
stored as row in CSV table. The cols may be different in every experiment.

# Examples

## Save image segmentation experiment outputs
```julia
    using ExSup
    segmentation = zeros(Int, 3,3)
    segmentation[1,2:3] .= 1

    data = Dict()
    data["length"] = 1.2
    ExSup.datetime_to_dict!(data)
    ExSup.segmentation_description_to_dict!(data, segmentation)
    ExSup.add_to_csv(data, fn4)
```


## Save experiments with different rows

```julia
fn3 = "test3.csv"
ExSup.add_to_csv((:one=>1, :two=>2), fn3)
ExSup.add_to_csv((:three=>3, :two=>2), fn3)
```
