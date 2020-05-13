struct PLEXOSTable{T<:PLEXOSTableRow,S}
    loadorder::Int
    selfidentifying::Bool
    zeroindexed::Bool

    PLEXOSTable{T,S}(;
        loadorder::Int=1,
        selfidentifying::Bool=true,
        zeroindexed::Bool=false
    ) where {T,S} = new{T,S}(loadorder, selfidentifying, zeroindexed)

end

tabletype(::PLEXOSTable{T}) where {T<:PLEXOSTableRow} = Vector{T}
fieldname(::PLEXOSTable{T,S}) where {T,S} = S

const plexostables = Dict([

    "t_config" => PLEXOSTable{PLEXOSConfig,:configs}(selfidentifying=false),
    "t_unit" => PLEXOSTable{PLEXOSUnit,:units}(zeroindexed=true),
    "t_timeslice" => PLEXOSTable{PLEXOSTimeslice,:timeslices}(zeroindexed=true),
    "t_model" => PLEXOSTable{PLEXOSModel,:models}(),

    "t_sample" => PLEXOSTable{PLEXOSSample,:samples}(zeroindexed=true),
    "t_sample_weight" => PLEXOSTable{PLEXOSSampleWeight,:sampleweights}(
        loadorder=2, selfidentifying=false),

    "t_class_group" => PLEXOSTable{PLEXOSClassGroup,:classgroups}(),
    "t_class" => PLEXOSTable{PLEXOSClass,:classes}(loadorder=2),
    "t_category" => PLEXOSTable{PLEXOSCategory,:categories}(loadorder=3),

    "t_attribute" => PLEXOSTable{PLEXOSAttribute,:attributes}(loadorder=3),
    "t_collection" => PLEXOSTable{PLEXOSCollection,:collections}(loadorder=3),
    "t_property" => PLEXOSTable{PLEXOSProperty,:properties}(loadorder=4),

    "t_object" => PLEXOSTable{PLEXOSObject,:objects}(loadorder=4),
    "t_membership" => PLEXOSTable{PLEXOSMembership,:memberships}(loadorder=5),
    "t_attribute_data" => PLEXOSTable{PLEXOSAttributeData,:attribute_data}(
        loadorder=5, selfidentifying=false),

    "t_period_0" => PLEXOSTable{PLEXOSPeriod0,:intervals}(),
    "t_period_1" => PLEXOSTable{PLEXOSPeriod1,:days}(),
    "t_period_2" => PLEXOSTable{PLEXOSPeriod2,:weeks}(),
    "t_period_3" => PLEXOSTable{PLEXOSPeriod3,:months}(),
    "t_period_4" => PLEXOSTable{PLEXOSPeriod4,:years}(),
    "t_period_6" => PLEXOSTable{PLEXOSPeriod6,:hours}(),
    "t_period_7" => PLEXOSTable{PLEXOSPeriod7,:quarters}(),

    "t_phase_2" => PLEXOSTable{PLEXOSPhase2,:pasa}(loadorder=2, selfidentifying=false),
    "t_phase_3" => PLEXOSTable{PLEXOSPhase3,:mt}(loadorder=2, selfidentifying=false),
    "t_phase_4" => PLEXOSTable{PLEXOSPhase4,:st}(loadorder=2, selfidentifying=false),

    "t_key" => PLEXOSTable{PLEXOSKey,:keys}(loadorder=6),
    "t_key_index" => PLEXOSTable{PLEXOSKeyIndex,:keyindices}(loadorder=7, selfidentifying=false)

])

const plexostables = (

    PLEXOSTable{PLEXOSConfig,:configs}("t_config", 1),
    PLEXOSTable{PLEXOSUnit,:units}("t_unit", 1, "unit_id", true),
    PLEXOSTable{PLEXOSTimeslice,:timeslices}("t_timeslice", 1, "timeslice_id", true),
    PLEXOSTable{PLEXOSModel,:models}("t_model", 1, "model_id"),

    PLEXOSTable{PLEXOSSample,:samples}("t_sample", 1, "sample_id", true),
    PLEXOSTable{PLEXOSSampleWeight,:sampleweights}("t_sample_weight", 2),

    PLEXOSTable{PLEXOSClassGroup,:classgroups}("t_class_group", 1, "class_group_id"),
    PLEXOSTable{PLEXOSClass,:classes}("t_class", 2, "class_id"),
    PLEXOSTable{PLEXOSCategory,:categories}("t_category", 3, "category_id"),

    PLEXOSTable{PLEXOSAttribute,:attributes}("t_attribute", 3, "attribute_id"),
    PLEXOSTable{PLEXOSCollection,:collections}("t_collection", 3, "collection_id"),
    PLEXOSTable{PLEXOSProperty,:properties}("t_property", 4, "property_id"),

    PLEXOSTable{PLEXOSObject,:objects}("t_object", 4, "object_id"),
    PLEXOSTable{PLEXOSMembership,:memberships}("t_membership", 5, "membership_id"),
    PLEXOSTable{PLEXOSAttributeData,:attribute_data}("t_attribute_data", 5),

    PLEXOSTable{PLEXOSPeriod0,:intervals}("t_period_0", 1, "interval_id"),
    PLEXOSTable{PLEXOSPeriod1,:days}("t_period_1", 1, "day_id"),
    PLEXOSTable{PLEXOSPeriod2,:weeks}("t_period_2", 1, "week_id"),
    PLEXOSTable{PLEXOSPeriod3,:months}("t_period_3", 1, "month_id"),
    PLEXOSTable{PLEXOSPeriod4,:years}("t_period_4", 1, "fiscal_year_id"),
    PLEXOSTable{PLEXOSPeriod6,:hours}("t_period_6", 1, "hour_id"),
    PLEXOSTable{PLEXOSPeriod7,:quarters}("t_period_7", 1, "quarter_id"),

    PLEXOSTable{PLEXOSPhase2,:pasa}("t_phase_2", 2),
    PLEXOSTable{PLEXOSPhase3,:mt}("t_phase_3", 2),
    PLEXOSTable{PLEXOSPhase4,:st}("t_phase_4", 2),

    PLEXOSTable{PLEXOSKey,:keys}("t_key", 6, "key_id"),
    PLEXOSTable{PLEXOSKeyIndex,:keyindices}("t_key_index", 7)

)
