RegisterNetEvent("radio:checkFivePDStatus", function()
    local src = source
    local license

    for _, id in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(id, 1, 8) == "license:" then
            license = string.sub(id, 9)
            break
        end
    end

    if not license then
        TriggerClientEvent("radio:authResult", src, false)
        return
    end

    exports.oxmysql:fetch([[
        SELECT 1
        FROM users u
        JOIN department_members dm ON dm.userID = u.id
        WHERE u.license = ? AND dm.accepted = 1
        LIMIT 1
    ]], { license }, function(result)
        local authorized = result and result[1] ~= nil
        TriggerClientEvent("radio:authResult", src, authorized)
    end)
end)
