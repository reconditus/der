-- Minimal example using loadstring + remote library loader

local library = loadstring(request({
    Url = "https://raw.githubusercontent.com/reconditus/der/refs/heads/main/stable.lua",
    Method = "GET"
}).Body)()

local window = library:new({
    name = "Example",
    sub = "loadstring",
    size = Vector2.new(560, 420)
})

local page = window:page({ name = "Main", default = true })
local section = page:section({ name = "Basics", side = "left", size = "auto" })

section:toggle({
    name = "Enabled",
    flag = "example_enabled",
    state = true,
    callback = function(state)
        print("Enabled:", state)
    end
})

section:slider({
    name = "Volume",
    flag = "example_volume",
    min = 0,
    max = 100,
    default = 25,
    suffix = "%",
    callback = function(value)
        print("Volume:", value)
    end
})

section:button({
    name = "Notify",
    callback = function()
        library:notify({ title = "example", text = "Hello from loadstring example!", time = 4 })
    end
})

library:set_open(true)
