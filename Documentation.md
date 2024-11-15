# Nebula Lib Documentation

A comprehensive, mobile-friendly UI library for Roblox with theme customization support.

## Features

- Mobile-responsive design
- Customizable UI elements
- Theme customization system with presets
- Configuration saving system
- Smooth animations and transitions
- Easy-to-use API
- Modern Replit Agent theme

## Getting Started

### Installation

To install Nebula Lib in your Roblox project, simply load the library using the provided loadstring:

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
```

### Theme Customization

Nebula Lib comes with built-in theme presets and customization options:

#### Using Theme Presets

```lua
-- Available presets: "Default", "Light", "Dark", "Contrast"
NebulaLib:SetTheme("Dark") -- Switch to dark theme
```

#### Custom Theme Colors

```lua
NebulaLib:SetTheme({
    Background = Color3.fromRGB(30, 30, 30),
    Secondary = Color3.fromRGB(45, 45, 45),
    Accent = Color3.fromRGB(138, 43, 226),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(179, 179, 179)
})
```

#### Creating Custom Theme Presets

```lua
NebulaLib:AddThemePreset("Custom", {
    Background = Color3.fromRGB(20, 20, 20),
    Secondary = Color3.fromRGB(30, 30, 30),
    Accent = Color3.fromRGB(255, 128, 0),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(200, 200, 200)
})

-- Use your custom theme
NebulaLib:SetTheme("Custom")
```

#### Getting Current Theme

```lua
local currentTheme = NebulaLib:GetTheme()
print(currentTheme.Background) -- Prints current background color
```

#### Getting Available Presets

```lua
local presets = NebulaLib:GetThemePresets()
for name, colors in pairs(presets) do
    print(name, colors.Background)
end
```

### Creating a Tab

```lua
local Tab = Window:CreateTab({
    Name = "Main Tab",
    Icon = "rbxassetid://123456",
})
```

### UI Elements

#### Buttons

```lua
Tab:AddButton({
    Name = "Click Me!",
    Callback = function()
        print("Button pressed!")
    end
})
```

#### Toggles

```lua
Tab:AddToggle({
    Name = "Enable Option",
    Default = false,
    Callback = function(Value)
        print("Toggle set to:", Value)
    end
})
```

#### Sliders

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
```

#### ColorPicker

```lua
Tab:AddColorPicker({
    Name = "Select Color",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(Color)
        print("Color selected:", Color)
    end
})
```

#### TextInput

```lua
Tab:AddTextInput({
    Name = "Username",
    Default = "",
    Placeholder = "Enter username...",
    ValidationFunc = function(Text)
        return #Text >= 3 -- Returns true if text length is 3 or more
    end,
    Callback = function(Text)
        print("Text changed to:", Text)
    end
})
```

#### Notifications

```lua
NebulaLib:ShowNotification({
    Title = "Welcome",
    Content = "Thanks for using Nebula Lib!",
    Time = 3
})
```

#### Dropdown Menus

```lua
Tab:AddDropdown({
    Name = "Choose an Option",
    Options = {"Option 1", "Option 2"},
    Callback = function(Value)
        print("Selected:", Value)
    end
})
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
- Theme changes are applied instantly to all UI elements
- Support for RGB color selection and text input validation

For more examples and advanced usage, please refer to the examples folder in the repository.
