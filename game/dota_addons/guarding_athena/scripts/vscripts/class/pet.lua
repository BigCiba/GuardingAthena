if Pet == nil then
	Pet = class({})
end

function NewPet(...)
	return Pet(...)
end
-- 通用处理
function Pet.init(bReload)
	if not bReload then
		Pet.tPets = {}
	end
end
function Pet.insert(hPet)
	local iIndex = 1
	while Pet.tPets[iIndex] ~= nil do
		iIndex = iIndex + 1
	end
	Pet.tPets[iIndex] = hPet
	return iIndex
end
function Pet.remove(hPet)
	if type(hPet) == "number" then -- 按索引删除
		local iIndex = hPet
		if Pet.tPets[iIndex] ~= nil then
			Pet.tPets[iIndex] = nil
			return true
		end
	else -- 按实例删除
		for iIndex, _hPet in pairs(Pet.tPets) do
			if _hPet == hPet then
				Pet.tPets[iIndex] = nil
				return true
			end
		end
	end
	return false
end

function Pet:constructor(sName, hOwner)
	self.iIndex = Pet.insert(self)

	self.hOwner = hOwner
	self.sName = sName

	self.iLevel = 1
	self.iQuality = 1
	self.iXP = 0

	local hUnit = CreateUnitByName(sName, GetRespawnPosition(), true, self.hOwner, self.hOwner, self.hOwner:GetTeamNumber())

	hUnit.GetMaster = function(hUnit)
		return hOwner
	end
	hUnit.GetPet = function(hUnit)
		return self
	end
	hOwner.GetPet = function (hOwner)
		return hUnit
	end

	local iExp = Service:GetPetExperience(hOwner:GetPlayerOwnerID(), sName)
	local iLevel = 1
	for i, v in ipairs(PET_XP_TABLE) do
		if iExp >= v then
			iLevel = i
		end
	end
	hUnit:CreatureLevelUp(iLevel - 1)
	hUnit:SetControllableByPlayer(self.hOwner:GetPlayerOwnerID(), true)
	hUnit:AddNewModifier(hOwner, nil, "modifier_pet_base", nil)
	for i = 0, 4 do
		local hAbility = hUnit:GetAbilityByIndex(i)
		if IsValid(hAbility) then
			hAbility:SetLevel(iLevel)
			if not hAbility:IsPassive() then
				hAbility:ToggleAutoCast()
			end
			
		end
	end
	-- ambient
	if KeyValues.PetsKv[sName].AmbientEffect ~= nil then
		hUnit:AddNewModifier(hUnit, nil, KeyValues.PetsKv[sName].AmbientEffect, nil)
	end
	-- local sAmbientParticle = KeyValues.PetsKv[sName].AmbientParticle
	-- if sAmbientParticle ~= nil then
	-- 	ParticleManager:CreateParticle(sAmbientParticle, PATTACH_ABSORIGIN_FOLLOW, hUnit)
	-- end
	self.hUnit = hUnit
end
function Pet:RemoveSelf()
	self.hUnit:ForceKill(false)
	UTIL_Remove(self.hUnit)
	Pet.remove(self.iIndex)

	self.hUnit = nil
	self.vLocation = nil
	self.fAngle = nil
	self.hOwner = nil
	self.iLevel = nil
	self.iXP = nil
	self.hBlocker = nil
	self.iIndex = nil
end
function Pet:GetUnitEntity()
	return self.hUnit
end
function Pet:GetUnitEntityName()
	return self.sName
end
function Pet:GetUnitEntityIndex()
	return self.hUnit:entindex()
end
function Pet:GetLevel()
	return self.iLevel
end
function Pet:GetOwner()
	return self.hOwner
end
function Pet:GetPlayerOwnerID()
	if self.hOwner == nil then
		return
	end
	return self.hOwner:GetPlayerOwnerID()
end

return Pet