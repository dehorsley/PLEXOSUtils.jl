# PLEXOSPrelimSolutionDataset

eval(Expr(
    :struct, false, :(PLEXOSPrelimSolutionDataset <: AbstractDataset), Expr(
        :block,
        map(t -> :($(t.fieldname)::Vector{$(prelimrowtype(t))}), tables)...
    )
))

function PLEXOSPrelimSolutionDataset(
    summary::Dict{String,Tuple{Int,Int}};
    consolidated::Bool=false)::PLEXOSPrelimSolutionDataset

    selector = consolidated ? first : last

    return PLEXOSPrelimSolutionDataset((
        _(undef, selector(summary[t.fieldname]))
        for t in plexostables)...)

end

# PLEXOSSolutionDataset

eval(Expr(
    :struct, false, :(PLEXOSSolutionDataset <: AbstractDataset), Expr(
        :block,
        map(t -> :($(t.fieldname)::Vector{$(t.rowtype)}), tables)...
    )
))

function PLEXOSSolutionDataset(
    summary::Dict{String,Tuple{Int,Int}};
    consolidated::Bool=false)::PLEXOSSolutionDataset

    selector = consolidated ? first : last

    return PLEXOSSolutionDataset((
        _(undef, selector(summary[t.fieldname]))
        for t in plexostables)...)

end

function PLEXOSSolutionDataset(zippath::String)
    resultsarchive, xmlname = _open_plexoszip(zippath)
    xml = parsexml(resultsarchive[xmlname])
    return PLEXOSSolutionDataset(xml)
end

function PLEXOSSolutionDataset(xml::IO)

    summary = summarize(xml)

    result_temp = PLEXOSPrelimSolutionDataset(summary, consolidated=false)
    idxcounter = Dict(k => 0 for k in keys(plexostables)
                             if !haskey(identifiers, t))

    # New strategy: single pass, filling in what data is possible right away
    # and storing index numbers seperately. Then, go through tables in
    # topological order and add in references based on stored indices.

    xmlstream = StreamReader(xml)
    iterate(xmlstream) # Move to root element
    nodename(xmlstream) == "SolutionDataset" || error("Unrecognized XML data")

    for node in xmlstream

        node == READER_ELEMENT || continue
        nodedepth(xmlstream) == 1 || continue

        tablename = nodename(xmlstream)

        # Ignore the band table
        tablename == "t_band" && continue

        tablespec, tablefields = table_lookup[tablename]
        row = tablespec.rowtype()

        idx = parsexml!(row, xmlstream, tablespec, tablefields)

        if isnothing(tablespec.identifier)
            idx = (idxcounter[tablename] += 1)
        end

        tabledata = getfield(result_temp, tablespec.fieldname)
        tabledata[idx] = row

    end

    result = PLEXOSSolutionDataset(summary, consolidated=false)

    for tablespec in sort(tables, by = x -> x.loadorder)

        fieldname = tablespec.fieldname
        tempdata = getfield(result_temp, fieldname)
        data = getfield(result, fieldname)

        for i in eachindex(tempdata)
            isassigned(tempdata, i) || continue
            data[i] = finalize(tempdata[i], tablespec, result)
        end

    end

    return consolidate(result, summary)

end

function consolidate(
    unconsolidated::PLEXOSSolutionDataset,
    summary::Dict{String,Tuple{Int,Int}})

    result = PLEXOSSolutionDataset(summary, consolidated=true)

    for name in fieldnames(PLEXOSSolutionDataset)
        idx = 0
        vec = getfield(unconsolidated, name)
        for i in 1:length(vec)
            if isassigned(vec, i)
                idx += 1
                getfield(result, name)[idx] = vec[i]
            end
        end
    end

    return result

end
