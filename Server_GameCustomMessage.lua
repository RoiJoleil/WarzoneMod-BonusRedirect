function Server_GameCustomMessage(game, playerID, payload, setReturnTable)
    local playerGameData = Mod.PlayerGameData
    if playerGameData[playerID] == nil then
        playerGameData[playerID] = {}
    end
    if payload.Message == "InitialPopupDisplayed" then
        playerGameData[playerID].InitialPopupDisplayed = true
        Mod.PlayerGameData = playerGameData
    end
end