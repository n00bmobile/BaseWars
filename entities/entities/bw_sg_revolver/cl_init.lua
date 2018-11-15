include('shared.lua')

function ENT:AfterSentryShot()
	local muzzle = self.GunTurret:GetAttachment(1)
	--bullet shell
	--local effect = EffectData()
	--effect:SetOrigin(self.GunTurret:GetAttachment(2).Pos)
	--util.Effect('EjectBrass_9mm', effect)
	--muzzle
	local effect = EffectData()
	effect:SetOrigin(muzzle.Pos)
	effect:SetAngles(muzzle.Ang)
	util.Effect('MuzzleEffect', effect)
	self:EmitSound(self.ShotSound, 140)
end

local laser = Material('cable/redlaser')
function ENT:Draw()
	local target = self.Target

	if target:IsValid() then
		local tPos = target:GetBonePosition(1)
		local muzzle = self.GunTurret:GetAttachment(1)
		render.SetMaterial(laser)
		render.DrawBeam(muzzle.Pos, tPos, 5, 1, 1, Color(255, 255, 255))
		local ang = (muzzle.Pos -tPos):Angle()
		self.GunTurret:SetAngles(Angle(ang.p *-1, ang.y -180, self:GetAngles().r))
	else
		self.GunTurret:SetAngles(LerpAngle(0.05, self.GunTurret:GetAngles(), self:GetAngles()))
	end
	
	self:DrawModel()
end