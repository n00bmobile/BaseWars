BaseWars.Config = {}

--[[
///////////////////////////
BaseWars Configuration File
///////////////////////////

Nearly everything should be listed here, 
let me know if there's something else you wish to easily customize in the gamemode.
]]

-- Rules URL for f3 menu
BaseWars.Config.rulesURL = 'http://www.google.com/'
-- salary - How much money the player gets every 10 minutes.
BaseWars.Config.salary = 500
-- salary_xp_multiplier - How much XP the player gets every 10 minutes.
BaseWars.Config.salary_xp = 500
-- drop_weapon - Whether the player should drop his weapon upon death or not (true to enable or false to disable).
BaseWars.Config.drop_weapon = true
-- respawn_delay - How long (in seconds) the player has to wait before respawning.
BaseWars.Config.respawn_delay = 2
-- starting_money - How much money a beginner player starts with.
BaseWars.Config.starting_money = 9000
-- level_xp_min - How much XP is required at level 1, this value is later used as a base to calculate how much XP you'll need in each level.
BaseWars.Config.level_xp_min = 250
-- level_xp_max - Simply an XP cap.
BaseWars.Config.level_xp_max = 12500
-- price_refund_multiplier - Multiplies the original price of a destroyed entity to refund the victim.
BaseWars.Config.price_refund_multiplier = 0.5
-- raid_duration - The duration of a raid (in seconds).
BaseWars.Config.raid_duration = 300
-- raid_cooldown - How much the player has to wait (in seconds) before being able to raid again.
BaseWars.Config.raid_cooldown = 600
-- raid_reward_prop - How much XP the raider is rewarded for destroying props. 
BaseWars.Config.raid_reward_xp_prop = 500
-- raid_reward_ent - How much money the raider is rewarded for destroying entities.
BaseWars.Config.raid_reward_ent = 2000
-- raid_reward_xp_ent - How much XP the raider is rewarded for destroying entities.
BaseWars.Config.raid_reward_xp_ent = 2000
-- raid_reward_xp_player - How much XP the raider is rewarded for killing players.
BaseWars.Config.raid_reward_xp_player = 2000
-- raid_reward_player - How much money the raider is rewarded for killing players.
BaseWars.Config.raid_reward_player = 2000
-- raid_requirement - How much value a player's possessions together need to have before he can raid or be raided.
BaseWars.Config.raid_requirement = 500000
-- spawn_clearance - Who's allowed to spawn anything: 0 = everyone, 1 = admins, 2 = superadmins, 3 = no one
BaseWars.Config.spawn_clearance = 3
-- spawnmenu_hide - Whether or not to show only the Store and Spawnlist tabs in the spawn menu. I recommend to keep it true.
BaseWars.Config.spawnmenu_hide = true
-- prop_material_health - How much health each prop has based on their material.
BaseWars.Config.prop_material_health = {
	[MAT_CONCRETE] = 700, --concrete
	[MAT_METAL] = 800, --metal
}
-- loadout - The weapons the player spawns with.
BaseWars.Config.loadout = {
	['weapon_physcannon'] = true,
	['weapon_physgun'] = true,
	['gmod_tool'] = true,
}
-- buyables - Stuff for sale.
BaseWars.Config.buyables = {
	[1] = { -- Order of the category in the menu.
		name = 'Weaponry', -- The category's name.
		items = { -- The items available to purchase in the category.
			['weapon_crowbar'] = { -- The item's class.
				name = 'Crowbar', -- The item's name.	
				model = 'models/weapons/w_crowbar.mdl', -- The item's model.
				desc = 'It kills people... Sorta.', -- The item's description.
				price = 500, -- The item's price.
				limit = 0, -- The maximum quantity of the item that the player can have simultaneously in the world. 0 to disable.
				level = 0 -- The level required to buy this item.
			},
		
			['weapon_pistol'] = {
				name = 'Pistol',
				model = 'models/weapons/w_pistol.mdl',
				desc = 'It kills people.',
				price = 2000,
				limit = 0,
				level = 4
			},
		
			['weapon_smg1'] = {
				name = 'SMG',
				model = 'models/weapons/w_smg1.mdl',
				desc = 'It kills people.',
				price = 6000,
				limit = 0,
				level = 6
			},
		
			['weapon_ar2'] = {
				name = 'AR2',
				model = 'models/weapons/w_irifle.mdl',
				desc = 'It kills people.',
				price = 12500,
				limit = 0,
				level = 10
			},
			
			['weapon_shotgun'] = { 
				name = 'Shotgun',
				model = 'models/weapons/w_shotgun.mdl',
				desc = 'It kills people.',
				price = 12500,
				limit = 0,
				level = 8
			},
			
			['weapon_crossbow'] = { 
				name = 'Crossbow',
				model = 'models/weapons/w_crossbow.mdl',
				desc = 'It kills people.',
				price = 1500,
				limit = 0,
				level = 2
			},
			
			['weapon_357'] = { 
				name = '.357 Magnum',
				model = 'models/weapons/w_357.mdl',
				desc = 'It kills people.',
				price = 4000,
				limit = 0,
				level = 6
			},
			
			['weapon_rpg'] = { 
				name = 'RPG Launcher',
				model = 'models/weapons/w_rocket_launcher.mdl',
				desc = 'It kills people.',
				price = 800000,
				limit = 0,
				level = 30
			},
			
			['weapon_frag'] = {
				name = 'Frag Grenade',
				model = 'models/weapons/w_grenade.mdl',
				desc = 'It kills people.',
				price = 15000,
				limit = 0,
				level = 10
			},
			
			['weapon_bw_timed'] = {
				name = 'Timed Explosive Charge',
				model = 'models/weapons/w_c4.mdl',
				desc = 'Deals massive damage in a very short range.\nGood for destroying objects.',
				price = 50000,
				limit = 0,
				level = 15
			},
		}
	},
	
	[2] = { 
		name = 'Ammo', 
		items = {
			['item_ammo_357'] = {
				name = '357 Ammo',
				model = 'models/Items/357ammo.mdl',
				desc = "It's ammo.",
				price = 500,
				limit = 1,
				level = 0
			},
			
			['item_ammo_ar2'] = {
				name = 'AR2 Ammo',
				model = 'models/items/combine_rifle_cartridge01.mdl',
				desc = "It's ammo.",
				price = 500,
				limit = 1,
				level = 0
			},
			
			['item_ammo_crossbow'] = {
				name = 'Crossbow Bolts',
				model = 'models/items/crossbowrounds.mdl',
				desc = "It's ammo.",
				price = 250,
				limit = 1,
				level = 0
			},
			
			['item_ammo_pistol'] = {
				name = 'Pistol Ammo',
				model = 'models/Items/BoxSRounds.mdl',
				desc = "It's ammo.",
				price = 500,
				limit = 1,
				level = 0
			},
			
			['item_rpg_round'] = {
				name = 'RPG Rocket',
				model = 'models/weapons/w_missile_launch.mdl',
				desc = "It's ammo.",
				price = 20000,
				limit = 1,
				level = 40
			},
			
			['item_box_buckshot'] = {
				name = 'Shotgun Ammo',
				model = 'models/items/boxbuckshot.mdl',
				desc = "It's ammo.",
				price = 500,
				limit = 1,
				level = 0
			},
			
			['item_ammo_smg1'] = {
				name = 'SMG Ammo',
				model = 'models/Items/BoxMRounds.mdl',
				desc = "It's ammo.",
				price = 500,
				limit = 1,
				level = 0
			},
		}
	},
	
	[3] = {
		name = 'Power Generators',
		items = {
			['bw_gen_diesel'] = {
				name = 'Diesel Generator',
				model = 'models/props_vehicles/generatortrailer01.mdl',
				desc = 'Provides power to your structures.\nNeeds diesel to function.',
				price = 50000,
				health = 400,
				limit = 5,
				level = 10
			},
			
			['bw_gen_coal'] = {
				name = 'Coal Generator',
				model = 'models/props_wasteland/laundry_washer003.mdl',
				desc = 'Provides power to your structures.\nNeeds coal to function.',
				price = 25000,
				health = 400,
				limit = 5,
				level = 5
			},
			
			['bw_gen_hydrogen'] = {
				name = 'Hydrogen Generator',
				model = 'models/props/de_nuke/equipment1.mdl',
				desc = 'Provides power to your structures.',
				price = 300000,
				health = 800,
				limit = 5,
				level = 15
			},
			
			['bw_gen_solar'] = {
				name = 'Solar Generator',
				model = 'models/props_lab/miniteleport.mdl',
				desc = 'Provides power to your structures.',
				price = 1500,
				health = 400,
				limit = 5,
				level = 0
			},
		}
	},
	
	[4] = {
		name = 'Support',
		items = {
			['weapon_bw_healgun'] = {
				name = 'Heal Gun',
				model = 'models/weapons/w_physics.mdl',
				desc = 'It heals things, what did you expect?',
				price = 80000,
				limit = 1,
				level = 20
			},
			
			['bw_hstation'] = {
				name = 'Health Station',
				model = 'models/props_lab/reciever_cart.mdl',
				desc = "It's free health, come get it!",
				price = 70000,
				health = 200,
				limit = 1,
				level = 5
			},
		
			['bw_astation'] = {
				name = 'Armor Station',
				model = 'models/props_lab/reciever_cart.mdl',
				desc = "It's free armor, come get it!",
				price = 35000,
				health = 100,
				limit = 1,
				level = 5
			},
		
			['bw_rstation'] = {
				name = 'Repair Station',
				model = 'models/props_c17/TrapPropeller_Engine.mdl',
				desc = 'Repairs your props.',
				price = 80000,
				health = 100,
				limit = 5,
				level = 20
			},
			
			['bw_drinkmixer'] = {
				name = 'Drink Mixer',
				model = 'models/props_lab/crematorcase.mdl',
				desc = 'Produces random drinks every few minutes for free.',
				price = 500000,
				health = 100,
				limit = 1,
				level = 10
			},
			
			['bw_ammocrate'] = {
				name = 'Munitions Crate',
				model = 'models/items/ammocrate_smg1.mdl',
				desc = "It's free ammo, come get it!",
				price = 500000,
				health = 1,
				limit = 1,
				level = 10
			},
		}
	},
	
	[5] = {
		name = 'Structures',
		items = {
			['bw_radar'] = {
				name = 'Radar Tower',
				model = 'models/props_rooftop/roof_dish001.mdl',
				desc = 'Is able to scan players.',
				price = 500000,
				health = 100,
				limit = 1,
				level = 10
			},
		
			['bw_teleporter'] = {
				name = 'Teleporter',
				model = 'models/props_lab/teleplatform.mdl',
				desc = 'Teleports you to it when you die.',
				price = 15000,
				health = 500,
				limit = 1,
				level = 2
			},
		
			['bw_vault'] = {
				name = 'Money Vault',
				model = 'models/props_lab/powerbox01a.mdl',
				desc = 'Stores money.\nCan also act as a backup storage to full printers.',
				price = 5000,
				health = 100,
				limit = 10,
				level = 2
			},
		}
	},
	
	[6] = {
		name = 'Money Printers (T1)',
		items = {
			['bw_mprinter_basic'] = {
				name = 'Basic Printer',
				model = 'models/props_c17/consolebox01a.mdl',
				desc = 'It prints money.',
				price = 2000,
				health = 100,
				limit = 5,
				level = 0
			},
			
			['bw_mprinter_copper'] = {
				name = 'Copper Printer',
				model = 'models/props_c17/consolebox01a.mdl',
				desc = 'It prints money.',
				price = 12500,
				health = 100,
				limit = 5,
				level = 2
			},
		
			['bw_mprinter_silver'] = {
				name = 'Silver Printer',
				model = 'models/props_c17/consolebox01a.mdl',
				desc = 'It prints money.',
				price = 20000,
				health = 100,
				limit = 5,
				level = 4
			},
			
			['bw_mprinter_gold'] = {
				name = 'Gold Printer',
				model = 'models/props_c17/consolebox01a.mdl',
				desc = 'It prints money.',
				price = 50000,
				health = 100,
				limit = 5,
				level = 6
			},
		
			['bw_mprinter_platinum'] = {
				name = 'Platinum Printer',
				model = 'models/props_c17/consolebox01a.mdl',
				desc = 'It prints money.',
				price = 75000,
				health = 100,
				limit = 5,
				level = 8
			},
		
			['bw_mprinter_diamond'] = {
				name = 'Diamond Printer',
				model = 'models/props_c17/consolebox01a.mdl',
				desc = 'It prints money',
				price = 150000,
				health = 100,
				limit = 5,
				level = 10
			},
		
			['bw_mprinter_nuclear'] = {
				name = 'Nuclear Printer',
				model = 'models/props_c17/consolebox01a.mdl',
				desc = 'It prints money',
				price = 300000,
				health = 100,
				limit = 5,
				level = 12
			},
		}
	},
	
	[7] = {
		name = 'Money Printers (T2)',
		items = {
			['bw_mprinter_mobius'] = {
				name = 'Mobius Printer',
				model = 'models/props_c17/consolebox01a.mdl',
				desc = 'It prints a LOT of money, believe me...',
				price = 6000000,
				health = 200,
				limit = 2,
				level = 20
			},
			
			['bw_mprinter_dmatter'] = {
				name = 'Dark Matter Printer',
				model = 'models/props_c17/consolebox01a.mdl',
				desc = 'It prints a LOT of money, believe me...',
				price = 15000000,
				health = 200,
				limit = 2,
				level = 25
			},
			
			['bw_mprinter_rmatter'] = {
				name = 'Red Matter Printer',
				model = 'models/props_c17/consolebox01a.mdl',
				desc = 'It prints a LOT of money, believe me...',
				price = 25000000,
				health = 200,
				limit = 2,
				level = 30
			},
			
			['bw_mprinter_monolith'] = {
				name = 'Monolith Printer',
				model = 'models/props_c17/consolebox01a.mdl',
				desc = 'It prints a LOT of money, believe me...',
				price = 35000000,
				health = 200,
				limit = 2,
				level = 35
			},
			
			['bw_mprinter_quantum'] = {
				name = 'Quantum Printer',
				model = 'models/props_c17/consolebox01a.mdl',
				desc = "You'll be using money as asspaper with this one!",
				price = 35000000,
				health = 200,
				limit = 2,
				level = 40
			},
		}
	},
	
	[8] = {
		name = 'Defense (T1)',
		items = {
			['bw_inhibitor_speed'] = {
				name = 'Speed Inhibitor',
				model = 'models/props_c17/TrapPropeller_Engine.mdl',
				desc = 'Considerably slows downs players inside its sphere of influence.',
				price = 50000,
				health = 250,
				limit = 2,
				level = 10
			},
			
			['bw_sg_pistol'] = {
				name = 'Sentry Gun (Pistol)',
				model = 'models/props_c17/TrapPropeller_Engine.mdl',
				desc = "It's a sentry gun, it shoots people.",
				price = 60000,
				health = 250,
				limit = 2,
				level = 12
			},
			
			['bw_explosivemine'] = {
				name = 'Explosive Mine',
				model = 'models/props_combine/combine_mine01.mdl',
				desc = 'A small damage proof mine capable of killing unsuspecting enemies.\nUneffective against aware opponents.',
				price = 20000,
				health = 0,
				limit = 5,
				level = 5
			},
		}
	},
	
	[9] = {
		name = 'Defense (T2)',
		items = {
			['bw_sg_revolver'] = {
				name = 'Sentry Gun (Revolver)',
				model = 'models/props_c17/TrapPropeller_Engine.mdl',
				desc = "It's a sentry gun, it shoots people.",
				price = 80000,
				health = 300,
				limit = 2,
				level = 20
			},
			
			['bw_sg_shotgun'] = {
				name = 'Sentry Gun (Shotgun)',
				model = 'models/props_c17/TrapPropeller_Engine.mdl',
				desc = "It's a sentry gun, it shoots people.",
				price = 80000,
				health = 350,
				limit = 2,
				level = 25
			},
			
			['bw_sg_smg'] = {
				name = 'Sentry Gun (SMG)',
				model = 'models/props_c17/TrapPropeller_Engine.mdl',
				desc = "It's a sentry gun, it shoots people.",
				price = 120000,
				health = 350,
				limit = 2,
				level = 30
			},
			
			['bw_tesla'] = {
				name = 'Tesla Coil',
				model = 'models/props_c17/substation_transformer01d.mdl',
				desc = 'Kills nearby enemies with a single powerful burst of electricity at the cost of damaging itself a little.\nUses a ton of eletricity and takes a while to charge.',
				price = 180000,
				health = 1000,
				limit = 2,
				level = 35
			},
		}
	},
	
	--consumables
	[10] = {
		name = 'Consumables',
		items = {
			['bw_dieselcan'] = {
				name = 'Diesel Can',
				model = 'models/props_junk/gascan001a.mdl',
				desc = "Can you smell this? It's the stink of progress!",
				price = 5000,
				health = 1,
				limit = 2,
				level = 4
			},
			
			['bw_coal'] = {
				name = 'Coal',
				model = 'models/props_junk/cardboard_box001a.mdl',
				desc = "Can you smell this? It's the stink of progress!",
				price = 2500,
				health = 0,
				limit = 2,
				level = 2
			},
			
			['bw_drink_antidote'] = {
				name = 'Antidote',
				model = 'models/props_junk/PopCan01a.mdl',
				desc = 'Returns you back to normal.',
				price = 500,
				limit = 1,
				level = 0
			},
			
			['bw_drink_damage'] = {
				name = 'Damage Increase',
				model = 'models/props_junk/PopCan01a.mdl',
				desc = 'Significantly boosts you for a short amount of time.',
				price = 90000,
				limit = 1,
				level = 6
			},
			
			['bw_drink_speed'] = {
				name = 'Speed Increase',
				model = 'models/props_junk/PopCan01a.mdl',
				desc = 'Significantly boosts you for a short amount of time.',
				price = 85000,
				limit = 1,
				level = 5
			},
			
			['bw_drink_gravity'] = {
				name = 'Low Gravity',
				model = 'models/props_junk/PopCan01a.mdl',
				desc = 'Significantly boosts you for a short amount of time.',
				price = 80000,
				limit = 1,
				level = 5
			},
			
			['bw_drink_jump'] = {
				name = 'Jump Increase',
				model = 'models/props_junk/PopCan01a.mdl',
				desc = 'Significantly boosts you for a short amount of time.',
				price = 75000,
				limit = 1,
				level = 5
			},
			
			['bw_drink_xp'] = {
				name = 'Mysterious Misture',
				model = 'models/props_junk/PopCan01a.mdl',
				desc = "What secrets does this hold?",
				price = 200000,
				limit = 1,
				level = 0
			},
		}
	},
}