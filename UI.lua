
-- ═══════════════════════════════════════════════════════════════
--  ETERNAL UI LIBRARY v2.0
--  Modern, Universal UI Library for Roblox Script Hubs
--  Author: Eternal Protection
--  Features: Dark theme, animations, tabs, toggles, sliders, dropdowns
-- ═══════════════════════════════════════════════════════════════

local EternalUI = {}
EternalUI.__index = EternalUI

-- ═══════════════════════════════════════════════════════════════
--  CONFIGURATION & THEME
-- ═══════════════════════════════════════════════════════════════

local Theme = {
    -- Colors
    Background = Color3.fromRGB(13, 13, 18),
    Surface = Color3.fromRGB(22, 22, 30),
    SurfaceHover = Color3.fromRGB(30, 30, 42),
    SurfaceActive = Color3.fromRGB(38, 38, 54),
    Border = Color3.fromRGB(40, 40, 58),
    BorderHover = Color3.fromRGB(65, 65, 95),
    Accent = Color3.fromRGB(147, 112, 219),
    AccentDark = Color3.fromRGB(120, 85, 190),
    AccentGlow = Color3.fromRGB(147, 112, 219),
    TextPrimary = Color3.fromRGB(240, 240, 245),
    TextSecondary = Color3.fromRGB(160, 160, 180),
    TextMuted = Color3.fromRGB(100, 100, 120),
    Success = Color3.fromRGB(80, 200, 120),
    Warning = Color3.fromRGB(240, 180, 60),
    Error = Color3.fromRGB(220, 80, 80),

    -- Gradients
    AccentGradient = {
        Color3.fromRGB(147, 112, 219),
        Color3.fromRGB(180, 130, 255),
        Color3.fromRGB(120, 80, 200)
    },

    -- Animation
    TweenSpeed = 0.25,
    TweenStyle = Enum.EasingStyle.Quart,
    TweenDir = Enum.EasingDirection.Out,
}

-- ═══════════════════════════════════════════════════════════════
--  UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

local function CreateTween(obj, props, duration, style, dir)
    local info = TweenInfo.new(
        duration or Theme.TweenSpeed,
        style or Theme.TweenStyle,
        dir or Theme.TweenDir
    )
    return TweenService:Create(obj, info, props)
end

local function CreateInstance(className, props)
    local obj = Instance.new(className)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
    return obj
end

local function AddCorner(obj, radius)
    local corner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, radius or 8),
        Parent = obj
    })
    return corner
end

local function AddStroke(obj, color, thickness)
    local stroke = CreateInstance("UIStroke", {
        Color = color or Theme.Border,
        Thickness = thickness or 1,
        Transparency = 0.5,
        Parent = obj
    })
    return stroke
end

local function AddShadow(obj, offset, blur)
    local shadow = CreateInstance("ImageLabel", {
        Name = "Shadow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, offset or 4),
        Size = UDim2.new(1, blur or 20, 1, blur or 20),
        Image = "rbxassetid://1316045217",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.6,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 118, 118),
        ZIndex = obj.ZIndex - 1,
        Parent = obj.Parent
    })
    return shadow
end

local function AddGradient(obj, colors, rotation)
    local gradient = CreateInstance("UIGradient", {
        Color = ColorSequence.new(colors or Theme.AccentGradient),
        Rotation = rotation or 45,
        Parent = obj
    })
    return gradient
end

-- ═══════════════════════════════════════════════════════════════
--  DRAG SYSTEM
-- ═══════════════════════════════════════════════════════════════

local function MakeDraggable(frame, handle)
    local dragging = false
    local dragStart = nil
    local startPos = nil

    handle = handle or frame

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                        input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════
--  MAIN WINDOW
-- ═══════════════════════════════════════════════════════════════

function EternalUI:CreateWindow(config)
    config = config or {}
    local title = config.Title or "Eternal Hub"
    local subtitle = config.SubTitle or "Universal"
    local size = config.Size or UDim2.new(0, 650, 0, 450)
    local pos = config.Position or UDim2.new(0.5, -325, 0.5, -225)

    -- ScreenGui
    local ScreenGui = CreateInstance("ScreenGui", {
        Name = "EternalUI_" .. tostring(math.random(100000, 999999)),
        Parent = CoreGui,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true
    })

    -- Main Frame
    local MainFrame = CreateInstance("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Position = pos,
        Size = size,
        ClipsDescendants = true,
        Active = true
    })
    AddCorner(MainFrame, 12)
    AddStroke(MainFrame, Theme.Border, 1)

    -- Shadow
    local Shadow = CreateInstance("ImageLabel", {
        Name = "Shadow",
        Parent = ScreenGui,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, pos.X.Offset - 15, 0, pos.Y.Offset - 15),
        Size = UDim2.new(0, size.X.Offset + 30, 0, size.Y.Offset + 30),
        Image = "rbxassetid://1316045217",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.7,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 118, 118),
        ZIndex = 0
    })

    -- Title Bar
    local TitleBar = CreateInstance("Frame", {
        Name = "TitleBar",
        Parent = MainFrame,
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 45)
    })
    AddCorner(TitleBar, 12)

    -- Title Bar Bottom Corner Fix
    local TitleBarFix = CreateInstance("Frame", {
        Name = "Fix",
        Parent = TitleBar,
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, -10),
        Size = UDim2.new(1, 0, 0, 12)
    })

    -- Accent Line
    local AccentLine = CreateInstance("Frame", {
        Name = "AccentLine",
        Parent = TitleBar,
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 20, 1, -2),
        Size = UDim2.new(0, 40, 0, 2)
    })
    AddCorner(AccentLine, 1)

    -- Logo/Icon
    local Logo = CreateInstance("ImageLabel", {
        Name = "Logo",
        Parent = TitleBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 10),
        Size = UDim2.new(0, 24, 0, 24),
        Image = "rbxassetid://7733964640",
        ImageColor3 = Theme.Accent
    })

    -- Title Text
    local TitleText = CreateInstance("TextLabel", {
        Name = "Title",
        Parent = TitleBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 48, 0, 0),
        Size = UDim2.new(0, 200, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = Theme.TextPrimary,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Subtitle
    local SubTitleText = CreateInstance("TextLabel", {
        Name = "SubTitle",
        Parent = TitleBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 48, 0, 22),
        Size = UDim2.new(0, 200, 0, 16),
        Font = Enum.Font.Gotham,
        Text = subtitle,
        TextColor3 = Theme.TextMuted,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Close Button
    local CloseBtn = CreateInstance("TextButton", {
        Name = "Close",
        Parent = TitleBar,
        BackgroundColor3 = Theme.Error,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -40, 0, 10),
        Size = UDim2.new(0, 26, 0, 26),
        Font = Enum.Font.GothamBold,
        Text = "X",
        TextColor3 = Theme.TextSecondary,
        TextSize = 14,
        AutoButtonColor = false
    })
    AddCorner(CloseBtn, 6)

    CloseBtn.MouseEnter:Connect(function()
        CreateTween(CloseBtn, {BackgroundTransparency = 0, TextColor3 = Theme.TextPrimary}):Play()
    end)

    CloseBtn.MouseLeave:Connect(function()
        CreateTween(CloseBtn, {BackgroundTransparency = 1, TextColor3 = Theme.TextSecondary}):Play()
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        CreateTween(MainFrame, {Size = UDim2.new(0, size.X.Offset, 0, 0)}):Play()
        wait(0.3)
        ScreenGui:Destroy()
    end)

    -- Minimize Button
    local MinBtn = CreateInstance("TextButton", {
        Name = "Minimize",
        Parent = TitleBar,
        BackgroundColor3 = Theme.Warning,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -72, 0, 10),
        Size = UDim2.new(0, 26, 0, 26),
        Font = Enum.Font.GothamBold,
        Text = "-",
        TextColor3 = Theme.TextSecondary,
        TextSize = 16,
        AutoButtonColor = false
    })
    AddCorner(MinBtn, 6)

    local minimized = false
    MinBtn.MouseEnter:Connect(function()
        CreateTween(MinBtn, {BackgroundTransparency = 0, TextColor3 = Theme.TextPrimary}):Play()
    end)

    MinBtn.MouseLeave:Connect(function()
        CreateTween(MinBtn, {BackgroundTransparency = 1, TextColor3 = Theme.TextSecondary}):Play()
    end)

    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            CreateTween(MainFrame, {Size = UDim2.new(0, size.X.Offset, 0, 45)}):Play()
            CreateTween(Shadow, {Size = UDim2.new(0, size.X.Offset + 30, 0, 75)}):Play()
        else
            CreateTween(MainFrame, {Size = size}):Play()
            CreateTween(Shadow, {Size = UDim2.new(0, size.X.Offset + 30, 0, size.Y.Offset + 30)}):Play()
        end
    end)

    -- Sidebar
    local Sidebar = CreateInstance("Frame", {
        Name = "Sidebar",
        Parent = MainFrame,
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 45),
        Size = UDim2.new(0, 160, 1, -45)
    })

    -- Sidebar Accent
    local SidebarAccent = CreateInstance("Frame", {
        Name = "Accent",
        Parent = Sidebar,
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -2, 0, 0),
        Size = UDim2.new(0, 2, 1, 0)
    })
    AddGradient(SidebarAccent, Theme.AccentGradient, 90)

    -- Tab Container
    local TabContainer = CreateInstance("ScrollingFrame", {
        Name = "TabContainer",
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 10),
        Size = UDim2.new(1, 0, 1, -20),
        ScrollBarThickness = 0,
        ScrollBarImageTransparency = 1,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    })

    local TabLayout = CreateInstance("UIListLayout", {
        Parent = TabContainer,
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    local TabPadding = CreateInstance("UIPadding", {
        Parent = TabContainer,
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        PaddingTop = UDim.new(0, 5)
    })

    -- Content Area
    local ContentArea = CreateInstance("Frame", {
        Name = "Content",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 170, 0, 55),
        Size = UDim2.new(1, -180, 1, -65),
        ClipsDescendants = true
    })

    -- Content Container (for pages)
    local Pages = CreateInstance("Frame", {
        Name = "Pages",
        Parent = ContentArea,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0)
    })

    -- Search Bar (optional)
    local SearchBar = CreateInstance("Frame", {
        Name = "SearchBar",
        Parent = ContentArea,
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, -40),
        Size = UDim2.new(1, 0, 0, 32),
        Visible = false
    })
    AddCorner(SearchBar, 6)
    AddStroke(SearchBar, Theme.Border, 1)

    local SearchIcon = CreateInstance("ImageLabel", {
        Name = "Icon",
        Parent = SearchBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 6),
        Size = UDim2.new(0, 20, 0, 20),
        Image = "rbxassetid://7733749837",
        ImageColor3 = Theme.TextMuted
    })

    local SearchInput = CreateInstance("TextBox", {
        Name = "Input",
        Parent = SearchBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 36, 0, 0),
        Size = UDim2.new(1, -46, 1, 0),
        Font = Enum.Font.Gotham,
        Text = "",
        PlaceholderText = "Search features...",
        TextColor3 = Theme.TextPrimary,
        PlaceholderColor3 = Theme.TextMuted,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false
    })

    -- Make draggable
    MakeDraggable(MainFrame, TitleBar)

    -- Window object
    local Window = {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        Shadow = Shadow,
        TabContainer = TabContainer,
        Pages = Pages,
        Tabs = {},
        ActiveTab = nil,
        Elements = {},
        Theme = Theme,
        Config = config
    }

    setmetatable(Window, EternalUI)

    -- Intro animation
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    Shadow.Size = UDim2.new(0, 0, 0, 0)
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)

    CreateTween(MainFrame, {Size = size, Position = pos}, 0.5):Play()
    CreateTween(Shadow, {Size = UDim2.new(0, size.X.Offset + 30, 0, size.Y.Offset + 30), 
        Position = UDim2.new(0, pos.X.Offset - 15, 0, pos.Y.Offset - 15)}, 0.5):Play()

    return Window
end

-- ═══════════════════════════════════════════════════════════════
--  TAB SYSTEM
-- ═══════════════════════════════════════════════════════════════

function EternalUI:AddTab(config)
    config = config or {}
    local name = config.Name or "Tab"
    local icon = config.Icon or "rbxassetid://7733964640"

    local TabBtn = CreateInstance("TextButton", {
        Name = name .. "_Tab",
        Parent = self.TabContainer,
        BackgroundColor3 = Theme.Surface,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 36),
        Font = Enum.Font.GothamSemibold,
        Text = "",
        TextColor3 = Theme.TextSecondary,
        TextSize = 13,
        AutoButtonColor = false,
        LayoutOrder = #self.Tabs + 1
    })
    AddCorner(TabBtn, 8)

    local TabIcon = CreateInstance("ImageLabel", {
        Name = "Icon",
        Parent = TabBtn,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0.5, -9),
        Size = UDim2.new(0, 18, 0, 18),
        Image = icon,
        ImageColor3 = Theme.TextMuted
    })

    local TabLabel = CreateInstance("TextLabel", {
        Name = "Label",
        Parent = TabBtn,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 38, 0, 0),
        Size = UDim2.new(1, -48, 1, 0),
        Font = Enum.Font.GothamSemibold,
        Text = name,
        TextColor3 = Theme.TextSecondary,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local TabIndicator = CreateInstance("Frame", {
        Name = "Indicator",
        Parent = TabBtn,
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 6),
        Size = UDim2.new(0, 3, 1, -12),
        BackgroundTransparency = 1
    })
    AddCorner(TabIndicator, 1)
    AddGradient(TabIndicator, Theme.AccentGradient, 180)

    -- Page
    local Page = CreateInstance("ScrollingFrame", {
        Name = name .. "_Page",
        Parent = self.Pages,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false
    })

    local PageLayout = CreateInstance("UIListLayout", {
        Parent = Page,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    local PagePadding = CreateInstance("UIPadding", {
        Parent = Page,
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 10),
        PaddingTop = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 20)
    })

    -- Tab logic
    local Tab = {
        Button = TabBtn,
        Page = Page,
        Name = name,
        Elements = {},
        Active = false
    }

    table.insert(self.Tabs, Tab)

    TabBtn.MouseEnter:Connect(function()
        if not Tab.Active then
            CreateTween(TabBtn, {BackgroundTransparency = 0.8}):Play()
        end
    end)

    TabBtn.MouseLeave:Connect(function()
        if not Tab.Active then
            CreateTween(TabBtn, {BackgroundTransparency = 1}):Play()
        end
    end)

    TabBtn.MouseButton1Click:Connect(function()
        self:SelectTab(Tab)
    end)

    -- Auto-select first tab
    if #self.Tabs == 1 then
        self:SelectTab(Tab)
    end

    return Tab
end

function EternalUI:SelectTab(tab)
    for _, t in ipairs(self.Tabs) do
        t.Active = false
        CreateTween(t.Button, {BackgroundTransparency = 1}):Play()
        CreateTween(t.Button.Indicator, {BackgroundTransparency = 1}):Play()
        CreateTween(t.Button.Icon, {ImageColor3 = Theme.TextMuted}):Play()
        CreateTween(t.Button.Label, {TextColor3 = Theme.TextSecondary}):Play()
        t.Page.Visible = false
    end

    tab.Active = true
    CreateTween(tab.Button, {BackgroundTransparency = 0.6}):Play()
    CreateTween(tab.Button.Indicator, {BackgroundTransparency = 0}):Play()
    CreateTween(tab.Button.Icon, {ImageColor3 = Theme.Accent}):Play()
    CreateTween(tab.Button.Label, {TextColor3 = Theme.TextPrimary}):Play()

    tab.Page.Visible = true
    tab.Page.CanvasPosition = Vector2.new(0, 0)

    self.ActiveTab = tab
end

-- ═══════════════════════════════════════════════════════════════
--  SECTION
-- ═══════════════════════════════════════════════════════════════

function EternalUI:AddSection(tab, config)
    config = config or {}
    local name = config.Name or "Section"

    local SectionFrame = CreateInstance("Frame", {
        Name = name .. "_Section",
        Parent = tab.Page,
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 40),
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = #tab.Elements + 1
    })
    AddCorner(SectionFrame, 10)
    AddStroke(SectionFrame, Theme.Border, 1)

    local SectionTitle = CreateInstance("TextLabel", {
        Name = "Title",
        Parent = SectionFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 10),
        Size = UDim2.new(1, -30, 0, 20),
        Font = Enum.Font.GothamBold,
        Text = name,
        TextColor3 = Theme.TextPrimary,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local SectionAccent = CreateInstance("Frame", {
        Name = "Accent",
        Parent = SectionFrame,
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 15, 0, 32),
        Size = UDim2.new(0, 30, 0, 2)
    })
    AddCorner(SectionAccent, 1)
    AddGradient(SectionAccent, Theme.AccentGradient, 0)

    local ContentFrame = CreateInstance("Frame", {
        Name = "Content",
        Parent = SectionFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 45),
        Size = UDim2.new(1, -20, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y
    })

    local ContentLayout = CreateInstance("UIListLayout", {
        Parent = ContentFrame,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    local ContentPadding = CreateInstance("UIPadding", {
        Parent = ContentFrame,
        PaddingBottom = UDim.new(0, 10)
    })

    -- Update section size
    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        SectionFrame.Size = UDim2.new(1, 0, 0, 55 + ContentLayout.AbsoluteContentSize.Y)
    end)

    table.insert(tab.Elements, SectionFrame)

    return ContentFrame
end

-- ═══════════════════════════════════════════════════════════════
--  BUTTON
-- ═══════════════════════════════════════════════════════════════

function EternalUI:AddButton(parent, config)
    config = config or {}
    local text = config.Text or "Button"
    local callback = config.Callback or function() end
    local icon = config.Icon

    local Btn = CreateInstance("TextButton", {
        Name = text .. "_Btn",
        Parent = parent,
        BackgroundColor3 = Theme.SurfaceHover,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 36),
        Font = Enum.Font.GothamSemibold,
        Text = "",
        TextColor3 = Theme.TextPrimary,
        TextSize = 13,
        AutoButtonColor = false,
        LayoutOrder = #parent:GetChildren()
    })
    AddCorner(Btn, 8)
    AddStroke(Btn, Theme.Border, 1)

    local BtnGradient = CreateInstance("Frame", {
        Name = "Gradient",
        Parent = Btn,
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundTransparency = 0.9,
        ZIndex = 0
    })
    AddCorner(BtnGradient, 8)

    local BtnText = CreateInstance("TextLabel", {
        Name = "Text",
        Parent = Btn,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, icon and 40 or 15, 0, 0),
        Size = UDim2.new(1, icon and -55 or -30, 1, 0),
        Font = Enum.Font.GothamSemibold,
        Text = text,
        TextColor3 = Theme.TextPrimary,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    if icon then
        local BtnIcon = CreateInstance("ImageLabel", {
            Name = "Icon",
            Parent = Btn,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0.5, -9),
            Size = UDim2.new(0, 18, 0, 18),
            Image = icon,
            ImageColor3 = Theme.Accent
        })
    end

    local Arrow = CreateInstance("ImageLabel", {
        Name = "Arrow",
        Parent = Btn,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -28, 0.5, -8),
        Size = UDim2.new(0, 16, 0, 16),
        Image = "rbxassetid://7733717447",
        ImageColor3 = Theme.TextMuted,
        Rotation = -90
    })

    Btn.MouseEnter:Connect(function()
        CreateTween(Btn, {BackgroundColor3 = Theme.SurfaceActive}):Play()
        CreateTween(BtnGradient, {Size = UDim2.new(0, 4, 1, 0)}):Play()
        CreateTween(Arrow, {ImageColor3 = Theme.Accent}):Play()
        CreateTween(BtnStroke or AddStroke(Btn, Theme.BorderHover, 1), {Color = Theme.BorderHover}):Play()
    end)

    Btn.MouseLeave:Connect(function()
        CreateTween(Btn, {BackgroundColor3 = Theme.SurfaceHover}):Play()
        CreateTween(BtnGradient, {Size = UDim2.new(0, 0, 1, 0)}):Play()
        CreateTween(Arrow, {ImageColor3 = Theme.TextMuted}):Play()
    end)

    Btn.MouseButton1Down:Connect(function()
        CreateTween(Btn, {BackgroundColor3 = Theme.Surface}):Play()
    end)

    Btn.MouseButton1Up:Connect(function()
        CreateTween(Btn, {BackgroundColor3 = Theme.SurfaceActive}):Play()
    end)

    Btn.MouseButton1Click:Connect(function()
        callback()
    end)

    return Btn
end

-- ═══════════════════════════════════════════════════════════════
--  TOGGLE
-- ═══════════════════════════════════════════════════════════════

function EternalUI:AddToggle(parent, config)
    config = config or {}
    local text = config.Text or "Toggle"
    local default = config.Default or false
    local callback = config.Callback or function() end

    local ToggleFrame = CreateInstance("Frame", {
        Name = text .. "_Toggle",
        Parent = parent,
        BackgroundColor3 = Theme.SurfaceHover,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 36),
        LayoutOrder = #parent:GetChildren()
    })
    AddCorner(ToggleFrame, 8)
    AddStroke(ToggleFrame, Theme.Border, 1)

    local ToggleText = CreateInstance("TextLabel", {
        Name = "Text",
        Parent = ToggleFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(1, -80, 1, 0),
        Font = Enum.Font.Gotham,
        Text = text,
        TextColor3 = Theme.TextPrimary,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local ToggleBtn = CreateInstance("TextButton", {
        Name = "ToggleBtn",
        Parent = ToggleFrame,
        BackgroundColor3 = Theme.SurfaceActive,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -52, 0.5, -11),
        Size = UDim2.new(0, 44, 0, 22),
        Text = "",
        AutoButtonColor = false
    })
    AddCorner(ToggleBtn, 11)
    AddStroke(ToggleBtn, Theme.Border, 1)

    local ToggleCircle = CreateInstance("Frame", {
        Name = "Circle",
        Parent = ToggleBtn,
        BackgroundColor3 = Theme.TextSecondary,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 3, 0.5, -8),
        Size = UDim2.new(0, 16, 0, 16)
    })
    AddCorner(ToggleCircle, 8)

    local state = default

    local function UpdateToggle()
        if state then
            CreateTween(ToggleBtn, {BackgroundColor3 = Theme.Accent}):Play()
            CreateTween(ToggleCircle, {Position = UDim2.new(0, 25, 0.5, -8), BackgroundColor3 = Theme.TextPrimary}):Play()
            CreateTween(ToggleText, {TextColor3 = Theme.TextPrimary}):Play()
        else
            CreateTween(ToggleBtn, {BackgroundColor3 = Theme.SurfaceActive}):Play()
            CreateTween(ToggleCircle, {Position = UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = Theme.TextSecondary}):Play()
            CreateTween(ToggleText, {TextColor3 = Theme.TextSecondary}):Play()
        end
        callback(state)
    end

    ToggleBtn.MouseButton1Click:Connect(function()
        state = not state
        UpdateToggle()
    end)

    ToggleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            state = not state
            UpdateToggle()
        end
    end)

    -- Initialize
    if default then
        ToggleBtn.BackgroundColor3 = Theme.Accent
        ToggleCircle.Position = UDim2.new(0, 25, 0.5, -8)
        ToggleCircle.BackgroundColor3 = Theme.TextPrimary
    end

    return {
        Frame = ToggleFrame,
        GetState = function() return state end,
        SetState = function(newState)
            state = newState
            UpdateToggle()
        end
    }
end

-- ═══════════════════════════════════════════════════════════════
--  SLIDER
-- ═══════════════════════════════════════════════════════════════

function EternalUI:AddSlider(parent, config)
    config = config or {}
    local text = config.Text or "Slider"
    local min = config.Min or 0
    local max = config.Max or 100
    local default = config.Default or min
    local decimals = config.Decimals or 0
    local callback = config.Callback or function() end
    local suffix = config.Suffix or ""

    local SliderFrame = CreateInstance("Frame", {
        Name = text .. "_Slider",
        Parent = parent,
        BackgroundColor3 = Theme.SurfaceHover,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 56),
        LayoutOrder = #parent:GetChildren()
    })
    AddCorner(SliderFrame, 8)
    AddStroke(SliderFrame, Theme.Border, 1)

    local SliderText = CreateInstance("TextLabel", {
        Name = "Text",
        Parent = SliderFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 8),
        Size = UDim2.new(0.7, 0, 0, 18),
        Font = Enum.Font.Gotham,
        Text = text,
        TextColor3 = Theme.TextPrimary,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local ValueText = CreateInstance("TextLabel", {
        Name = "Value",
        Parent = SliderFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -70, 0, 8),
        Size = UDim2.new(0, 60, 0, 18),
        Font = Enum.Font.GothamBold,
        Text = tostring(default) .. suffix,
        TextColor3 = Theme.Accent,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Right
    })

    local Track = CreateInstance("Frame", {
        Name = "Track",
        Parent = SliderFrame,
        BackgroundColor3 = Theme.SurfaceActive,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 15, 0, 36),
        Size = UDim2.new(1, -30, 0, 6)
    })
    AddCorner(Track, 3)

    local Fill = CreateInstance("Frame", {
        Name = "Fill",
        Parent = Track,
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    })
    AddCorner(Fill, 3)
    AddGradient(Fill, Theme.AccentGradient, 0)

    local Knob = CreateInstance("Frame", {
        Name = "Knob",
        Parent = Track,
        BackgroundColor3 = Theme.TextPrimary,
        BorderSizePixel = 0,
        Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7),
        Size = UDim2.new(0, 14, 0, 14),
        ZIndex = 2
    })
    AddCorner(Knob, 7)

    local KnobGlow = CreateInstance("Frame", {
        Name = "Glow",
        Parent = Knob,
        BackgroundColor3 = Theme.Accent,
        BackgroundTransparency = 0.8,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -12, 0.5, -12),
        Size = UDim2.new(0, 24, 0, 24),
        ZIndex = 1
    })
    AddCorner(KnobGlow, 12)

    local value = default
    local dragging = false

    local function UpdateSlider(input)
        local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        value = min + (max - min) * pos
        if decimals == 0 then
            value = math.floor(value)
        else
            value = math.floor(value * (10 ^ decimals)) / (10 ^ decimals)
        end

        Fill.Size = UDim2.new(pos, 0, 1, 0)
        Knob.Position = UDim2.new(pos, -7, 0.5, -7)
        ValueText.Text = tostring(value) .. suffix
        callback(value)
    end

    Track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            UpdateSlider(input)
        end
    end)

    Knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            CreateTween(KnobGlow, {Size = UDim2.new(0, 32, 0, 32), Position = UDim2.new(0.5, -16, 0.5, -16)}):Play()
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                        input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            CreateTween(KnobGlow, {Size = UDim2.new(0, 24, 0, 24), Position = UDim2.new(0.5, -12, 0.5, -12)}):Play()
        end
    end)

    return {
        Frame = SliderFrame,
        GetValue = function() return value end,
        SetValue = function(newValue)
            value = math.clamp(newValue, min, max)
            local pos = (value - min) / (max - min)
            Fill.Size = UDim2.new(pos, 0, 1, 0)
            Knob.Position = UDim2.new(pos, -7, 0.5, -7)
            ValueText.Text = tostring(value) .. suffix
            callback(value)
        end
    }
end

-- ═══════════════════════════════════════════════════════════════
--  DROPDOWN
-- ═══════════════════════════════════════════════════════════════

function EternalUI:AddDropdown(parent, config)
    config = config or {}
    local text = config.Text or "Dropdown"
    local options = config.Options or {}
    local default = config.Default or options[1] or "Select..."
    local callback = config.Callback or function() end

    local DropdownFrame = CreateInstance("Frame", {
        Name = text .. "_Dropdown",
        Parent = parent,
        BackgroundColor3 = Theme.SurfaceHover,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 36),
        ClipsDescendants = true,
        LayoutOrder = #parent:GetChildren()
    })
    AddCorner(DropdownFrame, 8)
    AddStroke(DropdownFrame, Theme.Border, 1)

    local DropdownBtn = CreateInstance("TextButton", {
        Name = "Btn",
        Parent = DropdownFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 36),
        Font = Enum.Font.Gotham,
        Text = "",
        AutoButtonColor = false
    })

    local DropdownText = CreateInstance("TextLabel", {
        Name = "Text",
        Parent = DropdownBtn,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(1, -50, 1, 0),
        Font = Enum.Font.Gotham,
        Text = text .. ": " .. default,
        TextColor3 = Theme.TextPrimary,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local Arrow = CreateInstance("ImageLabel", {
        Name = "Arrow",
        Parent = DropdownBtn,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -28, 0.5, -8),
        Size = UDim2.new(0, 16, 0, 16),
        Image = "rbxassetid://7733717447",
        ImageColor3 = Theme.TextMuted
    })

    local OptionsFrame = CreateInstance("Frame", {
        Name = "Options",
        Parent = DropdownFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 40),
        Size = UDim2.new(1, -20, 0, 0),
        ClipsDescendants = true
    })

    local OptionsLayout = CreateInstance("UIListLayout", {
        Parent = OptionsFrame,
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    local selected = default
    local open = false

    local function CreateOption(optionText)
        local OptionBtn = CreateInstance("TextButton", {
            Name = optionText,
            Parent = OptionsFrame,
            BackgroundColor3 = Theme.SurfaceActive,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 30),
            Font = Enum.Font.Gotham,
            Text = optionText,
            TextColor3 = Theme.TextSecondary,
            TextSize = 12,
            AutoButtonColor = false,
            LayoutOrder = #OptionsFrame:GetChildren()
        })
        AddCorner(OptionBtn, 6)

        OptionBtn.MouseEnter:Connect(function()
            CreateTween(OptionBtn, {BackgroundColor3 = Theme.SurfaceHover, TextColor3 = Theme.TextPrimary}):Play()
        end)

        OptionBtn.MouseLeave:Connect(function()
            CreateTween(OptionBtn, {BackgroundColor3 = Theme.SurfaceActive, TextColor3 = Theme.TextSecondary}):Play()
        end)

        OptionBtn.MouseButton1Click:Connect(function()
            selected = optionText
            DropdownText.Text = text .. ": " .. selected
            callback(selected)

            open = false
            CreateTween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 36)}):Play()
            CreateTween(Arrow, {Rotation = 0}):Play()
        end)

        return OptionBtn
    end

    for _, opt in ipairs(options) do
        CreateOption(opt)
    end

    DropdownBtn.MouseButton1Click:Connect(function()
        open = not open
        if open then
            local optsHeight = math.min(#options * 34, 170)
            CreateTween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 46 + optsHeight)}):Play()
            CreateTween(Arrow, {Rotation = 180}):Play()
        else
            CreateTween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 36)}):Play()
            CreateTween(Arrow, {Rotation = 0}):Play()
        end
    end)

    return {
        Frame = DropdownFrame,
        GetSelected = function() return selected end,
        SetSelected = function(newSel)
            selected = newSel
            DropdownText.Text = text .. ": " .. selected
            callback(selected)
        end,
        RefreshOptions = function(newOptions)
            for _, child in ipairs(OptionsFrame:GetChildren()) do
                if child:IsA("TextButton") then child:Destroy() end
            end
            for _, opt in ipairs(newOptions) do
                CreateOption(opt)
            end
        end
    }
end

-- ═══════════════════════════════════════════════════════════════
--  TEXTBOX / INPUT
-- ═══════════════════════════════════════════════════════════════

function EternalUI:AddTextbox(parent, config)
    config = config or {}
    local text = config.Text or "Input"
    local placeholder = config.Placeholder or "Enter text..."
    local default = config.Default or ""
    local callback = config.Callback or function() end

    local TextboxFrame = CreateInstance("Frame", {
        Name = text .. "_Textbox",
        Parent = parent,
        BackgroundColor3 = Theme.SurfaceHover,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 36),
        LayoutOrder = #parent:GetChildren()
    })
    AddCorner(TextboxFrame, 8)
    AddStroke(TextboxFrame, Theme.Border, 1)

    local TextboxLabel = CreateInstance("TextLabel", {
        Name = "Label",
        Parent = TextboxFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(0.4, 0, 1, 0),
        Font = Enum.Font.Gotham,
        Text = text,
        TextColor3 = Theme.TextPrimary,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local InputFrame = CreateInstance("Frame", {
        Name = "InputFrame",
        Parent = TextboxFrame,
        BackgroundColor3 = Theme.SurfaceActive,
        BorderSizePixel = 0,
        Position = UDim2.new(0.42, 0, 0.5, -12),
        Size = UDim2.new(0.56, -15, 0, 24)
    })
    AddCorner(InputFrame, 6)
    AddStroke(InputFrame, Theme.Border, 1)

    local TextInput = CreateInstance("TextBox", {
        Name = "Input",
        Parent = InputFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 8, 0, 0),
        Size = UDim2.new(1, -16, 1, 0),
        Font = Enum.Font.Gotham,
        Text = default,
        PlaceholderText = placeholder,
        TextColor3 = Theme.TextPrimary,
        PlaceholderColor3 = Theme.TextMuted,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false
    })

    TextInput.Focused:Connect(function()
        CreateTween(InputFrame, {BackgroundColor3 = Theme.Surface, BorderColor3 = Theme.Accent}):Play()
    end)

    TextInput.FocusLost:Connect(function()
        CreateTween(InputFrame, {BackgroundColor3 = Theme.SurfaceActive}):Play()
        callback(TextInput.Text)
    end)

    return {
        Frame = TextboxFrame,
        GetText = function() return TextInput.Text end,
        SetText = function(newText)
            TextInput.Text = newText
            callback(newText)
        end
    }
end

-- ═══════════════════════════════════════════════════════════════
--  LABEL / INFO
-- ═══════════════════════════════════════════════════════════════

function EternalUI:AddLabel(parent, config)
    config = config or {}
    local text = config.Text or "Label"
    local color = config.Color or Theme.TextSecondary

    local Label = CreateInstance("TextLabel", {
        Name = text .. "_Label",
        Parent = parent,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20),
        Font = Enum.Font.Gotham,
        Text = text,
        TextColor3 = color,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        LayoutOrder = #parent:GetChildren()
    })

    return Label
end

-- ═══════════════════════════════════════════════════════════════
--  KEYBIND
-- ═══════════════════════════════════════════════════════════════

function EternalUI:AddKeybind(parent, config)
    config = config or {}
    local text = config.Text or "Keybind"
    local default = config.Default or "None"
    local callback = config.Callback or function() end

    local KeybindFrame = CreateInstance("Frame", {
        Name = text .. "_Keybind",
        Parent = parent,
        BackgroundColor3 = Theme.SurfaceHover,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 36),
        LayoutOrder = #parent:GetChildren()
    })
    AddCorner(KeybindFrame, 8)
    AddStroke(KeybindFrame, Theme.Border, 1)

    local KeybindText = CreateInstance("TextLabel", {
        Name = "Text",
        Parent = KeybindFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(0.6, 0, 1, 0),
        Font = Enum.Font.Gotham,
        Text = text,
        TextColor3 = Theme.TextPrimary,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local KeybindBtn = CreateInstance("TextButton", {
        Name = "KeyBtn",
        Parent = KeybindFrame,
        BackgroundColor3 = Theme.SurfaceActive,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -80, 0.5, -12),
        Size = UDim2.new(0, 70, 0, 24),
        Font = Enum.Font.GothamBold,
        Text = default,
        TextColor3 = Theme.Accent,
        TextSize = 11,
        AutoButtonColor = false
    })
    AddCorner(KeybindBtn, 6)
    AddStroke(KeybindBtn, Theme.Border, 1)

    local listening = false
    local currentKey = default

    KeybindBtn.MouseButton1Click:Connect(function()
        listening = true
        KeybindBtn.Text = "..."
        CreateTween(KeybindBtn, {BackgroundColor3 = Theme.Accent, TextColor3 = Theme.TextPrimary}):Play()
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if listening and not gameProcessed then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                currentKey = input.KeyCode.Name
                KeybindBtn.Text = currentKey
                listening = false
                CreateTween(KeybindBtn, {BackgroundColor3 = Theme.SurfaceActive, TextColor3 = Theme.Accent}):Play()
                callback(currentKey)
            end
        elseif not gameProcessed and input.KeyCode.Name == currentKey then
            callback(currentKey)
        end
    end)

    return {
        Frame = KeybindFrame,
        GetKey = function() return currentKey end,
        SetKey = function(key)
            currentKey = key
            KeybindBtn.Text = key
        end
    }
end

-- ═══════════════════════════════════════════════════════════════
--  COLOR PICKER
-- ═══════════════════════════════════════════════════════════════

function EternalUI:AddColorPicker(parent, config)
    config = config or {}
    local text = config.Text or "Color"
    local default = config.Default or Color3.fromRGB(147, 112, 219)
    local callback = config.Callback or function() end

    local ColorFrame = CreateInstance("Frame", {
        Name = text .. "_Color",
        Parent = parent,
        BackgroundColor3 = Theme.SurfaceHover,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 36),
        LayoutOrder = #parent:GetChildren()
    })
    AddCorner(ColorFrame, 8)
    AddStroke(ColorFrame, Theme.Border, 1)

    local ColorText = CreateInstance("TextLabel", {
        Name = "Text",
        Parent = ColorFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(0.7, 0, 1, 0),
        Font = Enum.Font.Gotham,
        Text = text,
        TextColor3 = Theme.TextPrimary,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local ColorPreview = CreateInstance("TextButton", {
        Name = "Preview",
        Parent = ColorFrame,
        BackgroundColor3 = default,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -42, 0.5, -12),
        Size = UDim2.new(0, 24, 0, 24),
        Text = "",
        AutoButtonColor = false
    })
    AddCorner(ColorPreview, 6)
    AddStroke(ColorPreview, Theme.Border, 1)

    local currentColor = default

    ColorPreview.MouseButton1Click:Connect(function()
        -- Simple color cycle for demo (full picker would be much larger)
        local colors = {
            Color3.fromRGB(147, 112, 219),
            Color3.fromRGB(255, 100, 100),
            Color3.fromRGB(100, 255, 100),
            Color3.fromRGB(100, 100, 255),
            Color3.fromRGB(255, 255, 100),
            Color3.fromRGB(255, 100, 255),
            Color3.fromRGB(100, 255, 255),
            Color3.fromRGB(255, 255, 255)
        }
        local idx = 1
        for i, c in ipairs(colors) do
            if c == currentColor then idx = i + 1 break end
        end
        if idx > #colors then idx = 1 end
        currentColor = colors[idx]
        CreateTween(ColorPreview, {BackgroundColor3 = currentColor}):Play()
        callback(currentColor)
    end)

    return {
        Frame = ColorFrame,
        GetColor = function() return currentColor end,
        SetColor = function(color)
            currentColor = color
            ColorPreview.BackgroundColor3 = color
            callback(color)
        end
    }
end

-- ═══════════════════════════════════════════════════════════════
--  NOTIFICATION SYSTEM
-- ═══════════════════════════════════════════════════════════════

function EternalUI:Notify(config)
    config = config or {}
    local title = config.Title or "Notification"
    local text = config.Text or ""
    local duration = config.Duration or 3
    local type_ = config.Type or "Info" -- Info, Success, Warning, Error

    local colors = {
        Info = Theme.Accent,
        Success = Theme.Success,
        Warning = Theme.Warning,
        Error = Theme.Error
    }
    local color = colors[type_] or Theme.Accent

    local NotifGui = CreateInstance("ScreenGui", {
        Name = "EternalNotify",
        Parent = CoreGui,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    local NotifFrame = CreateInstance("Frame", {
        Name = "Notif",
        Parent = NotifGui,
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
        Position = UDim2.new(1, 20, 0.85, 0),
        Size = UDim2.new(0, 280, 0, 70),
        AnchorPoint = Vector2.new(1, 0.5)
    })
    AddCorner(NotifFrame, 10)
    AddStroke(NotifFrame, Theme.Border, 1)

    local AccentBar = CreateInstance("Frame", {
        Name = "Accent",
        Parent = NotifFrame,
        BackgroundColor3 = color,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 4, 1, 0)
    })
    AddCorner(AccentBar, 2)

    local NotifTitle = CreateInstance("TextLabel", {
        Name = "Title",
        Parent = NotifFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 18, 0, 10),
        Size = UDim2.new(1, -36, 0, 18),
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = Theme.TextPrimary,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local NotifText = CreateInstance("TextLabel", {
        Name = "Text",
        Parent = NotifFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 18, 0, 30),
        Size = UDim2.new(1, -36, 0, 30),
        Font = Enum.Font.Gotham,
        Text = text,
        TextColor3 = Theme.TextSecondary,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true
    })

    local CloseNotif = CreateInstance("TextButton", {
        Name = "Close",
        Parent = NotifFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -28, 0, 8),
        Size = UDim2.new(0, 20, 0, 20),
        Font = Enum.Font.GothamBold,
        Text = "X",
        TextColor3 = Theme.TextMuted,
        TextSize = 12
    })

    -- Animate in
    CreateTween(NotifFrame, {Position = UDim2.new(1, -20, 0.85, 0)}, 0.4):Play()

    local function Close()
        CreateTween(NotifFrame, {Position = UDim2.new(1, 20, 0.85, 0)}, 0.3):Play()
        wait(0.35)
        NotifGui:Destroy()
    end

    CloseNotif.MouseButton1Click:Connect(Close)

    if duration > 0 then
        delay(duration, Close)
    end

    return {Close = Close}
end

-- ═══════════════════════════════════════════════════════════════
--  LOADING SCREEN
-- ═══════════════════════════════════════════════════════════════

function EternalUI:ShowLoading(text)
    local LoadingGui = CreateInstance("ScreenGui", {
        Name = "EternalLoading",
        Parent = CoreGui,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    local Backdrop = CreateInstance("Frame", {
        Name = "Backdrop",
        Parent = LoadingGui,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0)
    })

    local LoadingFrame = CreateInstance("Frame", {
        Name = "Frame",
        Parent = Backdrop,
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -100, 0.5, -40),
        Size = UDim2.new(0, 200, 0, 80),
        AnchorPoint = Vector2.new(0.5, 0.5)
    })
    AddCorner(LoadingFrame, 12)
    AddStroke(LoadingFrame, Theme.Border, 1)

    local LoadingText = CreateInstance("TextLabel", {
        Name = "Text",
        Parent = LoadingFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 15),
        Size = UDim2.new(1, 0, 0, 20),
        Font = Enum.Font.GothamBold,
        Text = text or "Loading...",
        TextColor3 = Theme.TextPrimary,
        TextSize = 14
    })

    local ProgressBar = CreateInstance("Frame", {
        Name = "Progress",
        Parent = LoadingFrame,
        BackgroundColor3 = Theme.SurfaceActive,
        BorderSizePixel = 0,
        Position = UDim2.new(0.1, 0, 0, 50),
        Size = UDim2.new(0.8, 0, 0, 6)
    })
    AddCorner(ProgressBar, 3)

    local ProgressFill = CreateInstance("Frame", {
        Name = "Fill",
        Parent = ProgressBar,
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 0, 1, 0)
    })
    AddCorner(ProgressFill, 3)
    AddGradient(ProgressFill, Theme.AccentGradient, 0)

    return {
        Gui = LoadingGui,
        SetProgress = function(percent)
            CreateTween(ProgressFill, {Size = UDim2.new(percent / 100, 0, 1, 0)}, 0.3):Play()
        end,
        Close = function()
            CreateTween(Backdrop, {BackgroundTransparency = 1}, 0.3):Play()
            CreateTween(LoadingFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3):Play()
            wait(0.35)
            LoadingGui:Destroy()
        end
    }
end

-- ═══════════════════════════════════════════════════════════════
--  NOTIFICATION SHORTCUTS
-- ═══════════════════════════════════════════════════════════════

function EternalUI:Success(config)
    config = config or {}
    config.Type = "Success"
    return self:Notify(config)
end

function EternalUI:Error(config)
    config = config or {}
    config.Type = "Error"
    return self:Notify(config)
end

function EternalUI:Warning(config)
    config = config or {}
    config.Type = "Warning"
    return self:Notify(config)
end

-- ═══════════════════════════════════════════════════════════════
--  DESTROY
-- ═══════════════════════════════════════════════════════════════

function EternalUI:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

-- ═══════════════════════════════════════════════════════════════
--  RETURN LIBRARY
-- ═══════════════════════════════════════════════════════════════

return EternalUI
