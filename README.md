# A free yet supported BaseWars gamemode.

## Documentation:

**Shared**\
string.MaxLen(String string, number length)\
Entity:GetPrice()
Player:GetFaction() > Returns the name of the player's faction and its data (Password are serverside only).\
Player:CanRaid(Player victim)\
Player:IsPartakingRaid() > Returns 1 if the player is raiding and 2 is he's being raided.\
Player:IsRaiding(Player player) > Returns true if the player is raiding provided player.\
Player:IsRaidable() > Returns true if the player is able to raid and be raided.\
Player:CanAfford(number amount)\
Player:GetMoney() > Returns how much money the player has.\
Player:ReachesLevel(number level)\
Player:GetLimitXP() > Returns how much XP the level the player is currently in requires.\
Player:GetRequiredXP() > Returns how much XP the player still needs to level up.\
Player:SetLevel(number level)\
Player:IsAlly(Player player)\
Player:InsertInFaction(String name)\
BaseWars.GetAllFactions()\
BaseWars.GetRaid() > Returns global raid data, you shouldn't need to use this.\
BaseWars.FindPlayer(String name) > Attempts to find a player by his name.\
BaseWars.FormatMoney(number money) > Formats the number into a pretty string to be used for UI and stuff like that.\
BaseWars.FindBuyable(String class) > Returns the order (index) of the category the item is in and its data, provided the entity whose class is from is sellable.\
BaseWars.GetChatCommands() > Returns all chat commands.

**Serverside**\
Player:AddMoney(number amount)\
Player:RemoveFromFaction()\
Player:SpawnInFront(String class)\
Player:SetupVars()\
Player:SaveData()\
Player:AddXP(number amount)\
BaseWars.SaveDatabase(Player player, String data) > Don't use this unless you know EXACTLY how this works. INCORRECT USAGE WILL CORRUPT SAVE DATA!\
BaseWars.Notify(Player target, number type, number time, String message) > Default Garry's Mod notification.\
BaseWars.AddNotification(Player target, number type, String message) -> Notification board.\
BaseWars.StopRaid()\
BaseWars.StartRaid(Player victim, Player attacker)\
BaseWars.AddChatCommand(String command, String description, callback)\
BaseWars.AddSync(String identifier, callback) > Acts like a hook, calling the specified function everytime a player loads/reloads (I MIGHT REMOVE IT OR CHANGE ITS BEHAVIOR, BEWARE).\
BaseWars.EndSync(String identifier) > Self-explanatory (I MIGHT REMOVE IT OR CHANGE ITS BEHAVIOR, BEWARE).\
GM:PlayerLoaded(Player player) > Hook for when the player's game loads.

**Clientside**\
BaseWars.Notify(Integer type, Number time, String message) > Default Garry's Mod notification, notifies the client It's being called on.\
BaseWars.AddNotification(Integer type, String message) > Notification board, notifies the client It's being called on.\
draw.Circle(number x, number y, number Radius, String texture, Color color)