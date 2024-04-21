void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{
    /* I have chosen to allocate a player on the stack to avoid using new at all and remove any chance of a leak.
       I think this is the simplest and cleanest solution since it avoids dynamic memory allocation, which can be slow, but an alternative way to fix the leak would be to use smart pointers */
    Player tempPlayer(nullptr);
    Player* player = g_game.getPlayerByName(recipient);
    if (!player) {
        player = &tempPlayer;
        if (!IOLoginData::loadPlayerByName(player, recipient)) {
            return;
        }
    }

    Item* item = Item::CreateItem(itemId);
    if (!item) {
        return;
    }

    g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);

    if (player->isOffline()) {
        IOLoginData::savePlayer(player);
    }
}
