local EternalLib = {}
EternalLib.__index = EternalLib

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function GetGui()
	if syn and syn.protect_gui then
		local sg = Instance.new("ScreenGui")
		syn.protect_gui(sg)
		sg.Parent = game.CoreGui
		return sg
	elseif gethui then
		local sg = Instance.new("ScreenGui")
		sg.Parent = gethui()
		return sg
	else
		local sg = Instance.new("ScreenGui")
		sg.Parent = game:GetService("CoreGui")
		return sg
	end
end

local function Tween(obj, props, t, style, dir)
	local info = TweenInfo.new(
		t or 0.22,
		style or Enum.EasingStyle.Quart,
		dir or Enum.EasingDirection.Out
	)
	local tw = TweenService:Create(obj, info, props)
	tw:Play()
	return tw
end

local function New(class, props, children)
	local obj = Instance.new(class)
	for k, v in pairs(props or {}) do
		if k ~= "Parent" then
			obj[k] = v
		end
	end
	for _, child in ipairs(children or {}) do
		child.Parent = obj
	end
	if props and props.Parent then
		obj.Parent = props.Parent
	end
	return obj
end

local function Corner(r)
	return New("UICorner", { CornerRadius = UDim.new(0, r or 8) })
end

local function Stroke(color, thickness, transparency)
	return New("UIStroke", {
		Color = color or Color3.fromRGB(40, 40, 80),
		Thickness = thickness or 1,
		Transparency = transparency or 0,
	})
end

local function Gradient(colors, rotation)
	local seq = {}
	for i, c in ipairs(colors) do
		seq[i] = ColorSequenceKeypoint.new((i - 1) / (#colors - 1), c)
	end
	return New("UIGradient", {
		Color = ColorSequence.new(seq),
		Rotation = rotation or 0,
	})
end

local T = {
	Bg            = Color3.fromRGB(6, 6, 18),
	Surface       = Color3.fromRGB(10, 10, 26),
	SurfaceHover  = Color3.fromRGB(14, 14, 36),
	SurfaceActive = Color3.fromRGB(18, 18, 48),
	Border        = Color3.fromRGB(28, 28, 72),
	BorderHover   = Color3.fromRGB(48, 48, 110),
	Accent        = Color3.fromRGB(124, 77, 255),
	AccentBright  = Color3.fromRGB(168, 127, 255),
	AccentDim     = Color3.fromRGB(74, 42, 204),
	Cyan          = Color3.fromRGB(0, 212, 255),
	Text          = Color3.fromRGB(240, 240, 255),
	TextSub       = Color3.fromRGB(90, 90, 144),
	TextMuted     = Color3.fromRGB(46, 46, 96),
	Success       = Color3.fromRGB(0, 255, 179),
	Error         = Color3.fromRGB(255, 64, 96),
	Warning       = Color3.fromRGB(255, 170, 0),
}

local function MakeDraggable(frame, handle)
	local dragging = false
	local dragStart
	local startPos

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
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
		if not dragging then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
end

function EternalLib:CreateWindow(config)
	config = config or {}
	local title    = config.Title or "Eternal Hub"
	local subtitle = config.SubTitle or "Script Hub"
	local size     = config.Size or UDim2.new(0, 660, 0, 480)
	local pos      = config.Position or UDim2.new(0.5, -330, 0.5, -240)
	local game_    = config.Game or "Unknown"

	local ScreenGui = GetGui()
	ScreenGui.Name = "EternalHub_" .. tostring(math.random(1e5, 9e5))
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.IgnoreGuiInset = true

	local Shadow = New("ImageLabel", {
		Name = "Shadow",
		Parent = ScreenGui,
		BackgroundTransparency = 1,
		Position = UDim2.new(pos.X.Scale, pos.X.Offset - 20, pos.Y.Scale, pos.Y.Offset - 20),
		Size = UDim2.new(size.X.Scale, size.X.Offset + 40, size.Y.Scale, size.Y.Offset + 40),
		Image = "rbxassetid://1316045217",
		ImageColor3 = Color3.fromRGB(0, 0, 0),
		ImageTransparency = 0.5,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(10, 10, 118, 118),
		ZIndex = 0,
	})

	local Main = New("Frame", {
		Name = "Main",
		Parent = ScreenGui,
		BackgroundColor3 = T.Bg,
		BackgroundTransparency = 0.08,
		BorderSizePixel = 0,
		Position = pos,
		Size = UDim2.new(0, 0, 0, 0),
		ClipsDescendants = true,
		Active = true,
		ZIndex = 1,
	}, { Corner(12) })

	local MainStroke = Stroke(T.Border, 1, 0.3)
	MainStroke.Parent = Main

	local TopGlow = New("Frame", {
		Name = "TopGlow",
		Parent = Main,
		BackgroundColor3 = T.Accent,
		BackgroundTransparency = 0.88,
		BorderSizePixel = 0,
		Position = UDim2.new(0.2, 0, -0.2, 0),
		Size = UDim2.new(0.6, 0, 0.5, 0),
		ZIndex = 0,
	}, { Corner(80) })

	local Titlebar = New("Frame", {
		Name = "Titlebar",
		Parent = Main,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.97,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 46),
		ZIndex = 2,
	})

	local TitlebarBottomLine = New("Frame", {
		Name = "Line",
		Parent = Titlebar,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.93,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 1, -1),
		Size = UDim2.new(1, 0, 0, 1),
		ZIndex = 3,
	})

	local LogoBadge = New("Frame", {
		Name = "LogoBadge",
		Parent = Titlebar,
		BackgroundColor3 = T.AccentDim,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 12, 0.5, -13),
		Size = UDim2.new(0, 26, 0, 26),
		ZIndex = 3,
	}, {
		Corner(7),
		New("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Font = Enum.Font.GothamBold,
			Text = "E",
			TextColor3 = T.Text,
			TextSize = 13,
			ZIndex = 4,
		}),
	})

	local LogoGradient = Gradient({ T.AccentDim, T.AccentBright }, 135)
	LogoGradient.Parent = LogoBadge

	local TitleLabel = New("TextLabel", {
		Name = "Title",
		Parent = Titlebar,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 46, 0, 6),
		Size = UDim2.new(0, 200, 0, 18),
		Font = Enum.Font.GothamBold,
		Text = title,
		TextColor3 = T.Text,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 3,
	})

	local SubLabel = New("TextLabel", {
		Name = "Sub",
		Parent = Titlebar,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 46, 0, 26),
		Size = UDim2.new(0, 200, 0, 13),
		Font = Enum.Font.GothamLight,
		Text = "SCRIPT HUB",
		TextColor3 = T.TextMuted,
		TextSize = 9,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 3,
	})

	local StatusChip = New("Frame", {
		Name = "Status",
		Parent = Titlebar,
		BackgroundColor3 = T.Success,
		BackgroundTransparency = 0.88,
		BorderSizePixel = 0,
		Position = UDim2.new(1, -120, 0.5, -11),
		Size = UDim2.new(0, 72, 0, 22),
		ZIndex = 3,
	}, { Corner(5) })

	local StatusStroke = Stroke(T.Success, 1, 0.7)
	StatusStroke.Parent = StatusChip

	local StatusDot = New("Frame", {
		Name = "Dot",
		Parent = StatusChip,
		BackgroundColor3 = T.Success,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 8, 0.5, -3),
		Size = UDim2.new(0, 6, 0, 6),
		ZIndex = 4,
	}, { Corner(3) })

	local StatusText = New("TextLabel", {
		Name = "Text",
		Parent = StatusChip,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 18, 0, 0),
		Size = UDim2.new(1, -22, 1, 0),
		Font = Enum.Font.GothamBold,
		Text = "ON",
		TextColor3 = T.Success,
		TextSize = 10,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 4,
	})

	local CloseBtn = New("TextButton", {
		Name = "Close",
		Parent = Titlebar,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.97,
		BorderSizePixel = 0,
		Position = UDim2.new(1, -34, 0.5, -11),
		Size = UDim2.new(0, 22, 0, 22),
		Font = Enum.Font.GothamBold,
		Text = "✕",
		TextColor3 = T.TextMuted,
		TextSize = 10,
		AutoButtonColor = false,
		ZIndex = 3,
	}, { Corner(5) })

	CloseBtn.MouseEnter:Connect(function()
		Tween(CloseBtn, { BackgroundTransparency = 0.8, TextColor3 = T.Error })
	end)
	CloseBtn.MouseLeave:Connect(function()
		Tween(CloseBtn, { BackgroundTransparency = 0.97, TextColor3 = T.TextMuted })
	end)

	local Sidebar = New("Frame", {
		Name = "Sidebar",
		Parent = Main,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.985,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0, 46),
		Size = UDim2.new(0, 152, 1, -46),
		ZIndex = 2,
		ClipsDescendants = true,
	})

	local SidebarLine = New("Frame", {
		Name = "Line",
		Parent = Sidebar,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.94,
		BorderSizePixel = 0,
		Position = UDim2.new(1, -1, 0, 0),
		Size = UDim2.new(0, 1, 1, 0),
		ZIndex = 3,
	})

	local TabScroll = New("ScrollingFrame", {
		Name = "Tabs",
		Parent = Sidebar,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0, 8),
		Size = UDim2.new(1, 0, 1, -90),
		ScrollBarThickness = 0,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ZIndex = 3,
	})

	local TabLayout = New("UIListLayout", {
		Parent = TabScroll,
		Padding = UDim.new(0, 3),
		SortOrder = Enum.SortOrder.LayoutOrder,
	})

	local TabPadding = New("UIPadding", {
		Parent = TabScroll,
		PaddingLeft = UDim.new(0, 7),
		PaddingRight = UDim.new(0, 7),
		PaddingTop = UDim.new(0, 4),
	})

	local GameCard = New("Frame", {
		Name = "GameCard",
		Parent = Sidebar,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.98,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 7, 1, -78),
		Size = UDim2.new(1, -14, 0, 56),
		ZIndex = 3,
	}, { Corner(8) })

	Stroke(T.Border, 1, 0.4).Parent = GameCard

	New("TextLabel", {
		Parent = GameCard,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 10, 0, 8),
		Size = UDim2.new(1, -20, 0, 12),
		Font = Enum.Font.GothamBold,
		Text = "ACTIVE GAME",
		TextColor3 = T.TextMuted,
		TextSize = 8,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 4,
	})

	New("TextLabel", {
		Parent = GameCard,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 10, 0, 22),
		Size = UDim2.new(1, -20, 0, 15),
		Font = Enum.Font.GothamBold,
		Text = game_,
		TextColor3 = T.Text,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 4,
	})

	local GameDot = New("Frame", {
		Parent = GameCard,
		BackgroundColor3 = T.Success,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 10, 1, -14),
		Size = UDim2.new(0, 6, 0, 6),
		ZIndex = 4,
	}, { Corner(3) })

	New("TextLabel", {
		Parent = GameCard,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 20, 1, -17),
		Size = UDim2.new(1, -30, 0, 12),
		Font = Enum.Font.Gotham,
		Text = "Supported",
		TextColor3 = T.Success,
		TextSize = 10,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 4,
	})

	local ContentArea = New("Frame", {
		Name = "Content",
		Parent = Main,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 162, 0, 54),
		Size = UDim2.new(1, -172, 1, -64),
		ClipsDescendants = true,
		ZIndex = 2,
	})

	MakeDraggable(Main, Titlebar)

	local Window = {
		ScreenGui   = ScreenGui,
		Main        = Main,
		Shadow      = Shadow,
		TabScroll   = TabScroll,
		ContentArea = ContentArea,
		Tabs        = {},
		ActiveTab   = nil,
		CloseBtn    = CloseBtn,
		_size       = size,
		_pos        = pos,
	}

	setmetatable(Window, EternalLib)

	Main.Size = UDim2.new(0, 0, 0, 0)
	Main.Position = UDim2.new(pos.X.Scale, pos.X.Offset + size.X.Offset / 2, pos.Y.Scale, pos.Y.Offset + size.Y.Offset / 2)

	Tween(Main, { Size = size, Position = pos }, 0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

	CloseBtn.MouseButton1Click:Connect(function()
		Tween(Main, {
			Size = UDim2.new(0, size.X.Offset, 0, 0),
			Position = UDim2.new(pos.X.Scale, pos.X.Offset, pos.Y.Scale, pos.Y.Offset + size.Y.Offset / 2),
		}, 0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
		task.wait(0.3)
		ScreenGui:Destroy()
	end)

	local dotAnim = true
	task.spawn(function()
		while dotAnim and StatusDot and StatusDot.Parent do
			Tween(StatusDot, { BackgroundTransparency = 0.6 }, 0.9)
			task.wait(0.9)
			Tween(StatusDot, { BackgroundTransparency = 0 }, 0.9)
			task.wait(0.9)
		end
	end)

	return Window
end

function EternalLib:AddTab(config)
	config = config or {}
	local name = config.Name or "Tab"
	local icon = config.Icon or "rbxassetid://7733964640"

	local TabBtn = New("TextButton", {
		Name = name .. "_Btn",
		Parent = self.TabScroll,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 36),
		Font = Enum.Font.GothamSemibold,
		Text = "",
		AutoButtonColor = false,
		LayoutOrder = #self.Tabs + 1,
		ZIndex = 4,
	}, { Corner(8) })

	local ActiveBar = New("Frame", {
		Name = "Bar",
		Parent = TabBtn,
		BackgroundColor3 = T.Accent,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0.18, 0),
		Size = UDim2.new(0, 2, 0.64, 0),
		BackgroundTransparency = 1,
		ZIndex = 5,
	}, { Corner(2) })

	local BarGrad = Gradient({ T.Accent, T.Cyan }, 90)
	BarGrad.Parent = ActiveBar

	local TabIconImg = New("ImageLabel", {
		Name = "Icon",
		Parent = TabBtn,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 12, 0.5, -9),
		Size = UDim2.new(0, 18, 0, 18),
		Image = icon,
		ImageColor3 = T.TextMuted,
		ZIndex = 5,
	})

	local TabLabel = New("TextLabel", {
		Name = "Label",
		Parent = TabBtn,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 36, 0, 0),
		Size = UDim2.new(1, -48, 1, 0),
		Font = Enum.Font.GothamSemibold,
		Text = name,
		TextColor3 = T.TextMuted,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 5,
	})

	local ActiveDot = New("Frame", {
		Name = "Dot",
		Parent = TabBtn,
		BackgroundColor3 = T.Accent,
		BorderSizePixel = 0,
		Position = UDim2.new(1, -14, 0.5, -3),
		Size = UDim2.new(0, 5, 0, 5),
		BackgroundTransparency = 1,
		ZIndex = 5,
	}, { Corner(3) })

	local Page = New("ScrollingFrame", {
		Name = name .. "_Page",
		Parent = self.ContentArea,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		ScrollBarThickness = 2,
		ScrollBarImageColor3 = T.Accent,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Visible = false,
		ZIndex = 3,
	})

	New("UIListLayout", {
		Parent = Page,
		Padding = UDim.new(0, 8),
		SortOrder = Enum.SortOrder.LayoutOrder,
	})

	New("UIPadding", {
		Parent = Page,
		PaddingLeft = UDim.new(0, 4),
		PaddingRight = UDim.new(0, 8),
		PaddingTop = UDim.new(0, 4),
		PaddingBottom = UDim.new(0, 20),
	})

	local Tab = {
		Button    = TabBtn,
		Page      = Page,
		Bar       = ActiveBar,
		Dot       = ActiveDot,
		Icon      = TabIconImg,
		Label     = TabLabel,
		Name      = name,
		Active    = false,
		Elements  = {},
	}

	table.insert(self.Tabs, Tab)

	TabBtn.MouseEnter:Connect(function()
		if not Tab.Active then
			Tween(TabBtn, { BackgroundTransparency = 0.92 }, 0.15)
		end
	end)

	TabBtn.MouseLeave:Connect(function()
		if not Tab.Active then
			Tween(TabBtn, { BackgroundTransparency = 1 }, 0.15)
		end
	end)

	TabBtn.MouseButton1Click:Connect(function()
		self:SelectTab(Tab)
	end)

	if #self.Tabs == 1 then
		self:SelectTab(Tab)
	end

	return Tab
end

function EternalLib:SelectTab(tab)
	for _, t in ipairs(self.Tabs) do
		t.Active = false
		t.Page.Visible = false
		Tween(t.Button, { BackgroundTransparency = 1 }, 0.18)
		Tween(t.Bar, { BackgroundTransparency = 1 }, 0.18)
		Tween(t.Dot, { BackgroundTransparency = 1 }, 0.18)
		Tween(t.Icon, { ImageColor3 = T.TextMuted }, 0.18)
		Tween(t.Label, { TextColor3 = T.TextMuted }, 0.18)
	end

	tab.Active = true
	tab.Page.Visible = true
	tab.Page.CanvasPosition = Vector2.new(0, 0)

	Tween(tab.Button, { BackgroundTransparency = 0.9 }, 0.2)
	Tween(tab.Bar, { BackgroundTransparency = 0 }, 0.2)
	Tween(tab.Dot, { BackgroundTransparency = 0 }, 0.2)
	Tween(tab.Icon, { ImageColor3 = T.Accent }, 0.2)
	Tween(tab.Label, { TextColor3 = T.Text }, 0.2)

	self.ActiveTab = tab
end

function EternalLib:AddSection(tab, config)
	config = config or {}
	local name = config.Name or "Section"

	local SectionFrame = New("Frame", {
		Name = name .. "_Section",
		Parent = tab.Page,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.975,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 40),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = #tab.Elements + 1,
		ZIndex = 3,
	}, { Corner(10) })

	Stroke(T.Border, 1, 0.5).Parent = SectionFrame

	local HeaderRow = New("Frame", {
		Parent = SectionFrame,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 12, 0, 10),
		Size = UDim2.new(1, -24, 0, 14),
		ZIndex = 4,
	})

	local SectionBar = New("Frame", {
		Parent = HeaderRow,
		BackgroundColor3 = T.Accent,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0.1, 0),
		Size = UDim2.new(0, 2, 0.8, 0),
		ZIndex = 5,
	}, { Corner(1) })

	Gradient({ T.Accent, T.Cyan }, 90).Parent = SectionBar

	New("TextLabel", {
		Parent = HeaderRow,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 10, 0, 0),
		Size = UDim2.new(1, -10, 1, 0),
		Font = Enum.Font.GothamBold,
		Text = string.upper(name),
		TextColor3 = T.TextMuted,
		TextSize = 9,
		TextXAlignment = Enum.TextXAlignment.Left,
		LetterSpacing = 2,
		ZIndex = 5,
	})

	local Divider = New("Frame", {
		Parent = SectionFrame,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.94,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 12, 0, 28),
		Size = UDim2.new(1, -24, 0, 1),
		ZIndex = 4,
	})

	local Content = New("Frame", {
		Name = "Content",
		Parent = SectionFrame,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 8, 0, 36),
		Size = UDim2.new(1, -16, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ZIndex = 4,
	})

	local ContentLayout = New("UIListLayout", {
		Parent = Content,
		Padding = UDim.new(0, 5),
		SortOrder = Enum.SortOrder.LayoutOrder,
	})

	New("UIPadding", {
		Parent = Content,
		PaddingBottom = UDim.new(0, 10),
	})

	ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		SectionFrame.Size = UDim2.new(1, 0, 0, 44 + ContentLayout.AbsoluteContentSize.Y)
	end)

	table.insert(tab.Elements, SectionFrame)
	return Content
end

function EternalLib:AddToggle(parent, config)
	config = config or {}
	local text     = config.Text or "Toggle"
	local desc     = config.Description
	local default  = config.Default or false
	local callback = config.Callback or function() end

	local height = desc and 44 or 36

	local Row = New("Frame", {
		Name = text .. "_Toggle",
		Parent = parent,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.975,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, height),
		LayoutOrder = #parent:GetChildren(),
		ZIndex = 5,
	}, { Corner(8) })

	Stroke(T.Border, 1, 0.55).Parent = Row

	New("TextLabel", {
		Parent = Row,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 12, 0, desc and 7 or 0),
		Size = UDim2.new(1, -68, 0, 20),
		Font = Enum.Font.GothamSemibold,
		Text = text,
		TextColor3 = default and T.Text or T.TextSub,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 6,
	})

	if desc then
		New("TextLabel", {
			Parent = Row,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 12, 0, 24),
			Size = UDim2.new(1, -68, 0, 14),
			Font = Enum.Font.GothamLight,
			Text = desc,
			TextColor3 = T.TextMuted,
			TextSize = 9,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 6,
		})
	end

	local Track = New("Frame", {
		Name = "Track",
		Parent = Row,
		BackgroundColor3 = default and T.Accent or T.SurfaceActive,
		BorderSizePixel = 0,
		Position = UDim2.new(1, -52, 0.5, -11),
		Size = UDim2.new(0, 40, 0, 22),
		ZIndex = 6,
	}, { Corner(11) })

	Stroke(T.Border, 1, 0.4).Parent = Track

	local Knob = New("Frame", {
		Name = "Knob",
		Parent = Track,
		BackgroundColor3 = default and T.Text or T.TextSub,
		BorderSizePixel = 0,
		Position = UDim2.new(0, default and 21 or 3, 0.5, -8),
		Size = UDim2.new(0, 16, 0, 16),
		ZIndex = 7,
	}, { Corner(8) })

	local state = default
	local textLabel = Row:FindFirstChildWhichIsA("TextLabel")

	local function UpdateToggle()
		if state then
			Tween(Track, { BackgroundColor3 = T.Accent }, 0.22)
			Tween(Knob, { Position = UDim2.new(0, 21, 0.5, -8), BackgroundColor3 = T.Text }, 0.22, Enum.EasingStyle.Back)
			for _, lbl in ipairs(Row:GetChildren()) do
				if lbl:IsA("TextLabel") and lbl.Position.X.Offset == 12 and lbl.TextSize == 12 then
					Tween(lbl, { TextColor3 = T.Text }, 0.18)
				end
			end
		else
			Tween(Track, { BackgroundColor3 = T.SurfaceActive }, 0.22)
			Tween(Knob, { Position = UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = T.TextSub }, 0.22, Enum.EasingStyle.Back)
			for _, lbl in ipairs(Row:GetChildren()) do
				if lbl:IsA("TextLabel") and lbl.Position.X.Offset == 12 and lbl.TextSize == 12 then
					Tween(lbl, { TextColor3 = T.TextSub }, 0.18)
				end
			end
		end
		callback(state)
	end

	Row.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			state = not state
			UpdateToggle()
		end
	end)

	Row.MouseEnter:Connect(function()
		Tween(Row, { BackgroundTransparency = 0.95 }, 0.15)
	end)
	Row.MouseLeave:Connect(function()
		Tween(Row, { BackgroundTransparency = 0.975 }, 0.15)
	end)

	return {
		GetState = function() return state end,
		SetState = function(v) state = v UpdateToggle() end,
	}
end

function EternalLib:AddSlider(parent, config)
	config = config or {}
	local text     = config.Text or "Slider"
	local min      = config.Min or 0
	local max      = config.Max or 100
	local default  = config.Default or min
	local suffix   = config.Suffix or ""
	local decimals = config.Decimals or 0
	local callback = config.Callback or function() end

	local Frame = New("Frame", {
		Name = text .. "_Slider",
		Parent = parent,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.975,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 52),
		LayoutOrder = #parent:GetChildren(),
		ZIndex = 5,
	}, { Corner(8) })

	Stroke(T.Border, 1, 0.55).Parent = Frame

	New("TextLabel", {
		Parent = Frame,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 12, 0, 8),
		Size = UDim2.new(0.6, 0, 0, 16),
		Font = Enum.Font.GothamSemibold,
		Text = text,
		TextColor3 = T.TextSub,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 6,
	})

	local ValueChip = New("Frame", {
		Parent = Frame,
		BackgroundColor3 = T.Cyan,
		BackgroundTransparency = 0.88,
		BorderSizePixel = 0,
		Position = UDim2.new(1, -58, 0, 7),
		Size = UDim2.new(0, 48, 0, 18),
		ZIndex = 6,
	}, { Corner(4) })

	Stroke(T.Cyan, 1, 0.7).Parent = ValueChip

	local ValueLabel = New("TextLabel", {
		Parent = ValueChip,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Font = Enum.Font.GothamBold,
		Text = tostring(default) .. suffix,
		TextColor3 = T.Cyan,
		TextSize = 10,
		ZIndex = 7,
	})

	local Track = New("Frame", {
		Name = "Track",
		Parent = Frame,
		BackgroundColor3 = T.SurfaceActive,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 12, 0, 34),
		Size = UDim2.new(1, -24, 0, 4),
		ZIndex = 6,
	}, { Corner(2) })

	local pct = (default - min) / (max - min)

	local Fill = New("Frame", {
		Name = "Fill",
		Parent = Track,
		BackgroundColor3 = T.Accent,
		BorderSizePixel = 0,
		Size = UDim2.new(pct, 0, 1, 0),
		ZIndex = 7,
	}, { Corner(2) })

	Gradient({ T.AccentDim, T.Accent, T.Cyan }, 0).Parent = Fill

	local Knob = New("Frame", {
		Name = "Knob",
		Parent = Track,
		BackgroundColor3 = T.Text,
		BorderSizePixel = 0,
		Position = UDim2.new(pct, -7, 0.5, -7),
		Size = UDim2.new(0, 14, 0, 14),
		ZIndex = 8,
	}, { Corner(7) })

	Stroke(T.Accent, 2, 0).Parent = Knob

	local value = default
	local dragging = false

	local function SetValue(v)
		v = math.clamp(v, min, max)
		if decimals == 0 then
			v = math.floor(v + 0.5)
		else
			v = math.floor(v * (10 ^ decimals) + 0.5) / (10 ^ decimals)
		end
		value = v
		local p = (v - min) / (max - min)
		Fill.Size = UDim2.new(p, 0, 1, 0)
		Knob.Position = UDim2.new(p, -7, 0.5, -7)
		ValueLabel.Text = tostring(v) .. suffix
		callback(v)
	end

	local function InputToValue(input)
		local rel = math.clamp(
			(input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X,
			0, 1
		)
		SetValue(min + (max - min) * rel)
	end

	Track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			InputToValue(input)
			Tween(Knob, { Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new((value - min)/(max - min), -8, 0.5, -8) }, 0.12)
		end
	end)

	Knob.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if not dragging then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then
			InputToValue(input)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			if dragging then
				dragging = false
				Tween(Knob, { Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new((value - min)/(max - min), -7, 0.5, -7) }, 0.12)
			end
		end
	end)

	return {
		GetValue = function() return value end,
		SetValue = SetValue,
	}
end

function EternalLib:AddButton(parent, config)
	config = config or {}
	local text     = config.Text or "Button"
	local desc     = config.Description
	local icon     = config.Icon or "▸"
	local variant  = config.Variant or "default"
	local callback = config.Callback or function() end

	local isAccent = variant == "accent"
	local isDanger = variant == "danger"
	local isCyan   = variant == "cyan"
	local lineColor = isAccent and T.Accent or isDanger and T.Error or isCyan and T.Cyan or T.Border

	local height = desc and 44 or 36

	local Btn = New("TextButton", {
		Name = text .. "_Btn",
		Parent = parent,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.975,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, height),
		Font = Enum.Font.GothamSemibold,
		Text = "",
		AutoButtonColor = false,
		LayoutOrder = #parent:GetChildren(),
		ZIndex = 5,
		ClipsDescendants = true,
	}, { Corner(8) })

	local BtnStroke = Stroke(T.Border, 1, 0.55)
	BtnStroke.Parent = Btn

	local IconBox = New("Frame", {
		Parent = Btn,
		BackgroundColor3 = lineColor,
		BackgroundTransparency = 0.88,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 10, 0.5, -11),
		Size = UDim2.new(0, 22, 0, 22),
		ZIndex = 6,
	}, { Corner(6) })

	New("TextLabel", {
		Parent = IconBox,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Font = Enum.Font.GothamBold,
		Text = icon,
		TextColor3 = isAccent and T.AccentBright or isDanger and T.Error or isCyan and T.Cyan or T.TextSub,
		TextSize = 11,
		ZIndex = 7,
	})

	New("TextLabel", {
		Parent = Btn,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 40, 0, desc and 7 or 0),
		Size = UDim2.new(1, -52, 0, 20),
		Font = Enum.Font.GothamSemibold,
		Text = text,
		TextColor3 = T.Text,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 6,
	})

	if desc then
		New("TextLabel", {
			Parent = Btn,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 40, 0, 24),
			Size = UDim2.new(1, -52, 0, 14),
			Font = Enum.Font.GothamLight,
			Text = desc,
			TextColor3 = T.TextMuted,
			TextSize = 9,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 6,
		})
	end

	Btn.MouseEnter:Connect(function()
		Tween(Btn, { BackgroundTransparency = 0.93 }, 0.15)
		Tween(BtnStroke, { Color = lineColor, Transparency = 0.4 }, 0.15)
	end)
	Btn.MouseLeave:Connect(function()
		Tween(Btn, { BackgroundTransparency = 0.975 }, 0.15)
		Tween(BtnStroke, { Color = T.Border, Transparency = 0.55 }, 0.15)
	end)
	Btn.MouseButton1Down:Connect(function()
		Tween(Btn, { BackgroundTransparency = 0.88 }, 0.1)
	end)
	Btn.MouseButton1Up:Connect(function()
		Tween(Btn, { BackgroundTransparency = 0.93 }, 0.1)
		callback()
	end)

	return Btn
end

function EternalLib:AddDropdown(parent, config)
	config = config or {}
	local text     = config.Text or "Dropdown"
	local options  = config.Options or {}
	local default  = config.Default or (options[1] or "None")
	local callback = config.Callback or function() end

	local Frame = New("Frame", {
		Name = text .. "_Dropdown",
		Parent = parent,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.975,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 36),
		LayoutOrder = #parent:GetChildren(),
		ClipsDescendants = true,
		ZIndex = 5,
	}, { Corner(8) })

	Stroke(T.Border, 1, 0.55).Parent = Frame

	local HeaderBtn = New("TextButton", {
		Parent = Frame,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 36),
		Text = "",
		AutoButtonColor = false,
		ZIndex = 6,
	})

	New("TextLabel", {
		Parent = HeaderBtn,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 12, 0, 0),
		Size = UDim2.new(0.55, 0, 1, 0),
		Font = Enum.Font.GothamSemibold,
		Text = text,
		TextColor3 = T.TextSub,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 7,
	})

	local SelLabel = New("TextLabel", {
		Parent = HeaderBtn,
		BackgroundTransparency = 1,
		Position = UDim2.new(0.56, 0, 0, 0),
		Size = UDim2.new(1, -70, 1, 0),
		Font = Enum.Font.GothamBold,
		Text = default,
		TextColor3 = T.AccentBright,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Right,
		ZIndex = 7,
	})

	local Arrow = New("TextLabel", {
		Parent = HeaderBtn,
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -24, 0, 0),
		Size = UDim2.new(0, 16, 1, 0),
		Font = Enum.Font.GothamBold,
		Text = "▼",
		TextColor3 = T.Accent,
		TextSize = 8,
		ZIndex = 7,
	})

	local OptionsContainer = New("Frame", {
		Parent = Frame,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 8, 0, 40),
		Size = UDim2.new(1, -16, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ZIndex = 6,
	})

	New("UIListLayout", {
		Parent = OptionsContainer,
		Padding = UDim.new(0, 3),
		SortOrder = Enum.SortOrder.LayoutOrder,
	})

	local selected = default
	local open = false
	local totalOptionsHeight = math.min(#options * 32, 160)

	for i, opt in ipairs(options) do
		local OptBtn = New("TextButton", {
			Name = opt,
			Parent = OptionsContainer,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 0.96,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 28),
			Font = Enum.Font.Gotham,
			Text = "",
			AutoButtonColor = false,
			LayoutOrder = i,
			ZIndex = 7,
		}, { Corner(6) })

		local dot = New("TextLabel", {
			Parent = OptBtn,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 8, 0, 0),
			Size = UDim2.new(0, 10, 1, 0),
			Font = Enum.Font.GothamBold,
			Text = opt == selected and "◆" or "◇",
			TextColor3 = opt == selected and T.Cyan or T.TextMuted,
			TextSize = 7,
			ZIndex = 8,
		})

		New("TextLabel", {
			Parent = OptBtn,
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 22, 0, 0),
			Size = UDim2.new(1, -30, 1, 0),
			Font = Enum.Font.Gotham,
			Text = opt,
			TextColor3 = opt == selected and T.Cyan or T.TextSub,
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 8,
		})

		OptBtn.MouseEnter:Connect(function()
			if opt ~= selected then
				Tween(OptBtn, { BackgroundTransparency = 0.9 }, 0.12)
			end
		end)
		OptBtn.MouseLeave:Connect(function()
			if opt ~= selected then
				Tween(OptBtn, { BackgroundTransparency = 0.96 }, 0.12)
			end
		end)

		OptBtn.MouseButton1Click:Connect(function()
			selected = opt
			SelLabel.Text = opt
			for _, child in ipairs(OptionsContainer:GetChildren()) do
				if child:IsA("TextButton") then
					local d = child:FindFirstChildWhichIsA("TextLabel")
					local l = child:FindFirstChild("TextLabel", true)
					for _, lbl in ipairs(child:GetChildren()) do
						if lbl:IsA("TextLabel") then
							if lbl.TextSize == 7 then
								lbl.Text = child.Name == opt and "◆" or "◇"
								Tween(lbl, { TextColor3 = child.Name == opt and T.Cyan or T.TextMuted }, 0.15)
							else
								Tween(lbl, { TextColor3 = child.Name == opt and T.Cyan or T.TextSub }, 0.15)
							end
						end
					end
				end
			end
			open = false
			Tween(Frame, { Size = UDim2.new(1, 0, 0, 36) }, 0.22, Enum.EasingStyle.Quart)
			Tween(Arrow, { Rotation = 0 }, 0.2)
			callback(selected)
		end)
	end

	HeaderBtn.MouseButton1Click:Connect(function()
		open = not open
		if open then
			Tween(Frame, { Size = UDim2.new(1, 0, 0, 44 + totalOptionsHeight) }, 0.24, Enum.EasingStyle.Quart)
			Tween(Arrow, { Rotation = 180 }, 0.2)
		else
			Tween(Frame, { Size = UDim2.new(1, 0, 0, 36) }, 0.22, Enum.EasingStyle.Quart)
			Tween(Arrow, { Rotation = 0 }, 0.2)
		end
	end)

	return {
		GetSelected = function() return selected end,
		SetSelected = function(v)
			selected = v
			SelLabel.Text = v
			callback(v)
		end,
	}
end

function EternalLib:AddKeybind(parent, config)
	config = config or {}
	local text     = config.Text or "Keybind"
	local default  = config.Default or Enum.KeyCode.Unknown
	local callback = config.Callback or function() end

	local Row = New("Frame", {
		Name = text .. "_Keybind",
		Parent = parent,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.975,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 36),
		LayoutOrder = #parent:GetChildren(),
		ZIndex = 5,
	}, { Corner(8) })

	Stroke(T.Border, 1, 0.55).Parent = Row

	New("TextLabel", {
		Parent = Row,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 12, 0, 0),
		Size = UDim2.new(0.6, 0, 1, 0),
		Font = Enum.Font.GothamSemibold,
		Text = text,
		TextColor3 = T.TextSub,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 6,
	})

	local KeyBtn = New("TextButton", {
		Name = "KeyBtn",
		Parent = Row,
		BackgroundColor3 = T.SurfaceActive,
		BorderSizePixel = 0,
		Position = UDim2.new(1, -80, 0.5, -12),
		Size = UDim2.new(0, 68, 0, 24),
		Font = Enum.Font.GothamBold,
		Text = default.Name,
		TextColor3 = T.AccentBright,
		TextSize = 10,
		AutoButtonColor = false,
		ZIndex = 6,
	}, { Corner(5) })

	Stroke(T.Border, 1, 0.5).Parent = KeyBtn

	local listening = false
	local currentKey = default

	KeyBtn.MouseButton1Click:Connect(function()
		listening = true
		KeyBtn.Text = "..."
		Tween(KeyBtn, { BackgroundColor3 = T.Accent, TextColor3 = T.Text }, 0.15)
	end)

	UserInputService.InputBegan:Connect(function(input, gpe)
		if not listening or gpe then return end
		if input.UserInputType == Enum.UserInputType.Keyboard then
			currentKey = input.KeyCode
			listening = false
			KeyBtn.Text = input.KeyCode.Name
			Tween(KeyBtn, { BackgroundColor3 = T.SurfaceActive, TextColor3 = T.AccentBright }, 0.15)
			callback(currentKey)
		end
	end)

	return {
		GetKey = function() return currentKey end,
		SetKey = function(k)
			currentKey = k
			KeyBtn.Text = k.Name
		end,
	}
end

function EternalLib:Notify(config)
	config = config or {}
	local title    = config.Title or "Eternal"
	local text     = config.Text or ""
	local duration = config.Duration or 3
	local type_    = config.Type or "Info"

	local typeColor = type_ == "Success" and T.Success
		or type_ == "Error" and T.Error
		or type_ == "Warning" and T.Warning
		or T.Accent

	local NGui = GetGui()
	NGui.Name = "EternalNotif_" .. tostring(math.random(1e4, 9e4))
	NGui.ResetOnSpawn = false
	NGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	NGui.IgnoreGuiInset = true

	local NFrame = New("Frame", {
		Name = "Notif",
		Parent = NGui,
		BackgroundColor3 = T.Surface,
		BackgroundTransparency = 0.08,
		BorderSizePixel = 0,
		Position = UDim2.new(1, 20, 0.88, 0),
		Size = UDim2.new(0, 290, 0, 68),
		AnchorPoint = Vector2.new(1, 0.5),
		ZIndex = 10,
	}, { Corner(10) })

	Stroke(typeColor, 1, 0.55).Parent = NFrame

	New("Frame", {
		Parent = NFrame,
		BackgroundColor3 = typeColor,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(0, 3, 1, 0),
		ZIndex = 11,
	}, { Corner(2) })

	New("TextLabel", {
		Parent = NFrame,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 16, 0, 10),
		Size = UDim2.new(1, -32, 0, 18),
		Font = Enum.Font.GothamBold,
		Text = title,
		TextColor3 = T.Text,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 11,
	})

	New("TextLabel", {
		Parent = NFrame,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 16, 0, 30),
		Size = UDim2.new(1, -32, 0, 30),
		Font = Enum.Font.Gotham,
		Text = text,
		TextColor3 = T.TextSub,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = true,
		ZIndex = 11,
	})

	local GlowDot = New("Frame", {
		Parent = NFrame,
		BackgroundColor3 = typeColor,
		BorderSizePixel = 0,
		Position = UDim2.new(1, -16, 0, 14),
		Size = UDim2.new(0, 6, 0, 6),
		ZIndex = 11,
	}, { Corner(3) })

	Tween(NFrame, { Position = UDim2.new(1, -20, 0.88, 0) }, 0.35, Enum.EasingStyle.Back)

	local dotAnim = true
	task.spawn(function()
		while dotAnim and GlowDot and GlowDot.Parent do
			Tween(GlowDot, { BackgroundTransparency = 0.6 }, 0.8)
			task.wait(0.8)
			Tween(GlowDot, { BackgroundTransparency = 0 }, 0.8)
			task.wait(0.8)
		end
	end)

	task.delay(duration, function()
		dotAnim = false
		Tween(NFrame, { Position = UDim2.new(1, 20, 0.88, 0) }, 0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
		task.wait(0.32)
		NGui:Destroy()
	end)

	return {
		Close = function()
			dotAnim = false
			Tween(NFrame, { Position = UDim2.new(1, 20, 0.88, 0) }, 0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
			task.wait(0.32)
			NGui:Destroy()
		end,
	}
end

function EternalLib:CreateFAB()
	local FGui = GetGui()
	FGui.Name = "EternalFAB"
	FGui.ResetOnSpawn = false
	FGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	FGui.IgnoreGuiInset = true

	local FAB = New("TextButton", {
		Name = "FAB",
		Parent = FGui,
		BackgroundColor3 = T.AccentDim,
		BackgroundTransparency = 0.15,
		BorderSizePixel = 0,
		Position = UDim2.new(1, -76, 1, -84),
		Size = UDim2.new(0, 52, 0, 52),
		Font = Enum.Font.GothamBold,
		Text = "",
		AutoButtonColor = false,
		ZIndex = 20,
	}, { Corner(15) })

	Stroke(T.Accent, 1, 0.3).Parent = FAB

	local FGrad = Gradient({ T.AccentDim, T.AccentBright }, 135)
	FGrad.Parent = FAB

	local ELabel = New("TextLabel", {
		Name = "E",
		Parent = FAB,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Font = Enum.Font.GothamBold,
		Text = "E",
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextSize = 20,
		ZIndex = 21,
	})

	local glowing = true
	task.spawn(function()
		while glowing and FAB and FAB.Parent do
			Tween(FAB, { BackgroundTransparency = 0.05 }, 1.2)
			task.wait(1.2)
			Tween(FAB, { BackgroundTransparency = 0.25 }, 1.2)
			task.wait(1.2)
		end
	end)

	FAB.MouseEnter:Connect(function()
		Tween(FAB, { Size = UDim2.new(0, 56, 0, 56), Position = UDim2.new(1, -80, 1, -88) }, 0.18, Enum.EasingStyle.Back)
	end)
	FAB.MouseLeave:Connect(function()
		Tween(FAB, { Size = UDim2.new(0, 52, 0, 52), Position = UDim2.new(1, -76, 1, -84) }, 0.18, Enum.EasingStyle.Back)
	end)

	return {
		Button = FAB,
		Gui = FGui,
		SetIcon = function(icon)
			ELabel.Text = icon
		end,
		Destroy = function()
			glowing = false
			FGui:Destroy()
		end,
	}
end

return EternalLib
