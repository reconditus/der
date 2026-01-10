-- der/components/label.lua

local Theme = require(script.Parent.Parent.core.theme)
local derhook = getgenv().derhook

assert(derhook and derhook.loaded, "Font bootstrap not loaded")

return function(props)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center

    label.FontFace = derhook.Fonts[Theme.Fonts.Body]
    label.TextSize = Theme.TextSize.Body
    label.TextColor3 = Theme.Colors.Text
    label.Text = props.Text or ""

    return label
end
