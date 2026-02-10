Citizen.CreateThread(function()
    SendNUIMessage({
        action = 'updateTranslations',
        data = Config.Translations
    })
end)

-- NEW: Client event to receive notification from server
RegisterNetEvent('pp-adjustanim:notify', function(message)
    Config.Notify(message)
end)

-- NEW: Client event to start adjustment (triggered from server after permission check)
RegisterNetEvent('pp-adjustanim:startAdjust', function()
    adjustAnim()
end)

function adjustAnim()
    local animdata = Config.getCurrentAnimation()
    if not animdata then
        Config.Notify(Config.Translations['no_anim'])
        return 
    end
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
        while not xPressed do
            Citizen.Wait(0)
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
    
            -- enter
            if IsControlJustReleased(0, Config.keys.confirm[1]) and not enterPressed then
                if #(GetEntityCoords(cache.ped) - GetEntityCoords(clonePed)) <= Config.maxDistance then
                    enterPressed = true
                    keyPressed = true
                    FreezeEntityPosition(cache.ped, false)
                    local coords = GetEntityCoords(clonePed)
                    
                    -- ===== NEW: Auto-export coordinates to console =====
                    print("^2╔════════════════════════════════════════════════════════╗^0")
                    print("^2║       ADJUSTED ANIMATION COORDINATES EXPORTED         ║^0")
                    print("^2╠════════════════════════════════════════════════════════╣^0")
                    print(string.format("^3║ Position: ^0vector4(^6%.2f^0, ^6%.2f^0, ^6%.2f^0, ^6%.2f^0)^3 ║^0", 
                        coords.x, coords.y, coords.z, currentHeading))
                    print("^2╠════════════════════════════════════════════════════════╣^0")
                    print(string.format("^3║ Animation: ^0%s^3                              ║^0", animdata.dict))
                    print(string.format("^3║ Anim Name: ^0%s^3                              ║^0", animdata.anim))
                    print(string.format("^3║ Flag: ^0%d^3                                           ║^0", animdata.flag))
                    print("^2╚════════════════════════════════════════════════════════╝^0")
                    print("^5Copy this line for your script:^0")
                    print(string.format("vector4(%.2f, %.2f, %.2f, %.2f)", coords.x, coords.y, coords.z, currentHeading))
                    -- ===== END Auto-export =====
                    
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
                end
            end
    
            -- X
            if IsControlPressed(0, Config.keys.cancel[1]) then
                DeletePed(clonePed)
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
    
            -- Q
            if IsControlPressed(0, Config.keys.rleft[1]) then
                currentHeading = currentHeading - Config.rotateSpeed
            end
    
            -- E
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
    end)
end

-- Remove the old RegisterCommand since we're handling it server-side now
-- RegisterCommand(Config.command, adjustAnim)
