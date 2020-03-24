# PLEXOSSolutionDatasetSummary
eval(Expr(
    :struct, true, :PLEXOSSolutionDatasetSummary, Expr(:block,
        [:($(t.fieldname)::Tuple{Int,Int}) for t in plexostables]...
    )
))

PLEXOSSolutionDatasetSummary() =
    PLEXOSSolutionDatasetSummary(((0,0) for _ in 1:length(plexostables))...)

# PLEXOSSolutionDataset
eval(Expr(
    :struct, false, :PLEXOSSolutionDataset, Expr(:block,
        [:($(t.fieldname)::Vector{$(t.fieldtype)}) for t in plexostables]...
    )
))

PLEXOSSolutionDataset(summary::PLEXOSSolutionDatasetSummary) =
    PLEXOSSolutionDataset((
        Vector{eval(t.fieldtype)}(undef, last(getfield(summary, t.fieldname)))
        for t in plexostables)...)


function PLEXOSSolutionDataset(zippath::String)

    resultsarchive, xmlname = open_plexoszip(zippath)
    xml = parsexml(resultsarchive[xmlname])
    summary = summarize(xml)
    println(summary)

    result = PLEXOSSolutionDataset(summary)
    # TODO: Populate data using xml

    return result

end
