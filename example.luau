        local refresh_frame = library:create("Square", { Filled = true, Visible = true, Thickness = 0, Color = Color3.fromRGB(24, 24, 30), Transparency = 0.2, Size = UDim2.new(0,60,0,17), Position = UDim2.new(0, 85, 0, 250), ZIndex = 14, Parent = list_holder }) do
            local outline = library:outline(refresh_frame, Color3.fromRGB(48, 48, 60), 14); library:outline(outline, Color3.new(0,0,0), 14);
            library:create("Text", {Text = "refresh", Transparency = 1, Visible = true, Parent = refresh_frame, Theme = "Text", ZIndex = 16, Center = true, Position = UDim2.new(0.5, 0, 0, 1), Font = 2, Size = 13, Outline = true});

            refresh_frame.MouseLeave:Connect(function() refresh_frame.Color = Color3.fromRGB(24, 24, 30) end)
            refresh_frame.MouseEnter:Connect(function() refresh_frame.Color = Color3.fromRGB(34, 34, 42) end)
            refresh_frame.MouseButton1Click:Connect(function()
                serverlist:refresh(game:GetService('HttpService'):JSONDecode(game:HttpGet(('https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100'):format(game.PlaceId))).data, false)
                sort_text.Text = 'players ascending'
            end)
        end

        local textbox_frame = library:create("Square", { ZIndex = 14, Transparency = 0.2, Size = UDim2.new(0,90,0,17),Parent = list_holder, Thickness = 1, Position = UDim2.new(0, 386, 0, 150)}) do
            local textbox = library:create("Square", { Filled = true, Visible = true, Thickness = 0, Color = Color3.fromRGB(24, 24, 30), Size = UDim2.new(1, 0, 1, 0), ZIndex = 14, Parent = textbox_frame })

            textbox_frame.MouseEnter:Connect(function() textbox.Color = Color3.fromRGB(22,22,22) end)
            textbox_frame.MouseLeave:Connect(function() textbox.Color = Color3.fromRGB(24, 24, 30) end)

            local outline = library:outline(textbox, Color3.fromRGB(48, 48, 60), 14); library:outline(outline, Color3.new(0,0,0), 14);

            local text = library:create("Text", {Text = '', Transparency = 1, Visible = true, Parent = textbox, Theme = "Text", ZIndex = 14, Center = true, Position = UDim2.new(0.5, 0, 0, 1), Font = 2, Size = 13, Outline = true});
            local placeholder = library:create("Text", {Text = 'username or id', Transparency = 1, Visible = true, Parent = textbox, Theme = "Un-Selected_Text", ZIndex = 14, Center = true, Position = UDim2.new(0.5, 0, 0, 1), Font = 2, Size = 13, Outline = true});

            library.object_textbox(textbox, text,  function(str)
                if str == "" then
                    placeholder.Visible = true
                    text.Visible = false
                else
                    placeholder.Visible = false
                    text.Visible = true
                end
            end, function(str)
                library.flags['player username'] = str
                local s, id = pcall(function()
                    return game:GetService('Players'):GetUserIdFromNameAsync(str)
                end)
                if s then
                    local s, response = utility.request('https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=' .. id .. '&format=Png&size=150x150&isCircular=false')
                    if s then
                        player_image.Data = game:HttpGet(response.data[1].imageUrl)
                    else
                        player_image.Data = ''
                    end
                end
            end)

            local function set(str)
                text.Visible = str ~= ""
                placeholder.Visible = str == "";
                text.Text = str
                library.flags['player username'] = str
            end

            set('')
        end
        local button3 = library:create("Square", { Filled = true, Visible = true, Thickness = 0, Color = Color3.fromRGB(24, 24, 30), Transparency = 0.2, Size = UDim2.new(0,90,0,17), Position = UDim2.new(0, 386, 0, 172), ZIndex = 14, Parent = list_holder }) do
            local threads, searching = 30, false
            local outline = library:outline(button3, Color3.fromRGB(48, 48, 60), 14); library:outline(outline, Color3.new(0,0,0), 14);
            local text = library:create("Text", {Text = "scan", Transparency = 1, Visible = true, Parent = button3, Theme = "Text", ZIndex = 16, Center = true, Position = UDim2.new(0.5, 0, 0, 1), Font = 2, Size = 13, Outline = true});

            button3.MouseLeave:Connect(function() button3.Color = Color3.fromRGB(24, 24, 30) end)
            button3.MouseEnter:Connect(function() button3.Color = Color3.fromRGB(34, 34, 42) end)
            button3.MouseButton1Click:Connect(function()
                task.spawn(function()
                    if clicked_join then
                        clicked_join = false
                        counting_join = false
                        library:change_object_theme(text, "Text")
                        text.Text = 'scan'
                        --
                        do
                            if searching then
                                library:notify({ text = 'a scan is already in progress. hold on' })
                                return
                            end
                            searching = true
                            local playerFound = false
                            local s, user, id = pcall(function()
                                local userId = game:GetService('Players'):GetUserIdFromNameAsync(library.flags['player username'])
                                local username = game:GetService('Players'):GetNameFromUserIdAsync(userId)
                                return username, userId
                            end)

                            if not s then
                                library:notify({ text = 'invalid user' })
                                searching = false
                                return
                            end

                            local s, response = utility.request('https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=' .. id .. '&format=Png&size=150x150&isCircular=false')
                            if not s or not response.data then
                                library:notify({ text = 'unable to fetch player thumbnail' })
                                searching = false
                                return
                            end

                            local thumbnail = response.data[1].imageUrl
                            local placeId = game.PlaceId
                            local cursor, scanned, maxSearchs = nil, 0, 0

                            library:notify({ text = 'scanning servers for user \'' .. user .. '\''})
                            while searching do
                                local success, result = utility.fetchservers(placeId)
                                if not success or not result.data then
                                    library:notify({ text = result.data })
                                    searching = false
                                    return
                                end

                                local servers = result.data
                                cursor = result.nextPageCursor
                                maxSearchs = maxSearchs + #servers

                                for index, server in ipairs(servers) do
                                    local function scan()
                                        local s, thumbs = utility.fetchthumbs(server.playerTokens)
                                        if s and thumbs then
                                            for _, playerThumb in ipairs(thumbs) do
                                                if playerThumb.imageUrl == thumbnail then
                                                    playerFound, searching = true, false
                                                    library:notify({ text = ('teleporting you to \'%s-XXXX...\''):format(string.sub(server.id, 0, 8)) }); task.wait(1)
                                                    utility.tp(placeId, server.id)
                                                    game:GetService('Players').LocalPlayer.OnTeleport:Connect(function(state)
                                                        if state == Enum.TeleportState.Failed then
                                                            library:notify({ text = 'teleport failed'} )
                                                        end
                                                    end)
                                                    break
                                                end
                                            end
                                        end
                                    end
                                    scanned = scanned + 1
                                    if index % threads ~= 0 then task.spawn(scan); task.wait() else
                                        scan()
                                    end
                                end

                                if not cursor then
                                    break
                                end
                            end

                            if searching and not playerFound then task.wait(2)
                                library:notify({ text = 'unable to find \'' .. user .. '\'' })
                            end
                            searching = false
                        end
                        --
                    else
                        clicked_join = true
                        counting_join = true
                        for i = 3,1,-1 do
                            if not counting_join then
                                break
                            end
                            text.Text = 'confirm? '..tostring(i)
                            library:change_object_theme(text, "Accent")
                            wait(1)
                        end
                        clicked_join = false
                        counting_join = false
                        library:change_object_theme(text, "Text")
                        text.Text = 'scan'
                    end
                end);
            end)
        end

        local currentserv_text = library:create("Text", {Text = "current server", Transparency = 0.6, Visible = true, Parent = list_holder, Theme = "Text", ZIndex = 16, Center = true, Position = UDim2.new(0, 432, 0, 230), Font = 2, Size = 13, Outline = true});

        local button1 = library:create("Square", { Filled = true, Visible = true, Thickness = 0, Color = Color3.fromRGB(24, 24, 30), Size = UDim2.new(0,40,0,17), Position = UDim2.new(0, 386, 0, 250), ZIndex = 14, Parent = list_holder }) do
            local outline = library:outline(button1, Color3.fromRGB(48, 48, 60), 14); library:outline(outline, Color3.new(0,0,0), 14);
            local text = library:create("Text", {Text = "rejoin", Transparency = 1, Visible = true, Parent = button1, Theme = "Text", ZIndex = 16, Center = true, Position = UDim2.new(0.5, 0, 0, 1), Font = 2, Size = 13, Outline = true});

            button1.MouseLeave:Connect(function() button1.Color = Color3.fromRGB(24, 24, 30) end)
            button1.MouseEnter:Connect(function() button1.Color = Color3.fromRGB(34, 34, 42) end)
            button1.MouseButton1Click:Connect(function()
                task.spawn(function()
                    if clicked_join then
                        clicked_join = false
                        counting_join = false
                        library:change_object_theme(text, "Text")
                        text.Text = 'rejoin'
                        --
                        library:notify({ text = ('rejoining \'%s-XXXX-XXXX-XXXX-XXXXXXXXXXXX\''):format(string.sub(game.JobId, 0, 8)), time = 7 })
                        utility.tp(game.PlaceId, game.JobId);
                        --
                    else
                        clicked_join = true
                        counting_join = true
                        for i = 3,1,-1 do
                            if not counting_join then
                                break
                            end
                            text.Text = tostring(i)
                            library:change_object_theme(text, "Accent")
                            wait(1)
                        end
                        clicked_join = false
                        counting_join = false
                        library:change_object_theme(text, "Text")
                        text.Text = 'rejoin'
                    end
                end);
            end)
        end

