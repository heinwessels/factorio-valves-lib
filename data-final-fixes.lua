
---@type table<ValveMode, float>
local default_threshold_settings = {
    ["overflow"] = settings.startup["valves-default-threshold-overflow"].value /  100,
    ["top-up"] = settings.startup["valves-default-threshold-top_up"].value /  100, -- Note: uses old style
}

for valve_name in pairs(data.raw["mod-data"]["mod-valves"].data.valves --[[@as table]]) do
    local valve = data.raw.valve[valve_name]
    assert(valve, "Valve '" .. valve_name .. "' not found in data.raw.valve")

    -- Add a nice description and Factoriopedia page to describe the shortcuts and shortcomings.
    local factoriopeda_description = {"", {"entity-description."..valve.mode.."-valve"}}
    if valve.mode ~= "one-way" then
        table.insert(factoriopeda_description, {"valves.valve-shortcuts"})
        table.insert(factoriopeda_description, {"valves.threshold-settings"})
    end
    table.insert(factoriopeda_description, {"valves.factoriopedia-bad-connections"})
    valve.factoriopedia_description = factoriopeda_description
    valve.localised_description = {"",
        {"entity-description."..valve.mode.."-valve"},
        " ",
        {"valves.more-in-factoriopedia"},
    }

    -- Also ensure it uses the correct default value
    if valve.mode == "overflow" or valve.mode == "top-up" then
        valve.threshold = default_threshold_settings[valve.mode] or valve.threshold
    end
end
