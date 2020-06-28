function open_plexoszip(zippath::String)
    resultsarchive, xmlname = _open_plexoszip(zippath)
    data = PLEXOSSolutionDataset(parsexml(resultsarchive[xmlname]))
    resultvalues = perioddata(resultsarchive)
    return data, resultvalues
end

function _open_plexoszip(zippath::String)
    isfile(zippath) || error("$zippath does not exist")
    xmlname = match(r"^(.+)\.zip$", basename(zippath)).captures[1] * ".xml"
    archive = open_zip(zippath)
    return archive, xmlname
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

function getchildtext(name::String, xmlstream::StreamReader)
    for node in xmlstream
        nodedepth(xmlstream) == 1 && break
        node == READER_ELEMENT || continue
        nodename(xmlstream) == name && return nodecontent(xmlstream)
    end
    error("$e does not have child $name")
end

getchild(::Type{T}, name::String, s::StreamReader) where T =
    parse(T, getchildtext(name, s))

getchildfloat(name::String, s::StreamReader) = parse(Float64, getchildtext(name, s))
getchildint(name::String, s::StreamReader) = parse(Int, getchildtext(name, s))
getchildbool(name::String, s::StreamReader) = parse(Bool, getchildtext(name, s))
