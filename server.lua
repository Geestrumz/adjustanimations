-- Admin check function
local function isPlayerAdmin(source)
    if not Config.adminOnly then
        return true -- If admin check is disabled, allow everyone
    end

    if Config.framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            return xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'superadmin'
        end
        
    elseif Config.framework == 'qbcore' then
        local Player = QBCore.Functions.GetPlayer(source)
        if Player then
            local permission = QBCore.Functions.GetPermission(source)
            return permission == 'admin' or permission == 'god'
        end
        
    elseif Config.framework == 'ace' then
        return IsPlayerAceAllowed(source, Config.acePermission)
        
    elseif Config.framework == 'custom' then
        return Config.isAdmin(source)
    end
    
    return false
end

-- Register command with permission check
lib.addCommand(Config.command, {
    help = 'Adjust animation position',
    restricted = false -- We handle permission in the callback
}, function(source)
    if not isPlayerAdmin(source) then
        TriggerClientEvent('pp-adjustanim:notify', source, Config.Translations['no_permission'])
        return
    end
    
    TriggerClientEvent('pp-adjustanim:startAdjust', source)
end)
