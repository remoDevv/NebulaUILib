-- Nebula Lib
-- A mobile-friendly Roblox UI library
-- Version: 1.0.0

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

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

-- Theme Management Functions
function NebulaLib:SetTheme(theme)
    if type(theme) == "string" and self.ThemePresets[theme] then
        self.Theme = table.clone(self.ThemePresets[theme])
    elseif type(theme) == "table" then
        for key, value in pairs(theme) do
            if self.Theme[key] then
                self.Theme[key] = value
            end
        end
    end
    self:UpdateAllElements()
end

function NebulaLib:GetTheme()
    return table.clone(self.Theme)
end

function NebulaLib:GetThemePresets()
    return table.clone(self.ThemePresets)
end

function NebulaLib:AddThemePreset(name, theme)
    self.ThemePresets[name] = theme
end

function NebulaLib:UpdateAllElements()
    for _, window in pairs(self.Windows) do
        -- Update window elements
        if window.MainFrame then
            window.MainFrame.BackgroundColor3 = self.Theme.Background
        end
        if window.TitleBar then
            window.TitleBar.BackgroundColor3 = self.Theme.Secondary
        end
        if window.Title then
            window.Title.TextColor3 = self.Theme.Text
        end
        if window.TabContainer then
            window.TabContainer.BackgroundColor3 = self.Theme.Secondary
        end
        
        -- Update all tabs and their elements
        if window.Tabs then
            for _, tab in pairs(window.Tabs) do
                if tab.Button then
                    tab.Button.TextColor3 = self.Theme.Text
                end
                
                -- Update all elements in the tab
                if tab.Content then
                    for _, element in pairs(tab.Content:GetChildren()) do
                        if element:IsA("Frame") or element:IsA("TextButton") then
                            element.BackgroundColor3 = self.Theme.Secondary
                            
                            -- Update specific element types
                            if element.Name:find("Button") then
                                element.TextColor3 = self.Theme.Text
                            elseif element.Name:find("Toggle") then
                                local toggleButton = element:FindFirstChild("ToggleButton")
                                if toggleButton then
                                    toggleButton.BackgroundColor3 = toggleButton.Value and self.Theme.Accent or self.Theme.Secondary
                                end
                            elseif element.Name:find("Slider") then
                                local sliderFill = element:FindFirstChild("SliderFill")
                                if sliderFill then
                                    sliderFill.BackgroundColor3 = self.Theme.Accent
                                end
                            end
                            
                            -- Update text elements
                            for _, textLabel in pairs(element:GetDescendants()) do
                                if textLabel:IsA("TextLabel") then
                                    textLabel.TextColor3 = self.Theme.Text
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

-- Utility Functions
local function CreateInstance(className, properties)
    local instance = Instance.new(className)
    for prop, value in pairs(properties) do
        instance[prop] = value
    end
    return instance
end

local function Tween(instance, properties, duration)
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration, Enum.EasingStyle.Quad),
        properties
    )
    tween:Play()
    return tween
end

-- Core UI Creation
function NebulaLib:CreateWindow(config)
    config = config or {}
    local Window = {
        Name = config.Name or "Nebula Interface",
        Tabs = {},
        SaveConfig = config.SaveConfig or false,
        ConfigFolder = config.ConfigFolder or self.ConfigFolder,
        MobileDrag = config.MobileDrag or true
    }

    -- Main GUI Container
    Window.MainGui = CreateInstance("ScreenGui", {
        Name = "NebulaLib",
        Parent = CoreGui,
        ResetOnSpawn = false
    })

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

    -- Tab Container
    Window.TabContainer = CreateInstance("Frame", {
        Name = "TabContainer",
        Parent = Window.MainFrame,
        BackgroundColor3 = self.Theme.Secondary,
        Position = UDim2.new(0, 0, 0, 30),
        Size = UDim2.new(0, 120, 1, -30)
    })

    -- Tab Content Container
    Window.ContentContainer = CreateInstance("Frame", {
        Name = "ContentContainer",
        Parent = Window.MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 120, 0, 30),
        Size = UDim2.new(1, -120, 1, -30),
        ClipsDescendants = true
    })

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

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            UpdateDrag(input)
        end
    end)

    -- Window Methods
    function Window:CreateTab(config)
        config = config or {}
        local Tab = {
            Name = config.Name or "Tab",
            Icon = config.Icon
        }

        -- Tab Button
        Tab.Button = CreateInstance("TextButton", {
            Name = config.Name,
            Parent = Window.TabContainer,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 30),
            Font = Enum.Font.Gotham,
            Text = Tab.Name,
            TextColor3 = self.Theme.Text,
            TextSize = 14
        })

        -- Tab Content
        Tab.Content = CreateInstance("ScrollingFrame", {
            Name = "Content",
            Parent = Window.ContentContainer,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 2,
            Visible = false
        })

        -- Layout for Tab Content
        local UIListLayout = CreateInstance("UIListLayout", {
            Parent = Tab.Content,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 5)
        })

        -- Tab Methods
        function Tab:AddButton(config)
            config = config or {}
            local Button = CreateInstance("TextButton", {
                Parent = Tab.Content,
                BackgroundColor3 = NebulaLib.Theme.Secondary,
                Size = UDim2.new(1, -10, 0, 30),
                Position = UDim2.new(0, 5, 0, 0),
                Font = Enum.Font.Gotham,
                Text = config.Name or "Button",
                TextColor3 = NebulaLib.Theme.Text,
                TextSize = 14
            })

            CreateInstance("UICorner", {
                Parent = Button,
                CornerRadius = UDim.new(0, 4)
            })

            Button.MouseButton1Click:Connect(function()
                if config.Callback then
                    config.Callback()
                end
            end)

            return Button
        end

        function Tab:AddToggle(config)
            config = config or {}
            local Toggle = {
                Value = config.Default or false
            }

            local ToggleFrame = CreateInstance("Frame", {
                Parent = Tab.Content,
                BackgroundColor3 = NebulaLib.Theme.Secondary,
                Size = UDim2.new(1, -10, 0, 30),
                Position = UDim2.new(0, 5, 0, 0)
            })

            local ToggleButton = CreateInstance("TextButton", {
                Parent = ToggleFrame,
                BackgroundColor3 = Toggle.Value and NebulaLib.Theme.Accent or NebulaLib.Theme.DarkContrast,
                Position = UDim2.new(1, -40, 0.5, -10),
                Size = UDim2.new(0, 20, 0, 20),
                Text = ""
            })

            local ToggleText = CreateInstance("TextLabel", {
                Parent = ToggleFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -60, 1, 0),
                Font = Enum.Font.Gotham,
                Text = config.Name or "Toggle",
                TextColor3 = NebulaLib.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            CreateInstance("UICorner", {
                Parent = ToggleFrame,
                CornerRadius = UDim.new(0, 4)
            })

            CreateInstance("UICorner", {
                Parent = ToggleButton,
                CornerRadius = UDim.new(0, 4)
            })

            ToggleButton.MouseButton1Click:Connect(function()
                Toggle.Value = not Toggle.Value
                ToggleButton.BackgroundColor3 = Toggle.Value and NebulaLib.Theme.Accent or NebulaLib.Theme.DarkContrast
                if config.Callback then
                    config.Callback(Toggle.Value)
                end
            end)

            return Toggle
        end

        function Tab:AddSlider(config)
            config = config or {}
            local Slider = {
                Value = config.Default or config.Min or 0
            }

            local SliderFrame = CreateInstance("Frame", {
                Parent = Tab.Content,
                BackgroundColor3 = NebulaLib.Theme.Secondary,
                Size = UDim2.new(1, -10, 0, 45),
                Position = UDim2.new(0, 5, 0, 0)
            })

            local SliderText = CreateInstance("TextLabel", {
                Parent = SliderFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -20, 0, 20),
                Font = Enum.Font.Gotham,
                Text = config.Name or "Slider",
                TextColor3 = NebulaLib.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local SliderBackground = CreateInstance("Frame", {
                Parent = SliderFrame,
                BackgroundColor3 = NebulaLib.Theme.DarkContrast,
                Position = UDim2.new(0, 10, 0, 25),
                Size = UDim2.new(1, -20, 0, 10)
            })

            local SliderFill = CreateInstance("Frame", {
                Parent = SliderBackground,
                BackgroundColor3 = NebulaLib.Theme.Accent,
                Size = UDim2.new(0, 0, 1, 0)
            })

            CreateInstance("UICorner", {
                Parent = SliderFrame,
                CornerRadius = UDim.new(0, 4)
            })

            CreateInstance("UICorner", {
                Parent = SliderBackground,
                CornerRadius = UDim.new(0, 4)
            })

            CreateInstance("UICorner", {
                Parent = SliderFill,
                CornerRadius = UDim.new(0, 4)
            })

            local function UpdateSlider(input)
                local pos = UDim2.new(math.clamp((input.Position.X - SliderBackground.AbsolutePosition.X) / SliderBackground.AbsoluteSize.X, 0, 1), 0, 1, 0)
                SliderFill.Size = pos
                
                local value = math.floor(((pos.X.Scale * (config.Max - config.Min)) + config.Min) * 100) / 100
                Slider.Value = value
                SliderText.Text = config.Name .. ": " .. tostring(value)
                
                if config.Callback then
                    config.Callback(value)
                end
            end

            SliderBackground.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or
                   input.UserInputType == Enum.UserInputType.Touch then
                    UpdateSlider(input)
                    local connection
                    connection = RunService.RenderStepped:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            connection:Disconnect()
                        else
                            UpdateSlider(input)
                        end
                    end)
                end
            end)

            return Slider
        end

        function Tab:AddColorPicker(config)
            config = config or {}
            local ColorPicker = {
                Value = config.Default or Color3.fromRGB(255, 255, 255)
            }

            local ColorPickerFrame = CreateInstance("Frame", {
                Parent = Tab.Content,
                BackgroundColor3 = NebulaLib.Theme.Secondary,
                Size = UDim2.new(1, -10, 0, 70),
                Position = UDim2.new(0, 5, 0, 0)
            })

            local ColorPreview = CreateInstance("Frame", {
                Parent = ColorPickerFrame,
                BackgroundColor3 = ColorPicker.Value,
                Position = UDim2.new(1, -60, 0.5, -25),
                Size = UDim2.new(0, 50, 0, 50)
            })

            local ColorText = CreateInstance("TextLabel", {
                Parent = ColorPickerFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 5),
                Size = UDim2.new(1, -80, 0, 20),
                Font = Enum.Font.Gotham,
                Text = config.Name or "Color Picker",
                TextColor3 = NebulaLib.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            -- RGB Sliders
            local function CreateColorSlider(color, yPos)
                local SliderFrame = CreateInstance("Frame", {
                    Parent = ColorPickerFrame,
                    BackgroundColor3 = NebulaLib.Theme.Background,
                    Position = UDim2.new(0, 10, 0, yPos),
                    Size = UDim2.new(1, -80, 0, 10)
                })

                local SliderFill = CreateInstance("Frame", {
                    Parent = SliderFrame,
                    BackgroundColor3 = color == "R" and Color3.fromRGB(255,0,0) or color == "G" and Color3.fromRGB(0,255,0) or Color3.fromRGB(0,0,255),
                    Size = UDim2.new(ColorPicker.Value[color]/255, 0, 1, 0)
                })

                CreateInstance("UICorner", {
                    Parent = SliderFrame,
                    CornerRadius = UDim.new(0, 4)
                })

                CreateInstance("UICorner", {
                    Parent = SliderFill,
                    CornerRadius = UDim.new(0, 4)
                })

                return SliderFrame, SliderFill
            end

            local RSlider, RFill = CreateColorSlider("R", 30)
            local GSlider, GFill = CreateColorSlider("G", 45)
            local BSlider, BFill = CreateColorSlider("B", 60)

            -- Add corners and shadows
            CreateInstance("UICorner", {
                Parent = ColorPickerFrame,
                CornerRadius = UDim.new(0, 8)
            })

            CreateInstance("UICorner", {
                Parent = ColorPreview,
                CornerRadius = UDim.new(0, 8)
            })

            -- Update function
            local function UpdateColor(input, slider, color)
                local percentage = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
                local value = math.floor(percentage * 255)
                
                local r, g, b = ColorPicker.Value.R * 255, ColorPicker.Value.G * 255, ColorPicker.Value.B * 255
                if color == "R" then r = value
                elseif color == "G" then g = value
                else b = value end
                
                ColorPicker.Value = Color3.fromRGB(r, g, b)
                ColorPreview.BackgroundColor3 = ColorPicker.Value
                
                if config.Callback then
                    config.Callback(ColorPicker.Value)
                end
            end

            -- Input handlers for each slider
            local function SetupSliderInput(slider, fill, color)
                slider.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or
                       input.UserInputType == Enum.UserInputType.Touch then
                        UpdateColor(input, slider, color)
                        local connection
                        connection = RunService.RenderStepped:Connect(function()
                            if input.UserInputState == Enum.UserInputState.End then
                                connection:Disconnect()
                            else
                                UpdateColor(input, slider, color)
                            end
                        end)
                    end
                end)
            end

            SetupSliderInput(RSlider, RFill, "R")
            SetupSliderInput(GSlider, GFill, "G")
            SetupSliderInput(BSlider, BFill, "B")

            return ColorPicker
        end

        function Tab:AddTextInput(config)
            config = config or {}
            local TextInput = {
                Text = config.Default or ""
            }

            local InputFrame = CreateInstance("Frame", {
                Parent = Tab.Content,
                BackgroundColor3 = NebulaLib.Theme.Secondary,
                Size = UDim2.new(1, -10, 0, 40),
                Position = UDim2.new(0, 5, 0, 0)
            })

            local InputBox = CreateInstance("TextBox", {
                Parent = InputFrame,
                BackgroundColor3 = NebulaLib.Theme.Background,
                Position = UDim2.new(0, 10, 0.5, -15),
                Size = UDim2.new(1, -20, 0, 30),
                Font = Enum.Font.Gotham,
                PlaceholderText = config.Placeholder or "Enter text...",
                Text = TextInput.Text,
                TextColor3 = NebulaLib.Theme.Text,
                PlaceholderColor3 = NebulaLib.Theme.SubText,
                TextSize = 14,
                ClearTextOnFocus = false
            })

            -- Add corners and shadows
            CreateInstance("UICorner", {
                Parent = InputFrame,
                CornerRadius = UDim.new(0, 8)
            })

            CreateInstance("UICorner", {
                Parent = InputBox,
                CornerRadius = UDim.new(0, 8)
            })

            -- Text Changed handler
            InputBox.Changed:Connect(function(prop)
                if prop == "Text" then
                    TextInput.Text = InputBox.Text
                    if config.Callback then
                        config.Callback(TextInput.Text)
                    end
                end
            end)

            -- Validation
            if config.ValidationFunc then
                InputBox.FocusLost:Connect(function()
                    local success, result = pcall(config.ValidationFunc, TextInput.Text)
                    if success and result then
                        InputBox.BackgroundColor3 = NebulaLib.Theme.Background
                    else
                        InputBox.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                        task.delay(0.5, function()
                            InputBox.BackgroundColor3 = NebulaLib.Theme.Background
                        end)
                    end
                end)
            end

            return TextInput
        end

        return Tab
    end

    table.insert(self.Windows, Window)
    return Window
end

function NebulaLib:ShowNotification(config)
    config = config or {}
    
    local Notification = CreateInstance("Frame", {
        Parent = self.Windows[1].MainGui,
        BackgroundColor3 = self.Theme.Background,
        Position = UDim2.new(1, -310, 1, -110),
        Size = UDim2.new(0, 300, 0, 100),
        ClipsDescendants = true
    })

    CreateInstance("UICorner", {
        Parent = Notification,
        CornerRadius = UDim.new(0, 6)
    })

    local Title = CreateInstance("TextLabel", {
        Parent = Notification,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 10),
        Size = UDim2.new(1, -20, 0, 20),
        Font = Enum.Font.GothamBold,
        Text = config.Title or "Notification",
        TextColor3 = self.Theme.Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local Content = CreateInstance("TextLabel", {
        Parent = Notification,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 40),
        Size = UDim2.new(1, -20, 0, 50),
        Font = Enum.Font.Gotham,
        Text = config.Content or "",
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true
    })

    Tween(Notification, {Position = UDim2.new(1, -310, 1, -110)}, 0.5)
    task.delay(config.Time or 3, function()
        Tween(Notification, {Position = UDim2.new(1, 10, 1, -110)}, 0.5).Completed:Wait()
        Notification:Destroy()
    end)
end

function NebulaLib:Init()
    -- Load saved configurations if enabled
    for _, window in ipairs(self.Windows) do
        if window.SaveConfig then
            -- Implementation for loading saved configs
        end
    end
end

function NebulaLib:Destroy()
    for _, window in ipairs(self.Windows) do
        if window.MainGui then
            window.MainGui:Destroy()
        end
    end
    self.Windows = {}
end

return NebulaLib