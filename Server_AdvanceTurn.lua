require("Utilities")

function buildBonusOwnerTable(territoryOwnerTable, bonuses)
	-- table: { bonusID = playerID }
	local bonusOwnerTable = {}
	
	-- Figure out who owns what bonuses ------------------
	for bonusID, bonusDetails in pairs(bonuses) do
		local bonusOwnerID = nil
		for _, territoryID in ipairs(bonusDetails.Territories) do
			-- If bonusOwnerID hasnt been set yet, set it to the owner of the first territory.
			if bonusOwnerID == nil then
				bonusOwnerID = territoryOwnerTable[territoryID]
				-- If bonuseOwner is neutral, break
				if bonusOwnerID == 0 then
					bonusOwnerID = nil
					break
				end
			
			-- If previous bonusOwnerID doesnt match new bonusOwnerID, set bonusOwnerID to neutral and break
			elseif bonusOwnerID ~= territoryOwnerTable[territoryID] then
				bonusOwnerID = nil
				break
			end
		end

		-- Set owner of the bonusID
		bonusOwnerTable[bonusID] = bonusOwnerID
	end

	return bonusOwnerTable
end

function buildPlayerIncomeBonusTable(bonusOwnerTable, bonuses, overriddenBonuses)
	-- table: { playerID = income }
	local playerIncomeFromBonusesTable = {}

	-- Track how much income every player gets from bonuses ------------------
	for bonusID, playerID in pairs(bonusOwnerTable) do
		-- check if player already exists, if not add it
		if playerIncomeFromBonusesTable[playerID] == nil then
			playerIncomeFromBonusesTable[playerID] = 0
		end

		local value = bonuses[bonusID].Amount
		if overriddenBonuses[bonusID] then
			value = overriddenBonuses[bonusID]
		end

		-- add bonus value to their income
		if Mod.Settings.RedirectFrom == RedirectFromEnum.All then
			playerIncomeFromBonusesTable[playerID] = playerIncomeFromBonusesTable[playerID] + value

		-- add bonus value to their income
		elseif Mod.Settings.RedirectFrom == RedirectFromEnum.Positive then
			if value > 0 then
				playerIncomeFromBonusesTable[playerID] = playerIncomeFromBonusesTable[playerID] + value
			end

		-- add bonus value to their income
		elseif Mod.Settings.RedirectFrom == RedirectFromEnum.Negative then
			if value < 0 then
				playerIncomeFromBonusesTable[playerID] = playerIncomeFromBonusesTable[playerID] + value
			end
		end
	end

	for playerID, income in pairs(playerIncomeFromBonusesTable) do
		print("Player " .. playerID .. " gets " .. income .. " income from bonuses.")
	end

	return playerIncomeFromBonusesTable
end

function redirectBonusIncome(playerIncomeFromBonusesTable, players, addNewOrder)
	-- Reduce Income ------------------
	-- table: { playerID = amount }
	local playerIncomeModification = {}

	-- Add hostPlayerID to the IncomeModification list,
	for playerID, _ in pairs(players) do
		playerIncomeModification[playerID] = 0
	end

	for hostPlayerID, income in pairs(playerIncomeFromBonusesTable) do
		
		-- Update income from the host controlling the bonus
		if not Mod.Settings.RedirectSelf then
			playerIncomeModification[hostPlayerID] = playerIncomeModification[hostPlayerID] - income
		end

		-- Update income from all other players
		if Mod.Settings.RedirectTo == RedirectToEnum.AllOthers then
			for otherPlayerID, _ in pairs(players) do
				if hostPlayerID ~= otherPlayerID then
					playerIncomeModification[otherPlayerID] = playerIncomeModification[otherPlayerID] + income
				end
			end

		-- Update income from all opponent players
		elseif Mod.Settings.RedirectTo == RedirectToEnum.AllOpponents then
			for otherPlayerID, _ in pairs(players) do
				if players[hostPlayerID].Team ~= players[otherPlayerID].Team or players[hostPlayerID].Team == -1 and hostPlayerID ~= otherPlayerID then
					playerIncomeModification[otherPlayerID] = playerIncomeModification[otherPlayerID] + income
				end
			end

		-- Update income from all teammate players
		elseif Mod.Settings.RedirectTo == RedirectToEnum.AllTeammates then
			for otherPlayerID, _ in pairs(players) do
				if players[hostPlayerID].Team == players[otherPlayerID].Team and hostPlayerID ~= otherPlayerID then
					playerIncomeModification[otherPlayerID] = playerIncomeModification[otherPlayerID] + income
				end
			end

		-- Update income from one opponent player
		elseif Mod.Settings.RedirectTo == RedirectToEnum.OneOpponent then
			for otherPlayerID, _ in pairs(players) do
				if hostPlayerID ~= otherPlayerID then
					playerIncomeModification[otherPlayerID] = playerIncomeModification[otherPlayerID] + income
				end
			end

		-- Update income from one teammate player
		elseif Mod.Settings.RedirectTo == RedirectToEnum.OneTeammate then
			for otherPlayerID, _ in pairs(players) do
				if hostPlayerID ~= otherPlayerID then
					playerIncomeModification[otherPlayerID] = playerIncomeModification[otherPlayerID] + income
				end
			end
		end
	end

	-- Actually apply the income changes to the game
	for hostPlayerID, amount in pairs(playerIncomeModification) do
		UpdateIncomeOrder(addNewOrder, hostPlayerID, amount)
	end
end


function Server_AdvanceTurn_End(game, addNewOrder)
	local turnNumber = game.ServerGame.Game.TurnNumber
	print("----- Turn " .. turnNumber .. " finished.")

	local players = game.ServerGame.Game.PlayingPlayers
	local bonuses = game.Map.Bonuses
	local overriddenBonuses = game.Settings.OverriddenBonuses

	-- table: { territoryID = playerID }
	local territoryOwnerTable = {}

	for key, territoryStanding in pairs(game.ServerGame.LatestTurnStanding.Territories) do
		territoryOwnerTable[territoryStanding.ID] = territoryStanding.OwnerPlayerID
	end

	------------------------------------------------------------------------

	local bonusOwnerTable = buildBonusOwnerTable(territoryOwnerTable, bonuses)

	------------------------------------------------------------------------

	local playerIncomeFromBonusesTable = buildPlayerIncomeBonusTable(bonusOwnerTable, bonuses, overriddenBonuses)
	
	------------------------------------------------------------------------

	redirectBonusIncome(playerIncomeFromBonusesTable, players, addNewOrder)

	------------------------------------------------------------------------
end