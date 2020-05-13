abstract type PLEXOSTableRow end

struct FieldSpec
    fieldname::Symbol
    fieldtype::Symbol
    xmlname::String
end

struct TableSpec
    rowtype::Symbol
    fieldname::Symbol
    tablename::String
    identifier::Union{String,Nothing}
    loadorder::Int
    zeroindexed::Bool
    basefields::Vector{FieldSpec}
    relationfields::Vector{FieldSpec}
end

const tables = [

    TableSpec(
        :PLEXOSConfig, :configs, "t_config", nothing, 1, false,
        [FieldSpec(:element, :String, "element"),
         FieldSpec(:value, :String, "value")],
        FieldSpec[]),

    TableSpec(
        :PLEXOSUnit, :units, "t_unit", "unit_id", 1, true,
        [FieldSpec(:value, :String, "value")],
        FieldSpec[]),

    TableSpec(
        :PLEXOSTimeslice, :timeslices, "t_timeslice", "timeslice_id", 1, true, 
        [FieldSpec(:name, :String, "name")],
        FieldSpec[]),

    TableSpec(
        :PLEXOSModel, :models, "t_model", "model_id", 1, false, 
        [FieldSpec(:name, :String, "name")],
        FieldSpec[]),

    TableSpec(
        :PLEXOSSample, :samples, "t_sample", "sample_id", 1, true, 
        [FieldSpec(:name, :String, "sample_name")],
        FieldSpec[]),

    TableSpec(
        :PLEXOSSampleWeight, :sampleweights, "t_sample_weight", nothing, 2, false, 
        [FieldSpec(:phase, :Int, "phase_id"),
         FieldSpec(:value, :Float64, "value")],
        [FieldSpec(:sample, :PLEXOSSample, "sample_id")]),

    TableSpec(
        :PLEXOSClassGroup, :classgroups, "t_class_group", "class_group_id", 1, false, 
        [FieldSpec(:name, :String, "name")],
        FieldSpec[]),

    TableSpec(
        :PLEXOSClass, :classes, "t_class", "class_id", 2, false, 
        [FieldSpec(:name, :String, "name"),
         FieldSpec(:state, :Int, "state")],
        [FieldSpec(:classgroup, :PLEXOSClassGroup, "class_group_id")]),

    TableSpec(
        :PLEXOSCategory, :categories, "t_category", "category_id", 3, false, 
        [FieldSpec(:name, :String, "name"),
         FieldSpec(:rank, :Int, "rank")],
        [FieldSpec(:class, :PLEXOSClass, "class_id")]),

    TableSpec(
        :PLEXOSAttribute, :attributes, "t_attribute", "attribute_id", 3, false, 
        [FieldSpec(:name, :String, "name"),
         FieldSpec(:description, :String, "description"),
         FieldSpec(:enum, :Int, "enum_id")],
        [FieldSpec(:class, :PLEXOSClass, "class_id")]),

    TableSpec(
        :PLEXOSCollection, :collections, "t_collection", "collection_id", 3, false, 
        [FieldSpec(:name, :String, "name"),
         FieldSpec(:complementname, :String, "complement_name")],
        [FieldSpec(:parentclass, :PLEXOSClass, "parent_class_id"),
         FieldSpec(:childclass, :PLEXOSClass, "child_class_id")]),

    TableSpec(
        :PLEXOSProperty, :properties, "t_property", "property_id", 4, false, 
        [FieldSpec(:name, :String, "name"),
         FieldSpec(:summaryname, :String, "summary_name"),
         FieldSpec(:enum, :Int, "enum_id"),
         FieldSpec(:ismultiband, :Bool, "is_multi_band"),
         FieldSpec(:isperiod, :Bool, "is_period"),
         FieldSpec(:issummary, :Bool, "is_summary")],
        [FieldSpec(:unit, :PLEXOSUnit, "unit_id"),
         FieldSpec(:summaryunit, :PLEXOSUnit, "summary_unit_id"),
         FieldSpec(:collection, :PLEXOSCollection, "collection_id")]),

    TableSpec(
        :PLEXOSObject, :objects, "t_object", "object_id", 4, false, 
        [FieldSpec(:name, :String, "name"),
         FieldSpec(:index, :Int, "index"),
         FieldSpec(:show, :Bool, "show")],
        [FieldSpec(:class, :PLEXOSClass, "class_id"),
         FieldSpec(:category, :PLEXOSCategory, "category_id")]),

    TableSpec(
        :PLEXOSMembership, :memberships, "t_membership", "membership_id", 5, false, 
        FieldSpec[],
        [FieldSpec(:parentclass, :PLEXOSClass, "parent_class_id"),
         FieldSpec(:childclass, :PLEXOSClass, "child_class_id"),
         FieldSpec(:collection, :PLEXOSCollection, "collection_id"),
         FieldSpec(:parentobject, :PLEXOSObject, "parent_object_id"),
         FieldSpec(:childobject, :PLEXOSObject, "child_object_id")]),

    TableSpec(
        :PLEXOSAttributeData, :attributedata, "t_attribute_data", nothing, 5, false, 
        [FieldSpec(:value, :Float64, "value")],
        [FieldSpec(:attribute, :PLEXOSAttribute, "attribute_id"),
         FieldSpec(:object, :PLEXOSObject, "object_id")]),

    TableSpec(
        :PLEXOSPeriod0, :intervals, "t_period_0", "interval_id", 1, false, 
        [FieldSpec(:periodofday, :Int, "period_of_day"),
         FieldSpec(:hour, :Int, "hour_id"),
         FieldSpec(:day, :Int, "day_id"),
         FieldSpec(:week, :Int, "week_id"),
         FieldSpec(:month, :Int, "month_id"),
         FieldSpec(:quarter, :Int, "quarter_id"),
         FieldSpec(:fiscalyear, :Int, "fiscal_year_id"),
         FieldSpec(:datetime, :String, "datetime")],
        FieldSpec[]),

    TableSpec(
        :PLEXOSPeriod1, :days, "t_period_1", "day_id", 1, false, 
        [FieldSpec(:week, :Int, "week_id"),
         FieldSpec(:month, :Int, "month_id"),
         FieldSpec(:quarter, :Int, "quarter_id"),
         FieldSpec(:fiscalyear, :Int, "fiscal_year_id"),
         FieldSpec(:date, :String, "date")],
        FieldSpec[]),

    TableSpec(
        :PLEXOSPeriod2, :weeks, "t_period_2", "week_id", 1, false, 
        [FieldSpec(:weekending, :String, "week_ending")],
        FieldSpec[]),

    TableSpec(
        :PLEXOSPeriod3, :months, "t_period_3", "month_id", 1, false, 
        [FieldSpec(:monthbeginning, :String, "month_beginning")],
        FieldSpec[]),

    TableSpec(
        :PLEXOSPeriod4, :years, "t_period_4", "fiscal_year_id", 1, false, 
        [FieldSpec(:yearending, :String, "year_ending")],
        FieldSpec[]),

    TableSpec(
        :PLEXOSPeriod6, :hours, "t_period_6", "hour_id", 1, false, 
        [FieldSpec(:day, :Int, "day_id"),
         FieldSpec(:datetime, :String, "datetime")],
        FieldSpec[]),

    TableSpec(
        :PLEXOSPeriod7, :quarters, "t_period_7", "quarter_id", 1, false, 
        [FieldSpec(:quarterbeginning, :String, "quarter_beginning")],
        FieldSpec[]),

    # TODO: LT support?

    TableSpec(
        :PLEXOSPhase2, :pasa, "t_phase_2", nothing, 2, false, 
        [FieldSpec(:period, :Int, "period_id")],
        [FieldSpec(:interval, :PLEXOSPeriod0, "interval_id")]),

    TableSpec(
        :PLEXOSPhase3, :mt, "t_phase_3", nothing, 2, false, 
        [FieldSpec(:period, :Int, "period_id")],
        [FieldSpec(:interval, :PLEXOSPeriod0, "interval_id")]),

    TableSpec(
        :PLEXOSPhase4, :st, "t_phase_4", nothing, 2, false, 
        [FieldSpec(:period, :Int, "period_id")],
        [FieldSpec(:interval, :PLEXOSPeriod0, "interval_id")]),

    TableSpec(
        :PLEXOSKey, :keys, "t_key", "key_id", 6, false, 
        [FieldSpec(:phase, :Int, "phase_id"),
          # note this periodtype is not accurate, use KeyIndex.periodtype instead
         FieldSpec(:periodtype, :Int, "period_type_id"),
         FieldSpec(:band, :Int, "band_id")],
        [FieldSpec(:membership, :PLEXOSMembership, "membership_id"),
         FieldSpec(:model, :PLEXOSModel, "model_id"),
         FieldSpec(:property, :PLEXOSProperty, "property_id"),
         FieldSpec(:sample, :PLEXOSSample, "sample_id"),
         FieldSpec(:timeslice, :PLEXOSTimeslice, "timeslice_id")]),

    TableSpec(
        :PLEXOSKeyIndex, :keyindices, "t_key_index", nothing, 7, false, 
        [FieldSpec(:periodtype, :Int, "period_type_id"),
         FieldSpec(:position, :Int, "position"), # bytes from binary file start
         FieldSpec(:length, :Int, "length"), # in 8-byte (Float64) increments
         FieldSpec(:periodoffset, :Int, "period_offset")], # temporal data offset (if any) in stored times
        [FieldSpec(:key, :PLEXOSKey, "key_id")])

]

const identifiers = Dict(t.tablename => t.identifier
                         for t in tables if !isnothing(t.identifier))

# TODO: Autogenerate structs
# TODO: Autogenerate XML-parsing constructors
# TODO: Autogenerate table data structs

struct PLEXOSCategory <: PLEXOSTableRow
    name::String
    rank::Int
    class::PLEXOSClass

    # PLEXOS sometimes reports categories without reporting the classes they
    # refer to: if that happens, just leave the class undefined
    # (category won't have any objects anyways)

    function PLEXOSCategory(e::Node, d::AbstractDataset)

        class_idx = getchildint("class_id", e)

        if isassigned(d.classes, class_idx)
            new(getchildtext("name", e),
                getchildint("rank", e),
                d.classes[class_idx])
        else
            new(getchildtext("name", e),
                getchildint("rank", e))
        end

    end

end

PLEXOSSampleWeight(e::Node, d::AbstractDataset) =
    # TODO: Abstract away zero-indexing here
    PLEXOSSampleWeight(d.samples[getchildint("sample_id", e) + 1],
                       getchildint("phase_id", e),
                       getchildfloat("value", e))

