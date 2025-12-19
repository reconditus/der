# stable.luau Elements & Editable Areas

This document lists the UI elements inside `stable.luau` and highlights what you
can safely change in the library source itself (colors, sizes, behavior hooks,
and defaults).

## Where Elements Live

All UI elements are defined inside `stable.luau` under the `library:new` window
builder, specifically in the `page:section` element factory. Search for:

- `function library:new(cfg)`
- `function page:section(cfg)`
- `function section:<element>(cfg)`

These functions define the building blocks and how they render.

## Global Editable Areas

### Themes
Defined near the top of `stable.luau`:

```lua
local themes = {
    ["Default"] = {
        ["Accent"] = Color3.fromRGB(117, 163, 125);
        ["Un-Selected"] = Color3.fromRGB(55,55,55);
        ["Un-Selected_Text"] = Color3.fromRGB(118,118,118);
        ["Text"] = Color3.fromRGB(175,175,175);
        ["Risky Text"] = Color3.fromRGB(227, 206, 20);
        ["Toggle Background"] = Color3.fromRGB(77, 77, 77);
        ["Toggle Background Highlight"] = Color3.fromRGB(88,88,88);
    };
}
```

**Safe changes:**
- Update any theme colors to change the overall UI style.
- Add new theme keys and use them in `library:create(... Theme = "...")`.

### Sizes and Spacing Defaults
Many widget sizes are defined in their creation calls:

- `Size = UDim2.new(1, 0, 0, 6)` for small rows
- `Size = UDim2.new(1, -50, 0, 15)` for dropdown/list controls
- `AddListLayout(9)` spacing inside section content

**Safe changes:**
- Adjust `Size` values to change widget height/width.
- Adjust `AddListLayout` padding values to control spacing.

### Window Layout
In `library:new(cfg)`:

- Window size (`size` default)
- Holder padding (top bar, page bar, body)
- Accent bar size

**Safe changes:**
- Modify base sizes, padding, and position values to reshape the window.

## Elements (What You Can Customize)

Each element is created in `function section:<element>(cfg)`.

### Toggle
- Look for: `function section:toggle(cfg)`
- Visual parts: `toggle_frame`, `toggle_title`, gradient

**Editable:**
- Default colors and highlight colors
- Toggle size (`Size = UDim2.new(0,6,0,6)`)
- Text position (`Position = UDim2.new(0,20,0,-5)`)

### Divider
- Look for: `function section:divider(cfg)`

**Editable:**
- Divider line color, thickness, and text style
- Offset logic for named/unnamed dividers

### Slider
- Look for: `function section:slider(cfg)`

**Editable:**
- Frame height and value label position
- Tween timing (default `0.1` seconds)
- Suffix text and rounding (`float` step)

### Dropdown
- Look for: `function section:dropdown(cfg)`

**Editable:**
- Dropdown row height
- Hover highlight color
- Icon text (default `-`)
- Scrollbar width/size

### List
- Look for: `function section:list(cfg)`

**Editable:**
- Row height (default `16`)
- Scrollbar size and colors

### Multibox
- Look for: `function section:multibox(cfg)`

**Editable:**
- Multi-select text concatenation logic
- Max selection behavior
- Highlight color for chosen entries

### Button
- Look for: `function section:button(cfg)`

**Editable:**
- Button size (`Size = UDim2.new(1, -50, 0, 17)`)
- Hover colors
- Confirmation logic text and countdown timing

### Color Picker
- Look for: `function section:colorpicker(cfg)`
- Inner components are built in:
  - `library.object_colorpicker(...)`
  - `library.object_colorpicker_inner(...)`

**Editable:**
- Window size (default `UDim2.new(0, 206, 0, 200)`)
- Saturation/hue/alpha frame sizes
- RGB display formatting

### Keybind
- Look for: `function section:keybind(cfg)`

**Editable:**
- Key text styling
- Default key display and placeholder
- Mode behavior: `Hold`, `Toggle`, `Always`

### Textbox
- Look for: `function section:textbox(cfg)`

**Editable:**
- Placeholder styling
- Text alignment (`middle` option)
- Input filtering / allowed characters

### Screen (Placeholder)
- Look for: `function section:screen(cfg)`

**Editable:**
- Placeholder text
- Positioning and sizing

### Preview
- Look for: `function section:preview(cfg)`

**Editable:**
- Toggle interaction and preview content
- Preview layout size

### Infographic
- Look for: `function section:infographic(cfg)`

**Editable:**
- Text formatting and layout
- Image size and positioning

## Extra UI Objects

### Watermark
- Built by `library:createwatermark()`.

**Editable:**
- Title text, domain text, and line animation
- Refresh rate and dynamic text (FPS, ping, etc.)

### Notifications
- Built by `library:notify(...)` (search for notification creation logic).

**Editable:**
- Position, color, and animation timings

**Common fields:**
- `title` (string): optional header text.
- `text` (string): main notification body.
- `time` (number): duration in seconds.

## Behavior Hooks You Can Change

- **Open/close animation** in `library:set_open(bool)`.
  - Change tween duration, easing style, or off-screen positions.
- **Cursor rendering** in the `RunService.RenderStepped` connection near the
  `cursor1`/`cursor2` creation.
- **Drag behavior** in `utility.dragify`.

## Safe vs Risky Changes

**Safe:**
- Colors, sizes, positions, text formatting
- Default values and theme mappings
- Animation durations

**Risky:**
- Renaming flags or element function names
- Removing required `library.flags` updates
- Removing `library:connect` usage for inputs

If you need to add a new element type, copy an existing `section:*` function,
then register it inside `page:section` and keep the same pattern of creating a
holder + registering a `flags[flag]` setter.
