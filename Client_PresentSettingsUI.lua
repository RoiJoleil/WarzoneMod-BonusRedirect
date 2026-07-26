function Client_PresentSettingsUI(rootParent)
	UI.CreateLabel(rootParent)
		.SetText("Will redirect from " .. Mod.Settings.RedirectFrom .. " bonuses.");
	UI.CreateLabel(rootParent)
		.SetText("Will redirect relative of the holder to " .. Mod.Settings.RedirectTo);
end

