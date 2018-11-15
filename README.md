## A free BaseWars gamemode that I'll provide support to, yay!
Go [here](https://forum.facepunch.com/gmodgd/bubuv/BaseWars-Gamemode-Release/1/) for more information.

###### Documentation (I probably forgot some):

**(SHARED)**
Entity:GetPrice() -> Returns the price the entity on the Store.
Player:GetFaction() -> Returns the name of the player's faction and a table containing all the relevant information about it (Passwords are only accessible from the SERVER).
Player:CanRaid(Player victim)
Player:IsPartakingRaid() -> Returns 1 if the player is raiding and 2 is he's being raided.
Player:IsRaiding(Player player)
Player:IsRaidable()
BaseWars.GetRaid() -> Returns global raid data, you shouldn't need to use this.
BaseWars.FindPlayer(String name) -> Attempts to find a player by his name.
BaseWars.FormatMoney()
string.MaxLen(String string, Integer length) -> No need to explain this one. I might remove this soon...
Player:CanAfford(Integer amount)
Player:GetMoney()
Player:ReachesLevel(Integer level)
Player:GetLimitXP() -> How much XP the level the player is currently in requires.
Player:GetRequiredXP()
Player:SetLevel(Integer level)
Player:IsAlly(Player player)
BaseWars.GetAllFactions()
Player:InsertInFaction(String name)
BaseWars.GetChatCommands() -> Returns all chat commands.

**(SERVER)**
BaseWars.AddSync(String identifier, callback) -> Acts like a hook, calling the specified function everytime a player spawns for the first time. (MIGHT CHANGE SOON, DO NOT USE IT FOR NOW)
BaseWars.EndSync(String identifier) -> Stops the above from happening. (MIGHT CHANGE SOON, DO NOT USE IT FOR NOW)
Player:AddMoney(Integer amount)
Player:RemoveFromFaction()
Player:SpawnInFront(String class)
Player:SetupVars() -> Don't use it.
Player:SaveData()
BaseWars.SaveDatabase(Player player, String data) -> Don't use it.
Player:AddXP(Integer amount)
BaseWars.Notify(Player target, Integer type, Integer time, String message) -> Standard notification.
BaseWars.AddNotification(Player target, Integer type, String message) -> Notification board.
BaseWars.StopRaid()
BaseWars.StartRaid(Player victim, Player attacker)
BaseWars.AddChatCommand(String command, String description, callback)

**(CLIENT)**
BaseWars.Notify(Integer type, Integer time, String message) -> Standard notification, notifies the client It's being called on.
BaseWars.AddNotification(Integer type, String message) -> Notification board, notifies the client It's being called on.
draw.Circle(Number x, Number y, Number Radius, String texture, Color color)
