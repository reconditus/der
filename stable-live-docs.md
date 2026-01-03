# stable-live.luau UI Element Reference

This document summarizes the UI API exposed by `stable-live.luau`, focusing on windows, tabs, sections, and widgets (sliders, toggles, dropdowns, etc.) and the configuration options each one accepts.

Source: `stable-live.luau`.

## Window → Page → Section

### `library:new(cfg)`
Creates the root window.

**Config**
- `name` / `Name`: main title (string).
- `sub` / `Sub`: subtitle/accent (string).
- `size` / `Size`: `Vector2` size for the window.

**Returns**: `window` object.

### `window:page(cfg)`
Creates a top-level page (tab).

**Config**
- `name` / `Name`: tab label.
- `default` / `Default`: `true` to show this page initially.

**Returns**: `page` object.

### `page:section(cfg)`
Creates a standard section in the left/right column.

**Config**
- `name` / `Name`: section title.
- `side` / `Side`: `"left"` or `"right"`.
- `size` / `Size`: height in pixels or `"auto"` to grow with content.

**Returns**: `section` object.

### `page:multisection(cfg)`
Creates a section with its own tabs and two internal columns.

**Config**
- `name` / `Name`: title.
- `side` / `Side`: `"left"` or `"right"`.
- `size` / `Size`: height in pixels or `"auto"`.
- `override`: when `true`, uses full page width instead of a side column.
- `offset`: Y offset when `override` is enabled.

**Returns**: `multisection` object.

### `multisection:section(cfg)`
Creates a tabbed sub-section inside the multisection.

**Config**
- `name` / `Name`: label for the sub-tab.
- `default` / `Default`: `true` to open by default.

**Returns**: `section` object (with the same widget API as a normal section).

---

## Widgets (Section Elements)

All widgets are created via a `section` object (from either a normal section or a multisection). Most widgets support `flag` and `callback`.

### Toggle
`section:toggle(cfg)`

**Config**
- `name` / `Name`: label.
- `state` / `State`: initial boolean.
- `risky` / `Risky`: `true` to use the “Risky Text” theme.
- `flag` / `Flag`: value stored in `library.flags`.
- `callback` / `Callback`: function called with boolean.
- `ignoreflag`: when `true`, the flag is excluded from config persistence.

**Returns**: `toggle` object with:
- `toggle:set(bool)`
- `toggle:colorpicker(cfg)` (see Color Picker)
- `toggle:keybind(cfg)` (see Keybind)

### Divider
`section:divider(cfg)`

**Config**
- `name` / `Name`: divider label (string).

### Slider (Single Value)
`section:slider(cfg)`

**Config**
- `name` / `Name`: label (optional).
- `min` / `minimum`: minimum numeric value.
- `max` / `maximum`: maximum numeric value.
- `default`: initial value (clamped to min/max).
- `suffix` / `Suffix`: appended to display text.
- `text`: display template, default `"[value]" .. suffix`.
- `float`: rounding step (default `1`).
- `flag`: stored value.
- `callback`: receives numeric value.
- `ignoreflag`: exclude from config persistence.

**Animated/Fading Slider**
- `animation`: when `true`, a `?` control appears allowing fade behavior.
- `fade_min`, `fade_max`: limits for the fade sliders.

**Fade Flags (only when `animation = true`)**
- `flag .. "_FADING"` (boolean on/off)
- `flag .. "_FADING_START"`
- `flag .. "_FADING_END"`
- `flag .. "_FADING_SPEED"`

### Slider (Range)
`section:slider({ range = true, ... })`

**Extra Config**
- `range = true`: enables min/max handles.
- `defaultMin`, `defaultMax`: initial range values.

**Value**
Returns a table `{minValue, maxValue}` in `library.flags[flag]`.

### Dropdown (Single Select)
`section:dropdown(cfg)`

**Config**
- `name` / `Name`: label (optional).
- `options` / `Options`: list of options.
- `default` / `Default`: selected option.
- `scrollable` / `Scrollable`: enable scrolling.
- `scrollingmax` / `ScrollingMax`: max visible rows when scrollable.
- `flag`: stored value.
- `callback`: receives selected option.

**Returns**: dropdown object with
- `set(option)`
- `refresh(options)`
- `add(option)`
- `remove(option)`

### List (Always-Open Dropdown)
`section:list(cfg)`

Same config as dropdown, but always open and forces `scrollable = true`.

**Returns**: list object with the same API as dropdown (`set`, `refresh`, `add`, `remove`).

### Multibox (Multi-Select Dropdown)
`section:multibox(cfg)`

**Config**
- `name` / `Name`: label (optional).
- `options` / `Options`: list of options.
- `default` / `Default`: list of selected options (optional).
- `max` / `Max`: max selections (if set, selection count is capped).
- `scrollable` / `Scrollable`
- `scrollingmax` / `ScrollingMax`
- `flag`: stored value (table of selections).
- `callback`: receives table of selections.

**Returns**: multibox object with
- `set(option)`
- `refresh(options)`
- `add(option)`
- `remove(option)`

### Button
`section:button(cfg)`

**Config**
- `name` / `Name`: label.
- `confirm` / `Confirm`: when `true`, requires a second click within a short countdown.
- `callback` / `Callback`: fired on click (or confirmed click).

**Returns**: `button_tbl` object that can create a second half-width button:

```
local btn = section:button({ name = "Primary", callback = function() end })
btn:button({ name = "Secondary", callback = function() end })
```

### Color Picker
`section:colorpicker(cfg)` or `toggle:colorpicker(cfg)`

**Config**
- `name` / `Name`: label (section only).
- `default` / `Default`: initial `Color3`.
- `alpha` / `Alpha`: initial alpha (0-1).
- `flag`: stored value.
- `callback`: receives `Color3` (with alpha embedded via `color.a`).
- `tooltip` / `ToolTip`: appears in config, but currently unused in UI.

**Returns**: color picker object with
- `set(color)`
- `new_colorpicker(cfg)` (section-only) to add additional inline color pickers.

**Animation Flags**
The color picker UI exposes animation modes with these flags:
- `flag .. "_RAINBOW"` (boolean)
- `flag .. "_RAINBOW_SPEED"` (number)
- `flag .. "_LERP"` (boolean)
- `flag .. "_LERP_SPEED"` (number)
- `flag .. "_LERP_START"` (Color3)
- `flag .. "_LERP_END"` (Color3)
- `flag .. "_FADE"` (boolean)
- `flag .. "_FADING_MIN"` (number 0-1)
- `flag .. "_FADING_MAX"` (number 0-1)
- `flag .. "_FADING_SPEED"` (number)

### Keybind
`section:keybind(cfg)` or `toggle:keybind(cfg)`

**Config**
- `name` / `Name`: label (section only).
- `default` / `Default`: initial bind (`Enum.KeyCode` or `Enum.UserInputType`).
- `mode` / `Mode`: `"Hold"`, `"Toggle"`, or `"Always"`.
- `blacklist` / `Blacklist`: list of disallowed keys.
- `flag`: stored boolean (`Hold`/`Toggle`) and `flag .. "_KEY"` holds the selected key.
- `flag .. "_MODE"`: current mode string (`"Hold"`, `"Toggle"`, `"Always"`).
- `callback`: invoked based on mode.

**Returns**: keybind object with
- `set(newKey)`

**Interactions**
- Left click: set the keybind.
- Right click: cycle the mode (`Hold` → `Toggle` → `Always` → `Hold`).

### Textbox
`section:textbox(cfg)`

**Config**
- `placeholder` / `Placeholder`: placeholder text.
- `default` / `Default`: starting text.
- `flag`: stored text value.
- `callback`: receives final text on commit.

**Returns**: textbox object with
- `Set(text)`

### Screen
`section:screen(cfg)`

A placeholder “screen” element that renders centered text.

**Config**
- `name` / `Name`: content text.

### Preview (ESP)
`section:preview(cfg)`

Creates a preview panel for ESP-style visuals.

**Config**
- `toggled`: initial enabled state.
- `main_color`: main health color.
- `empty_color`: empty health color.

**Returns**: preview object with
- `set_health(amount)`
- `set_health_colors(type, color)` where type is `"main"` or `"empty"`.
- `set_visibility(element, state)` where element is `"box"`, `"healthbar"`, `"name"`, `"distance"`, `"weapon"`.
- `set_color(element, state)` where element includes `"box"`, `"box outline"`, `"healthbar outline"`, `"name"`, `"name outline"`, `"distance"`, `"distance outline"`, `"weapon"`, `"weapon outline"`.

### Infographic
`section:infographic(cfg)`

Displays a text block with an icon.

**Config**
- `text` / `Text`: text content.
- `image` / `Image`: image data URI (defaults to a bundled image).

**Returns**: infographic object with
- `update(text)`
- `hide(bool)` (when `true`, shows a placeholder).

---

## Notes on Flags and Persistence

Some controls accept `ignoreflag = true` to exclude their flag from configuration serialization. This is useful for transient UI state.
