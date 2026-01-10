-- der/font_bootstrap.lua
-- Fake-drawing-style global font bootstrap

if not getgenv().DER_FONT_BOOTSTRAP then
    getgenv().DER_FONT_BOOTSTRAP = true

    if not game:IsLoaded() then
        game.Loaded:Wait()
    end

    assert(writefile and getcustomasset, "Missing executor filesystem APIs")

    local HttpService = game:GetService("HttpService")

    -- global hook (fake-drawing style)
    local derhook = {
        loaded = false
    }
    getgenv().derhook = derhook

    -- folders
    local ROOT = "der_cache"
    local FONT_DIR = ROOT .. "/fonts"

    local function ensure(path)
        if not isfolder(path) then
            makefolder(path)
        end
    end

    ensure(ROOT)
    ensure(FONT_DIR)

    -- executor version isolation
    local _, ver = (identifyexecutor and identifyexecutor()) or {"unknown", "unknown"}
    local verFile = ROOT .. "/version.txt"

    if not isfile(verFile) then
        writefile(verFile, tostring(ver))
    end

    if readfile(verFile) ~= tostring(ver) then
        if delfolder then
            delfolder(FONT_DIR)
        end
        ensure(FONT_DIR)
        writefile(verFile, tostring(ver))
    end

    -- font loader (same mechanism as fake-drawing)
    local Fonts = {}
    Fonts._registry = {}

    function Fonts.Append(name, ttfData)
        local base = FONT_DIR .. "/" .. name
        local ttfPath = base .. ".ttf"
        local jsonPath = base .. ".json"

        if not isfile(ttfPath) then
            writefile(ttfPath, ttfData)
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

    -- expose fonts globally
    derhook.Fonts = {}

    -- load fs-tahoma-8px.ttf
    local TTF_URL =
        "https://raw.githubusercontent.com/reconditus/fonts/main/fs-tahoma-8px.ttf"

    local ttfBytes = game:HttpGet(TTF_URL)

    derhook.Fonts.Tahoma8 =
        Fonts.Append("fs-tahoma-8px", ttfBytes)

    if Drawing and Drawing.RegisterFont then
        local ok, fontId = pcall(Drawing.RegisterFont, "Tahoma8", getcustomasset(FONT_DIR .. "/fs-tahoma-8px.ttf"))
        if ok then
            derhook.Fonts.Tahoma8Drawing = fontId
        end
    end

    derhook.loaded = true
end
