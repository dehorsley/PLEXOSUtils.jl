module PLEXOSUtils

import EzXML: Document, eachelement, namespace, Node, nodecontent, parsexml
import InfoZIP: open_zip

export PLEXOSSolutionDataset

struct PLEXOSTable
    name::String
    fieldname::Symbol
    fieldtype::Symbol
    loadorder::Int
    identifier::Union{String,Nothing}
    zeroindexed::Bool
end

PLEXOSTable(name::String, fieldname::Symbol, fieldtype::Symbol, loadorder::Int) =
    PLEXOSTable(name, fieldname, fieldtype, loadorder, nothing, false)

PLEXOSTable(name::String, fieldname::Symbol, fieldtype::Symbol, loadorder::Int,
            identifier::Union{String,Nothing}) =
    PLEXOSTable(name, fieldname, fieldtype, loadorder, identifier, false)

plexostables = [

    PLEXOSTable("t_config", :configs, :PLEXOSConfig, 1),
    PLEXOSTable("t_unit", :units, :PLEXOSUnit, 1, "unit_id", true),
    PLEXOSTable("t_timeslice", :timeslices, :PLEXOSTimeslice, 1, "timeslice_id", true),
    PLEXOSTable("t_model", :models, :PLEXOSModel, 1, "model_id"),

    PLEXOSTable("t_sample", :samples, :PLEXOSSample, 1, "sample_id", true),
    PLEXOSTable("t_sample_weight", :sampleweights, :PLEXOSSampleWeight, 2),

    PLEXOSTable("t_class_group", :classgroups, :PLEXOSClassGroup, 1, "class_group_id"),
    PLEXOSTable("t_class", :classes, :PLEXOSClass, 2, "class_id"),
    PLEXOSTable("t_category", :categories, :PLEXOSCategory, 3, "category_id"),

    PLEXOSTable("t_collection", :collections, :PLEXOSCollection, 3, "collection_id"),
    PLEXOSTable("t_property", :properties, :PLEXOSProperty, 4, "property_id"),

    PLEXOSTable("t_object", :objects, :PLEXOSObject, 4, "object_id"),
    PLEXOSTable("t_membership", :memberships, :PLEXOSMembership, 5, "membership_id"),

    PLEXOSTable("t_period_0", :intervals, :PLEXOSPeriod0, 1, "interval_id"),
    PLEXOSTable("t_period_1", :days, :PLEXOSPeriod1, 1, "day_id"),
    PLEXOSTable("t_period_2", :weeks, :PLEXOSPeriod2, 1, "week_id"),
    PLEXOSTable("t_period_3", :months, :PLEXOSPeriod3, 1, "month_id"),
    PLEXOSTable("t_period_4", :years, :PLEXOSPeriod4, 1, "fiscal_year_id"),
    PLEXOSTable("t_period_6", :hours, :PLEXOSPeriod6, 1, "hour_id"),
    PLEXOSTable("t_period_7", :quarters, :PLEXOSPeriod7, 1, "quarter_id"),

    PLEXOSTable("t_phase_2", :pasa_intervals, :PLEXOSPhase2, 2),
    PLEXOSTable("t_phase_3", :mt_intervals, :PLEXOSPhase3, 2),
    PLEXOSTable("t_phase_4", :st_intervals, :PLEXOSPhase4, 2),

    PLEXOSTable("t_key", :keys, :PLEXOSKey, 6, "key_id"),
    PLEXOSTable("t_key_index", :keyindices, :PLEXOSKeyIndex, 7)

]

plexostables_lookup = Dict(x.name => x for x in plexostables)

include("types.jl")
include("PLEXOSSolutionDataset.jl")
include("summarize.jl")
include("utils.jl")

end
