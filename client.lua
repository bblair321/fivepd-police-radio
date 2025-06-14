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

-- Load animation dictionary
local function loadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
end

-- Play radio talking animation
local function startRadioAnim()
    playerPed = PlayerPedId()
    loadAnimDict(radioAnimDict)

    -- Start with 'enter' animation (optional but smooth)
    TaskPlayAnim(playerPed, radioAnimDict, radioEnterAnim, 8.0, -8.0, 500, 49, 0, false, false, false)

    -- Wait a bit then play looping chatter anim
    Wait(500)
    TaskPlayAnim(playerPed, radioAnimDict, radioChatterAnim, 8.0, -8.0, -1, 49, 0, false, false, false)
end

-- Stop the animation
local function stopRadioAnim()
    ClearPedSecondaryTask(PlayerPedId())
end

-- Listen to voice radio state from pma-voice
RegisterNetEvent("pma-voice:radioActive", function(talking)
    if talking and not isTalkingOnRadio then
        isTalkingOnRadio = true
        startRadioAnim()
    elseif not talking and isTalkingOnRadio then
        isTalkingOnRadio = false
        stopRadioAnim()
    end
end)

-- Command to toggle radio UI
RegisterCommand("toggleRadioUI", function()
    -- Force re-check on every toggle attempt
    isAuthChecked = false
    TriggerServerEvent("radio:checkFivePDStatus")

    TriggerEvent("chat:addMessage", {
        args = { "[Radio]", "^3Checking your FivePD status..." }
    })
end)

-- Register keybind (F3) for toggleRadioUI
RegisterKeyMapping("toggleRadioUI", "Toggle Police Radio UI", "keyboard", "F3")

RegisterNUICallback("joinRadio", function(data, cb)
    if not isAuthorized then
        TriggerEvent("chat:addMessage", {
            args = { "[Radio]", "^1Access denied. You are not an on-duty FivePD officer." }
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
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "toggle", state = false })
    uiOpen = false
    cb("ok")
end)

-- Handle server response to authorization check
RegisterNetEvent("radio:authResult")
AddEventHandler("radio:authResult", function(authorized, department)
    isAuthorized = authorized
    isAuthChecked = true
    playerDepartment = department
    print("[Radio Client] Authorized:", authorized, "Department:", department or "None")

    if isAuthorized then
        uiOpen = true
        SetNuiFocus(true, true)
        SendNUIMessage({ action = "toggle", state = true })
    else
        TriggerEvent("chat:addMessage", {
            args = { "[Radio]", "^1Access denied. You are not a FivePD officer." }
        })
    end
end)

-- On player spawn, reset auth and check again after 2 seconds
AddEventHandler('playerSpawned', function()
    isAuthorized = false
    isAuthChecked = false
    Citizen.SetTimeout(2000, function()
        print("[Radio Client] Requesting FivePD status check...")
        TriggerServerEvent("radio:checkFivePDStatus")
    end)
end)
