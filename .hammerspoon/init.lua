-- === vars ===
local home = os.getenv("HOME")
-- path to scripts
local onScriptPath = home .. "/Scripts/stats_on.scpt"
local offScriptPath = home .. "/Scripts/stats_off.scpt"

-- === monitor ===
local function powerSourceChanged()
    local currentSource = hs.battery.powerSource()

    if currentSource == lastPowerSource then
        return
    end

    lastPowerSource = currentSource
    
    if currentSource == "AC Power" then
        print("Power connected, do sensor stats on: " .. onScriptPath)
        hs.execute("osascript " .. onScriptPath)
    else
        print("Power disconnected, do sensor stats off" .. offScriptPath)
        hs.execute("osascript " .. offScriptPath)
    end
end

-- === start monitor ===
powerWatcher = hs.battery.watcher.new(powerSourceChanged)
powerWatcher:start()

-- alert
hs.alert.show("Hammerspoon Reloaded")
