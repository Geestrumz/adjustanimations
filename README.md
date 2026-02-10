# PP-AdjustAnim Enhanced 🎮

An enhanced version of PixelPrecision's animation adjustment script for FiveM with **automatic coordinate export** and **admin-only restrictions**.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![FiveM](https://img.shields.io/badge/FiveM-Ready-green.svg)

## 🌟 What's New in This Version?

This is an enhanced fork of the original [pp-adjustanim](https://github.com/pixelprecisiondev/pp-adjustanim) with the following improvements:

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

### Other Settings

```lua
Config.command = 'adjust'           -- Command to trigger adjustment
Config.maxDistance = 30              -- Max distance to adjust from start point
Config.rotateSpeed = 5               -- Rotation speed (degrees per tick)
Config.movementSpeed = 0.05          -- Movement speed
Config.cloneAlpha = 204              -- Clone transparency (0-255)
Config.returnToStart = true          -- Return to start position if cancelled
Config.walkToPosition = true         -- Walk to adjusted position or teleport
```

## 🎮 Usage

### For Admins/Developers

1. **Play an animation** using your emote menu (e.g., `/e sit`)
2. **Type** `/adjust` in chat
3. **Adjust the position** using these controls:
   - **W/A/S/D** - Move forward/left/backward/right
   - **R/F** - Move up/down
   - **Q/E** - Rotate left/right
   - **Enter** - Confirm and export coordinates
   - **X** - Cancel adjustment

4. **Check F8 Console** - Coordinates are automatically exported when you press Enter!

### Console Output Example

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

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

## 🙏 Credits

- **Original Script**: [PixelPrecision](https://github.com/pixelprecisiondev) - [Original Repository](https://github.com/pixelprecisiondev/pp-adjustanim)
- **Enhanced Version**: Modified with auto-export and admin restrictions
- **Documentation**: [PixelPrecision Docs](https://docs.pixelprecision.dev/adjust-animation)

## 🔗 Links

- [Original Repository](https://github.com/pixelprecisiondev/pp-adjustanim)
- [PixelPrecision Discord](https://discord.gg/pixelprecision)
- [ox_lib Documentation](https://overextended.dev/ox_lib)

## 🤝 Contributing

Feel free to fork this repository and submit pull requests with improvements!

## 📝 Changelog

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
