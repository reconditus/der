-- der/core/fonts.lua
-- Executor-based FontFace loader (TTF, no PNG)

local HttpService = game:GetService("HttpService")

local Fonts = {}
Fonts._registry = {}

-- executor API requirements
assert(writefile and isfile and isfolder and makefolder and getcustomasset,
    "Executor filesystem APIs missing")

local ROOT = "der_cache"
local FONT_DIR = ROOT .. "/fonts"

local function ensure(path)
    if not isfolder(path) then
        makefolder(path)
    end
end

ensure(ROOT)
ensure(FONT_DIR)

local function loadTTF(name, ttfBytes)
    local base = FONT_DIR .. "/" .. name
    local ttfPath = base .. ".ttf"
    local jsonPath = base .. ".json"

    if not isfile(ttfPath) then
        writefile(ttfPath, ttfBytes)
    end

    local manifest = {
        name = name,
        faces = {{
            name = "Regular",
            style = "normal",
            weight = 400,
            assetId = getcustomasset(ttfPath),
        }}
    }

    writefile(jsonPath, HttpService:JSONEncode(manifest))

    return Font.new(
        getcustomasset(jsonPath),
        Enum.FontWeight.Regular,
        Enum.FontStyle.Normal
    )
end

function Fonts.register(name, url)
    if Fonts._registry[name] then
        return Fonts._registry[name]
    end

    local bytes = game:HttpGet(url)
    local font = loadTTF(name, bytes)
    Fonts._registry[name] = font
    return font
end

function Fonts.get(name)
    return Fonts._registry[name]
        or Font.new("SourceSansPro", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
end

return Fonts
