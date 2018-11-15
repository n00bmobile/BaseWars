## A free BaseWars gamemode that I'll provide support to, yay!
Go [here](https://forum.facepunch.com/gmodgd/bubuv/BaseWars-Gamemode-Release/1/) for more information.

## Documentation (I probably forgot some):

**(SHARED)**

Entity:GetPrice() -> Returns the price the entity on the Store.&nbsp
Player:GetFaction() -> Returns the name of the player's faction and a table containing all the relevant information about it (Passwords are only accessible from the SERVER).&nbsp
Player:CanRaid(Player victim)&nbsp
Player:IsPartakingRaid() -> Returns 1 if the player is raiding and 2 is he's being raided.&nbsp
Player:IsRaiding(Player player)&nbsp
Player:IsRaidable()&nbsp
BaseWars.GetRaid() -> Returns global raid data, you shouldn't need to use this.&nbsp
BaseWars.FindPlayer(String name) -> Attempts to find a player by his name.&nbsp
BaseWars.FormatMoney()&nbsp
string.MaxLen(String string, Integer length) -> No need to explain this one. I might remove this soon...&nbsp
Player:CanAfford(Integer amount)&nbsp
Player:GetMoney()&nbsp
Player:ReachesLevel(Integer level)&nbsp
Player:GetLimitXP() -> How much XP the level the player is currently in requires.&nbsp
Player:GetRequiredXP()&nbsp
Player:SetLevel(Integer level)&nbsp
Player:IsAlly(Player player)&nbsp
BaseWars.GetAllFactions()&nbsp
Player:InsertInFaction(String name)&nbsp
BaseWars.GetChatCommands() -> Returns all chat commands.&nbsp

**(SERVER)**

BaseWars.AddSync(String identifier, callback) -> Acts like a hook, calling the specified function everytime a player spawns for the first time. (MIGHT CHANGE SOON, DO NOT USE IT FOR NOW)&nbsp
BaseWars.EndSync(String identifier) -> Stops the above from happening. (MIGHT CHANGE SOON, DO NOT USE IT FOR NOW)&nbsp
Player:AddMoney(Integer amount)&nbsp
Player:RemoveFromFaction()&nbsp
Player:SpawnInFront(String class)&nbsp
Player:SetupVars() -> Don't use it.&nbsp
Player:SaveData()&nbsp
BaseWars.SaveDatabase(Player player, String data) -> Don't use it.&nbsp
Player:AddXP(Integer amount)&nbsp
BaseWars.Notify(Player target, Integer type, Integer time, String message) -> Standard notification.&nbsp
BaseWars.AddNotification(Player target, Integer type, String message) -> Notification board.&nbsp
BaseWars.StopRaid()&nbsp
BaseWars.StartRaid(Player victim, Player attacker)&nbsp
BaseWars.AddChatCommand(String command, String description, callback)&nbsp

**(CLIENT)**

BaseWars.Notify(Integer type, Integer time, String message) -> Standard notification, notifies the client It's being called on.&nbsp
BaseWars.AddNotification(Integer type, String message) -> Notification board, notifies the client It's being called on.&nbsp
draw.Circle(Number x, Number y, Number Radius, String texture, Color color)&nbsp
