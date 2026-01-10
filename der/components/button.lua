-- der/components/button.lua

local Theme = require(script.Parent.Parent.core.theme)
local derhook = getgenv().derhook

assert(derhook and derhook.loaded, "Font bootstrap not loaded")

return function(props)
    local button = Instance.new("TextButton")
    button.AutoButtonColor = false
    button.TextXAlignment = Enum.TextXAlignment.Center
    button.TextYAlignment = Enum.TextYAlignment.Center

    button.FontFace = derhook.Fonts[Theme.Fonts.Body]
    button.TextSize = Theme.TextSize.Body
    button.TextColor3 = Theme.Colors.Text
    button.Text = props.Text or "Button"

    return button
end
