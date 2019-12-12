using CSV
using DataFrames

function prepare_empty_col(sz, tp=Any)
    arr = Array{tp, 1}(undef, sz)
    for i in 1:sz
        arr[i] = ""
#         arr[i] = nothing
    end
    return arr
end

function add_empty_col!(dataframe::DataFrame, col_name)
#     col = prepare_empty_col(size(tbl, 1), String)
    col = prepare_empty_col(size(dataframe, 1))
    if typeof(col_name) == Symbol
        column_name = col_name
    else
        column_name = Symbol(col_name)
    end
#     tbl[column_name] = 1:size(tbl,1)
    dataframe[column_name] = col
#     display(tbl)
    return dataframe

end

function add_missing_cols!(dataframe::DataFrame, to_add::Dict)

    nms = [String(name) for name in names(dataframe)]
    # @info "names as string" nms #, nms
    ks = [String(name) for name in keys(to_add)]


    allkeys = collect(Set(vcat(nms, ks)))
    # @info "names as string" allkeys
    for key in allkeys
        if key in nms
            # println("key '$key' exists")
        else
            add_empty_col!(dataframe, key)
            # println("adding empty col for key '$key'")
        end

    end
    return dataframe
end


function prepare_empty_row(tbl)
    new_row = Dict()
    for nm in names(tbl)
        if eltype(tbl[nm]) <: Number
#             println("$nm is subtype Number")
            # new_row[nm] = 0
            new_row[nm] = missing
        elseif eltype(tbl[nm]) == String
#             println("$nm is String")
            new_row[nm] = ""
        else
            new_row[nm] = missing

        end
    end

    return new_row
end

function dict_string_keys_to_symbols(to_add)
    new_to_add = Dict()
    for (key, val) in to_add
    #     println(key)
        new_to_add[Symbol(key)] = val
    end
    return new_to_add
end

function extend_row_type!(tbl1::DataFrame, tbl2::Union{Dict, DataFrame})
    # Extend data type
    for name in names(tbl1)
    # name = :one
        tbtype = Array{Union{
            eltype(tbl1[name]),
            eltype(tbl2[name])
        },1}
        tbtype
        tbl1[name] = convert(tbtype, tbl1[name])

    end
    return tbl1
end

function add_row_to_csv(row::Tuple, filename)
    return add_row_to_csv(Dict(row), filename)
end

function add_row_to_csv(row::Dict, filename)
    if isfile(filename)
        tbl = CSV.read(filename)
        tbl = DataFrame(tbl)
        @debug "display tbl" tbl
        to_add = row
        add_missing_cols!(tbl, to_add)
        @debug "missing cols" tbl
        new_row = prepare_empty_row(tbl)
        new_to_add = dict_string_keys_to_symbols(to_add)
        # print("new row: $new_row\n")
        # print("new to add: $new_to_add\n")
         merge!(new_row, new_to_add)
        # print("tbl $tbl")
        # print("new_row: $new_row")
        extend_row_type!(tbl, new_row)
        push!(tbl, new_row)
    else
        tbl = DataFrame(row)
    end
    CSV.write(filename, tbl)
    return tbl
end
