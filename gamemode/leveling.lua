--local requirement = {start = 250, max = 12500}
local meta = FindMetaTable('Entity')

function meta:ReachesLevel(lvl)
	return self:GetNWInt('level') >= self:GetNWInt('level')
end

function meta:GetLimitXP()
	return math.Clamp(BaseWars.Config.level_xp_min *self:GetNWInt('level'), 0, BaseWars.Config.level_xp_max)
end

function meta:GetRequiredXP()
	return self:GetLimitXP() -self:GetNWInt('level_xp')
end

if SERVER then
	function meta:AddXP(amount)
		local lvl = self:GetNWInt('Level')
		local needed = self:GetRequiredXP()
		
		if amount > needed then
			self:SetNWInt('level', lvl +1)
			self:SetNWInt('level_xp', 0)
			self:AddXP(amount -needed)
		elseif amount == needed then
			self:SetNWInt('level', lvl +1)
			self:SetNWInt('level_xp', 0)
			self:SaveData()
		else
			self:SetNWInt('level_xp', self:GetNWInt('level_xp') +amount)
			self:SaveData()
		end
	end
	
	function meta:SetLevel(lvl)
		self:SetNWInt('level', lvl)
		self:SetNWInt('level_xp', 0)
		self:SaveData()
	end
	
	--[[concommand.Add('addXP', function(ply)
		ply:AddXP(100)
	end)
	
	concommand.Add('resetXP', function(ply)
		ply:SetLevel(1)
	end)]]
end