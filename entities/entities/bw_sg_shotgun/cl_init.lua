include('shared.lua')

local laser = Material('cable/redlaser')
function ENT:Draw()
	if self.Target:IsValid() then
		local tPos = self.Target:GetBonePosition(1)
		local muzzle = self.GunTurret:GetAttachment(1)
		render.SetMaterial(laser)
		render.DrawBeam(muzzle.Pos, tPos, 5, 1, 1, Color(255, 255, 255))
		local ang = (muzzle.Pos -tPos):Angle()
		self.GunTurret:SetAngles(Angle(ang.p --[[+8]], ang.y, self:GetAngles().r))
	else
		self.GunTurret:SetAngles(LerpAngle(0.05, self.GunTurret:GetAngles(), self:GetAngles()))
	end
	
	self:DrawModel()
end