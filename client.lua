local placedProps = {}
local propAdjustMode = false
local selectedPropIndex = nil
local boneAttachMode = false
local selectedBoneData = nil

Citizen.CreateThread(function()
    SendNUIMessage({
        action = 'updateTranslations',
        data = Config.Translations
    })
end)

RegisterNetEvent('pp-adjustanim:notify', function(message)
    Config.Notify(message)
end)

RegisterNetEvent('pp-adjustanim:startAdjust', function()
    adjustAnim()
end)

-- ===== QUICK ACTIONS MENU =====
function ShowQuickActionsMenu(currentHeading, clonePed, currentCoords)
    local options = {
        {
            title = '🔄 Rotate 90° Right',
            description = 'Quickly rotate 90 degrees clockwise',
            icon = 'rotate-right',
            onSelect = function()
                return currentHeading + 90
            end
        },
        {
            title = '🔄 Rotate 180°',
            description = 'Turn around 180 degrees',
            icon = 'rotate',
            onSelect = function()
                return currentHeading + 180
            end
        },
        {
            title = '🔄 Rotate 90° Left',
            description = 'Quickly rotate 90 degrees counter-clockwise',
            icon = 'rotate-left',
            onSelect = function()
                return currentHeading - 90
            end
        },
        {
            title = '↔️ Mirror Position',
            description = 'Flip position horizontally',
            icon = 'left-right',
            onSelect = function()
                local offset = GetOffsetFromEntityInWorldCoords(clonePed, -2.0, 0.0, 0.0)
                SetEntityCoords(clonePed, offset.x, offset.y, offset.z)
                Config.Notify(Config.Translations['position_mirrored'])
                return currentHeading + 180
            end
        },
        {
            title = '📋 Duplicate Position',
            description = 'Create a copy offset to the right',
            icon = 'copy',
            metadata = {
                {label = 'Offset', value = string.format('%.1fm right', Config.duplicateOffset.x)}
            },
            onSelect = function()
                local offset = GetOffsetFromEntityInWorldCoords(clonePed, Config.duplicateOffset.x, Config.duplicateOffset.y, Config.duplicateOffset.z)
                SetEntityCoords(clonePed, offset.x, offset.y, offset.z)
                Config.Notify(Config.Translations['position_duplicated'])
                return currentHeading
            end
        },
        {
            title = '📍 Reset to Start',
            description = 'Return to original position',
            icon = 'house',
            onSelect = function()
                return 'reset'
            end
        }
    }
    
    lib.registerContext({
        id = 'quick_actions_menu',
        title = '⚡ Quick Actions',
        options = options
    })
    
    lib.showContext('quick_actions_menu')
end

-- ===== NEW: BONE ATTACHMENT PRESET MENU =====
function ShowBonePresetMenu(propModel)
    local options = {}
    
    -- Add preset categories
    for _, category in ipairs(Config.propBonePresets) do
        table.insert(options, {
            title = '📁 ' .. category.category,
            description = 'Presets for ' .. category.category,
            icon = 'folder',
            arrow = true,
            onSelect = function()
                ShowCategoryItems(category.items, propModel)
            end
        })
    end
    
    -- Add custom bone selection
    table.insert(options, {
        title = '⚙️ Custom Bone',
        description = 'Manually select a bone',
        icon = 'gear',
        arrow = true,
        onSelect = function()
            ShowBoneSelectionMenu(propModel)
        end
    })
    
    lib.registerContext({
        id = 'bone_preset_menu',
        title = '🦴 Bone Attachment Presets',
        options = options
    })
    
    lib.showContext('bone_preset_menu')
end

-- ===== NEW: SHOW CATEGORY ITEMS =====
function ShowCategoryItems(items, propModel)
    local options = {}
    
    for _, item in ipairs(items) do
        table.insert(options, {
            title = item.name,
            description = 'Bone: ' .. item.bone,
            icon = 'hand',
            onSelect = function()
                selectedBoneData = {
                    bone = item.bone,
                    offset = item.offset,
                    rotation = item.rotation,
                    model = item.prop or propModel
                }
                boneAttachMode = true
            end
        })
    end
    
    lib.registerContext({
        id = 'category_items_menu',
        title = '📦 Select Preset',
        menu = 'bone_preset_menu',
        options = options
    })
    
    lib.showContext('category_items_menu')
end

-- ===== NEW: BONE SELECTION MENU =====
function ShowBoneSelectionMenu(propModel)
    local options = {}
    
    for _, boneData in ipairs(Config.bonePresets) do
        table.insert(options, {
            title = boneData.name,
            description = 'Bone ID: ' .. boneData.bone,
            icon = 'bone',
            onSelect = function()
                selectedBoneData = {
                    bone = boneData.bone,
                    offset = boneData.offset,
                    rotation = boneData.rotation,
                    model = propModel
                }
                boneAttachMode = true
            end
        })
    end
    
    lib.registerContext({
        id = 'bone_selection_menu',
        title = '🦴 Select Bone',
        menu = 'bone_preset_menu',
        options = options
    })
    
    lib.showContext('bone_selection_menu')
end

-- ===== PROP PLACEMENT MENU =====
function ShowPropMenu(allowBoneAttach)
    local options = {}
    
    -- Group by category
    local categories = {}
    for _, prop in ipairs(Config.propLibrary) do
        local cat = prop.category or "Other"
        if not categories[cat] then
            categories[cat] = {}
        end
        table.insert(categories[cat], prop)
    end
    
    for category, props in pairs(categories) do
        table.insert(options, {
            title = '📁 ' .. category,
            description = #props .. ' items',
            icon = 'folder',
            arrow = true,
            onSelect = function()
                ShowCategoryProps(props, allowBoneAttach)
            end
        })
    end
    
    -- Add custom prop option
    table.insert(options, {
        title = '✏️ Custom Prop',
        description = 'Enter a custom model name',
        icon = 'pencil',
        onSelect = function()
            local input = lib.inputDialog('Custom Prop', {
                {type = 'input', label = 'Model Name', description = 'Enter prop model name', required = true, min = 3}
            })
            
            if input and input[1] then
                if allowBoneAttach then
                    ShowBonePresetMenu(input[1])
                else
                    table.insert(Config.propLibrary, {name = "Custom", model = input[1], category = "Custom"})
                    selectedPropIndex = #Config.propLibrary
                    propAdjustMode = true
                end
            end
        end
    })
    
    lib.registerContext({
        id = 'prop_menu',
        title = '🪑 Prop Library',
        options = options
    })
    
    lib.showContext('prop_menu')
end

-- ===== NEW: SHOW CATEGORY PROPS =====
function ShowCategoryProps(props, allowBoneAttach)
    local options = {}
    
    for i, prop in ipairs(props) do
        -- Find the actual index in Config.propLibrary
        local propIndex = nil
        for idx, p in ipairs(Config.propLibrary) do
            if p.model == prop.model then
                propIndex = idx
                break
            end
        end
        
        local optionData = {
            title = prop.name,
            description = 'Model: ' .. prop.model,
            icon = 'cube'
        }
        
        if allowBoneAttach then
            optionData.onSelect = function()
                ShowBonePresetMenu(prop.model)
            end
        else
            optionData.onSelect = function()
                selectedPropIndex = propIndex
                propAdjustMode = true
            end
        end
        
        table.insert(options, optionData)
    end
    
    lib.registerContext({
        id = 'category_props_menu',
        title = '📦 Select Prop',
        menu = 'prop_menu',
        options = options
    })
    
    lib.showContext('category_props_menu')
end

-- ===== PLACE PROP FUNCTION =====
function PlaceProp(propModel, coords, heading)
    local propHash = GetHashKey(propModel)
    
    RequestModel(propHash)
    local timeout = 0
    while not HasModelLoaded(propHash) and timeout < 100 do
        Wait(10)
        timeout = timeout + 1
    end
    
    if not HasModelLoaded(propHash) then
        Config.Notify('Failed to load prop model: ' .. propModel)
        return nil
    end
    
    local prop = CreateObject(propHash, coords.x, coords.y, coords.z, false, false, false)
    SetEntityHeading(prop, heading)
    FreezeEntityPosition(prop, true)
    SetEntityAlpha(prop, 200, false)
    
    table.insert(placedProps, {
        entity = prop,
        model = propModel,
        coords = coords,
        heading = heading,
        attached = false
    })
    
    SetModelAsNoLongerNeeded(propHash)
    
    return prop
end

-- ===== NEW: ATTACH PROP TO BONE =====
function AttachPropToBone(propModel, ped, boneData)
    local propHash = GetHashKey(propModel)
    
    RequestModel(propHash)
    local timeout = 0
    while not HasModelLoaded(propHash) and timeout < 100 do
        Wait(10)
        timeout = timeout + 1
    end
    
    if not HasModelLoaded(propHash) then
        Config.Notify('Failed to load prop model: ' .. propModel)
        return nil
    end
    
    local prop = CreateObject(propHash, 0.0, 0.0, 0.0, true, true, false)
    
    local boneIndex = GetPedBoneIndex(ped, boneData.bone)
    
    AttachEntityToEntity(
        prop, 
        ped, 
        boneIndex,
        boneData.offset.x, boneData.offset.y, boneData.offset.z,
        boneData.rotation.x, boneData.rotation.y, boneData.rotation.z,
        true, true, false, true, 1, true
    )
    
    SetEntityAlpha(prop, 200, false) -- Semi-transparent during adjustment
    
    table.insert(placedProps, {
        entity = prop,
        model = propModel,
        attached = true,
        bone = boneData.bone,
        offset = boneData.offset,
        rotation = boneData.rotation,
        attachedTo = ped
    })
    
    SetModelAsNoLongerNeeded(propHash)
    
    return prop
end

-- ===== REMOVE LAST PROP =====
function RemoveLastProp()
    if #placedProps > 0 then
        local lastProp = table.remove(placedProps)
        if DoesEntityExist(lastProp.entity) then
            if lastProp.attached then
                DetachEntity(lastProp.entity, true, true)
            end
            DeleteEntity(lastProp.entity)
        end
        Config.Notify(Config.Translations['prop_removed'])
        return true
    else
        Config.Notify(Config.Translations['no_props'])
        return false
    end
end

-- ===== CLEANUP ALL PROPS =====
function CleanupAllProps()
    for _, prop in ipairs(placedProps) do
        if DoesEntityExist(prop.entity) then
            if prop.attached then
                DetachEntity(prop.entity, true, true)
            end
            DeleteEntity(prop.entity)
        end
    end
    placedProps = {}
end

-- ===== MAIN ADJUST FUNCTION =====
function adjustAnim()
    local animdata = Config.getCurrentAnimation()
    if not animdata then
        Config.Notify(Config.Translations['no_anim'])
        return 
    end
    
    CleanupAllProps()
    
    local clonePed = ClonePed(cache.ped, false, true, true)
    SetEntityAlpha(clonePed, Config.cloneAlpha)
    SetEntityNoCollisionEntity(cache.ped, clonePed, false)
    TaskPlayAnim(clonePed, animdata.dict, animdata.anim, 2.0, 2.0, -1, animdata.flag, 0, false, false, false)
    FreezeEntityPosition(cache.ped, true)
    local currentHeading = GetEntityHeading(cache.ped)
    local startPos = GetEntityCoords(cache.ped)
    Config.setupPed(clonePed)
    
    local nuiData = {}
    for _, key in pairs(Config.keys) do
        table.insert(nuiData, {key = key[2], text = Config.Translations.keys[key[2]]})
    end
    
    SendNUIMessage({
        action = 'open',
        data = nuiData
    })
    
    Citizen.CreateThread(function()
        local enterPressed = false
        local xPressed = false
        local heightoffset = 0
        local moveX = 0
        local moveY = 0
        local currentProp = nil
        local propHeightOffset = 0
        local propMoveX = 0
        local propMoveY = 0
        local propHeading = 0
        local adjustingBoneProp = false
        local boneOffsetAdjust = {x = 0.0, y = 0.0, z = 0.0}
        local boneRotationAdjust = {x = 0.0, y = 0.0, z = 0.0}
        
        while not xPressed do
            Citizen.Wait(0)
            
            -- ===== BONE PROP ADJUSTMENT MODE =====
            if adjustingBoneProp and currentProp and DoesEntityExist(currentProp) then
                -- Fine-tune bone attachment
                local adjustSpeed = 0.001 -- Very fine control
                local rotSpeed = 1.0
                
                -- Position adjustments
                if IsControlPressed(0, Config.keys.forward[1]) then
                    boneOffsetAdjust.y = boneOffsetAdjust.y + adjustSpeed
                elseif IsControlPressed(0, Config.keys.backward[1]) then
                    boneOffsetAdjust.y = boneOffsetAdjust.y - adjustSpeed
                end
                
                if IsControlPressed(0, Config.keys.left[1]) then
                    boneOffsetAdjust.x = boneOffsetAdjust.x - adjustSpeed
                elseif IsControlPressed(0, Config.keys.right[1]) then
                    boneOffsetAdjust.x = boneOffsetAdjust.x + adjustSpeed
                end
                
                if IsControlPressed(0, Config.keys.up[1]) then
                    boneOffsetAdjust.z = boneOffsetAdjust.z + adjustSpeed
                elseif IsControlPressed(0, Config.keys.down[1]) then
                    boneOffsetAdjust.z = boneOffsetAdjust.z - adjustSpeed
                end
                
                -- Rotation adjustments (hold Shift for X, Ctrl for Y, default is Z)
                if IsControlPressed(0, 21) then -- Left Shift - X rotation
                    if IsControlPressed(0, Config.keys.rleft[1]) then
                        boneRotationAdjust.x = boneRotationAdjust.x - rotSpeed
                    elseif IsControlPressed(0, Config.keys.rright[1]) then
                        boneRotationAdjust.x = boneRotationAdjust.x + rotSpeed
                    end
                elseif IsControlPressed(0, 36) then -- Left Ctrl - Y rotation
                    if IsControlPressed(0, Config.keys.rleft[1]) then
                        boneRotationAdjust.y = boneRotationAdjust.y - rotSpeed
                    elseif IsControlPressed(0, Config.keys.rright[1]) then
                        boneRotationAdjust.y = boneRotationAdjust.y + rotSpeed
                    end
                else -- Z rotation (default)
                    if IsControlPressed(0, Config.keys.rleft[1]) then
                        boneRotationAdjust.z = boneRotationAdjust.z - rotSpeed
                    elseif IsControlPressed(0, Config.keys.rright[1]) then
                        boneRotationAdjust.z = boneRotationAdjust.z + rotSpeed
                    end
                end
                
                -- Reattach with new offsets
                local propData = placedProps[#placedProps]
                if propData then
                    DetachEntity(currentProp, false, false)
                    local boneIndex = GetPedBoneIndex(clonePed, propData.bone)
                    
                    AttachEntityToEntity(
                        currentProp,
                        clonePed,
                        boneIndex,
                        propData.offset.x + boneOffsetAdjust.x,
                        propData.offset.y + boneOffsetAdjust.y,
                        propData.offset.z + boneOffsetAdjust.z,
                        propData.rotation.x + boneRotationAdjust.x,
                        propData.rotation.y + boneRotationAdjust.y,
                        propData.rotation.z + boneRotationAdjust.z,
                        true, true, false, true, 1, true
                    )
                end
                
                -- Display adjustment values
                DrawText3D(GetEntityCoords(clonePed).x, GetEntityCoords(clonePed).y, GetEntityCoords(clonePed).z + 1.0,
                    string.format("~g~Bone Attachment~w~\nOffset: ~b~%.3f, %.3f, %.3f~w~\nRotation: ~y~%.1f, %.1f, %.1f~w~\n~o~Q/E~w~: Rotate Z | ~o~Shift+Q/E~w~: Rotate X | ~o~Ctrl+Q/E~w~: Rotate Y",
                    boneOffsetAdjust.x, boneOffsetAdjust.y, boneOffsetAdjust.z,
                    boneRotationAdjust.x, boneRotationAdjust.y, boneRotationAdjust.z))
                
                -- Confirm bone attachment
                if IsControlJustReleased(0, Config.keys.confirm[1]) then
                    -- Update the saved data
                    propData.offset.x = propData.offset.x + boneOffsetAdjust.x
                    propData.offset.y = propData.offset.y + boneOffsetAdjust.y
                    propData.offset.z = propData.offset.z + boneOffsetAdjust.z
                    propData.rotation.x = propData.rotation.x + boneRotationAdjust.x
                    propData.rotation.y = propData.rotation.y + boneRotationAdjust.y
                    propData.rotation.z = propData.rotation.z + boneRotationAdjust.z
                    
                    SetEntityAlpha(currentProp, 255, false)
                    Config.Notify('Bone attachment confirmed!')
                    adjustingBoneProp = false
                    currentProp = nil
                    boneOffsetAdjust = {x = 0.0, y = 0.0, z = 0.0}
                    boneRotationAdjust = {x = 0.0, y = 0.0, z = 0.0}
                end
                
                -- Cancel bone attachment
                if IsControlJustReleased(0, Config.keys.cancel[1]) then
                    RemoveLastProp()
                    adjustingBoneProp = false
                    currentProp = nil
                end
                
            -- ===== PROP ADJUSTMENT MODE =====
            elseif propAdjustMode and currentProp and DoesEntityExist(currentProp) then
                local hit, _, endCoords = lib.raycast.cam(1 | 2 | 16, 4, Config.maxDistance)
                if hit then
                    local groundZ, isOnGround = GetGroundZFor_3dCoord(endCoords.x, endCoords.y, endCoords.z, 0)
                    if isOnGround then
                        SetEntityCoords(currentProp, endCoords.x + propMoveX, endCoords.y + propMoveY, endCoords.z + propHeightOffset)
                        SetEntityHeading(currentProp, propHeading)
                    end
                end
                
                if IsControlPressed(0, Config.keys.rleft[1]) then
                    propHeading = propHeading - Config.rotateSpeed
                end
                if IsControlPressed(0, Config.keys.rright[1]) then
                    propHeading = propHeading + Config.rotateSpeed
                end
                if IsControlPressed(0, Config.keys.up[1]) then
                    propHeightOffset = propHeightOffset + Config.movementSpeed
                end
                if IsControlPressed(0, Config.keys.down[1]) then
                    propHeightOffset = propHeightOffset - Config.movementSpeed
                end
                if IsControlPressed(0, Config.keys.left[1]) then
                    propMoveX = propMoveX - math.cos(math.rad(propHeading)) * Config.movementSpeed
                    propMoveY = propMoveY - math.sin(math.rad(propHeading)) * Config.movementSpeed
                elseif IsControlPressed(0, Config.keys.right[1]) then
                    propMoveX = propMoveX + math.cos(math.rad(propHeading)) * Config.movementSpeed
                    propMoveY = propMoveY + math.sin(math.rad(propHeading)) * Config.movementSpeed
                end
                if IsControlPressed(0, Config.keys.forward[1]) then
                    propMoveX = propMoveX + math.cos(math.rad(propHeading + 90)) * Config.movementSpeed
                    propMoveY = propMoveY + math.sin(math.rad(propHeading + 90)) * Config.movementSpeed
                elseif IsControlPressed(0, Config.keys.backward[1]) then
                    propMoveX = propMoveX + math.cos(math.rad(propHeading - 90)) * Config.movementSpeed
                    propMoveY = propMoveY + math.sin(math.rad(propHeading - 90)) * Config.movementSpeed
                end
                
                if IsControlJustReleased(0, Config.keys.confirm[1]) then
                    SetEntityAlpha(currentProp, 255, false)
                    Config.Notify('Prop confirmed!')
                    propAdjustMode = false
                    currentProp = nil
                    propHeightOffset = 0
                    propMoveX = 0
                    propMoveY = 0
                    propHeading = 0
                end
                
                if IsControlJustReleased(0, Config.keys.cancel[1]) then
                    RemoveLastProp()
                    propAdjustMode = false
                    currentProp = nil
                end
                
            -- ===== NORMAL PED ADJUSTMENT MODE =====
            else
                local hit, _, endCoords = lib.raycast.cam(1 | 2 | 16, 4, Config.maxDistance)
                if hit then
                    local groundZ, isOnGround = GetGroundZFor_3dCoord(endCoords.x, endCoords.y, endCoords.z, 0)
                    if isOnGround then
                        SetEntityCoords(clonePed, endCoords.x + moveX, endCoords.y + moveY, endCoords.z + heightoffset)
                        SetEntityHeading(clonePed, currentHeading)
                    end
                end
                
                if not IsEntityPlayingAnim(clonePed, animdata.dict, animdata.anim, 3) then
                    TaskPlayAnim(clonePed, animdata.dict, animdata.anim, 2.0, 2.0, -1, animdata.flag, 0, false, false, false)
                end
                
                -- ENTER - CONFIRM
                if IsControlJustReleased(0, Config.keys.confirm[1]) and not enterPressed then
                    if #(GetEntityCoords(cache.ped) - GetEntityCoords(clonePed)) <= Config.maxDistance then
                        enterPressed = true
                        FreezeEntityPosition(cache.ped, false)
                        local coords = GetEntityCoords(clonePed)
                        
                        -- AUTO-EXPORT COORDINATES
                        print("^2╔════════════════════════════════════��═══════════════════╗^0")
                        print("^2║       ADJUSTED ANIMATION COORDINATES EXPORTED         ║^0")
                        print("^2╠════════════════════════════════════════════════════════╣^0")
                        print(string.format("^3║ Position: ^0vector4(^6%.2f^0, ^6%.2f^0, ^6%.2f^0, ^6%.2f^0)^3 ║^0", 
                            coords.x, coords.y, coords.z, currentHeading))
                        print("^2╠════════════════════════════════════════════════════════╣^0")
                        print(string.format("^3║ Animation: ^0%-38s^3 ║^0", animdata.dict))
                        print(string.format("^3║ Anim Name: ^0%-38s^3 ║^0", animdata.anim))
                        print(string.format("^3║ Flag: ^0%-46d^3 ║^0", animdata.flag))
                        
                        if #placedProps > 0 then
                            print("^2╠════════════════════════════════════════════════════════╣^0")
                            print(string.format("^3║ Props Placed: ^0%-40d^3 ║^0", #placedProps))
                            print("^2╠════════════════════════════════════════════════════════╣^0")
                            for i, prop in ipairs(placedProps) do
                                if prop.attached then
                                    print(string.format("^3║ Prop %d (BONE ATTACHED): ^0%-28s^3 ║^0", i, prop.model))
                                    print(string.format("^3║   Bone: ^0%-44d^3 ║^0", prop.bone))
                                    print(string.format("^3║   Offset: ^0%.3f, %.3f, %.3f^3                    ║^0", 
                                        prop.offset.x, prop.offset.y, prop.offset.z))
                                    print(string.format("^3║   Rotation: ^0%.1f, %.1f, %.1f^3                  ║^0",
                                        prop.rotation.x, prop.rotation.y, prop.rotation.z))
                                else
                                    local pCoords = GetEntityCoords(prop.entity)
                                    local pHeading = GetEntityHeading(prop.entity)
                                    print(string.format("^3║ Prop %d: ^0%-45s^3 ║^0", i, prop.model))
                                    print(string.format("^3║   Pos: ^0vector4(^6%.2f^0, ^6%.2f^0, ^6%.2f^0, ^6%.2f^0)^3    ║^0", 
                                        pCoords.x, pCoords.y, pCoords.z, pHeading))
                                end
                            end
                        end
                        
                        print("^2╚════════════════════════════════════════════════════════╝^0")
                        print("^5Copy for your script:^0")
                        print(string.format("vector4(%.2f, %.2f, %.2f, %.2f)", coords.x, coords.y, coords.z, currentHeading))
                        
                        if #placedProps > 0 then
                            print("^5Props:^0")
                            for i, prop in ipairs(placedProps) do
                                if prop.attached then
                                    print(string.format("{model = '%s', bone = %d, offset = vector3(%.3f, %.3f, %.3f), rotation = vector3(%.1f, %.1f, %.1f)},",
                                        prop.model, prop.bone, prop.offset.x, prop.offset.y, prop.offset.z,
                                        prop.rotation.x, prop.rotation.y, prop.rotation.z))
                                else
                                    local pCoords = GetEntityCoords(prop.entity)
                                    local pHeading = GetEntityHeading(prop.entity)
                                    print(string.format("{model = '%s', coords = vector4(%.2f, %.2f, %.2f, %.2f)},",
                                        prop.model, pCoords.x, pCoords.y, pCoords.z, pHeading))
                                end
                            end
                        end
                        
                        SendNUIMessage({
                            action = 'close'
                        })
                        
                        if Config.walkToPosition then
                            ClearPedTasksImmediately(cache.ped)
                            Citizen.Wait(400)
                            TaskGoStraightToCoord(cache.ped, coords, 1.0, -1, currentHeading, 0.0)
                            
                            while GetScriptTaskStatus(cache.ped, "SCRIPT_TASK_GO_STRAIGHT_TO_COORD") ~= 7 do
                                Citizen.Wait(100)
                            end
                        end
                        
                        SetEntityCoordsNoOffset(cache.ped, coords.x, coords.y, coords.z)
                        SetEntityHeading(cache.ped, currentHeading)
                        DeletePed(clonePed)
                        ExecuteCommand(animdata.command)
                        FreezeEntityPosition(cache.ped, true)
                        Citizen.Wait(0)
                        FreezeEntityPosition(cache.ped, false)
                        
                        for _, prop in ipairs(placedProps) do
                            if DoesEntityExist(prop.entity) then
                                SetEntityAlpha(prop.entity, 255, false)
                            end
                        end
                    end
                end
                
                -- X - CANCEL
                if IsControlPressed(0, Config.keys.cancel[1]) then
                    DeletePed(clonePed)
                    CleanupAllProps()
                    SendNUIMessage({
                        action = 'close'
                    })
                    FreezeEntityPosition(cache.ped, false)
                    if Config.returnToStart then
                        SetEntityCoords(cache.ped, startPos.x, startPos.y, startPos.z)
                    end
                    xPressed = true
                    break
                end
                
                -- Y - QUICK ACTIONS
                if IsControlJustReleased(0, Config.keys.quickmenu[1]) then
                    ShowQuickActionsMenu(currentHeading, clonePed, GetEntityCoords(clonePed))
                end
                
                -- G - PROP MENU (World placement)
                if IsControlJustReleased(0, Config.keys.propMenu[1]) and Config.enableProps then
                    if #placedProps >= Config.maxPropsPerAdjust then
                        Config.Notify(Config.Translations['max_props'])
                    else
                        ShowPropMenu(false)
                    end
                end
                
                -- U - BONE ATTACHMENT MENU
                if IsControlJustReleased(0, Config.keys.boneMenu[1]) and Config.enableBoneAttachment then
                    if #placedProps >= Config.maxPropsPerAdjust then
                        Config.Notify(Config.Translations['max_props'])
                    else
                        ShowPropMenu(true) -- true = allow bone attachment
                    end
                end
                
                -- BACKSPACE - REMOVE LAST PROP
                if IsControlJustReleased(0, 177) then
                    RemoveLastProp()
                end
                
                -- Place world prop if selected
                if selectedPropIndex and not propAdjustMode and not boneAttachMode then
                    local propData = Config.propLibrary[selectedPropIndex]
                    local cloneCoords = GetEntityCoords(clonePed)
                    currentProp = PlaceProp(propData.model, cloneCoords, currentHeading)
                    if currentProp then
                        Config.Notify(Config.Translations['prop_placed'])
                        propAdjustMode = true
                        propHeading = currentHeading
                    end
                    selectedPropIndex = nil
                end
                
                -- Attach bone prop if selected
                if boneAttachMode and selectedBoneData then
                    currentProp = AttachPropToBone(selectedBoneData.model, clonePed, selectedBoneData)
                    if currentProp then
                        Config.Notify(Config.Translations['bone_attached'])
                        adjustingBoneProp = true
                    end
                    boneAttachMode = false
                    selectedBoneData = nil
                end
                
                -- NORMAL CONTROLS
                if IsControlPressed(0, Config.keys.rleft[1]) then
                    currentHeading = currentHeading - Config.rotateSpeed
                end
                
                if IsControlPressed(0, Config.keys.rright[1]) then
                    currentHeading = currentHeading + Config.rotateSpeed
                end

                if IsControlPressed(0, Config.keys.up[1]) then
                    heightoffset = heightoffset + Config.movementSpeed
                end

                if IsControlPressed(0, Config.keys.down[1]) then
                    heightoffset = heightoffset - Config.movementSpeed
                end

                if IsControlPressed(0, Config.keys.left[1]) then
                    moveX = moveX - math.cos(math.rad(currentHeading)) * Config.movementSpeed
                    moveY = moveY - math.sin(math.rad(currentHeading)) * Config.movementSpeed
                elseif IsControlPressed(0, Config.keys.right[1]) then
                    moveX = moveX + math.cos(math.rad(currentHeading)) * Config.movementSpeed
                    moveY = moveY + math.sin(math.rad(currentHeading)) * Config.movementSpeed
                end

                if IsControlPressed(0, Config.keys.forward[1]) then
                    moveX = moveX + math.cos(math.rad(currentHeading + 90)) * Config.movementSpeed
                    moveY = moveY + math.sin(math.rad(currentHeading + 90)) * Config.movementSpeed
                elseif IsControlPressed(0, Config.keys.backward[1]) then
                    moveX = moveX + math.cos(math.rad(currentHeading - 90)) * Config.movementSpeed
                    moveY = moveY + math.sin(math.rad(currentHeading - 90)) * Config.movementSpeed
                end
            end
        end
    end)
end

-- ===== HELPER: 3D TEXT =====
function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end
