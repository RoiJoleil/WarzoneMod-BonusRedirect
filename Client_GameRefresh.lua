require('Mod_Message')

function Client_GameRefresh(game)
    if game.Us ~= nil and not Mod.PlayerGameData.InitialPopupDisplayed then
        UI.Alert(GetInitialPopup())
        local payload = {}
        payload.Message = "InitialPopupDisplayed"
        game.SendGameCustomMessage("Please wait...", payload, function(reply)end)
    end
end