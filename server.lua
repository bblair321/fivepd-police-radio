RegisterNetEvent("radio:checkFivePDStatus")
AddEventHandler("radio:checkFivePDStatus", function()
    local src = source
    print("[Radio Server] Checking FivePD status for player:", src)

    local license
    for _, id in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(id, 1, 8) == "license:" then
            license = string.sub(id, 9)
            break
        end
    end

    if not license then
        print("[Radio Server] No license found for", src)
        TriggerClientEvent("radio:authResult", src, false)
        return
    end

    exports.oxmysql:fetch(
    [[
        SELECT dm.departmentID
        FROM users u
        JOIN department_members dm ON dm.userID = u.id
        JOIN departments d ON d.id = dm.departmentID
        WHERE u.license = ? AND dm.accepted = 1
        LIMIT 1
    ]],
    { license },
    function(result)
        if result and result[1] then
            print("[Radio Server] Player", src, "authorized with department:", result[1].departmentID)
            TriggerClientEvent("radio:authResult", src, true, result[1].departmentID)
        else
            print("[Radio Server] Player", src, "NOT authorized for FivePD or not on duty.")
            TriggerClientEvent("radio:authResult", src, false)
        end
    end
    )

end
)
