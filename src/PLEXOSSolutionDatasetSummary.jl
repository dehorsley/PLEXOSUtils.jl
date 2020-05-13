function summarize(zippath::String)

    resultsarchive, xmlname = _open_plexoszip(zippath)
    xml = IOBuffer(resultsarchive[xmlname])
    return summarize(xml)

end

function summarize(xml::IO)

    summary = Dict(k => (0,0) for k in keys(plexostables))

    xmlstream = StreamReader(xml)

    iterate(xmlstream) # Move to root element
    nodename(xmlstream) == "SolutionDataset" || error("Unrecognized XML data")

    for node in xmlstream

        node == READER_ELEMENT || continue
        nodedepth(xmlstream) == 1 || continue

        tablename = nodename(xmlstream)

        # Ignore the band table
        tablename == "t_band" && continue

        table = plexostables[tablename]
        count, maxidx = summary[tablename]

        if table.selfidentifying
            idx = getchildint(identifiers[tablename], xmlstream)
            table.zeroindexed && (idx += 1)
            summary[tablename] = (count + 1, max(maxidx, idx))
        else
            summary[tablename] = (count + 1, count + 1)
        end

    end

    return summary

end
