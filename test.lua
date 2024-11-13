-- Nebula Library Demo Script
-- This script demonstrates all UI components and animations

local NebulaLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/remoDevv/NebulaUILib/refs/heads/main/NebulaLib.lua')))()

-- Create window
local Window = NebulaLib:CreateWindow({
    Name = "Nebula Library Demo",
    SaveConfig = true,
    ConfigFolder = "NebulaDemo",
    MobileDrag = true
})

-- Create main components tab
local ComponentsTab = Window:CreateTab({
    Name = "Components",
    Icon = "rbxassetid://4483345998"
})

-- Add Buttons with hover/press animations
ComponentsTab:AddButton({
    Name = "Test Button",
    Callback = function()
        NebulaLib:ShowNotification({
            Title = "Button Pressed",
            Content = "Button animation test successful!",
            Time = 2
        })
    end
})

-- Add Toggle with smooth transition
local toggle = ComponentsTab:AddToggle({
    Name = "Test Toggle",
    Default = false,
    Callback = function(Value)
        NebulaLib:ShowNotification({
            Title = "Toggle Changed",
            Content = "Toggle is now: " .. tostring(Value),
            Time = 2
        })
    end
})

-- Add Slider with fluid handle movement
ComponentsTab:AddSlider({
    Name = "Test Slider",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(Value)
        -- The slider animation is handled internally
        print("Slider Value:", Value)
    end
})

-- Add Dropdown with expand/collapse animation
ComponentsTab:AddDropdown({
    Name = "Test Dropdown",
    Options = {"Option 1", "Option 2", "Option 3"},
    Callback = function(Value)
        NebulaLib:ShowNotification({
            Title = "Selection Made",
            Content = "Selected: " .. Value,
            Time = 2
        })
    end
})

-- Add ColorPicker with smooth transitions
ComponentsTab:AddColorPicker({
    Name = "Test ColorPicker",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(Color)
        print("Selected Color:", Color)
    end
})

-- Add TextInput with focus states
ComponentsTab:AddTextInput({
    Name = "Test TextInput",
    Default = "",
    Placeholder = "Enter text here...",
    ValidationFunc = function(Text)
        return #Text > 0
    end,
    Callback = function(Text)
        print("Input Text:", Text)
    end
})

-- Create Theme tab to demonstrate theme switching
local ThemeTab = Window:CreateTab({
    Name = "Themes",
    Icon = "rbxassetid://4483345998"
})

-- Add theme switching buttons
local themes = {"Default", "Light", "Dark", "Contrast"}
for _, theme in ipairs(themes) do
    ThemeTab:AddButton({
        Name = "Switch to " .. theme,
        Callback = function()
            NebulaLib:SetTheme(theme)
            NebulaLib:ShowNotification({
                Title = "Theme Changed",
                Content = "Switched to " .. theme .. " theme",
                Time = 2
            })
        end
    })
end

-- Initialize the library
NebulaLib:Init()

-- Show welcome notification
NebulaLib:ShowNotification({
    Title = "Welcome",
    Content = "Nebula Library Demo Loaded!",
    Time = 3
})
