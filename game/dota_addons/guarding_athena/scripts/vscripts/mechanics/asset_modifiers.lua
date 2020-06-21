if AssetModifiers == nil then
	AssetModifiers = class({})
end
local public = AssetModifiers

function public:init(bReload)
	if not bReload then
		self.ATTACH_TYPE = {
			point_follow = PATTACH_POINT_FOLLOW
		}
	end

	if IsServer() then
		GameEvent("custom_npc_first_spawned", Dynamic_Wrap(public, "OnNPCFirstSpawned"), public)
	end
end

-- 替换饰品
function public:ReplaceWearables(sSkinName, hUnit)
	local tAssetModifiers = KeyValues.AssetModifiersKv[sSkinName]
	if tAssetModifiers ~= nil then
		-- 移除饰品
		local hModel = hUnit:FirstMoveChild()
		while hModel ~= nil do
			if hModel:GetClassname() ~= "" and hModel:GetClassname() == "dota_item_wearable" and hModel:GetModelName() ~= "" then
				hModel:AddEffects(EF_NODRAW)
			end
			hModel = hModel:NextMovePeer()
		end
		-- 创建饰品
		for _, tAssetModifier in pairs(tAssetModifiers) do
			if tAssetModifier.type == "wearable" then
				local hWearable = SpawnEntityFromTableSynchronous("prop_dynamic", { model = tAssetModifier.modifier, origin = hUnit:GetAbsOrigin() })
				hWearable:FollowEntity(hUnit, true)
				if tAssetModifier.criteria then
					local tColor = string.split(tAssetModifier.criteria, ",")
					hWearable:SetRenderColor(tonumber(tColor[1]), tonumber(tColor[2]), tonumber(tColor[3]))
				end
				if tAssetModifier.skin then
					hWearable:SetSkin(tonumber(tAssetModifier.skin))
				end
				-- 饰品特效
				for _, _tAssetModifier in pairs(tAssetModifiers) do
					if _tAssetModifier.type == "particle_create" and _tAssetModifier.asset == tAssetModifier.modifier then
						local iAttachType = PATTACH_ABSORIGIN_FOLLOW
						if _tAssetModifier.attach_type == "customorigin" then
							iAttachType = PATTACH_CUSTOMORIGIN
						end
						local iParticleID = ParticleManager:CreateParticle(_tAssetModifier.modifier, iAttachType, hWearable)
						if _tAssetModifier.attach_type == "customorigin" then
							for i, tControlPoint in pairs(_tAssetModifier.control_points) do
								ParticleManager:SetParticleControlEnt(iParticleID, tonumber(tControlPoint.control_point_index), hWearable, self.ATTACH_TYPE[tControlPoint.attach_type], tControlPoint.attachment, hWearable:GetAbsOrigin(), false)
							end
						end
						ParticleManager:ReleaseParticleIndex(iParticleID)
					end
				end
			end
		end
	end
end
-- 替换模型
function public:GetEntityModelReplacement(sSkinName)
	local tAssetModifiers = KeyValues.AssetModifiersKv[sSkinName]
	if tAssetModifiers ~= nil then
		for _, tAssetModifier in pairs(tAssetModifiers) do
			if tAssetModifier.type == "entity_model" then
				return tAssetModifier.modifier
			end
		end
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
	local sSkinName = hUnit.GetSkinName and hUnit:GetSkinName() or ""
	local tAssetModifiers = KeyValues.AssetModifiersKv[sSkinName]
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