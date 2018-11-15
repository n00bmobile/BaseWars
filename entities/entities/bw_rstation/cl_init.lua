include('shared.lua')

function ENT:Initialize()
	local mdl = ents.CreateClientProp('models/props_c17/tools_wrench01a.mdl')
	local ang = self:GetAngles()
	mdl:SetPos(self:GetPos() +ang:Up() *22 +ang:Right() *3.2)
	mdl:SetAngles(ang)
	mdl:SetParent(self)
	mdl:Spawn()
	self.Mounted = mdl
	self.Mounted.Rotation = 0
	self.LastDrawn = CurTime()
	local mn, mx = self:GetRenderBounds()
	self:SetRenderBounds(mn -Vector(self.MaxRange, self.MaxRange, self.MaxRange), mx +Vector(self.MaxRange, self.MaxRange, self.MaxRange))
end

function ENT:Think()
	self.Mounted:SetParent(self)
end

function ENT:OnRemove()
	if self.Mounted:IsValid() then self.Mounted:Remove() end
end

local laser = Material('cable/redlaser')
function ENT:Draw()
	local target = self:GetTarget()
	
	if target:IsValid() then
		local tr = util.TraceLine({start = self.Mounted:GetPos(), endpos = target:GetPos()})
		local effect = EffectData()
		effect:SetMagnitude(5)
		effect:SetNormal(tr.HitNormal)
		effect:SetOrigin(tr.HitPos)
		util.Effect('AR2Impact', effect)
		render.SetMaterial(laser)
		render.DrawBeam(tr.StartPos, tr.HitPos, 5, 1, 1, Color(255, 255, 255))
	end
	
	if self.Mounted.Rotation > 359 then 
	    self.Mounted.Rotation = 0 
	end
	
	self.Mounted.Rotation = self.Mounted.Rotation +(CurTime() -self.LastDrawn) *80
	self.Mounted:SetAngles(Angle(self.Mounted.Rotation, self.Mounted.Rotation, 0))
	self.Mounted:SetParent(self)
	self.LastDrawn = CurTime()
	self:DrawModel()
end