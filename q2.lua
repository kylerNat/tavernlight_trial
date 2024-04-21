function printSmallGuildNames(memberCount)
    -- this method is supposed to print names of all guilds that have less than memberCount max members

    -- max members is not part of the default forgotten server schema, but I'm assuming it exists
    local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < %d;"
    local resultId = db.storeQuery(string.format(selectGuildQuery, memberCount))
    if not resultId then
        return
    end
    repeat
        local guildName = result.getString(resultId, "name")
        print(guildName)
    until not result.next(resultId);
    result.free(resultId)
end
