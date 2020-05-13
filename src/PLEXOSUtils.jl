module PLEXOSUtils

import EzXML: Document, eachelement, iterate, Node, nodedepth, nodecontent, nodename, parsexml, READER_ELEMENT, StreamReader
import InfoZIP: Archive, open_zip

export open_plexoszip, PLEXOSSolutionDataset, summarize

abstract type AbstractDataset end

include("tablerowtypes.jl")
include("tables.jl")
include("PLEXOSSolutionDatasetSummary.jl")
include("PLEXOSSolutionDataset.jl")
include("utils.jl")

end
