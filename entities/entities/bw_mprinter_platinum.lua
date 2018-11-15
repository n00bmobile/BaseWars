AddCSLuaFile()

ENT.Type = 'anim'
ENT.Base = 'bw_mprinter_base'
ENT.Author = 'n00bmobile'
ENT.Category = 'n00bmobile'
ENT.Spawnable = true
ENT.AdminSpawnable = true
--[Customizable Values - ONLY USE WHOLE AND POSITIVE NUMBERS]--
ENT.PrintName = 'Platinum Printer' --The name of your custom printer.
ENT.BaseSpeed = 60 --How long the printer takes to print (in seconds).
ENT.BaseCapacity = 1440 --How much money the printer prints.
ENT.BaseStorage = 180000 --The starting storage capacity of the printer.
ENT.MaxPower = 125 --How much power the printer uses.
ENT.TitleBackgroundColor = Color(0, 255, 0) --The color that represents this printer (in RGB).
ENT.Model = 'models/props_c17/consolebox01a.mdl' --The model used by the printer, only edit this if you know what you're doing.
ENT.Upgrades = {
	['Speed'] = {
		[1] = {
			value = ENT.BaseSpeed -5, 
			price = ENT.BaseCapacity *30
		},
		[2] = {
			value = ENT.BaseSpeed -10,
			price = ENT.BaseCapacity *60
		},
		[3] = {
			value = ENT.BaseSpeed -15, 
			price = ENT.BaseCapacity *90
		},
	},
	
	['Capacity'] = {
		[1] = {
			value = ENT.BaseCapacity *2, 
			price = ENT.BaseCapacity *90
		},
		[2] = {
			value = ENT.BaseCapacity *3,
			price = ENT.BaseCapacity *180
		},
		[3] = {
			value = ENT.BaseCapacity *4, 
			price = ENT.BaseCapacity *270
		},
	},
	
	['Storage'] = {
		[1] = {
			value = ENT.BaseStorage *2, 
			price = ENT.BaseStorage *3
		},
		[2] = {
			value = ENT.BaseStorage *3,
			price = ENT.BaseStorage *4
		},
		[3] = {
			value = ENT.BaseStorage *4, 
			price = ENT.BaseStorage *5
		},
	}
}
---------------------------------------------------------------