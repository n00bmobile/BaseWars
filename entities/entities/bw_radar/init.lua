AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')
include('shared.lua')

util.AddNetworkString('bw_ents_radar')

function ENT:Initialize()
	local antenna = ents.Create('prop_physics')
	local ang = self:GetAngles()
	antenna:SetModelScale(0.9)
	antenna:SetPos(self:GetPos() +ang:Up() *30 -ang:Forward() *4.5)
	antenna:SetAngles(ang)
	antenna:SetParent(self)
	antenna:SetModel('models/props_rooftop/roof_dish001.mdl')
	antenna:Spawn()
	antenna:SetSolid(SOLID_NONE)
	antenna:SetMoveType(SOLID_NONE)
	antenna:PhysicsInit(SOLID_NONE)
	self.Antenna = antenna
	
	self:SetModel('models/props_wasteland/gaspump001a.mdl')
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self.NextCharge = nil
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then
	    phys:Wake()
	end
end

function ENT:Use(caller)
	net.Start('bw_ents_radar')
		net.WriteEntity(self)
	net.Send(caller)
end

function ENT:Think()
	if self:IsPowered() then
		if self:GetTarget():IsValid() then
			if self:GetChargeStored() > 0 then
				self:SetChargeStored(self:GetChargeStored() -(5 -math.floor(4 *self:GetEfficiency())))
			else
				self:SetTarget(NULL)
			end
		else 
			if not self.NextCharge then
				self.NextCharge = CurTime() +self.ChargeDelay
			elseif self.NextCharge <= CurTime() then
				self:SetChargeStored(math.Clamp(self:GetChargeStored() +1, 0, self.MaxCharge))
				self.NextCharge = CurTime() +self.ChargeDelay
			end
		end
	else
		if self:GetTarget():IsValid() then
			self:SetTarget(NULL)
		end
		
		self.NextCharge = nil
	end
	
	self:NextThink(CurTime() +1)
	return true
end

net.Receive('bw_ents_radar', function(len, ply)
	local ent = net.ReadEntity()
	
	if ent:IsValid() and ent:GetClass() == 'bw_radar' then
		local isScan = net.ReadBool()
		
		if isScan then
			if ent:CanScan() then
				local target = net.ReadEntity()
		
				if target:IsPlayer() then
					if ent:GetTarget() == target then
						ent:SetTarget(NULL)
					else
						ent.NextCharge = nil
						ent:SetTarget(target)
					end
				end
			end
		else
			if ent:GetTurnedOn() then
				ent:SetTarget(NULL)
				ent:SetTurnedOn(false)
			else
				ent:SetTurnedOn(true)
			end
			
			ent:EmitSound('buttons/button3.wav')
		end
	end
end)