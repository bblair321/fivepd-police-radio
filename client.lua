RegisterCommand("radio", function(source, args)
    local channel = tonumber(args[1])
    if channel then
        exports["pma-voice"]:setRadioChannel(channel)
        TriggerEvent("chat:addMessage", {
            color = {0, 255, 0},
            args = {"[Radio]", "You switched to channel " .. channel}
        })
    else
        exports["pma-voice"]:setRadioChannel(0)
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            args = {"[Radio]", "Left radio channel"}
        })
    end
end, false)
