local hyper = {"shift", "cmd"}


-- reset existing keybinds
for _, hotkey in pairs(hs.hotkey.getHotkeys()) do
    hotkey:delete()
end

-- quick app open shortcuts
do
    local shortcuts = {
        f = "finder",
        j = "vivaldi",
        k = "kitty",
        m = "chromium",
        [","] = "System Settings",
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
