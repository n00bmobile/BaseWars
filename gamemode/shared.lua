GM.Name = 'BaseWars'
GM.Author = 'n00bmobile'
GM.Version = '1.4.1'

DeriveGamemode('sandbox')
BaseWars = GM or GAMEMODE

function GM:CanProperty()
	return false
end

function BaseWars.FindPlayer(name)
	for k, v in pairs(player.GetAll()) do
		if string.find(string.lower(v:GetName()), string.lower(name)) then
			return v
		end
	end
end

function BaseWars.FormatMoney(amount)
	if amount >= 1000000000 then --1.000.000.000
		return '$'..string.Comma(amount *10^-9)..' billion'
	elseif amount >= 1000000 then
		return '$'..string.Comma(amount *10^-6)..' million'
	else
		return '$'..string.Comma(amount)
	end
end

function string.MaxLen(str, max)
	if #str > max then
		return string.Left(str, max)..'...'
	else
		return str
	end
end

local meta = FindMetaTable('Player')

function meta:CanAfford(amount)
	return self:GetMoney() >= amount
end

function meta:GetMoney()
	return tonumber(self:GetNWString('money'))
end