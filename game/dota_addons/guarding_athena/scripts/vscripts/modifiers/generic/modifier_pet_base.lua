if modifier_pet_base == nil then
	modifier_pet_base = class({}, nil, ModifierBasic)
end
function modifier_pet_base:IsHidden()
	return true
end
function modifier_pet_base:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_pet_base:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end
function modifier_pet_base:OnIntervalThink()
	if IsServer() then
		local hOwner = self:GetCaster()
		local hPet = self:GetParent()
		local flDistance = (hOwner:GetAbsOrigin() - hPet:GetAbsOrigin()):Length2D()
		self:SetStackCount(flDistance)
		if flDistance > 2000 then
			-- 传送
			local vPosition = hOwner:GetAbsOrigin() + RandomVector(256)
			FindClearSpaceForUnit(hPet, vPosition, false)
			hPet:AddNewModifier(hPet, nil, "modifier_stunned", {duration = 0.5})
			local iParticleID = ParticleManager:CreateParticle("particles/econ/items/pets/pet_generic/pet_flee.vpcf", PATTACH_ABSORIGIN, hPet)
			ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
			ParticleManager:ReleaseParticleIndex(iParticleID)
		else
			-- 移动
			local tPosition = {}
			table.insert(tPosition, hOwner:GetAbsOrigin() + RotatePosition(Vector(0, 0, 0), QAngle(0, 45, 0), hOwner:GetForwardVector()) * 256)
			table.insert(tPosition, hOwner:GetAbsOrigin() + RotatePosition(Vector(0, 0, 0), QAngle(0, -45, 0), hOwner:GetForwardVector()) * 256)
			local tDistance = {
				(hPet:GetAbsOrigin() - tPosition[1]):Length2D(),
				(hPet:GetAbsOrigin() - tPosition[2]):Length2D(),
			}
			local vPosition = tDistance[1] < tDistance[2] and tPosition[1] or tPosition[2]
			if not hPet:IsPositionInRange(vPosition, hPet:GetHullRadius()) then
				ExecuteOrderFromTable({
					UnitIndex = hPet:entindex(),
					OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
					Position = vPosition,
				})
			end
		end
	end
end
function modifier_pet_base:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
	}
end
function modifier_pet_base:GetModifierMoveSpeed_Absolute()
	return math.max(self:GetStackCount() * 0.8, 400)
end
function modifier_pet_base:CheckState()
	return {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSLOWABLE] = true,
		[MODIFIER_STATE_UNTARGETABLE] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
end