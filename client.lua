local uiOpen = false
local isAuthorized = false

RegisterCommand("toggleRadioUI", function()
    if not isAuthorized then
        TriggerEvent("chat:addMessage", {
            args = { "[Radio]", "^1Access denied. You are not a FivePD officer." }
        })
        return
    end

    uiOpen = not uiOpen
    SetNuiFocus(uiOpen, uiOpen)
    SendNUIMessage({ action = "toggle", state = uiOpen })
end)

RegisterKeyMapping("toggleRadioUI", "Toggle Police Radio UI", "keyboard", "F3")

RegisterNUICallback("joinRadio", function(data, cb)
    local channel = tonumber(data.channel)
    if channel then
        exports["pma-voice"]:setRadioChannel(channel)
        TriggerEvent("chat:addMessage", {
            args = { "[Radio]", "Joined radio channel " .. channel }
        })
    end
    cb("ok")
end)

RegisterNUICallback("leaveRadio", function(_, cb)
    exports["pma-voice"]:setRadioChannel(0)
    TriggerEvent("chat:addMessage", {
        args = { "[Radio]", "Left radio channel" }
    })
    cb("ok")
end)

RegisterNUICallback("close", function(_, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "toggle", state = false })
    uiOpen = false
    cb("ok")
end)

RegisterNetEvent("radio:authResult", function(auth)
    isAuthorized = auth
    print("[Radio Client] Authorized:", auth)
end)

AddEventHandler('playerSpawned', function()
    Wait(2000)
    TriggerServerEvent("radio:checkFivePDStatus")
end)
