# Metadata

struct PLEXOSConfig
    element::String
    value::String
end

PLEXOSConfig(e::Node) = PLEXOSConfig(
    getchildtext("element", e),
    getchildtext("value", e)
)


struct PLEXOSUnit
    value::String
end

PLEXOSUnit(e::Node) = PLEXOSUnit(getchildtext("value", e))


struct PLEXOSTimeslice
    name::String
end

PLEXOSTimeslice(e::Node) = PLEXOSTimeslice(getchildtext("name", e))


struct PLEXOSModel
    name::String
end

PLEXOSModel(e::Node) = PLEXOSModel(getchildtext("name", e))


struct PLEXOSSample
    name::String
end

PLEXOSSample(e::Node) = PLEXOSSample(getchildtext("sample_name", e))

struct PLEXOSSampleWeight
    sample::PLEXOSSample
    phase::Int # maybe Parametrize on this?
    value::Float64
end

# TODO PLEXOSSampleWeight(e::Node) = _

struct PLEXOSClassGroup
    name::String
end

PLEXOSClassGroup(e::Node) = PLEXOSClassGroup(getchildtext("name", e))

struct PLEXOSClass
    name::String
    classgroup::PLEXOSClassGroup
    state::Int
end

struct PLEXOSCategory
    name::String
    class::PLEXOSClass
    rank::Int
end

struct PLEXOSCollection
    name::String
    parentclass::PLEXOSClass
    childclass::PLEXOSClass
    complementname::Union{Nothing,String}
end

struct PLEXOSProperty
    name::String
    summaryname::String
    collection::PLEXOSCollection
    enum::Int
    unit::PLEXOSUnit 
    summaryunit::PLEXOSUnit
    ismultiband::Bool
    isperiod::Bool
    issummary::Bool
end

# System Data

struct PLEXOSObject
    name::String
    class::PLEXOSClass
    category::PLEXOSCategory
    index::Int
    show::Bool
end

struct PLEXOSMembership
    parentclass::PLEXOSClass
    childclass::PLEXOSClass
    collection::PLEXOSCollection
    parentobject::PLEXOSObject
    childobject::PLEXOSObject
end

# Results

struct PLEXOSPeriod0
    interval::Int # is this the id?
    periodofday::Int
    hour::Int
    day::Int
    week::Int
    month::Int
    quarter::Int
    fiscalyear::Int
    datetime::String
end

struct PLEXOSPeriod1
    day::Int # is this the id?
    week::Int
    month::Int
    quarter::Int
    fiscalyear::Int
    date::String
end

struct PLEXOSPeriod2
    week::Int #id?
    week_ending::String
end

struct PLEXOSPeriod3
    month::Int # id?
    month_beginning::String
end

struct PLEXOSPeriod4
    year::Int # id?
    year_ending::String
end

struct PLEXOSPeriod6
    hour::Int # joint hour/day id?
    day::Int
    datetime::String
end

struct PLEXOSPeriod7
    quarter::Int # id?
    quarter_beginning::String
end


# TODO: LT support?

struct PLEXOSPhase2
    interval::PLEXOSPeriod0
    period::Int # PASA period
end

struct PLEXOSPhase3
    interval::PLEXOSPeriod0
    period::Int # MT period
end

struct PLEXOSPhase4 # are these values always 1:1 matches?
    interval::PLEXOSPeriod0
    period::Int # ST period
end


struct PLEXOSKey
    membership::PLEXOSMembership
    model::PLEXOSModel
    phase::Int # maybe parametrize on this?
    property::PLEXOSProperty
    periodtype::Int # maybe parametrize on this?
    band::Int
    sample::PLEXOSSample
    timeslice::PLEXOSTimeslice
end

struct PLEXOSKeyIndex
    key::PLEXOSKey
    periodtype::Int # maybe parametrize on this?
    position::Int # bytes from binary file start
    length::Int # 8-byte (Float64) increments
    periodoffset::Int
end
