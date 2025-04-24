using JSON

# Define structs to represent the plant data

mutable struct pHRange
    DeathLow::Float64
    TooLow::Float64
    Ideal::Float64
    TooHigh::Float64
    DeathHigh::Float64
end

mutable struct RetentionRange
    DeathLow::Float64
    TooLow::Float64
    Ideal::Float64
    TooHigh::Float64
    DeathHigh::Float64
end

mutable struct AerationRange
    DeathLow::Float64
    TooLow::Float64
    Ideal::Float64
    TooHigh::Float64
    DeathHigh::Float64
end

mutable struct OrganicContentRange
    DeathLow::Float64
    TooLow::Float64
    Ideal::Float64
    TooHigh::Float64
    DeathHigh::Float64
end

mutable struct LightStrengthRange
    DeathLow::Float64
    TooLow::Float64
    Ideal::Float64
    TooHigh::Float64
    DeathHigh::Float64
end

mutable struct PhotoperiodRange
    DeathLow::Float64
    TooLow::Float64
    Ideal::Float64
    TooHigh::Float64
    DeathHigh::Float64
end

mutable struct TemperatureRange
    DeathLow::Float64
    TooLow::Float64
    Ideal::Float64
    TooHigh::Float64
    DeathHigh::Float64
end

mutable struct HumidityRange
    DeathLow::Float64
    TooLow::Float64
    Ideal::Float64
    TooHigh::Float64
    DeathHigh::Float64
end

mutable struct FertilizerRange
    DeathLow::Float64
    TooLow::Float64
    Ideal::Float64
    TooHigh::Float64
    DeathHigh::Float64
end

mutable struct PlantData
    CommonName::String
    ScientificName::String
    SoilDescription::String
    pH::pHRange
    Retention::RetentionRange
    Aeration::AerationRange
    OrganicContent::OrganicContentRange
    LightStrength::LightStrengthRange
    Photoperiod::PhotoperiodRange
    Temperature::TemperatureRange
    CareDescription::String
    RelativeHumidity::HumidityRange
    Fertilizer::FertilizerRange
end

# Function to load the plant data from a JSON file
function load_plant_data(filename::String)
    data = JSON.parsefile(filename)
    
    plant_data = Dict{String, PlantData}()
    
    for (key, value) in data
        pH = pHRange(value["pH"]["DeathLow"], value["pH"]["TooLow"], value["pH"]["Ideal"], value["pH"]["TooHigh"], value["pH"]["DeathHigh"])
        retention = RetentionRange(value["Retention"]["DeathLow"], value["Retention"]["TooLow"], value["Retention"]["Ideal"], value["Retention"]["TooHigh"], value["Retention"]["DeathHigh"])
        aeration = AerationRange(value["Aeration"]["DeathLow"], value["Aeration"]["TooLow"], value["Aeration"]["Ideal"], value["Aeration"]["TooHigh"], value["Aeration"]["DeathHigh"])
        organic_content = OrganicContentRange(value["OrganicContent"]["DeathLow"], value["OrganicContent"]["TooLow"], value["OrganicContent"]["Ideal"], value["OrganicContent"]["TooHigh"], value["OrganicContent"]["DeathHigh"])
        light_strength = LightStrengthRange(value["LightStrength"]["DeathLow"], value["LightStrength"]["TooLow"], value["LightStrength"]["Ideal"], value["LightStrength"]["TooHigh"], value["LightStrength"]["DeathHigh"])
        photoperiod = PhotoperiodRange(value["Photoperiod"]["DeathLow"], value["Photoperiod"]["TooLow"], value["Photoperiod"]["Ideal"], value["Photoperiod"]["TooHigh"], value["Photoperiod"]["DeathHigh"])
        temperature = TemperatureRange(value["Temperature"]["DeathLow"], value["Temperature"]["TooLow"], value["Temperature"]["Ideal"], value["Temperature"]["TooHigh"], value["Temperature"]["DeathHigh"])
        humidity = HumidityRange(value["RelativeHumidity"]["DeathLow"], value["RelativeHumidity"]["TooLow"], value["RelativeHumidity"]["Ideal"], value["RelativeHumidity"]["TooHigh"], value["RelativeHumidity"]["DeathHigh"])
        fertilizer = FertilizerRange(value["Fertilizer"]["DeathLow"], value["Fertilizer"]["TooLow"], value["Fertilizer"]["Ideal"], value["Fertilizer"]["TooHigh"], value["Fertilizer"]["DeathHigh"])
        
        plant_data[key] = PlantData(value["CommonName"], value["ScientificName"], value["SoilDescription"], pH, retention, aeration, organic_content, light_strength, photoperiod, temperature, value["CareDescription"], humidity, fertilizer)
    end
    
    return plant_data
end

