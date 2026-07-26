require('Mod_Message')

function Client_GameRefresh(game)
    print("Test Client")
    if game.Us ~= nil and not Mod.PlayerGameData.InitialPopupDisplayed then
        UI.Alert(GetInitialPopup())
        local payload = {}
        payload.Message = "InitialPopupDisplayed"
        game.SendGameCustomMessage("Please wait...", payload, function(reply)end)
    end
end