AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')
include('shared.lua')

util.AddNetworkString('bw_ents_mprinter') 

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then
	    phys:Wake()
	end
end

function ENT:Use(caller)
	net.Start('bw_ents_mprinter')
		net.WriteEntity(self)
	net.Send(caller)
end

function ENT:PrintMoney()
	local newAmount = self:GetStoredMoney() +math.Round(self:GetPrintCapacity() *self:GetEfficiency())
	
	if newAmount <= self:GetMaxStorage() then
		self:SetStoredMoney(newAmount)
	else
		local clamped = math.Clamp(newAmount, 0, self:GetMaxStorage())
		local missing = newAmount -clamped
		self:SetStoredMoney(clamped)
		
		for k, v in pairs(ents.FindInSphere(self:GetPos(), 100)) do
			if v:GetClass() == 'bw_moneyvault' then
				if missing ~= 0 then
					local added = v:AddStoredMoney(missing)
				
					if added then
						missing = added					
					end
				else 
					break 
				end
			end
		end
	end
end

function ENT:Think()
	if self:IsPowered() then
		if not self.NextPrint then
			self.EmittedSound:Play()
			self.NextPrint = CurTime() +self:GetPrintSpeed()
		elseif self.NextPrint <= CurTime() then
			self:PrintMoney()
			self.NextPrint = CurTime() +self:GetPrintSpeed()
		end
	elseif self.NextPrint then
		self.NextPrint = nil
		self.EmittedSound:Stop()
	end
end

function ENT:OnRemove()
	local amount = self:GetStoredMoney()
	
	if amount ~= 0 then
		local money = ents.Create('bw_money')
		money:SetAmount(amount)
		money:SetPos(self:GetPos())
		money:Spawn()
	end	
	
	if self.EmittedSound then
		self.EmittedSound:Stop()
	end
end

net.Receive('bw_ents_mprinter', function(len, ply)
	local ent = net.ReadEntity()
	
	if ent:IsValid() and ent.BaseSpeed then
		local opt = net.ReadInt(3)
		
		if opt == 1 then
			if ent:GetTurnedOn() then
				ent:SetTurnedOn(false)
			else
				ent.EmittedSound = CreateSound(ent, 'ambient/levels/labs/equipment_printer_loop1.wav')
				ent.EmittedSound:SetSoundLevel(50)
				ent:SetTurnedOn(true)
			end
	
			ent:EmitSound('buttons/button3.wav')
		elseif opt == 2 then
			local money = ents.Create('bw_money')
			money:SetPos(ent:GetPos() +Vector(0, 0, 20))
			money:SetAmount(ent:GetStoredMoney())
			money:Spawn()
			ent:CPPIGetOwner():AddXP(math.Round(ent:GetStoredMoney() *0.1))
			ent:SetStoredMoney(0)
		else
			local name = net.ReadString()
	
			if ent.Upgrades[name] then
				local data = ent:GetUpgrade(name)
				
				if data then
					if ply:CanAfford(data.price) then
						if name == 'Speed' then
							ent:SetPrintSpeed(data.value)
							--ent.NextPrint = CurTime() +data.value
						elseif name == 'Capacity' then
							ent:SetPrintCapacity(data.value)
						else
							ent:SetMaxStorage(data.value)
						end
				
						ply:AddMoney(-data.price)
						BaseWars.AddNotification(ply, 1, 'You upgraded '..ent.PrintName..' for '..BaseWars.FormatMoney(data.price)..'.')
					end
				end
			end
		end
	end
end)