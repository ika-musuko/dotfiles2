local hyper = {"shift", "cmd"}

-- app launcher
do
    local APP_DIRS = {
        "/Applications",
        "/System/Applications",
        os.getenv("HOME") .. "/Applications",
    }

    -- chooser init
    local chooser = hs.chooser.new(
        function(choice)
            if not choice or not choice.app then return end
            hs.application.launchOrFocus(choice.app)
        end
    )

    -- chooser private
    do
        local function scanApps(query)
            local choices = {}
            local seen = {}

            for _, dir in ipairs(APP_DIRS) do

                repeat
                    local iter, dirObj = hs.fs.dir(dir)
                    if not iter then do break end end

                    for file in iter, dirObj do

                        repeat
                            if file == "."
                                or file == ".."
                                or file:sub(-4) ~= ".app"
                                or not string.find(string.lower(file), string.lower(query)) then
                                do break end
                            end

                            local name = file:sub(1, -5)
                            if seen[name] then do break end end

                            local appPath = dir .. "/" .. file
                            local icon = hs.image.iconForFile(appPath)

                            table.insert(choices, {
                                    text    = name,
                                    subText = dir,
                                    app     = name,
                                    image   = icon,
                                })

                            seen[name] = true
                        until true

                    end
                until true

            end

            table.sort(choices, function(a, b)
                return a.text:lower() < b.text:lower()
            end)

            return choices
        end

        chooser:queryChangedCallback(
            function(query)
                if query == nil or query == "" then
                    chooser:choices({})
                else
                    local appChoices = scanApps(query)
                    chooser:choices(appChoices)
                end
            end
        )
        chooser:rows(4)
        chooser:width(35)
        chooser:placeholderText("Applications")
    end

    -- keybinds
    function showAppChooser()
        local screenFrame = hs.screen.mainScreen():frame()
        local chooserWidth = screenFrame.w*(chooser:width() / 100)
        local x = screenFrame.x + (screenFrame.w - chooserWidth)/2
        local y = screenFrame.y + 300
        chooser:show(hs.geometry.point(x, y))
    end

    hs.hotkey.bind(hyper, "space", showAppChooser)
    local shortcuts = {
        d = "Calendar",
        f = "Finder",
        h = "Hammerspoon",
        j = "Vivaldi",
        k = "kitty",
        m = "Notes",
        s = "System Settings",
    }

    for key, app in pairs(shortcuts) do
        hs.hotkey.bind(
            hyper, key,
            function()
                local ok = hs.application.launchOrFocus(app)
                if ok then return end
                if app  == "System Settings" then
                    hs.application.launchOrFocus("System Preferences")
                end
            end
        )
    end
end
