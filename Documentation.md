# Nebula Lib Documentation

A comprehensive, mobile-friendly UI library for Roblox

## Features

- Mobile-responsive design
- Customizable UI elements
- Configuration saving system
- Smooth animations and transitions
- Easy-to-use API

## Getting Started

### Installation

To install Nebula Lib in your Roblox project, simply load the library using the provided loadstring:

```lua
local NebulaLib = loadstring(game:HttpGet(('https://path.to/nebula/source')))()
```

### Booting the Library

After installing, you can initialize the library with a basic configuration:

```lua
local NebulaLib = loadstring(game:HttpGet(('https://path.to/nebula/source')))()
```

### Creating a Window

Create a new window to contain your UI elements:

```lua
local Window = NebulaLib:CreateWindow({
    Name = "Nebula Interface",
    SaveConfig = true,
    ConfigFolder = "NebulaSettings",
    MobileDrag = true
})

--[[
Name = <string> - The name displayed on the UI.
SaveConfig = <bool> - Enables saving user preferences.
ConfigFolder = <string> - Folder for saving settings.
MobileDrag = <bool> - Allows drag functionality on mobile.
]]
```

### Creating a Tab

Organize your UI elements into tabs:

```lua
local Tab = Window:CreateTab({
    Name = "Main Tab",
    Icon = "rbxassetid://123456",
})

--[[
Name = <string> - The tab's name.
Icon = <string> - URL or asset ID for the tab icon.
]]
```

### UI Elements

#### Buttons

Add clickable buttons to your interface:

```lua
Tab:AddButton({
    Name = "Click Me!",
    Callback = function()
        print("Button pressed!")
    end
})

--[[
Name = <string> - Button label.
Callback = <function> - Executes when clicked.
]]
```

#### Toggles

Create toggleable options:

```lua
Tab:AddToggle({
    Name = "Enable Option",
    Default = false,
    Callback = function(Value)
        print("Toggle set to:", Value)
    end
})

--[[
Name = <string> - Label for toggle.
Default = <bool> - Initial value.
Callback = <function> - Runs when toggle is changed.
]]
```

#### Sliders

Add adjustable value sliders:

```lua
Tab:AddSlider({
    Name = "Volume",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(Value)
        print("Slider set to:", Value)
    end
})

--[[
Name = <string> - Label for the slider.
Min = <number> - Minimum value.
Max = <number> - Maximum value.
Default = <number> - Initial slider position.
Callback = <function> - Executes when slider value changes.
]]
```

#### Notifications

Display temporary notifications:

```lua
NebulaLib:ShowNotification({
    Title = "Welcome",
    Content = "Thanks for using Nebula Lib!",
    Time = 3
})

--[[
Title = <string> - Title of the notification.
Content = <string> - Main message text.
Time = <number> - Duration of notification.
]]
```

#### Dropdown Menus

Create selectable dropdown menus:

```lua
Tab:AddDropdown({
    Name = "Choose an Option",
    Options = {"Option 1", "Option 2"},
    Callback = function(Value)
        print("Selected:", Value)
    end
})

--[[
Name = <string> - Dropdown label.
Options = <table> - Options in dropdown.
Callback = <function> - Executes on selection.
]]
```

### Finalizing and Destroying

To initialize the interface:

```lua
NebulaLib:Init()
```

To destroy and clean up the interface:

```lua
NebulaLib:Destroy()
```

## Additional Information

- The library automatically handles mobile touch input and responsive design
- All UI elements support both mouse and touch interactions
- Configuration saving is optional and can be enabled per window
- The interface can be dragged on both desktop and mobile devices

For more examples and advanced usage, please refer to the examples folder in the repository.
