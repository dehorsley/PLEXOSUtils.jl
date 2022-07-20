using ZipFile

function open_plexos(path::String, xmlname::String=defaultxml(zippath))
    if !isnothing(match(r"\.zip$", path))
        return open_plexoszip(path, xmlname)
    end

    println("opening as path")

    println("parsing xml")
    xmlfile = open(joinpath(path, xmlname), "r")
    xml = parsexml(read(xmlfile, String))
    close(xmlfile)

    println("loading parsed xml")
    data = PLEXOSSolutionDataset(xml)

    println("reading bin files")
    results = Dict{Int,Vector{UInt8}}()
    for f in readdir(path, join=true)
        rgx = match(r"t_data_(\d)\.BIN", f)
        if isnothing(rgx)
            continue
        end
        f = open(f, "r")
        results[parse(Int, rgx[1])] = read(f)
        close(f)
    end
    println("done")
    return data, results
end

function open_plexoszip(zippath::String, xmlname::String=defaultxml(zippath))

    r = _open_plexoszip(zippath)
    xml = _read_xml_from_zip(r, xmlname)
    data = PLEXOSSolutionDataset(xml)
    resultvalues = perioddata(r)
    close(r)

    return data, resultvalues

end

function _read_xml_from_zip(r::ZipFile.Reader, xmlname::String)
    for f in r.files
        if f.name == xmlname
            return parsexml(read(f, String))
        end
    end
    error("File $xmlname not in zip")
end

function _open_plexoszip(zippath::String)
    isfile(zippath) || error("$zippath does not exist")
    # archive = open_zip(zippath)
    archive = ZipFile.Reader(zippath)
    return archive
end

defaultxml(zippath::String) = replace(basename(zippath), r".zip$" => ".xml")

function perioddata(archive)
    results = Dict{Int,Vector{UInt8}}()
    for f in archive.files
        rgx = match(r"t_data_(\d).BIN", f.name)
        isnothing(rgx) && continue
        data = read(f, String)
        # data = f
        results[parse(Int, rgx[1])] = data
    end
    return results
end

function getchildtext(name::String, e::Node)
    resultnode = findfirst("x:" * name, e, ["x" => namespace(e)])
    isnothing(resultnode) && error("$e does not have child $name")
    return nodecontent(resultnode)
end

getchildfloat(name::String, e::Node) = parse(Float64, getchildtext(name, e))
getchildint(name::String, e::Node) = parse(Int, getchildtext(name, e))
getchildbool(name::String, e::Node) = parse(Bool, getchildtext(name, e))
