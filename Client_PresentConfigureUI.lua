require("Utilities")


function SetRedirectTo(value)
	ModSettingRedirectTo = value
end

function SetRedirectFrom(value)
	ModSettingRedirectFrom = value
end

function SetRedirectSelf(isChecked)
	ModSettingRedirectSelf = isChecked
end


function Client_PresentConfigureUI(rootParent)
    ModSettingRedirectTo = Mod.Settings.RedirectTo
    ModSettingRedirectFrom = Mod.Settings.RedirectFrom
    ModSettingRedirectSelf = Mod.Settings.RedirectSelf

	if ModSettingRedirectTo == nil then
		ModSettingRedirectTo = RedirectToEnum.AllOpponents
	end

	if ModSettingRedirectFrom == nil then
		ModSettingRedirectFrom = RedirectFromEnum.Negative
	end

	if ModSettingRedirectSelf == nil then
		ModSettingRedirectSelf = false
	end

	local rootVert 	= UI.CreateVerticalLayoutGroup(rootParent);

	
	local vert2 	= UI.CreateVerticalLayoutGroup(rootVert);
	UI.CreateLabel(vert2)
		.SetText('When a player holds a bonus, its income is redirect away from them and towards the target group. Choose which bonuses are affected by this mod:')
	local group2 	= UI.CreateRadioButtonGroup(vert2);
	UI.CreateRadioButton(vert2)
		.SetGroup(group2)
		.SetText('All bonuses')
		.SetIsChecked(ModSettingRedirectFrom == RedirectFromEnum.All)
		.SetOnValueChanged(function(isChecked) SetRedirectFrom(RedirectFromEnum.All) end);
	UI.CreateRadioButton(vert2)
		.SetGroup(group2)
		.SetText('Positive bonuses only')
		.SetIsChecked(ModSettingRedirectFrom == RedirectFromEnum.Positive)
		.SetOnValueChanged(function(isChecked) SetRedirectFrom(RedirectFromEnum.Positive) end);
	UI.CreateRadioButton(vert2)
		.SetGroup(group2)
		.SetText('Negative bonuses only')
		.SetIsChecked(ModSettingRedirectFrom == RedirectFromEnum.Negative)
		.SetOnValueChanged(function(isChecked) SetRedirectFrom(RedirectFromEnum.Negative) end);


	local vert1 	= UI.CreateVerticalLayoutGroup(rootVert);
	UI.CreateLabel(vert1)
		.SetText('Choose who receives the redirected income. The holder loses the bonus value, and it is redistributed to everyone in the selected group.')
	local group1 	= UI.CreateRadioButtonGroup(vert1);
	UI.CreateRadioButton(vert1)
		.SetGroup(group1)
		.SetText('All other players')
		.SetIsChecked(ModSettingRedirectTo == RedirectToEnum.AllOthers)
		.SetOnValueChanged(function(isChecked) SetRedirectTo(RedirectToEnum.AllOthers) end);
	UI.CreateRadioButton(vert1)
		.SetGroup(group1)
		.SetText('All opponents')
		.SetIsChecked(ModSettingRedirectTo == RedirectToEnum.AllOpponents)
		.SetOnValueChanged(function(isChecked) SetRedirectTo(RedirectToEnum.AllOpponents) end);
	UI.CreateRadioButton(vert1)
		.SetGroup(group1)
		.SetText('All teammates')
		.SetIsChecked(ModSettingRedirectTo == RedirectToEnum.AllTeammates)
		.SetOnValueChanged(function(isChecked) SetRedirectTo(RedirectToEnum.AllTeammates) end);
	UI.CreateRadioButton(vert1)
		.SetGroup(group1)
		.SetText('[WIP] One opponent')
		.SetIsChecked(ModSettingRedirectTo == RedirectToEnum.OneOpponent)
		.SetInteractable(flase)
		.SetOnValueChanged(function(isChecked) SetRedirectTo(RedirectToEnum.OneOpponent) end);
	UI.CreateRadioButton(vert1)
		.SetGroup(group1)
		.SetText('[WIP] One teammate')
		.SetIsChecked(ModSettingRedirectTo == RedirectToEnum.OneTeammate)
		.SetInteractable(flase)
		.SetOnValueChanged(function(isChecked) SetRedirectTo(RedirectToEnum.OneTeammate) end);


	local vert3 	= UI.CreateVerticalLayoutGroup(rootVert);
	UI.CreateLabel(vert3)
		.SetText('By default, the holder receives nothing from their own bonuses. Enable this to also redirect the bonus income back to the holder themselves, in addition to the target group.')
	UI.CreateCheckBox(vert3)
		.SetText('Include self')
		.SetIsChecked(ModSettingRedirectSelf)
		.SetOnValueChanged(function(isChecked) SetRedirectSelf(isChecked) end);


end