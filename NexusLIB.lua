
----------------------------------------------------------------------
-- SERVICES
----------------------------------------------------------------------
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local HttpService      = game:GetService("HttpService")
local SoundService     = game:GetService("SoundService")
local LocalPlayer      = Players.LocalPlayer

local env = (typeof(getgenv) == "function" and getgenv()) or _G

----------------------------------------------------------------------
-- DESIGN TOKENS  (every colour, size, radius, duration comes from here)
----------------------------------------------------------------------
local Tokens = {
	Color = {
		Bg        = Color3.fromRGB(11, 12, 16),
		Surface1  = Color3.fromRGB(16, 18, 23),
		Surface2  = Color3.fromRGB(21, 24, 30),
		Surface3  = Color3.fromRGB(28, 32, 40),
		Surface4  = Color3.fromRGB(38, 43, 53),
		KeyLip    = Color3.fromRGB(52, 58, 70),
		Text      = Color3.fromRGB(236, 238, 242),
		TextDim   = Color3.fromRGB(154, 160, 172),
		TextMute  = Color3.fromRGB(100, 106, 118),
		Accent    = Color3.fromRGB(92, 156, 255),
		Accent2   = Color3.fromRGB(120, 124, 255),
		Success   = Color3.fromRGB(52, 211, 153),
		Warning   = Color3.fromRGB(251, 191, 36),
		Danger    = Color3.fromRGB(248, 90, 100),
		White     = Color3.new(1, 1, 1),
		Shadow    = Color3.new(0, 0, 0),
	},
	-- transparencies (0 = opaque, 1 = invisible)
	Alpha = {
		Border = 0.92, BorderStrong = 0.84, Highlight = 0.94, AccentSoft = 0.85,
		Wash = 0.5, WashActive = 0.2, Ring = 0.8, Scroll = 0.85, Backdrop = 0.45,
		Noise = 0.975, Aurora = 0.993, Sheen = 0.82, Overlay = 0.92, Tint = 0.86,
	},
	Space  = { XS = 4, S = 8, M = 12, L = 16, XL = 20, XXL = 24, XXXL = 32 },
	Radius = { Window = 14, Card = 10, Control = 8, Small = 6, Tiny = 4, Pill = 999 },
	Font   = { Display = "Montserrat", Text = "Roboto", Mono = "RobotoMono" },
	Type = {
		Display = { Size = 20, Weight = "SemiBold", Color = "Text",     Family = "Display" },
		Title   = { Size = 14, Weight = "SemiBold", Color = "Text",     Family = "Display" },
		Body    = { Size = 13, Weight = "Medium",   Color = "Text",     Family = "Text" },
		Strong  = { Size = 13, Weight = "SemiBold", Color = "Text",     Family = "Display" },
		Caption = { Size = 12, Weight = "Regular",  Color = "TextDim",  Family = "Text" },
		Label   = { Size = 11, Weight = "SemiBold", Color = "TextMute", Family = "Display" },
		Mono    = { Size = 12, Weight = "Regular",  Color = "TextDim",  Family = "Mono" },
		MonoSm  = { Size = 11, Weight = "Regular",  Color = "TextMute", Family = "Mono" },
		MonoLg  = { Size = 20, Weight = "Medium",   Color = "Text",     Family = "Mono" },
	},
	Size = {
		Window = Vector2.new(780, 540), TitleBar = 48, Sidebar = 200, TabRow = 34, TabGap = 2, UserCard = 56,
		Row = 36, RowDesc = 52, RowSlider = 56, RowButton = 48, RowGraph = 112, RowProgress = 52, RowSeparator = 28,
		SectionHeader = 40, Icon = 16, IconSm = 14, IconXs = 12, Logo = 22, Control = 30, Well = 32, IconButton = 28,
		ToggleW = 36, ToggleH = 20, Knob = 16, Checkbox = 18, Thumb = 14, ThumbActive = 16, Track = 4, ProgressTrack = 6,
		Swatch = 20, SwatchSm = 18, Keycap = 24, KeyLip = 2, Avatar = 28, Search = Vector2.new(280, 30), Pill = 20,
		Toast = Vector2.new(340, 72), ToastIcon = 28, ToastGap = 8, ToastMax = 4, ToastEdge = 16,
		PopItem = 32, PopMaxH = 248, PopMinW = 200, PopGap = 6, PopSearchAt = 8,
		WindowPad = 48, PopPad = 24, TipPad = 8, ScrollThumb = 4, ScrollInset = 3,
		Mobile = 44, Watermark = 28, SV = Vector2.new(200, 140), Hue = 12, HueHandle = 14, ColorPop = 224,
		GraphPlot = 56, GraphLine = 2, Divider = 1, Hairline = 2, ControlFrac = 0.5, MinControl = 96,
		Splash = Vector2.new(240, 140), SplashBar = 120, SplashLogo = 40,
		Spinner = 14, Radio = 16, RadioDot = 8, RadioRow = 32, SegPad = 3, ScrollBar = 2, Fade = 16, Stretch = 3,
		Dialog = 360, ToastPeek = 10, ToastScale = 0.06, ToastVisible = 3, CursorRing = 26, CursorDot = 6,
		StatTile = 64, Burst = 14, MagnetRange = 72, MagnetStrength = 0.3,
	},
	Motion = {
		Hover = 0.12, State = 0.18, Enter = 0.24, Exit = 0.16,
		Splash = 0.6, Toast = 4.5, TooltipDelay = 0.4, Stagger = 0.03, StaggerCap = 0.12,
		Sheen = 0.8, ScrollIdle = 0.9, Drift = 8, TabSlide = 6, TipOffset = 2, ToastSlide = 12,
		OpenScale = 0.96, Press = 0.98, Tap = 0.97,
		Accordion = 0.35, ExitDelay = 0.2, ItemStagger = 0.015, ItemStaggerCap = 0.12,
		CharStagger = 0.025, CharStaggerCap = 0.3, Roll = 0.5, PageOut = 0.15, PageIn = 0.3, PageSlide = 12,
		Liquid = 0.25, Done = 1.2, Reveal = 0.7, Burst = 0.55, Beat = 0.08, Draw = 0.3, DrawDelay = 0.2, Shimmer = 1.6,
	},
	Ease = {
		Enter = Enum.EasingStyle.Quint, Exit = Enum.EasingStyle.Quad, State = Enum.EasingStyle.Quint,
		Linear = Enum.EasingStyle.Linear, Sine = Enum.EasingStyle.Sine, Accordion = Enum.EasingStyle.Cubic,
	},
	-- springs: either Speed/Damping (ω, ζ) or K/C/Mass (stiffness, damping, mass — same values as animate-ui)
	Spring = {
		Indicator = { K = 300, C = 30, Eps = 0.05 },
		Knob      = { K = 300, C = 25, Eps = 0.02 },
		Thumb     = { Speed = 42, Damping = 1, Eps = 0.0005 },
		Drag      = { Speed = 36, Damping = 1, Eps = 0.05 },
		Stack     = { Speed = 22, Damping = 1, Eps = 0.05 },
		Highlight = { K = 500, C = 40, Eps = 0.05 },
		Digit     = { K = 200, C = 20, Mass = 0.4, Eps = 0.01 },
		Count     = { K = 90, C = 50, Eps = 0.05 },
		Flip      = { K = 280, C = 20, Eps = 0.002 },
		Tap       = { K = 550, C = 30, Eps = 0.0005 },
		Pop       = { K = 500, C = 24, Eps = 0.002 },
		Magnetic  = { K = 100, C = 10, Mass = 0.5, Eps = 0.05 },
		Parallax  = { K = 50, C = 20, Eps = 0.05 },
		Follower  = { K = 100, C = 20, Eps = 0.05 },
		Popover   = { K = 420, C = 34, Eps = 0.0005 },
	},
	-- layered soft shadows: Layers x Step px spread, total opacity ≈ Layers * Opacity at the centre
	Shadow = {
		small   = { Layers = 2, Step = 1, Offset = 1,  Opacity = 0.18 },
		card    = { Layers = 3, Step = 2, Offset = 2,  Opacity = 0.05 },
		popover = { Layers = 6, Step = 3, Offset = 6,  Opacity = 0.065 },
		window  = { Layers = 9, Step = 4, Offset = 12, Opacity = 0.05 },
		glow    = { Layers = 4, Step = 2, Offset = 0,  Opacity = 0.07 },
	},
	UIScaleSteps = { 1, 0.875, 0.75, 0.625, 0.5 },
	NoiseSize = 128,
}

local C, A, S, R, M, Z = Tokens.Color, Tokens.Alpha, Tokens.Space, Tokens.Radius, Tokens.Motion, Tokens.Size

-- Theme keeps the v3.0 key names working for existing scripts
local Theme = C
local function syncThemeAliases()
	C.Background, C.Panel, C.Element, C.ElementHi = C.Bg, C.Surface2, C.Surface3, C.Surface4
	C.Track, C.Stroke, C.SubText = C.Surface4, C.Surface4, C.TextDim
	C.Good, C.Warn, C.Bad = C.Success, C.Warning, C.Danger
end
syncThemeAliases()

local Presets = {
	Nexus  = { Color3.fromRGB(92, 156, 255),  Color3.fromRGB(120, 124, 255) },
	Violet = { Color3.fromRGB(150, 120, 250), Color3.fromRGB(190, 128, 240) },
	Ember  = { Color3.fromRGB(246, 132, 72),  Color3.fromRGB(238, 98, 98) },
	Mint   = { Color3.fromRGB(52, 201, 150),  Color3.fromRGB(56, 176, 206) },
	Rose   = { Color3.fromRGB(240, 112, 168), Color3.fromRGB(246, 114, 132) },
	Gold   = { Color3.fromRGB(230, 180, 72),  Color3.fromRGB(238, 142, 52) },
}
local PresetAlias = { Cyber = "Nexus", Synthwave = "Violet", Toxic = "Mint", Inferno = "Ember", Glacier = "Nexus", Aurum = "Gold" }

----------------------------------------------------------------------
-- LIBRARY TABLE (and unload any previous copy)
----------------------------------------------------------------------
local Library = {
	Flags = {}, Options = {}, Theme = Theme, Tokens = Tokens, Presets = Presets,
	FX = {
		Aurora = true, Noise = true,
		Particles = false, Grid = false, Scanline = false, Glitch = false, Spotlight = false, Comet = false,
		GradientBorder = false, Glow = false, Brackets = false, Visualizer = false, Typing = false, Scramble = false,
		Stars = false, Cursor = false,
	},
	Settings = { Sounds = false, Blur = false, Watermark = false, ToggleButton = "Auto", Scale = "Auto" },
	FPS = 60, Ping = 0, _uiScale = 1, _alive = true,
	_connections = {}, _spinners = {}, _steppers = {}, _painters = {},
}

if env.__NEXUS_UI and env.__NEXUS_UI.Unload then
	pcall(function() env.__NEXUS_UI:Unload() end)
end
env.__NEXUS_UI = Library

----------------------------------------------------------------------
-- BASIC HELPERS
----------------------------------------------------------------------
local kp = NumberSequenceKeypoint.new

local function create(class, props, children)
	local inst = Instance.new(class)
	local parent
	for k, v in pairs(props or {}) do
		if k == "Parent" then parent = v else inst[k] = v end
	end
	for _, c in ipairs(children or {}) do c.Parent = inst end
	if parent then inst.Parent = parent end
	return inst
end

local function tween(inst, t, props, style, dir)
	local tw = TweenService:Create(inst, TweenInfo.new(t, style or Tokens.Ease.State, dir or Enum.EasingDirection.Out), props)
	tw:Play()
	return tw
end

local function loopTween(inst, t, props, style, reverses)
	local tw = TweenService:Create(inst, TweenInfo.new(t, style or Tokens.Ease.Sine, Enum.EasingDirection.InOut, -1, reverses ~= false), props)
	tw:Play()
	return tw
end

local function corner(r) return create("UICorner", { CornerRadius = UDim.new(0, r) }) end

local function stroke(color, transparency, thickness)
	return create("UIStroke", {
		Color = color or C.White, Transparency = transparency or A.Border, Thickness = thickness or 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	})
end

local function pad(l, t, r, b)
	return create("UIPadding", {
		PaddingLeft = UDim.new(0, l), PaddingTop = UDim.new(0, t or l),
		PaddingRight = UDim.new(0, r or l), PaddingBottom = UDim.new(0, b or t or l),
	})
end

local function vlist(gap, halign)
	return create("UIListLayout", {
		Padding = UDim.new(0, gap or 0), SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = halign or Enum.HorizontalAlignment.Left,
	})
end

local function hlist(gap, valign, halign)
	return create("UIListLayout", {
		Padding = UDim.new(0, gap or 0), SortOrder = Enum.SortOrder.LayoutOrder, FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = valign or Enum.VerticalAlignment.Center, HorizontalAlignment = halign or Enum.HorizontalAlignment.Left,
	})
end

local function seq(...)
	local pts = {}
	for _, p in ipairs({ ... }) do table.insert(pts, ColorSequenceKeypoint.new(p[1], p[2])) end
	return ColorSequence.new(pts)
end

local function track(conn)
	table.insert(Library._connections, conn)
	return conn
end

local function paint(fn)
	table.insert(Library._painters, fn)
	pcall(fn)
end

local function accentProp(inst, prop, key)
	paint(function() inst[prop] = C[key or "Accent"] end)
	return inst
end

local function accentGradient(rotation)
	local g = create("UIGradient", { Rotation = rotation or 0 })
	paint(function() g.Color = seq({ 0, C.Accent }, { 1, C.Accent2 }) end)
	return g
end

local function spin(gradient, speed)
	table.insert(Library._spinners, { g = gradient, s = speed or 60 })
end

local function stepper(fn)
	table.insert(Library._steppers, fn)
	return fn
end

local function unstep(fn)
	for i = #Library._steppers, 1, -1 do
		if Library._steppers[i] == fn then table.remove(Library._steppers, i) end
	end
end

local function fire(cb, ...)
	if type(cb) ~= "function" then return end
	local args = table.pack(...)
	task.spawn(function()
		local ok, err = pcall(cb, table.unpack(args, 1, args.n))
		if not ok then warn("[Nexus] callback error: " .. tostring(err)) end
	end)
end

local function setFlag(cfg, value) if cfg.Flag then Library.Flags[cfg.Flag] = value end end
local function register(cfg, obj) if cfg.Flag then Library.Options[cfg.Flag] = obj end return obj end

local function isPress(input)
	return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
end
local function isMove(input)
	return input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch
end

local function pointIn(gui, pos)
	if not gui or not gui.Parent then return false end
	local p, s = gui.AbsolutePosition, gui.AbsoluteSize
	return pos.X >= p.X and pos.Y >= p.Y and pos.X <= p.X + s.X and pos.Y <= p.Y + s.Y
end

local function round(n) return math.floor(n + 0.5) end

local function toHex(c)
	return string.format("#%02X%02X%02X", round(c.R * 255), round(c.G * 255), round(c.B * 255))
end

local function fromHex(s)
	s = tostring(s or ""):gsub("#", "")
	if #s ~= 6 then return nil end
	local r, g, b = tonumber(s:sub(1, 2), 16), tonumber(s:sub(3, 4), 16), tonumber(s:sub(5, 6), 16)
	if not (r and g and b) then return nil end
	return Color3.fromRGB(r, g, b)
end

local function decimals(n)
	local s = tostring(n)
	local dot = s:find("%.")
	return dot and (#s - dot) or 0
end

local function escapeRich(s)
	s = tostring(s)
	s = s:gsub("&", "&amp;")
	s = s:gsub("<", "&lt;")
	s = s:gsub(">", "&gt;")
	return s
end

local function viewport()
	local cam = workspace.CurrentCamera
	return cam and cam.ViewportSize or Vector2.new(1280, 720)
end

-- Coordinate spaces: GetMouseLocation() is measured from the very top of the screen, while
-- AbsolutePosition / InputObject.Position are measured in GUI space (which can start below the
-- top bar). Origin.frame is a full-screen frame at (0,0) in our root, so its AbsolutePosition is
-- exactly the offset between the two spaces, whatever the inset setting or device.
local Origin = { frame = nil }
local function rootOrigin()
	local f = Origin.frame
	return (f and f.Parent) and f.AbsolutePosition or Vector2.zero
end
-- mouse position in the same space as AbsolutePosition
local function absMouse()
	return UserInputService:GetMouseLocation() + rootOrigin()
end
-- convert an AbsolutePosition-space point into an offset inside the root ScreenGui
local function toRoot(p)
	return p - rootOrigin()
end

----------------------------------------------------------------------
-- TYPOGRAPHY
----------------------------------------------------------------------
local fontCache = {}
local function fontFor(family, weight)
	local name = Tokens.Font[family] or family
	local key = name .. "/" .. weight
	local f = fontCache[key]
	if not f then
		local ok, res = pcall(function() return Font.fromName(name, Enum.FontWeight[weight]) end)
		if not ok then
			ok, res = pcall(function() return Font.new(Font.fromEnum(Enum.Font.Roboto).Family, Enum.FontWeight[weight]) end)
		end
		f = ok and res or Font.fromEnum(Enum.Font.Roboto)
		fontCache[key] = f
	end
	return f
end

local function styleProps(style)
	local st = Tokens.Type[style] or Tokens.Type.Body
	return { FontFace = fontFor(st.Family, st.Weight), TextSize = st.Size, TextColor3 = C[st.Color] }
end

local function Text(parent, style, props)
	local p = {
		BackgroundTransparency = 1, BorderSizePixel = 0, Text = "", Parent = parent,
		TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center,
	}
	for k, v in pairs(styleProps(style)) do p[k] = v end
	for k, v in pairs(props or {}) do p[k] = v end
	return create("TextLabel", p)
end

local function TextInput(parent, style, props)
	local p = {
		BackgroundTransparency = 1, BorderSizePixel = 0, Text = "", Parent = parent, ClearTextOnFocus = false,
		PlaceholderColor3 = C.TextMute, TextXAlignment = Enum.TextXAlignment.Left, ClipsDescendants = true,
	}
	for k, v in pairs(styleProps(style)) do p[k] = v end
	for k, v in pairs(props or {}) do p[k] = v end
	return create("TextBox", p)
end

----------------------------------------------------------------------
-- SURFACES
----------------------------------------------------------------------
local function Surface(parent, props)
	props = props or {}
	local radius = props.Radius or R.Card
	local f = create("Frame", {
		Name = props.Name or "Surface", BackgroundColor3 = props.Color or C.Surface2, BackgroundTransparency = props.Transparency or 0,
		BorderSizePixel = 0, Size = props.Size or UDim2.fromScale(1, 1), Position = props.Position or UDim2.new(),
		AnchorPoint = props.AnchorPoint or Vector2.zero, AutomaticSize = props.AutomaticSize or Enum.AutomaticSize.None,
		ClipsDescendants = props.Clip == true, ZIndex = props.ZIndex or 1, LayoutOrder = props.LayoutOrder or 0, Parent = parent,
	}, { corner(radius) })
	if props.Stroke ~= false then
		local st = stroke(C.White, props.StrokeAlpha or A.Border)
		st.Name = "Border"
		st.Parent = f
	end
	if props.Highlight then
		create("Frame", {
			Name = "Highlight", BackgroundColor3 = C.White, BackgroundTransparency = A.Highlight, BorderSizePixel = 0,
			Position = UDim2.fromOffset(radius, 0), Size = UDim2.new(1, -2 * radius, 0, Z.Divider), ZIndex = (props.ZIndex or 1) + 1, Parent = f,
		})
	end
	return f
end

----------------------------------------------------------------------
-- SHADOWS & GLOWS  (asset-free: stacked rounded layers at low opacity)
----------------------------------------------------------------------
local function Shadow(parent, level, opts)
	opts = opts or {}
	local spec = Tokens.Shadow[level] or Tokens.Shadow.card
	local radius = opts.Radius or R.Card
	local opacity = opts.Opacity or spec.Opacity
	local host = create("Frame", {
		Name = opts.Name or "Shadow", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromOffset(0, opts.Offset or spec.Offset), ZIndex = opts.ZIndex or 1, Parent = parent,
	})
	host:SetAttribute("Opacity", opacity)
	for i = 1, spec.Layers do
		local g = i * spec.Step
		local layer = create("Frame", {
			Name = "Layer", BackgroundColor3 = opts.Color or C.Shadow, BackgroundTransparency = 1 - opacity, BorderSizePixel = 0,
			Position = UDim2.fromOffset(-g, -g), Size = UDim2.new(1, 2 * g, 1, 2 * g), ZIndex = opts.ZIndex or 1, Parent = host,
		}, { corner(radius + g) })
		if opts.Accent then accentProp(layer, "BackgroundColor3") end
	end
	return host
end

local function Glow(parent, opts)
	opts = opts or {}
	opts.Accent = opts.Color == nil
	opts.Offset = 0
	return Shadow(parent, "glow", opts)
end

-- fade a shadow/glow to `factor` (0..1) of its base opacity
local function shadowLevel(host, factor, t)
	local base = host:GetAttribute("Opacity") or 0.05
	for _, l in ipairs(host:GetChildren()) do
		if l:IsA("Frame") then tween(l, t or M.State, { BackgroundTransparency = 1 - base * factor }) end
	end
end

----------------------------------------------------------------------
-- ICONS  (vector, drawn from primitives on a 24×24 grid, Lucide-style)
--   l = line x1 y1 x2 y2 · c = circle cx cy r · d = dot cx cy r · r = rect x y w h radius
----------------------------------------------------------------------
local IconDefs = {
	["x"]                  = { { "l", 18, 6, 6, 18 }, { "l", 6, 6, 18, 18 } },
	["minus"]              = { { "l", 5, 12, 19, 12 } },
	["plus"]               = { { "l", 12, 5, 12, 19 }, { "l", 5, 12, 19, 12 } },
	["check"]              = { { "l", 4.5, 12.5, 9.5, 17.5 }, { "l", 9.5, 17.5, 19.5, 6.5 } },
	["chevron-down"]       = { { "l", 6, 9, 12, 15 }, { "l", 12, 15, 18, 9 } },
	["chevron-up"]         = { { "l", 6, 15, 12, 9 }, { "l", 12, 9, 18, 15 } },
	["chevron-right"]      = { { "l", 9, 6, 15, 12 }, { "l", 15, 12, 9, 18 } },
	["chevrons-up-down"]   = { { "l", 7, 9, 12, 4.5 }, { "l", 12, 4.5, 17, 9 }, { "l", 7, 15, 12, 19.5 }, { "l", 12, 19.5, 17, 15 } },
	["search"]             = { { "c", 11, 11, 7 }, { "l", 16.2, 16.2, 20.5, 20.5 } },
	["info"]               = { { "c", 12, 12, 9.5 }, { "l", 12, 11, 12, 16.5 }, { "d", 12, 7.8, 1.2 } },
	["alert-triangle"]     = { { "l", 12, 3.5, 2.8, 19.5 }, { "l", 2.8, 19.5, 21.2, 19.5 }, { "l", 21.2, 19.5, 12, 3.5 }, { "l", 12, 9.5, 12, 13.5 }, { "d", 12, 16.6, 1.1 } },
	["circle-check"]       = { { "c", 12, 12, 9.5 }, { "l", 8.2, 12.2, 10.8, 14.8 }, { "l", 10.8, 14.8, 15.8, 9.4 } },
	["circle-x"]           = { { "c", 12, 12, 9.5 }, { "l", 15, 9, 9, 15 }, { "l", 9, 9, 15, 15 } },
	["circle-dot"]         = { { "c", 12, 12, 9 }, { "d", 12, 12, 2 } },
	["layout-dashboard"]   = { { "r", 3, 3, 7, 9, 1.5 }, { "r", 14, 3, 7, 5, 1.5 }, { "r", 14, 12, 7, 9, 1.5 }, { "r", 3, 16, 7, 5, 1.5 } },
	["sliders-horizontal"] = { { "l", 21, 5, 14, 5 }, { "l", 10, 5, 3, 5 }, { "l", 21, 12, 12, 12 }, { "l", 8, 12, 3, 12 },
		{ "l", 21, 19, 16, 19 }, { "l", 12, 19, 3, 19 }, { "l", 14, 3, 14, 7 }, { "l", 8, 10, 8, 14 }, { "l", 16, 17, 16, 21 } },
	["list"]               = { { "l", 8.5, 6, 21, 6 }, { "l", 8.5, 12, 21, 12 }, { "l", 8.5, 18, 21, 18 }, { "d", 4, 6, 1.2 }, { "d", 4, 12, 1.2 }, { "d", 4, 18, 1.2 } },
	["keyboard"]           = { { "r", 2, 5, 20, 14, 2 }, { "d", 6.5, 9.5, 0.9 }, { "d", 10, 9.5, 0.9 }, { "d", 13.5, 9.5, 0.9 }, { "d", 17.5, 9.5, 0.9 }, { "l", 7.5, 14.5, 16.5, 14.5 } },
	["palette"]            = { { "c", 12, 12, 9.5 }, { "d", 8, 10, 1.4 }, { "d", 11.5, 7, 1.4 }, { "d", 15.5, 8.5, 1.4 }, { "d", 16.5, 12.8, 1.4 } },
	["settings-2"]         = { { "l", 20, 7, 11, 7 }, { "l", 13, 17, 4, 17 }, { "c", 17, 17, 3 }, { "c", 7, 7, 3 } },
	["sparkles"]           = { { "l", 12, 3, 12, 21 }, { "l", 3, 12, 21, 12 }, { "l", 7, 7, 17, 17 }, { "l", 17, 7, 7, 17 } },
	["zap"]                = { { "l", 13, 2.5, 4.5, 13.5 }, { "l", 4.5, 13.5, 11.5, 13.5 }, { "l", 11.5, 13.5, 11, 21.5 }, { "l", 11, 21.5, 19.5, 10.5 }, { "l", 19.5, 10.5, 12.5, 10.5 }, { "l", 12.5, 10.5, 13, 2.5 } },
	["monitor"]            = { { "r", 2, 3, 20, 14, 2 }, { "l", 8, 21, 16, 21 }, { "l", 12, 17, 12, 21 } },
	["download"]           = { { "l", 12, 3.5, 12, 15 }, { "l", 7, 10, 12, 15 }, { "l", 12, 15, 17, 10 }, { "l", 4, 20, 20, 20 } },
	["upload"]             = { { "l", 12, 15, 12, 3.5 }, { "l", 7, 8.5, 12, 3.5 }, { "l", 12, 3.5, 17, 8.5 }, { "l", 4, 20, 20, 20 } },
	["log-out"]            = { { "l", 9, 4, 5, 4 }, { "l", 5, 4, 5, 20 }, { "l", 5, 20, 9, 20 }, { "l", 15.5, 16.5, 20, 12 }, { "l", 20, 12, 15.5, 7.5 }, { "l", 20, 12, 9.5, 12 } },
	["terminal"]           = { { "l", 4.5, 16.5, 10, 11 }, { "l", 10, 11, 4.5, 5.5 }, { "l", 12, 19, 20, 19 } },
	["bell"]               = { { "l", 6, 16, 6, 10.5 }, { "l", 18, 16, 18, 10.5 }, { "c", 12, 10.5, 6 }, { "l", 4.5, 16.5, 19.5, 16.5 }, { "l", 10.5, 20, 13.5, 20 } },
	["user"]               = { { "c", 12, 8, 4 }, { "l", 5, 20.5, 7.5, 15.5 }, { "l", 7.5, 15.5, 16.5, 15.5 }, { "l", 16.5, 15.5, 19, 20.5 } },
	["refresh"]            = { { "c", 12, 12, 8 }, { "l", 17.5, 3, 20, 6 }, { "l", 20, 6, 16.5, 7.5 } },
	["copy"]               = { { "r", 8, 8, 13, 13, 2 }, { "l", 4, 16, 4, 5 }, { "l", 4, 4, 15, 4 } },
	["trash"]              = { { "l", 3.5, 6, 20.5, 6 }, { "r", 5.5, 6, 13, 15, 2 }, { "l", 9.5, 3, 14.5, 3 }, { "l", 10, 10.5, 10, 16.5 }, { "l", 14, 10.5, 14, 16.5 } },
	["mark"]               = { { "l", 7.5, 17, 7.5, 7 }, { "l", 7.5, 7, 16.5, 17 }, { "l", 16.5, 17, 16.5, 7 } },
}
local GlyphIcons = {
	["◈"] = "layout-dashboard", ["▣"] = "sliders-horizontal", ["☰"] = "list", ["⌨"] = "keyboard",
	["✦"] = "palette", ["⚙"] = "settings-2", ["×"] = "x", ["–"] = "minus", ["✓"] = "check", ["▼"] = "chevron-down",
}

local function resolveIcon(name)
	if type(name) ~= "string" then return "circle-dot" end
	if IconDefs[name] then return name end
	if GlyphIcons[name] then return GlyphIcons[name] end
	local lower = string.lower(name)
	if IconDefs[lower] then return lower end
	return "circle-dot"
end

local function Icon(name, size, color, parent)
	local def = IconDefs[resolveIcon(name)]
	size = size or Z.Icon
	color = color or C.TextDim
	local k = size / 24
	local t = (size <= Z.Icon) and 1.5 or math.max(1.5, round(size / 12 * 10) / 10)
	local root = create("Frame", { Name = "Icon", BackgroundTransparency = 1, Size = UDim2.fromOffset(size, size), Parent = parent })
	root:SetAttribute("IconName", resolveIcon(name))
	root:SetAttribute("Unit", k)
	for idx, p in ipairs(def) do
		local kind, f = p[1], nil
		if kind == "l" then
			local x1, y1, x2, y2 = p[2] * k, p[3] * k, p[4] * k, p[5] * k
			local dx, dy = x2 - x1, y2 - y1
			f = create("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset((x1 + x2) / 2, (y1 + y2) / 2),
				Size = UDim2.fromOffset(math.sqrt(dx * dx + dy * dy) + t, t), Rotation = math.deg(math.atan2(dy, dx)),
				BackgroundColor3 = color, BorderSizePixel = 0, Parent = root,
			}, { corner(R.Pill) })
			f:SetAttribute("Fill", true)
		elseif kind == "c" then
			local d = p[4] * 2 * k - t
			f = create("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(p[2] * k, p[3] * k), Size = UDim2.fromOffset(d, d),
				BackgroundTransparency = 1, Parent = root,
			}, { corner(R.Pill), create("UIStroke", { Color = color, Thickness = t, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }) })
		elseif kind == "d" then
			local d = math.max(p[4] * 2 * k, t)
			f = create("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(p[2] * k, p[3] * k), Size = UDim2.fromOffset(d, d),
				BackgroundColor3 = color, BorderSizePixel = 0, Parent = root,
			}, { corner(R.Pill) })
			f:SetAttribute("Fill", true)
		elseif kind == "r" then
			f = create("Frame", {
				Position = UDim2.fromOffset(p[2] * k + t / 2, p[3] * k + t / 2), Size = UDim2.fromOffset(p[4] * k - t, p[5] * k - t),
				BackgroundTransparency = 1, Parent = root,
			}, { corner(round(p[6] * k)), create("UIStroke", { Color = color, Thickness = t, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }) })
		end
		if f then
			f.Name = "P" .. idx
			f:SetAttribute("BasePos", f.Position)
			f:SetAttribute("BaseSize", f.Size)
		end
	end
	return root
end

local function tintIcon(icon, color, t)
	for _, d in ipairs(icon:GetDescendants()) do
		if d:IsA("UIStroke") then
			tween(d, t or 0, { Color = color })
		elseif d:IsA("Frame") and d:GetAttribute("Fill") then
			tween(d, t or 0, { BackgroundColor3 = color })
		end
	end
end

local function fadeIcon(icon, transparency, t)
	for _, d in ipairs(icon:GetDescendants()) do
		if d:IsA("UIStroke") then
			tween(d, t or 0, { Transparency = transparency })
		elseif d:IsA("Frame") and d:GetAttribute("Fill") then
			tween(d, t or 0, { BackgroundTransparency = transparency })
		end
	end
end

-- the Nexus logo mark: accent tile with an "N" monogram
local function LogoMark(parent, size)
	size = size or Z.Logo
	local tile = create("Frame", {
		Name = "Logo", Size = UDim2.fromOffset(size, size), BackgroundColor3 = C.White, BorderSizePixel = 0, Parent = parent,
	}, { corner(round(size * 0.3)) })
	accentGradient(135).Parent = tile
	create("Frame", {
		Name = "Highlight", BackgroundColor3 = C.White, BackgroundTransparency = 0.75, BorderSizePixel = 0,
		Position = UDim2.fromOffset(round(size * 0.3), 0), Size = UDim2.new(1, -2 * round(size * 0.3), 0, 1), Parent = tile,
	})
	local glyph = Icon("mark", round(size * 0.78), C.White, tile)
	glyph.AnchorPoint = Vector2.new(0.5, 0.5)
	glyph.Position = UDim2.fromScale(0.5, 0.5)
	return tile
end

----------------------------------------------------------------------
-- SPRINGS  (critically/under-damped, stepped by the single render loop)
----------------------------------------------------------------------
local ActiveSprings = {}
local Spring = {}
Spring.__index = Spring

local function spring(x0, cfg, onUpdate)
	cfg = cfg or Tokens.Spring.Indicator
	local w, z = cfg.Speed, cfg.Damping
	if cfg.K then
		local m = cfg.Mass or 1
		w = math.sqrt(cfg.K / m)
		z = cfg.C / (2 * math.sqrt(cfg.K * m))
	end
	return setmetatable({ x = x0, v = 0, target = x0, w = w, z = z, eps = cfg.Eps or 0.01, on = onUpdate }, Spring)
end
function Spring:Kick(velocity)
	self.v = self.v + velocity
	ActiveSprings[self] = true
end
function Spring:Set(target)
	self.target = target
	ActiveSprings[self] = true
end
function Spring:Snap(value)
	self.x, self.target, self.v = value, value, 0
	ActiveSprings[self] = nil
	if self.on then self.on(value) end
end

local function stepSprings(dt)
	dt = math.min(dt, 0.1)
	local steps = math.max(1, math.ceil(dt * 240))
	local h = dt / steps
	for s in pairs(ActiveSprings) do
		for _ = 1, steps do
			local acc = -s.w * s.w * (s.x - s.target) - 2 * s.z * s.w * s.v
			s.v = s.v + acc * h
			s.x = s.x + s.v * h
		end
		if math.abs(s.x - s.target) < s.eps and math.abs(s.v) < s.eps * 10 then
			s.x, s.v = s.target, 0
			ActiveSprings[s] = nil
		end
		if s.on then
			local ok, err = pcall(s.on, s.x)
			if not ok then ActiveSprings[s] = nil; warn("[Nexus] spring error: " .. tostring(err)) end
		end
	end
end

----------------------------------------------------------------------
-- TEXT SCRAMBLE (cinematic only)
----------------------------------------------------------------------
local GLYPHS = "!<>-_/[]{}=+*^?#%$&ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
local scrambleTokens = setmetatable({}, { __mode = "k" })
local function scramble(lbl, final, duration)
	duration = duration or 0.6
	local token = {}
	scrambleTokens[lbl] = token
	local chars = {}
	for _, code in utf8.codes(final) do table.insert(chars, utf8.char(code)) end
	task.spawn(function()
		local start = os.clock()
		while true do
			if scrambleTokens[lbl] ~= token or not lbl.Parent then return end
			local p = math.clamp((os.clock() - start) / duration, 0, 1)
			local reveal = math.floor(#chars * p)
			local out = {}
			for i, ch in ipairs(chars) do
				if i <= reveal or ch == " " then out[i] = ch else
					local r = math.random(1, #GLYPHS)
					out[i] = GLYPHS:sub(r, r)
				end
			end
			lbl.Text = table.concat(out)
			if p >= 1 then break end
			task.wait(0.03)
		end
		lbl.Text = final
	end)
end
local function setText(lbl, text, scrambleDuration)
	if Library.FX.Scramble then scramble(lbl, text, scrambleDuration) else
		scrambleTokens[lbl] = nil
		lbl.Text = text
	end
end

----------------------------------------------------------------------
-- SOUND (off by default)
----------------------------------------------------------------------
local Sounds = {}
local function sfx(name, pitch)
	if not Library.Settings.Sounds then return end
	local s = Sounds[name]
	if s then
		s.PlaybackSpeed = pitch or 1
		pcall(function() s:Play() end)
	end
end

----------------------------------------------------------------------
-- MOTION PRIMITIVES  (patterns adapted from animate-ui.com)
----------------------------------------------------------------------
local TextService = game:GetService("TextService")
local NBSP = utf8.char(160)

-- Highlight: one shared surface that springs between hovered items (animate-ui "Highlight", parent mode)
--   container must hold the highlight frame AND the items (items may live in a nested list)
local function Highlight(container, opts)
	opts = opts or {}
	local inset = opts.Inset or Vector2.new(S.XS, 2)
	local horizontal = opts.Horizontal == true
	local frame = create("Frame", {
		Name = "Highlight", BackgroundColor3 = opts.Color or C.Surface3, BackgroundTransparency = 1, BorderSizePixel = 0,
		Size = UDim2.fromOffset(0, 0), ZIndex = opts.ZIndex or 1, Parent = container,
	}, { corner(opts.Radius or R.Small) })
	local shown = opts.Alpha or 0
	local pos, len
	local function apply()
		if horizontal then
			frame.Position = UDim2.fromOffset(round(pos.x), inset.Y)
			frame.Size = UDim2.new(0, round(len.x), 1, -2 * inset.Y)
		else
			frame.Position = UDim2.fromOffset(inset.X, round(pos.x))
			frame.Size = UDim2.new(1, -2 * inset.X, 0, round(len.x))
		end
	end
	pos = spring(0, Tokens.Spring.Highlight, apply)
	len = spring(0, Tokens.Spring.Highlight, apply)
	local visible, current, leaveToken = false, nil, nil

	local api = { Frame = frame }
	function api:Move(item)
		if not item or not item.Parent then return end
		local s = Library._uiScale
		local rel = (item.AbsolutePosition - container.AbsolutePosition) / s
		local size = item.AbsoluteSize / s
		local p, l
		if horizontal then p, l = rel.X + inset.X, size.X - 2 * inset.X else p, l = rel.Y + inset.Y, size.Y - 2 * inset.Y end
		leaveToken = nil
		current = item
		if not visible then
			visible = true
			pos:Snap(p); len:Snap(l)
			tween(frame, M.Hover, { BackgroundTransparency = shown })
		else
			pos:Set(p); len:Set(l)
		end
	end
	function api:Leave(item)
		if item and current ~= item then return end
		local t = {}
		leaveToken = t
		task.delay(M.ExitDelay, function()
			if leaveToken ~= t then return end
			visible, current = false, nil
			tween(frame, M.Hover, { BackgroundTransparency = 1 })
		end)
	end
	function api:Hide()
		leaveToken, visible, current = nil, false, nil
		frame.BackgroundTransparency = 1
	end
	function api:Attach(item, target)
		target = target or item
		target.MouseEnter:Connect(function() api:Move(item) end)
		target.MouseLeave:Connect(function() api:Leave(item) end)
	end
	function api:Refresh() if current then api:Move(current) end end
	return api
end

-- monospace advance width (measurement only; rendering uses FontFace)
local advanceCache = {}
local function monoAdvance(size)
	if advanceCache[size] then return advanceCache[size] end
	local ok, v = pcall(function()
		return TextService:GetTextSize("0000000000", size, Enum.Font.RobotoMono, Vector2.new(10000, 1000)).X / 10
	end)
	local adv = (ok and v and v > 0) and v or size * 0.6
	advanceCache[size] = adv
	return adv
end

-- SlidingNumber: every digit is a wheel that springs to its new value (animate-ui "Sliding Number")
local function SlidingNumber(parent, props)
	props = props or {}
	local styleName = props.Style or "Mono"
	local sp = styleProps(styleName)
	local lineH = props.LineHeight or (sp.TextSize + 4)
	local adv = math.ceil(monoAdvance(sp.TextSize))
	local color = props.Color or sp.TextColor3
	local holder = create("Frame", {
		Name = "SlidingNumber", BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, lineH),
		AnchorPoint = props.AnchorPoint or Vector2.zero, Position = props.Position or UDim2.new(), LayoutOrder = props.LayoutOrder or 0,
		ZIndex = props.ZIndex or 1, Parent = parent,
	}, { hlist(0, Enum.VerticalAlignment.Center) })
	local cols, value = {}, nil
	local dec = props.Decimals or 0

	local function format(v)
		local str = string.format("%." .. dec .. "f", math.abs(v))
		if props.Pad then
			local int, frac = str:match("^(%d+)(.*)$")
			if int and #int < props.Pad then str = string.rep("0", props.Pad - #int) .. int .. frac end
		end
		if props.Thousands then
			local int, frac = str:match("^(%d+)(.*)$")
			if int then
				int = int:reverse():gsub("(%d%d%d)", "%1,"):reverse()
				if int:sub(1, 1) == "," then int = int:sub(2) end
				str = int .. frac
			end
		end
		return (v < 0 and "-" or "") .. (props.Prefix or "") .. str .. (props.Suffix or "")
	end
	local function tokenize(str)
		local out, lit = {}, ""
		for _, code in utf8.codes(str) do
			local ch = utf8.char(code)
			if ch:match("^%d$") then
				if lit ~= "" then table.insert(out, { "t", lit }); lit = "" end
				table.insert(out, { "d", tonumber(ch) })
			else
				lit = lit .. ch
			end
		end
		if lit ~= "" then table.insert(out, { "t", lit }) end
		return out
	end
	local function makeDigit(order, start)
		local f = create("Frame", { BackgroundTransparency = 1, ClipsDescendants = true, Size = UDim2.fromOffset(adv, lineH), LayoutOrder = order, Parent = holder })
		local strip = create("Frame", { BackgroundTransparency = 1, Size = UDim2.fromOffset(adv, lineH * 10), Parent = f })
		for d = 0, 9 do
			Text(strip, styleName, { Text = tostring(d), TextColor3 = color, TextXAlignment = Enum.TextXAlignment.Center,
				Position = UDim2.fromOffset(0, d * lineH), Size = UDim2.fromOffset(adv, lineH) })
		end
		local col = { kind = "d", frame = f, strip = strip }
		col.spring = spring(start, Tokens.Spring.Digit, function(x) strip.Position = UDim2.fromOffset(0, -x * lineH) end)
		col.spring:Snap(start)
		return col
	end
	local function makeText(order, text)
		local l = Text(holder, styleName, { Text = text, TextColor3 = color, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 1, 0), LayoutOrder = order })
		return { kind = "t", frame = l, text = text }
	end

	local api = { Holder = holder }
	function api:Set(v, instant)
		v = tonumber(v) or 0
		local toks = tokenize(format(v))
		local same = #toks == #cols
		if same then
			for i, t in ipairs(toks) do
				if t[1] ~= cols[i].kind or (t[1] == "t" and t[2] ~= cols[i].text) then same = false break end
			end
		end
		if not same then
			local old = {}
			for i = #cols, 1, -1 do if cols[i].kind == "d" then table.insert(old, cols[i].spring.x) end end
			for _, c in ipairs(cols) do c.frame:Destroy() end
			cols = {}
			local digits = 0
			for _, t in ipairs(toks) do if t[1] == "d" then digits = digits + 1 end end
			local seen = 0
			for i, t in ipairs(toks) do
				if t[1] == "d" then
					seen = seen + 1
					local start = old[digits - seen + 1]
					cols[i] = makeDigit(i, instant and t[2] or (start or 0))
				else
					cols[i] = makeText(i, t[2])
				end
			end
		end
		for i, t in ipairs(toks) do
			if t[1] == "d" then
				if instant then cols[i].spring:Snap(t[2]) else cols[i].spring:Set(t[2]) end
			end
		end
		value = v
	end
	-- count from the current value to `target` on a slow spring, digits rolling along the way
	local counter
	function api:CountTo(target)
		if not counter then
			counter = spring(value or 0, Tokens.Spring.Count, function(x) api:Set(round(x * 10 ^ dec) / 10 ^ dec) end)
		end
		counter:Set(target)
	end
	function api:SetColor(c)
		color = c
		for _, col in ipairs(cols) do
			if col.kind == "d" then
				for _, l in ipairs(col.strip:GetChildren()) do if l:IsA("TextLabel") then l.TextColor3 = c end end
			else
				col.frame.TextColor3 = c
			end
		end
	end
	function api:Get() return value end
	api:Set(props.Value or 0, true)
	return api
end

-- RollingText: letters roll up into place one after another (animate-ui "Rolling Text")
local function RollingText(parent, styleName, props)
	props = props or {}
	local h = props.Height or (styleProps(styleName).TextSize + 6)
	local holder = create("Frame", {
		Name = "RollingText", BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, h),
		LayoutOrder = props.LayoutOrder or 0, Parent = parent,
	}, { hlist(0, Enum.VerticalAlignment.Center) })
	local cells = {}
	local api = { Holder = holder, Text = "" }
	function api:SetText(text)
		for _, c in ipairs(cells) do c.cell:Destroy() end
		cells = {}
		local i = 0
		for _, code in utf8.codes(text) do
			i = i + 1
			local ch = utf8.char(code)
			if ch == " " then ch = NBSP end
			local cell = create("Frame", { BackgroundTransparency = 1, ClipsDescendants = true, AutomaticSize = Enum.AutomaticSize.X,
				Size = UDim2.new(0, 0, 1, 0), LayoutOrder = i, Parent = holder })
			local lbl = Text(cell, styleName, { Text = ch, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 1, 0), TextColor3 = props.Color })
			cells[i] = { cell = cell, lbl = lbl }
		end
		self.Text = text
	end
	function api:Play()
		for i, c in ipairs(cells) do
			c.lbl.Position = UDim2.new(0, 0, 0.85, 0)
			c.lbl.TextTransparency = 1
			task.delay(math.min((i - 1) * M.CharStagger, M.CharStaggerCap), function()
				if c.lbl.Parent then tween(c.lbl, M.Roll, { Position = UDim2.new(), TextTransparency = 0 }, Tokens.Ease.Enter) end
			end)
		end
	end
	if props.Text then api:SetText(props.Text) end
	return api
end

-- swapText: old text slides out, new text slides in (animate-ui "Swapping Text"); parent should clip
local function swapText(lbl, text, dir)
	if lbl.Text == text then return end
	local base = lbl:GetAttribute("SwapBase")
	if not base then
		base = lbl.Position
		lbl:SetAttribute("SwapBase", base)
	end
	local d = round(lbl.AbsoluteSize.Y / Library._uiScale * 0.7) * (dir or 1)
	local ghost = lbl:Clone()
	ghost.Position = base
	ghost.Parent = lbl.Parent
	lbl.Text = text
	lbl.Position = base + UDim2.fromOffset(0, d)
	lbl.TextTransparency = 1
	tween(lbl, M.Enter, { Position = base, TextTransparency = 0 }, Tokens.Ease.Enter)
	tween(ghost, M.Exit, { Position = base - UDim2.fromOffset(0, d), TextTransparency = 1 }, Tokens.Ease.Exit, Enum.EasingDirection.In)
	task.delay(M.Exit, function() ghost:Destroy() end)
end

-- shimmering text: a bright band sweeps across the glyphs (animate-ui "Shimmering Text")
local function shimmer(lbl, loop)
	lbl.TextColor3 = C.White
	local g = create("UIGradient", {
		Color = seq({ 0, C.TextDim }, { 0.42, C.TextDim }, { 0.5, C.White }, { 0.58, C.TextDim }, { 1, C.TextDim }),
		Offset = Vector2.new(-1, 0), Parent = lbl,
	})
	TweenService:Create(g, TweenInfo.new(M.Shimmer, Tokens.Ease.Linear, Enum.EasingDirection.InOut, loop and -1 or 0), { Offset = Vector2.new(1, 0) }):Play()
	return g
end

-- drawn check mark: strokes extend along the path (animate-ui Checkbox "draw")
local function CheckMark(parent, size, color)
	local host = create("Frame", { Name = "Check", BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(size, size), ZIndex = 3, Parent = parent })
	local k, t = size / 24, 2
	local pts = { Vector2.new(4.5, 12.5) * k, Vector2.new(9.5, 17.5) * k, Vector2.new(19.5, 6.5) * k }
	local segs, lens = {}, {}
	for i = 1, 2 do
		local d = pts[i + 1] - pts[i]
		segs[i] = create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = color, BorderSizePixel = 0,
			Rotation = math.deg(math.atan2(d.Y, d.X)), Visible = false, ZIndex = 3, Parent = host }, { corner(R.Pill) })
		lens[i] = d.Magnitude
	end
	local total = lens[1] + lens[2]
	local function draw(p)
		local drawn = p * total
		for i = 1, 2 do
			local l = math.clamp(drawn - (i == 2 and lens[1] or 0), 0, lens[i])
			local seg = segs[i]
			if l <= 0.05 then seg.Visible = false else
				seg.Visible = true
				local dir = (pts[i + 1] - pts[i]).Unit
				local c = pts[i] + dir * (l / 2)
				seg.Position = UDim2.fromOffset(c.X, c.Y)
				seg.Size = UDim2.fromOffset(l + t, t)
			end
		end
	end
	local progress = create("NumberValue", { Value = 0, Parent = host })
	progress.Changed:Connect(draw)
	local api = { Host = host }
	function api:Set(on, animate)
		if not animate then progress.Value = on and 1 or 0; draw(progress.Value) return end
		local info = on and TweenInfo.new(M.Draw, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, M.DrawDelay)
			or TweenInfo.new(M.Draw, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		TweenService:Create(progress, info, { Value = on and 1 or 0 }):Play()
	end
	return api
end

-- loading spinner: arc that rotates
local function Spinner(parent, size, color)
	local f = create("Frame", { Name = "Spinner", BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(size - 2, size - 2), Parent = parent }, { corner(R.Pill) })
	local st = create("UIStroke", { Color = color or C.White, Thickness = 2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = f })
	local g = create("UIGradient", { Transparency = NumberSequence.new({ kp(0, 0), kp(0.65, 0.85), kp(0.66, 1), kp(1, 1) }), Parent = st })
	spin(g, 400)
	return f, st
end

-- animated icons (animate-ui "Icons"): each icon has its own hover motion
local function popScale(icon, from)
	local sc = icon:FindFirstChild("Pop") or create("UIScale", { Name = "Pop", Parent = icon })
	local sp = spring(from or 0.8, Tokens.Spring.Pop, function(x) sc.Scale = x end)
	sp:Snap(from or 0.8)
	sp:Set(1)
end
local function seqTween(inst, prop, values, dt)
	task.spawn(function()
		for _, v in ipairs(values) do
			if not inst.Parent then return end
			tween(inst, dt, { [prop] = v }, Tokens.Ease.Sine, Enum.EasingDirection.InOut)
			task.wait(dt)
		end
	end)
end
local function part(icon, i) return icon:FindFirstChild("P" .. i) end
local function nudge(icon, idx, dx, dy, dt)
	local p = part(icon, idx)
	if not p then return end
	local base, k = p:GetAttribute("BasePos"), icon:GetAttribute("Unit") or 1
	seqTween(p, "Position", { base + UDim2.fromOffset(dx * k, dy * k), base }, dt or M.Hover * 1.5)
end
local IconMotion = {
	["bell"] = function(ic) seqTween(ic, "Rotation", { 16, -14, 10, -6, 3, 0 }, M.Beat) end,
	["settings-2"] = function(ic) nudge(ic, 3, -4, 0, 0.18); nudge(ic, 4, 4, 0, 0.18) end,
	["sliders-horizontal"] = function(ic) nudge(ic, 7, -3, 0); nudge(ic, 8, 3, 0); nudge(ic, 9, -3, 0) end,
	["refresh"] = function(ic) ic.Rotation = 0; tween(ic, 0.6, { Rotation = 360 }, Tokens.Ease.Enter); task.delay(0.6, function() ic.Rotation = 0 end) end,
	["zap"] = function(ic) popScale(ic, 0.7); seqTween(ic, "Rotation", { -10, 0 }, M.Beat) end,
	["download"] = function(ic) for i = 1, 3 do nudge(ic, i, 0, 3) end end,
	["upload"] = function(ic) for i = 1, 3 do nudge(ic, i, 0, -3) end end,
	["log-out"] = function(ic) for i = 4, 6 do nudge(ic, i, 3, 0) end end,
	["layout-dashboard"] = function(ic) nudge(ic, 1, 0, -1.5); nudge(ic, 2, 0, 1.5); nudge(ic, 3, 0, -1.5); nudge(ic, 4, 0, 1.5) end,
	["list"] = function(ic) for i = 4, 6 do task.delay((i - 4) * 0.06, function() nudge(ic, i, 2.5, 0) end) end end,
	["keyboard"] = function(ic)
		for i = 2, 5 do
			task.delay((i - 2) * 0.05, function()
				local p = part(ic, i)
				if p then seqTween(p, "BackgroundTransparency", { 0.8, 0 }, M.Beat) end
			end)
		end
	end,
	["palette"] = function(ic) seqTween(ic, "Rotation", { -24, 8, 0 }, M.Beat * 1.5) end,
	["search"] = function(ic) seqTween(ic, "Rotation", { -14, 6, 0 }, M.Beat * 1.5) end,
	["copy"] = function(ic) nudge(ic, 1, -2, -2) end,
	["trash"] = function(ic) nudge(ic, 1, 0, -2); nudge(ic, 3, 0, -2) end,
	["chevron-right"] = function(ic) nudge(ic, 1, 3, 0); nudge(ic, 2, 3, 0) end,
	["user"] = function(ic) nudge(ic, 1, 0, -1.5) end,
}
local function animateIcon(icon)
	if not icon or not icon.Parent or icon:GetAttribute("Busy") then return end
	icon:SetAttribute("Busy", true)
	local fn = IconMotion[icon:GetAttribute("IconName") or ""] or function(ic) popScale(ic, 0.82) end
	pcall(fn, icon)
	task.delay(0.55, function() if icon.Parent then icon:SetAttribute("Busy", nil) end end)
end

-- Magnetic: elements lean toward the pointer within a range (animate-ui "Magnetic")
local Magnets, magnetStep = {}, nil
local function magnetic(target, anchor, opts)
	opts = opts or {}
	local base = target.Position
	local m = { target = target, anchor = anchor or target.Parent, range = opts.Range or Z.MagnetRange,
		strength = opts.Strength or Z.MagnetStrength, active = opts.Active, tx = 0, ty = 0 }
	local function apply() target.Position = base + UDim2.fromOffset(round(m.sx.x), round(m.sy.x)) end
	m.sx = spring(0, Tokens.Spring.Magnetic, apply)
	m.sy = spring(0, Tokens.Spring.Magnetic, apply)
	table.insert(Magnets, m)
	if not magnetStep then
		magnetStep = stepper(function()
			if #Magnets == 0 then return end
			if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then return end
			local mouse = absMouse()
			local s = Library._uiScale
			for i = #Magnets, 1, -1 do
				local mg = Magnets[i]
				if not mg.target.Parent then
					table.remove(Magnets, i)
				else
					local tx, ty = 0, 0
					if not mg.active or mg.active() then
						local c = mg.anchor.AbsolutePosition + mg.anchor.AbsoluteSize / 2
						local d = mouse - c
						local dist = d.Magnitude / s
						if dist < mg.range then
							local f = (1 - dist / mg.range) * mg.strength
							tx, ty = d.X / s * f, d.Y / s * f
						end
					end
					if math.abs(tx - mg.tx) > 0.25 or math.abs(ty - mg.ty) > 0.25 then
						mg.tx, mg.ty = tx, ty
						mg.sx:Set(tx); mg.sy:Set(ty)
					end
				end
			end
		end)
	end
	return m
end

-- press feedback on a spring: dips to M.Tap and springs back (animate-ui tapScale)
local function tapSpring(scaleObj, button)
	local sp = spring(1, Tokens.Spring.Tap, function(x) scaleObj.Scale = x end)
	button.MouseButton1Down:Connect(function() sp:Set(M.Tap) end)
	local function up() sp:Set(1) end
	button.MouseButton1Up:Connect(up)
	button.MouseLeave:Connect(up)
	return sp
end

----------------------------------------------------------------------
-- ROOT GUI, LAYERS AND THE SINGLE RENDER LOOP
----------------------------------------------------------------------
local Layers = {}
local closePopover -- forward declaration

local function getRoot()
	if Library._root and Library._root.Parent then return Library._root end

	local gui = create("ScreenGui", {
		Name = "NEXUS_UI", ResetOnSpawn = false, IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 9999,
	})
	if typeof(syn) == "table" and syn.protect_gui then pcall(syn.protect_gui, gui) end

	local mounted = false
	if typeof(gethui) == "function" then
		mounted = pcall(function() gui.Parent = gethui() end) and gui.Parent ~= nil
	end
	if not mounted then
		mounted = pcall(function() gui.Parent = game:GetService("CoreGui") end) and gui.Parent ~= nil
	end
	if not mounted then
		gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	end
	Library._root = gui

	-- layers (bottom → top)
	Layers.Backdrop = create("Frame", {
		Name = "Backdrop", Size = UDim2.fromScale(1, 1), BackgroundColor3 = C.Bg, BackgroundTransparency = 1,
		BorderSizePixel = 0, Visible = false, ZIndex = 1, Parent = gui,
	}, { create("UIGradient", { Rotation = 90, Transparency = NumberSequence.new({ kp(0, 0), kp(0.5, 0.45), kp(1, 0) }) }) })
	Layers.Overlay = create("Frame", { Name = "Overlay", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 400, Parent = gui })
	Layers.OverlayScale = create("UIScale", { Scale = Library._uiScale, Parent = Layers.Overlay })
	Layers.Scrim = create("TextButton", { Name = "Scrim", Size = UDim2.fromScale(1, 1), BackgroundColor3 = C.Bg, BackgroundTransparency = 1,
		AutoButtonColor = false, Text = "", BorderSizePixel = 0, Visible = false, ZIndex = 440, Parent = gui })
	Layers.Toasts = create("Frame", { Name = "Toasts", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 500, Parent = gui })
	Origin.frame = Layers.Toasts

	-- sounds (silent unless Settings.Sounds = true)
	local folder = create("Folder", { Name = "NexusSounds", Parent = SoundService })
	Library._soundFolder = folder
	Sounds.click  = create("Sound", { SoundId = "rbxasset://sounds/clickfast.wav", Volume = 0.25, Parent = folder })
	Sounds.notify = create("Sound", { SoundId = "rbxasset://sounds/electronicpingshort.wav", Volume = 0.2, Parent = folder })

	-- popovers close on outside click / Esc
	track(UserInputService.InputBegan:Connect(function(input)
		local p = Library._popover
		if not p then return end
		if input.KeyCode == Enum.KeyCode.Escape then closePopover() return end
		if isPress(input) or input.UserInputType == Enum.UserInputType.MouseButton2 then
			local pos = Vector2.new(input.Position.X, input.Position.Y)
			if not pointIn(p.surface, pos) and not pointIn(p.anchor, pos) then closePopover() end
		end
	end))

	-- the one render loop
	local frames, last = 0, os.clock()
	track(RunService.RenderStepped:Connect(function(dt)
		local now = os.clock()
		if next(ActiveSprings) then stepSprings(dt) end
		local spinners = Library._spinners
		for i = #spinners, 1, -1 do
			local s = spinners[i]
			if s.g.Parent then s.g.Rotation = (now * s.s) % 360 else table.remove(spinners, i) end
		end
		local steppers = Library._steppers
		for i = #steppers, 1, -1 do
			local fn = steppers[i]
			if fn then
				local ok, err = pcall(fn, dt, now)
				if not ok then
					warn("[Nexus] stepper removed: " .. tostring(err))
					table.remove(steppers, i)
				end
			end
		end
		frames = frames + 1
		if now - last >= 0.5 then
			Library.FPS = round(frames / (now - last))
			frames, last = 0, now
		end
	end))
	return gui
end

----------------------------------------------------------------------
-- FILM GRAIN (EditableImage, generated at runtime; skipped if unsupported)
----------------------------------------------------------------------
local function noiseContent()
	if Library._noise ~= nil then return Library._noise end
	local ok, content = pcall(function()
		local AssetService = game:GetService("AssetService")
		local n = Tokens.NoiseSize
		local img = AssetService:CreateEditableImage({ Size = Vector2.new(n, n) })
		local buf = buffer.create(n * n * 4)
		local rng = Random.new(7)
		for i = 0, n * n - 1 do
			local v = rng:NextInteger(0, 255)
			buffer.writeu8(buf, i * 4, v)
			buffer.writeu8(buf, i * 4 + 1, v)
			buffer.writeu8(buf, i * 4 + 2, v)
			buffer.writeu8(buf, i * 4 + 3, 255)
		end
		img:WritePixelsBuffer(Vector2.zero, Vector2.new(n, n), buf)
		Library._noiseImage = img
		return Content.fromObject(img)
	end)
	Library._noise = ok and content or false
	return Library._noise
end

----------------------------------------------------------------------
-- SCROLLER (custom thumb · edge fades · progress callback)
--   animate-ui: "Scroll Fade" + "Scroll Progress"
----------------------------------------------------------------------
local function Scroller(parent, props)
	props = props or {}
	local host = create("Frame", {
		Name = "ScrollHost", BackgroundTransparency = 1, Size = props.Size or UDim2.fromScale(1, 1),
		Position = props.Position or UDim2.new(), Parent = parent,
	})
	local sf = create("ScrollingFrame", {
		Name = "Scroll", BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1),
		ScrollBarThickness = 0, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y, Parent = host,
	})
	local thumb = create("Frame", {
		Name = "Thumb", AnchorPoint = Vector2.new(1, 0), BackgroundColor3 = C.White, BackgroundTransparency = 1,
		BorderSizePixel = 0, Size = UDim2.fromOffset(Z.ScrollThumb, 0), ZIndex = 20, Parent = host,
	}, { corner(R.Pill) })
	local fadeTop, fadeBottom
	if props.FadeColor then
		fadeTop = create("Frame", { Name = "FadeTop", BackgroundColor3 = props.FadeColor, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, Z.Fade),
			BackgroundTransparency = 1, ZIndex = 18, Parent = host }, { create("UIGradient", { Rotation = 90, Transparency = NumberSequence.new(0, 1) }) })
		fadeBottom = create("Frame", { Name = "FadeBottom", AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), BackgroundColor3 = props.FadeColor,
			BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, Z.Fade), BackgroundTransparency = 1, ZIndex = 18, Parent = host },
			{ create("UIGradient", { Rotation = 90, Transparency = NumberSequence.new(1, 0) }) })
	end
	local hovering, token = false, nil
	local topOn, bottomOn = false, false
	local function show(on)
		tween(thumb, on and M.Hover or M.State, { BackgroundTransparency = on and A.Scroll or 1 })
	end
	local function update()
		local view, canvas = sf.AbsoluteWindowSize.Y, sf.AbsoluteCanvasSize.Y
		local scrollable = canvas > view + 1 and view > 0
		local frac = scrollable and math.clamp(sf.CanvasPosition.Y * Library._uiScale / (canvas - view), 0, 1) or 0
		thumb.Visible = scrollable
		if scrollable then
			local ratio = view / canvas
			thumb.Size = UDim2.new(0, Z.ScrollThumb, ratio, -2 * Z.ScrollInset)
			thumb.Position = UDim2.new(1, -Z.ScrollInset, frac * (1 - ratio), Z.ScrollInset)
		end
		if fadeTop then
			local t, b = scrollable and frac > 0.005, scrollable and frac < 0.995
			if t ~= topOn then topOn = t; tween(fadeTop, M.State, { BackgroundTransparency = t and 0 or 1 }) end
			if b ~= bottomOn then bottomOn = b; tween(fadeBottom, M.State, { BackgroundTransparency = b and 0 or 1 }) end
		end
		if props.OnProgress then props.OnProgress(frac, scrollable) end
	end
	local function pulse()
		show(true)
		local t = {}
		token = t
		task.delay(M.ScrollIdle, function() if token == t and not hovering then show(false) end end)
	end
	sf:GetPropertyChangedSignal("CanvasPosition"):Connect(function() update(); pulse() end)
	sf:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(update)
	sf:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(update)
	host.MouseEnter:Connect(function() hovering = true; update(); if thumb.Visible then show(true) end end)
	host.MouseLeave:Connect(function() hovering = false; show(false) end)
	task.defer(update)
	return host, sf
end

----------------------------------------------------------------------
-- POPOVERS (floating layer; spring scale-in from the anchor)
----------------------------------------------------------------------
closePopover = function()
	local p = Library._popover
	if not p then return end
	Library._popover = nil
	if p.onClose then pcall(p.onClose) end
	local cg = p.canvas
	if p.scaleSpring then p.scaleSpring:Set(M.OpenScale) end
	tween(cg, M.Exit, { GroupTransparency = 1 }, Tokens.Ease.Exit, Enum.EasingDirection.In)
	task.delay(M.Exit, function() cg:Destroy() end)
end

local function openPopover(anchor, opts)
	closePopover()
	getRoot()
	local P = Z.PopPad
	local width = round(opts.Width or Z.PopMinW)
	local canvas = create("CanvasGroup", {
		Name = "Popover", BackgroundTransparency = 1, GroupTransparency = 1,
		Size = UDim2.fromOffset(width + 2 * P, 2 * P), Parent = Layers.Overlay,
	})
	local scaleObj = create("UIScale", { Scale = M.OpenScale, Parent = canvas })
	local shadowHost = create("Frame", { BackgroundTransparency = 1, Position = UDim2.fromOffset(P, P), Size = UDim2.new(1, -2 * P, 1, -2 * P), Parent = canvas })
	Shadow(shadowHost, "popover", { Radius = R.Card })
	local surface = Surface(canvas, {
		Name = "Surface", Color = C.Surface2, Radius = R.Card, Highlight = true, Clip = true,
		Position = UDim2.fromOffset(P, P), Size = UDim2.new(1, -2 * P, 1, -2 * P), StrokeAlpha = A.BorderStrong,
	})

	local api = { Canvas = canvas, Surface = surface, Height = 0, Width = width }
	local baseX, baseY, above = 0, 0, false
	local function place()
		local s = Library._uiScale
		local ap, as = toRoot(anchor.AbsolutePosition), anchor.AbsoluteSize
		local vp = viewport()
		local h = api.Height
		local x = (opts.Align == "right") and ((ap.X + as.X) / s - width) or (ap.X / s)
		local y = (ap.Y + as.Y) / s + Z.PopGap
		above = (y + h) * s > vp.Y - S.S
		if above then y = ap.Y / s - Z.PopGap - h end
		x = math.clamp(x, S.S / s, math.max(S.S / s, (vp.X - S.S) / s - width))
		y = math.max(S.S / s, y)
		baseX, baseY = round(x) - P, round(y) - P
		canvas.Position = UDim2.fromOffset(baseX, baseY)
	end
	function api:SetHeight(h)
		self.Height = round(h)
		canvas.Size = UDim2.fromOffset(width + 2 * P, self.Height + 2 * P)
		place()
	end
	function api:Close()
		if Library._popover and Library._popover.canvas == canvas then closePopover() end
	end
	function api:IsOpen()
		return Library._popover ~= nil and Library._popover.canvas == canvas
	end

	local scaleSpring = spring(M.OpenScale, Tokens.Spring.Popover, function(x) scaleObj.Scale = x end)
	Library._popover = { canvas = canvas, surface = surface, anchor = anchor, onClose = opts.OnClose, scaleSpring = scaleSpring }
	local h = opts.Build(surface, api)
	api:SetHeight(h or api.Height)
	-- grow out of the anchor edge
	canvas.Position = UDim2.fromOffset(baseX, baseY + (above and S.XS or -S.XS))
	tween(canvas, M.Enter, { GroupTransparency = 0, Position = UDim2.fromOffset(baseX, baseY) }, Tokens.Ease.Enter)
	scaleSpring:Set(1)
	return api
end

-- a selectable list row (popovers and listboxes share it)
local function OptionItem(parent, text, order, iconName)
	local item = create("TextButton", {
		Name = "Item", Size = UDim2.new(1, 0, 0, Z.PopItem), BackgroundTransparency = 1,
		AutoButtonColor = false, Text = "", BorderSizePixel = 0, LayoutOrder = order, ZIndex = 2, Parent = parent,
	})
	local x = S.M
	local ic
	if iconName then
		ic = Icon(iconName, Z.IconSm, C.TextDim, item)
		ic.AnchorPoint = Vector2.new(0, 0.5)
		ic.Position = UDim2.new(0, S.M, 0.5, 0)
		x = S.M + Z.IconSm + S.S
	end
	local lbl = Text(item, "Body", {
		Text = escapeRich(text), RichText = true, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 2,
		Position = UDim2.fromOffset(x, 0), Size = UDim2.new(1, -(x + S.M + Z.IconSm + S.S), 1, 0),
	})
	local checkHost = create("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -S.M, 0.5, 0), Size = UDim2.fromOffset(Z.IconSm, Z.IconSm),
		BackgroundTransparency = 1, ZIndex = 2, Parent = item })
	local check = CheckMark(checkHost, Z.IconSm, C.Accent)
	local selected = false
	local function setSelected(on, animate)
		if on == selected and animate then return end
		selected = on
		check:Set(on, animate)
	end
	local function enter(delay)
		lbl.Position = UDim2.fromOffset(x + S.XS, 0)
		lbl.TextTransparency = 1
		if ic then fadeIcon(ic, 1, 0) end
		task.delay(delay, function()
			if not lbl.Parent then return end
			tween(lbl, M.Enter, { Position = UDim2.fromOffset(x, 0), TextTransparency = 0 }, Tokens.Ease.Enter)
			if ic then fadeIcon(ic, 0, M.Enter) end
		end)
	end
	item.MouseEnter:Connect(function() if ic then animateIcon(ic) end end)
	return item, setSelected, lbl, enter
end

-- list wrapper with a shared sliding hover highlight
local function HighlightList(scroll, color)
	local content = create("Frame", { Name = "Content", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = scroll })
	local hl = Highlight(content, { Color = color or C.Surface3, Inset = Vector2.new(0, 0), Radius = R.Small })
	local list = create("Frame", { Name = "List", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, ZIndex = 2, Parent = content },
		{ vlist(0) })
	return content, list, hl
end

-- filtered option list inside a popover
--   opts: Options() → array, IsSelected(opt), OnPick(opt), Search (bool), PickOnDown (bool), CloseOnPick (bool)
local function PopoverList(surface, api, opts)
	local top = 0
	local searchBox
	if opts.Search then
		local well = Surface(surface, {
			Color = C.Bg, Radius = R.Small, Position = UDim2.fromOffset(S.S, S.S), Size = UDim2.new(1, -2 * S.S, 0, Z.Control),
		})
		local ic = Icon("search", Z.IconSm, C.TextMute, well)
		ic.AnchorPoint = Vector2.new(0, 0.5)
		ic.Position = UDim2.new(0, S.S, 0.5, 0)
		searchBox = TextInput(well, "Body", {
			PlaceholderText = "Search", Position = UDim2.fromOffset(S.S * 2 + Z.IconSm, 0),
			Size = UDim2.new(1, -(S.S * 3 + Z.IconSm), 1, 0),
		})
		top = S.S + Z.Control
	end
	local _, sf = Scroller(surface, { Position = UDim2.fromOffset(0, top), Size = UDim2.new(1, 0, 1, -top), FadeColor = C.Surface2 })
	pad(S.XS).Parent = sf
	local _, list, hl = HighlightList(sf)
	local first = true

	local function rebuild(query)
		hl:Hide()
		for _, c in ipairs(list:GetChildren()) do
			if c:IsA("GuiObject") then c:Destroy() end
		end
		local q = string.lower(query or "")
		local n = 0
		for _, opt in ipairs(opts.Options()) do
			local s = tostring(opt)
			local a, b
			if q ~= "" then a, b = string.find(string.lower(s), q, 1, true) end
			if q == "" or a then
				n = n + 1
				local item, setSelected, lbl, enter = OptionItem(list, s, n)
				hl:Attach(item)
				if a then
					lbl.TextColor3 = C.TextDim
					lbl.Text = escapeRich(s:sub(1, a - 1)) .. '<font color="' .. toHex(C.Text) .. '">' .. escapeRich(s:sub(a, b)) .. "</font>" .. escapeRich(s:sub(b + 1))
				end
				setSelected(opts.IsSelected(opt), false)
				if first then enter(math.min((n - 1) * M.ItemStagger, M.ItemStaggerCap)) end
				local signal = opts.PickOnDown and item.MouseButton1Down or item.MouseButton1Click
				signal:Connect(function()
					sfx("click", 1.1)
					opts.OnPick(opt)
					if api:IsOpen() and not opts.CloseOnPick then setSelected(opts.IsSelected(opt), true) end
				end)
			end
		end
		first = false
		if n == 0 then
			Text(list, "Caption", { Text = "No results", TextColor3 = C.TextMute, TextXAlignment = Enum.TextXAlignment.Center, Size = UDim2.new(1, 0, 0, Z.PopItem) })
		end
		local listH = math.min(math.max(n, 1) * Z.PopItem + 2 * S.XS, Z.PopMaxH - top)
		api:SetHeight(top + listH)
	end
	if searchBox then
		searchBox:GetPropertyChangedSignal("Text"):Connect(function() rebuild(searchBox.Text) end)
		task.defer(function() if searchBox.Parent then searchBox:CaptureFocus() end end)
	end
	return rebuild, searchBox
end

-- context menu at a screen point (animate-ui "Context Menu")
--   items: { { Text, Icon, Callback, Danger } , "-" (separator) }
local function openMenu(screenPos, items)
	getRoot()
	local s = Library._uiScale
	screenPos = toRoot(screenPos)
	local anchor = create("Frame", { Name = "MenuAnchor", BackgroundTransparency = 1, Size = UDim2.fromOffset(1, 1),
		Position = UDim2.fromOffset(round(screenPos.X / s), round(screenPos.Y / s) - Z.PopGap), Parent = Layers.Overlay })
	openPopover(anchor, {
		Width = 196,
		OnClose = function() anchor:Destroy() end,
		Build = function(surface, api)
			local content = create("Frame", { BackgroundTransparency = 1, Position = UDim2.fromOffset(S.XS, S.XS),
				Size = UDim2.new(1, -2 * S.XS, 1, -2 * S.XS), Parent = surface })
			local hl = Highlight(content, { Inset = Vector2.new(0, 0) })
			local list = create("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, ZIndex = 2, Parent = content },
				{ vlist(0) })
			local h = 2 * S.XS
			for i, it in ipairs(items) do
				if it == "-" then
					local sep = create("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, S.S + 1), LayoutOrder = i, Parent = list })
					create("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.fromScale(0, 0.5), Size = UDim2.new(1, 0, 0, Z.Divider),
						BackgroundColor3 = C.White, BackgroundTransparency = A.Border, BorderSizePixel = 0, Parent = sep })
					h = h + S.S + 1
				else
					local item, _, lbl, enter = OptionItem(list, it.Text, i, it.Icon)
					if it.Danger then lbl.TextColor3 = C.Danger end
					hl:Attach(item)
					enter(math.min((i - 1) * M.ItemStagger, M.ItemStaggerCap))
					item.MouseButton1Click:Connect(function()
						sfx("click", 1)
						api:Close()
						fire(it.Callback)
					end)
					h = h + Z.PopItem
				end
			end
			return h
		end,
	})
end

----------------------------------------------------------------------
-- PARTICLE BURST (animate-ui "Particles" on click)
----------------------------------------------------------------------
local function burst(gui, color)
	if not gui or not gui.Parent then return end
	getRoot()
	local s = Library._uiScale
	local c = (toRoot(gui.AbsolutePosition) + gui.AbsoluteSize / 2) / s
	for i = 1, Z.Burst do
		local ang = (i / Z.Burst) * math.pi * 2 + math.random() * 0.4
		local dist = 28 + math.random() * 36
		local size = math.random(3, 6)
		local dot = create("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(c.X, c.Y), Size = UDim2.fromOffset(size, size),
			BackgroundColor3 = (i % 3 == 0) and C.White or (i % 2 == 0 and C.Accent2 or (color or C.Accent)), BorderSizePixel = 0, Parent = Layers.Overlay,
		}, { corner(R.Pill) })
		tween(dot, M.Burst, { Position = UDim2.fromOffset(c.X + math.cos(ang) * dist, c.Y + math.sin(ang) * dist), Size = UDim2.fromOffset(0, 0),
			BackgroundTransparency = 1 }, Tokens.Ease.Enter)
		task.delay(M.Burst, function() dot:Destroy() end)
	end
end

----------------------------------------------------------------------
-- TOOLTIP (delay, fade + scale, clamped)
----------------------------------------------------------------------
local Tip = {}
local function ensureTooltip()
	if Tip.canvas and Tip.canvas.Parent then return end
	local root = getRoot()
	-- explicitly sized from the text (no AutomaticSize: a shadow sized relative to an
	-- auto-sized parent feeds back into it and grows forever)
	local P = Z.TipPad
	local canvas = create("CanvasGroup", {
		Name = "Tooltip", BackgroundTransparency = 1, GroupTransparency = 1,
		Size = UDim2.fromOffset(2 * P, 2 * P), Visible = false, ZIndex = 600, Parent = root,
	})
	Tip.scale = create("UIScale", { Parent = canvas })
	local shadowHost = create("Frame", { BackgroundTransparency = 1, Position = UDim2.fromOffset(P, P), Size = UDim2.new(1, -2 * P, 1, -2 * P), Parent = canvas })
	Shadow(shadowHost, "small", { Radius = R.Small })
	local surface = Surface(canvas, {
		Color = C.Surface3, Radius = R.Small, Position = UDim2.fromOffset(P, P), Size = UDim2.new(1, -2 * P, 1, -2 * P), StrokeAlpha = A.Border,
	})
	local lbl = Text(surface, "Caption", { TextColor3 = C.Text, Position = UDim2.fromOffset(S.S, S.XS), Size = UDim2.fromOffset(1000, 40),
		TextYAlignment = Enum.TextYAlignment.Top })
	local function fit()
		local b = lbl.TextBounds
		local w, h = math.ceil(b.X), math.max(math.ceil(b.Y), 14)
		lbl.Size = UDim2.fromOffset(w + 1, h)
		canvas.Size = UDim2.fromOffset(w + 1 + 2 * S.S + 2 * P, h + 2 * S.XS + 2 * P)
	end
	lbl:GetPropertyChangedSignal("TextBounds"):Connect(fit)
	Tip.fit = fit
	Tip.canvas, Tip.label = canvas, lbl
	stepper(function()
		if not (Tip.canvas and Tip.canvas.Visible) then return end
		local m = toRoot(absMouse())
		local size, vp, P = Tip.canvas.AbsoluteSize, viewport(), Z.TipPad
		local t = math.clamp((os.clock() - (Tip.shownAt or 0)) / M.Enter, 0, 1)
		local x = m.X + S.M - P
		local y = m.Y + S.L - P + M.TipOffset * (1 - t)
		x = math.clamp(x, S.XS - P, vp.X - size.X + P - S.XS)
		if y + size.Y - P > vp.Y - S.XS then y = m.Y - size.Y + P - S.S end
		Tip.canvas.Position = UDim2.fromOffset(round(x), round(y))
	end)
end

local function attachTooltip(obj, text)
	if not text then return end
	obj.MouseEnter:Connect(function()
		ensureTooltip()
		local token = {}
		Tip.owner, Tip.token = obj, token
		task.delay(M.TooltipDelay, function()
			if Tip.token ~= token or not obj.Parent then return end
			Tip.label.Text = text
			Tip.fit()
			Tip.shownAt = os.clock()
			Tip.canvas.Visible = true
			Tip.scale.Scale = M.OpenScale
			tween(Tip.scale, M.Enter, { Scale = 1 }, Tokens.Ease.Enter)
			tween(Tip.canvas, M.Enter, { GroupTransparency = 0 }, Tokens.Ease.Enter)
		end)
	end)
	obj.MouseLeave:Connect(function()
		if Tip.owner ~= obj then return end
		Tip.owner, Tip.token = nil, nil
		if Tip.canvas and Tip.canvas.Visible then
			tween(Tip.canvas, M.Exit, { GroupTransparency = 1 }, Tokens.Ease.Exit, Enum.EasingDirection.In)
			task.delay(M.Exit, function() if not Tip.owner and Tip.canvas then Tip.canvas.Visible = false end end)
		end
	end)
end

----------------------------------------------------------------------
-- NOTIFICATIONS  (stacked deck that fans out on hover · spring reflow · pause on hover)
----------------------------------------------------------------------
local Toasts = {}
local toastStepper
local toastHover, toastExpanded, toastZ = 0, false, 0

local function layoutToasts()
	local n = #Toasts
	for i = n, 1, -1 do
		local t = Toasts[i]
		local k = n - i
		if toastExpanded then
			t.sy:Set(-k * (Z.Toast.Y + Z.ToastGap))
			t.sc:Set(1)
			t.alpha = 0
		else
			t.sy:Set(-k * Z.ToastPeek)
			t.sc:Set(1 - k * Z.ToastScale)
			t.alpha = (k >= Z.ToastVisible) and 1 or 0
		end
		if t.appliedAlpha ~= t.alpha and t.entered then
			t.appliedAlpha = t.alpha
			tween(t.canvas, M.State, { GroupTransparency = t.alpha })
		end
		t.content.Visible = toastExpanded or k == 0
	end
end

local function setToastHover(delta)
	toastHover = math.max(0, toastHover + delta)
	local want = toastHover > 0
	if want then
		toastExpanded = true
		layoutToasts()
	else
		task.delay(M.ExitDelay, function()
			if toastHover == 0 and toastExpanded then toastExpanded = false; layoutToasts() end
		end)
	end
end

local function dismissToast(t)
	if t.closing then return end
	t.closing = true
	if t.hovered then t.hovered = false; setToastHover(-1) end
	for i, other in ipairs(Toasts) do
		if other == t then table.remove(Toasts, i) break end
	end
	layoutToasts()
	t.sx:Set(M.ToastSlide * 3)
	tween(t.canvas, M.Exit, { GroupTransparency = 1 }, Tokens.Ease.Exit, Enum.EasingDirection.In)
	task.delay(M.Exit, function() t.canvas:Destroy() end)
end

function Library:Notify(cfg)
	cfg = cfg or {}
	getRoot()
	local kinds = {
		Info    = { "Accent", "info" },
		Success = { "Success", "circle-check" },
		Warning = { "Warning", "alert-triangle" },
		Error   = { "Danger", "circle-x" },
	}
	local kind = kinds[cfg.Type or "Info"] or kinds.Info
	local color = C[kind[1]]
	local duration = cfg.Duration or M.Toast
	local P = Z.PopPad
	local W, H = Z.Toast.X, Z.Toast.Y

	sfx("notify", 1)
	toastZ = toastZ + 1

	local canvas = create("CanvasGroup", {
		Name = "Toast", AnchorPoint = Vector2.new(0.5, 1), BackgroundTransparency = 1, GroupTransparency = 1,
		Size = UDim2.fromOffset(W + 2 * P, H + 2 * P), ZIndex = toastZ, Parent = Layers.Toasts,
	})
	local scaleObj = create("UIScale", { Parent = canvas })
	local shadowHost = create("Frame", { BackgroundTransparency = 1, Position = UDim2.fromOffset(P, P), Size = UDim2.new(1, -2 * P, 1, -2 * P), Parent = canvas })
	Shadow(shadowHost, "popover", { Radius = R.Card + S.XS / 2 })
	local surface = Surface(canvas, {
		Color = C.Surface2, Radius = R.Card + S.XS / 2, Highlight = true, Clip = true,
		Position = UDim2.fromOffset(P, P), Size = UDim2.new(1, -2 * P, 1, -2 * P), StrokeAlpha = A.BorderStrong,
	})
	local content = create("Frame", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Parent = surface })
	local badge = create("Frame", {
		Position = UDim2.fromOffset(S.L, S.L), Size = UDim2.fromOffset(Z.ToastIcon, Z.ToastIcon), BackgroundColor3 = color,
		BackgroundTransparency = A.Tint, BorderSizePixel = 0, Parent = content,
	}, { corner(R.Pill) })
	local ic = Icon(kind[2], Z.IconSm, color, badge)
	ic.AnchorPoint = Vector2.new(0.5, 0.5)
	ic.Position = UDim2.fromScale(0.5, 0.5)
	-- expanding ring on arrival
	local ring = create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1, Parent = badge }, { corner(R.Pill) })
	local ringStroke = create("UIStroke", { Color = color, Thickness = 1.5, Transparency = 0.3, Parent = ring })

	local textX = S.L + Z.ToastIcon + S.M
	local title = Text(content, "Strong", {
		Position = UDim2.fromOffset(textX, S.L - 2), Size = UDim2.new(1, -(textX + S.L), 0, 18), TextTruncate = Enum.TextTruncate.AtEnd,
	})
	setText(title, cfg.Title or "Notice", 0.4)
	Text(content, "Caption", {
		Text = cfg.Content or "", TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top, TextTruncate = Enum.TextTruncate.AtEnd,
		Position = UDim2.fromOffset(textX, S.L + 18), Size = UDim2.new(1, -(textX + S.L), 0, 32),
	})
	local bar = create("Frame", {
		AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), Size = UDim2.new(1, 0, 0, Z.Hairline),
		BackgroundColor3 = color, BackgroundTransparency = 0.4, BorderSizePixel = 0, Parent = surface,
	})
	local hit = create("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", ZIndex = 5, Parent = surface })

	local t = { canvas = canvas, bar = bar, content = content, duration = duration, remaining = duration, alpha = 0 }
	local function apply()
		canvas.Position = UDim2.new(1, -Z.ToastEdge - W / 2 + round(t.sx.x), 1, -Z.ToastEdge + P + round(t.sy.x))
	end
	t.sx = spring(M.ToastSlide, Tokens.Spring.Stack, apply)
	t.sy = spring(0, Tokens.Spring.Stack, apply)
	t.sc = spring(1, Tokens.Spring.Stack, function(x) scaleObj.Scale = x end)
	apply()

	hit.MouseEnter:Connect(function() if not t.hovered then t.hovered = true; setToastHover(1) end end)
	hit.MouseLeave:Connect(function() if t.hovered then t.hovered = false; setToastHover(-1) end end)
	hit.MouseButton1Click:Connect(function() dismissToast(t) end)

	table.insert(Toasts, t)
	while #Toasts > Z.ToastMax do dismissToast(Toasts[1]) end
	t.sy:Snap(0)
	t.sx:Set(0)
	layoutToasts()
	t.entered, t.appliedAlpha = true, 0
	tween(canvas, M.Enter, { GroupTransparency = 0 }, Tokens.Ease.Enter)
	popScale(ic, 0.4)
	tween(ring, M.Burst * 1.4, { Size = UDim2.fromScale(1.9, 1.9) }, Tokens.Ease.Enter)
	tween(ringStroke, M.Burst * 1.4, { Transparency = 1 }, Tokens.Ease.Enter)

	if not toastStepper then
		toastStepper = stepper(function(dt)
			if #Toasts == 0 then return end
			for _, toast in ipairs(table.clone(Toasts)) do
				if not toastExpanded then toast.remaining = toast.remaining - dt end
				toast.bar.Size = UDim2.new(math.clamp(toast.remaining / toast.duration, 0, 1), 0, 0, Z.Hairline)
				if toast.remaining <= 0 then dismissToast(toast) end
			end
		end)
	end
end

----------------------------------------------------------------------
-- DIALOG (animate-ui "Alert Dialog"): scrim + spring pop
--   cfg: Title, Content, Buttons = { { Text, Variant, Callback } }, Dismissible
----------------------------------------------------------------------
local ActionButton -- defined with the components; forward declared
function Library:Dialog(cfg)
	cfg = cfg or {}
	local root = getRoot()
	closePopover()
	local P = Z.PopPad
	local W = Z.Dialog
	local scrim = Layers.Scrim
	scrim.Visible = true
	tween(scrim, M.Enter, { BackgroundTransparency = A.Backdrop }, Tokens.Ease.Enter)

	-- height is computed up front (no AutomaticSize around the shadow, see the tooltip note)
	local innerW = W - 2 * S.XL
	local contentText = cfg.Content or ""
	local contentH = 0
	if contentText ~= "" then
		local ok, size = pcall(function()
			return TextService:GetTextSize(contentText, Tokens.Type.Caption.Size, Enum.Font.Roboto, Vector2.new(innerW, 2000))
		end)
		contentH = (ok and size) and math.ceil(size.Y) + 2 or 32
	end
	local bodyH = S.XL + 20 + S.S + contentH + S.S + Z.Well + S.M + S.XL
	local canvas = create("CanvasGroup", {
		Name = "Dialog", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), BackgroundTransparency = 1, GroupTransparency = 1,
		Size = UDim2.fromOffset(W + 2 * P, bodyH + 2 * P), ZIndex = 460, Parent = root,
	})
	local scaleObj = create("UIScale", { Parent = canvas })
	local shadowHost = create("Frame", { BackgroundTransparency = 1, Position = UDim2.fromOffset(P, P), Size = UDim2.new(1, -2 * P, 1, -2 * P), Parent = canvas })
	Shadow(shadowHost, "popover", { Radius = R.Card + S.XS / 2 })
	local surface = Surface(canvas, { Color = C.Surface2, Radius = R.Card + S.XS / 2, Highlight = true,
		Position = UDim2.fromOffset(P, P), Size = UDim2.new(1, -2 * P, 1, -2 * P), StrokeAlpha = A.BorderStrong })
	vlist(S.S).Parent = surface
	pad(S.XL).Parent = surface
	Text(surface, "Title", { Text = cfg.Title or "Are you sure?", Size = UDim2.new(1, 0, 0, 20), LayoutOrder = 1 })
	Text(surface, "Caption", { Text = contentText, TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top,
		Size = UDim2.new(1, 0, 0, contentH), LayoutOrder = 2 })
	local row = create("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, Z.Well + S.M), LayoutOrder = 3, Parent = surface },
		{ hlist(S.S, Enum.VerticalAlignment.Bottom, Enum.HorizontalAlignment.Right) })

	local closed = false
	local escConn
	local pop = spring(0.92, Tokens.Spring.Pop, function(x) scaleObj.Scale = x * Library._uiScale end)
	local function close()
		if closed then return end
		closed = true
		if escConn then escConn:Disconnect() end
		pop:Set(0.95)
		tween(canvas, M.Exit, { GroupTransparency = 1 }, Tokens.Ease.Exit, Enum.EasingDirection.In)
		tween(scrim, M.Exit, { BackgroundTransparency = 1 }, Tokens.Ease.Exit, Enum.EasingDirection.In)
		task.delay(M.Exit, function()
			canvas:Destroy()
			if scrim.BackgroundTransparency >= 0.99 then scrim.Visible = false end
		end)
	end
	for i, b in ipairs(cfg.Buttons or { { Text = "OK", Variant = "Primary" } }) do
		local holder = ActionButton(row, { Name = b.Text, Variant = b.Variant or "Secondary", Icon = b.Icon,
			Size = UDim2.fromOffset(112, Z.Well), AnchorPoint = Vector2.zero, Position = UDim2.new(),
			MagnetActive = function() return not closed end, Callback = function() close(); fire(b.Callback) end })
		holder.LayoutOrder = i
	end
	if cfg.Dismissible ~= false then
		local c
		c = scrim.MouseButton1Click:Connect(function() c:Disconnect(); close() end)
		escConn = UserInputService.InputBegan:Connect(function(input) if input.KeyCode == Enum.KeyCode.Escape then close() end end)
		track(escConn)
	end
	pop:Snap(0.92)
	pop:Set(1)
	tween(canvas, M.Enter, { GroupTransparency = 0 }, Tokens.Ease.Enter)
	return close
end

----------------------------------------------------------------------
-- THEME API
----------------------------------------------------------------------
-- radial accent wave across the window when the theme changes (animate-ui "Theme Toggler")
local function themeWave()
	local win = Library.Window
	if not (win and win.Visible and win.FXTop) then return end
	local s = win.ScaleValue
	local m = (absMouse() - win.Main.AbsolutePosition) / s
	local size = win.Main.AbsoluteSize / s
	local diag = math.sqrt(size.X * size.X + size.Y * size.Y) * 2.2
	local wave = create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(m.X, m.Y), Size = UDim2.fromOffset(0, 0),
		BackgroundColor3 = C.Accent, BackgroundTransparency = 0.82, BorderSizePixel = 0, Parent = win.FXTop }, { corner(R.Pill) })
	tween(wave, M.Reveal, { Size = UDim2.fromOffset(diag, diag), BackgroundTransparency = 1 }, Tokens.Ease.Enter)
	task.delay(M.Reveal, function() wave:Destroy() end)
end

function Library:SetAccent(a, b)
	if a then C.Accent = a end
	if b then C.Accent2 = b end
	syncThemeAliases()
	for _, fn in ipairs(self._painters) do pcall(fn) end
end

function Library:SetPreset(name)
	local p = Presets[name] or Presets[PresetAlias[name] or ""]
	if p then
		self:SetAccent(p[1], p[2])
		themeWave()
	end
end

-- v3.0 name kept: now drives a dim/vignette backdrop instead of a world blur
function Library:SetBlur(on)
	self.Settings.Blur = on and true or false
	getRoot()
	local show = self.Settings.Blur and self.Window ~= nil and self.Window.Visible
	if show then Layers.Backdrop.Visible = true end
	tween(Layers.Backdrop, M.State, { BackgroundTransparency = show and A.Backdrop or 1 })
	if not show then task.delay(M.State, function() if not (self.Settings.Blur and self.Window and self.Window.Visible) then Layers.Backdrop.Visible = false end end) end
end

function Library:SetWatermark(on)
	self.Settings.Watermark = on and true or false
	if self._watermark then self._watermark.Visible = self.Settings.Watermark end
end

----------------------------------------------------------------------
-- SECTION ROWS
----------------------------------------------------------------------
local Section = {}
Section.__index = Section

local function copyText(text)
	local fn = (typeof(setclipboard) == "function" and setclipboard) or (typeof(toclipboard) == "function" and toclipboard)
	if not fn then return false end
	return (pcall(fn, tostring(text)))
end

local lastMenuAt = 0
local function newRow(section, height, opts)
	opts = opts or {}
	section._order = section._order + 1
	local auto = height == nil
	local row = create("Frame", {
		Name = "Row", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, height or 0),
		AutomaticSize = auto and Enum.AutomaticSize.Y or Enum.AutomaticSize.None, LayoutOrder = section._order, ZIndex = 2, Parent = section.List,
	})
	local divider = create("Frame", {
		Name = "Divider", BackgroundColor3 = C.White, BackgroundTransparency = A.Border, BorderSizePixel = 0,
		Position = UDim2.fromOffset(S.L, 0), Size = UDim2.new(1, -2 * S.L, 0, Z.Divider), ZIndex = 3, Parent = row,
	})
	local rec = {
		Frame = row, Divider = divider, Section = section, Search = string.lower(opts.Search or ""),
		NoDivider = opts.NoDivider, NoDividerAfter = opts.NoDividerAfter,
	}
	if auto then
		rec.Inner = create("Frame", { Name = "Inner", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = row },
			{ pad(S.L, opts.PadY or S.M, S.L, opts.PadY or S.M) })
		rec.Content = rec.Inner
	else
		rec.Content = create("Frame", { Name = "Content", BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromScale(1, 1), Parent = row })
		rec.Scale = create("UIScale", { Parent = rec.Content })
		rec.Inner = create("Frame", { Name = "Inner", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Parent = rec.Content },
			{ pad(S.L, 0, S.L, 0) })
	end
	if opts.Interactive then section.Highlight:Attach(row) end
	if opts.Tooltip then attachTooltip(row, opts.Tooltip) end
	-- right-click context menu
	function rec.BindMenu(gui)
		if not opts.Menu then return end
		gui.InputBegan:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.MouseButton2 then return end
			if os.clock() - lastMenuAt < 0.1 then return end
			lastMenuAt = os.clock()
			local items = opts.Menu()
			if items and #items > 0 then openMenu(Vector2.new(input.Position.X, input.Position.Y), items) end
		end)
	end
	rec.BindMenu(row)
	table.insert(section.Rows, rec)
	table.insert(section.Tab.Rows, rec)
	section:_relayout()
	return rec
end

function Section:_relayout()
	local prev
	for _, r in ipairs(self.Rows) do
		if r.Frame.Visible then
			r.Divider.Visible = prev ~= nil and not prev.NoDividerAfter and not r.NoDivider
			prev = r
		end
	end
end

local function pressFeedback(scale, button)
	if not scale then return end
	tapSpring(scale, button)
end

-- standard right-click menu for value controls
local function valueMenu(cfg, getObj, default, extra)
	return function()
		local items = {}
		local obj = getObj()
		if default ~= nil then
			table.insert(items, { Text = "Reset to default", Icon = "refresh", Callback = function() obj:Set(default) end })
		end
		for _, e in ipairs(extra or {}) do table.insert(items, e) end
		if cfg.Flag then
			if #items > 0 then table.insert(items, "-") end
			table.insert(items, { Text = "Copy flag name", Icon = "copy", Callback = function()
				if not copyText(cfg.Flag) then Library:Notify({ Title = "Clipboard unavailable", Content = "This environment can't write to the clipboard.", Type = "Warning", Duration = 3 }) end
			end })
		end
		return items
	end
end

-- name + optional description on the left; reserves (scale, offset) on the right
local function labelBlock(inner, cfg, default, rScale, rOffset)
	rScale, rOffset = rScale or 0, rOffset or 0
	local name
	if cfg.Description then
		name = Text(inner, "Body", { Text = cfg.Name or default, TextTruncate = Enum.TextTruncate.AtEnd,
			Position = UDim2.new(0, 0, 0.5, -16), Size = UDim2.new(1 - rScale, -rOffset, 0, 16) })
		Text(inner, "Caption", { Text = cfg.Description, TextTruncate = Enum.TextTruncate.AtEnd,
			Position = UDim2.new(0, 0, 0.5, 2), Size = UDim2.new(1 - rScale, -rOffset, 0, 14) })
	else
		name = Text(inner, "Body", { Text = cfg.Name or default, TextTruncate = Enum.TextTruncate.AtEnd,
			Size = UDim2.new(1 - rScale, -rOffset, 1, 0) })
	end
	return name
end

local function searchText(cfg, default)
	return (cfg.Name or default or "") .. " " .. (cfg.Description or "")
end

local function rowHeight(cfg) return cfg.Description and Z.RowDesc or Z.Row end

local function windowActive()
	local w = Library.Window
	return w ~= nil and w.Visible
end

-- input well with accent focus ring
local function Field(parent, props)
	local holder = create("Frame", {
		Name = "Field", BackgroundTransparency = 1, AnchorPoint = props.AnchorPoint or Vector2.new(1, 0.5),
		Position = props.Position or UDim2.new(1, 0, 0.5, 0), Size = props.Size or UDim2.new(Z.ControlFrac, 0, 0, Z.Well), Parent = parent,
	})
	local RING = 3
	local ring = create("Frame", {
		Name = "Ring", BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.fromOffset(-RING, -RING),
		Size = UDim2.new(1, 2 * RING, 1, 2 * RING), Parent = holder,
	}, { corner(R.Control + RING) })
	accentProp(ring, "BackgroundColor3")
	local well = Surface(holder, { Name = "Well", Color = C.Bg, Radius = R.Control })
	local border = well:FindFirstChild("Border")
	local left = S.M
	local fieldIcon
	if props.Icon then
		fieldIcon = Icon(props.Icon, Z.IconSm, C.TextMute, well)
		fieldIcon.AnchorPoint = Vector2.new(0, 0.5)
		fieldIcon.Position = UDim2.new(0, S.M - 2, 0.5, 0)
		left = S.M + Z.IconSm + S.S - 2
	end
	local right = S.M + (props.RightReserve or 0)
	local input = TextInput(well, props.Style or "Body", {
		Position = UDim2.fromOffset(left, 0), Size = UDim2.new(1, -(left + right), 1, 0),
		PlaceholderText = props.Placeholder or "", Text = props.Text or "", ClearTextOnFocus = props.ClearOnFocus == true,
	})
	local focused = false
	well.MouseEnter:Connect(function() if not focused then tween(border, M.Hover, { Transparency = A.BorderStrong }) end end)
	well.MouseLeave:Connect(function() if not focused then tween(border, M.Hover, { Transparency = A.Border }) end end)
	input.Focused:Connect(function()
		focused = true
		tween(ring, M.State, { BackgroundTransparency = A.Ring })
		tween(border, M.State, { Color = C.Accent, Transparency = 0.3 })
		if fieldIcon then tintIcon(fieldIcon, C.Accent, M.State); animateIcon(fieldIcon) end
	end)
	input.FocusLost:Connect(function()
		focused = false
		tween(ring, M.State, { BackgroundTransparency = 1 })
		tween(border, M.State, { Color = C.White, Transparency = A.Border })
		if fieldIcon then tintIcon(fieldIcon, C.TextMute, M.State) end
	end)
	return { Holder = holder, Well = well, Input = input, Border = border }
end

local function iconButton(parent, name, size, props)
	props = props or {}
	local b = create("TextButton", {
		Name = props.Name or "IconButton", Size = UDim2.fromOffset(size, size), BackgroundColor3 = props.Hover or C.Surface3,
		BackgroundTransparency = 1, AutoButtonColor = false, Text = "", BorderSizePixel = 0,
		AnchorPoint = props.AnchorPoint or Vector2.zero, Position = props.Position or UDim2.new(),
		LayoutOrder = props.LayoutOrder or 0, ZIndex = props.ZIndex or 1, Parent = parent,
	}, { corner(props.Radius or R.Control) })
	local ic = Icon(name, props.IconSize or Z.Icon, props.Color or C.TextDim, b)
	ic.AnchorPoint = Vector2.new(0.5, 0.5)
	ic.Position = UDim2.fromScale(0.5, 0.5)
	b.MouseEnter:Connect(function()
		tween(b, M.Hover, { BackgroundTransparency = props.HoverAlpha or 0 })
		tintIcon(ic, props.HoverColor or C.Text, M.Hover)
		animateIcon(ic)
	end)
	b.MouseLeave:Connect(function()
		tween(b, M.Hover, { BackgroundTransparency = 1 })
		tintIcon(ic, props.Color or C.TextDim, M.Hover)
	end)
	return b, ic
end

----------------------------------------------------------------------
-- ACTION BUTTON  (Primary · Secondary · Danger · Liquid · Flip, optional Async)
--   animate-ui: Button (tap spring), Liquid Button, Flip Button, Shine, Particles, Magnetic
----------------------------------------------------------------------
ActionButton = function(parent, cfg)
	local variant = cfg.Variant or "Secondary"
	local holder = create("Frame", {
		Name = "Action", BackgroundTransparency = 1, AnchorPoint = cfg.AnchorPoint or Vector2.new(0.5, 0.5),
		Position = cfg.Position or UDim2.fromScale(0.5, 0.5), Size = cfg.Size or UDim2.new(1, 0, 0, Z.Well), Parent = parent,
	})
	local mover = create("Frame", { Name = "Mover", BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromScale(1, 1), Parent = holder })
	local scale = create("UIScale", { Parent = mover })
	local glowF
	if variant == "Primary" then
		glowF = Glow(mover, { Radius = R.Control })
		glowF.Position = UDim2.fromOffset(0, 2)
	end
	local btn = create("TextButton", { Size = UDim2.fromScale(1, 1), AutoButtonColor = false, Text = "", BorderSizePixel = 0,
		ClipsDescendants = true, Parent = mover }, { corner(R.Control) })

	local fg, fgKey = C.Text, nil
	if variant == "Primary" then
		btn.BackgroundColor3 = C.White
		accentGradient(0).Parent = btn
		create("Frame", { BackgroundColor3 = C.White, BackgroundTransparency = 0.8, BorderSizePixel = 0, ZIndex = 3,
			Position = UDim2.fromOffset(R.Control, 0), Size = UDim2.new(1, -2 * R.Control, 0, Z.Divider), Parent = btn })
		fg = C.White
	elseif variant == "Danger" then
		btn.BackgroundColor3, btn.BackgroundTransparency = C.Danger, A.Tint
		stroke(C.Danger, 0.6).Parent = btn
		fg = C.Danger
	elseif variant == "Liquid" then
		btn.BackgroundColor3 = C.Surface3
		accentProp(stroke(C.Accent, 0.5), "Color").Parent = btn
		fg, fgKey = C.Accent, "Accent"
	else
		btn.BackgroundColor3 = C.Surface3
		stroke(C.White, A.BorderStrong).Parent = btn
	end

	-- liquid fill rises from the bottom edge
	local liquid
	if variant == "Liquid" then
		liquid = create("Frame", { Name = "Liquid", AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), Size = UDim2.new(0, 0, 0, 3),
			BorderSizePixel = 0, Parent = btn }, { corner(R.Control) })
		accentProp(liquid, "BackgroundColor3")
	end
	local overlay = create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = C.White, BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 2, Parent = btn }, { corner(R.Control) })
	local shine
	if variant == "Primary" then
		shine = create("Frame", { Name = "Shine", Size = UDim2.new(0.45, 0, 1, 0), Position = UDim2.new(-0.6, 0, 0, 0), BackgroundColor3 = C.White,
			BorderSizePixel = 0, ZIndex = 3, Parent = btn }, { create("UIGradient", { Rotation = 20, Transparency = NumberSequence.new({ kp(0, 1), kp(0.5, 0.72), kp(1, 1) }) }) })
	end

	-- faces
	local function face(text, withIcon)
		local f = create("Frame", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 4, Parent = btn })
		local row = create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.new(0, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, ZIndex = 4, Parent = f }, { hlist(S.S, nil, Enum.HorizontalAlignment.Center) })
		local ic
		if withIcon and cfg.Icon then
			ic = Icon(cfg.Icon, Z.IconSm, fg, row)
			ic.LayoutOrder = 1
		end
		local lbl = Text(row, "Strong", { Text = text, TextColor3 = fg, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 1, 0), LayoutOrder = 2, ZIndex = 4 })
		if fgKey then accentProp(lbl, "TextColor3", fgKey) end
		return f, lbl, ic
	end
	local front, label, icon = face(cfg.Name or "Button", true)
	local back, backLabel
	if variant == "Flip" then
		back, backLabel = face(cfg.Back or "Let's go", false)
		local p = spring(0, Tokens.Spring.Flip, function(x)
			front.Position = UDim2.fromScale(0, -0.5 * x)
			back.Position = UDim2.fromScale(0, 0.5 * (1 - x))
			label.TextTransparency = math.clamp(x, 0, 1)
			backLabel.TextTransparency = math.clamp(1 - x, 0, 1)
			if icon then fadeIcon(icon, math.clamp(x, 0, 1)) end
		end)
		p:Snap(0)
		btn.MouseEnter:Connect(function() p:Set(1) end)
		btn.MouseLeave:Connect(function() p:Set(0) end)
	end

	-- async status face: spinner → drawn check
	local status = create("Frame", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Visible = false, ZIndex = 5, Parent = btn })
	local statusRow = create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.new(0, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, ZIndex = 5, Parent = status }, { hlist(S.S, nil, Enum.HorizontalAlignment.Center) })
	local spinHost = create("Frame", { BackgroundTransparency = 1, Size = UDim2.fromOffset(Z.Spinner, Z.Spinner), LayoutOrder = 1, ZIndex = 5, Parent = statusRow })
	local checkHost = create("Frame", { BackgroundTransparency = 1, Size = UDim2.fromOffset(Z.Spinner, Z.Spinner), LayoutOrder = 2, ZIndex = 5, Visible = false, Parent = statusRow })
	local statusLbl = Text(statusRow, "Strong", { Text = "", TextColor3 = fg, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 1, 0), LayoutOrder = 3, ZIndex = 5 })
	local doneCheck = CheckMark(checkHost, Z.Spinner, fg)

	local hovering, busy, liquidToken = false, false, nil
	btn.MouseEnter:Connect(function()
		hovering = true
		if variant ~= "Liquid" then tween(overlay, M.Hover, { BackgroundTransparency = A.Overlay }) end
		if glowF then shadowLevel(glowF, 1.6, M.Hover) end
		if shine then
			shine.Position = UDim2.new(-0.6, 0, 0, 0)
			tween(shine, M.Sheen, { Position = UDim2.new(1.2, 0, 0, 0) }, Tokens.Ease.Exit)
		end
		if icon then animateIcon(icon) end
		if variant == "Danger" then tween(btn, M.Hover, { BackgroundTransparency = A.Tint - 0.12 }) end
		if liquid then
			local t = {}
			liquidToken = t
			tween(liquid, M.Liquid, { Size = UDim2.new(1, 0, 0, 3) }, Tokens.Ease.Exit)
			task.delay(M.Liquid, function()
				if liquidToken ~= t then return end
				tween(liquid, M.Liquid, { Size = UDim2.new(1, 0, 1, 0) }, Tokens.Ease.Enter)
				tween(label, M.Liquid, { TextColor3 = C.White })
				if icon then tintIcon(icon, C.White, M.Liquid) end
			end)
		end
	end)
	btn.MouseLeave:Connect(function()
		hovering = false
		tween(overlay, M.Hover, { BackgroundTransparency = 1 })
		if glowF then shadowLevel(glowF, 1, M.Hover) end
		if variant == "Danger" then tween(btn, M.Hover, { BackgroundTransparency = A.Tint }) end
		if liquid then
			local t = {}
			liquidToken = t
			tween(label, M.Liquid, { TextColor3 = C.Accent })
			if icon then tintIcon(icon, C.Accent, M.Liquid) end
			tween(liquid, M.Liquid, { Size = UDim2.new(1, 0, 0, 3) }, Tokens.Ease.Exit)
			task.delay(M.Liquid, function()
				if liquidToken == t then tween(liquid, M.Liquid, { Size = UDim2.new(0, 0, 0, 3) }, Tokens.Ease.Exit) end
			end)
		end
	end)
	tapSpring(scale, btn)
	magnetic(mover, holder, { Range = Z.MagnetRange, Strength = Z.MagnetStrength * 0.5, Active = cfg.MagnetActive or windowActive })

	local function setFaces(alpha, t)
		tween(label, t, { TextTransparency = alpha })
		if icon then fadeIcon(icon, alpha, t) end
		if backLabel then tween(backLabel, t, { TextTransparency = 1 }) end
	end
	btn.MouseButton1Click:Connect(function()
		if busy then return end
		sfx("click", 1)
		if variant == "Primary" and cfg.Burst ~= false then burst(btn) end
		if not cfg.Async then fire(cfg.Callback) return end
		busy = true
		setFaces(1, M.Exit)
		status.Visible = true
		spinHost.Visible, checkHost.Visible = true, false
		local spinner = Spinner(spinHost, Z.Spinner, fg)
		statusLbl.Text = cfg.LoadingText or ""
		task.spawn(function()
			local ok = true
			if type(cfg.Callback) == "function" then
				ok = pcall(cfg.Callback)
			end
			spinner:Destroy()
			spinHost.Visible, checkHost.Visible = false, true
			statusLbl.Text = ok and (cfg.DoneText or "Done") or "Failed"
			doneCheck:Set(false, false)
			doneCheck:Set(true, true)
			popScale(checkHost, 0.6)
			task.wait(M.Done)
			status.Visible = false
			setFaces(0, M.Enter)
			busy = false
		end)
	end)

	local api = { Holder = holder, Button = btn }
	function api:SetText(t) label.Text = t end
	return holder, api
end

---------------------------------------------------------------- LABEL
function Section:AddLabel(text)
	local rec = newRow(self, nil, { Search = text, PadY = S.S })
	local l = Text(rec.Inner, "Caption", {
		Text = text or "", TextWrapped = true, RichText = true, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
	})
	local obj = {}
	function obj:SetText(t) l.Text = t; rec.Search = string.lower(tostring(t)) end
	function obj:SetColor(c) l.TextColor3 = c end
	return obj
end

---------------------------------------------------------------- PARAGRAPH
function Section:AddParagraph(cfg)
	cfg = cfg or {}
	local rec = newRow(self, nil, { Search = (cfg.Title or "") .. " " .. (cfg.Content or "") })
	vlist(S.XS).Parent = rec.Inner
	local t = Text(rec.Inner, "Strong", { Text = cfg.Title or "", Size = UDim2.new(1, 0, 0, 16), LayoutOrder = 1 })
	local c = Text(rec.Inner, "Caption", {
		Text = cfg.Content or "", TextWrapped = true, RichText = true, LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
	})
	local obj = {}
	function obj:Set(title, content)
		if title then t.Text = title end
		if content then c.Text = content end
		rec.Search = string.lower(t.Text .. " " .. c.Text)
	end
	return obj
end

---------------------------------------------------------------- SEPARATOR (optional label)
function Section:AddSeparator(text)
	local rec = newRow(self, Z.RowSeparator, { NoDivider = true, NoDividerAfter = true })
	create("Frame", {
		AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.fromScale(0, 0.5), Size = UDim2.new(1, 0, 0, Z.Divider),
		BackgroundColor3 = C.White, BackgroundTransparency = A.Border, BorderSizePixel = 0, Parent = rec.Inner,
	})
	if text then
		local l = Text(rec.Inner, "Label", {
			Text = string.upper(text), AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 1, 0),
			BackgroundTransparency = 0, BackgroundColor3 = C.Surface2, ZIndex = 2,
		})
		pad(0, 0, S.S, 0).Parent = l
	end
	return rec.Frame
end

---------------------------------------------------------------- BUTTON
local ACTION_VARIANTS = { Primary = true, Secondary = true, Danger = true, Liquid = true, Flip = true }
function Section:AddButton(cfg)
	cfg = cfg or {}
	local obj = {}
	if ACTION_VARIANTS[cfg.Variant or ""] then
		local rec = newRow(self, Z.RowButton, { Search = searchText(cfg, "Button"), Tooltip = cfg.Tooltip })
		local _, api = ActionButton(rec.Inner, cfg)
		function obj:SetText(t) api:SetText(t) end
		return obj
	end

	local rec = newRow(self, rowHeight(cfg), { Interactive = true, Search = searchText(cfg, "Button"), Tooltip = cfg.Tooltip })
	local name = labelBlock(rec.Inner, cfg, "Button", 0, Z.Icon + S.S)
	local chev = Icon("chevron-right", Z.Icon, C.TextMute, rec.Inner)
	chev.AnchorPoint = Vector2.new(1, 0.5)
	chev.Position = UDim2.new(1, 0, 0.5, 0)
	local hit = create("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", ZIndex = 5, Parent = rec.Content })
	hit.MouseEnter:Connect(function() tintIcon(chev, C.TextDim, M.Hover); animateIcon(chev) end)
	hit.MouseLeave:Connect(function() tintIcon(chev, C.TextMute, M.Hover) end)
	pressFeedback(rec.Scale, hit)
	hit.MouseButton1Click:Connect(function() sfx("click", 1); fire(cfg.Callback) end)
	function obj:SetText(t) name.Text = t end
	return obj
end

---------------------------------------------------------------- TOGGLE (thumb stretches on press)
function Section:AddToggle(cfg)
	cfg = cfg or {}
	local state = cfg.Default == true
	local obj = {}
	local rec = newRow(self, rowHeight(cfg), { Interactive = true, Search = searchText(cfg, "Toggle"), Tooltip = cfg.Tooltip,
		Menu = valueMenu(cfg, function() return obj end, cfg.Default == true) })
	labelBlock(rec.Inner, cfg, "Toggle", 0, Z.ToggleW + S.M)

	local holder = create("Frame", {
		AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(Z.ToggleW, Z.ToggleH),
		BackgroundTransparency = 1, Parent = rec.Inner,
	})
	local glowF = Glow(holder, { Radius = R.Pill })
	local trackF = create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = C.Surface4, BorderSizePixel = 0, Parent = holder }, { corner(R.Pill) })
	local trackStroke = stroke(C.White, A.Border)
	trackStroke.Parent = trackF
	local INSET = (Z.ToggleH - Z.Knob) / 2
	local knobHost = create("Frame", {
		AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, INSET, 0.5, 0), Size = UDim2.fromOffset(Z.Knob, Z.Knob),
		BackgroundTransparency = 1, Parent = trackF,
	})
	Shadow(knobHost, "small", { Radius = R.Pill })
	local knob = create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = C.TextDim, BorderSizePixel = 0, Parent = knobHost }, { corner(R.Pill) })
	local xS, wS
	local function apply()
		knobHost.Position = UDim2.new(0, xS.x, 0.5, 0)
		knobHost.Size = UDim2.fromOffset(wS.x, Z.Knob)
	end
	xS = spring(INSET, Tokens.Spring.Knob, apply)
	wS = spring(Z.Knob, Tokens.Spring.Knob, apply)
	local function restX(w) return state and (Z.ToggleW - INSET - w) or INSET end
	local hit = create("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", ZIndex = 5, Parent = rec.Content })
	rec.BindMenu(hit)

	local pressed = false
	local function render(animate)
		local t = animate and M.State or 0
		tween(trackF, t, { BackgroundColor3 = state and C.Accent or C.Surface4 })
		tween(trackStroke, t, { Transparency = state and 1 or A.Border })
		tween(knob, t, { BackgroundColor3 = state and C.White or C.TextDim })
		shadowLevel(glowF, state and 1 or 0, t)
		if animate then wS:Set(Z.Knob); xS:Set(restX(Z.Knob)) else wS:Snap(Z.Knob); xS:Snap(restX(Z.Knob)) end
	end
	hit.MouseButton1Down:Connect(function()
		pressed = true
		local w = Z.Knob + Z.Stretch
		wS:Set(w); xS:Set(restX(w))
	end)
	local function release()
		if not pressed then return end
		pressed = false
		wS:Set(Z.Knob); xS:Set(restX(Z.Knob))
	end
	hit.MouseButton1Up:Connect(release)
	hit.MouseLeave:Connect(release)

	function obj:Set(v, silent)
		state = v and true or false
		render(true); setFlag(cfg, state)
		if not silent then fire(cfg.Callback, state) end
	end
	function obj:Get() return state end
	pressFeedback(rec.Scale, hit)
	hit.MouseButton1Click:Connect(function() sfx("click", state and 0.9 or 1.1); obj:Set(not state) end)
	paint(function() render(false) end)
	setFlag(cfg, state)
	return register(cfg, obj)
end

---------------------------------------------------------------- CHECKBOX (fill scales in, check draws itself)
function Section:AddCheckbox(cfg)
	cfg = cfg or {}
	local state = cfg.Default == true
	local obj = {}
	local rec = newRow(self, rowHeight(cfg), { Interactive = true, Search = searchText(cfg, "Checkbox"), Tooltip = cfg.Tooltip,
		Menu = valueMenu(cfg, function() return obj end, cfg.Default == true) })
	labelBlock(rec.Inner, cfg, "Checkbox", 0, Z.Checkbox + S.M)
	local box = create("Frame", {
		AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(Z.Checkbox, Z.Checkbox),
		BackgroundColor3 = C.Bg, BorderSizePixel = 0, Parent = rec.Inner,
	}, { corner(R.Small - 1) })
	local boxStroke = stroke(C.White, A.BorderStrong)
	boxStroke.Parent = box
	local fill = create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 2, Parent = box }, { corner(R.Small - 1) })
	accentProp(fill, "BackgroundColor3")
	local fillScale = create("UIScale", { Scale = 0.7, Parent = fill })
	local check = CheckMark(box, Z.IconXs + 2, C.White)
	local hit = create("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", ZIndex = 5, Parent = rec.Content })
	rec.BindMenu(hit)

	local function render(animate)
		local t = animate and M.Draw or 0
		tween(fill, t, { BackgroundTransparency = state and 0 or 1 }, Tokens.Ease.Enter)
		tween(fillScale, t, { Scale = state and 1 or 0.7 }, Tokens.Ease.Enter)
		tween(boxStroke, t, { Transparency = state and 1 or A.BorderStrong })
		check:Set(state, animate)
	end
	function obj:Set(v, silent)
		state = v and true or false
		render(true); setFlag(cfg, state)
		if not silent then fire(cfg.Callback, state) end
	end
	function obj:Get() return state end
	pressFeedback(rec.Scale, hit)
	hit.MouseButton1Click:Connect(function() sfx("click", 1.2); obj:Set(not state) end)
	render(false)
	setFlag(cfg, state)
	return register(cfg, obj)
end

---------------------------------------------------------------- RADIO GROUP (dot pops in on a spring)
function Section:AddRadio(cfg)
	cfg = cfg or {}
	local options = cfg.Options or {}
	local value = cfg.Default
	local n = #options
	local obj = {}
	local rec = newRow(self, Z.Row + n * Z.RadioRow + S.S, { Search = searchText(cfg, "Options") .. " " .. table.concat(options, " "),
		Tooltip = cfg.Tooltip, Menu = valueMenu(cfg, function() return obj end, cfg.Default) })
	Text(rec.Inner, "Body", { Text = cfg.Name or "Options", Size = UDim2.new(1, 0, 0, Z.Row) })
	local area = create("Frame", { BackgroundTransparency = 1, Position = UDim2.fromOffset(0, Z.Row - S.XS), Size = UDim2.new(1, 0, 0, n * Z.RadioRow), Parent = rec.Inner })
	local hl = Highlight(area, { Inset = Vector2.new(-S.S, 0) })
	local list = create("Frame", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 2, Parent = area }, { vlist(0) })
	local entries = {}
	local function render(animate)
		for _, e in ipairs(entries) do
			local on = e.opt == value
			if animate then e.dot:Set(on and 1 or 0) else e.dot:Snap(on and 1 or 0) end
			tween(e.ring, animate and M.State or 0, { Color = on and C.Accent or C.White, Transparency = on and 0 or A.BorderStrong })
			tween(e.label, animate and M.State or 0, { TextColor3 = on and C.Text or C.TextDim })
		end
	end
	for i, opt in ipairs(options) do
		local b = create("TextButton", { Size = UDim2.new(1, 0, 0, Z.RadioRow), BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
			LayoutOrder = i, ZIndex = 2, Parent = list })
		local circle = create("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.fromOffset(Z.Radio, Z.Radio),
			BackgroundColor3 = C.Bg, BorderSizePixel = 0, ZIndex = 2, Parent = b }, { corner(R.Pill) })
		local ring = stroke(C.White, A.BorderStrong)
		ring.Parent = circle
		local dot = create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(Z.RadioDot, Z.RadioDot),
			BorderSizePixel = 0, ZIndex = 3, Parent = circle }, { corner(R.Pill) })
		accentProp(dot, "BackgroundColor3")
		local dotScale = create("UIScale", { Scale = 0, Parent = dot })
		local label = Text(b, "Body", { Text = tostring(opt), TextColor3 = C.TextDim, ZIndex = 2,
			Position = UDim2.fromOffset(Z.Radio + S.M, 0), Size = UDim2.new(1, -(Z.Radio + S.M), 1, 0) })
		local e = { opt = opt, ring = ring, label = label }
		e.dot = spring(0, Tokens.Spring.Pop, function(x) dotScale.Scale = math.max(0, x) end)
		entries[i] = e
		hl:Attach(b)
		rec.BindMenu(b)
		b.MouseButton1Click:Connect(function()
			if value == opt then return end
			sfx("click", 1.1)
			value = opt
			render(true); setFlag(cfg, value); fire(cfg.Callback, value)
		end)
	end
	function obj:Get() return value end
	function obj:Set(v, silent)
		value = v; render(true); setFlag(cfg, value)
		if not silent then fire(cfg.Callback, value) end
	end
	paint(function() render(false) end)
	setFlag(cfg, value)
	return register(cfg, obj)
end

---------------------------------------------------------------- SEGMENTED (sliding pill, animate-ui "Tabs"/"Toggle Group")
function Section:AddSegmented(cfg)
	cfg = cfg or {}
	local options = cfg.Options or {}
	local n = math.max(#options, 1)
	local value = cfg.Default or options[1]
	local obj = {}
	local rec = newRow(self, rowHeight(cfg), { Search = searchText(cfg, "Segmented") .. " " .. table.concat(options, " "), Tooltip = cfg.Tooltip,
		Menu = valueMenu(cfg, function() return obj end, cfg.Default or options[1]) })
	labelBlock(rec.Inner, cfg, "Segmented", cfg.Width or 0.6, S.M)
	local well = Surface(rec.Inner, { Color = C.Bg, Radius = R.Control, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.new(cfg.Width or 0.6, 0, 0, Z.Control) })
	local inner = create("Frame", { BackgroundTransparency = 1, Position = UDim2.fromOffset(Z.SegPad, Z.SegPad),
		Size = UDim2.new(1, -2 * Z.SegPad, 1, -2 * Z.SegPad), Parent = well })
	local pill = create("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1 / n, 0, 1, 0), Parent = inner })
	Shadow(pill, "small", { Radius = R.Small })
	Surface(pill, { Color = C.Surface3, Radius = R.Small, StrokeAlpha = A.Border, Highlight = true })
	local row = create("Frame", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 2, Parent = inner }, { hlist(0) })
	local labels = {}
	local idx
	idx = spring(0, Tokens.Spring.Highlight, function(x)
		local stretch = math.min(math.abs(idx and idx.v or 0) * 0.015, 0.35)
		pill.Position = UDim2.new((x - stretch / 2) / n, 0, 0, 0)
		pill.Size = UDim2.new((1 + stretch) / n, 0, 1, 0)
	end)
	local function indexOf(v) for i, o in ipairs(options) do if o == v then return i end end return 1 end
	local function render(animate)
		local i = indexOf(value)
		if animate then idx:Set(i - 1) else idx:Snap(i - 1) end
		for j, l in ipairs(labels) do tween(l, animate and M.State or 0, { TextColor3 = (j == i) and C.Text or C.TextDim }) end
	end
	for i, opt in ipairs(options) do
		local b = create("TextButton", { Size = UDim2.new(1 / n, 0, 1, 0), BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
			LayoutOrder = i, ZIndex = 2, Parent = row })
		labels[i] = Text(b, "Body", { Text = tostring(opt), TextColor3 = C.TextDim, TextXAlignment = Enum.TextXAlignment.Center,
			TextTruncate = Enum.TextTruncate.AtEnd, Size = UDim2.fromScale(1, 1), ZIndex = 2 })
		rec.BindMenu(b)
		b.MouseEnter:Connect(function() if value ~= opt then tween(labels[i], M.Hover, { TextColor3 = C.Text }) end end)
		b.MouseLeave:Connect(function() if value ~= opt then tween(labels[i], M.Hover, { TextColor3 = C.TextDim }) end end)
		b.MouseButton1Click:Connect(function()
			if value == opt then return end
			sfx("click", 1.05)
			value = opt
			render(true); setFlag(cfg, value); fire(cfg.Callback, value)
		end)
	end
	function obj:Get() return value end
	function obj:Set(v, silent)
		value = v; render(true); setFlag(cfg, value)
		if not silent then fire(cfg.Callback, value) end
	end
	render(false); setFlag(cfg, value)
	return register(cfg, obj)
end

---------------------------------------------------------------- STATS (KPI tiles with counting numbers)
function Section:AddStats(items)
	items = items or {}
	local n = math.max(#items, 1)
	local names = {}
	for _, it in ipairs(items) do table.insert(names, it.Name or "") end
	local rec = newRow(self, Z.StatTile + S.M, { Search = table.concat(names, " ") })
	local row = create("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, Z.StatTile), Parent = rec.Inner }, { hlist(S.S) })
	local nums = {}
	for i, it in ipairs(items) do
		local tile = Surface(row, { Color = C.Bg, Radius = R.Control, Size = UDim2.new(1 / n, -round(S.S * (n - 1) / n), 1, 0), LayoutOrder = i })
		Text(tile, "Label", { Text = string.upper(it.Name or ""), Position = UDim2.fromOffset(S.M, S.S + 2), Size = UDim2.new(1, -2 * S.M, 0, 14),
			TextTruncate = Enum.TextTruncate.AtEnd })
		nums[i] = SlidingNumber(tile, { Style = "MonoLg", Suffix = it.Suffix, Decimals = it.Decimals, Thousands = it.Thousands,
			Position = UDim2.fromOffset(S.M, S.XXL + 2), Value = 0 })
		if it.Value then nums[i]:CountTo(it.Value) end
	end
	local obj = {}
	function obj:Set(i, v) if nums[i] then nums[i]:CountTo(v) end end
	function obj:Get(i) return nums[i] and nums[i]:Get() end
	return obj
end

---------------------------------------------------------------- SLIDER (sliding-number value pill)
function Section:AddSlider(cfg)
	cfg = cfg or {}
	local min, max = cfg.Min or 0, cfg.Max or 100
	local inc = cfg.Increment or 1
	local dec = decimals(inc)
	local suffix = cfg.Suffix or ""
	local value = math.clamp(cfg.Default or min, min, max)
	local obj = {}

	local rec = newRow(self, Z.RowSlider, { Interactive = true, Search = searchText(cfg, "Slider"), Tooltip = cfg.Tooltip,
		Menu = valueMenu(cfg, function() return obj end, value) })
	Text(rec.Inner, "Body", { Text = cfg.Name or "Slider", TextTruncate = Enum.TextTruncate.AtEnd,
		Position = UDim2.fromOffset(0, S.M), Size = UDim2.new(1, -112, 0, 16) })
	local pill = create("TextButton", {
		AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, S.M + 8 - Z.Pill / 2), Size = UDim2.fromOffset(0, Z.Pill),
		AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = C.Surface3, AutoButtonColor = false, Text = "", BorderSizePixel = 0, ZIndex = 6, Parent = rec.Inner,
	}, { corner(R.Small), pad(S.S, 0, S.S, 0) })
	local num = SlidingNumber(pill, { Style = "Mono", Color = C.Text, Decimals = dec, Suffix = suffix, AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.fromScale(0, 0.5), ZIndex = 6, Value = value })
	local editBox = TextInput(pill, "Mono", { TextColor3 = C.Text, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 1, 0),
		Visible = false, ZIndex = 7, ClipsDescendants = false })

	local TRACK_Y = Z.RowSlider - S.M - Z.Track
	local trackF = create("Frame", { Position = UDim2.fromOffset(0, TRACK_Y), Size = UDim2.new(1, 0, 0, Z.Track),
		BackgroundColor3 = C.Surface4, BorderSizePixel = 0, Parent = rec.Inner }, { corner(R.Pill) })
	local fill = create("Frame", { Size = UDim2.fromScale(0, 1), BorderSizePixel = 0, Parent = trackF }, { corner(R.Pill) })
	accentProp(fill, "BackgroundColor3")
	local thumbHost = create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0, 0.5), Size = UDim2.fromOffset(Z.Thumb, Z.Thumb),
		BackgroundTransparency = 1, ZIndex = 2, Parent = trackF })
	local thumbGlow = Glow(thumbHost, { Radius = R.Pill })
	shadowLevel(thumbGlow, 0, 0)
	Shadow(thumbHost, "small", { Radius = R.Pill, ZIndex = 2 })
	create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = C.White, BorderSizePixel = 0, ZIndex = 2, Parent = thumbHost }, { corner(R.Pill) })

	local relSpring = spring(0, Tokens.Spring.Thumb, function(r)
		fill.Size = UDim2.fromScale(r, 1)
		thumbHost.Position = UDim2.fromScale(r, 0.5)
	end)
	local dragging, hovering = false, false
	local function fmt(v) return string.format("%." .. dec .. "f", v) end
	local function grow(on)
		tween(thumbHost, M.Hover, { Size = on and UDim2.fromOffset(Z.ThumbActive, Z.ThumbActive) or UDim2.fromOffset(Z.Thumb, Z.Thumb) })
		shadowLevel(thumbGlow, on and 1 or 0, M.Hover)
	end
	local function render(animate)
		local rel = (max == min) and 0 or (value - min) / (max - min)
		if animate then relSpring:Set(rel) else relSpring:Snap(rel) end
		num:Set(value, not animate)
	end
	local function snap(v)
		v = math.floor((v - min) / inc + 0.5) * inc + min
		v = tonumber(string.format("%." .. dec .. "f", v))
		return math.clamp(v, min, max)
	end
	function obj:Set(v, silent)
		local nv = snap(tonumber(v) or value)
		local changed = nv ~= value
		value = nv
		render(true); setFlag(cfg, value)
		if changed and not silent then fire(cfg.Callback, value) end
	end
	function obj:Get() return value end

	local function fromInput(input)
		local rel = math.clamp((input.Position.X - trackF.AbsolutePosition.X) / trackF.AbsoluteSize.X, 0, 1)
		obj:Set(min + (max - min) * rel)
	end
	local hit = create("TextButton", { Position = UDim2.fromOffset(0, TRACK_Y - S.M), Size = UDim2.new(1, 0, 0, Z.Track + 2 * S.M),
		BackgroundTransparency = 1, Text = "", ZIndex = 5, Parent = rec.Inner })
	rec.BindMenu(hit)
	hit.MouseEnter:Connect(function() hovering = true; grow(true) end)
	hit.MouseLeave:Connect(function() hovering = false; if not dragging then grow(false) end end)
	hit.InputBegan:Connect(function(input)
		if isPress(input) then dragging = true; grow(true); fromInput(input) end
	end)
	track(UserInputService.InputChanged:Connect(function(input)
		if dragging and isMove(input) then fromInput(input) end
	end))
	track(UserInputService.InputEnded:Connect(function(input)
		if dragging and isPress(input) then
			dragging = false
			if not hovering then grow(false) end
		end
	end))
	-- click the value to type an exact number
	pill.MouseButton1Click:Connect(function()
		num.Holder.Visible = false
		editBox.Visible = true
		editBox.Text = fmt(value)
		editBox:CaptureFocus()
	end)
	editBox.FocusLost:Connect(function()
		local n = tonumber((editBox.Text:gsub("[^%d%.%-]", "")))
		editBox.Visible = false
		num.Holder.Visible = true
		if n then obj:Set(n) end
	end)

	render(false); setFlag(cfg, value)
	return register(cfg, obj)
end

---------------------------------------------------------------- TEXTBOX (optional copy button)
function Section:AddTextbox(cfg)
	cfg = cfg or {}
	local obj = {}
	local rec = newRow(self, Z.RowDesc, { Interactive = true, Search = searchText(cfg, "Textbox"), Tooltip = cfg.Tooltip,
		Menu = valueMenu(cfg, function() return obj end, cfg.Default or "") })
	labelBlock(rec.Inner, cfg, "Textbox", Z.ControlFrac, S.M)
	local maxLen = cfg.MaxLength
	local btnSize = Z.IconSm + S.XS
	local reserve = btnSize + (cfg.Copy and btnSize or 0) + (maxLen and 36 or 0)
	local field = Field(rec.Inner, { Placeholder = cfg.Placeholder or "Enter text", Text = cfg.Default or "", RightReserve = reserve, ClearOnFocus = cfg.ClearOnFocus })
	local input = field.Input
	local rightX = -S.S + 2
	local copyBtn
	if cfg.Copy then
		local copyIc
		copyBtn, copyIc = iconButton(field.Well, "copy", btnSize, { IconSize = Z.IconXs, Color = C.TextMute, HoverColor = C.Text, Radius = R.Tiny,
			AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, rightX, 0.5, 0), ZIndex = 3 })
		local done = CheckMark(copyBtn, Z.IconXs, C.Success)
		local busy = false
		copyBtn.MouseButton1Click:Connect(function()
			if busy then return end
			if not copyText(input.Text) then
				Library:Notify({ Title = "Clipboard unavailable", Content = "This environment can't write to the clipboard.", Type = "Warning", Duration = 3 })
				return
			end
			busy = true
			fadeIcon(copyIc, 1, M.Hover)
			done:Set(true, true)
			task.delay(M.Done, function()
				done:Set(false, true)
				task.delay(M.Draw, function() fadeIcon(copyIc, 0, M.State); busy = false end)
			end)
		end)
		rightX = rightX - btnSize
	end
	local clear = iconButton(field.Well, "x", btnSize, {
		IconSize = Z.IconXs, Color = C.TextMute, HoverColor = C.Text, Radius = R.Tiny,
		AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, rightX, 0.5, 0), ZIndex = 3,
	})
	local counter
	if maxLen then
		counter = Text(field.Well, "MonoSm", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, rightX - btnSize, 0.5, 0),
			Size = UDim2.fromOffset(36, 14), TextXAlignment = Enum.TextXAlignment.Right })
	end

	local function refresh()
		clear.Visible = input.Text ~= ""
		if counter then counter.Text = #input.Text .. "/" .. maxLen end
	end
	input.FocusLost:Connect(function(enter)
		setFlag(cfg, input.Text)
		fire(cfg.Callback, input.Text, enter)
	end)
	input:GetPropertyChangedSignal("Text"):Connect(function()
		local txt = input.Text
		if cfg.NumbersOnly then
			local cleaned = txt:gsub("[^%d%.%-]", "")
			if cleaned ~= txt then input.Text = cleaned return end
		end
		if maxLen and #txt > maxLen then input.Text = txt:sub(1, maxLen) return end
		refresh()
	end)
	clear.MouseButton1Click:Connect(function() input.Text = ""; setFlag(cfg, ""); fire(cfg.Callback, "", false) end)
	function obj:Set(t) input.Text = tostring(t); setFlag(cfg, input.Text) end
	function obj:Get() return input.Text end
	refresh(); setFlag(cfg, input.Text)
	return register(cfg, obj)
end

---------------------------------------------------------------- DROPDOWN (popover · swapping value text)
local function summarize(list)
	if #list == 0 then return "None" end
	if #list <= 2 then return table.concat(list, ", ") end
	return list[1] .. ", " .. list[2] .. " +" .. (#list - 2)
end

local function selectButton(parent)
	local btn = create("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.new(Z.ControlFrac, 0, 0, Z.Control),
		BackgroundColor3 = C.Surface3, AutoButtonColor = false, Text = "", BorderSizePixel = 0, ClipsDescendants = true, Parent = parent,
	}, { corner(R.Control) })
	local st = stroke(C.White, A.Border)
	st.Parent = btn
	local lbl = Text(btn, "Body", { Position = UDim2.fromOffset(S.M, 0), Size = UDim2.new(1, -(S.M * 2 + Z.IconSm + S.XS), 1, 0), TextTruncate = Enum.TextTruncate.AtEnd })
	local chev = Icon("chevron-down", Z.IconSm, C.TextMute, btn)
	chev.AnchorPoint = Vector2.new(1, 0.5)
	chev.Position = UDim2.new(1, -S.M + 2, 0.5, 0)
	btn.MouseEnter:Connect(function() tween(btn, M.Hover, { BackgroundColor3 = C.Surface4 }); tween(st, M.Hover, { Transparency = A.BorderStrong }) end)
	btn.MouseLeave:Connect(function() tween(btn, M.Hover, { BackgroundColor3 = C.Surface3 }); tween(st, M.Hover, { Transparency = A.Border }) end)
	return btn, lbl, chev
end

function Section:AddDropdown(cfg)
	cfg = cfg or {}
	local options = cfg.Options or {}
	local multi = cfg.Multi == true
	local selected, single = {}, nil
	if multi then for _, v in ipairs(cfg.Default or {}) do selected[v] = true end else single = cfg.Default end
	local obj = {}

	local rec = newRow(self, rowHeight(cfg), { Interactive = true, Search = searchText(cfg, "Dropdown"), Tooltip = cfg.Tooltip,
		Menu = valueMenu(cfg, function() return obj end, cfg.Default) })
	labelBlock(rec.Inner, cfg, "Dropdown", Z.ControlFrac, S.M)
	local btn, valueLbl, chev = selectButton(rec.Inner)
	rec.BindMenu(btn)

	local popApi
	local function getValue()
		if not multi then return single end
		local out = {}
		for _, o in ipairs(options) do if selected[o] then table.insert(out, o) end end
		return out
	end
	local function display()
		if multi then return summarize(getValue()) end
		return single ~= nil and tostring(single) or "Select"
	end
	local function visual(animate, dir)
		if animate then swapText(valueLbl, display(), dir) else valueLbl.Text = display() end
		valueLbl.TextColor3 = (multi and #getValue() == 0 or (not multi and single == nil)) and C.TextMute or C.Text
	end
	local function open()
		popApi = openPopover(btn, {
			Width = math.max(btn.AbsoluteSize.X / Library._uiScale, Z.PopMinW),
			OnClose = function() popApi = nil; tween(chev, M.State, { Rotation = 0 }) end,
			Build = function(surface, api)
				local rebuild = PopoverList(surface, api, {
					Options = function() return options end,
					Search = #options > Z.PopSearchAt,
					IsSelected = function(o) if multi then return selected[o] == true end return single == o end,
					OnPick = function(o)
						local before = multi and #getValue() or 0
						if multi then selected[o] = not selected[o] or nil else single = o end
						local dir = multi and ((#getValue() >= before) and 1 or -1) or 1
						visual(true, dir); setFlag(cfg, getValue()); fire(cfg.Callback, getValue())
						if not multi then api:Close() end
					end,
				})
				rebuild("")
			end,
		})
		tween(chev, M.State, { Rotation = 180 })
	end
	btn.MouseButton1Click:Connect(function()
		sfx("click", 1)
		if popApi and popApi:IsOpen() then popApi:Close() else open() end
	end)

	function obj:Get() return getValue() end
	function obj:Set(v, silent)
		selected, single = {}, nil
		if multi then for _, x in ipairs(type(v) == "table" and v or {}) do selected[x] = true end else single = v end
		visual(true); setFlag(cfg, getValue())
		if not silent then fire(cfg.Callback, getValue()) end
	end
	function obj:Refresh(newOptions)
		options = newOptions or {}
		if popApi and popApi:IsOpen() then popApi:Close() end
		visual(false)
	end
	visual(false); setFlag(cfg, getValue())
	return register(cfg, obj)
end

---------------------------------------------------------------- COMBOBOX (field + filtered popover)
function Section:AddCombobox(cfg)
	cfg = cfg or {}
	local options = cfg.Options or {}
	local allowCustom = cfg.AllowCustom ~= false
	local value = cfg.Default or ""
	local obj = {}

	local rec = newRow(self, Z.RowDesc, { Interactive = true, Search = searchText(cfg, "Combobox"), Tooltip = cfg.Tooltip,
		Menu = valueMenu(cfg, function() return obj end, cfg.Default) })
	labelBlock(rec.Inner, cfg, "Combobox", Z.ControlFrac, S.M)
	local field = Field(rec.Inner, { Placeholder = cfg.Placeholder or "Search", Text = value, RightReserve = Z.IconSm, Icon = "search" })
	local input = field.Input
	local chev = Icon("chevrons-up-down", Z.IconSm, C.TextMute, field.Well)
	chev.AnchorPoint = Vector2.new(1, 0.5)
	chev.Position = UDim2.new(1, -S.M + 2, 0.5, 0)

	local popApi, rebuild = nil, nil
	local function query() return (input.Text == value) and "" or input.Text end
	local function choose(opt)
		if popApi then popApi:Close() end
		value = tostring(opt)
		input.Text = value
		setFlag(cfg, value)
		input:ReleaseFocus()
		fire(cfg.Callback, value)
	end
	local function open()
		if popApi and popApi:IsOpen() then return end
		popApi = openPopover(field.Well, {
			Width = math.max(field.Well.AbsoluteSize.X / Library._uiScale, Z.PopMinW),
			OnClose = function() popApi, rebuild = nil, nil end,
			Build = function(surface, api)
				rebuild = PopoverList(surface, api, {
					Options = function() return options end,
					IsSelected = function(o) return tostring(o) == value end,
					OnPick = choose, PickOnDown = true, CloseOnPick = true,
				})
				rebuild(query())
			end,
		})
	end
	input.Focused:Connect(open)
	input:GetPropertyChangedSignal("Text"):Connect(function()
		if rebuild and input:IsFocused() then rebuild(query()) end
	end)
	input.FocusLost:Connect(function(enter)
		if enter then
			if allowCustom and input.Text ~= "" and input.Text ~= value then
				value = input.Text; setFlag(cfg, value); fire(cfg.Callback, value)
			end
			if popApi then popApi:Close() end
		end
	end)

	function obj:Get() return value end
	function obj:Set(v, silent)
		value = tostring(v); input.Text = value; setFlag(cfg, value)
		if not silent then fire(cfg.Callback, value) end
	end
	function obj:Refresh(newOptions)
		options = newOptions or {}
		if rebuild then rebuild(query()) end
	end
	setFlag(cfg, value)
	return register(cfg, obj)
end

---------------------------------------------------------------- LISTBOX (well · shared highlight · drawn checks)
function Section:AddListbox(cfg)
	cfg = cfg or {}
	local options = cfg.Options or {}
	local multi = cfg.Multi ~= false
	local HEIGHT = cfg.Height or 130
	local selected, single, entries = {}, nil, {}
	if multi then for _, v in ipairs(cfg.Default or {}) do selected[v] = true end else single = cfg.Default end
	local obj = {}

	local rec = newRow(self, Z.Row + HEIGHT + S.M, { Search = searchText(cfg, "Listbox"), Tooltip = cfg.Tooltip,
		Menu = valueMenu(cfg, function() return obj end, cfg.Default) })
	Text(rec.Inner, "Body", { Text = cfg.Name or "Listbox", Size = UDim2.new(1, -140, 0, Z.Row) })
	local controls = create("Frame", { AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0), Size = UDim2.new(0, 0, 0, Z.Row),
		AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, Parent = rec.Inner }, { hlist(S.M) })
	local count = SlidingNumber(controls, { Style = "MonoSm", Suffix = " of " .. #options, LayoutOrder = 1 })
	local well = Surface(rec.Inner, { Name = "Well", Color = C.Bg, Radius = R.Control, Position = UDim2.fromOffset(0, Z.Row), Size = UDim2.new(1, 0, 0, HEIGHT) })
	local _, sf = Scroller(well, { FadeColor = C.Bg })
	pad(S.XS).Parent = sf
	local _, list, hl = HighlightList(sf)

	local function getValue()
		if not multi then return single end
		local out = {}
		for _, o in ipairs(options) do if selected[o] then table.insert(out, o) end end
		return out
	end
	local function visual(animate)
		local n = 0
		for _, e in ipairs(entries) do
			local on = (multi and selected[e.opt] == true) or (not multi and single == e.opt)
			e.set(on, animate)
			if on then n = n + 1 end
		end
		count:Set(n, not animate)
	end
	local function changed() visual(true); setFlag(cfg, getValue()); fire(cfg.Callback, getValue()) end
	local function build()
		hl:Hide()
		for _, c in ipairs(list:GetChildren()) do if c:IsA("GuiObject") then c:Destroy() end end
		entries = {}
		for i, opt in ipairs(options) do
			local item, set = OptionItem(list, tostring(opt), i)
			hl:Attach(item)
			table.insert(entries, { opt = opt, set = set })
			item.MouseButton1Click:Connect(function()
				sfx("click", 1.1)
				if multi then selected[opt] = not selected[opt] or nil else single = opt end
				changed()
			end)
		end
		visual(false)
	end
	if multi then
		local function mini(text, order, fn)
			local b = create("TextButton", { AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 1, 0), BackgroundTransparency = 1,
				Text = text, AutoButtonColor = false, LayoutOrder = order, Parent = controls })
			for k, v in pairs(styleProps("Label")) do b[k] = v end
			b.MouseEnter:Connect(function() tween(b, M.Hover, { TextColor3 = C.Text }) end)
			b.MouseLeave:Connect(function() tween(b, M.Hover, { TextColor3 = C.TextMute }) end)
			b.MouseButton1Click:Connect(function() sfx("click", 1); fn() end)
		end
		mini("ALL", 2, function() for _, o in ipairs(options) do selected[o] = true end changed() end)
		mini("NONE", 3, function() selected = {} changed() end)
	end

	function obj:Get() return getValue() end
	function obj:Set(v, silent)
		selected, single = {}, nil
		if multi then for _, x in ipairs(type(v) == "table" and v or {}) do selected[x] = true end else single = v end
		visual(true); setFlag(cfg, getValue())
		if not silent then fire(cfg.Callback, getValue()) end
	end
	function obj:Refresh(newOptions) options = newOptions or {}; build() end
	function obj:Add(opt) table.insert(options, opt); build() end
	build(); setFlag(cfg, getValue())
	return register(cfg, obj)
end

---------------------------------------------------------------- KEYBIND (physical keycap)
local KeyNames = {
	LeftControl = "Ctrl", RightControl = "RCtrl", LeftShift = "Shift", RightShift = "RShift", LeftAlt = "Alt", RightAlt = "RAlt",
	Return = "Enter", Backspace = "Bksp", Space = "Space", Tab = "Tab", CapsLock = "Caps", Escape = "Esc",
	One = "1", Two = "2", Three = "3", Four = "4", Five = "5", Six = "6", Seven = "7", Eight = "8", Nine = "9", Zero = "0",
}
local function prettyKey(k) return k and (KeyNames[k.Name] or k.Name) or "None" end

local function Keycap(parent, props)
	local base = create("Frame", {
		Name = "Keycap", AnchorPoint = props.AnchorPoint or Vector2.new(1, 0.5), Position = props.Position or UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(0, props.Height or Z.Keycap), AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = C.KeyLip,
		BorderSizePixel = 0, ClipsDescendants = true, ZIndex = props.ZIndex or 1, Parent = parent,
	}, { corner(R.Small) })
	local face = create("Frame", { Size = UDim2.new(1, 0, 1, -Z.KeyLip), BackgroundColor3 = C.Surface3, BorderSizePixel = 0, ZIndex = props.ZIndex or 1, Parent = base }, { corner(R.Small) })
	local st = stroke(C.White, A.Border)
	st.Parent = face
	local lbl = Text(base, props.Style or "Mono", { TextColor3 = C.Text, TextXAlignment = Enum.TextXAlignment.Center,
		AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 1, -Z.KeyLip), ZIndex = (props.ZIndex or 1) + 1 })
	pad(S.S, 0, S.S, 0).Parent = lbl
	return base, face, lbl, st
end

function Section:AddKeybind(cfg)
	cfg = cfg or {}
	local key = cfg.Default
	local listening = false
	local obj = {}
	local rec = newRow(self, rowHeight(cfg), { Interactive = true, Search = searchText(cfg, "Keybind"), Tooltip = cfg.Tooltip,
		Menu = valueMenu(cfg, function() return obj end, cfg.Default, {
			{ Text = "Clear binding", Icon = "x", Callback = function() obj:Set(nil) end },
		}) })
	labelBlock(rec.Inner, cfg, "Keybind", 0, 120)
	local base, face, lbl, st = Keycap(rec.Inner, {})
	local hit = create("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", ZIndex = 5, Parent = base })
	rec.BindMenu(hit)
	local pulse

	local function press()
		face.Position = UDim2.fromOffset(0, Z.KeyLip)
		face.BackgroundColor3 = C.Surface4
		tween(face, M.Enter, { Position = UDim2.new(), BackgroundColor3 = C.Surface3 }, Tokens.Ease.Enter)
	end
	local function render(animate)
		if pulse then pulse:Cancel(); pulse = nil end
		if listening then
			lbl.Text = "Press a key…"
			lbl.TextColor3 = C.TextDim
			st.Color, st.Transparency = C.Accent, 0.3
			pulse = loopTween(st, M.Enter * 3, { Transparency = 0.8 })
		else
			if animate then swapText(lbl, prettyKey(key)) else lbl.Text = prettyKey(key) end
			lbl.TextColor3 = key and C.Text or C.TextMute
			tween(st, M.State, { Color = C.White, Transparency = A.Border })
		end
	end
	hit.MouseButton1Click:Connect(function() sfx("click", 1); press(); listening = true; render() end)
	track(UserInputService.InputBegan:Connect(function(input, gp)
		if listening then
			if input.UserInputType == Enum.UserInputType.Keyboard then
				listening = false
				if input.KeyCode == Enum.KeyCode.Backspace then key = nil
				elseif input.KeyCode ~= Enum.KeyCode.Escape then key = input.KeyCode end
				render(true); press(); setFlag(cfg, key)
				fire(cfg.OnChange, key)
			end
		elseif not gp and key and input.KeyCode == key then
			press()
			fire(cfg.Callback, key)
		end
	end))
	function obj:Get() return key end
	function obj:Set(k) key = k; listening = false; render(true); setFlag(cfg, key); fire(cfg.OnChange, key) end
	render(false); setFlag(cfg, key)
	return register(cfg, obj)
end

---------------------------------------------------------------- COLOR PICKER (popover)
local SWATCH_PRESETS = {
	Color3.fromRGB(92, 156, 255), Color3.fromRGB(150, 120, 250), Color3.fromRGB(52, 201, 150),
	Color3.fromRGB(230, 180, 72), Color3.fromRGB(246, 132, 72), Color3.fromRGB(240, 112, 168), Color3.fromRGB(236, 238, 242),
}
local HUE_SEQ = seq({ 0, Color3.fromRGB(255, 0, 0) }, { 1 / 6, Color3.fromRGB(255, 255, 0) }, { 2 / 6, Color3.fromRGB(0, 255, 0) },
	{ 3 / 6, Color3.fromRGB(0, 255, 255) }, { 4 / 6, Color3.fromRGB(0, 0, 255) }, { 5 / 6, Color3.fromRGB(255, 0, 255) }, { 1, Color3.fromRGB(255, 0, 0) })

function Section:AddColorPicker(cfg)
	cfg = cfg or {}
	local color = cfg.Default or C.Accent
	local h, s, v = color:ToHSV()
	local rainbow, rainbowStep = false, nil
	local obj = {}

	local rec = newRow(self, rowHeight(cfg), { Interactive = true, Search = searchText(cfg, "Color"), Tooltip = cfg.Tooltip,
		Menu = valueMenu(cfg, function() return obj end, cfg.Default, {
			{ Text = "Copy hex", Icon = "copy", Callback = function() copyText(toHex(color)) end },
		}) })
	labelBlock(rec.Inner, cfg, "Color", 0, Z.Swatch + S.S + 72)
	local hexLbl = Text(rec.Inner, "Mono", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -(Z.Swatch + S.S), 0.5, 0),
		Size = UDim2.fromOffset(72, 16), TextXAlignment = Enum.TextXAlignment.Right })
	local swatch = create("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(Z.Swatch, Z.Swatch),
		BackgroundColor3 = color, AutoButtonColor = false, Text = "", BorderSizePixel = 0, ZIndex = 5, Parent = rec.Inner,
	}, { corner(R.Small) })
	stroke(C.White, A.BorderStrong).Parent = swatch
	rec.BindMenu(swatch)
	swatch.MouseEnter:Connect(function() popScale(swatch, 0.9) end)

	local popApi
	local ui = {}
	local function render()
		color = Color3.fromHSV(h, s, v)
		swatch.BackgroundColor3 = color
		hexLbl.Text = toHex(color)
		if ui.sv and ui.sv.Parent then
			ui.sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
			ui.svCursor.Position = UDim2.fromScale(s, 1 - v)
			ui.hueHandle.Position = UDim2.fromScale(h, 0.5)
			ui.preview.BackgroundColor3 = color
			if not ui.hex.Input:IsFocused() then ui.hex.Input.Text = toHex(color) end
		end
	end
	local function commit() setFlag(cfg, color); fire(cfg.Callback, color) end
	local function setRainbow(on)
		rainbow = on
		if ui.cycle and ui.cycle.Parent then tween(ui.cycle, M.State, { TextColor3 = on and C.Accent or C.TextDim }) end
		if on and not rainbowStep then
			local acc = 0
			rainbowStep = stepper(function(dt)
				h = (h + dt * 0.15) % 1
				if s < 0.2 then s = 1 end
				if v < 0.2 then v = 1 end
				render()
				acc = acc + dt
				if acc > 0.05 then acc = 0; commit() end
			end)
		elseif not on and rainbowStep then
			unstep(rainbowStep); rainbowStep = nil
		end
	end

	local function buildPicker(surface, api)
		local P = S.M
		local w = Z.ColorPop - 2 * P
		local conns = {}
		local sv = create("Frame", { Position = UDim2.fromOffset(P, P), Size = UDim2.fromOffset(w, Z.SV.Y), BackgroundColor3 = Color3.fromHSV(h, 1, 1),
			BorderSizePixel = 0, Parent = surface }, { corner(R.Small) })
		create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = C.White, BorderSizePixel = 0, Parent = sv },
			{ corner(R.Small), create("UIGradient", { Transparency = NumberSequence.new(0, 1) }) })
		create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = C.Shadow, BorderSizePixel = 0, Parent = sv },
			{ corner(R.Small), create("UIGradient", { Rotation = 90, Transparency = NumberSequence.new(1, 0) }) })
		local svCursor = create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(Z.HueHandle - 2, Z.HueHandle - 2),
			BackgroundTransparency = 1, ZIndex = 3, Parent = sv }, { corner(R.Pill), stroke(C.White, 0, 2) })
		local cursorScale = create("UIScale", { Parent = svCursor })

		local hueY = P + Z.SV.Y + P
		local hue = create("Frame", { Position = UDim2.fromOffset(P, hueY), Size = UDim2.fromOffset(w, Z.Hue), BackgroundColor3 = C.White,
			BorderSizePixel = 0, Parent = surface }, { corner(R.Pill), create("UIGradient", { Color = HUE_SEQ }) })
		local hueHandle = create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(Z.HueHandle, Z.HueHandle),
			BackgroundTransparency = 1, ZIndex = 3, Parent = hue })
		local handleScale = create("UIScale", { Parent = hueHandle })
		Shadow(hueHandle, "small", { Radius = R.Pill, ZIndex = 3 })
		create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = C.White, BorderSizePixel = 0, ZIndex = 3, Parent = hueHandle }, { corner(R.Pill) })

		local rowY = hueY + Z.Hue + P
		local preview = create("Frame", { Position = UDim2.fromOffset(P, rowY), Size = UDim2.fromOffset(Z.Control, Z.Control), BackgroundColor3 = color,
			BorderSizePixel = 0, Parent = surface }, { corner(R.Control), stroke(C.White, A.BorderStrong) })
		local hex = Field(surface, { AnchorPoint = Vector2.zero, Position = UDim2.fromOffset(P + Z.Control + S.S, rowY),
			Size = UDim2.fromOffset(w - 72 - Z.Control - 2 * S.S, Z.Control), Style = "Mono", Text = toHex(color) })
		local cycle = create("TextButton", { Position = UDim2.fromOffset(P + w - 72, rowY), Size = UDim2.fromOffset(72, Z.Control),
			BackgroundColor3 = C.Surface3, AutoButtonColor = false, Text = "Cycle", BorderSizePixel = 0, Parent = surface }, { corner(R.Control) })
		for k, val in pairs(styleProps("Body")) do cycle[k] = val end
		cycle.TextColor3 = rainbow and C.Accent or C.TextDim
		stroke(C.White, A.Border).Parent = cycle

		local presetY = rowY + Z.Control + P
		local row = create("Frame", { Position = UDim2.fromOffset(P, presetY), Size = UDim2.fromOffset(w, Z.SwatchSm), BackgroundTransparency = 1, Parent = surface },
			{ hlist(S.S + 2) })
		for i, pc in ipairs(SWATCH_PRESETS) do
			local p = create("TextButton", { Size = UDim2.fromOffset(Z.SwatchSm, Z.SwatchSm), BackgroundColor3 = pc, AutoButtonColor = false,
				Text = "", BorderSizePixel = 0, LayoutOrder = i, Parent = row }, { corner(R.Small - 1) })
			local pst = stroke(C.White, A.BorderStrong)
			pst.Parent = p
			p.MouseEnter:Connect(function() tween(pst, M.Hover, { Transparency = 0.4 }); popScale(p, 0.85) end)
			p.MouseLeave:Connect(function() tween(pst, M.Hover, { Transparency = A.BorderStrong }) end)
			p.MouseButton1Click:Connect(function()
				sfx("click", 1.2); h, s, v = pc:ToHSV(); render(); commit()
				popScale(swatch, 0.7); popScale(preview, 0.8)
			end)
		end

		ui = { sv = sv, svCursor = svCursor, hueHandle = hueHandle, hex = hex, cycle = cycle, preview = preview }
		local mode
		local function update(input)
			if mode == "sv" then
				s = math.clamp((input.Position.X - sv.AbsolutePosition.X) / sv.AbsoluteSize.X, 0, 1)
				v = 1 - math.clamp((input.Position.Y - sv.AbsolutePosition.Y) / sv.AbsoluteSize.Y, 0, 1)
			elseif mode == "hue" then
				h = math.clamp((input.Position.X - hue.AbsolutePosition.X) / hue.AbsoluteSize.X, 0, 0.999)
			end
			render(); commit()
		end
		sv.InputBegan:Connect(function(i) if isPress(i) then mode = "sv"; tween(cursorScale, M.Hover, { Scale = 1.3 }); update(i) end end)
		hue.InputBegan:Connect(function(i) if isPress(i) then mode = "hue"; tween(handleScale, M.Hover, { Scale = 1.2 }); update(i) end end)
		table.insert(conns, UserInputService.InputChanged:Connect(function(i) if mode and isMove(i) then update(i) end end))
		table.insert(conns, UserInputService.InputEnded:Connect(function(i)
			if mode and isPress(i) then
				mode = nil
				tween(cursorScale, M.State, { Scale = 1 }); tween(handleScale, M.State, { Scale = 1 })
			end
		end))
		hex.Input.FocusLost:Connect(function()
			local c = fromHex(hex.Input.Text)
			if c then h, s, v = c:ToHSV(); render(); commit() else hex.Input.Text = toHex(color) end
		end)
		cycle.MouseButton1Click:Connect(function() sfx("click", 1); setRainbow(not rainbow) end)
		api.Conns = conns
		render()
		return presetY + Z.SwatchSm + P
	end

	swatch.MouseButton1Click:Connect(function()
		sfx("click", 1)
		if popApi and popApi:IsOpen() then popApi:Close() return end
		popApi = openPopover(swatch, {
			Width = Z.ColorPop, Align = "right", Build = buildPicker,
			OnClose = function()
				if popApi and popApi.Conns then for _, c in ipairs(popApi.Conns) do c:Disconnect() end end
				popApi, ui = nil, {}
			end,
		})
	end)

	function obj:Get() return color end
	function obj:Set(c, silent)
		h, s, v = c:ToHSV(); render(); setFlag(cfg, color)
		if not silent then fire(cfg.Callback, color) end
	end
	render(); setFlag(cfg, color)
	return register(cfg, obj)
end

---------------------------------------------------------------- PROGRESS (sliding percent · sheen while changing)
function Section:AddProgress(cfg)
	cfg = cfg or {}
	local value = math.clamp(cfg.Default or 0, 0, 100)
	local rec = newRow(self, Z.RowProgress, { Search = searchText(cfg, "Progress"), Tooltip = cfg.Tooltip })
	Text(rec.Inner, "Body", { Text = cfg.Name or "Progress", Position = UDim2.fromOffset(0, S.M), Size = UDim2.new(1, -64, 0, 16) })
	local pct = SlidingNumber(rec.Inner, { Style = "Mono", Suffix = "%", AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, S.M - 2), Value = value })
	local trackF = create("Frame", { Position = UDim2.fromOffset(0, Z.RowProgress - S.M - Z.ProgressTrack), Size = UDim2.new(1, 0, 0, Z.ProgressTrack),
		BackgroundColor3 = C.Surface4, BorderSizePixel = 0, ClipsDescendants = true, Parent = rec.Inner }, { corner(R.Pill) })
	local fill = create("Frame", { Size = UDim2.fromScale(0, 1), BorderSizePixel = 0, ClipsDescendants = true, Parent = trackF }, { corner(R.Pill) })
	accentProp(fill, "BackgroundColor3")
	local sheen = create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = C.White, BorderSizePixel = 0, Parent = fill })
	local sg = create("UIGradient", { Transparency = NumberSequence.new({ kp(0, 1), kp(0.4, 1), kp(0.5, A.Sheen), kp(0.6, 1), kp(1, 1) }),
		Offset = Vector2.new(-1, 0), Parent = sheen })
	local sheenTween

	local obj = {}
	function obj:Set(x, instant)
		local nv = math.clamp(tonumber(x) or 0, 0, 100)
		local changed = math.abs(nv - value) >= 0.5
		value = nv
		tween(fill, instant and 0 or M.Enter * 2, { Size = UDim2.fromScale(value / 100, 1) }, Tokens.Ease.Enter)
		pct:Set(round(value), instant)
		if changed and not instant and not (sheenTween and sheenTween.PlaybackState == Enum.PlaybackState.Playing) then
			sg.Offset = Vector2.new(-1, 0)
			sheenTween = tween(sg, M.Sheen, { Offset = Vector2.new(1, 0) }, Tokens.Ease.Linear)
		end
	end
	function obj:Get() return value end
	obj:Set(value, true)
	return obj
end

---------------------------------------------------------------- GRAPH (smoothed line + gradient area)
function Section:AddGraph(cfg)
	cfg = cfg or {}
	local N = math.max(cfg.Bars or 30, 4)
	local max = cfg.Max or 100
	local SUB = 3
	local P = (N - 1) * SUB + 1

	local rec = newRow(self, Z.RowGraph, { Search = searchText(cfg, "Graph"), Tooltip = cfg.Tooltip })
	Text(rec.Inner, "Body", { Text = cfg.Name or "Graph", Position = UDim2.fromOffset(0, S.M), Size = UDim2.new(1, -96, 0, 16) })
	local cur = SlidingNumber(rec.Inner, { Style = "Mono", Color = C.Text, Suffix = cfg.Suffix, AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 0, 0, S.M - 2) })
	local plot = create("Frame", { Position = UDim2.fromOffset(0, S.M + 16 + S.M), Size = UDim2.new(1, 0, 0, Z.GraphPlot),
		BackgroundTransparency = 1, ClipsDescendants = true, Parent = rec.Inner })
	for i = 0, 2 do
		create("Frame", { Position = UDim2.new(0, 0, i / 2, i == 2 and -1 or 0), Size = UDim2.new(1, 0, 0, Z.Divider),
			BackgroundColor3 = C.White, BackgroundTransparency = A.Border, BorderSizePixel = 0, Parent = plot })
	end
	local columns, segments = {}, {}
	for i = 1, P do
		local col = create("Frame", { BorderSizePixel = 0, Parent = plot },
			{ create("UIGradient", { Rotation = 90, Transparency = NumberSequence.new(0.8, 1) }) })
		accentProp(col, "BackgroundColor3")
		columns[i] = col
	end
	for i = 1, P - 1 do
		local seg = create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), BorderSizePixel = 0, ZIndex = 2, Parent = plot }, { corner(R.Pill) })
		accentProp(seg, "BackgroundColor3")
		segments[i] = seg
	end
	local head = create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(6, 6), BorderSizePixel = 0, ZIndex = 3, Parent = plot },
		{ corner(R.Pill), stroke(C.Surface2, 0, 2) })
	accentProp(head, "BackgroundColor3")
	local values = {}
	for i = 1, N do values[i] = 0 end

	local function draw()
		local scale = Library._uiScale
		local w, hgt = plot.AbsoluteSize.X / scale, plot.AbsoluteSize.Y / scale
		if w <= 0 then return end
		local function yOf(val) return hgt - math.clamp(val / max, 0, 1) * (hgt - 6) - 3 end
		local pts = {}
		for i = 1, N - 1 do
			local p0 = yOf(values[math.max(i - 1, 1)])
			local p1 = yOf(values[i])
			local p2 = yOf(values[i + 1])
			local p3 = yOf(values[math.min(i + 2, N)])
			for j = 0, SUB - 1 do
				local t = j / SUB
				local t2, t3 = t * t, t * t * t
				local y = 0.5 * (2 * p1 + (-p0 + p2) * t + (2 * p0 - 5 * p1 + 4 * p2 - p3) * t2 + (-p0 + 3 * p1 - 3 * p2 + p3) * t3)
				table.insert(pts, { x = ((i - 1) + t) / (N - 1) * w, y = math.clamp(y, 1, hgt - 1) })
			end
		end
		table.insert(pts, { x = w, y = yOf(values[N]) })
		local colW = w / (P - 1)
		for i, pt in ipairs(pts) do
			local col = columns[i]
			col.Position = UDim2.fromOffset(pt.x - colW / 2, pt.y)
			col.Size = UDim2.fromOffset(colW + 1, hgt - pt.y)
			local nxt = pts[i + 1]
			if nxt then
				local dx, dy = nxt.x - pt.x, nxt.y - pt.y
				local seg = segments[i]
				seg.Position = UDim2.fromOffset((pt.x + nxt.x) / 2, (pt.y + nxt.y) / 2)
				seg.Size = UDim2.fromOffset(math.sqrt(dx * dx + dy * dy) + 1, Z.GraphLine)
				seg.Rotation = math.deg(math.atan2(dy, dx))
			end
		end
		local last = pts[#pts]
		head.Position = UDim2.fromOffset(last.x - 3, last.y)
	end
	plot:GetPropertyChangedSignal("AbsoluteSize"):Connect(draw)

	local obj = {}
	function obj:Push(x)
		table.remove(values, 1)
		table.insert(values, tonumber(x) or 0)
		cur:Set(round(tonumber(x) or 0))
		draw()
	end
	task.defer(draw)
	return obj
end

----------------------------------------------------------------------
-- TAB / SECTION CARDS  (collapsible like animate-ui "Accordion")
----------------------------------------------------------------------
local Tab = {}
Tab.__index = Tab

function Tab:AddSection(name, side, opts)
	opts = opts or {}
	self._count = self._count + 1
	side = side or ((self._count % 2 == 1) and "Left" or "Right")
	local column = (side == "Right") and self.Right or self.Left

	local wrapper = create("Frame", {
		Name = name or "Section", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = self._count, Parent = column,
	})
	-- the shadow's height is pinned to the card (in offset) so it can't feed the wrapper's AutomaticSize
	local cardShadow = Shadow(wrapper, "card", { Radius = R.Card })
	cardShadow.Size = UDim2.new(1, 0, 0, 0)
	local card = create("CanvasGroup", {
		Name = "Card", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = wrapper,
	})
	local function syncCardShadow()
		local h = round(card.AbsoluteSize.Y / Library._uiScale) - Tokens.Shadow.card.Offset
		cardShadow.Size = UDim2.new(1, 0, 0, math.max(h, 0))
	end
	card:GetPropertyChangedSignal("AbsoluteSize"):Connect(syncCardShadow)
	task.defer(syncCardShadow)
	Surface(card, { Name = "Bg", Color = C.Surface2, Radius = R.Card, Highlight = true, Position = UDim2.fromOffset(1, 1), Size = UDim2.new(1, -2, 1, -2) })
	local body = create("Frame", { Name = "Body", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = card },
		{ vlist(0), pad(1, 1, 1, S.XS + 1) })

	local header = create("TextButton", { Name = "Header", BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
		Size = UDim2.new(1, 0, 0, Z.SectionHeader), LayoutOrder = 0, Parent = body })
	local title = Text(header, "Title", { Text = name or "Section", Position = UDim2.fromOffset(S.L, 0), Size = UDim2.new(1, -(2 * S.L + Z.Icon), 1, 0),
		TextTruncate = Enum.TextTruncate.AtEnd })
	local chev = Icon("chevron-down", Z.IconSm, C.TextMute, header)
	chev.AnchorPoint = Vector2.new(1, 0.5)
	chev.Position = UDim2.new(1, -S.L, 0.5, 0)
	chev.Visible = opts.Collapsible ~= false

	-- rows live in a clipping group so the section can fold away
	local clip = create("CanvasGroup", { Name = "Rows", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 1, Parent = body })
	local hl = Highlight(clip, { Color = C.Surface3 })
	local list = create("Frame", { Name = "List", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
		ZIndex = 2, Parent = clip })
	local layout = vlist(0)
	layout.Parent = list

	local sec = setmetatable({
		Wrapper = wrapper, Card = card, Body = body, Clip = clip, List = list, Layout = layout, Highlight = hl, Chevron = chev,
		Title = title, Name = name or "Section", Rows = {}, Tab = self, Window = self.Window, _order = 0, Collapsed = false,
	}, Section)
	table.insert(self.Sections, sec)

	if opts.Collapsible ~= false then
		header.MouseEnter:Connect(function() tintIcon(chev, C.TextDim, M.Hover); tween(title, M.Hover, { TextColor3 = C.White }) end)
		header.MouseLeave:Connect(function() tintIcon(chev, C.TextMute, M.Hover); tween(title, M.Hover, { TextColor3 = C.Text }) end)
		header.MouseButton1Click:Connect(function() sfx("click", 0.95); sec:SetCollapsed(not sec.Collapsed) end)
	end
	if opts.Collapsed then task.defer(function() sec:SetCollapsed(true, true) end) end
	return sec
end

function Section:SetCollapsed(collapsed, instant)
	collapsed = collapsed and true or false
	if self.Collapsed == collapsed then return end
	self.Collapsed = collapsed
	self.Highlight:Hide()
	local clip = self.Clip
	local full = self.Layout.AbsoluteContentSize.Y / Library._uiScale
	local t = instant and 0 or M.Accordion
	local token = {}
	self._foldToken = token
	tween(self.Chevron, t, { Rotation = collapsed and -90 or 0 }, Tokens.Ease.Accordion)
	if collapsed then
		clip.AutomaticSize = Enum.AutomaticSize.None
		clip.Size = UDim2.new(1, 0, 0, full)
		tween(clip, t, { Size = UDim2.new(1, 0, 0, 0), GroupTransparency = 1 }, Tokens.Ease.Accordion)
	else
		clip.AutomaticSize = Enum.AutomaticSize.None
		tween(clip, t, { Size = UDim2.new(1, 0, 0, full), GroupTransparency = 0 }, Tokens.Ease.Accordion)
		task.delay(t, function()
			if self._foldToken == token and not self.Collapsed then
				clip.Size = UDim2.new(1, 0, 0, 0)
				clip.AutomaticSize = Enum.AutomaticSize.Y
			end
		end)
	end
end

----------------------------------------------------------------------
-- SPLASH (logo pop · shimmering title · counting percent)
----------------------------------------------------------------------
local function splash(titleText)
	local root = getRoot()
	local cg = create("CanvasGroup", {
		Name = "Splash", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(Z.Splash.X, Z.Splash.Y),
		BackgroundTransparency = 1, GroupTransparency = 1, ZIndex = 700, Parent = root,
	})
	local scale = create("UIScale", { Scale = M.OpenScale, Parent = cg })
	local logo = LogoMark(cg, Z.SplashLogo)
	logo.AnchorPoint = Vector2.new(0.5, 0)
	logo.Position = UDim2.fromScale(0.5, 0)
	local title = Text(cg, "Title", { Text = titleText, TextXAlignment = Enum.TextXAlignment.Center, Position = UDim2.fromOffset(0, Z.SplashLogo + S.L),
		Size = UDim2.new(1, 0, 0, 20) })
	shimmer(title, true)
	local barY = Z.SplashLogo + S.L + 20 + S.L
	local trackF = create("Frame", { AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, barY), Size = UDim2.fromOffset(Z.SplashBar, Z.Hairline),
		BackgroundColor3 = C.Surface4, BorderSizePixel = 0, Parent = cg }, { corner(R.Pill) })
	local fill = create("Frame", { Size = UDim2.fromScale(0, 1), BorderSizePixel = 0, Parent = trackF }, { corner(R.Pill) })
	accentProp(fill, "BackgroundColor3")
	local pct = SlidingNumber(cg, { Style = "MonoSm", Suffix = "%", AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, barY + S.S) })

	local q = M.Splash / 4
	tween(cg, q, { GroupTransparency = 0 }, Tokens.Ease.Enter)
	tween(scale, q, { Scale = 1 }, Tokens.Ease.Enter)
	popScale(logo, 0.6)
	tween(fill, q * 2.5, { Size = UDim2.fromScale(1, 1) }, Tokens.Ease.Enter)
	pct:CountTo(100)
	task.wait(q * 3.5)
	tween(cg, q, { GroupTransparency = 1 }, Tokens.Ease.Exit, Enum.EasingDirection.In)
	tween(scale, q, { Scale = 1.04 }, Tokens.Ease.Exit, Enum.EasingDirection.In)
	task.wait(q)
	cg:Destroy()
end

----------------------------------------------------------------------
-- WINDOW
----------------------------------------------------------------------
local Window = {}
Window.__index = Window

function Library:CreateWindow(cfg)
	cfg = cfg or {}
	local root = getRoot()
	local W, H = cfg.Width or Z.Window.X, cfg.Height or Z.Window.Y
	local TB, SB, P = Z.TitleBar, Z.Sidebar, Z.WindowPad
	local titleText = cfg.Title or "Nexus"

	local win = setmetatable({
		Tabs = {}, Active = nil, ToggleKey = cfg.ToggleKey or Enum.KeyCode.RightShift,
		Visible = false, Minimized = false, ScaleValue = 1, Query = "", _booting = true,
	}, Window)
	Library.Window = win

	----------------------------------------------------------------
	-- frame stack: holder (CanvasGroup, fades) > body > shadow · glow host · main
	----------------------------------------------------------------
	local holder = create("CanvasGroup", {
		Name = "Window", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(W + 2 * P, H + 2 * P), BackgroundTransparency = 1, GroupTransparency = 1, Visible = false, ZIndex = 10, Parent = root,
	})
	local uiScale = create("UIScale", { Parent = holder })
	local body = create("Frame", { Name = "Body", BackgroundTransparency = 1, Position = UDim2.fromOffset(P, P), Size = UDim2.fromOffset(W, H), Parent = holder })
	Shadow(body, "window", { Radius = R.Window })
	local glowHost = create("Frame", { Name = "GlowHost", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Parent = body })
	local main = Surface(body, { Name = "Main", Color = C.Surface1, Radius = R.Window, Highlight = true, HighlightZ = 50, Clip = true })
	main.Active = true
	local mainBorder = main:FindFirstChild("Border")
	win.Holder, win.Body, win.Main = holder, body, main

	local animating = false
	local function fit()
		local vp = viewport()
		local f = math.min(vp.X / (W + 2 * S.XXXL), vp.Y / (H + 2 * S.XXXL))
		local steps = Tokens.UIScaleSteps
		local chosen = steps[#steps]
		for _, st in ipairs(steps) do if st <= f then chosen = st break end end
		if type(Library.Settings.Scale) == "number" then chosen = Library.Settings.Scale end
		win.ScaleValue = chosen
		Library._uiScale = chosen
		if Layers.OverlayScale then Layers.OverlayScale.Scale = chosen end
		if not animating then uiScale.Scale = chosen end
	end
	fit()
	win._fit = fit
	if workspace.CurrentCamera then
		track(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fit))
	end

	-- ambient layers
	local grain = create("ImageLabel", {
		Name = "Grain", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ScaleType = Enum.ScaleType.Tile,
		TileSize = UDim2.fromOffset(Tokens.NoiseSize, Tokens.NoiseSize), ImageTransparency = A.Noise, Visible = false, Parent = main,
	})
	local aurora = create("Frame", { Name = "Aurora", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Visible = false, Parent = main })
	local fxBack = create("Frame", { Name = "FX", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Parent = main })

	----------------------------------------------------------------
	-- TITLE BAR
	----------------------------------------------------------------
	local titleBar = create("Frame", { Name = "TitleBar", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, TB), Parent = main })
	create("Frame", { AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), Size = UDim2.new(1, 0, 0, Z.Divider),
		BackgroundColor3 = C.White, BackgroundTransparency = A.Border, BorderSizePixel = 0, Parent = titleBar })
	local brand = create("Frame", { BackgroundTransparency = 1, Position = UDim2.fromOffset(S.L, 0), Size = UDim2.new(0, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.X, Parent = titleBar }, { hlist(S.S + 2) })
	local logo = LogoMark(brand, Z.Logo)
	logo.LayoutOrder = 1
	local titleLbl = Text(brand, "Title", { Text = titleText, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 1, 0), LayoutOrder = 2 })
	local version = create("Frame", { Size = UDim2.fromOffset(0, Z.Pill), AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = C.Surface3,
		BorderSizePixel = 0, LayoutOrder = 3, Parent = brand }, { corner(R.Pill) })
	local versionLbl = Text(version, "MonoSm", { Text = cfg.Version or "v3.3", AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 1, 0) })
	pad(S.S, 0, S.S, 0).Parent = versionLbl
	local cineSlot = create("Frame", { BackgroundTransparency = 1, Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, LayoutOrder = 4, Parent = brand },
		{ hlist(S.S) })
	local logoHit = create("TextButton", { BackgroundTransparency = 1, Text = "", Size = UDim2.fromScale(1, 1), Parent = logo })
	logoHit.MouseEnter:Connect(function() popScale(logo, 0.85) end)

	local search
	if cfg.Search ~= false then
		search = Field(titleBar, { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(Z.Search.X, Z.Search.Y), Icon = "search", Placeholder = "Search settings", RightReserve = 48 })
		local hint = create("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -S.S + 2, 0.5, 0), Size = UDim2.fromOffset(0, Z.Pill),
			AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = C.Surface3, BorderSizePixel = 0, Parent = search.Well }, { corner(R.Tiny) })
		local hl = Text(hint, "MonoSm", { Text = "Ctrl K", AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 1, 0) })
		pad(S.XS + 2, 0, S.XS + 2, 0).Parent = hl
		search.Input.Focused:Connect(function() tween(hint, M.State, { BackgroundTransparency = 1 }); tween(hl, M.State, { TextTransparency = 1 }) end)
		search.Input.FocusLost:Connect(function() tween(hint, M.State, { BackgroundTransparency = 0 }); tween(hl, M.State, { TextTransparency = 0 }) end)
		search.Input:GetPropertyChangedSignal("Text"):Connect(function() win:Filter(search.Input.Text) end)
	end

	local controls = create("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -S.M, 0.5, 0), Size = UDim2.fromOffset(0, Z.IconButton),
		AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, Parent = titleBar }, { hlist(S.XS) })
	local minBtn, minIc = iconButton(controls, "minus", Z.IconButton, { LayoutOrder = 1 })
	local closeBtn, closeIc = iconButton(controls, "x", Z.IconButton, { LayoutOrder = 2, Hover = C.Danger, HoverAlpha = 0.15, HoverColor = C.White })
	magnetic(minIc, minBtn, { Range = 40, Strength = 0.35, Active = windowActive })
	magnetic(closeIc, closeBtn, { Range = 40, Strength = 0.35, Active = windowActive })
	closeBtn.MouseEnter:Connect(function() seqTween(closeIc, "Rotation", { 90 }, M.State) end)
	closeBtn.MouseLeave:Connect(function() seqTween(closeIc, "Rotation", { 0 }, M.State) end)

	----------------------------------------------------------------
	-- SIDEBAR (hover highlight + springy active pill that stretches in motion)
	----------------------------------------------------------------
	local side = create("Frame", { Name = "Sidebar", BackgroundTransparency = 1, Position = UDim2.fromOffset(0, TB), Size = UDim2.new(0, SB, 1, -TB), Parent = main })
	create("Frame", { AnchorPoint = Vector2.new(1, 0), Position = UDim2.fromScale(1, 0), Size = UDim2.new(0, Z.Divider, 1, 0),
		BackgroundColor3 = C.White, BackgroundTransparency = A.Border, BorderSizePixel = 0, Parent = side })
	Text(side, "Label", { Text = string.upper(cfg.SidebarLabel or "Workspace"), Position = UDim2.fromOffset(S.XL, S.L), Size = UDim2.new(1, -2 * S.XL, 0, 14) })
	local TAB_TOP = S.XXXL + S.S
	local TAB_STEP = Z.TabRow + Z.TabGap

	local hoverHl = Highlight(side, { Color = C.Surface2, Radius = R.Control, Inset = Vector2.new(S.S, 0) })
	local indicator = create("Frame", { Name = "Indicator", Position = UDim2.fromOffset(S.S, TAB_TOP), Size = UDim2.new(1, -2 * S.S, 0, Z.TabRow),
		BackgroundColor3 = C.Surface3, BorderSizePixel = 0, Visible = false, Parent = side }, { corner(R.Control) })
	stroke(C.White, A.Border).Parent = indicator
	local barHost = create("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.fromOffset(2, Z.Icon),
		BackgroundTransparency = 1, Parent = indicator })
	Glow(barHost, { Radius = R.Pill })
	local bar = create("Frame", { Size = UDim2.fromScale(1, 1), BorderSizePixel = 0, Parent = barHost }, { corner(R.Pill) })
	accentProp(bar, "BackgroundColor3")
	local indSpring
	indSpring = spring(TAB_TOP, Tokens.Spring.Indicator, function(y)
		local stretch = math.min(math.abs(indSpring and indSpring.v or 0) * 0.012, 10)
		indicator.Position = UDim2.fromOffset(S.S, round(y - stretch / 2))
		indicator.Size = UDim2.new(1, -2 * S.S, 0, round(Z.TabRow + stretch))
	end)

	local tabList = create("Frame", { Position = UDim2.fromOffset(S.S, TAB_TOP), Size = UDim2.new(1, -2 * S.S, 1, -(TAB_TOP + Z.UserCard)),
		BackgroundTransparency = 1, ClipsDescendants = true, ZIndex = 2, Parent = side }, { vlist(Z.TabGap) })

	-- built-in "System" tabs live in their own group pinned above the user card
	local SYS_LABEL = S.XXL
	local sysList = create("Frame", { Name = "System", AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, S.S, 1, -(Z.UserCard + S.S)),
		Size = UDim2.new(1, -2 * S.S, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Visible = false, ZIndex = 2, Parent = side },
		{ vlist(Z.TabGap) })
	local sysLabel = Text(sysList, "Label", { Text = "SYSTEM", Size = UDim2.new(1, 0, 0, SYS_LABEL), LayoutOrder = 0,
		TextYAlignment = Enum.TextYAlignment.Center })
	pad(S.M, 0, 0, 0).Parent = sysLabel
	local sysCount, userCount = 0, 0
	local function layoutLists()
		local sysH = (sysCount > 0) and (SYS_LABEL + sysCount * (Z.TabRow + Z.TabGap) + S.S) or 0
		sysList.Visible = sysCount > 0
		tabList.Size = UDim2.new(1, -2 * S.S, 1, -(TAB_TOP + Z.UserCard + sysH))
	end
	-- y of a tab button inside the sidebar, measured (works for both groups and any scale)
	local function tabY(t)
		local eff = side.AbsoluteSize.X / SB
		if eff <= 0 then eff = 1 end
		return round((t.Button.AbsolutePosition.Y - side.AbsolutePosition.Y) / eff)
	end
	side:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		if win.Active then task.defer(function() if win.Active then indSpring:Snap(tabY(win.Active)) end end) end
	end)

	local card = create("Frame", { AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), Size = UDim2.new(1, 0, 0, Z.UserCard),
		BackgroundTransparency = 1, Parent = side })
	create("Frame", { Position = UDim2.fromOffset(S.L, 0), Size = UDim2.new(1, -2 * S.L, 0, Z.Divider), BackgroundColor3 = C.White,
		BackgroundTransparency = A.Border, BorderSizePixel = 0, Parent = card })
	local avatarHost = create("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, S.L, 0.5, 0), Size = UDim2.fromOffset(Z.Avatar, Z.Avatar),
		BackgroundTransparency = 1, Parent = card })
	local avatar = create("ImageLabel", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = C.Surface3, BorderSizePixel = 0, Parent = avatarHost }, { corner(R.Pill) })
	stroke(C.White, A.Border).Parent = avatar
	local presence = create("Frame", { AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, 1, 1, 1), Size = UDim2.fromOffset(S.S + 1, S.S + 1),
		BackgroundColor3 = C.Success, BorderSizePixel = 0, ZIndex = 2, Parent = avatarHost }, { corner(R.Pill), stroke(C.Surface1, 0, 2) })
	local presencePulse = create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = C.Success, BackgroundTransparency = 0.4, BorderSizePixel = 0, ZIndex = 1, Parent = presence }, { corner(R.Pill) })
	TweenService:Create(presencePulse, TweenInfo.new(1.6, Tokens.Ease.Enter, Enum.EasingDirection.Out, -1), { Size = UDim2.fromScale(2.4, 2.4), BackgroundTransparency = 1 }):Play()
	local textX = S.L + Z.Avatar + S.M
	Text(card, "Body", { Text = LocalPlayer and LocalPlayer.DisplayName or "Guest", TextTruncate = Enum.TextTruncate.AtEnd,
		Position = UDim2.new(0, textX, 0.5, -15), Size = UDim2.new(1, -(textX + S.L), 0, 16) })
	Text(card, "MonoSm", { Text = "@" .. (LocalPlayer and LocalPlayer.Name or "guest"), TextTruncate = Enum.TextTruncate.AtEnd,
		Position = UDim2.new(0, textX, 0.5, 2), Size = UDim2.new(1, -(textX + S.L), 0, 14) })
	if LocalPlayer then
		task.spawn(function()
			local ok, img = pcall(function()
				return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
			end)
			if ok and avatar.Parent then avatar.Image = img end
		end)
	end

	----------------------------------------------------------------
	-- CONTENT
	----------------------------------------------------------------
	local content = create("Frame", { Name = "Content", BackgroundTransparency = 1, Position = UDim2.fromOffset(SB, TB),
		Size = UDim2.new(1, -SB, 1, -TB), ClipsDescendants = true, Parent = main })
	local progressBar = create("Frame", { Name = "ScrollProgress", Size = UDim2.new(0, 0, 0, Z.ScrollBar), BorderSizePixel = 0, ZIndex = 25,
		BackgroundTransparency = 1, Parent = content }, { accentGradient(0) })
	progressBar.BackgroundColor3 = C.White
	local fxTop = create("Frame", { Name = "FXTop", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 30, Parent = main })
	win.FXTop = fxTop

	----------------------------------------------------------------
	-- WATERMARK + REOPEN BUTTON
	----------------------------------------------------------------
	local wm = create("Frame", { Name = "Watermark", BackgroundTransparency = 1, Position = UDim2.fromOffset(S.L, S.L), Size = UDim2.fromOffset(0, Z.Watermark),
		AutomaticSize = Enum.AutomaticSize.X, Visible = Library.Settings.Watermark, ZIndex = 50, Parent = root })
	local wmShadow = Shadow(wm, "popover", { Radius = R.Pill })
	wmShadow.Size = UDim2.new(0, 0, 1, 0)
	local wmPill = Surface(wm, { Color = C.Surface2, Radius = R.Pill, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, Z.Watermark), StrokeAlpha = A.BorderStrong })
	wmPill:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() wmShadow.Size = UDim2.new(0, wmPill.AbsoluteSize.X, 1, 0) end)
	local wmRow = create("Frame", { BackgroundTransparency = 1, Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, Parent = wmPill },
		{ hlist(S.S), pad(S.S, 0, S.M, 0) })
	LogoMark(wmRow, Z.Icon).LayoutOrder = 1
	Text(wmRow, "Strong", { Text = titleText, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 1, 0), LayoutOrder = 2 })
	local function wmDivider(order)
		create("Frame", { Size = UDim2.fromOffset(Z.Divider, S.M), BackgroundColor3 = C.White, BackgroundTransparency = A.BorderStrong,
			BorderSizePixel = 0, LayoutOrder = order, Parent = wmRow })
	end
	wmDivider(3)
	local wmFps = SlidingNumber(wmRow, { Style = "Mono", Suffix = " fps", LayoutOrder = 4 })
	wmDivider(5)
	local wmPing = SlidingNumber(wmRow, { Style = "Mono", Suffix = " ms", LayoutOrder = 6 })
	wmDivider(7)
	local wmClock = Text(wmRow, "Mono", { AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 1, 0), LayoutOrder = 8 })
	Library._watermark = wm
	task.spawn(function()
		while Library._alive and wm.Parent do
			if wm.Visible then
				pcall(function() Library.Ping = round(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()) end)
				wmFps:Set(Library.FPS)
				wmPing:Set(Library.Ping or 0)
				wmClock.Text = os.date("%H:%M")
			end
			task.wait(1)
		end
	end)

	local mobile = create("Frame", { Name = "Reopen", BackgroundTransparency = 1, AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, S.L, 0.5, 0),
		Size = UDim2.fromOffset(Z.Mobile, Z.Mobile), Visible = false, ZIndex = 50, Parent = root })
	local mobileMover = create("Frame", { BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1, 1), Parent = mobile })
	Shadow(mobileMover, "popover", { Radius = R.Pill })
	local mobileBtn = create("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = C.Surface2, AutoButtonColor = false, Text = "",
		BorderSizePixel = 0, Parent = mobileMover }, { corner(R.Pill) })
	stroke(C.White, A.BorderStrong).Parent = mobileBtn
	local mLogo = LogoMark(mobileBtn, Z.Logo - 2)
	mLogo.AnchorPoint = Vector2.new(0.5, 0.5)
	mLogo.Position = UDim2.fromScale(0.5, 0.5)
	magnetic(mobileMover, mobile, { Range = 90, Strength = 0.4, Active = function() return mobile.Visible and not win._mobileDrag end })
	tapSpring(create("UIScale", { Parent = mobileMover }), mobileBtn)

	-- modes: "Auto" (only while the window is hidden) · "Always" · "Never"
	local function updateMobile()
		local mode = Library.Settings.ToggleButton
		local show = not win._booting and ((mode == "Always") or (mode ~= "Never" and not win.Visible))
		if show and not mobile.Visible then
			mobile.Visible = true
			popScale(mobileMover, 0.5)
		elseif not show then
			mobile.Visible = false
		end
	end
	win._updateMobile = updateMobile

	-- drag the button anywhere; a short tap still toggles the window
	local mStart, mStartPos, mMoved = nil, nil, false
	mobileBtn.InputBegan:Connect(function(input)
		if isPress(input) then mStart, mStartPos, mMoved = Vector2.new(input.Position.X, input.Position.Y), mobile.Position, false end
	end)
	track(UserInputService.InputChanged:Connect(function(input)
		if mStart and isMove(input) then
			local d = Vector2.new(input.Position.X, input.Position.Y) - mStart
			if not mMoved and d.Magnitude > 6 then mMoved = true; win._mobileDrag = true end
			if mMoved then
				mobile.Position = UDim2.new(mStartPos.X.Scale, mStartPos.X.Offset + d.X, mStartPos.Y.Scale, mStartPos.Y.Offset + d.Y)
			end
		end
	end))
	track(UserInputService.InputEnded:Connect(function(input)
		if mStart and isPress(input) then
			mStart = nil
			task.defer(function() win._mobileDrag = false end)
		end
	end))

	----------------------------------------------------------------
	-- DRAG (spring)
	----------------------------------------------------------------
	local dragX, dragY
	local function applyPos() holder.Position = UDim2.new(0.5, round(dragX.x), 0.5, round(dragY.x)) end
	dragX = spring(0, Tokens.Spring.Drag, applyPos)
	dragY = spring(0, Tokens.Spring.Drag, applyPos)
	local dragging, dragStart, startX, startY = false, nil, 0, 0
	titleBar.InputBegan:Connect(function(input)
		if not isPress(input) then return end
		local pos = Vector2.new(input.Position.X, input.Position.Y)
		if pointIn(controls, pos) or (search and pointIn(search.Well, pos)) then return end
		dragging, dragStart, startX, startY = true, pos, dragX.target, dragY.target
		closePopover()
	end)
	track(UserInputService.InputChanged:Connect(function(input)
		if dragging and isMove(input) then
			dragX:Set(startX + input.Position.X - dragStart.X)
			dragY:Set(startY + input.Position.Y - dragStart.Y)
		end
	end))
	track(UserInputService.InputEnded:Connect(function(input) if isPress(input) then dragging = false end end))

	----------------------------------------------------------------
	-- VISIBILITY
	----------------------------------------------------------------
	local animToken
	local function currentH() return win.Minimized and TB or H end

	function win:SetVisible(v)
		self.Visible = v and true or false
		closePopover()
		local token = {}
		animToken = token
		local base = self.ScaleValue
		animating = true
		if self.Visible then
			updateMobile()
			holder.Visible = true
			holder.GroupTransparency = 1
			uiScale.Scale = base * M.OpenScale
			body.Position = UDim2.fromOffset(P, P + M.Drift)
			tween(holder, M.Enter, { GroupTransparency = 0 }, Tokens.Ease.Enter)
			tween(uiScale, M.Enter, { Scale = base }, Tokens.Ease.Enter)
			tween(body, M.Enter, { Position = UDim2.fromOffset(P, P) }, Tokens.Ease.Enter)
			task.delay(M.Enter, function() if animToken == token then animating = false; uiScale.Scale = self.ScaleValue end end)
		else
			tween(holder, M.Exit, { GroupTransparency = 1 }, Tokens.Ease.Exit, Enum.EasingDirection.In)
			tween(uiScale, M.Exit, { Scale = base * M.OpenScale }, Tokens.Ease.Exit, Enum.EasingDirection.In)
			tween(body, M.Exit, { Position = UDim2.fromOffset(P, P + M.Drift) }, Tokens.Ease.Exit, Enum.EasingDirection.In)
			task.delay(M.Exit, function()
				if animToken ~= token then return end
				animating = false
				holder.Visible = false
				uiScale.Scale = self.ScaleValue
				updateMobile()
			end)
		end
		Library:SetBlur(Library.Settings.Blur)
	end
	function win:Toggle() if not self._booting then sfx("click", 0.8); self:SetVisible(not self.Visible) end end
	function win:Minimize()
		self.Minimized = not self.Minimized
		closePopover()
		local h = currentH()
		dragY:Set(dragY.target + (self.Minimized and -1 or 1) * (H - TB) / 2)
		tween(holder, M.Enter, { Size = UDim2.fromOffset(W + 2 * P, h + 2 * P) }, Tokens.Ease.Enter)
		tween(body, M.Enter, { Size = UDim2.fromOffset(W, h) }, Tokens.Ease.Enter)
		seqTween(minIc, "Rotation", { self.Minimized and 180 or 0 }, M.State)
	end
	function win:Destroy()
		closePopover()
		holder:Destroy(); wm:Destroy(); mobile:Destroy()
	end

	----------------------------------------------------------------
	-- TABS (directional page transitions · rolling page titles)
	----------------------------------------------------------------
	local function styleTab(t, on, animate)
		local d = animate and M.State or 0
		tween(t.Label, d, { TextColor3 = on and C.Text or C.TextDim })
		tintIcon(t.Icon, on and C.Accent or C.TextMute, d)
	end
	local function indexOf(tab) return (tab.System and 1000 or 0) + (tab.Order or 0) end

	local pageToken
	function win:SelectTab(tab, force)
		if self.Active == tab and not force then return end
		closePopover()
		local prev = self.Active
		local newIndex = indexOf(tab)
		local dir = (prev and prev ~= tab and indexOf(prev) > newIndex) and -1 or 1
		for _, t in ipairs(self.Tabs) do
			local on = (t == tab)
			styleTab(t, on, true)
			if on then
				indicator.Visible = true
				local y = tabY(t)
				if prev == nil or force then indSpring:Snap(y) else indSpring:Set(y) end
			end
		end
		if self.Active ~= tab then animateIcon(tab.Icon); sfx("click", 1.05) end
		self.Active = tab
		self:Filter(self.Query)

		local token = {}
		pageToken = token
		local delayIn = 0
		if prev and prev ~= tab then
			local old = prev.Page
			delayIn = M.PageOut
			tween(old, M.PageOut, { GroupTransparency = 1, Position = UDim2.fromOffset(0, -dir * M.PageSlide) }, Tokens.Ease.Exit, Enum.EasingDirection.In)
			task.delay(M.PageOut, function() if self.Active ~= prev then old.Visible = false end end)
		end
		local page = tab.Page
		page.GroupTransparency = 1
		page.Position = UDim2.fromOffset(0, dir * M.PageSlide)
		for _, sec in ipairs(tab.Sections) do sec.Card.GroupTransparency = 1 end
		tab.Scroll.CanvasPosition = Vector2.zero
		task.delay(delayIn, function()
			if pageToken ~= token then return end
			page.Visible = true
			tween(page, M.PageIn, { GroupTransparency = 0, Position = UDim2.fromOffset(0, 0) }, Tokens.Ease.Enter)
			tab.TitleRoll:Play()
			for i, sec in ipairs(tab.Sections) do
				task.delay(math.min((i - 1) * M.Stagger, M.StaggerCap), function()
					if pageToken == token then tween(sec.Card, M.PageIn, { GroupTransparency = 0 }, Tokens.Ease.Enter) end
				end)
				if Library.FX.Scramble then scramble(sec.Title, sec.Name, 0.4) end
			end
		end)
	end

	function win:Filter(q)
		self.Query = q or ""
		local tab = self.Active
		if not tab then return end
		local query = string.lower((self.Query:gsub("^%s+", ""):gsub("%s+$", "")))
		local total = 0
		for _, sec in ipairs(tab.Sections) do
			sec.Highlight:Hide()
			local secMatch = query ~= "" and string.find(string.lower(sec.Name), query, 1, true) ~= nil
			local count = 0
			for _, r in ipairs(sec.Rows) do
				local vis = query == "" or secMatch or (r.Search ~= "" and string.find(r.Search, query, 1, true) ~= nil)
				r.Frame.Visible = vis
				if vis then count = count + 1 end
			end
			sec.Wrapper.Visible = query == "" or count > 0
			if query ~= "" and count > 0 and sec.Collapsed then sec:SetCollapsed(false) end
			total = total + count
			sec:_relayout()
		end
		local empty = query ~= "" and total == 0
		tab.Empty.Visible = empty
		tab.Empty.Text = empty and ('No settings match "' .. self.Query .. '"') or ""
		tab.Cols.Visible = not empty
	end

	function win:AddTab(name, icon, description, opts)
		opts = opts or {}
		local tab = setmetatable({ Window = win, _count = 0, Sections = {}, Rows = {}, Name = name, System = opts.System == true }, Tab)
		if tab.System then sysCount = sysCount + 1; tab.Order = sysCount else userCount = userCount + 1; tab.Order = userCount end
		local btn = create("TextButton", {
			Size = UDim2.new(1, 0, 0, Z.TabRow), BackgroundTransparency = 1, AutoButtonColor = false, Text = "",
			BorderSizePixel = 0, LayoutOrder = tab.Order, ZIndex = 2, Parent = tab.System and sysList or tabList,
		})
		layoutLists()
		local ic = Icon(icon or "circle-dot", Z.Icon, C.TextMute, btn)
		ic.AnchorPoint = Vector2.new(0, 0.5)
		ic.Position = UDim2.new(0, S.M, 0.5, 0)
		local lb = Text(btn, "Body", { Text = name, TextColor3 = C.TextDim, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 2,
			Position = UDim2.fromOffset(S.M + Z.Icon + S.M, 0), Size = UDim2.new(1, -(S.M * 3 + Z.Icon), 1, 0) })
		hoverHl:Attach(btn)
		btn.MouseEnter:Connect(function()
			animateIcon(ic)
			if win.Active ~= tab then tween(lb, M.Hover, { TextColor3 = C.Text }) end
		end)
		btn.MouseLeave:Connect(function() if win.Active ~= tab then tween(lb, M.Hover, { TextColor3 = C.TextDim }) end end)

		local page = create("CanvasGroup", { Name = name, BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), GroupTransparency = 1,
			Visible = false, Parent = content })
		local _, sf = Scroller(page, { FadeColor = C.Surface1, OnProgress = function(frac, scrollable)
			if win.Active == tab then
				progressBar.Size = UDim2.new(frac, 0, 0, Z.ScrollBar)
				progressBar.BackgroundTransparency = (scrollable and frac > 0.002) and 0.2 or 1
			end
		end })
		vlist(S.XL).Parent = sf
		pad(S.XXL, S.XXL, S.XXL, S.XXL).Parent = sf
		local header = create("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 1, Parent = sf },
			{ vlist(S.XS) })
		tab.TitleRoll = RollingText(header, "Display", { Text = name, Height = 26, LayoutOrder = 1 })
		if description then
			Text(header, "Caption", { Text = description, TextWrapped = true, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 2 })
		end
		local empty = Text(sf, "Caption", { Text = "", TextColor3 = C.TextMute, TextXAlignment = Enum.TextXAlignment.Center,
			Size = UDim2.new(1, 0, 0, 80), Visible = false, LayoutOrder = 3 })
		local cols = create("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 2, Parent = sf })
		tab.Left = create("Frame", { BackgroundTransparency = 1, Size = UDim2.new(0.5, -S.S, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = cols }, { vlist(S.L) })
		tab.Right = create("Frame", { BackgroundTransparency = 1, Position = UDim2.new(0.5, S.S, 0, 0), Size = UDim2.new(0.5, -S.S, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y, Parent = cols }, { vlist(S.L) })

		tab.Page, tab.Scroll, tab.Cols, tab.Empty, tab.Button, tab.Label, tab.Icon = page, sf, cols, empty, btn, lb, ic
		table.insert(win.Tabs, tab)
		btn.MouseButton1Click:Connect(function() win:SelectTab(tab) end)
		-- the first user tab becomes the default page (system tabs never steal focus)
		if not tab.System and userCount == 1 then
			if win.Active and win.Active ~= tab then
				win.Active.Page.Visible = false
				styleTab(win.Active, false, false)
			end
			win.Active = tab
			page.Visible = true
			page.GroupTransparency = 0
			indicator.Visible = true
			styleTab(tab, true, false)
		end
		return tab
	end

	minBtn.MouseButton1Click:Connect(function() win:Minimize() end)
	closeBtn.MouseButton1Click:Connect(function() win:Toggle() end)
	mobileBtn.MouseButton1Click:Connect(function()
		if mMoved then mMoved = false return end
		win:Toggle()
	end)
	track(UserInputService.InputBegan:Connect(function(input, gp)
		if gp then return end
		if input.KeyCode == win.ToggleKey then
			win:Toggle()
		elseif input.KeyCode == Enum.KeyCode.K and search and win.Visible
			and (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)) then
			task.defer(function() search.Input:CaptureFocus() end)
		end
	end))

	----------------------------------------------------------------
	-- EFFECTS  (ambient on by default · cinematic off by default)
	----------------------------------------------------------------
	local effects = {}
	local function mouseIn()
		local mp = (absMouse() - main.AbsolutePosition) / win.ScaleValue
		return mp, mp.X >= 0 and mp.Y >= 0 and mp.X <= W and mp.Y <= H
	end
	-- a soft radial blob made of stacked circles
	local function blob(parent, diameter, key, alpha, layers)
		local b = create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(0, 0), BackgroundTransparency = 1, Parent = parent })
		for i = 1, layers do
			local d = round(diameter * (1 - (i - 1) / layers))
			accentProp(create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(d, d), BackgroundTransparency = alpha,
				BorderSizePixel = 0, Parent = b }, { corner(R.Pill) }), "BackgroundColor3", key)
		end
		return b
	end

	effects.Noise = {
		enable = function()
			local contentId = noiseContent()
			if contentId then
				pcall(function() grain.ImageContent = contentId end)
				grain.Visible = true
			end
		end,
		disable = function() grain.Visible = false end,
	}

	do -- ambient bubbles (animate-ui "Bubble Background"): drifting + orbiting blobs and a cursor follower
		local blobs = {
			{ b = blob(aurora, 460, "Accent", A.Aurora, 7), kind = "drift", cx = W * 0.82, cy = H * 0.05, ax = 90, ay = 0, period = 30 },
			{ b = blob(aurora, 380, "Accent2", A.Aurora, 6), kind = "drift", cx = W * 0.95, cy = H * 0.45, ax = 0, ay = 70, period = 40 },
			{ b = blob(aurora, 320, "Accent", A.Aurora, 6), kind = "orbit", cx = W * 0.15, cy = H * 0.95, r = 70, period = 60 },
			{ b = blob(aurora, 260, "Accent2", A.Aurora, 5), kind = "orbit", cx = W * 0.55, cy = H * 1.05, r = 50, period = -45 },
		}
		local follower = blob(aurora, 240, "Accent", 0.994, 5)
		follower.Visible = false
		local fx, fy
		local function placeFollower() follower.Position = UDim2.fromOffset(round(fx.x), round(fy.x)) end
		fx = spring(W / 2, Tokens.Spring.Follower, placeFollower)
		fy = spring(H / 2, Tokens.Spring.Follower, placeFollower)
		local fn
		effects.Aurora = {
			enable = function()
				aurora.Visible = true
				if fn then return end
				fn = stepper(function(_, now)
					if not holder.Visible or win.Minimized then return end
					for _, bl in ipairs(blobs) do
						local x, y
						if bl.kind == "drift" then
							local t = math.sin(now / bl.period * math.pi * 2)
							x, y = bl.cx + bl.ax * t, bl.cy + bl.ay * t
						else
							local a = now / bl.period * math.pi * 2
							x, y = bl.cx + math.cos(a) * bl.r, bl.cy + math.sin(a) * bl.r
						end
						x, y = round(x), round(y)
						if x ~= bl.lx or y ~= bl.ly then
							bl.lx, bl.ly = x, y
							bl.b.Position = UDim2.fromOffset(x, y)
						end
					end
					local mp, inside = mouseIn()
					follower.Visible = inside
					if inside and (math.abs(fx.target - mp.X) > 1 or math.abs(fy.target - mp.Y) > 1) then
						fx:Set(mp.X); fy:Set(mp.Y)
					end
				end)
			end,
			disable = function() aurora.Visible = false; if fn then unstep(fn); fn = nil end end,
		}
	end

	do -- star field with mouse parallax (animate-ui "Stars Background")
		local layer, px, py, fn
		effects.Stars = {
			enable = function()
				if layer then return end
				layer = create("Frame", { Name = "Stars", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Parent = fxBack })
				local function applyP() layer.Position = UDim2.fromOffset(round(px.x), round(py.x)) end
				px = spring(0, Tokens.Spring.Parallax, applyP)
				py = spring(0, Tokens.Spring.Parallax, applyP)
				for li, spec in ipairs({ { 60, 1, 60, 0.55 }, { 30, 2, 120, 0.65 }, { 14, 3, 180, 0.75 } }) do
					local count, size, speed, alpha = spec[1], spec[2], spec[3], spec[4]
					local strip = create("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, H * 2), Parent = layer })
					for i = 1, count do
						local x, y = math.random() * W, math.random() * H
						for copy = 0, 1 do
							create("Frame", { Position = UDim2.fromOffset(x, y + copy * H), Size = UDim2.fromOffset(size, size), BackgroundColor3 = C.White,
								BackgroundTransparency = alpha, BorderSizePixel = 0, Parent = strip }, { corner(R.Pill) })
						end
					end
					TweenService:Create(strip, TweenInfo.new(speed, Tokens.Ease.Linear, Enum.EasingDirection.In, -1), { Position = UDim2.fromOffset(0, -H) }):Play()
					strip.Name = "Layer" .. li
				end
				fn = stepper(function()
					if not holder.Visible then return end
					local mp, inside = mouseIn()
					local tx, ty = 0, 0
					if inside then tx, ty = -(mp.X - W / 2) * 0.05, -(mp.Y - H / 2) * 0.05 end
					if math.abs(px.target - tx) > 0.5 or math.abs(py.target - ty) > 0.5 then px:Set(tx); py:Set(ty) end
				end)
			end,
			disable = function()
				if fn then unstep(fn); fn = nil end
				if layer then layer:Destroy(); layer = nil end
			end,
		}
	end

	do -- cursor follower ring (animate-ui "Cursor")
		local host, fn
		effects.Cursor = {
			enable = function()
				if host then return end
				host = create("Frame", { Name = "Cursor", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 35, Parent = fxTop })
				local ring = create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(Z.CursorRing, Z.CursorRing), BackgroundTransparency = 1,
					ZIndex = 35, Parent = host }, { corner(R.Pill) })
				accentProp(stroke(C.Accent, 0.3, 1.5), "Color").Parent = ring
				local dot = create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(Z.CursorDot, Z.CursorDot), BorderSizePixel = 0,
					ZIndex = 36, Parent = host }, { corner(R.Pill) })
				accentProp(dot, "BackgroundColor3")
				local ringScale = create("UIScale", { Parent = ring })
				local rx, ry
				local function placeRing() ring.Position = UDim2.fromOffset(round(rx.x), round(ry.x)) end
				rx = spring(W / 2, Tokens.Spring.Follower, placeRing)
				ry = spring(H / 2, Tokens.Spring.Follower, placeRing)
				local down = false
				fn = stepper(function()
					if not holder.Visible then return end
					local mp, inside = mouseIn()
					host.Visible = inside
					if not inside then return end
					dot.Position = UDim2.fromOffset(round(mp.X), round(mp.Y))
					if math.abs(rx.target - mp.X) > 0.5 or math.abs(ry.target - mp.Y) > 0.5 then rx:Set(mp.X); ry:Set(mp.Y) end
					local pressed = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
					if pressed ~= down then down = pressed; tween(ringScale, M.Hover, { Scale = pressed and 0.7 or 1 }) end
				end)
			end,
			disable = function()
				if fn then unstep(fn); fn = nil end
				if host then host:Destroy(); host = nil end
			end,
		}
	end

	do -- particle network
		local layer, fn
		effects.Particles = {
			enable = function()
				if layer then return end
				layer = create("Frame", { Name = "Particles", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Parent = fxBack })
				local NODES, LINES, LINK = 26, 70, 110
				local nodes, pool, used = {}, {}, 0
				for i = 1, NODES do
					local n = { x = math.random() * W, y = math.random() * H, vx = (math.random() - 0.5) * 24, vy = (math.random() - 0.5) * 24 }
					n.f = create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(3, 3), BackgroundColor3 = C.Accent,
						BackgroundTransparency = 0.5, BorderSizePixel = 0, Parent = layer }, { corner(R.Pill) })
					nodes[i] = n
				end
				for i = 1, LINES do
					pool[i] = create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), BorderSizePixel = 0, Visible = false, Parent = layer }, { corner(R.Pill) })
				end
				fn = stepper(function(dt)
					if not holder.Visible or win.Minimized then return end
					dt = math.min(dt, 0.05)
					local mp, inside = mouseIn()
					for _, n in ipairs(nodes) do
						if inside then
							local dx, dy = n.x - mp.X, n.y - mp.Y
							local d2 = dx * dx + dy * dy
							if d2 < 8100 and d2 > 1 then
								local d = math.sqrt(d2)
								local f = (90 - d) / 90 * 180 * dt
								n.vx, n.vy = n.vx + dx / d * f, n.vy + dy / d * f
							end
						end
						local sp = math.sqrt(n.vx * n.vx + n.vy * n.vy)
						if sp > 50 then n.vx, n.vy = n.vx / sp * 50, n.vy / sp * 50 end
						n.x, n.y = n.x + n.vx * dt, n.y + n.vy * dt
						if n.x < 0 or n.x > W then n.vx = -n.vx; n.x = math.clamp(n.x, 0, W) end
						if n.y < 0 or n.y > H then n.vy = -n.vy; n.y = math.clamp(n.y, 0, H) end
						n.f.Position = UDim2.fromOffset(n.x, n.y)
						n.f.BackgroundColor3 = C.Accent
					end
					local count = 0
					for i = 1, NODES do
						local a = nodes[i]
						for j = i + 1, NODES do
							if count >= LINES then break end
							local b = nodes[j]
							local dx, dy = b.x - a.x, b.y - a.y
							local d2 = dx * dx + dy * dy
							if d2 < LINK * LINK then
								count = count + 1
								local l = pool[count]
								l.Visible = true
								l.Position = UDim2.fromOffset((a.x + b.x) / 2, (a.y + b.y) / 2)
								l.Size = UDim2.fromOffset(math.sqrt(d2), 1)
								l.Rotation = math.deg(math.atan2(dy, dx))
								l.BackgroundColor3 = C.Accent
								l.BackgroundTransparency = 0.8 + 0.2 * math.sqrt(d2) / LINK
							end
						end
					end
					for i = count + 1, used do pool[i].Visible = false end
					used = count
				end)
			end,
			disable = function()
				if fn then unstep(fn); fn = nil end
				if layer then layer:Destroy(); layer = nil end
			end,
		}
	end

	do -- holo grid
		local grid
		effects.Grid = {
			enable = function()
				if grid then return end
				local G = S.XXXL
				grid = create("Frame", { Name = "Grid", BackgroundTransparency = 1, Size = UDim2.new(1, G * 2, 1, G * 2), Parent = fxBack })
				for x = 0, W + G * 2, G do
					create("Frame", { Position = UDim2.fromOffset(x, 0), Size = UDim2.new(0, 1, 1, 0), BackgroundColor3 = C.White, BackgroundTransparency = 0.965, BorderSizePixel = 0, Parent = grid })
				end
				for y = 0, H + G * 2, G do
					create("Frame", { Position = UDim2.fromOffset(0, y), Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = C.White, BackgroundTransparency = 0.965, BorderSizePixel = 0, Parent = grid })
				end
				TweenService:Create(grid, TweenInfo.new(6, Tokens.Ease.Linear, Enum.EasingDirection.In, -1), { Position = UDim2.fromOffset(-G, -G) }):Play()
				win.Grid = grid
			end,
			disable = function() if grid then grid:Destroy(); grid = nil; win.Grid = nil end end,
		}
	end

	do -- scanline
		local scan
		effects.Scanline = {
			enable = function()
				if scan then return end
				scan = create("Frame", { Name = "Scanline", Size = UDim2.new(1, 0, 0, 80), Position = UDim2.new(0, 0, 0, -80), BackgroundColor3 = C.Accent,
					BackgroundTransparency = 0.95, BorderSizePixel = 0, Parent = fxTop }, { create("UIGradient", { Rotation = 90,
					Transparency = NumberSequence.new({ kp(0, 1), kp(0.9, 0.4), kp(1, 1) }) }) })
				accentProp(scan, "BackgroundColor3")
				TweenService:Create(scan, TweenInfo.new(5, Tokens.Ease.Linear, Enum.EasingDirection.In, -1, false, 1), { Position = UDim2.new(0, 0, 1, 0) }):Play()
				win.Scanline = scan
			end,
			disable = function() if scan then scan:Destroy(); scan = nil; win.Scanline = nil end end,
		}
	end

	do -- cursor spotlight
		local spot, fn
		effects.Spotlight = {
			enable = function()
				if spot then return end
				spot = blob(fxBack, 300, "Accent", 0.99, 5)
				spot.Visible = false
				local pos = Vector2.new(W / 2, H / 2)
				fn = stepper(function(dt)
					if not holder.Visible then return end
					local mp, inside = mouseIn()
					spot.Visible = inside
					if inside then
						pos = pos:Lerp(mp, math.min(1, dt * 10))
						spot.Position = UDim2.fromOffset(round(pos.X), round(pos.Y))
					end
				end)
			end,
			disable = function()
				if fn then unstep(fn); fn = nil end
				if spot then spot:Destroy(); spot = nil end
			end,
		}
	end

	do -- comet border light
		local frame
		effects.Comet = {
			enable = function()
				if frame then return end
				frame = create("Frame", { Name = "Comet", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 5, Parent = body }, { corner(R.Window) })
				local st = create("UIStroke", { Thickness = 1.5, Color = C.White, Parent = frame })
				local g = create("UIGradient", { Transparency = NumberSequence.new({ kp(0, 1), kp(0.45, 1), kp(0.5, 0.1), kp(0.55, 1), kp(1, 1) }), Parent = st })
				paint(function() if g.Parent then g.Color = seq({ 0, C.Accent }, { 1, C.Accent2 }) end end)
				spin(g, 110)
			end,
			disable = function() if frame then frame:Destroy(); frame = nil end end,
		}
	end

	do -- spinning gradient border
		local g
		effects.GradientBorder = {
			enable = function()
				if g then return end
				g = create("UIGradient", { Parent = mainBorder })
				paint(function() if g and g.Parent then g.Color = seq({ 0, C.Accent }, { 0.5, C.Accent2 }, { 1, C.Accent }) end end)
				mainBorder.Transparency = 0.4
				spin(g, 40)
			end,
			disable = function()
				if g then g:Destroy(); g = nil end
				mainBorder.Transparency = A.Border
			end,
		}
	end

	do -- pulsing outer glow
		local glowF, token
		effects.Glow = {
			enable = function()
				if glowF then return end
				glowF = Shadow(glowHost, "window", { Accent = true, Offset = 0, Opacity = 0.03, Radius = R.Window })
				local t = {}
				token = t
				task.spawn(function()
					local up = false
					while token == t and glowF and glowF.Parent do
						up = not up
						shadowLevel(glowF, up and 1 or 0.4, 1.6)
						task.wait(1.6)
					end
				end)
			end,
			disable = function() token = nil; if glowF then glowF:Destroy(); glowF = nil end end,
		}
	end

	do -- HUD corner brackets
		local host
		effects.Brackets = {
			enable = function()
				if host then return end
				host = create("Frame", { Name = "Brackets", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Parent = body })
				for _, c in ipairs({ { 0, 0 }, { 1, 0 }, { 0, 1 }, { 1, 1 } }) do
					local ax, ay = c[1], c[2]
					local b = create("Frame", { AnchorPoint = Vector2.new(ax, ay), Position = UDim2.new(ax, ax == 0 and -S.S or S.S, ay, ay == 0 and -S.S or S.S),
						Size = UDim2.fromOffset(S.L, S.L), BackgroundTransparency = 1, Parent = host })
					for _, sz in ipairs({ UDim2.fromOffset(S.L, 2), UDim2.fromOffset(2, S.L) }) do
						local segF = create("Frame", { AnchorPoint = Vector2.new(ax, ay), Position = UDim2.fromScale(ax, ay), Size = sz, BorderSizePixel = 0, Parent = b })
						accentProp(segF, "BackgroundColor3")
						loopTween(segF, 1.2, { BackgroundTransparency = 0.7 })
					end
				end
			end,
			disable = function() if host then host:Destroy(); host = nil end end,
		}
	end

	do -- audio visualizer (title bar)
		local viz, fn
		effects.Visualizer = {
			enable = function()
				if viz then return end
				viz = create("Frame", { BackgroundTransparency = 1, Size = UDim2.fromOffset(38, S.L), LayoutOrder = 1, Parent = cineSlot },
					{ hlist(2, Enum.VerticalAlignment.Bottom) })
				local bars = {}
				for i = 1, 8 do
					bars[i] = create("Frame", { Size = UDim2.fromOffset(3, 4), BorderSizePixel = 0, LayoutOrder = i, Parent = viz }, { corner(1) })
					accentProp(bars[i], "BackgroundColor3")
				end
				local acc = 0
				fn = stepper(function(dt)
					acc = acc + dt
					if acc < 0.12 or not holder.Visible then return end
					acc = 0
					for _, b in ipairs(bars) do tween(b, 0.1, { Size = UDim2.fromOffset(3, math.random(2, S.L)) }, Tokens.Ease.Exit) end
				end)
			end,
			disable = function()
				if fn then unstep(fn); fn = nil end
				if viz then viz:Destroy(); viz = nil end
			end,
		}
	end

	do -- typing status (title bar)
		local lbl, token
		local messages = cfg.Messages or { "All systems operational", "Connected", "Autosave enabled", "Up to date" }
		effects.Typing = {
			enable = function()
				if lbl then return end
				lbl = Text(cineSlot, "MonoSm", { AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.new(0, 0, 1, 0), LayoutOrder = 2 })
				local t = {}
				token = t
				task.spawn(function()
					local i = 0
					while token == t and lbl and lbl.Parent do
						i = i % #messages + 1
						local msg = messages[i]
						for n = 1, #msg do if token ~= t then return end lbl.Text = msg:sub(1, n) .. "_"; task.wait(0.03) end
						task.wait(2.2)
						for n = #msg, 0, -2 do if token ~= t then return end lbl.Text = msg:sub(1, n) .. "_"; task.wait(0.012) end
					end
				end)
			end,
			disable = function() token = nil; if lbl then lbl:Destroy(); lbl = nil end end,
		}
	end

	do -- glitch bursts (Window:Glitch works any time; this toggles the random loop)
		local token
		effects.Glitch = {
			enable = function()
				local t = {}
				token = t
				task.spawn(function()
					while token == t and Library._alive and holder.Parent do
						task.wait(3 + math.random() * 5)
						if token == t and win.Visible then win:Glitch() end
					end
				end)
			end,
			disable = function() token = nil end,
		}
	end

	function win:Glitch()
		if not holder.Visible then return end
		local s = self.ScaleValue
		local rel = (titleLbl.AbsolutePosition - titleBar.AbsolutePosition) / s
		local clones = {}
		for i, key in ipairs({ "Accent", "Accent2" }) do
			clones[i] = Text(titleBar, "Title", { Text = titleText, TextColor3 = C[key], TextTransparency = 1, AutomaticSize = Enum.AutomaticSize.X,
				Position = UDim2.fromOffset(round(rel.X), round(rel.Y)), Size = UDim2.new(0, 0, 0, titleLbl.AbsoluteSize.Y / s), ZIndex = 5 })
		end
		task.spawn(function()
			for _ = 1, 6 do
				for _, c in ipairs(clones) do
					c.TextTransparency = 0.35
					c.Position = UDim2.fromOffset(round(rel.X) + math.random(-3, 3), round(rel.Y) + math.random(-1, 1))
				end
				task.wait(0.035)
			end
			for _, c in ipairs(clones) do c:Destroy() end
		end)
		if Library.FX.Scramble then scramble(titleLbl, titleText, 0.3) end
		for _ = 1, math.random(2, 3) do
			local slice = create("Frame", {
				Position = UDim2.new(math.random() * 0.4, 0, math.random(), 0), Size = UDim2.new(0.3 + math.random() * 0.5, 0, 0, math.random(2, 6)),
				BackgroundColor3 = (math.random() < 0.5) and C.Accent or C.Accent2, BackgroundTransparency = 0.75, BorderSizePixel = 0, Parent = fxTop,
			})
			task.spawn(function()
				for _ = 1, 4 do
					slice.Position = slice.Position + UDim2.fromOffset(math.random(-24, 24), 0)
					slice.BackgroundTransparency = 0.7 + math.random() * 0.25
					task.wait(0.04)
				end
				slice:Destroy()
			end)
		end
	end

	function win:SetEffect(name, on)
		on = on and true or false
		Library.FX[name] = on
		local e = effects[name]
		if e then if on then e.enable() else e.disable() end end
	end

	for name, on in pairs(Library.FX) do
		if on and effects[name] then effects[name].enable() end
	end

	-- built-in Performance / Appearance / Settings tabs (always present unless BuiltInTabs = false)
	if cfg.BuiltInTabs ~= false and Library._buildSystemTabs then
		local ok, err = pcall(Library._buildSystemTabs, win, cfg)
		if not ok then warn("[Nexus] built-in tabs failed: " .. tostring(err)) end
	end

	----------------------------------------------------------------
	-- STARTUP
	----------------------------------------------------------------
	task.spawn(function()
		if cfg.Intro ~= false then splash(titleText) else task.wait() end
		win._booting = false
		win:SetVisible(true)
		popScale(logo, 0.6)
		local first = win.Active
		if not first then
			for _, t in ipairs(win.Tabs) do if not t.System then first = t break end end
			first = first or win.Tabs[1]
		end
		if first then win:SelectTab(first, true) end
		updateMobile()
		-- apply the auto-load profile once the user's own tabs exist
		-- auto-load belongs to the profile system, so it follows the same rule (demo on by default)
		local autoLoad = cfg.AutoLoad
		if autoLoad == nil then autoLoad = cfg.Profiles end
		if autoLoad == nil then autoLoad = not env.NEXUS_NO_DEMO end
		if autoLoad then
			local auto = Library:GetAutoload()
			if auto then
				local ok = Library:LoadConfig(auto)
				if ok then Library:Notify({ Title = "Profile loaded", Content = "Applied " .. auto .. ".json on start.", Type = "Success", Duration = 3 }) end
			end
		end
		if Library.FX.Scramble then scramble(titleLbl, titleText, 0.6) end
		fire(cfg.OnReady, win)
	end)

	return win
end

----------------------------------------------------------------------
-- BUILT-IN SYSTEM TABS  (Performance · Appearance · Settings)
--   Added to every window, demo or not. Opt out with CreateWindow{ BuiltInTabs = false }
--   or pick some: BuiltInTabs = { Performance = true, Appearance = true, Settings = false }
----------------------------------------------------------------------
local CINEMATIC_EFFECTS = {
	{ "Stars", "Star field" }, { "Cursor", "Cursor follower" }, { "Particles", "Particle network" }, { "Grid", "Holo grid" },
	{ "Scanline", "Scanline sweep" }, { "Spotlight", "Cursor spotlight" }, { "Glitch", "Glitch bursts" }, { "Comet", "Comet border" },
	{ "GradientBorder", "Gradient border" }, { "Glow", "Outer glow" }, { "Brackets", "Corner brackets" },
	{ "Visualizer", "Audio visualizer" }, { "Typing", "Typing status" }, { "Scramble", "Text scramble" },
}
local SCALE_OPTIONS = { Auto = "Auto", ["100%"] = 1, ["88%"] = 0.875, ["75%"] = 0.75, ["63%"] = 0.625 }

Library._buildSystemTabs = function(win, cfg)
	local want = cfg.BuiltInTabs
	local function enabled(name) return type(want) ~= "table" or want[name] ~= false end
	local refs = { cine = {} }

	-- performance mode: switch every effect off (and restore it afterwards)
	function refs.setPerformanceMode(on)
		if on then
			refs.saved = {}
			for name, v in pairs(Library.FX) do refs.saved[name] = v end
			if refs.aurora then refs.aurora:Set(false) else win:SetEffect("Aurora", false) end
			if refs.noise then refs.noise:Set(false) else win:SetEffect("Noise", false) end
			for i, e in ipairs(CINEMATIC_EFFECTS) do
				if refs.cine[i] then refs.cine[i]:Set(false) else win:SetEffect(e[1], false) end
			end
		elseif refs.saved then
			local saved = refs.saved
			refs.saved = nil
			if refs.aurora then refs.aurora:Set(saved.Aurora) else win:SetEffect("Aurora", saved.Aurora) end
			if refs.noise then refs.noise:Set(saved.Noise) else win:SetEffect("Noise", saved.Noise) end
			for i, e in ipairs(CINEMATIC_EFFECTS) do
				if refs.cine[i] then refs.cine[i]:Set(saved[e[1]] == true) else win:SetEffect(e[1], saved[e[1]] == true) end
			end
		end
	end

	------------------------------------------------ PERFORMANCE
	if enabled("Performance") then
		local tab = win:AddTab("Performance", "monitor", "Live client performance for this session.", { System = true })
		local liveOn = true

		local live = tab:AddSection("Live")
		local stats = live:AddStats({ { Name = "FPS" }, { Name = "Ping", Suffix = "ms" }, { Name = "Memory", Suffix = "MB", Thousands = true } })
		local fpsGraph = live:AddGraph({ Name = "Frame rate", Max = 144, Suffix = " fps", Tooltip = "Client frames per second" })
		local pingGraph = live:AddGraph({ Name = "Ping", Max = 300, Suffix = " ms", Tooltip = "Round trip to the server" })

		local session = tab:AddSection("Session", "Right")
		local sessionStats = session:AddStats({ { Name = "Players" }, { Name = "In game", Suffix = "s", Thousands = true } })
		local memBar = session:AddProgress({ Name = "Memory budget", Default = 0, Tooltip = "Client memory against a 2 GB budget" })

		local tuning = tab:AddSection("Tuning", "Right")
		if typeof(setfpscap) == "function" then
			local current = 60
			if typeof(getfpscap) == "function" then pcall(function() current = getfpscap() end) end
			current = tonumber(current) or 60
			if current <= 0 or current > 360 then current = 360 end
			tuning:AddSlider({ Name = "Frame rate cap", Min = 30, Max = 360, Default = math.clamp(current, 30, 360), Suffix = " fps",
				Flag = "nexus_fpscap", Callback = function(v) pcall(setfpscap, v) end })
		end
		tuning:AddToggle({ Name = "Performance mode", Description = "Turns off every visual effect", Flag = "nexus_perfmode",
			Callback = function(v) refs.setPerformanceMode(v) end })
		tuning:AddToggle({ Name = "Live sampling", Description = "Update these stats while this tab is open", Default = true,
			Callback = function(v) liveOn = v end })

		local StatsService = game:GetService("Stats")
		task.spawn(function()
			while Library._alive and win.Holder.Parent do
				if liveOn and win.Visible and win.Active == tab then
					local fps = Library.FPS
					local ping, mem = 0, 0
					pcall(function() ping = round(StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
					pcall(function() mem = round(StatsService:GetTotalMemoryUsageMb()) end)
					Library.Ping = ping
					stats:Set(1, fps); stats:Set(2, ping); stats:Set(3, mem)
					fpsGraph:Push(fps)
					pingGraph:Push(ping)
					sessionStats:Set(1, #Players:GetPlayers())
					sessionStats:Set(2, round(workspace.DistributedGameTime))
					memBar:Set(math.clamp(mem / 2048 * 100, 0, 100))
				end
				task.wait(0.5)
			end
		end)
	end

	------------------------------------------------ APPEARANCE
	if enabled("Appearance") then
		local tab = win:AddTab("Appearance", "palette", "Theme, interface and visual effects.", { System = true })

		local theme = tab:AddSection("Theme")
		local accentPicker, accent2Picker
		theme:AddDropdown({ Name = "Accent preset", Options = { "Nexus", "Violet", "Ember", "Mint", "Rose", "Gold" }, Default = "Nexus",
			Callback = function(v)
				Library:SetPreset(v)
				local p = Presets[v]
				if p and accentPicker then accentPicker:Set(p[1], true); accent2Picker:Set(p[2], true) end
				setFlag({ Flag = "nexus_accent" }, C.Accent)
				setFlag({ Flag = "nexus_accent2" }, C.Accent2)
			end })
		accentPicker = theme:AddColorPicker({ Name = "Accent colour", Description = "Repaints the whole interface", Default = C.Accent,
			Flag = "nexus_accent", Callback = function(c) Library:SetAccent(c, nil) end })
		accent2Picker = theme:AddColorPicker({ Name = "Secondary accent", Description = "Used in gradients", Default = C.Accent2,
			Flag = "nexus_accent2", Callback = function(c) Library:SetAccent(nil, c) end })

		local iface = tab:AddSection("Interface", "Right")
		iface:AddSegmented({ Name = "On-screen button", Description = "Auto shows it while the menu is hidden",
			Options = { "Auto", "On", "Off" }, Width = 0.5, Flag = "nexus_button",
			Default = (Library.Settings.ToggleButton == "Always" and "On") or (Library.Settings.ToggleButton == "Never" and "Off") or "Auto",
			Callback = function(v) Library:SetToggleButton((v == "On" and "Always") or (v == "Off" and "Never") or "Auto") end })
		iface:AddDropdown({ Name = "Interface scale", Options = { "Auto", "100%", "88%", "75%", "63%" }, Default = "Auto", Flag = "nexus_scale",
			Callback = function(v) Library:SetScale(SCALE_OPTIONS[v]) end })
		iface:AddToggle({ Name = "Watermark", Description = "Stats pill in the top-left corner", Default = Library.Settings.Watermark,
			Flag = "nexus_watermark", Callback = function(v) Library:SetWatermark(v) end })
		iface:AddToggle({ Name = "Dim background", Description = "Darkens the game behind the window", Default = Library.Settings.Blur,
			Flag = "nexus_dim", Callback = function(v) Library:SetBlur(v) end })
		iface:AddToggle({ Name = "Interface sounds", Default = Library.Settings.Sounds, Flag = "nexus_sounds",
			Callback = function(v) Library.Settings.Sounds = v end })

		local ambient = tab:AddSection("Ambient")
		refs.aurora = ambient:AddToggle({ Name = "Ambient light", Description = "Soft colour drifting behind the window", Default = Library.FX.Aurora,
			Flag = "nexus_fx_aurora", Callback = function(v) win:SetEffect("Aurora", v) end })
		refs.noise = ambient:AddToggle({ Name = "Film grain", Description = "Faint texture on the window", Default = Library.FX.Noise,
			Flag = "nexus_fx_noise", Callback = function(v) win:SetEffect("Noise", v) end })

		local cinema = tab:AddSection("Cinematic", "Right", { Collapsed = true })
		cinema:AddLabel("Optional effects. Everything here is off by default.")
		cinema:AddToggle({ Name = "Enable all", Description = "Turns every effect below on or off", Callback = function(v)
			for _, t in ipairs(refs.cine) do t:Set(v) end
		end })
		cinema:AddSeparator()
		for i, e in ipairs(CINEMATIC_EFFECTS) do
			refs.cine[i] = cinema:AddToggle({ Name = e[2], Default = Library.FX[e[1]] == true, Flag = "nexus_fx_" .. string.lower(e[1]),
				Callback = function(v) win:SetEffect(e[1], v) end })
		end
		cinema:AddButton({ Name = "Play glitch once", Callback = function() win:Glitch() end })
	end

	------------------------------------------------ SETTINGS
	-- Only added while the demo runs (NEXUS_NO_DEMO not set). Override with CreateWindow{ Profiles = true / false }.
	local profiles = cfg.Profiles
	if profiles == nil then profiles = not env.NEXUS_NO_DEMO end
	if enabled("Settings") and profiles then
		local tab = win:AddTab("Settings", "settings-2", "Profiles, start-up behaviour and controls.", { System = true })

		local function unloadButton(section)
			section:AddButton({ Name = "Unload", Variant = "Danger", Icon = "log-out", Callback = function()
				Library:Dialog({
					Title = "Unload the interface?", Content = "This removes the menu and disconnects every listener. Unsaved changes will be lost.",
					Buttons = {
						{ Text = "Cancel" },
						{ Text = "Unload", Variant = "Danger", Callback = function()
							win:SetVisible(false)
							task.wait(M.Exit + 0.1)
							Library:Unload()
						end },
					},
				})
			end })
		end

		local canFiles = Library:CanSaveConfigs()

		local prof = tab:AddSection("Profiles")
		if not canFiles then
			prof:AddLabel("Saving profiles needs an executor with file access (writefile / readfile). Roblox Studio can't write files.")
		end
		local nameBox
		local saved = prof:AddDropdown({ Name = "Saved profiles", Description = "Pick one to fill in the name", Options = Library:ListConfigs(),
			Callback = function(v) if v and nameBox then nameBox:Set(v) end end })
		nameBox = prof:AddTextbox({ Name = "Profile name", Default = Library:GetAutoload() or "default", Placeholder = "default" })
		local function refresh() saved:Refresh(Library:ListConfigs()) end
		local function currentName()
			local n = tostring(nameBox:Get()):gsub("[^%w%-_ ]", "")
			return n ~= "" and n or "default"
		end
		local function doSave(n)
			local ok, err = Library:SaveConfig(n)
			Library:Notify({ Title = ok and "Profile saved" or "Couldn't save", Content = ok and ("Saved as " .. n .. ".json") or tostring(err),
				Type = ok and "Success" or "Error" })
			refresh()
		end
		prof:AddButton({ Name = "Save profile", Variant = "Primary", Icon = "download", Callback = function()
			local n = currentName()
			if table.find(Library:ListConfigs(), n) then
				Library:Dialog({ Title = "Overwrite " .. n .. "?", Content = "A profile with this name already exists. Saving replaces it with your current settings.",
					Buttons = { { Text = "Cancel" }, { Text = "Overwrite", Variant = "Primary", Callback = function() doSave(n) end } } })
			else
				doSave(n)
			end
		end })
		prof:AddButton({ Name = "Load profile", Variant = "Secondary", Icon = "upload", Callback = function()
			local n = currentName()
			local ok, err = Library:LoadConfig(n)
			Library:Notify({ Title = ok and "Profile loaded" or "Couldn't load", Content = ok and ("Applied " .. n .. ".json") or tostring(err),
				Type = ok and "Success" or "Error" })
		end })
		prof:AddButton({ Name = "Delete profile", Variant = "Danger", Icon = "trash", Callback = function()
			local n = currentName()
			Library:Dialog({ Title = "Delete " .. n .. "?", Content = "This removes " .. n .. ".json from disk. It can't be undone.",
				Buttons = { { Text = "Cancel" }, { Text = "Delete", Variant = "Danger", Callback = function()
					local ok, err = Library:DeleteConfig(n)
					Library:Notify({ Title = ok and "Profile deleted" or "Couldn't delete", Content = ok and (n .. ".json was removed.") or tostring(err),
						Type = ok and "Success" or "Error" })
					refresh()
				end } } })
		end })
		prof:AddButton({ Name = "Refresh list", Description = "Rescan the NexusUI folder", Callback = refresh })

		local startup = tab:AddSection("Start-up", "Right")
		local autoLabel
		local function autoText()
			local a = Library:GetAutoload()
			return a and ("Auto-load: <b>" .. escapeRich(a) .. "</b>") or "No profile loads automatically."
		end
		startup:AddToggle({ Name = "Load profile on start", Description = "Applies the profile named on the left", Default = Library:GetAutoload() ~= nil,
			Callback = function(v)
				local ok, err = Library:SetAutoload(v and currentName() or nil)
				if not ok then Library:Notify({ Title = "Couldn't change auto-load", Content = tostring(err), Type = "Error" }) end
				if autoLabel then autoLabel:SetText(autoText()) end
			end })
		autoLabel = startup:AddLabel(autoText())

		local controls = tab:AddSection("Controls", "Right")
		controls:AddKeybind({ Name = "Toggle menu", Description = "Show or hide the window", Default = win.ToggleKey, Flag = "nexus_togglekey",
			OnChange = function(k) if k then win.ToggleKey = k end end })
		controls:AddButton({ Name = "Print all flags", Description = "Writes every flag to the output", Callback = function()
			print("[Nexus] flags")
			for k, v in pairs(Library.Flags) do
				if typeof(v) == "table" then v = "{" .. table.concat(v, ", ") .. "}"
				elseif typeof(v) == "Color3" then v = toHex(v) end
				print("  " .. k .. " = " .. tostring(v))
			end
			Library:Notify({ Title = "Flags printed", Content = "Open the output window to see them.", Type = "Success" })
		end })
		unloadButton(controls)
	end
end

----------------------------------------------------------------------
-- CONFIG SAVE / LOAD (executor only: needs writefile/readfile)
----------------------------------------------------------------------
local CONFIG_DIR = "NexusUI"
local function encodeValue(v)
	local t = typeof(v)
	if t == "Color3" then return { __t = "c3", r = v.R, g = v.G, b = v.B } end
	if t == "EnumItem" then return { __t = "key", n = v.Name } end
	return v
end
local function decodeValue(v)
	if type(v) == "table" and v.__t == "c3" then return Color3.new(v.r, v.g, v.b) end
	if type(v) == "table" and v.__t == "key" then
		local ok, k = pcall(function() return Enum.KeyCode[v.n] end)
		return ok and k or nil
	end
	return v
end

local function ensureFolder()
	if typeof(isfolder) == "function" and typeof(makefolder) == "function" and not isfolder(CONFIG_DIR) then makefolder(CONFIG_DIR) end
end
local function cleanName(name)
	name = tostring(name or ""):gsub("[^%w%-_ ]", "")
	return name ~= "" and name or "default"
end

function Library:CanSaveConfigs()
	return typeof(writefile) == "function" and typeof(readfile) == "function"
end

function Library:SaveConfig(name)
	if typeof(writefile) ~= "function" then return false, "Saving needs an executor with writefile" end
	name = cleanName(name)
	local data = {}
	for flag, v in pairs(self.Flags) do data[flag] = encodeValue(v) end
	local ok, err = pcall(function()
		ensureFolder()
		writefile(CONFIG_DIR .. "/" .. name .. ".json", HttpService:JSONEncode(data))
	end)
	return ok, err
end

-- names of every saved profile (without .json), sorted
function Library:ListConfigs()
	local out = {}
	if typeof(listfiles) ~= "function" then return out end
	pcall(function()
		ensureFolder()
		for _, path in ipairs(listfiles(CONFIG_DIR)) do
			local n = tostring(path):match("([^/\\]+)%.json$")
			if n then table.insert(out, n) end
		end
	end)
	table.sort(out)
	return out
end

function Library:DeleteConfig(name)
	if typeof(delfile) ~= "function" then return false, "Deleting needs an executor with delfile" end
	name = cleanName(name)
	local ok, err = pcall(function() delfile(CONFIG_DIR .. "/" .. name .. ".json") end)
	if ok and self:GetAutoload() == name then self:SetAutoload(nil) end
	return ok, err
end

-- profile applied automatically when a window starts (nil clears it)
function Library:SetAutoload(name)
	if typeof(writefile) ~= "function" then return false, "Auto-load needs an executor with writefile" end
	local ok, err = pcall(function()
		ensureFolder()
		local path = CONFIG_DIR .. "/autoload.txt"
		if name == nil then
			if typeof(delfile) == "function" and (typeof(isfile) ~= "function" or isfile(path)) then delfile(path) else writefile(path, "") end
		else
			writefile(path, cleanName(name))
		end
	end)
	return ok, err
end

function Library:GetAutoload()
	if typeof(readfile) ~= "function" then return nil end
	local ok, name = pcall(function()
		local path = CONFIG_DIR .. "/autoload.txt"
		if typeof(isfile) == "function" and not isfile(path) then return nil end
		return readfile(path)
	end)
	if ok and type(name) == "string" and name ~= "" then return name end
	return nil
end

-- on-screen toggle button: "Auto" (only while hidden), "Always", "Never"  (true = Always, false = Never)
function Library:SetToggleButton(mode)
	if mode == true then mode = "Always" elseif mode == false then mode = "Never" end
	if mode ~= "Always" and mode ~= "Never" then mode = "Auto" end
	self.Settings.ToggleButton = mode
	if self.Window and self.Window._updateMobile then self.Window._updateMobile() end
end

-- interface scale: "Auto" (fit the screen) or a number such as 1, 0.875, 0.75
function Library:SetScale(scale)
	self.Settings.Scale = (type(scale) == "number") and scale or "Auto"
	if self.Window and self.Window._fit then self.Window._fit() end
end

function Library:LoadConfig(name)
	if typeof(readfile) ~= "function" then return false, "Loading needs an executor with readfile" end
	name = cleanName(name)
	local ok, data = pcall(function() return HttpService:JSONDecode(readfile(CONFIG_DIR .. "/" .. name .. ".json")) end)
	if not ok then return false, "Profile not found" end
	for flag, v in pairs(data) do
		local opt = self.Options[flag]
		if opt and opt.Set then pcall(function() opt:Set(decodeValue(v)) end) end
	end
	return true
end

----------------------------------------------------------------------
-- UNLOAD
----------------------------------------------------------------------
function Library:Unload()
	self._alive = false
	pcall(closePopover)
	for _, c in ipairs(self._connections) do pcall(function() c:Disconnect() end) end
	for s in pairs(ActiveSprings) do ActiveSprings[s] = nil end
	for i = #Toasts, 1, -1 do Toasts[i] = nil end
	for i = #Magnets, 1, -1 do Magnets[i] = nil end
	Tip.canvas, Tip.owner, Tip.token = nil, nil, nil
	self._connections, self._steppers, self._spinners, self._painters = {}, {}, {}, {}
	self._popover, self._watermark = nil, nil
	if self._noiseImage then pcall(function() self._noiseImage:Destroy() end) end
	if self._soundFolder then self._soundFolder:Destroy() end
	if self._root then self._root:Destroy() end
	self._root = nil
end

----------------------------------------------------------------------
-- DEMO
----------------------------------------------------------------------
if not env.NEXUS_NO_DEMO then
	local Window = Library:CreateWindow({
		Title = "Nexus",
		ToggleKey = Enum.KeyCode.RightShift,
		OnReady = function()
			Library:Notify({ Title = "Welcome back", Content = "Press RightShift to hide or show Nexus. Ctrl+K searches settings.", Type = "Info", Duration = 6 })
		end,
	})

	------------------------------------------------ OVERVIEW
	local overview = Window:AddTab("Overview", "layout-dashboard", "Quick actions and component showcase. Performance, Appearance and Settings are built in.")

	local quick = overview:AddSection("Quick actions")
	quick:AddParagraph({ Title = "Getting started", Content = "Every control in this demo is live. The System tabs at the bottom of the sidebar (Performance, Appearance, Settings) are added to every window automatically, even with the demo turned off." })
	quick:AddButton({ Name = "Run diagnostics", Variant = "Primary", Icon = "zap", Async = true, DoneText = "All clear",
		Tooltip = "Shows a loading state, then a confirmation", Callback = function()
			task.wait(1.4)
			Library:Notify({ Title = "Diagnostics complete", Content = "No issues found across 14 checks.", Type = "Success" })
		end })
	quick:AddButton({ Name = "Send test notification", Variant = "Liquid", Icon = "bell", Callback = function()
		Library:Notify({ Title = "Test notification", Content = "Hover the stack to fan it out and pause timers.", Type = "Info" })
	end })
	quick:AddButton({ Name = "Hover to flip", Variant = "Flip", Back = "Opens a dialog", Callback = function()
		Library:Dialog({ Title = "Share this profile?", Content = "Anyone with the link will be able to view your settings.",
			Buttons = { { Text = "Cancel", Variant = "Secondary" }, { Text = "Share", Variant = "Primary", Callback = function()
				Library:Notify({ Title = "Link copied", Content = "Your profile link is ready to paste.", Type = "Success" })
			end } } })
	end })
	quick:AddButton({ Name = "View changelog", Description = "See what's new in this release", Callback = function()
		Library:Notify({ Title = "Nexus 3.2", Content = "Spring physics, rolling numbers, stacked toasts and more.", Type = "Info" })
	end })
	quick:AddButton({ Name = "Report a problem", Description = "Opens a warning toast", Callback = function()
		Library:Notify({ Title = "Unsaved changes", Content = "Your profile has changes that haven't been saved yet.", Type = "Warning" })
	end })
	quick:AddSeparator("Danger zone")
	quick:AddButton({ Name = "Reset session", Variant = "Danger", Icon = "refresh", Callback = function()
		Library:Notify({ Title = "Session reset failed", Content = "Reconnect and try again.", Type = "Error" })
	end })

	------------------------------------------------ CONTROLS
	local controls = Window:AddTab("Controls", "sliders-horizontal", "Toggles, checkboxes, sliders and text input.")

	local behaviour = controls:AddSection("Behaviour")
	behaviour:AddToggle({ Name = "Auto-save", Description = "Write changes to disk every 30 seconds", Default = true, Flag = "autosave",
		Callback = function(v) print("[Nexus] autosave:", v) end })
	behaviour:AddToggle({ Name = "Hardware acceleration", Description = "Use the GPU where available", Default = true, Flag = "hwaccel" })
	behaviour:AddToggle({ Name = "Compact mode", Flag = "compact", Tooltip = "Reduces padding in lists" })
	behaviour:AddSeparator()
	behaviour:AddCheckbox({ Name = "Show tooltips", Default = true, Flag = "tooltips" })
	behaviour:AddCheckbox({ Name = "Check for updates on launch", Default = true, Flag = "updates" })
	behaviour:AddCheckbox({ Name = "Share anonymous usage data", Description = "Helps us prioritise improvements", Flag = "telemetry" })

	local tuning = controls:AddSection("Tuning")
	tuning:AddSlider({ Name = "Master volume", Min = 0, Max = 100, Default = 72, Suffix = "%", Flag = "volume",
		Tooltip = "Click the value to type an exact number", Callback = function(v) print("[Nexus] volume:", v) end })
	tuning:AddSlider({ Name = "Field of view", Min = 60, Max = 120, Default = 90, Suffix = "°", Flag = "fov" })
	tuning:AddSlider({ Name = "Mouse sensitivity", Min = 0.1, Max = 3, Default = 1, Increment = 0.05, Suffix = "×", Flag = "sens" })
	tuning:AddSlider({ Name = "Frame rate cap", Min = 30, Max = 240, Default = 144, Increment = 1, Suffix = " fps", Flag = "fpscap" })

	local layoutSec = controls:AddSection("Layout")
	layoutSec:AddSegmented({ Name = "Density", Options = { "Compact", "Default", "Comfy" }, Default = "Default", Flag = "density",
		Callback = function(v) print("[Nexus] density:", v) end })
	layoutSec:AddSegmented({ Name = "Alignment", Options = { "Left", "Center", "Right" }, Default = "Left", Flag = "align" })
	layoutSec:AddRadio({ Name = "Startup behaviour", Options = { "Open last session", "Open a blank workspace", "Show the welcome screen" },
		Default = "Open last session", Flag = "startup", Callback = function(v) print("[Nexus] startup:", v) end })

	local identity = controls:AddSection("Identity", nil, { Collapsed = false })
	identity:AddTextbox({ Name = "Display name", Placeholder = "Your name", MaxLength = 24, Flag = "displayname",
		Callback = function(text, enter) print("[Nexus] name:", text, enter and "(enter)" or "") end })
	identity:AddTextbox({ Name = "Invite code", Description = "Click the copy icon", Default = "NX-7F3K-2QPL", Copy = true, Flag = "invite" })
	identity:AddTextbox({ Name = "Port", Description = "Numbers only", Placeholder = "25565", NumbersOnly = true, Flag = "port" })
	identity:AddTextbox({ Name = "Status message", Placeholder = "What are you working on?", Flag = "status" })

	------------------------------------------------ SELECTION
	local selection = Window:AddTab("Selection", "list", "Dropdowns, comboboxes and lists.")

	local menus = selection:AddSection("Dropdowns")
	menus:AddDropdown({ Name = "Render quality", Options = { "Low", "Medium", "High", "Ultra", "Custom" }, Default = "High", Flag = "quality",
		Callback = function(v) print("[Nexus] quality:", v) end })
	menus:AddDropdown({ Name = "Enabled modules", Multi = true, Options = { "Analytics", "Autosave", "Cloud sync", "Hotkeys", "Overlay", "Telemetry", "Updater" },
		Default = { "Autosave", "Hotkeys", "Overlay" }, Flag = "modules", Tooltip = "Pick as many as you like",
		Callback = function(v) print("[Nexus] modules:", table.concat(v, ", ")) end })
	menus:AddDropdown({ Name = "Region", Description = "Lists over 8 items get a search field",
		Options = { "US East", "US West", "Canada", "Brazil", "EU West", "EU Central", "UK", "India", "Singapore", "Japan", "Australia", "South Africa" },
		Default = "EU West", Flag = "region" })

	local combo = selection:AddSection("Combobox")
	combo:AddCombobox({ Name = "Default server", Options = { "Amsterdam", "Ashburn", "Chicago", "Dallas", "Frankfurt", "London", "Los Angeles", "Mumbai",
		"Paris", "São Paulo", "Seattle", "Singapore", "Stockholm", "Sydney", "Tokyo", "Toronto" },
		Default = "Frankfurt", Placeholder = "Search servers", Flag = "server", Callback = function(v) print("[Nexus] server:", v) end })
	combo:AddLabel("Type to filter. Press Enter to keep a custom value.")

	local lists = selection:AddSection("Lists")
	lists:AddListbox({ Name = "Team members", Height = 160, Multi = true,
		Options = { "Avery Chen", "Jordan Miles", "Sam Okafor", "Priya Raman", "Leo Martins", "Noor Haddad", "Kai Tanaka", "Elena Petrova" },
		Default = { "Avery Chen", "Priya Raman" }, Flag = "team", Callback = function(v) print("[Nexus] team:", table.concat(v, ", ")) end })
	lists:AddListbox({ Name = "Release channel", Height = 104, Multi = false, Options = { "Stable", "Beta", "Nightly" }, Default = "Stable", Flag = "channel" })

	------------------------------------------------ INPUT
	local inputTab = Window:AddTab("Input", "keyboard", "Keybinds and colour pickers.")

	local binds = inputTab:AddSection("Keybinds")
	binds:AddKeybind({ Name = "Quick toggle", Default = Enum.KeyCode.LeftControl, Flag = "kb_quick",
		Callback = function() Library:Notify({ Title = "Quick toggle", Content = "Shortcut triggered.", Type = "Info", Duration = 2 }) end })
	binds:AddKeybind({ Name = "Take screenshot", Default = Enum.KeyCode.G, Flag = "kb_shot",
		Callback = function() Library:Notify({ Title = "Screenshot saved", Content = "Saved to your captures folder.", Type = "Success", Duration = 2 }) end })
	binds:AddKeybind({ Name = "Push to talk", Description = "Hold to transmit voice", Default = Enum.KeyCode.V, Flag = "kb_ptt" })
	binds:AddLabel("Click a key, then press a new one. Esc cancels, Backspace clears.")

	local colors = inputTab:AddSection("Colours")
	colors:AddColorPicker({ Name = "Highlight colour", Default = Color3.fromRGB(52, 201, 150), Flag = "col_highlight" })
	colors:AddColorPicker({ Name = "Selection colour", Description = "Used for outlines", Default = Color3.fromRGB(240, 112, 168), Flag = "col_select" })
	colors:AddLabel("Click a swatch to open the picker. Type a hex code or choose a preset.")

end

return Library
