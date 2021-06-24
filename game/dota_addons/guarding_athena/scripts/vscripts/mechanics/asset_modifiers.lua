if AssetModifiers == nil then
	AssetModifiers = class({})
end
local public = AssetModifiers

function public:init(bReload)
	if not bReload then
		self.ATTACH_TYPE = {
			absorigin_follow = PATTACH_ABSORIGIN_FOLLOW,
			point_follow = PATTACH_POINT_FOLLOW,
			customorigin = PATTACH_CUSTOMORIGIN,
			follow_origin = PATTACH_ABSORIGIN_FOLLOW,
			follow_overhead = PATTACH_OVERHEAD_FOLLOW,
			attach_origin = PATTACH_ABSORIGIN,
			attach_hitloc = PATTACH_POINT,
			follow_hitloc = PATTACH_POINT_FOLLOW,
			start_at_customorigin = PATTACH_CUSTOMORIGIN,
			follow_customorigin = PATTACH_CUSTOMORIGIN_FOLLOW,
			world_origin = PATTACH_WORLDORIGIN,
			follow_eyes = PATTACH_EYES_FOLLOW,
			follow_attachment_substepped = PATTACH_POINT_FOLLOW_SUBSTEPPED,
			rootbone_follow = PATTACH_ROOTBONE_FOLLOW,
		}
	end

	if IsServer() then
		GameEvent("custom_npc_first_spawned", Dynamic_Wrap(public, "OnNPCFirstSpawned"), public)
	end
end

function public:HasWearables(sModelName, hUnit)
	local bHasWearable = false
	local hModel = hUnit:FirstMoveChild()
	while hModel ~= nil do
		if hModel:GetClassname() ~= "" and hModel:GetClassname() == "dota_item_wearable" and hModel:GetModelName() == sModelName then
			bHasWearable = true
			break
		end
		hModel = hModel:NextMovePeer()
	end
	return bHasWearable, hModel
end

---替换饰品
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
		if hUnit._tWearable then
			for _, hModel in ipairs(hUnit._tWearable) do
				UTIL_Remove(hModel)
			end
		end
		-- 创建饰品
		for _, tAssetModifier in pairs(tAssetModifiers) do
			if tAssetModifier.type == "wearable" then
				local bHasWearable, _hModel = self:HasWearables(tAssetModifier.modifier, hUnit)
				if bHasWearable and tAssetModifier.modifier == tAssetModifier.asset then
					_hModel:RemoveEffects(EF_NODRAW)
					if tAssetModifier.skin then
						_hModel:SetSkin(tonumber(tAssetModifier.skin))
					end
					if tAssetModifier.body_group then
						_hModel:SetBodygroupByName("arcana", 2)
					end
				else
					local hWearable = SpawnEntityFromTableSynchronous("prop_dynamic", { model = tAssetModifier.modifier, origin = hUnit:GetAbsOrigin() })
					hWearable:FollowEntity(hUnit, true)
					hUnit._tWearable = hUnit._tWearable or {}
					table.insert(hUnit._tWearable, hWearable)
					if tAssetModifier.criteria then
						local tColor = string.split(tAssetModifier.criteria, ",")
						hWearable:SetRenderColor(tonumber(tColor[1]), tonumber(tColor[2]), tonumber(tColor[3]))
					end
					if tAssetModifier.skin then
						hWearable:SetSkin(tonumber(tAssetModifier.skin))
					end
					if tAssetModifier.body_group then
						hWearable:SetBodygroupByName("arcana", 2)
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
end

---替换技能
function public:ReplaceAbilities(sSkinName, hUnit)
	local tAssetModifiers = KeyValues.AssetModifiersKv[sSkinName]
	if tAssetModifiers ~= nil then
		for _, tAssetModifier in pairs(tAssetModifiers) do
			if tAssetModifier.type == "ability" then
				local hAbility = hUnit:AddAbility(tAssetModifier.modifier)
				hUnit:SwapAbilities(tAssetModifier.modifier, tAssetModifier.asset, true, false)
				hUnit:RemoveAbility(tAssetModifier.asset)
				if hAbility:GetAbilityIndex() == 0 then
					hAbility:SetLevel(1)
				end
			end
		end
	end
end

---替换主体模型
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

---获取主体模型皮肤
function public:GetEntityModelReplacementSkin(sSkinName)
	local tAssetModifiers = KeyValues.AssetModifiersKv[sSkinName]
	if tAssetModifiers ~= nil then
		for _, tAssetModifier in pairs(tAssetModifiers) do
			if tAssetModifier.type == "entity_model" then
				return tAssetModifier.skin
			end
		end
	end
end

---通过皮肤名字获取单位名字
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

---获取替换特效
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

---获取替换技能图标
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

---获取替换音效
function public:GetSoundReplacement(sSoundName, hUnit)
	if not IsValid(hUnit) then
		return sSoundName
	end
	local sSkinName = hUnit.GetSkinName and hUnit:GetSkinName() or ""
	local tAssetModifiers = KeyValues.AssetModifiersKv[sSkinName]
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

---获取替换模型
function public:GetModelReplacement(sModelName, hUnit)
	if not IsValid(hUnit) then
		return sModelName
	end
	local sSkinName = hUnit.GetSkinName and hUnit:GetSkinName() or ""
	local tAssetModifiers = KeyValues.AssetModifiersKv[sSkinName]
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

---获取专属替换
function public:GetScepterReplacement(sScepterName, hUnit)
	if not IsValid(hUnit) then
		return sScepterName
	end
	local sSkinName = hUnit.GetSkinName and hUnit:GetSkinName() or ""
	local tAssetModifiers = KeyValues.AssetModifiersKv[sSkinName]
	if tAssetModifiers ~= nil then
		for _, tAssetModifier in pairs(tAssetModifiers) do
			if tAssetModifier.type == "scepter" then
				if tAssetModifier.asset == sScepterName then
					return tAssetModifier.modifier
				end
			end
		end
	end
	return sScepterName
end

if IsServer() then
	--[[		监听事件
	]]
	--
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