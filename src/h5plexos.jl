function h5plexos(
    zipfilein::String, h5fileout::String;
    compressionlevel=1, strlen=128)

    # Load zipfile data
    resultsarchive, xmlname = open_plexoszip(zipfilein)
    data = PLEXOSSolutionDataset(parsexml(resultsarchive[xmlname]))
    resultvalues = phasevalues(resultsarchive)

    h5open(h5fileout, "w") do h5file::HDF5File
        membership_idxs = addcollections!(h5file, data, strlen, compressionlevel)
        addvalues!(h5file, data, membership_idxs, resultvalues)
    end

    # Next - advance pass through keys to determine number of phases per property

    # Given a keyindex - period type, property, property collection determine dimensions
    #  - period type determines whether to use name/unit or summaryname/summaryunit
    #  - pull binary data and store in appropriate indices

end

function addcollections!(
    f::HDF5File, data::PLEXOSSolutionDataset,
    strlen::Int, compressionlevel::Int)

    counts = Dict{PLEXOSCollection,Int}()

    for membership in data.memberships
        if membership.collection in keys(counts)
            counts[membership.collection] += 1
        else
            counts[membership.collection] = 1
        end 
    end

    collections = Dict(
         collection => (Vector{Tuple{String,String}}(undef, counts[collection]), 0)
         for collection in keys(counts))

    membership_idxs = Dict{PLEXOSMembership, Int}()

    for membership in data.memberships

        collection = membership.collection
        collection_memberships, collection_idx = collections[collection]
        collection_idx += 1

        membership_idxs[membership] = collection_idx

        collection_memberships[collection_idx] =
            isnothing(collection.complementname) ?
                (membership.childobject.name, # object collection
                 membership.childobject.category.name) :
                (membership.parentobject.name, # relation collection
                 membership.childobject.name)

        collections[collection] = (collection_memberships, collection_idx)

    end

    h5meta = g_create(f, "metadata")
    h5objects = g_create(h5meta, "objects")
    h5relations = g_create(h5meta, "relations")

    for collection in keys(collections)

        collection_memberships, _ = collections[collection]

        if collection.parentclass.name == "System" # object collection

            string_table!(h5objects, sanitize(collection.name), strlen,
                          ("name", "category"), collection_memberships)

        else # relation collection

            prefix = isnothing(collection.complementname) ?
                collection.parentclass.name : collection.complementname

            string_table!(h5relations, sanitize(prefix * "_" * collection.name),
                          strlen, ("parent", "child"), collection_memberships)

        end

    end

    return membership_idxs

end

function addvalues!(
    h5file::HDF5File, data::PLEXOSSolutionDataset,
    membership_idxs::Dict{PLEXOSMembership,Int},
    resultvalues::Dict{Int,Vector{UInt8}})

    for ki in data.keyindices

        key = ki.key
        periodtype = ki.periodtype
        collection = key.membership.collection
        collection_idx = membership_idxs[key.membership]
        property = key.property

        start_idx = ki.position + 1
        end_idx = ki.position + 8*ki.length
        rawvalues = view(resultvalues[periodtype], start_idx:end_idx)
        values = reinterpret(Float64, rawvalues)

        data_interval = ki.periodoffset .+ (1:length(values))

        # Create the phase/period/property dataset if needed,
        # and write relevant data to it

    end

end

# KeyIndex.periodoffset describes any mismatch between the binary data
# starting point and the provided intervals

# Period type 0 - phase-native interval data (blocks)
# Maps to ST period 0 via relevant phase table
# Store both block and interval results on disk (if not ST)

# Period type 1-7 - period-type-specific data
# Direct mapping to period labels
