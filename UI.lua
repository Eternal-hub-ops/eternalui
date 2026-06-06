local Library = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")

local Colors = {
    DarkBg = Color3.fromRGB(6, 6, 12),
    DarkerBg = Color3.fromRGB(3, 3, 8),
    NeonPurple = Color3.fromRGB(156, 56, 255),
    NeonPink = Color3.fromRGB(255, 56, 188),
    NeonBlue = Color3.fromRGB(56, 156, 255),
    TextPrimary = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(180, 180, 200),
    GlowPurple = Color3.fromRGB(120, 30, 200),
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EternalHub"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local UIScale = Instance.new("UIScale")
UIScale.Parent = ScreenGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Colors.DarkBg
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local GlowFrame = Instance.new("Frame")
GlowFrame.Size = UDim2.new(1, 20, 1, 20)
GlowFrame.Position = UDim2.new(0, -10, 0, -10)
GlowFrame.BackgroundColor3 = Colors.NeonPurple
GlowFrame.BackgroundTransparency = 0.85
GlowFrame.BorderSizePixel = 0
GlowFrame.Parent = MainFrame

local BlurEffect = Instance.new("BlurEffect")
BlurEffect.Size = 8
BlurEffect.Parent = GlowFrame

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 16)
Corner.Parent = MainFrame

local InnerFrame = Instance.new("Frame")
InnerFrame.Size = UDim2.new(1, -4, 1, -4)
InnerFrame.Position = UDim2.new(0, 2, 0, 2)
InnerFrame.BackgroundColor3 = Colors.DarkerBg
InnerFrame.BackgroundTransparency = 0.3
InnerFrame.BorderSizePixel = 0
InnerFrame.Parent = MainFrame

local InnerCorner = Instance.new("UICorner")
InnerCorner.CornerRadius = UDim.new(0, 14)
InnerCorner.Parent = InnerFrame

local NeonBorder = Instance.new("Frame")
NeonBorder.Size = UDim2.new(1, 0, 1, 0)
NeonBorder.Position = UDim2.new(0, 0, 0, 0)
NeonBorder.BackgroundTransparency = 1
NeonBorder.BorderSizePixel = 0
NeonBorder.Parent = MainFrame

local BorderGradient = Instance.new("UIGradient")
BorderGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Colors.NeonPurple),
    ColorSequenceKeypoint.new(0.3, Colors.NeonPink),
    ColorSequenceKeypoint.new(0.7, Colors.NeonBlue),
    ColorSequenceKeypoint.new(1, Colors.NeonPurple)
}
BorderGradient.Rotation = 45

local AnimatedGlow = Instance.new("Frame")
AnimatedGlow.Size = UDim2.new(1, 0, 1, 0)
AnimatedGlow.Position = UDim2.new(0, 0, 0, 0)
AnimatedGlow.BackgroundColor3 = Colors.NeonPurple
AnimatedGlow.BackgroundTransparency = 0.9
AnimatedGlow.BorderSizePixel = 0
AnimatedGlow.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 55)
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.BackgroundColor3 = Colors.DarkBg
TitleBar.BackgroundTransparency = 0.5
TitleBar.BorderSizePixel = 0
TitleBar.Parent = InnerFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 14)
TitleCorner.Parent = TitleBar

local TitleGlow = Instance.new("Frame")
TitleGlow.Size = UDim2.new(1, 0, 0, 2)
TitleGlow.Position = UDim2.new(0, 0, 1, -2)
TitleGlow.BackgroundColor3 = Colors.NeonPurple
TitleGlow.BorderSizePixel = 0
TitleGlow.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -60, 1, 0)
TitleText.Position = UDim2.new(0, 20, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "ETERNAL HUB"
TitleText.TextColor3 = Colors.TextPrimary
TitleText.TextSize = 22
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Font = Enum.Font.GothamBold
TitleText.Parent = TitleBar

local SubtitleText = Instance.new("TextLabel")
SubtitleText.Size = UDim2.new(1, -60, 0, 20)
SubtitleText.Position = UDim2.new(0, 20, 0, 30)
SubtitleText.BackgroundTransparency = 1
SubtitleText.Text = "PREMIUM SCRIPT HUB"
SubtitleText.TextColor3 = Colors.NeonPurple
SubtitleText.TextSize = 11
SubtitleText.TextXAlignment = Enum.TextXAlignment.Left
SubtitleText.Font = Enum.Font.Gotham
SubtitleText.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 38, 0, 38)
CloseButton.Position = UDim2.new(1, -48, 0, 8)
CloseButton.BackgroundColor3 = Color3.fromRGB(30, 10, 40)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Colors.TextPrimary
CloseButton.TextSize = 20
CloseButton.TextScaled = true
CloseButton.Font = Enum.Font.GothamBold
CloseButton.BorderSizePixel = 0
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 10)
CloseCorner.Parent = CloseButton

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 38, 0, 38)
MinimizeButton.Position = UDim2.new(1, -96, 0, 8)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
MinimizeButton.Text = "−"
MinimizeButton.TextColor3 = Colors.TextPrimary
MinimizeButton.TextSize = 20
MinimizeButton.TextScaled = true
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Parent = TitleBar

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 10)
MinimizeCorner.Parent = MinimizeButton

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, 50)
TabContainer.Position = UDim2.new(0, 0, 0, 55)
TabContainer.BackgroundColor3 = Colors.DarkBg
TabContainer.BackgroundTransparency = 0.3
TabContainer.BorderSizePixel = 0
TabContainer.Parent = InnerFrame

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -20, 1, -125)
ContentContainer.Position = UDim2.new(0, 10, 0, 115)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = InnerFrame

local ContentScrolling = Instance.new("ScrollingFrame")
ContentScrolling.Size = UDim2.new(1, 0, 1, 0)
ContentScrolling.Position = UDim2.new(0, 0, 0, 0)
ContentScrolling.BackgroundTransparency = 1
ContentScrolling.BorderSizePixel = 0
ContentScrolling.ScrollBarThickness = 4
ContentScrolling.ScrollBarImageColor3 = Colors.NeonPurple
ContentScrolling.Parent = ContentContainer

local ContentList = Instance.new("UIListLayout")
ContentList.Padding = UDim.new(0, 10)
ContentList.SortOrder = Enum.SortOrder.LayoutOrder
ContentList.Parent = ContentScrolling

local ContentPadding = Instance.new("UIPadding")
ContentPadding.PaddingTop = UDim.new(0, 5)
ContentPadding.PaddingBottom = UDim.new(0, 5)
ContentPadding.Parent = ContentScrolling

local Tabs = {}
local TabButtons = {}
local CurrentTab = nil

local NeonLine = Instance.new("Frame")
NeonLine.Size = UDim2.new(0, 0, 0, 3)
NeonLine.Position = UDim2.new(0, 0, 1, -3)
NeonLine.BackgroundColor3 = Colors.NeonPurple
NeonLine.BorderSizePixel = 0
NeonLine.Parent = TabContainer

local NeonGlowLine = Instance.new("Frame")
NeonGlowLine.Size = UDim2.new(0, 0, 0, 8)
NeonGlowLine.Position = UDim2.new(0, 0, 1, -6)
NeonGlowLine.BackgroundColor3 = Colors.NeonPurple
NeonGlowLine.BackgroundTransparency = 0.7
NeonGlowLine.BorderSizePixel = 0
NeonGlowLine.Parent = TabContainer

local function GetScreenScale()
    local viewportSize = workspace.CurrentCamera.ViewportSize
    local scale = math.min(viewportSize.X / 1920, viewportSize.Y / 1080)
    return math.clamp(scale, 0.5, 1.2)
end

local function UpdateScale()
    local scale = GetScreenScale()
    UIScale.Scale = scale
end

local function AnimateBorder()
    local angle = 0
    RunService.RenderStepped:Connect(function(dt)
        angle = (angle + dt * 30) % 360
        BorderGradient.Rotation = angle
    end)
end

local function CreateNeonButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 42)
    button.Position = UDim2.new(0, 10, 0, 0)
    button.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    button.Text = text
    button.TextColor3 = Colors.TextPrimary
    button.TextSize = 14
    button.Font = Enum.Font.GothamSemibold
    button.BorderSizePixel = 0
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    local glow = Instance.new("Frame")
    glow.Size = UDim2.new(1, 0, 1, 0)
    glow.Position = UDim2.new(0, 0, 0, 0)
    glow.BackgroundColor3 = Colors.NeonPurple
    glow.BackgroundTransparency = 0.85
    glow.BorderSizePixel = 0
    glow.Parent = button
    
    local glowCorner = Instance.new("UICorner")
    glowCorner.CornerRadius = UDim.new(0, 8)
    glowCorner.Parent = glow
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(25, 20, 40)}):Play()
        TweenService:Create(glow, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.7}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(15, 15, 25)}):Play()
        TweenService:Create(glow, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.85}):Play()
    end)
    
    button.MouseButton1Click:Connect(callback)
    return button
end

function Library:MakeWindow(options)
    local title = options and options.Name or "ETERNAL HUB"
    TitleText.Text = title
    MainFrame.Size = UDim2.new(0, 550, 0, 650)
    if UserInputService.TouchEnabled then
        MainFrame.Size = UDim2.new(0, 650, 0, 750)
    end
    MainFrame.Visible = true
    UpdateScale()
    AnimateBorder()
    return self
end

function Library:CreateWindow(title)
    return Library:MakeWindow({Name = title})
end

function Library:MakeTab(options)
    local tabName = options and options.Name or "Tab"
    return Library:CreateTab(tabName)
end

function Library:CreateTab(tabName)
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(0, 110, 1, 0)
    tabButton.BackgroundTransparency = 1
    tabButton.Text = tabName
    tabButton.TextColor3 = Colors.TextSecondary
    tabButton.TextSize = 14
    tabButton.Font = Enum.Font.GothamSemibold
    tabButton.Parent = TabContainer
    
    local tabContent = Instance.new("Frame")
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.Visible = false
    tabContent.Parent = ContentScrolling
    
    local tabList = Instance.new("UIListLayout")
    tabList.Padding = UDim.new(0, 12)
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.Parent = tabContent
    
    table.insert(Tabs, tabContent)
    table.insert(TabButtons, tabButton)
    
    local function selectTab()
        for i, tab in pairs(Tabs) do
            tab.Visible = false
            if TabButtons[i] then
                TabButtons[i].TextColor3 = Colors.TextSecondary
            end
        end
        tabContent.Visible = true
        tabButton.TextColor3 = Colors.NeonPurple
        
        local xPos = (tabButton.AbsolutePosition.X - TabContainer.AbsolutePosition.X)
        TweenService:Create(NeonLine, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, tabButton.AbsoluteSize.X, 0, 3), Position = UDim2.new(0, xPos, 1, -3)}):Play()
        TweenService:Create(NeonGlowLine, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, tabButton.AbsoluteSize.X, 0, 8), Position = UDim2.new(0, xPos, 1, -6)}):Play()
    end
    
    tabButton.MouseButton1Click:Connect(selectTab)
    
    if not CurrentTab then
        CurrentTab = tabContent
        selectTab()
    end
    
    local sectionObjects = {}
    
    local function createSection(sectionName)
        local sectionFrame = Instance.new("Frame")
        sectionFrame.Size = UDim2.new(1, 0, 0, 45)
        sectionFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 18)
        sectionFrame.BackgroundTransparency = 0.4
        sectionFrame.BorderSizePixel = 0
        sectionFrame.Parent = tabContent
        
        local sectionCorner = Instance.new("UICorner")
        sectionCorner.CornerRadius = UDim.new(0, 8)
        sectionCorner.Parent = sectionFrame
        
        local sectionLabel = Instance.new("TextLabel")
        sectionLabel.Size = UDim2.new(1, -15, 1, 0)
        sectionLabel.Position = UDim2.new(0, 15, 0, 0)
        sectionLabel.BackgroundTransparency = 1
        sectionLabel.Text = sectionName
        sectionLabel.TextColor3 = Colors.NeonPurple
        sectionLabel.TextSize = 13
        sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
        sectionLabel.Font = Enum.Font.GothamBold
        sectionLabel.Parent = sectionFrame
        
        local sectionContent = Instance.new("Frame")
        sectionContent.Size = UDim2.new(1, 0, 0, 0)
        sectionContent.BackgroundTransparency = 1
        sectionContent.Parent = tabContent
        
        local contentList = Instance.new("UIListLayout")
        contentList.Padding = UDim.new(0, 8)
        contentList.SortOrder = Enum.SortOrder.LayoutOrder
        contentList.Parent = sectionContent
        
        local function updateHeight()
            local totalHeight = 0
            for _, child in pairs(sectionContent:GetChildren()) do
                if child:IsA("Frame") or child:IsA("TextButton") then
                    totalHeight = totalHeight + child.Size.Y.Offset + 8
                end
            end
            sectionContent.Size = UDim2.new(1, 0, 0, totalHeight)
        end
        
        local section = {
            AddButton = function(self, options)
                if type(self) ~= "table" then
                    options = self
                end
                local btn = CreateNeonButton(sectionContent, options.Name, options.Callback or function() end)
                updateHeight()
                return btn
            end,
            AddToggle = function(self, options)
                if type(self) ~= "table" then
                    options = self
                end
                local toggleFrame = Instance.new("Frame")
                toggleFrame.Size = UDim2.new(1, -20, 0, 45)
                toggleFrame.Position = UDim2.new(0, 10, 0, 0)
                toggleFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 20)
                toggleFrame.BorderSizePixel = 0
                toggleFrame.Parent = sectionContent
                
                local toggleCorner = Instance.new("UICorner")
                toggleCorner.CornerRadius = UDim.new(0, 8)
                toggleCorner.Parent = toggleFrame
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -60, 1, 0)
                label.Position = UDim2.new(0, 15, 0, 0)
                label.BackgroundTransparency = 1
                label.Text = options.Name
                label.TextColor3 = Colors.TextPrimary
                label.TextSize = 13
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Font = Enum.Font.Gotham
                label.Parent = toggleFrame
                
                local toggleBtn = Instance.new("TextButton")
                toggleBtn.Size = UDim2.new(0, 50, 0, 28)
                toggleBtn.Position = UDim2.new(1, -65, 0, 8)
                toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
                toggleBtn.Text = ""
                toggleBtn.BorderSizePixel = 0
                toggleBtn.Parent = toggleFrame
                
                local toggleCorner2 = Instance.new("UICorner")
                toggleCorner2.CornerRadius = UDim.new(0, 14)
                toggleCorner2.Parent = toggleBtn
                
                local toggleCircle = Instance.new("Frame")
                toggleCircle.Size = UDim2.new(0, 24, 0, 24)
                toggleCircle.Position = UDim2.new(0, 3, 0, 2)
                toggleCircle.BackgroundColor3 = Colors.TextPrimary
                toggleCircle.BorderSizePixel = 0
                toggleCircle.Parent = toggleBtn
                
                local circleCorner = Instance.new("UICorner")
                circleCorner.CornerRadius = UDim.new(0, 12)
                circleCorner.Parent = toggleCircle
                
                local toggled = options.Default or false
                if toggled then
                    toggleBtn.BackgroundColor3 = Colors.NeonPurple
                    toggleCircle.Position = UDim2.new(1, -27, 0, 2)
                end
                
                toggleBtn.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    if toggled then
                        TweenService:Create(toggleBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Colors.NeonPurple}):Play()
                        TweenService:Create(toggleCircle, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = UDim2.new(1, -27, 0, 2)}):Play()
                    else
                        TweenService:Create(toggleBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}):Play()
                        TweenService:Create(toggleCircle, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = UDim2.new(0, 3, 0, 2)}):Play()
                    end
                    if options.Callback then options.Callback(toggled) end
                end)
                
                updateHeight()
                return toggleFrame
            end,
            AddSlider = function(self, options)
                if type(self) ~= "table" then
                    options = self
                end
                local sliderFrame = Instance.new("Frame")
                sliderFrame.Size = UDim2.new(1, -20, 0, 75)
                sliderFrame.Position = UDim2.new(0, 10, 0, 0)
                sliderFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 20)
                sliderFrame.BorderSizePixel = 0
                sliderFrame.Parent = sectionContent
                
                local sliderCorner = Instance.new("UICorner")
                sliderCorner.CornerRadius = UDim.new(0, 8)
                sliderCorner.Parent = sliderFrame
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -20, 0, 30)
                label.Position = UDim2.new(0, 15, 0, 0)
                label.BackgroundTransparency = 1
                label.Text = options.Name .. ": " .. tostring(options.Default or options.Min)
                label.TextColor3 = Colors.TextPrimary
                label.TextSize = 13
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Font = Enum.Font.Gotham
                label.Parent = sliderFrame
                
                local valueLabel = Instance.new("TextLabel")
                valueLabel.Size = UDim2.new(0, 50, 0, 30)
                valueLabel.Position = UDim2.new(1, -65, 0, 0)
                valueLabel.BackgroundTransparency = 1
                valueLabel.Text = tostring(options.Default or options.Min)
                valueLabel.TextColor3 = Colors.NeonPurple
                valueLabel.TextSize = 13
                valueLabel.TextXAlignment = Enum.TextXAlignment.Right
                valueLabel.Font = Enum.Font.GothamBold
                valueLabel.Parent = sliderFrame
                
                local sliderBar = Instance.new("Frame")
                sliderBar.Size = UDim2.new(1, -30, 0, 6)
                sliderBar.Position = UDim2.new(0, 15, 0, 45)
                sliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
                sliderBar.BorderSizePixel = 0
                sliderBar.Parent = sliderFrame
                
                local barCorner = Instance.new("UICorner")
                barCorner.CornerRadius = UDim.new(0, 3)
                barCorner.Parent = sliderBar
                
                local fillBar = Instance.new("Frame")
                fillBar.Size = UDim2.new(0, 0, 1, 0)
                fillBar.BackgroundColor3 = Colors.NeonPurple
                fillBar.BorderSizePixel = 0
                fillBar.Parent = sliderBar
                
                local fillCorner = Instance.new("UICorner")
                fillCorner.CornerRadius = UDim.new(0, 3)
                fillCorner.Parent = fillBar
                
                local handle = Instance.new("Frame")
                handle.Size = UDim2.new(0, 18, 0, 18)
                handle.Position = UDim2.new(0, -9, 0, -6)
                handle.BackgroundColor3 = Colors.TextPrimary
                handle.BorderSizePixel = 0
                handle.Parent = fillBar
                
                local handleCorner = Instance.new("UICorner")
                handleCorner.CornerRadius = UDim.new(0, 9)
                handleCorner.Parent = handle
                
                local value = options.Default or options.Min
                local min, max = options.Min, options.Max
                
                local function updateValue(inputPos)
                    local relativePos = math.clamp((inputPos.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
                    value = math.floor(min + (max - min) * relativePos)
                    value = math.clamp(value, min, max)
                    fillBar.Size = UDim2.new(relativePos, 0, 1, 0)
                    label.Text = options.Name .. ": " .. tostring(value)
                    valueLabel.Text = tostring(value)
                    if options.Callback then options.Callback(value) end
                end
                
                local dragging = false
                sliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        updateValue(input.Position)
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        updateValue(input.Position)
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                local initialPercent = (value - min) / (max - min)
                fillBar.Size = UDim2.new(initialPercent, 0, 1, 0)
                label.Text = options.Name .. ": " .. tostring(value)
                valueLabel.Text = tostring(value)
                
                updateHeight()
                return sliderFrame
            end,
            AddDropdown = function(self, options)
                if type(self) ~= "table" then
                    options = self
                end
                local dropdownFrame = Instance.new("Frame")
                dropdownFrame.Size = UDim2.new(1, -20, 0, 45)
                dropdownFrame.Position = UDim2.new(0, 10, 0, 0)
                dropdownFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 20)
                dropdownFrame.BorderSizePixel = 0
                dropdownFrame.Parent = sectionContent
                
                local dropdownCorner = Instance.new("UICorner")
                dropdownCorner.CornerRadius = UDim.new(0, 8)
                dropdownCorner.Parent = dropdownFrame
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -100, 1, 0)
                label.Position = UDim2.new(0, 15, 0, 0)
                label.BackgroundTransparency = 1
                label.Text = options.Name .. ": " .. (options.Default or options.List[1])
                label.TextColor3 = Colors.TextPrimary
                label.TextSize = 13
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Font = Enum.Font.Gotham
                label.Parent = dropdownFrame
                
                local dropdownBtn = Instance.new("TextButton")
                dropdownBtn.Size = UDim2.new(0, 40, 0, 35)
                dropdownBtn.Position = UDim2.new(1, -55, 0, 5)
                dropdownBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
                dropdownBtn.Text = "▼"
                dropdownBtn.TextColor3 = Colors.TextPrimary
                dropdownBtn.TextSize = 16
                dropdownBtn.Font = Enum.Font.Gotham
                dropdownBtn.BorderSizePixel = 0
                dropdownBtn.Parent = dropdownFrame
                
                local dropdownCorner2 = Instance.new("UICorner")
                dropdownCorner2.CornerRadius = UDim.new(0, 8)
                dropdownCorner2.Parent = dropdownBtn
                
                local dropdownList = Instance.new("Frame")
                dropdownList.Size = UDim2.new(1, 0, 0, 0)
                dropdownList.Position = UDim2.new(0, 0, 1, 5)
                dropdownList.BackgroundColor3 = Color3.fromRGB(8, 8, 16)
                dropdownList.BorderSizePixel = 0
                dropdownList.Visible = false
                dropdownList.Parent = dropdownFrame
                
                local listCorner = Instance.new("UICorner")
                listCorner.CornerRadius = UDim.new(0, 8)
                listCorner.Parent = dropdownList
                
                local listLayout = Instance.new("UIListLayout")
                listLayout.Padding = UDim.new(0, 2)
                listLayout.SortOrder = Enum.SortOrder.LayoutOrder
                listLayout.Parent = dropdownList
                
                local function updateListHeight()
                    local height = 0
                    for _, child in pairs(dropdownList:GetChildren()) do
                        if child:IsA("TextButton") then
                            height = height + 38
                        end
                    end
                    dropdownList.Size = UDim2.new(1, 0, 0, height + 10)
                end
                
                local isOpen = false
                for _, item in pairs(options.List) do
                    local itemBtn = Instance.new("TextButton")
                    itemBtn.Size = UDim2.new(1, 0, 0, 38)
                    itemBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
                    itemBtn.Text = item
                    itemBtn.TextColor3 = Colors.TextSecondary
                    itemBtn.TextSize = 13
                    itemBtn.Font = Enum.Font.Gotham
                    itemBtn.BorderSizePixel = 0
                    itemBtn.Parent = dropdownList
                    
                    local itemCorner = Instance.new("UICorner")
                    itemCorner.CornerRadius = UDim.new(0, 4)
                    itemCorner.Parent = itemBtn
                    
                    itemBtn.MouseEnter:Connect(function()
                        TweenService:Create(itemBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(25, 20, 40)}):Play()
                    end)
                    itemBtn.MouseLeave:Connect(function()
                        TweenService:Create(itemBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(15, 15, 25)}):Play()
                    end)
                    
                    itemBtn.MouseButton1Click:Connect(function()
                        label.Text = options.Name .. ": " .. item
                        if options.Callback then options.Callback(item) end
                        isOpen = false
                        TweenService:Create(dropdownList, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
                        task.wait(0.2)
                        dropdownList.Visible = false
                    end)
                end
                updateListHeight()
                
                local cachedHeight = dropdownList.AbsoluteSize.Y
                dropdownBtn.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    if isOpen then
                        dropdownList.Visible = true
                        dropdownList.Size = UDim2.new(1, 0, 0, 0)
                        local h = cachedHeight > 0 and cachedHeight or (#options.List * 40 + 10)
                        TweenService:Create(dropdownList, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(1, 0, 0, h)}):Play()
                    else
                        TweenService:Create(dropdownList, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(1, 0, 0, 0)}):Play()
                        task.wait(0.2)
                        dropdownList.Visible = false
                    end
                end)
                
                updateHeight()
                return dropdownFrame
            end
        }
        return section
    end
    
    return {
        CreateSection = createSection,
        MakeSection = createSection,
    }
end

function Library:Notification(options)
    local notifFrame = Instance.new("Frame")
    notifFrame.Size = UDim2.new(0, 320, 0, 70)
    notifFrame.Position = UDim2.new(1, -340, 0, -80)
    notifFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 16)
    notifFrame.BorderSizePixel = 0
    notifFrame.Parent = ScreenGui
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 12)
    notifCorner.Parent = notifFrame
    
    local notifGlow = Instance.new("Frame")
    notifGlow.Size = UDim2.new(1, 0, 1, 0)
    notifGlow.Position = UDim2.new(0, 0, 0, 0)
    notifGlow.BackgroundColor3 = options.Type == "success" and Color3.fromRGB(80, 200, 80) or (options.Type == "error" and Color3.fromRGB(200, 50, 50) or Colors.NeonPurple)
    notifGlow.BackgroundTransparency = 0.85
    notifGlow.BorderSizePixel = 0
    notifGlow.Parent = notifFrame
    
    local notifGlowCorner = Instance.new("UICorner")
    notifGlowCorner.CornerRadius = UDim.new(0, 12)
    notifGlowCorner.Parent = notifGlow
    
    local borderLine = Instance.new("Frame")
    borderLine.Size = UDim2.new(0, 4, 1, 0)
    borderLine.Position = UDim2.new(0, 0, 0, 0)
    borderLine.BackgroundColor3 = options.Type == "success" and Color3.fromRGB(80, 200, 80) or (options.Type == "error" and Color3.fromRGB(200, 50, 50) or Colors.NeonPurple)
    borderLine.BorderSizePixel = 0
    borderLine.Parent = notifFrame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 30)
    title.Position = UDim2.new(0, 15, 0, 8)
    title.BackgroundTransparency = 1
    title.Text = options.Title
    title.TextColor3 = Colors.TextPrimary
    title.TextSize = 15
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Font = Enum.Font.GothamBold
    title.Parent = notifFrame
    
    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(1, -20, 0, 30)
    desc.Position = UDim2.new(0, 15, 0, 35)
    desc.BackgroundTransparency = 1
    desc.Text = options.Description
    desc.TextColor3 = Colors.TextSecondary
    desc.TextSize = 12
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.Font = Enum.Font.Gotham
    desc.Parent = notifFrame
    
    TweenService:Create(notifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {Position = UDim2.new(1, -340, 0, 10)}):Play()
    task.wait(options.Duration or 4)
    TweenService:Create(notifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {Position = UDim2.new(1, -340, 0, -80)}):Play()
    task.wait(0.4)
    notifFrame:Destroy()
end

local uiOpen = true
local toggleKey = Enum.KeyCode.RightShift

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == toggleKey then
        uiOpen = not uiOpen
        MainFrame.Visible = uiOpen
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    uiOpen = false
    MainFrame.Visible = false
end)

local minimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 400, 0, 55)}):Play()
        TitleText.Text = "ETERNAL HUB [MINIMIZED]"
    else
        local targetSize = UserInputService.TouchEnabled and UDim2.new(0, 650, 0, 750) or UDim2.new(0, 550, 0, 650)
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = targetSize}):Play()
        TitleText.Text = "ETERNAL HUB"
    end
end)

workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateScale)

MainFrame.Visible = false

return Library
