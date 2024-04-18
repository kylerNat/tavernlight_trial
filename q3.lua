function removeFromPlayerPartyByName(playerId, membername)
    local player = Player(playerId)
    local party = player:getParty()

    -- looping over members is unecessary since removeMember already makes sure the member is in the party before removing them
    party:removeMember(Player(membername))
end
