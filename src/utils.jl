function open_plexoszip(zippath::String)
    xmlname = match(r"^(.+)\.zip$", basename(zippath)).captures[1] * ".xml"
    archive = open_zip(zippath)
    return archive, xmlname
end

function getchildtext(name::String, e::Node)
    resultnode = findfirst("x:" * name, e, ["x"=>namespace(e)])
    isnothing(resultnode) && error("$e does not have child $name")
    return nodecontent(resultnode)
end

getchildfloat(name::String, e::Node) = parse(Float64, getchildtext(name, e))
getchildint(name::String, e::Node) = parse(Int, getchildtext(name, e))
getchildbool(name::String, e::Node) = parse(Bool, getchildtext(name, e))
