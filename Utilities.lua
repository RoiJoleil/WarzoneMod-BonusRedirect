RedirectToEnum = {
	AllOthers 		= 'All Others',
	AllOpponents 	= 'All Opponents',
	AllTeammates 	= 'All Teammates',
	OneOpponent 	= 'One Opponent',
	OneTeammate 	= 'One Teammate'
}

RedirectFromEnum = {
	All 		= 'All Bonuses',
	Positive 	= 'Positive Bonuses',
	Negative 	= 'Negative Bonuses'
}

function UpdateIncomeOrder(addNewOrder, playerID, income)
    local incomeMod = WL.IncomeMod.Create(
        playerID,
        income,
        "BonusRedirect: Updated income",
        nil
    )

    local order = WL.GameOrderEvent.Create(
        playerID,-- playerID
        "BonusRedirect: Updated income",-- message
        nil,        	-- visibleToOpt (nil = visible to everyone)
        nil,        	-- terrModsOpt
        nil,        	-- setResourcesOpt
        { incomeMod }   -- incomeModsOpt, array wrapping the single IncomeMod
    )

    addNewOrder(order)
end