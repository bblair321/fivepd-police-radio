local uiOpen = false
local isAuthorized = false
local isAuthChecked = false
local isTalkingOnRadio = false
local playerPed = PlayerPedId()
local radioAnimDict = "random@arrests"
local radioEnterAnim = "generic_radio_enter"
local radioChatterAnim = "radio_chatter"

local function playRadioClick()
    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
end

local function loadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
end

local function startRadioAnim()
    playerPed = PlayerPedId()
    loadAnimDict(radioAnimDict)
    TaskPlayAnim(playerPed, radioAnimDict, radioEnterAnim, 8.0, -8.0, 500, 49, 0, false, false, false)
    Wait(500)
    TaskPlayAnim(playerPed, radioAnimDict, radioChatterAnim, 8.0, -8.0, -1, 49, 0, false, false, false)
end

local function stopRadioAnim()
    ClearPedSecondaryTask(PlayerPedId())
end

RegisterNetEvent("pma-voice:radioActive")
AddEventHandler("pma-voice:radioActive", function(talking)
    if talking and not isTalkingOnRadio then
        isTalkingOnRadio = true
        startRadioAnim()
    elseif not talking and isTalkingOnRadio then
        isTalkingOnRadio = false
        stopRadioAnim()
    end
end)

-- Toggle UI function
local function toggleRadioUI()
    if not isAuthorized then
        TriggerEvent("chat:addMessage", {
            args = { "[Radio]", "^1Access denied. You are not an on-duty FivePD officer." }
        })
        return
    end

    uiOpen = not uiOpen
    SetNuiFocus(uiOpen, uiOpen)
    SendNUIMessage({ action = "toggle", state = uiOpen })
end

-- Command to trigger toggle, only toggle if authorized
RegisterCommand("toggleRadioUI", function()
    if not isAuthChecked then
        TriggerServerEvent("radio:checkFivePDStatus")
        TriggerEvent("chat:addMessage", {
            args = { "[Radio]", "^3Checking your FivePD status..." }
        })
        return
    end

    toggleRadioUI()
end)

RegisterKeyMapping("toggleRadioUI", "Toggle Police Radio UI", "keyboard", "F3")

-- NUI Callbacks
RegisterNUICallback("joinRadio", function(data, cb)
    if not isAuthorized then
        TriggerEvent("chat:addMessage", {
            args = { "[Radio]", "^1Access denied. You are not on-duty." }
        })
        cb("unauthorized")
        return
    end

    local channel = tonumber(data.channel)
    if channel then
        exports["pma-voice"]:setRadioChannel(channel)
        playRadioClick()
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
    uiOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "toggle", state = false })
    cb("ok")
end)

-- Server response to auth check
RegisterNetEvent("radio:authResult")
AddEventHandler("radio:authResult", function(authorized, department)
    isAuthorized = authorized
    isAuthChecked = true
    print("[Radio Client] Authorized:", authorized, "Department:", department or "None")

    if isAuthorized and uiOpen then
        -- If UI was open (e.g. tried to open before auth), open it now
        SetNuiFocus(true, true)
        SendNUIMessage({ action = "toggle", state = true })
    elseif not isAuthorized and uiOpen then
        -- Close UI if unauthorized
        uiOpen = false
        SetNuiFocus(false, false)
        SendNUIMessage({ action = "toggle", state = false })
        TriggerEvent("chat:addMessage", {
            args = { "[Radio]", "^1Access denied. You are not a FivePD officer." }
        })
    end
end)

-- Reset authorization and UI on player spawn
AddEventHandler('playerSpawned', function()
    isAuthorized = false
    isAuthChecked = false
    uiOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "toggle", state = false })
    TriggerServerEvent("radio:checkFivePDStatus")
end)
