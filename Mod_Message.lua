require("Utilities")

function GetInitialPopup()
    local from = Mod.Settings.RedirectFrom
    local to = Mod.Settings.RedirectTo
    local slf = Mod.Settings.RedirectSelf

    local fromText
    if from == RedirectFromEnum.All then
        fromText = 'all bonuses'
        notFromText = ''
    elseif from == RedirectFromEnum.Positive then
        fromText = 'positive bonuses'
        notFromText = ' Negative bonuses are uneffected by this mod.'
    elseif from == RedirectFromEnum.Negative then
        fromText = 'negative bonuses'
        notFromText = ' Positive bonuses are uneffected by this mod.'
    end

    local toText
    if to == RedirectToEnum.AllOthers then
        toText = 'all other players'
    elseif to == RedirectToEnum.AllOpponents then
        toText = 'all opponents'
    elseif to == RedirectToEnum.AllTeammates then
        toText = 'all teammates'
    elseif to == RedirectToEnum.OneOpponent then
        toText = 'one opponent'
    elseif to == RedirectToEnum.OneTeammate then
        toText = 'one teammate'
    end

    local slfText1 = '.'
    if slf then
        slfText1 = ', including yourself.'
    end

    local slfText2 = ''
    if not slf then
        slfText2 = ' You do not gain the income from ' .. fromText .. ' yourself.'
    end

    return '[MOD] BonusRedirect: The income from ' .. fromText .. ' you own is redirected to ' .. toText .. slfText1 .. slfText2 .. ' The same applies vice versa towards you.' .. notFromText
end