Config = {}

-- ===== Admin Restriction Settings =====
Config.adminOnly = true
Config.framework = 'esx'
Config.acePermission = 'admin'

Config.isAdmin = function(source)
    local adminIdentifiers = {
        'license:abc123',
        'discord:123456789'
    }
    
    for _, id in pairs(GetPlayerIdentifiers(source)) do
        for _, adminId in pairs(adminIdentifiers) do
            if id == adminId then
                return true
            end
        end
    end
    return false
end

-- ===== Prop Placement Settings =====
Config.enableProps = true
Config.maxPropsPerAdjust = 5

-- ===== NEW: Bone Attachment Settings =====
Config.enableBoneAttachment = true

-- Common bone presets
Config.bonePresets = {
    -- Hands
    {name = "Right Hand", bone = 28422, offset = {x = 0.0, y = 0.0, z = 0.0}, rotation = {x = 0.0, y = 0.0, z = 0.0}},
    {name = "Left Hand", bone = 60309, offset = {x = 0.0, y = 0.0, z = 0.0}, rotation = {x = 0.0, y = 0.0, z = 0.0}},
    
    -- Head
    {name = "Head", bone = 31086, offset = {x = 0.0, y = 0.0, z = 0.0}, rotation = {x = 0.0, y = 0.0, z = 0.0}},
    {name = "Head Top", bone = 31086, offset = {x = 0.0, y = 0.0, z = 0.1}, rotation = {x = 0.0, y = 0.0, z = 0.0}},
    
    -- Body
    {name = "Spine (Back)", bone = 24817, offset = {x = -0.15, y = 0.0, z = 0.0}, rotation = {x = 0.0, y = 0.0, z = 0.0}},
    {name = "Chest", bone = 24818, offset = {x = 0.0, y = 0.0, z = 0.0}, rotation = {x = 0.0, y = 0.0, z = 0.0}},
    {name = "Pelvis (Hip)", bone = 11816, offset = {x = 0.0, y = 0.0, z = 0.0}, rotation = {x = 0.0, y = 0.0, z = 0.0}},
    
    -- Arms
    {name = "Right Shoulder", bone = 40269, offset = {x = 0.0, y = 0.0, z = 0.0}, rotation = {x = 0.0, y = 0.0, z = 0.0}},
    {name = "Left Shoulder", bone = 45509, offset = {x = 0.0, y = 0.0, z = 0.0}, rotation = {x = 0.0, y = 0.0, z = 0.0}},
    {name = "Right Forearm", bone = 28252, offset = {x = 0.0, y = 0.0, z = 0.0}, rotation = {x = 0.0, y = 0.0, z = 0.0}},
    {name = "Left Forearm", bone = 61163, offset = {x = 0.0, y = 0.0, z = 0.0}, rotation = {x = 0.0, y = 0.0, z = 0.0}},
    
    -- Legs
    {name = "Right Thigh", bone = 58271, offset = {x = 0.0, y = 0.0, z = 0.0}, rotation = {x = 0.0, y = 0.0, z = 0.0}},
    {name = "Left Thigh", bone = 51826, offset = {x = 0.0, y = 0.0, z = 0.0}, rotation = {x = 0.0, y = 0.0, z = 0.0}},
    {name = "Right Foot", bone = 52301, offset = {x = 0.0, y = 0.0, z = 0.0}, rotation = {x = 0.0, y = 0.0, z = 0.0}},
    {name = "Left Foot", bone = 14201, offset = {x = 0.0, y = 0.0, z = 0.0}, rotation = {x = 0.0, y = 0.0, z = 0.0}},
    
    -- Fingers (Advanced)
    {name = "Right Index Finger", bone = 26610, offset = {x = 0.0, y = 0.0, z = 0.0}, rotation = {x = 0.0, y = 0.0, z = 0.0}},
    {name = "Left Index Finger", bone = 4089, offset = {x = 0.0, y = 0.0, z = 0.0}, rotation = {x = 0.0, y = 0.0, z = 0.0}},
    
    -- Face
    {name = "Mouth", bone = 17188, offset = {x = 0.0, y = 0.0, z = 0.0}, rotation = {x = 0.0, y = 0.0, z = 0.0}},
    {name = "Neck", bone = 39317, offset = {x = 0.0, y = 0.0, z = 0.0}, rotation = {x = 0.0, y = 0.0, z = 0.0}},
}

-- Popular prop + bone combinations (presets for quick use)
Config.propBonePresets = {
    -- Phones
    {
        category = "Phone",
        items = {
            {name = "Phone in Right Hand", prop = "prop_npc_phone_02", bone = 28422, offset = {x = 0.0, y = 0.0, z = 0.0}, rotation = {x = 0.0, y = 0.0, z = 0.0}},
            {name = "Phone in Left Hand", prop = "prop_npc_phone_02", bone = 60309, offset = {x = 0.0, y = 0.0, z = 0.0}, rotation = {x = 0.0, y = 0.0, z = 0.0}},
        }
    },
    -- Drinks
    {
        category = "Drinks",
        items = {
            {name = "Coffee Cup (Right)", prop = "p_amb_coffeecup_01", bone = 28422, offset = {x = 0.0, y = 0.0, z = 0.0}, rotation = {x = 0.0, y = 0.0, z = 0.0}},
            {name = "Beer Bottle (Right)", prop = "prop_beer_bottle", bone = 28422, offset = {x = 0.08, y = -0.03, z = 0.0}, rotation = {x = 0.0, y = 0.0, z = 0.0}},
            {name = "Wine Glass (Right)", prop = "prop_drink_whiwhi", bone = 28422, offset = {x = 0.0, y = -0.08, z = 0.0}, rotation = {x = 0.0, y = 0.0, z = 0.0}},
        }
    },
    -- Work Items
    {
        category = "Work Items",
        items = {
            {name = "Clipboard (Left)", prop = "p_amb_clipboard_01", bone = 60309, offset = {x = 0.1, y = 0.02, z = 0.05}, rotation = {x = -130.0, y = -50.0, z = 0.0}},
            {name = "Tablet (Left)", prop = "prop_cs_tablet", bone = 60309, offset = {x = 0.03, y = 0.0, z = -0.05}, rotation = {x = 20.0, y = 180.0, z = 180.0}},
            {name = "Newspaper (Both)", prop = "prop_cliff_paper", bone = 28422, offset = {x = 0.0, y = 0.0, z = -0.02}, rotation = {x = 0.0, y = 0.0, z = 0.0}},
        }
    },
    -- Accessories
    {
        category = "Accessories",
        items = {
            {name = "Hat on Head", prop = "prop_hat_box_01", bone = 31086, offset = {x = 0.0, y = 0.0, z = 0.07}, rotation = {x = 0.0, y = 0.0, z = 0.0}},
            {name = "Backpack", prop = "p_michael_backpack_s", bone = 24817, offset = {x = -0.07, y = -0.11, z = -0.05}, rotation = {x = 0.0, y = 90.0, z = 180.0}},
            {name = "Briefcase (Right)", prop = "prop_ld_case_01", bone = 28422, offset = {x = 0.1, y = 0.0, z = 0.0}, rotation = {x = 0.0, y = -90.0, z = 0.0}},
        }
    },
    -- Food
    {
        category = "Food",
        items = {
            {name = "Burger (Right)", prop = "prop_cs_burger_01", bone = 28422, offset = {x = 0.13, y = 0.05, z = 0.02}, rotation = {x = -50.0, y = 16.0, z = 60.0}},
            {name = "Hotdog (Right)", prop = "prop_cs_hotdog_01", bone = 28422, offset = {x = 0.13, y = 0.05, z = 0.02}, rotation = {x = -50.0, y = 16.0, z = 60.0}},
            {name = "Pizza Slice (Right)", prop = "v_res_tt_pizzaplate", bone = 28422, offset = {x = 0.0, y = 0.0, z = 0.0}, rotation = {x = 0.0, y = 0.0, z = 0.0}},
        }
    },
    -- Smoking
    {
        category = "Smoking",
        items = {
            {name = "Cigarette (Mouth)", prop = "prop_amb_ciggy_01", bone = 17188, offset = {x = 0.015, y = -0.009, z = 0.003}, rotation = {x = 55.0, y = 0.0, z = 110.0}},
            {name = "Cigar (Mouth)", prop = "prop_cigar_02", bone = 17188, offset = {x = 0.015, y = -0.009, z = 0.003}, rotation = {x = 55.0, y = 0.0, z = 110.0}},
        }
    },
}

-- Common props library (UPDATED)
Config.propLibrary = {
    -- Chairs
    {name = "Office Chair", model = "v_corp_offchair", category = "Furniture"},
    {name = "Dining Chair", model = "v_res_tre_chair", category = "Furniture"},
    {name = "Arm Chair", model = "v_res_tre_armchair", category = "Furniture"},
    {name = "Stool", model = "v_ilev_stool", category = "Furniture"},
    
    -- Tables
    {name = "Coffee Table", model = "v_res_tre_coffeetable", category = "Furniture"},
    {name = "Desk", model = "v_res_desk", category = "Furniture"},
    
    -- Interactive Objects
    {name = "Laptop", model = "prop_laptop_01a", category = "Electronics"},
    {name = "Coffee Cup", model = "p_amb_coffeecup_01", category = "Drinks"},
    {name = "Beer Bottle", model = "prop_beer_bottle", category = "Drinks"},
    {name = "Phone", model = "prop_npc_phone_02", category = "Electronics"},
    {name = "Clipboard", model = "p_amb_clipboard_01", category = "Work"},
    {name = "Tablet", model = "prop_cs_tablet", category = "Electronics"},
    
    -- Food
    {name = "Burger", model = "prop_cs_burger_01", category = "Food"},
    {name = "Hotdog", model = "prop_cs_hotdog_01", category = "Food"},
    {name = "Pizza", model = "v_res_tt_pizzaplate", category = "Food"},
    
    -- Decorative
    {name = "Plant", model = "prop_pot_plant_03a", category = "Decoration"},
    {name = "Lamp", model = "prop_table_01_lamp", category = "Furniture"},
    
    -- Outdoor
    {name = "Bench", model = "prop_bench_01a", category = "Furniture"},
    {name = "Trash Can", model = "prop_bin_01a", category = "Objects"},
}

-- ===== Quick Actions Settings =====
Config.quickActions = {
    enabled = true,
    key = 38,
    keyName = "E"
}

Config.duplicateOffset = {
    x = 1.0,
    y = 0.0,
    z = 0.0
}

-- ===== Original Settings =====
Config.keys = {
    confirm = {191, 'Enter'},
    cancel = {73, 'X'},
    rleft = {44, 'Q'},
    rright = {38, 'E'},
    up = {45, 'R'},
    down = {23, 'F'},
    left = {34, 'A'},
    right = {35, 'D'},
    forward = {32, 'W'},
    backward = {33, 'S'},
    quickmenu = {246, 'Y'},
    propMenu = {47, 'G'},
    boneMenu = {303, 'U'}, -- NEW: U key for bone attachment menu
}

Config.Translations = {
    ['title'] = 'Adjust animation',
    ['no_anim'] = 'Use animation first!',
    ['no_permission'] = 'You do not have permission to use this command!',
    ['prop_placed'] = 'Prop placed! Use controls to adjust.',
    ['prop_removed'] = 'Last prop removed.',
    ['no_props'] = 'No props to remove!',
    ['max_props'] = 'Maximum props reached!',
    ['position_duplicated'] = 'Position duplicated!',
    ['position_mirrored'] = 'Position mirrored!',
    ['rotated'] = 'Rotated %s degrees!',
    ['bone_attached'] = 'Prop attached to bone!',
    ['select_bone'] = 'Select a bone attachment point',
    ['select_preset'] = 'Select a preset or choose custom',
    keys = {
        ['X'] = 'Cancel',
        ['Enter'] = 'Confirm',
        ['Q'] = 'Rot. left',
        ['E'] = 'Rot. right',
        ['R'] = 'Up',
        ['F'] = 'Down',
        ['A'] = 'Left',
        ['D'] = 'Right',
        ['W'] = 'Forward',
        ['S'] = 'Backward',
        ['Y'] = 'Quick Menu',
        ['G'] = 'Props',
        ['U'] = 'Bone Attach'
    }
}

Config.command = 'adjust'
Config.maxDistance = 30
Config.rotateSpeed = 5
Config.movementSpeed = 0.05
Config.cloneAlpha = 204
Config.returnToStart = true
Config.walkToPosition = true

Config.setupPed = function(ped)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    TaskSetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
end

-- [Rest of config remains the same - getCurrentAnimation and Notify functions]
Config.getCurrentAnimation = function()
    if GetResourceState('scully_emotemenu') == 'started' then
        local data, lastVariant = exports.scully_emotemenu:getLastEmote()
        if not data then return end
        local movementFlag = cache.vehicle and 51 or 0
        if not cache.vehicle and data.Options.Flags then
            if data.Options.Flags.Loop then movementFlag = 1 end
            if data.Options.Flags.Move then movementFlag = 51 end
            if data.Options.Flags.Stuck then movementFlag = 50 end
        end
        if not IsEntityPlayingAnim(cache.ped, data.Dictionary, data.Animation, 3) then return end
        return {
            dict = data.Dictionary,
            anim = data.Animation,
            flag = movementFlag,
            command = 'e ' .. data.Command
        }
    elseif GetResourceState('rpemotes') == 'started' then
        local data = exports.rpemotes:getCurrentEmote()
        if not data then return end
        local MovementType = cache.vehicle and 51 or 0
        if data.AnimationOptions then
            if data.AnimationOptions.EmoteLoop then
                MovementType = 1
                if data.AnimationOptions.EmoteMoving then
                    MovementType = 51
                end
    
            elseif data.AnimationOptions.EmoteMoving then
                MovementType = 51
            elseif data.AnimationOptions.EmoteMoving == false then
                MovementType = 0
            elseif data.AnimationOptions.EmoteStuck then
                MovementType = 50
            end
    
        else
            MovementType = 0
        end
    
        if InVehicle == 1 then
            MovementType = 51
        end
        if not IsEntityPlayingAnim(cache.ped, data[1], data[2], 3) then return end
        return {
            dict = data[1],
            anim = data[2],
            flag = MovementType,
            command = 'e ' .. data[4]
        }
    end
end

Config.Notify = function(message)
    lib.notify({
        title = 'Adjust animation',
        description = message,
        type = 'info'
    })
end
