function open_plexoszip(zippath::String)
    resultsarchive, xmlname = _open_plexoszip(zippath)
    data = PLEXOSSolutionDataset(parsexml(resultsarchive[xmlname]))
    resultvalues = perioddata(resultsarchive)
    return data, resultvalues
end

function _open_plexoszip(zippath::String)
    isfile(zippath) || error("$zippath does not exist")
    archive = open_zip(zippath)
    filenames = keys(archive)
    xml_idx = findfirst(x -> !isnothing(match(r".xml$", x)), filenames)
    isnothing(xml_idx) && error("$zippath does not contain a valid XML file")
    return archive, filenames[xml_idx]
end

function perioddata(archive::Archive)
    results = Dict{Int,Vector{UInt8}}()
    for filename in keys(archive)
        rgx = match(r"t_data_(\d).BIN", filename)
        isnothing(rgx) && continue
        data = archive[filename]
        results[parse(Int, rgx[1])] = data
    end
    return results
end

function getchildtext(name::String, e::Node)
    resultnode = findfirst("x:" * name, e, ["x"=>namespace(e)])
    isnothing(resultnode) && error("$e does not have child $name")
    return nodecontent(resultnode)
end

getchildfloat(name::String, e::Node) = parse(Float64, getchildtext(name, e))
getchildint(name::String, e::Node) = parse(Int, getchildtext(name, e))
getchildbool(name::String, e::Node) = parse(Bool, getchildtext(name, e))
