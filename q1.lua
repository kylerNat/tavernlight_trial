local function releaseStorage(playerGuid)
    -- after logout we can't reliably use a Player metatable, so we need to use database functions instead

    -- make sure not to delete the storage value if they logged back in before the event triggered
    -- depending on the code that sets and uses this value this may or may not be necessary
    query = string.format([[
DELETE FROM `player_storage` WHERE `player_id` = %d AND `key` = 1000
AND NOT EXISTS (SELECT 1 FROM `players_online` WHERE `player_id` = %d);]], playerGuid, playerGuid)
    db.query(query)
end

function onLogout(player)
    if player:getStorageValue(1000) == 1 then
        addEvent(releaseStorage, 1000, player:getGuid())
    end
    return true
end
