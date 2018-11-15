include('shared.lua')

local material = Material('models/props_combine/stasisshield_sheet')
function ENT:Draw()
	self:DrawModel()
	
	if self:IsPowered() then
		local range = self.MaxRange *self:GetEfficiency()
		
		render.UpdateScreenEffectTexture()
		render.SetMaterial(material)
	
		if self:GetPos():DistToSqr(LocalPlayer():GetPos()) <= range *range then
			render.DrawSphere(self:GetPos(), -range, 30, 30)
		else
			render.DrawSphere(self:GetPos(), range, 30, 30)
		end
	end
end

function ENT:Initialize()
	local mn, mx = self:GetRenderBounds()
	self:SetRenderBounds(mn -Vector(self.MaxRange, self.MaxRange, self.MaxRange), mx +Vector(self.MaxRange, self.MaxRange, self.MaxRange))
end