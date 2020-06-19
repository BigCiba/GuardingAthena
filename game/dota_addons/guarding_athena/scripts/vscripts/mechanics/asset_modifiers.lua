if AssetModifiers == nil then
	AssetModifiers = class({})
end
local public = AssetModifiers

function public:init(bReload)
	if not bReload then
	end

	if IsServer() then
		GameEvent("custom_npc_first_spawned", Dynamic_Wrap(public, "OnNPCFirstSpawned"), public)
	end
end


-- 通过皮肤名字获取单位名字
function public:GetUnitNameBySkinName(sSkinName)
	local tAssetModifiers = KeyValues.AssetModifiersKv[sSkinName]
	if tAssetModifiers ~= nil then
		for _, tAssetModifier in pairs(tAssetModifiers) do
			if tAssetModifier.type == "name" then
				return tAssetModifier.asset
			end
		end
	end
end

-- 获取替换特效
function public:GetParticleReplacement(sParticlePath, hUnit)
	if not IsValid(hUnit) then
		return sParticlePath
	end
	local sSkinName = hUnit.GetSkinName and hUnit:GetSkinName() or ""
	local tAssetModifiers = KeyValues.AssetModifiersKv[sSkinName]
	if tAssetModifiers ~= nil then
		for _, tAssetModifier in pairs(tAssetModifiers) do
			if tAssetModifier.type == "particle" then
				if tAssetModifier.asset == sParticlePath then
					return tAssetModifier.modifier
				end
			end
		end
	end
	return sParticlePath
end

-- 获取替换技能图标
function public:GetAbilityTextureReplacement(sAbilityTexture, hUnit)
	if not IsValid(hUnit) then
		return sAbilityTexture
	end
	local sUnitName = hUnit:GetUnitName()
	local tAssetModifiers = KeyValues.AssetModifiersKv[sUnitName]
	if tAssetModifiers ~= nil then
		for _, tAssetModifier in pairs(tAssetModifiers) do
			if tAssetModifier.type == "ability_icon" then
				if tAssetModifier.asset == sAbilityTexture then
					return tAssetModifier.modifier
				end
			end
		end
	end
	return sAbilityTexture
end

-- 获取替换音效
function public:GetSoundReplacement(sSoundName, hUnit)
	if not IsValid(hUnit) then
		return sSoundName
	end
	local sUnitName = hUnit:GetUnitName()
	local tAssetModifiers = KeyValues.AssetModifiersKv[sUnitName]
	if tAssetModifiers ~= nil then
		for _, tAssetModifier in pairs(tAssetModifiers) do
			if tAssetModifier.type == "sound" then
				if tAssetModifier.asset == sSoundName then
					return tAssetModifier.modifier
				end
			end
		end
	end
	return sSoundName
end

-- 获取替换模型
function public:GetModelReplacement(sModelName, hUnit)
	if not IsValid(hUnit) then
		return sModelName
	end
	local sUnitName = hUnit:GetUnitName()
	local tAssetModifiers = KeyValues.AssetModifiersKv[sUnitName]
	if tAssetModifiers ~= nil then
		for _, tAssetModifier in pairs(tAssetModifiers) do
			if tAssetModifier.type == "model" then
				if tAssetModifier.asset == sModelName then
					return tAssetModifier.modifier
				end
			end
		end
	end
	return sModelName
end

if IsServer() then
	function public:_updateActivityModifier(hUnit)
		if not IsValid(hUnit) then return end
		if hUnit.AssetModifiers_tActivityModifiers == nil then hUnit.AssetModifiers_tActivityModifiers = {} end

		hUnit:ClearActivityModifiers()

		for i = #hUnit.AssetModifiers_tActivityModifiers, 1, -1 do
			hUnit:AddActivityModifier(hUnit.AssetModifiers_tActivityModifiers[i])
		end
	end

	function public:AddActivityModifier(hUnit, sName)
		if not IsValid(hUnit) then return end
		if hUnit.AssetModifiers_tActivityModifiers == nil then hUnit.AssetModifiers_tActivityModifiers = {} end

		table.insert(hUnit.AssetModifiers_tActivityModifiers, sName)

		self:_updateActivityModifier(hUnit)
	end

	function public:RemoveActivityModifier(hUnit, sName)
		if not IsValid(hUnit) then return end
		if hUnit.AssetModifiers_tActivityModifiers == nil then hUnit.AssetModifiers_tActivityModifiers = {} end

		ArrayRemove(hUnit.AssetModifiers_tActivityModifiers, sName)

		self:_updateActivityModifier(hUnit)
	end

	--[[
		监听事件
	]]--
	function public:OnNPCFirstSpawned(tEvents)
		local hSpawnedUnit = EntIndexToHScript(tEvents.entindex)

		if IsValid(hSpawnedUnit) then
			local sUnitName = hSpawnedUnit:GetUnitName()
			local tAssetModifiers = KeyValues.AssetModifiersKv[sUnitName]
			if tAssetModifiers ~= nil then
				for _, tAssetModifier in pairs(tAssetModifiers) do
					if tAssetModifier.type == "activity" then
						self:AddActivityModifier(hSpawnedUnit, tAssetModifier.modifier)
					end
				end
			end
		end
	end
end


return public