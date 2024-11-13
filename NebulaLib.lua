-- Nebula Lib
-- A mobile-friendly Roblox UI library with smooth animations
-- Version: 1.0.0

-- Service Initialization with proper error handling
local Success, Services = pcall(function()
    return {
        RunService = game:GetService("RunService"),
        Players = game:GetService("Players"),
        CoreGui = game:GetService("CoreGui"),
        TweenService = game:GetService("TweenService"),
        UserInputService = game:GetService("UserInputService"),
        HttpService = game:GetService("HttpService")
    }
end)
assert(Success, "Failed to initialize services")

local NebulaLib = {
    Windows = {},
    Theme = {
        Background = Color3.fromRGB(13, 17, 23),
        Secondary = Color3.fromRGB(22, 27, 34),
        Accent = Color3.fromRGB(88, 166, 255),
        Text = Color3.fromRGB(230, 237, 243),
        SubText = Color3.fromRGB(125, 133, 144)
    },
    Flags = {},
    ConfigFolder = "NebulaSettings",
    ThemePresets = {
        Default = {
            Background = Color3.fromRGB(13, 17, 23),
            Secondary = Color3.fromRGB(22, 27, 34),
            Accent = Color3.fromRGB(88, 166, 255),
            Text = Color3.fromRGB(230, 237, 243),
            SubText = Color3.fromRGB(125, 133, 144)
        },
        Light = {
            Background = Color3.fromRGB(255, 255, 255),
            Secondary = Color3.fromRGB(242, 242, 242),
            Accent = Color3.fromRGB(0, 122, 255),
            Text = Color3.fromRGB(0, 0, 0),
            SubText = Color3.fromRGB(102, 102, 102)
        },
        Dark = {
            Background = Color3.fromRGB(30, 30, 30),
            Secondary = Color3.fromRGB(45, 45, 45),
            Accent = Color3.fromRGB(138, 43, 226),
            Text = Color3.fromRGB(255, 255, 255),
            SubText = Color3.fromRGB(179, 179, 179)
        },
        Contrast = {
            Background = Color3.fromRGB(0, 0, 0),
            Secondary = Color3.fromRGB(20, 20, 20),
            Accent = Color3.fromRGB(255, 215, 0),
            Text = Color3.fromRGB(255, 255, 255),
            SubText = Color3.fromRGB(200, 200, 200)
        }
    }
}

-- Utility Functions with error handling
local function CreateInstance(className, properties)
    assert(className, "className is required")
    local success, instance = pcall(Instance.new, className)
    assert(success, "Failed to create instance of " .. className)
    
    -- Validate parent before setting properties
    if properties and properties.Parent then
        assert(typeof(properties.Parent) == "Instance", "Parent must be an Instance")
    end
    
    for prop, value in pairs(properties or {}) do
        success, err = pcall(function()
            instance[prop] = value
        end)
        if not success then
            warn(string.format("Failed to set %s to %s: %s", prop, tostring(value), err))
        end
    end
    return instance
end

-- Animation System
local AnimationConfig = {
    Duration = 0.15,
    EasingStyle = Enum.EasingStyle.Quad,
    EasingDirection = Enum.EasingDirection.Out
}

local function CreateTween(instance, properties)
    assert(instance, "Instance is required for tweening")
    local tween = Services.TweenService:Create(
        instance,
        TweenInfo.new(
            AnimationConfig.Duration,
            AnimationConfig.EasingStyle,
            AnimationConfig.EasingDirection
        ),
        properties
    )
    tween:Play()
    return tween
end

-- Core UI Creation
function NebulaLib:CreateWindow(config)
    assert(type(config) == "table", "Config must be a table")
    local Window = {
        Name = config.Name or "Nebula Interface",
        Tabs = {},
        SaveConfig = config.SaveConfig or false,
        ConfigFolder = config.ConfigFolder or self.ConfigFolder,
        MobileDrag = config.MobileDrag or true
    }

    -- Main GUI Container with protection
    Window.MainGui = (syn and syn.protect_gui) and syn.protect_gui(CreateInstance("ScreenGui")) or CreateInstance("ScreenGui")
    Window.MainGui.Name = "NebulaLib"
    if Services.RunService:IsStudio() then
        Window.MainGui.Parent = Services.Players.LocalPlayer:WaitForChild("PlayerGui")
    else
        Window.MainGui.Parent = Services.CoreGui
    end

    -- Main Frame
    Window.MainFrame = CreateInstance("Frame", {
        Name = "MainFrame",
        Parent = Window.MainGui,
        BackgroundColor3 = self.Theme.Background,
        Position = UDim2.new(0.5, -250, 0.5, -150),
        Size = UDim2.new(0, 500, 0, 300),
        ClipsDescendants = true
    })

    -- Add Corner
    CreateInstance("UICorner", {
        Parent = Window.MainFrame,
        CornerRadius = UDim.new(0, 6)
    })

    -- Title Bar
    Window.TitleBar = CreateInstance("Frame", {
        Name = "TitleBar",
        Parent = Window.MainFrame,
        BackgroundColor3 = self.Theme.Secondary,
        Size = UDim2.new(1, 0, 0, 30)
    })

    -- Container initialization
    Window.TabContainer = CreateInstance("Frame", {
        Name = "TabContainer",
        Parent = Window.MainFrame,
        BackgroundColor3 = self.Theme.Secondary,
        Position = UDim2.new(0, 0, 0, 30),
        Size = UDim2.new(0, 120, 1, -30)
    })

    Window.ContentContainer = CreateInstance("Frame", {
        Name = "ContentContainer",
        Parent = Window.MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 120, 0, 30),
        Size = UDim2.new(1, -120, 1, -30),
        ClipsDescendants = true
    })

    -- CreateTab function with proper error handling
    function Window:CreateTab(config)
        assert(self.TabContainer, "TabContainer not initialized")
        assert(self.ContentContainer, "ContentContainer not initialized")
        
        config = config or {}
        local Tab = {
            Name = config.Name or "Tab",
            Icon = config.Icon,
            Elements = {}
        }

        -- Create tab button with proper error checking
        Tab.Button = CreateInstance("TextButton", {
            Name = Tab.Name,
            Parent = self.TabContainer,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 30),
            Font = Enum.Font.Gotham,
            Text = Tab.Name,
            TextColor3 = NebulaLib.Theme.Text,
            TextSize = 14
        })

        -- Create content container with error checking
        Tab.Content = CreateInstance("ScrollingFrame", {
            Name = "Content",
            Parent = self.ContentContainer,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 2,
            Visible = false
        })

        -- Add UIListLayout
        CreateInstance("UIListLayout", {
            Parent = Tab.Content,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 5)
        })

        -- Add to tabs table
        table.insert(self.Tabs, Tab)
        return Tab
    end

    -- Title Text
    Window.Title = CreateInstance("TextLabel", {
        Name = "Title",
        Parent = Window.TitleBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(1, -20, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = Window.Name,
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Toggle Visibility Button
    Window.ToggleButton = CreateInstance("TextButton", {
        Name = "ToggleVisibility",
        Parent = Window.TitleBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -25, 0, 0),
        Size = UDim2.new(0, 25, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = "-",
        TextColor3 = self.Theme.Text,
        TextSize = 14
    })

    -- Add toggle functionality
    Window.ToggleButton.MouseButton1Click:Connect(function()
        local contentVisible = Window.MainFrame.Visible
        -- Create smooth fade animation
        local fadeOut = Services.TweenService:Create(
            Window.MainFrame,
            TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundTransparency = contentVisible and 1 or 0}
        )
        fadeOut:Play()
        -- Update visibility after animation
        fadeOut.Completed:Connect(function()
            Window.MainFrame.Visible = not contentVisible
            Window.ToggleButton.Text = contentVisible and "+" or "-"
        end)
    end)

    -- Dragging Functionality
    local dragging, dragInput, dragStart, startPos
    
    local function UpdateDrag(input)
        local delta = input.Position - dragStart
        Window.MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

    Window.TitleBar.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or
            (Window.MobileDrag and input.UserInputType == Enum.UserInputType.Touch)) then
            dragging = true
            dragStart = input.Position
            startPos = Window.MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    Window.TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or
           input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    Services.UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            UpdateDrag(input)
        end
    end)

    return Window
end

return NebulaLib
