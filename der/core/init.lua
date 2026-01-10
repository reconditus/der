-- der/core/init.lua

local Fonts = require(script.fonts)

-- Register fs-tahoma-8px
Fonts.register(
    "Tahoma8",
    "https://raw.githubusercontent.com/reconditus/fonts/main/fs-tahoma-8px.ttf"
)

return {
    Fonts = Fonts
}
