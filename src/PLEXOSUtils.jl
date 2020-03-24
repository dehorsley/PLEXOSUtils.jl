module PLEXOSUtils

import EzXML: Document, eachelement, namespace, Node, nodecontent, parsexml
import InfoZIP: open_zip

export PLEXOSSolutionDataset

struct PLEXOSTable
    name::String
    fieldname::Symbol
    fieldtype::Symbol
    identifier::Union{String,Nothing}
    zeroindexed::Bool
end

PLEXOSTable(name::String, fieldname::Symbol, fieldtype::Symbol) =
    PLEXOSTable(name, fieldname, fieldtype, nothing, false)

PLEXOSTable(name::String, fieldname::Symbol, fieldtype::Symbol,
            identifier::Union{String,Nothing}) =
    PLEXOSTable(name, fieldname, fieldtype, identifier, false)

plexostables = [

    PLEXOSTable("t_config", :configs, :PLEXOSConfig),
    PLEXOSTable("t_unit", :units, :PLEXOSUnit, "unit_id", true),
    PLEXOSTable("t_timeslice", :timeslices, :PLEXOSTimeslice, "timeslice_id", true),
    PLEXOSTable("t_model", :models, :PLEXOSModel, "model_id"),

    PLEXOSTable("t_sample", :samples, :PLEXOSSample, "sample_id", true),
    PLEXOSTable("t_sample_weight", :sampleweights, :PLEXOSSampleWeight),

    PLEXOSTable("t_class_group", :classgroups, :PLEXOSClassGroup, "class_group_id"),
    PLEXOSTable("t_class", :classes, :PLEXOSClass, "class_id"),
    PLEXOSTable("t_category", :categories, :PLEXOSCategory, "category_id"),

    PLEXOSTable("t_collection", :collections, :PLEXOSCollection, "collection_id"),
    PLEXOSTable("t_property", :properties, :PLEXOSProperty, "property_id"),

    PLEXOSTable("t_object", :objects, :PLEXOSObject, "object_id"),
    PLEXOSTable("t_membership", :memberships, :PLEXOSMembership, "membership_id"),

    PLEXOSTable("t_period_0", :intervals, :PLEXOSPeriod0, "interval_id"),
    PLEXOSTable("t_period_1", :days, :PLEXOSPeriod1, "day_id"),
    PLEXOSTable("t_period_2", :weeks, :PLEXOSPeriod2, "week_id"),
    PLEXOSTable("t_period_3", :months, :PLEXOSPeriod3, "month_id"),
    PLEXOSTable("t_period_4", :years, :PLEXOSPeriod4, "fiscal_year_id"),
    PLEXOSTable("t_period_6", :hours, :PLEXOSPeriod6, "hour_id"),
    PLEXOSTable("t_period_7", :quarters, :PLEXOSPeriod7, "quarter_id"),

    PLEXOSTable("t_phase_2", :pasa_intervals, :PLEXOSPhase2),
    PLEXOSTable("t_phase_3", :mt_intervals, :PLEXOSPhase3),
    PLEXOSTable("t_phase_4", :st_intervals, :PLEXOSPhase4),

    PLEXOSTable("t_key", :keys, :PLEXOSKey, "key_id"),
    PLEXOSTable("t_key_index", :keyindices, :PLEXOSKeyIndex)

]

plexostables_lookup = Dict(x.name => x for x in plexostables)

include("types.jl")
include("PLEXOSSolutionDataset.jl")
include("summarize.jl")
include("utils.jl")

end
