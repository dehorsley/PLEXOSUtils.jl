# PLEXOSSolutionDatasetSummary

eval(Expr(
    :struct, true, :PLEXOSSolutionDatasetSummary, Expr(:block,
        [:($(t.fieldname)::Tuple{Int,Int}) for t in plexostables]...
    )
))

PLEXOSSolutionDatasetSummary() =
    PLEXOSSolutionDatasetSummary(((0,0) for _ in 1:length(plexostables))...)

# IndexCounter

eval(Expr(
    :struct, true, :IndexCounter, Expr(:block,
        [:($(t.fieldname)::Int) for t in plexostables if isnothing(t.identifier)]...
    )
))

IndexCounter() = IndexCounter(zeros(Int, length(fieldnames(IndexCounter)))...)

function increment!(x::IndexCounter, fieldname::Symbol)
    idx = getfield(x, fieldname) + 1
    setfield!(x, fieldname, idx)
    return idx
end

# PLEXOSSolutionDataset

eval(Expr(
    :struct, false, :(PLEXOSSolutionDataset <: AbstractDataset), Expr(:block,
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

    result = PLEXOSSolutionDataset(summary)
    idxcounter = IndexCounter()

    for loadorder in 1:7
        for element in eachelement(xml.root)

            # Ignore the band table
            element.name == "t_band" && continue

            table = plexostables_lookup[element.name]
            table.loadorder == loadorder || continue

            idx = if isnothing(table.identifier)
                      increment!(idxcounter, table.fieldname)
                  else
                      getchildint(table.identifier, element)
                  end
            table.zeroindexed && (idx += 1)

            getfield(result, table.fieldname)[idx] =
                eval(table.fieldtype)(element, result)

        end
    end

    return result

end

# Results are driven by keyindex -> key -> (membership + property) -> collection

# Report all collections containing members

# Binary data relationships - determine how data relates to
# a period type vs phase period?

# PASA - interval only?
# MT - interval only?
# ST - multiple levels
