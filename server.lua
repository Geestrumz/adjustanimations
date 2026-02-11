-- Initialize framework objects
local ESX = nil
local QBCore = nil

if Config.framework == 'esx' then
    local success, result = pcall(function()
        return exports['es_extended']:getSharedObject()
    end)
    if success then
        ESX = result
        print('[pp-adjustanim] ESX framework initialized successfully')
    else
        print('[pp-adjustanim] ERROR: Failed to initialize ESX framework. Please ensure es_extended is started before this resource.')
    end
elseif Config.framework == 'qbcore' then
    local success, result = pcall(function()
        return exports['qb-core']:GetCoreObject()
    end)
    if success then
        QBCore = result
        print('[pp-adjustanim] QBCore framework initialized successfully')
    else
        print('[pp-adjustanim] ERROR: Failed to initialize QBCore framework. Please ensure qb-core is started before this resource.')
    end
end

-- Admin check function
local function isPlayerAdmin(source)
    if not Config.adminOnly then
        return true -- If admin check is disabled, allow everyone
    end

    if Config.framework == 'esx' then
        if not ESX then
            return false
        end
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            return xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'superadmin'
        end
        
    elseif Config.framework == 'qbcore' then
        if not QBCore then
            return false
        end
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
