include('shared.lua')

function ENT:Initialize()
	local gun = ents.CreateClientProp(self.GunModel)
	local ang = self:GetAngles()
	gun:SetPos(self:GetPos() +ang:Up() *22 +ang:Right() *3.2)
	gun:SetAngles(ang)
	gun:SetParent(self)
	gun:Spawn()
	self.GunTurret = gun
	self.Target = NULL
	local mn, mx = self:GetRenderBounds()
	self:SetRenderBounds(mn -Vector(self.MaxRange, self.MaxRange, self.MaxRange), mx +Vector(self.MaxRange, self.MaxRange, self.MaxRange))
end

function ENT:AfterSentryShot()
	local muzzle = self.GunTurret:GetAttachment(1)
	--bullet shell
	local effect = EffectData()
	effect:SetOrigin(self.GunTurret:GetAttachment(2).Pos)
	util.Effect('EjectBrass_9mm', effect)
	--muzzle
	local effect = EffectData()
	effect:SetOrigin(muzzle.Pos)
	effect:SetAngles(muzzle.Ang)
	util.Effect('MuzzleEffect', effect)
	self:EmitSound(self.ShotSound, 140)
end

net.Receive('bw_ents_sg', function()
	local hasShot = net.ReadBool()
	local ent = net.ReadEntity()
	
	if hasShot then
		ent:AfterSentryShot()
	else
		ent.Target = net.ReadEntity()
	end
end)

function ENT:Think()
	self.GunTurret:SetParent(self)
end

function ENT:OnRemove()
	if self.GunTurret:IsValid() then self.GunTurret:Remove() end
end

local laser = Material('cable/redlaser')
function ENT:Draw()
	if self.Target:IsValid() then
		local tPos = self.Target:GetBonePosition(1)
		local muzzle = self.GunTurret:GetAttachment(1)
		render.SetMaterial(laser)
		render.DrawBeam(muzzle.Pos, tPos, 5, 1, 1, Color(255, 255, 255))
		local ang = (muzzle.Pos -tPos):Angle()
		self.GunTurret:SetAngles(Angle(ang.p, ang.y, self:GetAngles().r))
	else
		self.GunTurret:SetAngles(LerpAngle(0.05, self.GunTurret:GetAngles(), self:GetAngles()))
	end
	
	self:DrawModel()
end