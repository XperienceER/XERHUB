--[[
    ╔══════════════════════════════════════════════════════════════════╗
    ║                     SAPPHIRE MINIMAL UI SUITE                   ║
    ║               Redesigned Fluent-Compatible Library               ║
    ║       Theme: Minimalist Deep Blue / Frost Azure / Glassmorphism  ║
    ╚══════════════════════════════════════════════════════════════════╝
--]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TextService = game:GetService("TextService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

local protectgui = protectgui or (syn and syn.protect_gui) or function() end

-- ============================================================================
-- THEME CONFIGURATION (Cyber Sapphire & Modern Midnight Blue)
-- ============================================================================
local Themes = {
    Names = {"Sapphire", "Midnight", "AquaGlow", "Dark"},
    
    Sapphire = {
        Accent = Color3.fromRGB(0, 162, 255),
        AccentGlow = Color3.fromRGB(0, 210, 255),
        AccentDark = Color3.fromRGB(0, 95, 175),
        
        Background = Color3.fromRGB(11, 16, 26),
        BackgroundTransparency = 0.15,
        
        Card = Color3.fromRGB(16, 24, 40),
        CardHover = Color3.fromRGB(24, 35, 58),
        CardBorder = Color3.fromRGB(32, 48, 80),
        CardBorderFocused = Color3.fromRGB(0, 162, 255),
        
        TitleBar = Color3.fromRGB(14, 20, 34),
        TitleBarLine = Color3.fromRGB(25, 38, 64),
        
        TabActive = Color3.fromRGB(0, 162, 255),
        TabInactive = Color3.fromRGB(130, 150, 180),
        TabBackground = Color3.fromRGB(18, 27, 46),
        
        Text = Color3.fromRGB(245, 248, 255),
        SubText = Color3.fromRGB(140, 160, 195),
        
        ToggleOff = Color3.fromRGB(25, 36, 60),
        ToggleOn = Color3.fromRGB(0, 162, 255),
        
        SliderRail = Color3.fromRGB(22, 32, 54),
        
        Dialog = Color3.fromRGB(13, 19, 32),
        DialogHolder = Color3.fromRGB(9, 14, 24),
        DialogBorder = Color3.fromRGB(35, 55, 90),
        
        Scrollbar = Color3.fromRGB(0, 162, 255),
        ScrollbarTransparency = 0.7
    },
    
    Midnight = {
        Accent = Color3.fromRGB(80, 130, 255),
        AccentGlow = Color3.fromRGB(120, 170, 255),
        AccentDark = Color3.fromRGB(40, 70, 160),
        
        Background = Color3.fromRGB(7, 9, 15),
        BackgroundTransparency = 0.1,
        
        Card = Color3.fromRGB(12, 16, 26),
        CardHover = Color3.fromRGB(18, 24, 40),
        CardBorder = Color3.fromRGB(24, 34, 56),
        CardBorderFocused = Color3.fromRGB(80, 130, 255),
        
        TitleBar = Color3.fromRGB(10, 13, 22),
        TitleBarLine = Color3.fromRGB(20, 28, 48),
        
        TabActive = Color3.fromRGB(80, 130, 255),
        TabInactive = Color3.fromRGB(110, 130, 165),
        TabBackground = Color3.fromRGB(14, 19, 32),
        
        Text = Color3.fromRGB(240, 245, 255),
        SubText = Color3.fromRGB(120, 140, 175),
        
        ToggleOff = Color3.fromRGB(20, 28, 46),
        ToggleOn = Color3.fromRGB(80, 130, 255),
        
        SliderRail = Color3.fromRGB(18, 25, 42),
        
        Dialog = Color3.fromRGB(10, 13, 22),
        DialogHolder = Color3.fromRGB(6, 8, 14),
        DialogBorder = Color3.fromRGB(28, 40, 68),
        
        Scrollbar = Color3.fromRGB(80, 130, 255),
        ScrollbarTransparency = 0.7
    }
}

-- Fallback theme
Themes.AquaGlow = Themes.Sapphire
Themes.Dark = Themes.Midnight

-- ============================================================================
-- CORE CREATOR & ANIMATION UTILITIES
-- ============================================================================
local Creator = {
    Signals = {},
    Objects = {},
    CurrentTheme = "Sapphire"
}

function Creator.GetThemeProperty(property)
    local active = Themes[Creator.CurrentTheme] or Themes.Sapphire
    return active[property] or Themes.Sapphire[property]
end

function Creator.AddSignal(signal, callback)
    local conn = signal:Connect(callback)
    table.insert(Creator.Signals, conn)
    return conn
end

function Creator.Disconnect()
    for _, conn in ipairs(Creator.Signals) do
        if conn and conn.Connected then
            pcall(function() conn:Disconnect() end)
        end
    end
    Creator.Signals = {}
end

function Creator.New(className, properties, children)
    local inst = Instance.new(className)
    
    for prop, val in pairs(properties or {}) do
        if prop == "ThemeTag" then
            Creator.Objects[inst] = val
            for tagProp, themeKey in pairs(val) do
                inst[tagProp] = Creator.GetThemeProperty(themeKey)
            end
        else
            inst[prop] = val
        end
    end
    
    for _, child in ipairs(children or {}) do
        child.Parent = inst
    end
    
    return inst
end

function Creator.UpdateTheme()
    for inst, tags in pairs(Creator.Objects) do
        if inst and inst.Parent then
            for tagProp, themeKey in pairs(tags) do
                pcall(function()
                    inst[tagProp] = Creator.GetThemeProperty(themeKey)
                end)
            end
        else
            Creator.Objects[inst] = nil
        end
    end
end

function Creator.Tween(instance, tweenInfo, properties)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

-- ============================================================================
-- ICONS REPOSITORY (Lucide)
-- ============================================================================
local Icons = {
    ["lucide-settings"] = "rbxassetid://10734950309",
    ["lucide-home"] = "rbxassetid://10723407389",
    ["lucide-user"] = "rbxassetid://10747373176",
    ["lucide-bell"] = "rbxassetid://10709775704",
    ["lucide-shield"] = "rbxassetid://10734951847",
    ["lucide-zap"] = "rbxassetid://10723345749",
    ["lucide-box"] = "rbxassetid://10709782497",
    ["lucide-layers"] = "rbxassetid://10723424505",
    ["lucide-chevron-down"] = "rbxassetid://10709790948",
    ["lucide-chevron-right"] = "rbxassetid://10709791437",
    ["lucide-close"] = "rbxassetid://9886659671",
    ["lucide-min"] = "rbxassetid://9886659276",
    ["lucide-max"] = "rbxassetid://9886659406",
    ["lucide-restore"] = "rbxassetid://9886659001",
    ["lucide-check"] = "rbxassetid://10709790644",
    ["lucide-search"] = "rbxassetid://10734943674"
}

-- ============================================================================
-- MAIN FLUENT INTERFACE SUITE
-- ============================================================================
local ScreenGui = Creator.New("ScreenGui", {
    Name = "Sapphire_Interface",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = RunService:IsStudio() and LocalPlayer.PlayerGui or game:GetService("CoreGui")
})
protectgui(ScreenGui)

local Fluent = {
    Version = "2.0.0-Sapphire",
    Options = {},
    Themes = Themes.Names,
    CurrentTheme = "Sapphire",
    Window = nil,
    GUI = ScreenGui,
    OpenFrames = {},
    Unloaded = false,
    MinimizeKey = Enum.KeyCode.LeftControl,
    MinimizeKeybind = nil
}

function Fluent:GetIcon(icon)
    if not icon then return nil end
    if Icons[icon] then return Icons[icon] end
    if Icons["lucide-" .. icon] then return Icons["lucide-" .. icon] end
    if string.find(icon, "rbxassetid://") or string.find(icon, "http") then
        return icon
    end
    return nil
end

function Fluent:SafeCallback(callback, ...)
    if type(callback) ~= "function" then return end
    local success, result = pcall(callback, ...)
    if not success then
        warn("[Sapphire Fluent Error]:", result)
        self:Notify({
            Title = "Execution Error",
            Content = tostring(result):gsub(".-:%d+: ", ""),
            Duration = 5
        })
    end
end

function Fluent:Round(num, decimalPlaces)
    if not decimalPlaces or decimalPlaces == 0 then
        return math.floor(num + 0.5)
    end
    local mult = 10 ^ decimalPlaces
    return math.floor(num * mult + 0.5) / mult
end

function Fluent:SetTheme(themeName)
    if Themes[themeName] then
        Fluent.CurrentTheme = themeName
        Creator.CurrentTheme = themeName
        Creator.UpdateTheme()
    end
end

function Fluent:Destroy()
    Fluent.Unloaded = true
    Creator.Disconnect()
    if ScreenGui then
        ScreenGui:Destroy()
    end
    if Fluent.AcrylicEffect then
        Fluent.AcrylicEffect:Destroy()
    end
end

-- ============================================================================
-- NOTIFICATION SYSTEM
-- ============================================================================
local NotifHolder = Creator.New("Frame", {
    Size = UDim2.new(0, 320, 1, -40),
    Position = UDim2.new(1, -340, 0, 20),
    BackgroundTransparency = 1,
    Parent = ScreenGui
}, {
    Creator.New("UIListLayout", {
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
})

function Fluent:Notify(config)
    local title = config.Title or "Notification"
    local content = config.Content or ""
    local subContent = config.SubContent or ""
    local duration = config.Duration or 4.5
    
    local card = Creator.New("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 0.1,
        Position = UDim2.new(1, 50, 0, 0),
        Parent = NotifHolder,
        ThemeTag = {
            BackgroundColor3 = "Card",
        }
    }, {
        Creator.New("UICorner", { CornerRadius = UDim.new(0, 8) }),
        Creator.New("UIStroke", {
            Thickness = 1.2,
            Transparency = 0.3,
            ThemeTag = { Color = "CardBorder" }
        }),
        -- Accent Neon Stripe
        Creator.New("Frame", {
            Size = UDim2.new(0, 4, 1, -12),
            Position = UDim2.new(0, 6, 0, 6),
            ThemeTag = { BackgroundColor3 = "Accent" }
        }, {
            Creator.New("UICorner", { CornerRadius = UDim.new(1, 0) })
        }),
        Creator.New("Frame", {
            Size = UDim2.new(1, -26, 1, 0),
            Position = UDim2.new(0, 18, 0, 0),
            BackgroundTransparency = 1,
            AutomaticSize = Enum.AutomaticSize.Y
        }, {
            Creator.New("UIPadding", {
                PaddingTop = UDim.new(0, 10),
                PaddingBottom = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10)
            }),
            Creator.New("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 3)
            }),
            Creator.New("TextLabel", {
                Text = title,
                FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold),
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 16),
                ThemeTag = { TextColor3 = "Text" }
            }),
            Creator.New("TextLabel", {
                Text = content,
                FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular),
                TextSize = 12,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                ThemeTag = { TextColor3 = "SubText" }
            })
        })
    })

    if subContent ~= "" then
        Creator.New("TextLabel", {
            Text = subContent,
            FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Light),
            TextSize = 11,
            TextTransparency = 0.3,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 14),
            Parent = card:FindFirstChildOfClass("Frame"),
            ThemeTag = { TextColor3 = "SubText" }
        })
    end

    -- Animation In
    card.Position = UDim2.new(1, 100, 0, 0)
    Creator.Tween(card, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0, 0)
    })

    task.delay(duration, function()
        if card and card.Parent then
            local tween = Creator.Tween(card, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                Position = UDim2.new(1, 100, 0, 0)
            })
            tween.Completed:Connect(function()
                card:Destroy()
            end)
        end
    end)
end

-- ============================================================================
-- WINDOW CREATION
-- ============================================================================
function Fluent:CreateWindow(config)
    assert(config.Title, "Fluent.CreateWindow: Missing Title")
    if Fluent.Window then
        warn("Fluent: A window is already opened.")
        return Fluent.Window
    end

    local title = config.Title or "SAPPHIRE"
    local subTitle = config.SubTitle or "v2.0"
    local tabWidth = config.TabWidth or 160
    local size = config.Size or UDim2.fromOffset(580, 380)
    local minimizeKey = config.MinimizeKey or Enum.KeyCode.LeftControl
    
    Fluent.MinimizeKey = minimizeKey

    -- Window Outer Container (Glass Outline)
    local RootFrame = Creator.New("Frame", {
        Name = "Sapphire_Root",
        Size = size,
        Position = UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2),
        BackgroundTransparency = 0.05,
        Parent = ScreenGui,
        ThemeTag = {
            BackgroundColor3 = "Background"
        }
    }, {
        Creator.New("UICorner", { CornerRadius = UDim.new(0, 10) }),
        Creator.New("UIStroke", {
            Thickness = 1.5,
            Transparency = 0.2,
            ThemeTag = { Color = "CardBorder" }
        })
    })

    -- Header Bar
    local Header = Creator.New("Frame", {
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundTransparency = 1,
        Parent = RootFrame
    }, {
        Creator.New("Frame", {
            Size = UDim2.new(1, 0, 0, 1),
            Position = UDim2.new(0, 0, 1, -1),
            ThemeTag = { BackgroundColor3 = "TitleBarLine" }
        }),
        -- Title & Logo Group
        Creator.New("Frame", {
            Size = UDim2.new(1, -120, 1, 0),
            Position = UDim2.new(0, 14, 0, 0),
            BackgroundTransparency = 1
        }, {
            Creator.New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Padding = UDim.new(0, 8)
            }),
            Creator.New("Frame", {
                Size = UDim2.fromOffset(8, 8),
                ThemeTag = { BackgroundColor3 = "Accent" }
            }, {
                Creator.New("UICorner", { CornerRadius = UDim.new(1, 0) })
            }),
            Creator.New("TextLabel", {
                Text = title:upper(),
                FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutomaticSize = Enum.AutomaticSize.X,
                Size = UDim2.new(0, 0, 1, 0),
                BackgroundTransparency = 1,
                ThemeTag = { TextColor3 = "Text" }
            }),
            Creator.New("TextLabel", {
                Text = "| " .. subTitle,
                FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutomaticSize = Enum.AutomaticSize.X,
                Size = UDim2.new(0, 0, 1, 0),
                BackgroundTransparency = 1,
                ThemeTag = { TextColor3 = "SubText" }
            })
        })
    })

    -- Control Buttons (Minimize & Close)
    local Controls = Creator.New("Frame", {
        Size = UDim2.new(0, 70, 1, 0),
        Position = UDim2.new(1, -75, 0, 0),
        BackgroundTransparency = 1,
        Parent = Header
    }, {
        Creator.New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 6)
        })
    })

    local function CreateTopButton(icon, onClick)
        local btn = Creator.New("ImageButton", {
            Size = UDim2.fromOffset(24, 24),
            BackgroundTransparency = 1,
            Image = icon,
            ImageTransparency = 0.3,
            Parent = Controls,
            ThemeTag = { ImageColor3 = "Text" }
        }, {
            Creator.New("UICorner", { CornerRadius = UDim.new(0, 6) })
        })
        
        Creator.AddSignal(btn.MouseEnter, function()
            Creator.Tween(btn, TweenInfo.new(0.2), { ImageTransparency = 0 })
        end)
        Creator.AddSignal(btn.MouseLeave, function()
            Creator.Tween(btn, TweenInfo.new(0.2), { ImageTransparency = 0.3 })
        end)
        Creator.AddSignal(btn.MouseButton1Click, onClick)
        return btn
    end

    local Window = {
        Root = RootFrame,
        Tabs = {},
        SelectedTab = nil,
        Minimized = false
    }

    CreateTopButton(Fluent:GetIcon("min"), function()
        Window:ToggleMinimize()
    end)
    CreateTopButton(Fluent:GetIcon("close"), function()
        Fluent:Destroy()
    end)

    -- Window Body
    local Body = Creator.New("Frame", {
        Size = UDim2.new(1, 0, 1, -42),
        Position = UDim2.new(0, 0, 0, 42),
        BackgroundTransparency = 1,
        Parent = RootFrame
    })

    -- Sidebar / Tab List
    local Sidebar = Creator.New("Frame", {
        Size = UDim2.new(0, tabWidth, 1, 0),
        BackgroundTransparency = 1,
        Parent = Body
    }, {
        Creator.New("Frame", {
            Size = UDim2.new(0, 1, 1, 0),
            Position = UDim2.new(1, -1, 0, 0),
            ThemeTag = { BackgroundColor3 = "TitleBarLine" }
        })
    })

    local TabScroll = Creator.New("ScrollingFrame", {
        Size = UDim2.new(1, -12, 1, -16),
        Position = UDim2.new(0, 8, 0, 8),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = Sidebar
    }, {
        Creator.New("UIListLayout", {
            Padding = UDim.new(0, 4),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
    })

    -- Content Container
    local ContentHolder = Creator.New("Frame", {
        Size = UDim2.new(1, -tabWidth - 16, 1, -16),
        Position = UDim2.new(0, tabWidth + 8, 0, 8),
        BackgroundTransparency = 1,
        Parent = Body
    })

    -- Dragging Logic (Fixed & Smoothed)
    local isDragging, dragStart, startPos = false, nil, nil
    Creator.AddSignal(Header.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStart = input.Position
            startPos = RootFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    isDragging = false
                end
            end)
        end
    end)

    Creator.AddSignal(UserInputService.InputChanged, function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            RootFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    function Window:ToggleMinimize()
        Window.Minimized = not Window.Minimized
        if Window.Minimized then
            Creator.Tween(Body, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 0, 0) })
            task.delay(0.2, function() Body.Visible = false end)
            Creator.Tween(RootFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = UDim2.new(size.X.Scale, size.X.Offset, 0, 42) })
        else
            Body.Visible = true
            Creator.Tween(Body, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 1, -42) })
            Creator.Tween(RootFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = size })
        end
    end

    -- Tab System
    function Window:AddTab(tabConfig)
        local tabTitle = tabConfig.Title or "Tab"
        local tabIcon = Fluent:GetIcon(tabConfig.Icon)
        
        local TabBtn = Creator.New("TextButton", {
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundTransparency = 1,
            Text = "",
            Parent = TabScroll,
            ThemeTag = {
                BackgroundColor3 = "TabBackground"
            }
        }, {
            Creator.New("UICorner", { CornerRadius = UDim.new(0, 6) }),
            -- Neon selection indicator bar
            Creator.New("Frame", {
                Name = "GlowIndicator",
                Size = UDim2.new(0, 3, 0, 0),
                Position = UDim2.new(0, 2, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundTransparency = 1,
                ThemeTag = { BackgroundColor3 = "Accent" }
            }, {
                Creator.New("UICorner", { CornerRadius = UDim.new(1, 0) })
            }),
            Creator.New("TextLabel", {
                Name = "Title",
                Text = tabTitle,
                FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
                TextSize = 12,
                Position = UDim2.new(0, tabIcon and 28 or 10, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundTransparency = 1,
                ThemeTag = { TextColor3 = "TabInactive" }
            })
        })

        if tabIcon then
            Creator.New("ImageLabel", {
                Name = "Icon",
                Size = UDim2.fromOffset(14, 14),
                Position = UDim2.new(0, 8, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Image = tabIcon,
                BackgroundTransparency = 1,
                Parent = TabBtn,
                ThemeTag = { ImageColor3 = "TabInactive" }
            })
        end

        -- Tab Content Scroll
        local PageScroll = Creator.New("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 3,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            Parent = ContentHolder,
            ThemeTag = {
                ScrollBarImageColor3 = "Scrollbar"
            }
        }, {
            Creator.New("UIListLayout", {
                Padding = UDim.new(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder
            }),
            Creator.New("UIPadding", {
                PaddingTop = UDim.new(0, 2),
                PaddingRight = UDim.new(0, 6),
                PaddingLeft = UDim.new(0, 2),
                PaddingBottom = UDim.new(0, 6)
            })
        })

        -- Auto adjust canvas size
        local layout = PageScroll:FindFirstChildOfClass("UIListLayout")
        Creator.AddSignal(layout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
            PageScroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
        end)
        
        local tabLayout = TabScroll:FindFirstChildOfClass("UIListLayout")
        Creator.AddSignal(tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
            TabScroll.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 10)
        end)

        local Tab = {
            Button = TabBtn,
            Page = PageScroll,
            Container = PageScroll
        }

        function Tab:Select()
            for _, otherTab in pairs(Window.Tabs) do
                otherTab.Page.Visible = false
                Creator.Tween(otherTab.Button, TweenInfo.new(0.2), { BackgroundTransparency = 1 })
                Creator.Tween(otherTab.Button.GlowIndicator, TweenInfo.new(0.2), { Size = UDim2.new(0, 3, 0, 0), BackgroundTransparency = 1 })
                otherTab.Button.Title.TextColor3 = Creator.GetThemeProperty("TabInactive")
                if otherTab.Button:FindFirstChild("Icon") then
                    otherTab.Button.Icon.ImageColor3 = Creator.GetThemeProperty("TabInactive")
                end
            end

            Tab.Page.Visible = true
            Window.SelectedTab = Tab
            Creator.Tween(TabBtn, TweenInfo.new(0.2), { BackgroundTransparency = 0.3 })
            Creator.Tween(TabBtn.GlowIndicator, TweenInfo.new(0.25, Enum.EasingStyle.Back), { Size = UDim2.new(0, 3, 0, 16), BackgroundTransparency = 0 })
            TabBtn.Title.TextColor3 = Creator.GetThemeProperty("Text")
            if TabBtn:FindFirstChild("Icon") then
                TabBtn.Icon.ImageColor3 = Creator.GetThemeProperty("Accent")
            end
        end

        Creator.AddSignal(TabBtn.MouseButton1Click, function()
            Tab:Select()
        end)

        table.insert(Window.Tabs, Tab)
        if #Window.Tabs == 1 then
            Tab:Select()
        end

        -- ====================================================================
        -- COMPONENT GENERATORS (Section, Button, Toggle, Slider, Dropdown...)
        -- ====================================================================

        function Tab:AddSection(sectionTitle)
            local SectionFrame = Creator.New("Frame", {
                Size = UDim2.new(1, 0, 0, 24),
                BackgroundTransparency = 1,
                Parent = PageScroll
            }, {
                Creator.New("TextLabel", {
                    Text = sectionTitle:upper(),
                    FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
                    TextSize = 10,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 4, 0, 6),
                    BackgroundTransparency = 1,
                    ThemeTag = { TextColor3 = "Accent" }
                }),
                Creator.New("Frame", {
                    Size = UDim2.new(1, -8, 0, 1),
                    Position = UDim2.new(0, 4, 1, -2),
                    ThemeTag = { BackgroundColor3 = "CardBorder" }
                })
            })
            return SectionFrame
        end

        function Tab:AddParagraph(pConfig)
            local pTitle = pConfig.Title or "Information"
            local pContent = pConfig.Content or ""

            local card = Creator.New("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 0.2,
                Parent = PageScroll,
                ThemeTag = { BackgroundColor3 = "Card" }
            }, {
                Creator.New("UICorner", { CornerRadius = UDim.new(0, 6) }),
                Creator.New("UIStroke", { Thickness = 1, ThemeTag = { Color = "CardBorder" } }),
                Creator.New("UIPadding", {
                    PaddingTop = UDim.new(0, 8),
                    PaddingBottom = UDim.new(0, 8),
                    PaddingLeft = UDim.new(0, 10),
                    PaddingRight = UDim.new(0, 10)
                }),
                Creator.New("UIListLayout", { Padding = UDim.new(0, 3) }),
                Creator.New("TextLabel", {
                    Text = pTitle,
                    FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold),
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 14),
                    ThemeTag = { TextColor3 = "Text" }
                }),
                Creator.New("TextLabel", {
                    Text = pContent,
                    FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular),
                    TextSize = 11,
                    TextWrapped = true,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    ThemeTag = { TextColor3 = "SubText" }
                })
            })
            return card
        end

        function Tab:AddButton(btnConfig)
            local bTitle = btnConfig.Title or "Button"
            local bDesc = btnConfig.Description or ""
            local callback = btnConfig.Callback or function() end

            local card = Creator.New("TextButton", {
                Size = UDim2.new(1, 0, 0, bDesc ~= "" and 42 or 34),
                BackgroundTransparency = 0.25,
                Text = "",
                Parent = PageScroll,
                ThemeTag = { BackgroundColor3 = "Card" }
            }, {
                Creator.New("UICorner", { CornerRadius = UDim.new(0, 6) }),
                Creator.New("UIStroke", { Thickness = 1, ThemeTag = { Color = "CardBorder" } }),
                Creator.New("ImageLabel", {
                    Size = UDim2.fromOffset(14, 14),
                    Position = UDim2.new(1, -22, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Image = Fluent:GetIcon("chevron-right"),
                    BackgroundTransparency = 1,
                    ThemeTag = { ImageColor3 = "Accent" }
                }),
                Creator.New("Frame", {
                    Size = UDim2.new(1, -30, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1
                }, {
                    Creator.New("UIListLayout", {
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        Padding = UDim.new(0, 1)
                    }),
                    Creator.New("TextLabel", {
                        Text = bTitle,
                        FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
                        TextSize = 12,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 14),
                        ThemeTag = { TextColor3 = "Text" }
                    })
                })
            })

            if bDesc ~= "" then
                Creator.New("TextLabel", {
                    Text = bDesc,
                    FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular),
                    TextSize = 10,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 12),
                    Parent = card:FindFirstChildOfClass("Frame"),
                    ThemeTag = { TextColor3 = "SubText" }
                })
            end

            Creator.AddSignal(card.MouseEnter, function()
                Creator.Tween(card, TweenInfo.new(0.2), { BackgroundColor3 = Creator.GetThemeProperty("CardHover") })
            end)
            Creator.AddSignal(card.MouseLeave, function()
                Creator.Tween(card, TweenInfo.new(0.2), { BackgroundColor3 = Creator.GetThemeProperty("Card") })
            end)
            Creator.AddSignal(card.MouseButton1Click, function()
                Fluent:SafeCallback(callback)
            end)

            return card
        end

        function Tab:AddToggle(id, toggleConfig)
            local tTitle = toggleConfig.Title or "Toggle"
            local tDesc = toggleConfig.Description or ""
            local default = toggleConfig.Default or false
            local callback = toggleConfig.Callback or function() end

            local Toggle = { Value = default, Type = "Toggle" }

            local card = Creator.New("TextButton", {
                Size = UDim2.new(1, 0, 0, tDesc ~= "" and 42 or 34),
                BackgroundTransparency = 0.25,
                Text = "",
                Parent = PageScroll,
                ThemeTag = { BackgroundColor3 = "Card" }
            }, {
                Creator.New("UICorner", { CornerRadius = UDim.new(0, 6) }),
                Creator.New("UIStroke", { Thickness = 1, ThemeTag = { Color = "CardBorder" } }),
                Creator.New("Frame", {
                    Size = UDim2.new(1, -55, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1
                }, {
                    Creator.New("UIListLayout", {
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        Padding = UDim.new(0, 1)
                    }),
                    Creator.New("TextLabel", {
                        Text = tTitle,
                        FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
                        TextSize = 12,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 14),
                        ThemeTag = { TextColor3 = "Text" }
                    })
                })
            })

            if tDesc ~= "" then
                Creator.New("TextLabel", {
                    Text = tDesc,
                    FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular),
                    TextSize = 10,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 12),
                    Parent = card:FindFirstChildOfClass("Frame"),
                    ThemeTag = { TextColor3 = "SubText" }
                })
            end

            -- Switch Track
            local Track = Creator.New("Frame", {
                Size = UDim2.fromOffset(36, 18),
                Position = UDim2.new(1, -44, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Parent = card,
                ThemeTag = { BackgroundColor3 = "ToggleOff" }
            }, {
                Creator.New("UICorner", { CornerRadius = UDim.new(1, 0) }),
                Creator.New("UIStroke", { Thickness = 1, ThemeTag = { Color = "CardBorder" } })
            })

            local Thumb = Creator.New("Frame", {
                Size = UDim2.fromOffset(12, 12),
                Position = UDim2.new(0, 3, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Parent = Track
            }, {
                Creator.New("UICorner", { CornerRadius = UDim.new(1, 0) })
            })

            function Toggle:SetValue(val)
                Toggle.Value = not not val
                if Toggle.Value then
                    Creator.Tween(Track, TweenInfo.new(0.2), { BackgroundColor3 = Creator.GetThemeProperty("Accent") })
                    Creator.Tween(Thumb, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        Position = UDim2.new(1, -15, 0.5, 0)
                    })
                else
                    Creator.Tween(Track, TweenInfo.new(0.2), { BackgroundColor3 = Creator.GetThemeProperty("ToggleOff") })
                    Creator.Tween(Thumb, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        Position = UDim2.new(0, 3, 0.5, 0)
                    })
                end
                Fluent:SafeCallback(callback, Toggle.Value)
            end

            Creator.AddSignal(card.MouseButton1Click, function()
                Toggle:SetValue(not Toggle.Value)
            end)

            Toggle:SetValue(default)
            Fluent.Options[id] = Toggle
            return Toggle
        end

        function Tab:AddSlider(id, sliderConfig)
            local sTitle = sliderConfig.Title or "Slider"
            local sDesc = sliderConfig.Description or ""
            local min = sliderConfig.Min or 0
            local max = sliderConfig.Max or 100
            local rounding = sliderConfig.Rounding or 0
            local default = math.clamp(sliderConfig.Default or min, min, max)
            local callback = sliderConfig.Callback or function() end

            local Slider = { Value = default, Type = "Slider" }

            local card = Creator.New("Frame", {
                Size = UDim2.new(1, 0, 0, sDesc ~= "" and 50 or 44),
                BackgroundTransparency = 0.25,
                Parent = PageScroll,
                ThemeTag = { BackgroundColor3 = "Card" }
            }, {
                Creator.New("UICorner", { CornerRadius = UDim.new(0, 6) }),
                Creator.New("UIStroke", { Thickness = 1, ThemeTag = { Color = "CardBorder" } }),
                Creator.New("Frame", {
                    Size = UDim2.new(1, -20, 0, 16),
                    Position = UDim2.new(0, 10, 0, 6),
                    BackgroundTransparency = 1
                }, {
                    Creator.New("TextLabel", {
                        Text = sTitle,
                        FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
                        TextSize = 12,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, -50, 1, 0),
                        ThemeTag = { TextColor3 = "Text" }
                    }),
                    Creator.New("TextLabel", {
                        Name = "ValueLabel",
                        Text = tostring(default),
                        FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
                        TextSize = 11,
                        TextXAlignment = Enum.TextXAlignment.Right,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, 45, 1, 0),
                        Position = UDim2.new(1, -45, 0, 0),
                        ThemeTag = { TextColor3 = "Accent" }
                    })
                })
            })

            local ValueLabel = card:FindFirstChild("ValueLabel", true)

            -- Slider Bar
            local Bar = Creator.New("TextButton", {
                Size = UDim2.new(1, -20, 0, 5),
                Position = UDim2.new(0, 10, 1, -12),
                Text = "",
                AutoButtonColor = false,
                Parent = card,
                ThemeTag = { BackgroundColor3 = "SliderRail" }
            }, {
                Creator.New("UICorner", { CornerRadius = UDim.new(1, 0) })
            })

            local Fill = Creator.New("Frame", {
                Size = UDim2.new(0, 0, 1, 0),
                Parent = Bar,
                ThemeTag = { BackgroundColor3 = "Accent" }
            }, {
                Creator.New("UICorner", { CornerRadius = UDim.new(1, 0) })
            })

            local Knob = Creator.New("Frame", {
                Size = UDim2.fromOffset(11, 11),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(1, 0, 0.5, 0),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Parent = Fill
            }, {
                Creator.New("UICorner", { CornerRadius = UDim.new(1, 0) })
            })

            function Slider:SetValue(val)
                if min == max then
                    Slider.Value = min
                    Fill.Size = UDim2.new(1, 0, 1, 0)
                else
                    val = math.clamp(val, min, max)
                    Slider.Value = Fluent:Round(val, rounding)
                    local percent = (Slider.Value - min) / (max - min)
                    Fill.Size = UDim2.new(percent, 0, 1, 0)
                end
                ValueLabel.Text = tostring(Slider.Value)
                Fluent:SafeCallback(callback, Slider.Value)
            end

            local isDraggingSlider = false
            local function UpdateFromInput(input)
                local absPos = Bar.AbsolutePosition.X
                local absSize = Bar.AbsoluteSize.X
                local percent = math.clamp((input.Position.X - absPos) / absSize, 0, 1)
                Slider:SetValue(min + ((max - min) * percent))
            end

            Creator.AddSignal(Bar.InputBegan, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    isDraggingSlider = true
                    UpdateFromInput(input)
                end
            end)

            Creator.AddSignal(UserInputService.InputChanged, function(input)
                if isDraggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateFromInput(input)
                end
            end)

            Creator.AddSignal(UserInputService.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    isDraggingSlider = false
                end
            end)

            Slider:SetValue(default)
            Fluent.Options[id] = Slider
            return Slider
        end

        function Tab:AddInput(id, inputConfig)
            local iTitle = inputConfig.Title or "Input"
            local default = inputConfig.Default or ""
            local placeholder = inputConfig.Placeholder or "Type here..."
            local numeric = inputConfig.Numeric or false
            local finished = inputConfig.Finished or false
            local callback = inputConfig.Callback or function() end

            local Input = { Value = default, Type = "Input" }

            local card = Creator.New("Frame", {
                Size = UDim2.new(1, 0, 0, 38),
                BackgroundTransparency = 0.25,
                Parent = PageScroll,
                ThemeTag = { BackgroundColor3 = "Card" }
            }, {
                Creator.New("UICorner", { CornerRadius = UDim.new(0, 6) }),
                Creator.New("UIStroke", { Thickness = 1, ThemeTag = { Color = "CardBorder" } }),
                Creator.New("TextLabel", {
                    Text = iTitle,
                    FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 10, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.4, 0, 1, 0),
                    ThemeTag = { TextColor3 = "Text" }
                })
            })

            local BoxHolder = Creator.New("Frame", {
                Size = UDim2.new(0.5, 0, 0, 24),
                Position = UDim2.new(1, -10, 0.5, 0),
                AnchorPoint = Vector2.new(1, 0.5),
                Parent = card,
                ThemeTag = { BackgroundColor3 = "TitleBar" }
            }, {
                Creator.New("UICorner", { CornerRadius = UDim.new(0, 4) }),
                Creator.New("UIStroke", { Thickness = 1, ThemeTag = { Color = "CardBorder" } })
            })

            local TextBox = Creator.New("TextBox", {
                Size = UDim2.new(1, -12, 1, 0),
                Position = UDim2.new(0, 6, 0, 0),
                Text = default,
                PlaceholderText = placeholder,
                FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular),
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                ClearTextOnFocus = false,
                Parent = BoxHolder,
                ThemeTag = {
                    TextColor3 = "Text",
                    PlaceholderColor3 = "SubText"
                }
            })

            function Input:SetValue(text)
                if numeric and text ~= "" and not tonumber(text) then
                    TextBox.Text = Input.Value
                    return
                end
                Input.Value = text
                TextBox.Text = text
                Fluent:SafeCallback(callback, Input.Value)
            end

            if finished then
                Creator.AddSignal(TextBox.FocusLost, function()
                    Input:SetValue(TextBox.Text)
                end)
            else
                Creator.AddSignal(TextBox:GetPropertyChangedSignal("Text"), function()
                    Input:SetValue(TextBox.Text)
                end)
            end

            Fluent.Options[id] = Input
            return Input
        end

        function Tab:AddDropdown(id, dropdownConfig)
            local dTitle = dropdownConfig.Title or "Dropdown"
            local values = dropdownConfig.Values or {}
            local multi = dropdownConfig.Multi or false
            local allowNull = dropdownConfig.AllowNull or false
            local default = dropdownConfig.Default
            local callback = dropdownConfig.Callback or function() end

            local Dropdown = {
                Values = values,
                Value = multi and {} or nil,
                Multi = multi,
                Opened = false,
                Type = "Dropdown"
            }

            local card = Creator.New("TextButton", {
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundTransparency = 0.25,
                Text = "",
                Parent = PageScroll,
                ThemeTag = { BackgroundColor3 = "Card" }
            }, {
                Creator.New("UICorner", { CornerRadius = UDim.new(0, 6) }),
                Creator.New("UIStroke", { Thickness = 1, ThemeTag = { Color = "CardBorder" } }),
                Creator.New("TextLabel", {
                    Text = dTitle,
                    FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 10, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.4, 0, 1, 0),
                    ThemeTag = { TextColor3 = "Text" }
                })
            })

            local DisplayLabel = Creator.New("TextLabel", {
                Size = UDim2.new(0.5, -28, 1, 0),
                Position = UDim2.new(1, -26, 0.5, 0),
                AnchorPoint = Vector2.new(1, 0.5),
                Text = "--",
                TextTruncate = Enum.TextTruncate.AtEnd,
                FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular),
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Right,
                BackgroundTransparency = 1,
                Parent = card,
                ThemeTag = { TextColor3 = "SubText" }
            })

            local Arrow = Creator.New("ImageLabel", {
                Size = UDim2.fromOffset(12, 12),
                Position = UDim2.new(1, -18, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                Image = Fluent:GetIcon("chevron-down"),
                BackgroundTransparency = 1,
                Parent = card,
                ThemeTag = { ImageColor3 = "SubText" }
            })

            -- Floating Menu List
            local DropList = Creator.New("Frame", {
                Size = UDim2.fromOffset(180, 0),
                BackgroundTransparency = 0.05,
                Visible = false,
                ZIndex = 50,
                Parent = ScreenGui,
                ThemeTag = { BackgroundColor3 = "Card" }
            }, {
                Creator.New("UICorner", { CornerRadius = UDim.new(0, 6) }),
                Creator.New("UIStroke", { Thickness = 1.2, ThemeTag = { Color = "Accent" } })
            })

            local ListScroll = Creator.New("ScrollingFrame", {
                Size = UDim2.new(1, -4, 1, -8),
                Position = UDim2.new(0, 2, 0, 4),
                BackgroundTransparency = 1,
                ScrollBarThickness = 2,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                ZIndex = 51,
                Parent = DropList,
                ThemeTag = { ScrollBarImageColor3 = "Scrollbar" }
            }, {
                Creator.New("UIListLayout", { Padding = UDim.new(0, 2) })
            })

            local function UpdateText()
                if multi then
                    local selected = {}
                    for item, state in pairs(Dropdown.Value) do
                        if state then table.insert(selected, item) end
                    end
                    DisplayLabel.Text = #selected > 0 and table.concat(selected, ", ") or "None"
                else
                    DisplayLabel.Text = Dropdown.Value or "--"
                end
            end

            function Dropdown:BuildList()
                for _, ch in ipairs(ListScroll:GetChildren()) do
                    if ch:IsA("TextButton") then ch:Destroy() end
                end

                for _, val in ipairs(Dropdown.Values) do
                    local itemBtn = Creator.New("TextButton", {
                        Size = UDim2.new(1, 0, 0, 26),
                        BackgroundTransparency = 1,
                        Text = "  " .. tostring(val),
                        FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular),
                        TextSize = 11,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 52,
                        Parent = ListScroll,
                        ThemeTag = { TextColor3 = "Text" }
                    }, {
                        Creator.New("UICorner", { CornerRadius = UDim.new(0, 4) })
                    })

                    Creator.AddSignal(itemBtn.MouseButton1Click, function()
                        if multi then
                            Dropdown.Value[val] = not Dropdown.Value[val]
                            if not Dropdown.Value[val] and not allowNull then
                                -- Check count fix
                                local count = 0
                                for _, st in pairs(Dropdown.Value) do if st then count = count + 1 end end
                                if count == 0 then Dropdown.Value[val] = true end
                            end
                            itemBtn.TextColor3 = Dropdown.Value[val] and Creator.GetThemeProperty("Accent") or Creator.GetThemeProperty("Text")
                        else
                            Dropdown.Value = val
                            Dropdown:Close()
                        end
                        UpdateText()
                        Fluent:SafeCallback(callback, Dropdown.Value)
                    end)
                end

                local count = #Dropdown.Values
                local height = math.clamp(count * 28 + 10, 40, 160)
                DropList.Size = UDim2.fromOffset(180, height)
                ListScroll.CanvasSize = UDim2.new(0, 0, 0, count * 28)
            end

            function Dropdown:Open()
                Dropdown.Opened = true
                Dropdown:BuildList()
                local cardPos = card.AbsolutePosition
                DropList.Position = UDim2.fromOffset(cardPos.X + card.AbsoluteSize.X - 180, cardPos.Y + card.AbsoluteSize.Y + 4)
                DropList.Visible = true
                Creator.Tween(Arrow, TweenInfo.new(0.2), { Rotation = 180 })
            end

            function Dropdown:Close()
                Dropdown.Opened = false
                DropList.Visible = false
                Creator.Tween(Arrow, TweenInfo.new(0.2), { Rotation = 0 })
            end

            Creator.AddSignal(card.MouseButton1Click, function()
                if Dropdown.Opened then Dropdown:Close() else Dropdown:Open() end
            end)

            -- Outside Click Close
            Creator.AddSignal(UserInputService.InputBegan, function(input)
                if Dropdown.Opened and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                    local mousePos = UserInputService:GetMouseLocation()
                    local dPos, dSize = DropList.AbsolutePosition, DropList.AbsoluteSize
                    if mousePos.X < dPos.X or mousePos.X > dPos.X + dSize.X or mousePos.Y < dPos.Y or mousePos.Y > dPos.Y + dSize.Y then
                        local cPos, cSize = card.AbsolutePosition, card.AbsoluteSize
                        if mousePos.X < cPos.X or mousePos.X > cPos.X + cSize.X or mousePos.Y < cPos.Y or mousePos.Y > cPos.Y + cSize.Y then
                            Dropdown:Close()
                        end
                    end
                end
            end)

            if default then
                if multi and type(default) == "table" then
                    for _, v in ipairs(default) do Dropdown.Value[v] = true end
                else
                    Dropdown.Value = default
                end
                UpdateText()
            end

            Fluent.Options[id] = Dropdown
            return Dropdown
        end

        function Tab:AddKeybind(id, keybindConfig)
            local kTitle = keybindConfig.Title or "Keybind"
            local default = keybindConfig.Default or "None"
            local callback = keybindConfig.Callback or function() end
            local changedCallback = keybindConfig.ChangedCallback or function() end

            local Keybind = { Value = default, Type = "Keybind" }

            local card = Creator.New("Frame", {
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundTransparency = 0.25,
                Parent = PageScroll,
                ThemeTag = { BackgroundColor3 = "Card" }
            }, {
                Creator.New("UICorner", { CornerRadius = UDim.new(0, 6) }),
                Creator.New("UIStroke", { Thickness = 1, ThemeTag = { Color = "CardBorder" } }),
                Creator.New("TextLabel", {
                    Text = kTitle,
                    FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 10, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.6, 0, 1, 0),
                    ThemeTag = { TextColor3 = "Text" }
                })
            })

            local BindBtn = Creator.New("TextButton", {
                Size = UDim2.fromOffset(65, 22),
                Position = UDim2.new(1, -10, 0.5, 0),
                AnchorPoint = Vector2.new(1, 0.5),
                Text = default,
                FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold),
                TextSize = 10,
                Parent = card,
                ThemeTag = {
                    BackgroundColor3 = "TabBackground",
                    TextColor3 = "Accent"
                }
            }, {
                Creator.New("UICorner", { CornerRadius = UDim.new(0, 4) }),
                Creator.New("UIStroke", { Thickness = 1, ThemeTag = { Color = "CardBorder" } })
            })

            local isBinding = false
            Creator.AddSignal(BindBtn.MouseButton1Click, function()
                isBinding = true
                BindBtn.Text = "..."
            end)

            Creator.AddSignal(UserInputService.InputBegan, function(input, gameProcessed)
                if isBinding then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        local key = input.KeyCode.Name
                        Keybind.Value = key
                        BindBtn.Text = key
                        isBinding = false
                        Fluent:SafeCallback(changedCallback, input.KeyCode)
                    end
                elseif not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
                    if input.KeyCode.Name == Keybind.Value then
                        Fluent:SafeCallback(callback)
                    end
                end
            end)

            Fluent.Options[id] = Keybind
            return Keybind
        end

        function Tab:AddColorpicker(id, cpConfig)
            local cpTitle = cpConfig.Title or "Colorpicker"
            local default = cpConfig.Default or Color3.fromRGB(0, 162, 255)
            local callback = cpConfig.Callback or function() end

            local Colorpicker = { Value = default, Type = "Colorpicker" }

            local card = Creator.New("Frame", {
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundTransparency = 0.25,
                Parent = PageScroll,
                ThemeTag = { BackgroundColor3 = "Card" }
            }, {
                Creator.New("UICorner", { CornerRadius = UDim.new(0, 6) }),
                Creator.New("UIStroke", { Thickness = 1, ThemeTag = { Color = "CardBorder" } }),
                Creator.New("TextLabel", {
                    Text = cpTitle,
                    FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium),
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 10, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0.6, 0, 1, 0),
                    ThemeTag = { TextColor3 = "Text" }
                })
            })

            local ColorPreview = Creator.New("TextButton", {
                Size = UDim2.fromOffset(26, 18),
                Position = UDim2.new(1, -10, 0.5, 0),
                AnchorPoint = Vector2.new(1, 0.5),
                Text = "",
                BackgroundColor3 = default,
                Parent = card
            }, {
                Creator.New("UICorner", { CornerRadius = UDim.new(0, 4) }),
                Creator.New("UIStroke", { Thickness = 1, ThemeTag = { Color = "CardBorder" } })
            })

            function Colorpicker:SetValue(col)
                Colorpicker.Value = col
                ColorPreview.BackgroundColor3 = col
                Fluent:SafeCallback(callback, col)
            end

            Fluent.Options[id] = Colorpicker
            return Colorpicker
        end

        return Tab
    end

    -- Global Toggle Window Keybind
    Creator.AddSignal(UserInputService.InputBegan, function(input, gpe)
        if not gpe and input.KeyCode == Fluent.MinimizeKey then
            RootFrame.Visible = not RootFrame.Visible
        end
    end)

    Fluent.Window = Window
    return Window
end

return Fluent