-- der/components/label.lua

local Theme = require(script.Parent.Parent.core.theme)
local Fonts = require(script.Parent.Parent.core.fonts)

return function(props)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center

    label.FontFace = Fonts.get(Theme.Fonts.Body)
    label.TextSize = Theme.TextSize.Body
    label.TextColor3 = Theme.Colors.Text
    label.Text = props.Text or ""

    return label
end
