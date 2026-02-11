# PP-AdjustAnim Enhanced 🎮

An enhanced version of PixelPrecision's animation adjustment script for FiveM with **prop placement**, **bone attachments**, **quick actions**, and **admin-only restrictions**.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![FiveM](https://img.shields.io/badge/FiveM-Ready-green.svg)

## 🌟 What's New in This Version?

This is an enhanced fork of the original [pp-adjustanim](https://github.com/pixelprecisiondev/pp-adjustanim) with significant improvements:

### Version 2.0 Features

🎯 **Prop Placement System** - Place and adjust props alongside your animations with an extensive prop library

🦴 **Bone Attachment** - Attach props to character bones (hands, head, back, etc.) with 18+ preset attachment points

⚡ **Quick Actions Menu** - Instantly rotate, mirror, duplicate, or reset positions with preset actions

📦 **Extensive Prop Library** - 50+ pre-configured props organized by category (furniture, electronics, food, drinks, accessories)

🎨 **Enhanced Menus** - Intuitive categorized menus for props, bones, and quick actions

### Version 1.1 Features

✨ **Auto-Export Coordinates** - Automatically prints adjusted animation coordinates to your F8 console in a ready-to-use format

🔒 **Admin-Only Mode** - Restrict the `/adjust` command to admins only with support for multiple frameworks

🎯 **Developer-Friendly** - Perfect for scripters who need precise animation positioning for their custom scripts

## 📋 Features

- **Precise Animation Control**: Adjust character animations with millimeter precision
- **Visual Clone System**: See a semi-transparent clone as you adjust positions
- **Real-time Preview**: Move, rotate, and adjust height in real-time
- **Coordinate Export**: Instantly get vector4 coordinates for your scripts
- **Admin Protection**: Keep the tool exclusive to authorized staff
- **Framework Support**: Works with ESX, QBCore, ACE Permissions, or custom systems
- **Easy Integration**: Compatible with popular emote menus (scully_emotemenu, rpemotes)
- **Prop Placement System**: Place and adjust props alongside animations
- **Bone Attachment**: Attach props to character bones (hands, head, back, etc.)
- **Quick Actions Menu**: Rotate, mirror, and duplicate positions with preset actions
- **Extensive Prop Library**: Pre-configured props organized by category (furniture, electronics, food, etc.)

## 🎥 Demo

[YouTube Trailer](https://youtu.be/dQ3mEsm3YdI) *(Original version by PixelPrecision)*

## 📦 Installation

### Dependencies

- [ox_lib](https://github.com/overextended/ox_lib) - **Required**
- An emote menu: [scully_emotemenu](https://github.com/Scullyy/scully_emotemenu) or [rpemotes](https://github.com/TayMcKenzieNZ/rpemotes)

### Setup

1. **Download** this repository
2. **Extract** the folder to your server's `resources` directory
3. **Rename** the folder to `pp-adjustanim` (or your preferred name)
4. **Configure** admin permissions (see Configuration section below)
5. **Add to server.cfg**:
   ```cfg
   ensure ox_lib
   ensure pp-adjustanim
   ```
6. **Restart** your server

## ⚙️ Configuration

Open `config.lua` to customize settings:

### Admin Restrictions

```lua
Config.adminOnly = true -- Set to false to allow everyone

-- Choose your framework
Config.framework = 'ace' -- Options: 'esx', 'qbcore', 'ace', 'custom'
```

#### ACE Permissions (Default)
Add to your `server.cfg`:
```cfg
add_ace group.admin admin allow
add_principal identifier.license:YOUR_LICENSE_HERE group.admin
```

#### ESX Framework
```lua
Config.framework = 'esx'
-- Allows players with 'admin' or 'superadmin' group
```

#### QBCore Framework
```lua
Config.framework = 'qbcore'
-- Allows players with 'admin' or 'god' permission
```

#### Custom Permission System
```lua
Config.framework = 'custom'

Config.isAdmin = function(source)
    local adminIdentifiers = {
        'license:abc123def456',
        'discord:123456789012345'
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
```

### Prop and Bone Attachment Settings

```lua
Config.enableProps = true            -- Enable prop placement system
Config.maxPropsPerAdjust = 5         -- Maximum props per adjustment session
Config.enableBoneAttachment = true   -- Enable bone attachment feature
```

The script includes:
- **18+ bone presets** for common attachment points (hands, head, chest, back, legs, etc.)
- **6 prop/bone preset categories** with popular combinations (phones, drinks, work items, food, accessories, smoking)
- **Extensive prop library** organized by category (furniture, electronics, drinks, food, decoration)

### Other Settings

```lua
Config.command = 'adjust'           -- Command to trigger adjustment
Config.maxDistance = 30              -- Max distance to adjust from start point
Config.rotateSpeed = 5               -- Rotation speed (degrees per tick)
Config.movementSpeed = 0.05          -- Movement speed
Config.cloneAlpha = 204              -- Clone transparency (0-255)
Config.returnToStart = true          -- Return to start position if cancelled
Config.walkToPosition = true         -- Walk to adjusted position or teleport

Config.duplicateOffset = {
    x = 1.0,                         -- Offset for duplicate action
    y = 0.0,
    z = 0.0
}
```

## 🎮 Usage

### For Admins/Developers

#### Basic Animation Adjustment

1. **Play an animation** using your emote menu (e.g., `/e sit`)
2. **Type** `/adjust` in chat
3. **Adjust the position** using these controls:
   - **W/A/S/D** - Move forward/left/backward/right
   - **R/F** - Move up/down
   - **Q/E** - Rotate left/right
   - **Y** - Quick Actions Menu (rotate 90°, mirror, duplicate, reset)
   - **G** - Props Menu (place props in world)
   - **U** - Bone Attachment Menu (attach props to character bones)
   - **Enter** - Confirm and export coordinates
   - **X** - Cancel adjustment

4. **Check F8 Console** - Coordinates are automatically exported when you press Enter!

#### Prop Placement System

While adjusting an animation, press **G** to open the Props Menu:

1. **Browse by category**: Furniture, Electronics, Drinks, Food, Decoration, etc.
2. **Select a prop** to place it at your current position
3. **Adjust the prop** using the same W/A/S/D/R/F/Q/E controls
4. **Place up to 5 props** per adjustment session
5. **Remove last prop** using the remove option in the menu

Example props:
- Furniture: Office chairs, desks, benches, stools
- Electronics: Laptops, phones, tablets
- Drinks: Coffee cups, beer bottles, wine glasses
- Food: Burgers, hotdogs, pizza
- And many more!

#### Bone Attachment System

Attach props directly to character bones for items that move with the character:

1. **Press U** while in adjustment mode
2. **Choose a preset** or select custom bone:
   - **Phones** - Pre-configured for right/left hand
   - **Drinks** - Coffee cups, beer bottles, wine glasses
   - **Work Items** - Clipboard, tablet, newspaper
   - **Accessories** - Hats, backpacks, briefcases
   - **Food** - Burgers, hotdogs, pizza
   - **Smoking** - Cigarettes, cigars (mouth attachment)
3. **Adjust position** using controls
4. **Confirm** to lock in position

Common bone attachment points:
- Right/Left Hand (28422/60309)
- Head (31086)
- Mouth (17188) - for cigarettes/cigars
- Chest/Back (24818/24817) - for backpacks
- And 15+ more preset bones!

#### Quick Actions Menu

Press **Y** during adjustment for instant transformations:

- **🔄 Rotate 90° Right/Left** - Quick rotation presets
- **🔄 Rotate 180°** - Turn around instantly
- **↔️ Mirror Position** - Flip position horizontally
- **📋 Duplicate Position** - Copy position offset to the right
- **📍 Reset to Start** - Return to original position

### Console Output Example

When you confirm your adjustment (press Enter), the coordinates are automatically exported:

```
╔════════════════════════════════════════════════════════╗
║       ADJUSTED ANIMATION COORDINATES EXPORTED         ║
╠════════════════════════════════════════════════════════╣
║ Position: vector4(123.45, -456.78, 28.50, 90.00)     ║
╠════════════════════════════════════════════════════════╣
║ Animation: anim@heists@prison_heistig_1_p1_guard     ║
║ Anim Name: loop                                       ║
║ Flag: 1                                               ║
╚════════════════════════════════════════════════════════╝
Copy this line for your script:
vector4(123.45, -456.78, 28.50, 90.00)
```

**Note**: Prop coordinates are also exported if you placed any props during adjustment!

### Using Exported Coordinates in Your Script

```lua
local sitPosition = vector4(123.45, -456.78, 28.50, 90.00) -- From exported coords

-- Teleport player to position
SetEntityCoords(PlayerPedId(), sitPosition.x, sitPosition.y, sitPosition.z)
SetEntityHeading(PlayerPedId(), sitPosition.w)

-- Play animation
local dict = "anim@heists@prison_heistig_1_p1_guard"
local anim = "loop"

RequestAnimDict(dict)
while not HasAnimDictLoaded(dict) do Wait(10) end

TaskPlayAnim(PlayerPedId(), dict, anim, 8.0, -8.0, -1, 1, 0, false, false, false)
```

### Using Bone-Attached Props in Your Script

```lua
-- Example: Attach a phone to right hand
local prop = CreateObject(GetHashKey('prop_npc_phone_02'), 0, 0, 0, true, true, true)
local boneIndex = GetPedBoneIndex(PlayerPedId(), 28422) -- Right hand bone

AttachEntityToEntity(
    prop, PlayerPedId(), boneIndex,
    0.0, 0.0, 0.0,  -- X, Y, Z offset (adjust as needed)
    0.0, 0.0, 0.0,  -- X, Y, Z rotation (adjust as needed)
    true, true, false, true, 1, true
)
```

## 🔧 Troubleshooting

**Command doesn't work:**
- Check if `ox_lib` is started before this resource
- Verify admin permissions are configured correctly
- Check F8 console for errors

**Clone doesn't appear:**
- Make sure you're playing an animation first
- Check if the animation is supported by your emote menu
- Verify the emote menu is started and functioning

**Coordinates not printing:**
- Open F8 console before pressing Enter
- Make sure you're within `Config.maxDistance` of the clone

**Props not appearing:**
- Ensure `Config.enableProps = true` in config.lua
- Check that prop models are valid and loaded
- Verify you haven't exceeded `Config.maxPropsPerAdjust` limit

**Bone attachment not working:**
- Ensure `Config.enableBoneAttachment = true` in config.lua
- Make sure you're playing an animation when attaching props
- Some props may require manual offset adjustments for proper positioning

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

## 🙏 Credits

- **Original Script**: [PixelPrecision](https://github.com/pixelprecisiondev) - [Original Repository](https://github.com/pixelprecisiondev/pp-adjustanim)
- **Enhanced Version**: Modified with prop placement, bone attachments, quick actions, auto-export, and admin restrictions
- **Documentation**: [PixelPrecision Docs](https://docs.pixelprecision.dev/adjust-animation)

## 🔗 Links

- [Original Repository](https://github.com/pixelprecisiondev/pp-adjustanim)
- [PixelPrecision Discord](https://discord.gg/pixelprecision)
- [ox_lib Documentation](https://overextended.dev/ox_lib)

## 🤝 Contributing

Feel free to fork this repository and submit pull requests with improvements!

## 📝 Changelog

### Version 2.0.0 (Latest - Enhanced)
- ✨ **NEW**: Prop placement system with extensive prop library
- ✨ **NEW**: Bone attachment system with 18+ bone presets
- ✨ **NEW**: Quick actions menu (rotate, mirror, duplicate, reset)
- ✨ **NEW**: 6 prop/bone preset categories (phones, drinks, work items, food, accessories, smoking)
- 🎯 **NEW**: Additional keyboard controls (Y, G, U keys)
- 📝 **NEW**: Prop coordinate export alongside animation coordinates
- 🎨 Enhanced UI with categorized menus and better organization

### Version 1.1.0 (Enhanced)
- ✨ Added automatic coordinate export to F8 console
- 🔒 Added admin-only restriction system
- 🎯 Added support for ESX, QBCore, ACE, and custom frameworks
- 📝 Improved documentation and setup instructions
- 🎨 Enhanced console output formatting with animation details

### Version 1.0.0 (Original)
- Initial release by PixelPrecision
- Basic animation adjustment functionality
- Clone system and visual controls

---

**Made with ❤️ for the FiveM development community**

*This is an unofficial enhanced version. All credit for the original concept and implementation goes to PixelPrecision.*
