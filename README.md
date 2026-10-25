<img width="961" height="769" alt="image" src="https://github.com/user-attachments/assets/03ce4a42-fc1f-483b-b5df-5a275fafbe78" />




# Nexus UI — Library Reference (v3.2)

Nexus is a single-file interface library for Roblox. One script gives you a draggable window with a sidebar, tabs, collapsible section cards and 18 kinds of controls, plus notifications, dialogs, popovers, right-click menus, themes and config saving.

---

## Contents

1. [Quick start](#1-quick-start)
2. [Loading the library](#2-loading-the-library)
3. [Core concepts](#3-core-concepts)
4. [Library](#4-library)
5. [Window](#5-window)
6. [Tab](#6-tab)
7. [Section](#7-section)
8. [Elements](#8-elements)
9. [Notifications and dialogs](#9-notifications-and-dialogs)
10. [Themes and appearance](#10-themes-and-appearance)
11. [Effects](#11-effects)
12. [Configs (save / load)](#12-configs-save--load)
13. [Icons](#13-icons)
14. [Keyboard and mouse](#14-keyboard-and-mouse)
15. [Customising tokens](#15-customising-tokens)
16. [Full example](#16-full-example)

---

## 1. Quick start

```lua
getgenv().NEXUS_NO_DEMO = true          -- skip the built-in demo
local Library = loadstring(game:HttpGet("YOUR_RAW_URL/NexusUI.lua"))()

local Window  = Library:CreateWindow({ Title = "My Hub" })
local Main    = Window:AddTab("Main", "layout-dashboard", "Everything you use most.")
local Section = Main:AddSection("Movement")

Section:AddToggle({
    Name = "Sprint",
    Flag = "sprint",
    Callback = function(on) print("Sprint:", on) end,
})

Section:AddSlider({
    Name = "Walk speed", Min = 16, Max = 100, Default = 16, Flag = "speed",
    Callback = function(v) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end,
})
```

Every value is always available in `Library.Flags`, for example `Library.Flags.speed`.

---

## 2. Loading the library

| Where | How |
|---|---|
| **Executor** | Paste the file and run it, or host it and use `loadstring(game:HttpGet(url))()`. |
| **Roblox Studio (LocalScript)** | Put the whole file in a LocalScript under *StarterPlayer > StarterPlayerScripts* and press Play. |
| **Roblox Studio (ModuleScript)** | Put the file in a ModuleScript and `local Library = require(path.To.Module)`. |

The file **returns the `Library` table**.

### Turning off the demo

The built-in demo runs unless you set this flag **before** the file runs:

```lua
getgenv().NEXUS_NO_DEMO = true   -- executors
_G.NEXUS_NO_DEMO = true          -- Roblox Studio (no getgenv)
```

### Re-running

Running the script again automatically unloads the previous copy first, so you never end up with two windows.

---

## 3. Core concepts

```
Library
 └── Window          Library:CreateWindow(cfg)
      └── Tab        Window:AddTab(name, icon, description)
           └── Section   Tab:AddSection(name, side, opts)
                └── Elements   Section:AddToggle(cfg), Section:AddSlider(cfg), …
```

### Config tables

Every element is created by passing a single table:

```lua
Section:AddToggle({ Name = "Enabled", Default = true, Flag = "enabled", Callback = print })
```

### Flags

If you give an element a `Flag`, its current value is mirrored into `Library.Flags[flag]` and the element object is stored in `Library.Options[flag]`. Configs save and load through these.

```lua
print(Library.Flags.enabled)           -- current value
Library.Options.enabled:Set(false)     -- change it from code
```

### Element objects

Most `Add*` calls return an object you can keep to read or change the control later:

```lua
local toggle = Section:AddToggle({ Name = "Enabled" })
toggle:Set(true)          -- updates the UI and fires the callback
toggle:Set(false, true)   -- second argument `silent = true` skips the callback
print(toggle:Get())
```

### Callbacks

Callbacks run in their own thread and are wrapped in `pcall`. If one errors, you get a `[Nexus] callback error: …` warning in the output, and the UI keeps working.

---

## 4. Library

### Methods

| Method | Description |
|---|---|
| `Library:CreateWindow(cfg)` | Creates the window. Returns a [Window](#5-window). |
| `Library:Notify(cfg)` | Shows a toast notification. See [§9](#9-notifications-and-dialogs). |
| `Library:Dialog(cfg)` | Shows a confirmation dialog. Returns a `close()` function. See [§9](#9-notifications-and-dialogs). |
| `Library:SetAccent(accent, accent2)` | Repaints the whole UI with new accent colours (`Color3`). Pass `nil` to leave one unchanged. |
| `Library:SetPreset(name)` | Applies a built-in accent preset with a colour-wave animation. See [§10](#10-themes-and-appearance). |
| `Library:SetBlur(on)` | Shows or hides a dim, vignetted backdrop behind the window. It doesn't blur the 3D world; the name is kept from v3.0. |
| `Library:SetWatermark(on)` | Shows or hides the stats pill in the top-left corner. |
| `Library:SaveConfig(name)` | Saves all flags to `workspace/NexusUI/<name>.json`. Returns `ok, err`. Executor only. |
| `Library:LoadConfig(name)` | Loads a saved config and applies it to every flagged element. Returns `ok, err`. Executor only. |
| `Library:Unload()` | Destroys every instance and disconnects every connection. |

### Fields

| Field | Description |
|---|---|
| `Library.Flags` | `flag → current value` for every flagged element. |
| `Library.Options` | `flag → element object` for every flagged element. |
| `Library.Window` | The most recently created window. |
| `Library.Theme` | The live colour table. Older key names such as `Background` and `SubText` also work. |
| `Library.Tokens` | The design-token table. See [§15](#15-customising-tokens). |
| `Library.Presets` | The built-in accent presets. |
| `Library.FX` | Which effects are on (`name → bool`). Change them with `Window:SetEffect`. |
| `Library.Settings` | `{ Sounds = false, Blur = false, Watermark = false }`. You can set `Settings.Sounds` directly. |
| `Library.FPS` | Current client frame rate (updated twice a second). |
| `Library.Ping` | Last measured ping in ms (updated while the watermark is visible). |

---

## 5. Window

```lua
local Window = Library:CreateWindow({
    Title        = "My Hub",                   -- default "Nexus"
    Version      = "v1.0",                     -- version pill text, default "v3.2"
    Width        = 780,                        -- default 780
    Height       = 540,                        -- default 540
    ToggleKey    = Enum.KeyCode.RightShift,    -- default RightShift
    Intro        = true,                       -- false skips the splash screen
    Search       = true,                       -- false hides the title-bar search field
    SidebarLabel = "Workspace",                -- small label above the tabs
    Messages     = { "Connected", "Ready" },   -- lines for the "Typing" effect
    OnReady      = function(window) end,       -- called once the window has opened
})
```

The window scales down automatically on small screens, in crisp steps (1, 0.875, 0.75, 0.625, 0.5).

### Methods

| Method | Description |
|---|---|
| `Window:AddTab(name, icon, description)` | Adds a sidebar tab and its page. `icon` and `description` are optional. Returns a [Tab](#6-tab). |
| `Window:SelectTab(tab, force)` | Switches to a tab. `force = true` replays the entry animation even if it's already active. |
| `Window:SetVisible(bool)` | Shows or hides the window with its fade/scale animation. |
| `Window:Toggle()` | Flips visibility. Does nothing during the splash screen. |
| `Window:Minimize()` | Collapses the window to its title bar, or expands it again. |
| `Window:Filter(query)` | Filters the current tab's rows by name and description, the same as typing in the search field. |
| `Window:SetEffect(name, on)` | Turns an effect on or off. See [§11](#11-effects). |
| `Window:Glitch()` | Plays a single glitch burst (only while the window is visible). |
| `Window:Destroy()` | Removes this window, its watermark and its reopen button. |

### Fields

| Field | Description |
|---|---|
| `Window.ToggleKey` | The key that shows and hides the window. Assign a new `Enum.KeyCode` at any time. |
| `Window.Visible` / `Window.Minimized` | Current state (read-only; use the methods to change it). |
| `Window.Tabs` / `Window.Active` | All tabs, and the selected tab. |
| `Window.Main` | The window's main frame, if you want to parent your own UI to it. |

When the window is hidden, a round reopen button appears on the left edge of the screen, which is useful on mobile.

---

## 6. Tab

```lua
local Tab = Window:AddTab("Combat", "zap", "Aim and targeting options.")
```

Each page shows its title (the letters roll in when you switch tabs) and the optional description, followed by two columns of section cards.

### `Tab:AddSection(name, side, opts)`

| Argument | Description |
|---|---|
| `name` | Card title. |
| `side` | `"Left"` or `"Right"`. If you leave it out, sections alternate between the two columns. |
| `opts.Collapsible` | Default `true`. Click the card title to fold the card away. |
| `opts.Collapsed` | Default `false`. Start folded. |

Returns a [Section](#7-section).

```lua
local Aim   = Tab:AddSection("Aim")                                  -- left
local Extra = Tab:AddSection("Extras", "Right", { Collapsed = true })
```

---

## 7. Section

A section is a card that holds rows. All the [Elements](#8-elements) are methods on it.

| Method | Description |
|---|---|
| `Section:SetCollapsed(collapsed, instant)` | Folds or unfolds the card. `instant = true` skips the animation. |
| `Section.Collapsed` | Current state. |

---

## 8. Elements

Keys shared by most elements:

| Key | Meaning |
|---|---|
| `Name` | The row label. |
| `Description` | A second, dimmer line under the name. It also makes the row taller. Not shown by sliders, listboxes, radio groups, graphs or progress bars, though it still counts for search. |
| `Flag` | Stores the value in `Library.Flags` and the object in `Library.Options`. |
| `Callback` | Called when the value changes. |
| `Tooltip` | Text shown after hovering for 0.4 s. |

Right-clicking any control with a value opens a menu with **Reset to default**, and **Copy flag name** if it has a `Flag`. Keybinds also get **Clear binding**, and colour pickers get **Copy hex**.

---

### 8.1 `AddLabel(text)`

A wrapped line of dim text. Supports RichText (`<b>bold</b>`).

```lua
local note = Section:AddLabel("Changes apply instantly.")
note:SetText("Saved!")
note:SetColor(Color3.fromRGB(52, 211, 153))
```

| Returns | `SetText(text)`, `SetColor(color3)` |
|---|---|

---

### 8.2 `AddParagraph(cfg)`

A title with a block of body text.

```lua
local p = Section:AddParagraph({ Title = "Getting started", Content = "Pick a tab on the left." })
p:Set("New title", "New body")   -- either argument can be nil
```

| Key | Default |
|---|---|
| `Title` | `""` |
| `Content` | `""` (supports RichText) |

| Returns | `Set(title, content)` |
|---|---|

---

### 8.3 `AddSeparator(text?)`

A thin divider line, optionally with a small uppercase label.

```lua
Section:AddSeparator()
Section:AddSeparator("Danger zone")
```

Returns the row frame.

---

### 8.4 `AddButton(cfg)`

Without a `Variant`, a button is a full-width clickable row with a chevron. With a `Variant`, it's a real filled or outlined button.

```lua
Section:AddButton({ Name = "Open settings", Description = "Advanced options", Callback = function() end })

Section:AddButton({ Name = "Save", Variant = "Primary", Icon = "download", Callback = save })

Section:AddButton({
    Name = "Run check", Variant = "Primary", Async = true, DoneText = "All clear",
    Callback = function() task.wait(2) end,   -- spinner shows until this returns
})

Section:AddButton({ Name = "Hover me", Variant = "Flip", Back = "Let's go", Callback = go })
```

| Key | Description |
|---|---|
| `Name` | Button text. |
| `Callback` | Called on click with no arguments. |
| `Variant` | `nil` (row), `"Primary"`, `"Secondary"`, `"Danger"`, `"Liquid"` or `"Flip"`. |
| `Description` | Row style only. |
| `Icon` | Icon name shown before the text (variant buttons only). See [§13](#13-icons). |
| `Back` | The text revealed on hover, for `"Flip"`. Default `"Let's go"`. |
| `Async` | `true` shows a spinner until the callback returns, then a drawn check and `DoneText` for about 1.2 s. |
| `DoneText` / `LoadingText` | Text shown after / during an `Async` click. Defaults `"Done"` / `""`. If the callback errors, it shows `"Failed"`. |
| `Burst` | `false` turns off the particle burst on Primary buttons. |
| `Tooltip` | Hover text. |

**Variants at a glance**

| Variant | Look and motion |
|---|---|
| `Primary` | Accent gradient, soft glow, a shine on hover and particles on click. |
| `Secondary` | Neutral surface with an outline. |
| `Danger` | Red tint, which gets stronger on hover. |
| `Liquid` | Accent outline. On hover, colour fills up from the bottom edge. |
| `Flip` | The label flips to the `Back` text on hover. |

All variants dip on press and lean slightly toward the cursor.

| Returns | `SetText(text)` |
|---|---|

---

### 8.5 `AddToggle(cfg)`

A switch. The knob stretches while you hold it, then springs across.

```lua
local t = Section:AddToggle({ Name = "Auto-save", Description = "Every 30 seconds", Default = true, Flag = "autosave",
    Callback = function(on) end })
```

| Key | Default |
|---|---|
| `Default` | `false` |
| `Callback` | `function(state: boolean)` |

| Returns | `Set(value, silent)`, `Get() → boolean` |
|---|---|

---

### 8.6 `AddCheckbox(cfg)`

The same as a toggle, shown as a checkbox whose tick draws itself.

```lua
Section:AddCheckbox({ Name = "Show tooltips", Default = true, Flag = "tips", Callback = function(on) end })
```

| Returns | `Set(value, silent)`, `Get() → boolean` |
|---|---|

---

### 8.7 `AddSlider(cfg)`

Drag the track, or click the value pill to type an exact number. The digits roll as the value changes.

```lua
Section:AddSlider({ Name = "Volume", Min = 0, Max = 100, Default = 70, Suffix = "%", Flag = "vol",
    Callback = function(v) end })

Section:AddSlider({ Name = "Sensitivity", Min = 0.1, Max = 3, Default = 1, Increment = 0.05, Suffix = "×" })
```

| Key | Default | Notes |
|---|---|---|
| `Min` | `0` | |
| `Max` | `100` | |
| `Default` | `Min` | Clamped to `[Min, Max]`. |
| `Increment` | `1` | Step size. Its decimal places set how many decimals are shown. |
| `Suffix` | `""` | Unit text after the number. |
| `Callback` | | `function(value: number)`. Fires only when the value actually changes. |

| Returns | `Set(value, silent)`, `Get() → number` |
|---|---|

---

### 8.8 `AddTextbox(cfg)`

A text field with a focus ring, a clear button and an optional character counter or copy button.

```lua
Section:AddTextbox({ Name = "Display name", Placeholder = "Your name", MaxLength = 24, Flag = "name",
    Callback = function(text, enterPressed) end })

Section:AddTextbox({ Name = "Invite code", Default = "NX-1234", Copy = true })
```

| Key | Default | Notes |
|---|---|---|
| `Default` | `""` | |
| `Placeholder` | `"Enter text"` | |
| `MaxLength` | none | Limits input and shows a `3/24` counter. |
| `NumbersOnly` | `false` | Strips everything except digits, `.` and `-`. |
| `ClearOnFocus` | `false` | Clears the field when it's clicked. |
| `Copy` | `false` | Adds a copy button (needs `setclipboard`). |
| `Callback` | | `function(text, enterPressed)`. Fires when the field loses focus. |

| Returns | `Set(text)`, `Get() → string` |
|---|---|

---

### 8.9 `AddDropdown(cfg)`

Opens a floating list. Single-select closes on pick; multi-select stays open. A search field appears when there are more than 8 options.

```lua
local d = Section:AddDropdown({ Name = "Quality", Options = { "Low", "Medium", "High" }, Default = "High", Flag = "quality",
    Callback = function(v) end })

local m = Section:AddDropdown({ Name = "Modules", Multi = true, Options = { "A", "B", "C" }, Default = { "A" },
    Callback = function(list) end })

d:Refresh({ "Low", "High", "Ultra" })   -- replace the options
```

| Key | Default | Notes |
|---|---|---|
| `Options` | `{}` | Array of strings (or values that `tostring` cleanly). |
| `Multi` | `false` | |
| `Default` | `nil` | A value, or an array when `Multi`. |
| `Callback` | | Receives the value, or an array (in option order) when `Multi`. |

Multi-select shows its value as `"A, B +2"`.

| Returns | `Get()`, `Set(value or array, silent)`, `Refresh(options)` |
|---|---|

---

### 8.10 `AddCombobox(cfg)`

A text field with a filtered suggestion list. The matching part of each suggestion is highlighted.

```lua
Section:AddCombobox({ Name = "Server", Options = { "London", "Tokyo", "Paris" }, Default = "London",
    Placeholder = "Search servers", AllowCustom = true, Flag = "server", Callback = function(v) end })
```

| Key | Default | Notes |
|---|---|---|
| `Options` | `{}` | |
| `Default` | `""` | |
| `Placeholder` | `"Search"` | |
| `AllowCustom` | `true` | If `true`, pressing Enter keeps whatever was typed, even if it isn't one of the options. |
| `Callback` | | `function(value: string)` |

| Returns | `Get()`, `Set(value, silent)`, `Refresh(options)` |
|---|---|

---

### 8.11 `AddListbox(cfg)`

An always-visible scrolling list. It's **multi-select by default**, with ALL / NONE shortcuts and a live count.

```lua
local lb = Section:AddListbox({ Name = "Players", Height = 160, Options = { "Alice", "Bob" }, Default = { "Alice" },
    Flag = "players", Callback = function(list) end })

lb:Add("Charlie")
lb:Refresh({ "Dan", "Eve" })

Section:AddListbox({ Name = "Channel", Multi = false, Options = { "Stable", "Beta" }, Default = "Stable" })
```

| Key | Default |
|---|---|
| `Options` | `{}` |
| `Multi` | `true` |
| `Height` | `130` (pixels) |
| `Default` | Array when `Multi`, otherwise a single value. |

| Returns | `Get()`, `Set(value or array, silent)`, `Refresh(options)`, `Add(option)` |
|---|---|

---

### 8.12 `AddKeybind(cfg)`

A keycap. Click it, then press a key. **Esc** cancels and **Backspace** clears.

```lua
Section:AddKeybind({ Name = "Dash", Default = Enum.KeyCode.Q, Flag = "dashKey",
    Callback = function(key) print("pressed", key) end,   -- each time the bound key is pressed
    OnChange = function(key) print("rebound to", key) end, -- when the binding changes (nil if cleared)
})
```

| Key | Description |
|---|---|
| `Default` | An `Enum.KeyCode`, or `nil`. |
| `Callback` | Fired when the bound key is pressed (not while typing in a text box). |
| `OnChange` | Fired when the user changes or clears the binding. |

| Returns | `Get() → KeyCode?`, `Set(keyCode)` (also fires `OnChange`) |
|---|---|

---

### 8.13 `AddColorPicker(cfg)`

A swatch that opens a picker with a saturation/value square, hue bar, hex input, presets and a **Cycle** (rainbow) button.

```lua
Section:AddColorPicker({ Name = "ESP colour", Default = Color3.fromRGB(255, 80, 80), Flag = "espColor",
    Callback = function(color) end })
```

| Key | Default |
|---|---|
| `Default` | The current accent colour. |
| `Callback` | `function(color: Color3)`. Fires continuously while dragging. |

| Returns | `Get() → Color3`, `Set(color3, silent)` |
|---|---|

---

### 8.14 `AddRadio(cfg)`

A vertical list of exclusive options. The selected dot springs in.

```lua
Section:AddRadio({ Name = "On startup", Options = { "Last session", "Blank", "Welcome screen" },
    Default = "Last session", Flag = "startup", Callback = function(v) end })
```

| Returns | `Get()`, `Set(value, silent)` |
|---|---|

---

### 8.15 `AddSegmented(cfg)`

A compact selector with a pill that slides between options.

```lua
Section:AddSegmented({ Name = "Density", Options = { "Compact", "Default", "Comfy" }, Default = "Default",
    Width = 0.6, Flag = "density", Callback = function(v) end })
```

| Key | Default | Notes |
|---|---|---|
| `Options` | `{}` | Best with 2–4 short labels. |
| `Default` | first option | |
| `Width` | `0.6` | Fraction of the row width the control takes. |

| Returns | `Get()`, `Set(value, silent)` |
|---|---|

---

### 8.16 `AddProgress(cfg)`

A read-only progress bar (0–100) with a rolling percentage.

```lua
local bar = Section:AddProgress({ Name = "Download", Default = 0 })
bar:Set(45)          -- animated
bar:Set(100, true)   -- instant
```

| Returns | `Set(value, instant)`, `Get() → number` |
|---|---|

---

### 8.17 `AddGraph(cfg)`

A live line chart with a gradient fill. Push a new sample whenever you like.

```lua
local g = Section:AddGraph({ Name = "Frame rate", Max = 144, Bars = 30, Suffix = " fps" })
task.spawn(function()
    while true do g:Push(Library.FPS) task.wait(0.5) end
end)
```

| Key | Default | Notes |
|---|---|---|
| `Max` | `100` | The value that reaches the top of the chart. |
| `Bars` | `30` | How many samples are kept (minimum 4). |
| `Suffix` | `""` | Shown after the current value. |

| Returns | `Push(value)` |
|---|---|

---

### 8.18 `AddStats(items)`

A row of stat tiles whose numbers count up with rolling digits. Note that it takes an **array**, not a config table.

```lua
local stats = Section:AddStats({
    { Name = "Players", Value = 12 },
    { Name = "Latency", Suffix = "ms" },
    { Name = "Coins",   Thousands = true },     -- 12,500
})
stats:Set(2, 48)            -- tile index, new value
print(stats:Get(1))
```

| Item key | Description |
|---|---|
| `Name` | Small uppercase label. |
| `Value` | Starting value (counts up from 0). |
| `Suffix` | Unit text. |
| `Decimals` | Number of decimals to show (default 0). |
| `Thousands` | `true` adds comma separators. |

| Returns | `Set(index, value)`, `Get(index)` |
|---|---|

---

## 9. Notifications and dialogs

### `Library:Notify(cfg)`

Toasts stack in the bottom-right corner as a deck. Hover the stack to fan it out, which also pauses the timers. Click a toast to dismiss it. At most 4 are kept.

```lua
Library:Notify({
    Title    = "Saved",
    Content  = "Your profile was written to disk.",
    Type     = "Success",   -- "Info" (default), "Success", "Warning", "Error"
    Duration = 4.5,         -- seconds, default 4.5
})
```

### `Library:Dialog(cfg)`

A modal confirmation with a dimmed background. Clicking a button closes the dialog and then runs its callback.

```lua
local close = Library:Dialog({
    Title   = "Delete profile?",
    Content = "This can't be undone.",
    Buttons = {
        { Text = "Cancel", Variant = "Secondary" },
        { Text = "Delete", Variant = "Danger", Callback = function() deleteProfile() end },
    },
    Dismissible = true,   -- default true: clicking the background or pressing Esc closes it
})
-- close()  -- close it yourself if needed
```

| Button key | Description |
|---|---|
| `Text` | Label. |
| `Variant` | Any button variant (default `"Secondary"`). |
| `Icon` | Optional icon name. |
| `Callback` | Called after the dialog closes. |

---

## 10. Themes and appearance

### Presets

```lua
Library:SetPreset("Violet")
```

| Preset | Accent |
|---|---|
| `Nexus` | Azure (default) |
| `Violet` | Purple |
| `Ember` | Orange |
| `Mint` | Green |
| `Rose` | Pink |
| `Gold` | Amber |

Old v3.0 names still work: `Cyber`, `Synthwave`, `Toxic`, `Inferno`, `Glacier`, `Aurum`.

### Custom accent

```lua
Library:SetAccent(Color3.fromRGB(255, 120, 80))          -- primary accent only
Library:SetAccent(nil, Color3.fromRGB(255, 80, 160))     -- secondary (gradient) accent only
```

Every accent-coloured part of the UI repaints immediately.

### Backdrop, watermark and sounds

```lua
Library:SetBlur(true)              -- dim + vignette behind the window
Library:SetWatermark(true)         -- top-left pill: logo · title · fps · ping · time
Library.Settings.Sounds = true     -- subtle click sounds (off by default)
```

---

## 11. Effects

Turn effects on and off with `Window:SetEffect(name, on)`. The current state is in `Library.FX[name]`.

**On by default (subtle)**

| Name | Effect |
|---|---|
| `Aurora` | Soft colour blobs drifting across the window, plus one that follows your cursor. |
| `Noise` | Faint film grain on the window (skipped where the environment can't generate it). |

**Cinematic (off by default)**

| Name | Effect |
|---|---|
| `Stars` | A star field that shifts with your mouse. |
| `Cursor` | A ring and dot that follow your cursor inside the window. |
| `Particles` | A network of linked dots that moves away from your cursor. |
| `Grid` | A slowly scrolling grid. |
| `Scanline` | A light band sweeping down the window. |
| `Spotlight` | A soft glow that follows your cursor. |
| `Glitch` | Random glitch bursts (`Window:Glitch()` plays one at any time). |
| `Comet` | A light that sweeps around the window border. |
| `GradientBorder` | A rotating gradient on the window border. |
| `Glow` | A pulsing coloured glow around the window. |
| `Brackets` | Pulsing corner brackets outside the window. |
| `Visualizer` | Bouncing bars in the title bar. |
| `Typing` | Status messages typed out in the title bar (set them with `cfg.Messages`). |
| `Scramble` | "Decrypting" text effect on titles and toasts. |

```lua
Window:SetEffect("Stars", true)
Window:SetEffect("Aurora", false)   -- the lowest idle cost
```

Ambient effects (`Aurora` and the pulsing presence dot) keep the window redrawing slowly. Turn off `Aurora` if you want the lowest idle cost.

---

## 12. Configs (save / load)

Configs need an executor that has `writefile` / `readfile`; they don't work in Roblox Studio. Files are stored in `workspace/NexusUI/<name>.json`.

```lua
local ok, err = Library:SaveConfig("default")
if not ok then warn(err) end

local ok2, err2 = Library:LoadConfig("default")
```

- Only elements with a `Flag` are saved.
- Colours and keybinds are converted to and from JSON automatically.
- Loading calls `Set` on every matching element, so their callbacks fire.

---

## 13. Icons

`AddTab`, button `Icon` and dialog-button `Icon` take an icon **name**. Icons are vector shapes drawn on a 24×24 grid in the Lucide style, and many animate when hovered.

```
x                 minus             plus              check
chevron-down      chevron-up        chevron-right     chevrons-up-down
search            info              alert-triangle    circle-check
circle-x          circle-dot        layout-dashboard  sliders-horizontal
list              keyboard          palette           settings-2
sparkles          zap               monitor           download
upload            log-out           terminal          bell
user              refresh           copy              trash
mark (Nexus logo)
```

Old glyph strings still work and map to the matching icon: `◈ ▣ ☰ ⌨ ✦ ⚙ × – ✓ ▼`. An unknown name shows `circle-dot`.

---

## 14. Keyboard and mouse

| Input | Action |
|---|---|
| `RightShift` (or `Window.ToggleKey`) | Show or hide the window. |
| `Ctrl + K` | Focus the search field. |
| `Esc` | Close the open dropdown, menu or dialog, or cancel keybind listening. |
| Right-click a control | Context menu (reset to default, copy flag name, and so on). |
| Click a section title | Fold or unfold the section. |
| Drag the title bar | Move the window. |
| `–` / `×` buttons | Minimize / hide. |

Change the toggle key at runtime with:

```lua
Window.ToggleKey = Enum.KeyCode.Insert
```

---

## 15. Customising tokens

Every colour, size, radius and duration lives in `Library.Tokens`. Change values **before** calling `CreateWindow`, since elements read them when they're created. Colours are the exception: `SetAccent` repaints those live.

```lua
getgenv().NEXUS_NO_DEMO = true
local Library = loadstring(game:HttpGet(url))()

Library.Tokens.Font.Display = "Roboto"         -- heading font (default "Montserrat")
Library.Tokens.Font.Text    = "Roboto"         -- body font
Library.Tokens.Size.Window  = Vector2.new(860, 600)
Library.Tokens.Motion.Toast = 6                -- toast duration
Library.Tokens.Color.Surface2 = Color3.fromRGB(24, 26, 32)

local Window = Library:CreateWindow({ Title = "Custom" })
```

Useful groups:

| Table | Contents |
|---|---|
| `Tokens.Color` | `Bg`, `Surface1`–`Surface4`, `Text`, `TextDim`, `TextMute`, `Accent`, `Accent2`, `Success`, `Warning`, `Danger` |
| `Tokens.Font` | `Display`, `Text`, `Mono` (Roblox font family names) |
| `Tokens.Type` | Text styles: `Display`, `Title`, `Body`, `Strong`, `Caption`, `Label`, `Mono`, `MonoSm`, `MonoLg` |
| `Tokens.Size` | Component sizes, for example `Window`, `Sidebar`, `Row`, `Toast` |
| `Tokens.Radius` | `Window`, `Card`, `Control`, `Small`, `Tiny`, `Pill` |
| `Tokens.Motion` | Durations in seconds, for example `Hover`, `State`, `Enter`, `Exit`, `Toast` |
| `Tokens.Spring` | Spring settings for each animation, using `K` (stiffness), `C` (damping) and `Mass` |

---

## 16. Full example

```lua
getgenv().NEXUS_NO_DEMO = true
local Library = loadstring(game:HttpGet("YOUR_RAW_URL/NexusUI.lua"))()
local Players = game:GetService("Players")

local Window = Library:CreateWindow({
    Title = "Speed Hub", Version = "v1.0",
    OnReady = function() Library:Notify({ Title = "Loaded", Content = "Press RightShift to toggle.", Type = "Success" }) end,
})

-- Player tab
local PlayerTab = Window:AddTab("Player", "user", "Movement and character settings.")
local Move = PlayerTab:AddSection("Movement")

Move:AddSlider({ Name = "Walk speed", Min = 16, Max = 120, Default = 16, Flag = "ws", Callback = function(v)
    local hum = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = v end
end })
Move:AddToggle({ Name = "Infinite jump", Description = "Jump in mid-air", Flag = "infjump" })
Move:AddKeybind({ Name = "Toggle infinite jump", Default = Enum.KeyCode.J, Callback = function()
    Library.Options.infjump:Set(not Library.Flags.infjump)
end })

local Look = PlayerTab:AddSection("Appearance", "Right")
Look:AddColorPicker({ Name = "Highlight", Default = Color3.fromRGB(92, 156, 255), Flag = "hl" })
Look:AddSegmented({ Name = "Mode", Options = { "Off", "Outline", "Fill" }, Default = "Outline", Flag = "hlMode" })

-- Settings tab
local SettingsTab = Window:AddTab("Settings", "settings-2")
local General = SettingsTab:AddSection("General")
General:AddDropdown({ Name = "Theme", Options = { "Nexus", "Violet", "Ember", "Mint", "Rose", "Gold" }, Default = "Nexus",
    Callback = function(v) Library:SetPreset(v) end })
General:AddKeybind({ Name = "Menu key", Default = Enum.KeyCode.RightShift, OnChange = function(k) if k then Window.ToggleKey = k end end })

local Profiles = SettingsTab:AddSection("Profiles", "Right")
local name = Profiles:AddTextbox({ Name = "Profile", Default = "default" })
Profiles:AddButton({ Name = "Save", Variant = "Primary", Icon = "download", Callback = function()
    local ok, err = Library:SaveConfig(name:Get())
    Library:Notify({ Title = ok and "Saved" or "Failed", Content = ok and "Profile saved." or tostring(err), Type = ok and "Success" or "Error" })
end })
Profiles:AddButton({ Name = "Load", Variant = "Secondary", Icon = "upload", Callback = function()
    Library:LoadConfig(name:Get())
end })
Profiles:AddButton({ Name = "Unload", Variant = "Danger", Icon = "log-out", Callback = function()
    Library:Dialog({ Title = "Unload?", Content = "The menu will close.", Buttons = {
        { Text = "Cancel" },
        { Text = "Unload", Variant = "Danger", Callback = function() Library:Unload() end },
    } })
end })
```
