# stable.luau UI Library Guide

This guide describes how to build UI with `stable.luau`, including windows, pages,
sections, and the available elements. All examples assume you have already loaded
and executed `stable.luau` to get the `library` table.

```lua
local library = loadstring(request({
    Url = "https://raw.githubusercontent.com/reconditus/der/refs/heads/main/stable.lua",
    Method = "GET"
}).Body)()
```

## Core Concepts

### Flags
Most elements accept a `flag` in their config. The library stores the current value
in `library.flags[flag]`. If you don’t provide a flag, the library auto-generates one.

### Callbacks
Most elements accept `callback = function(value) ... end`. The callback fires when
that element changes.

### Theme
You can adjust theme colors with:

```lua
library:change_theme_color("Accent", Color3.fromRGB(255, 100, 100))
```

## Creating a Window

```lua
local window = library:new({
    name = "My Menu", -- primary title
    sub = "demo",     -- accent title
    size = Vector2.new(600, 520)
})
```

The returned `window` is the root container used to add pages and specialized
utilities like `player_list` and `server_list` (if you need them).

## Pages

```lua
local page = window:page({
    name = "Main",
    default = true -- show this page first
})
```

## Sections

Sections live on either the left or right column of a page.

```lua
local section = page:section({
    name = "Controls",
    side = "left", -- "left" or "right"
    size = "auto" -- or a fixed height number/string
})
```

Use `size = "auto"` to make the section grow with content.

## Elements (Widgets)

Below are the standard section widgets with their common options and example usage.

### Toggle

```lua
section:toggle({
    name = "Enable Feature",
    flag = "feature_enabled",
    state = true, -- initial state
    callback = function(state)
        print("Toggle:", state)
    end
})
```

Optional add-ons for toggles:

- **Color picker** attached to a toggle:
  ```lua
  local toggle = section:toggle({ name = "Glow", flag = "glow_enabled" })
  toggle:colorpicker({
      flag = "glow_color",
      default = Color3.fromRGB(255, 0, 0),
      callback = function(color) print(color) end
  })
  ```

- **Keybind** attached to a toggle:
  ```lua
  local toggle = section:toggle({ name = "Aim", flag = "aim_enabled" })
  toggle:keybind({
      flag = "aim_key",
      default = Enum.KeyCode.E,
      mode = "Hold", -- Hold / Toggle / Always
      callback = function(active) print("Keybind:", active) end
  })
  ```

### Divider

```lua
section:divider({ name = "Group Title" })
```

### Slider

```lua
section:slider({
    name = "Speed",
    flag = "speed",
    min = 0,
    max = 100,
    default = 50,
    suffix = "%",
    float = 1, -- step size
    callback = function(value)
        print("Slider:", value)
    end
})
```

Optional slider features:

- **Range slider** (two handles):
  ```lua
  section:slider({
      name = "FOV Range",
      flag = "fov_range",
      min = 0,
      max = 120,
      range = true,
      defaultMin = 20,
      defaultMax = 80,
      callback = function(values)
          print(values[1], values[2])
      end
  })
  ```

- **Animated slider** (`animation = true`): provides extra controls like
  fading, rainbow, and lerp options in the UI.

### Dropdown

```lua
section:dropdown({
    name = "Mode",
    flag = "mode",
    options = { "Balanced", "Stealth", "Loud" },
    default = "Balanced",
    scrollable = false,
    scrollingmax = 10,
    callback = function(value)
        print("Dropdown:", value)
    end
})
```

### List

```lua
section:list({
    name = "Targets",
    flag = "target",
    options = { "Alpha", "Bravo", "Charlie" },
    default = "Alpha",
    scrollable = true,
    scrollingmax = 6,
    callback = function(value)
        print("List:", value)
    end
})
```

### Multibox (Multi-select)

```lua
section:multibox({
    name = "Options",
    flag = "multi_options",
    options = { "A", "B", "C", "D" },
    max = 3,
    default = { "A", "C" },
    scrollable = true,
    scrollingmax = 6,
    callback = function(values)
        print(table.concat(values, ", "))
    end
})
```

### Button

```lua
section:button({
    name = "Run Action",
    confirm = false, -- true to require a confirmation click
    callback = function()
        print("Button clicked")
    end
})
```

### Color Picker

```lua
section:colorpicker({
    name = "Accent",
    flag = "accent_color",
    default = Color3.fromRGB(117, 163, 125),
    alpha = 1, -- 0 to 1
    callback = function(color)
        print("Color:", color)
    end
})
```

### Keybind

```lua
section:keybind({
    name = "Menu Toggle",
    flag = "menu_key",
    default = Enum.KeyCode.RightShift,
    mode = "Toggle", -- Hold / Toggle / Always
    callback = function(state)
        print("Keybind state:", state)
    end
})
```

### Textbox

```lua
section:textbox({
    name = "Username",
    flag = "username",
    default = "",
    placeholder = "Enter name...",
    middle = true,
    callback = function(text)
        print("Textbox:", text)
    end
})
```

### Screen (Empty Placeholder)

```lua
section:screen({
    name = "No data available"
})
```

### Preview

```lua
section:preview({
    name = "Preview",
    flag = "preview",
    callback = function(state)
        print("Preview toggled:", state)
    end
})
```

### Infographic

```lua
section:infographic({
    info = "uid 1234\nexpires in: 9y, 9m",
    image = "rbxassetid://1234567890"
})
```

## Window Utilities

### Open/Close the menu

```lua
library:set_open(true) -- open
library:set_open(false) -- close
```

### Toggle with a key

```lua
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        library:set_open(not library.open)
    end
end)
```

## Notifications

Use `library:notify` to show temporary toast notifications.

```lua
library:notify({
    title = "dreya",
    text = "Settings saved successfully.",
    time = 5
})
```

**Common fields:**
- `title` (string): optional header text.
- `text` (string): main notification body.
- `time` (number): duration in seconds.

## Notes & Tips

- **Flags** are the primary way to access current values across your script.
- **Auto flags** are generated if you don’t supply one, but explicit flags are
  easier to track and save/load.
- **Saving configs** uses `library:get_config()` and `library:load_config(path)`.
- **Theme updates** propagate automatically to objects tagged with theme entries.
