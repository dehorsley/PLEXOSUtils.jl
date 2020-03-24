function summarize(zippath::String)

    resultsarchive, xmlname = summarize(open_plexoszip(zippath)...)
    xml = parsexml(resultsarchive[xmlname])
    return summarize(xml)

    # TODO:
    # Pull out binary files
    # Scan XML file and track largest index of each table group
    # Check binary file sizes and compare against expected sizes from XML references

end

function summarize(xml::Document)

    summary = PLEXOSSolutionDatasetSummary()

    for element in eachelement(xml.root)

        # Ignore the band table
        element.name == "t_band" && continue

        table = plexostables_lookup[element.name]
        count, maxidx = getfield(summary, table.fieldname)

        if isnothing(table.identifier)
            setfield!(summary, table.fieldname, (count + 1, count + 1))
        else
            idx = getchildint(table.identifier, element)
            table.zeroindexed && (idx += 1)
            setfield!(summary, table.fieldname, (count + 1, max(maxidx, idx)))
        end

    end

    return summary

end
