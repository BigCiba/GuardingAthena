type NetworkedData<T> = T extends string | number
    ? T
    : T extends boolean
    ? 0 | 1
    : T extends (infer U)[]
    ? { [key: number]: NetworkedData<U> }
    : T extends Function // eslint-disable-line @typescript-eslint/ban-types
    ? undefined
    : T extends object
    ? { [K in keyof T]: NetworkedData<T[K]> }
    : never;

/**
 * The type used for validation of custom events.
 *
 * This type may be augmented via interface merging.
 */
interface CustomGameEventDeclarations {}

declare namespace GameEvents {
    type InferCustomGameEventType<T extends string | object, TUntyped> = T extends keyof CustomGameEventDeclarations
        ? CustomGameEventDeclarations[T]
        : T extends string
        ? TUntyped
        : T;

    type InferGameEventType<T extends string | object, TUntyped> = T extends keyof GameEventDeclarations
        ? GameEventDeclarations[T]
        : InferCustomGameEventType<T, TUntyped>;
}

interface CDOTA_PanoramaScript_GameEvents {
    /**
     * Subscribe to a game event.
     * @template T Either a name of the event (inferred automatically) or the type of a custom event.
     *
     * @example
     * // Custom event with separate definition
     * interface CustomGameEventDeclarations {
     *     custom_event: { field: string };
     * }
     *
     * GameEvents.Subscribe("custom_event", event => $.Msg(event.field));
     *
     * @example
     * // Custom event with inline type definition
     * GameEvents.Subscribe<{ field: string }>("custom_event", event => $.Msg(event.field));
     *
     * @example
     * // Builtin event
     * GameEvents.Subscribe("npc_spawned", event => $.Msg(event.entindex));
     */
    Subscribe<T extends string | object>(
        pEventName: (T extends string ? T : string) | keyof CustomGameEventDeclarations | keyof GameEventDeclarations,
        funcVal: (event: NetworkedData<GameEvents.InferGameEventType<T, object>>) => void,
    ): GameEventListenerID;

    /**
     * Unsubscribe from a game event.
     *
     * @param nCallbackHandle Return value of `GameEvents.Subscribe`.
     */
    Unsubscribe(nCallbackHandle: GameEventListenerID): void;

    /**
     * Send a custom game event.
     *
     * @example
     * // Separate definition
     * interface CustomGameEventDeclarations {
     *     custom_event: { field: string };
     * }
     *
     * GameEvents.SendCustomGameEventToServer("custom_event", { field: "foo" });
     *
     * @example
     * // Inline type definition
     * GameEvents.SendCustomGameEventToServer<{ field: string }>("custom_event", { field: "foo" });
     */
    SendCustomGameEventToServer<T extends string | object>(
        pEventName: (T extends string ? T : string) | keyof CustomGameEventDeclarations,
        eventData: GameEvents.InferCustomGameEventType<T, never>,
    ): void;

    /**
     * Send a custom game event to the server, which will send it to all clients.
     */
    SendCustomGameEventToAllClients<T extends string | object>(
        pEventName: (T extends string ? T : string) | keyof CustomGameEventDeclarations,
        eventData: GameEvents.InferCustomGameEventType<T, never>,
    ): void;

    /**
     * Send a custom game event to the server, which will send it to all clients.
     */
    SendCustomGameEventToClient<T extends string | object>(
        pEventName: (T extends string ? T : string) | keyof CustomGameEventDeclarations,
        playerIndex: PlayerID,
        eventData: GameEvents.InferCustomGameEventType<T, never>,
    ): void;

    /**
     * Send a client-side event using gameeventmanager.
     */
    SendEventClientSide<TName extends keyof GameEventDeclarations>(
        pEventName: TName,
        eventData: GameEventDeclarations[TName],
    ): void;
}

/**
 * The type of `Game.CustomUIConfig()`.
 *
 * If you need to declare that a given property exists in `Game.CustomUIConfig()`,
 * this type may be augmented via interface merging.
 */
interface CustomUIConfig {}

type MouseEvent = 'pressed' | 'doublepressed' | 'released' | 'wheeled';

/**
 * 0 - Left
 * 1 - Right
 * 2 - Middle
 * 3 - Mouse 4
 * 4 - Mouse 5
 * 5 - Scroll up
 * 6 - Scroll down
 */
type MouseButton = 0 | 1 | 2 | 3 | 4 | 5 | 6;

/**
 * 1 - Up
 * -1 - Down
 */
type MouseScrollDirection = 1 | -1;

interface ScreenEntity {
    entityIndex: EntityIndex;
    accurateCollision: boolean;
}

interface CDOTA_PanoramaScript_GameUI {
    /**
     * Control whether the default UI is enabled
     */
    SetDefaultUIEnabled(nElementType: number, bVisible: boolean): void;

    /**
     * Get the current UI configuration
     */
    CustomUIConfig(): CustomUIConfig;

    /**
     * Create a minimap ping at the given location
     */
    PingMinimapAtLocation(vec3: [number, number, number]): void;

    /**
     * Install a mouse input filter
     */
    SetMouseCallback(callbackFn: (event: MouseEvent, value: MouseButton | MouseScrollDirection) => boolean): void;

    EnableAliMode(bEnable: boolean, nPort: number, offsetVal: number, flScale: number): void;

    /**
     * Get the current mouse position.
     */
    GetCursorPosition(): [number, number];

    /**
     * Return the entity index of the entity under the given screen position.
     */
    FindScreenEntities(screenPos: [number, number]): ScreenEntity[];

    /**
     * Get the world position of the screen position, or null if the cursor is out of the world.
     */
    GetScreenWorldPosition(screenPos: [number, number]): [number, number, number] | null;

    /**
     * Install a mouse input filter
     */
    WasMousePressed(nButtonNum: MouseButton): boolean;

    /**
     * Install a mouse input filter
     */
    WasMouseDoublePressed(nButtonNum: MouseButton): boolean;

    /**
     * Install a mouse input filter
     */
    IsMouseDown(nButtonNum: MouseButton): boolean;

    /**
     * Is the shift button pressed?
     */
    IsShiftDown(): boolean;

    /**
     * Is the alt button pressed?
     */
    IsAltDown(): boolean;

    /**
     * Is the control button pressed?
     */
    IsControlDown(): boolean;

    /**
     * Get the current UI click interaction mode.
     */
    GetClickBehaviors(): CLICK_BEHAVIORS;

    /**
     * Select a unit, adding it to the group or replacing the current selection.
     */
    SelectUnit(nEntityIndex: EntityIndex, bAddToGroup: boolean): void;

    /**
     * Get the current look at position.
     */
    GetCameraLookAtPosition(): [number, number, number];

    /**
     * Get the current look at position height offset.
     */
    GetCameraLookAtPositionHeightOffset(): number;

    /**
     * Set the minimum camera pitch angle.
     */
    SetCameraPitchMin(flPitchMin: number): void;

    /**
     * Set the maximum camera pitch angle.
     */
    SetCameraPitchMax(flPitchMax: number): void;

    /**
     * Set the camera's yaw.
     */
    SetCameraYaw(flCameraYaw: number): void;

    /**
     * Get the camera's yaw.
     */
    GetCameraYaw(): number;

    /**
     * Offset the camera's look at point.
     */
    SetCameraLookAtPositionHeightOffset(flCameraLookAtHeightOffset: number): void;

    /**
     * Set the camera from a lateral position.
     */
    SetCameraPositionFromLateralLookAtPosition(x: number, y: number): void;

    /**
     * Set whether the camera should automatically adjust to average terrain height.
     */
    SetCameraTerrainAdjustmentEnabled(bEnabled: boolean): void;

    /**
     * Set the camera distance from the look at point.
     */
    SetCameraDistance(flDistance: number): void;

    /**
     * Set the gap between the bottom of the screen and the game rendering viewport. (Value expressed as pixels in a normalized 1024x768 viewport.)
     */
    SetRenderBottomInsetOverride(nInset: number): void;

    /**
     * Set the gap between the top of the screen and the game rendering viewport. (Value expressed as pixels in a normalized 1024x768 viewport.)
     */
    SetRenderTopInsetOverride(nInset: number): void;

    /**
     * Set the camera target for the local player, or -1 to clear.
     */
    SetCameraTarget(nTargetEntIndex: EntityIndex): void;

    /**
     * Set the camera target as position for the local player over specified lerp.
     */
    SetCameraTargetPosition(vec3: [number, number, number], flLerp: number): void;

    /**
     * Converts the specified x,y,z world co-ordinate into an x,y screen coordinate. Will clamp position to always be in front of camera.  Position returned as 0->1.0
     */
    WorldToScreenXYClamped(vec3: [number, number, number]): [number, number, 0];

    /**
     * Get the current players scoreboard score for the specified zone.
     */
    GetPlayerScoreboardScore(pszScoreboardName: string): number;

    /**
     * Send a custom client side error message with passed string and soundevent.
     */
    SendCustomHUDError(pszErrorText: string, pszErrorSound: string): void;

    /**
     * Given a passed ability, replace the special value variables in the passed localized text.
     */
    ReplaceDOTAAbilitySpecialValues(...unknown: any[]): void;
}

/**
 * The type used for validation of custom net tables.
 *
 * This type may be augmented via interface merging.
 */
interface CustomNetTableDeclarations {}

interface CDOTA_PanoramaScript_CustomNetTables {
    /**
     * Get a key from a custom net table
     */
    GetTableValue<
        TName extends keyof CustomNetTableDeclarations,
        T extends CustomNetTableDeclarations[TName],
        K extends keyof T
    >(
        pTableName: TName,
        pKeyName: K,
    ): NetworkedData<T[K]>;

    /**
     * Get all values from a custom net table
     */
    GetAllTableValues<TName extends keyof CustomNetTableDeclarations, T extends CustomNetTableDeclarations[TName]>(
        pTableName: TName,
    ): { [K in keyof T]: { key: K; value: NetworkedData<T[K]> } }[keyof T][];

    /**
     * Register a callback when a particular custom net table changes
     */
    SubscribeNetTableListener<
        TName extends keyof CustomNetTableDeclarations,
        T extends CustomNetTableDeclarations[TName]
    >(
        tableName: TName,
        callback: (tableName: TName, key: keyof T, value: NetworkedData<T[keyof T]>) => void,
    ): NetTableListenerID;

    /**
     * Unsubscribe from a game event
     */
    UnsubscribeNetTableListener(nCallbackHandle: NetTableListenerID): void;
}

interface CDOTA_PanoramaScript_LocalInventory {
    /**
     * Does the player have an inventory item of a given item definition index?
     */
    HasItemByDefinition(nDefIndex: number): boolean;
}

interface CDOTA_PanoramaScript_EventData {
    /**
     * Get the score of an EventAction.
     */
    GetEventActionScore(unEventID: number, unActionID: number): number;

    /**
     * Get a periodic resource value used.
     */
    GetPeriodicResourceUsed(unPeriodicResourceID: number): number;

    /**
     * Get a periodic resource value max.
     */
    GetPeriodicResourceMax(unPeriodicResourceID: number): number;
}

interface CScriptBindingPR_Particles {
    /**
     * Create a particle from a file with an attachment and an owning entity.
     */
    CreateParticle(particleName: string, particleAttach: ParticleAttachment_t, owningEntity: EntityIndex): ParticleID;

    /**
     * Release the index of a particle, will make the particle in-accessible from script. This allows another particle
     * to reuse the freed particle index.
     */
    ReleaseParticleIndex(particle: ParticleID): void;

    /**
     * Destroy a particle. Setting the immediate boolean to true will prevent the endcap from playing.
     */
    DestroyParticleEffect(particle: ParticleID, immediate: boolean): void;

    /**
     * Set a particle's control point to a vector value.
     */
    SetParticleControl(particle: ParticleID, controlPoint: number, value: [number, number, number]): void;

    /**
     * Set a particle's forward control point to a vector value.
     */
    SetParticleControlForward(particle: ParticleID, controlPoint: number, value: [number, number, number]): void;

    /**
     * Unknown use, any info welcome.
     */
    SetParticleAlwaysSimulate(particle: ParticleID): void;

    /**
     * Set a particle's control point to an entity's attachment.
     *
     * @example
     * Particles.SetParticleControlEnt(particle, 0, entity, ParticleAttachment_t.PATTACH_POINT_FOLLOW, "attach_hitloc", [0, 0, 0], true);
     */
    SetParticleControlEnt(
        particle: ParticleID,
        controlPoint: number,
        entity: EntityIndex,
        particleAttach: ParticleAttachment_t,
        attachmentName: string,
        offset: [number, number, number],
        unknown: boolean,
    ): void;
}

interface CScriptBindingPR_Buffs {
    /**
     * Returns the name of the modifier.
     */
    GetName(nEntityIndex: EntityIndex, nBuffIndex: BuffID): string;

    /**
     * Returns the classname of the modifier.
     */
    GetClass(nEntityIndex: EntityIndex, nBuffIndex: BuffID): string;

    /**
     * Returns the modifier icon texture.
     */
    GetTexture(nEntityIndex: EntityIndex, nBuffIndex: BuffID): string;

    /**
     * Returns the total duration of the modifier.
     */
    GetDuration(nEntityIndex: EntityIndex, nBuffIndex: BuffID): number;

    /**
     * Returns the time at which the modifier will expire.
     */
    GetDieTime(nEntityIndex: EntityIndex, nBuffIndex: BuffID): number;

    /**
     * Returns the time until the modifier expires.
     */
    GetRemainingTime(nEntityIndex: EntityIndex, nBuffIndex: BuffID): number;

    /**
     * Returns the time elapsed since the creation of the modifier.
     */
    GetElapsedTime(nEntityIndex: EntityIndex, nBuffIndex: BuffID): number;

    /**
     * Returns the time at which the modifier was created.
     */
    GetCreationTime(nEntityIndex: EntityIndex, nBuffIndex: BuffID): number;

    /**
     * Returns the keybind (as a string) for the specified ability.
     */
    GetStackCount(nEntityIndex: EntityIndex, nBuffIndex: BuffID): number;

    /**
     * Returns true if the modifier is a debuff (red icon), false otherwise.
     */
    IsDebuff(nEntityIndex: EntityIndex, nBuffIndex: BuffID): boolean;

    /**
     * Returns the keybind (as a string) for the specified ability.
     */
    IsHidden(nEntityIndex: EntityIndex, nBuffIndex: BuffID): boolean;

    /**
     * Returns the entity that created the modifier (possibly on another entity).
     */
    GetCaster(nEntityIndex: EntityIndex, nBuffIndex: BuffID): EntityIndex;

    /**
     * Returns the entity to which the modifier is applied.
     */
    GetParent(nEntityIndex: EntityIndex, nBuffIndex: BuffID): EntityIndex;

    /**
     * Returns the ability associated with the modifier.
     */
    GetAbility(nEntityIndex: EntityIndex, nBuffIndex: BuffID): AbilityEntityIndex;
}

interface CScriptBindingPR_Players {
    /**
     * Get the maximum number of players in the game.
     */
    GetMaxPlayers(): number;

    /**
     * Get the maximum number of players on teams.
     */
    GetMaxTeamPlayers(): number;

    /**
     * Get the local player ID.
     */
    GetLocalPlayer(): PlayerID;

    /**
     * Is the nth player a valid player?
     */
    IsValidPlayerID(iPlayerID: PlayerID): boolean;

    /**
     * Return the name of a player.
     */
    GetPlayerName(iPlayerID: PlayerID): string;

    /**
     * Get the entity index of the hero controlled by this player.
     */
    GetPlayerHeroEntityIndex(iPlayerID: PlayerID): EntityIndex;

    /**
     * Get the entities this player has selected.
     */
    GetSelectedEntities(iPlayerID: PlayerID): EntityIndex[];

    /**
     * Get the entities this player is querying.
     */
    GetQueryUnit(iPlayerID: PlayerID): EntityIndex;

    /**
     * Get local player current portrait unit. (ie. Player's hero or primary selected unit.)
     */
    GetLocalPlayerPortraitUnit(): EntityIndex;

    /**
     * Can the player buy back?
     */
    CanPlayerBuyback(iPlayerID: PlayerID): boolean;

    /**
     * Does this player have a custom game ticket?
     */
    HasCustomGameTicketForPlayerID(iPlayerID: PlayerID): boolean;

    /**
     * The number of assists credited to a player.
     */
    GetAssists(iPlayerID: PlayerID): number;

    GetClaimedDenies(iPlayerID: PlayerID): number;

    GetClaimedMisses(iPlayerID: PlayerID): number;

    /**
     * The number of deaths a player has suffered.
     */
    GetDeaths(iPlayerID: PlayerID): number;

    /**
     * The number of denies credited to a player.
     */
    GetDenies(iPlayerID: PlayerID): number;

    /**
     * The amount of gold a player has.
     */
    GetGold(iPlayerID: PlayerID): number;

    /**
     * The number of kills credited to a player.
     */
    GetKills(iPlayerID: PlayerID): number;

    GetLastBuybackTime(iPlayerID: PlayerID): number;

    GetLastHitMultikill(iPlayerID: PlayerID): number;

    /**
     * The number of last hits credited to a player.
     */
    GetLastHits(iPlayerID: PlayerID): number;

    GetLastHitStreak(iPlayerID: PlayerID): number;

    /**
     * The current level of a player.
     */
    GetLevel(iPlayerID: PlayerID): number;

    GetMisses(iPlayerID: PlayerID): number;

    GetNearbyCreepDeaths(iPlayerID: PlayerID): number;

    /**
     * Total reliable gold for this player.
     */
    GetReliableGold(iPlayerID: PlayerID): number;

    GetRespawnSeconds(iPlayerID: PlayerID): number;

    GetStreak(iPlayerID: PlayerID): number;

    /**
     * Total gold earned in this game by this player.
     */
    GetTotalEarnedGold(iPlayerID: PlayerID): number;

    /**
     * Total xp earned in this game by this player.
     */
    GetTotalEarnedXP(iPlayerID: PlayerID): number;

    /**
     * Total unreliable gold for this player.
     */
    GetUnreliableGold(iPlayerID: PlayerID): number;

    /**
     * Get the team this player is on.
     */
    GetTeam(iPlayerID: PlayerID): DOTATeam_t;

    /**
     * Average gold earned per minute for this player.
     */
    GetGoldPerMin(iPlayerID: PlayerID): number;

    /**
     * Average xp earned per minute for this player.
     */
    GetXPPerMin(iPlayerID: PlayerID): number;

    /**
     * Return the name of the hero a player is controlling.
     */
    GetPlayerSelectedHero(iPlayerID: PlayerID): string;

    /**
     * Get the player color.
     */
    GetPlayerColor(iPlayerID: PlayerID): number;

    /**
     * Is this player a spectator.
     */
    IsSpectator(iPlayerID: PlayerID): boolean;

    PlayerPortraitClicked(nClickedPlayerID: PlayerID, bHoldingCtrl: boolean, bHoldingAlt: boolean): void;

    BuffClicked(nEntity: EntityIndex, nBuffSerial: number, bAlert: boolean): void;

    /**
     * If player is in perspective camera, returns true. Else, false
     */
    IsLocalPlayerInPerspectiveCamera(): boolean;

    /**
     * If player is in perspective mode, returns the followed players entity index.  Else, -1.
     */
    GetPerspectivePlayerEntityIndex(): EntityIndex;

    /**
     * If player is in perspective mode, returns the followed players id.  Else, -1.
     */
    GetPerspectivePlayerId(): PlayerID;
}

interface CScriptBindingPR_Entities {
    /**
     * Get the world origin of the entity.
     */
    GetAbsOrigin(nEntityIndex: EntityIndex): [number, number, number];

    /**
     * Get the forward vector of the entity.
     */
    GetForward(nEntityIndex: EntityIndex): [number, number, number];

    /**
     * Get the right vector of the entity.
     */
    GetRight(nEntityIndex: EntityIndex): [number, number, number];

    /**
     * Get the up vector of the entity.
     */
    GetUp(nEntityIndex: EntityIndex): [number, number, number];

    /**
     * Get all the building entities.
     */
    GetAllBuildingEntities(): EntityIndex[];

    /**
     * Get all the hero entities.
     */
    GetAllHeroEntities(): EntityIndex[];

    /**
     * Get all the entities with a given name.
     */
    GetAllEntitiesByName(pszName: string): EntityIndex[];

    /**
     * Get all the entities with a given classname.
     */
    GetAllEntitiesByClassname(pszName: string): EntityIndex[];

    /**
     * Get all the creature entities.
     */
    GetAllCreatureEntities(): EntityIndex[];

    /**
     * Get all the entities.
     */
    GetAllEntities(): EntityIndex[];

    /**
     * Get the ID of the player owning the given entity.
     */
    GetPlayerOwnerID(nEntityIndex: EntityIndex): PlayerID;

    CanBeDominated(nEntityIndex: EntityIndex): boolean;

    HasAttackCapability(nEntityIndex: EntityIndex): boolean;

    HasCastableAbilities(nEntityIndex: EntityIndex): boolean;

    HasFlyingVision(nEntityIndex: EntityIndex): boolean;

    HasFlyMovementCapability(nEntityIndex: EntityIndex): boolean;

    HasGroundMovementCapability(nEntityIndex: EntityIndex): boolean;

    HasMovementCapability(nEntityIndex: EntityIndex): boolean;

    HasScepter(nEntityIndex: EntityIndex): boolean;

    HasUpgradeableAbilities(nEntityIndex: EntityIndex): boolean;

    HasUpgradeableAbilitiesThatArentMaxed(nEntityIndex: EntityIndex): boolean;

    IsAlive(nEntityIndex: EntityIndex): boolean;

    IsAncient(nEntityIndex: EntityIndex): boolean;

    IsAttackImmune(nEntityIndex: EntityIndex): boolean;

    IsBarracks(nEntityIndex: EntityIndex): boolean;

    IsBlind(nEntityIndex: EntityIndex): boolean;

    IsBoss(nEntityIndex: EntityIndex): boolean;

    IsRoshan(nEntityIndex: EntityIndex): boolean;

    IsBuilding(nEntityIndex: EntityIndex): boolean;

    IsCommandRestricted(nEntityIndex: EntityIndex): boolean;

    IsConsideredHero(nEntityIndex: EntityIndex): boolean;

    IsControllableByAnyPlayer(nEntityIndex: EntityIndex): boolean;

    IsCourier(nEntityIndex: EntityIndex): boolean;

    IsCreature(nEntityIndex: EntityIndex): boolean;

    IsCreep(nEntityIndex: EntityIndex): boolean;

    IsCreepHero(nEntityIndex: EntityIndex): boolean;

    IsDeniable(nEntityIndex: EntityIndex): boolean;

    IsDominated(nEntityIndex: EntityIndex): boolean;

    IsEnemy(nEntityIndex: EntityIndex): boolean;

    IsEvadeDisabled(nEntityIndex: EntityIndex): boolean;

    IsFort(nEntityIndex: EntityIndex): boolean;

    IsFrozen(nEntityIndex: EntityIndex): boolean;

    IsGeneratedByEconItem(nEntityIndex: EntityIndex): boolean;

    IsHallofFame(nEntityIndex: EntityIndex): boolean;

    IsDisarmed(nEntityIndex: EntityIndex): boolean;

    IsHero(nEntityIndex: EntityIndex): boolean;

    IsHexed(nEntityIndex: EntityIndex): boolean;

    IsIllusion(nEntityIndex: EntityIndex): boolean;

    IsInRangeOfFountain(nEntityIndex: EntityIndex): boolean;

    IsInventoryEnabled(nEntityIndex: EntityIndex): boolean;

    IsInvisible(nEntityIndex: EntityIndex): boolean;

    IsInvulnerable(nEntityIndex: EntityIndex): boolean;

    IsLaneCreep(nEntityIndex: EntityIndex): boolean;

    IsLowAttackPriority(nEntityIndex: EntityIndex): boolean;

    IsMagicImmune(nEntityIndex: EntityIndex): boolean;

    IsMuted(nEntityIndex: EntityIndex): boolean;

    IsNeutralUnitType(nEntityIndex: EntityIndex): boolean;

    IsNightmared(nEntityIndex: EntityIndex): boolean;

    IsOther(nEntityIndex: EntityIndex): boolean;

    IsOutOfGame(nEntityIndex: EntityIndex): boolean;

    IsOwnedByAnyPlayer(nEntityIndex: EntityIndex): boolean;

    IsPhantom(nEntityIndex: EntityIndex): boolean;

    IsRangedAttacker(nEntityIndex: EntityIndex): boolean;

    IsRealHero(nEntityIndex: EntityIndex): boolean;

    IsRooted(nEntityIndex: EntityIndex): boolean;

    IsSelectable(nEntityIndex: EntityIndex): boolean;

    IsShop(nEntityIndex: EntityIndex): boolean;

    IsSilenced(nEntityIndex: EntityIndex): boolean;

    IsSpeciallyDeniable(nEntityIndex: EntityIndex): boolean;

    IsStunned(nEntityIndex: EntityIndex): boolean;

    IsSummoned(nEntityIndex: EntityIndex): boolean;

    IsTower(nEntityIndex: EntityIndex): boolean;

    IsUnselectable(nEntityIndex: EntityIndex): boolean;

    IsWard(nEntityIndex: EntityIndex): boolean;

    IsZombie(nEntityIndex: EntityIndex): boolean;

    NoHealthBar(nEntityIndex: EntityIndex): boolean;

    NoTeamMoveTo(nEntityIndex: EntityIndex): boolean;

    NoTeamSelect(nEntityIndex: EntityIndex): boolean;

    NotOnMinimap(nEntityIndex: EntityIndex): boolean;

    NotOnMinimapForEnemies(nEntityIndex: EntityIndex): boolean;

    NoUnitCollision(nEntityIndex: EntityIndex): boolean;

    PassivesDisabled(nEntityIndex: EntityIndex): boolean;

    ProvidesVision(nEntityIndex: EntityIndex): boolean;

    UsesHeroAbilityNumbers(nEntityIndex: EntityIndex): boolean;

    IsMoving(nEntityIndex: EntityIndex): boolean;

    GetAbilityCount(nEntityIndex: EntityIndex): number;

    GetCombatClassAttack(nEntityIndex: EntityIndex): number;

    GetCombatClassDefend(nEntityIndex: EntityIndex): number;

    GetCurrentVisionRange(nEntityIndex: EntityIndex): number;

    GetDamageBonus(nEntityIndex: EntityIndex): number;

    GetDamageMax(nEntityIndex: EntityIndex): number;

    GetDamageMin(nEntityIndex: EntityIndex): number;

    GetDayTimeVisionRange(nEntityIndex: EntityIndex): number;

    GetHealth(nEntityIndex: EntityIndex): number;

    GetHealthPercent(nEntityIndex: EntityIndex): number;

    GetHealthThinkRegen(nEntityIndex: EntityIndex): number;

    GetLevel(nEntityIndex: EntityIndex): number;

    GetMaxHealth(nEntityIndex: EntityIndex): number;

    GetNightTimeVisionRange(nEntityIndex: EntityIndex): number;

    GetStates(nEntityIndex: EntityIndex): modifierstate[];

    GetTotalPurchasedUpgradeGoldCost(nEntityIndex: EntityIndex): number;

    GetTeamNumber(nEntityIndex: EntityIndex): DOTATeam_t;

    GetHealthBarOffset(nEntityIndex: EntityIndex): number;

    GetAttackRange(nEntityIndex: EntityIndex): number;

    GetAttackSpeed(nEntityIndex: EntityIndex): number;

    GetAttacksPerSecond(nEntityIndex: EntityIndex): number;

    GetBaseAttackTime(nEntityIndex: EntityIndex): number;

    GetBaseMagicalResistanceValue(nEntityIndex: EntityIndex): number;

    GetBaseMoveSpeed(nEntityIndex: EntityIndex): number;

    GetBonusPhysicalArmor(nEntityIndex: EntityIndex): number;

    GetCollisionPadding(nEntityIndex: EntityIndex): number;

    GetEffectiveInvisibilityLevel(nEntityIndex: EntityIndex): number;

    GetHasteFactor(nEntityIndex: EntityIndex): number;

    GetHullRadius(nEntityIndex: EntityIndex): number;

    GetIdealSpeed(nEntityIndex: EntityIndex): number;

    GetIncreasedAttackSpeed(nEntityIndex: EntityIndex): number;

    GetMana(nEntityIndex: EntityIndex): number;

    GetManaThinkRegen(nEntityIndex: EntityIndex): number;

    GetMaxMana(nEntityIndex: EntityIndex): number;

    GetMagicalArmorValue(nEntityIndex: EntityIndex): number;

    GetPaddedCollisionRadius(nEntityIndex: EntityIndex): number;

    GetPercentInvisible(nEntityIndex: EntityIndex): number;

    GetPhysicalArmorValue(nEntityIndex: EntityIndex): number;

    GetProjectileCollisionSize(nEntityIndex: EntityIndex): number;

    /**
     * Returns the radius of the bounding ring of the unit.
     */
    GetRingRadius(nEntityIndex: EntityIndex): number;

    GetSecondsPerAttack(nEntityIndex: EntityIndex): number;

    ManaFraction(nEntityIndex: EntityIndex): number;

    GetClassname(nEntityIndex: EntityIndex): string;

    GetDisplayedUnitName(nEntityIndex: EntityIndex): string;

    GetSelectionGroup(nEntityIndex: EntityIndex): string;

    GetSoundSet(nEntityIndex: EntityIndex): string;

    GetUnitLabel(nEntityIndex: EntityIndex): string;

    GetUnitName(nEntityIndex: EntityIndex): string;

    GetTotalDamageTaken(nEntityIndex: EntityIndex): number;

    IsControllableByPlayer(nEntityIndex: EntityIndex, nPlayerIndex: PlayerID): boolean;

    GetChosenTarget(nEntityIndex: EntityIndex): number;

    HasItemInInventory(nEntityIndex: EntityIndex, pItemName: string): boolean;

    GetRangeToUnit(nEntityIndex: EntityIndex, nEntityIndex2: EntityIndex): number;

    IsEntityInRange(nEntityIndex: EntityIndex, nEntityIndex2: EntityIndex, flRange: number): boolean;

    GetMoveSpeedModifier(nEntityIndex: EntityIndex, flBaseSpeed: number): number;

    CanAcceptTargetToAttack(nEntityIndex: EntityIndex, nEntityIndex2: EntityIndex): boolean;

    InState(nEntityIndex: EntityIndex, nState: modifierstate): boolean;

    GetArmorForDamageType(nEntityIndex: EntityIndex, iDamageType: DAMAGE_TYPES): number;

    GetArmorReductionForDamageType(nEntityIndex: EntityIndex, iDamageType: DAMAGE_TYPES): number;

    IsInRangeOfShop(nEntityIndex: EntityIndex, iShopType: number, bSpecific: boolean): boolean;

    GetNumItemsInStash(nEntityIndex: EntityIndex): number;

    GetNumItemsInInventory(nEntityIndex: EntityIndex): number;

    GetItemInSlot(nEntityIndex: EntityIndex, nSlotIndex: number): ItemEntityIndex;

    GetAbility(nEntityIndex: EntityIndex, nSlotIndex: number): AbilityEntityIndex;

    GetAbilityByName(nEntityIndex: EntityIndex, pszAbilityName: string): AbilityEntityIndex;

    GetNumBuffs(nEntityIndex: EntityIndex): number;

    GetBuff(nEntityIndex: EntityIndex, nBufIndex: number): BuffID;

    GetAbilityPoints(nEntityIndex: EntityIndex): number;

    GetCurrentXP(nEntityIndex: EntityIndex): number;

    GetNeededXPToLevel(nEntityIndex: EntityIndex): number;

    /**
     * Get the currently selected entities
     */
    GetSelectionEntities(): EntityIndex[];

    /**
     * Is this a valid entity index?
     */
    IsValidEntity(nEntityIndex: EntityIndex): boolean;

    /**
     * Is this entity an item container in the world?
     */
    IsItemPhysical(nEntityIndex: EntityIndex): boolean;

    /**
     * Get the item contained in this physical item container.
     */
    GetContainedItem(nEntityIndex: EntityIndex): ItemEntityIndex;
}

interface CScriptBindingPR_Abilities {
    GetAbilityName(nEntityIndex: AbilityEntityIndex): string;

    GetAbilityTextureName(nEntityIndex: AbilityEntityIndex): string;

    GetAssociatedPrimaryAbilities(nEntityIndex: AbilityEntityIndex): AbilityEntityIndex[];

    GetAssociatedSecondaryAbilities(nEntityIndex: AbilityEntityIndex): AbilityEntityIndex[];

    GetHotkeyOverride(nEntityIndex: AbilityEntityIndex): string;

    GetIntrinsicModifierName(nEntityIndex: AbilityEntityIndex): string;

    GetSharedCooldownName(nEntityIndex: AbilityEntityIndex): string;

    AbilityReady(nEntityIndex: AbilityEntityIndex): number;

    /**
     * Returns an AbilityLearnResult_t
     */
    CanAbilityBeUpgraded(nEntityIndex: AbilityEntityIndex): AbilityLearnResult_t;

    CanBeExecuted(nEntityIndex: AbilityEntityIndex): boolean;

    GetAbilityDamage(nEntityIndex: AbilityEntityIndex): number;

    GetAbilityDamageType(nEntityIndex: AbilityEntityIndex): number;

    GetAbilityTargetFlags(nEntityIndex: AbilityEntityIndex): number;

    GetAbilityTargetTeam(nEntityIndex: AbilityEntityIndex): number;

    GetAbilityTargetType(nEntityIndex: AbilityEntityIndex): number;

    GetAbilityType(nEntityIndex: AbilityEntityIndex): number;

    GetBehavior(nEntityIndex: AbilityEntityIndex): number;

    GetCastRange(nEntityIndex: AbilityEntityIndex): number;

    GetChannelledManaCostPerSecond(nEntityIndex: AbilityEntityIndex): number;

    GetCurrentCharges(nEntityIndex: AbilityEntityIndex): number;

    GetEffectiveLevel(nEntityIndex: AbilityEntityIndex): number;

    GetHeroLevelRequiredToUpgrade(nEntityIndex: AbilityEntityIndex): number;

    GetLevel(nEntityIndex: AbilityEntityIndex): number;

    GetManaCost(nEntityIndex: AbilityEntityIndex): number;

    GetMaxLevel(nEntityIndex: AbilityEntityIndex): number;

    AttemptToUpgrade(nEntityIndex: AbilityEntityIndex): boolean;

    CanLearn(nEntityIndex: AbilityEntityIndex): boolean;

    GetAutoCastState(nEntityIndex: AbilityEntityIndex): boolean;

    GetToggleState(nEntityIndex: AbilityEntityIndex): boolean;

    HasScepterUpgradeTooltip(nEntityIndex: AbilityEntityIndex): boolean;

    IsActivated(nEntityIndex: AbilityEntityIndex): boolean;

    IsActivatedChanging(nEntityIndex: AbilityEntityIndex): boolean;

    IsAttributeBonus(nEntityIndex: AbilityEntityIndex): boolean;

    IsAutocast(nEntityIndex: AbilityEntityIndex): boolean;

    IsCooldownReady(nEntityIndex: AbilityEntityIndex): boolean;

    IsDisplayedAbility(nEntityIndex: AbilityEntityIndex): boolean;

    IsHidden(nEntityIndex: AbilityEntityIndex): boolean;

    IsHiddenWhenStolen(nEntityIndex: AbilityEntityIndex): boolean;

    IsInAbilityPhase(nEntityIndex: AbilityEntityIndex): boolean;

    IsItem(nEntityIndex: AbilityEntityIndex): boolean;

    IsMarkedAsDirty(nEntityIndex: AbilityEntityIndex): boolean;

    IsMuted(nEntityIndex: AbilityEntityIndex): boolean;

    IsOnCastbar(nEntityIndex: AbilityEntityIndex): boolean;

    IsOnLearnbar(nEntityIndex: AbilityEntityIndex): boolean;

    IsOwnersGoldEnough(nEntityIndex: AbilityEntityIndex): boolean;

    IsOwnersGoldEnoughForUpgrade(nEntityIndex: AbilityEntityIndex): boolean;

    IsOwnersManaEnough(nEntityIndex: AbilityEntityIndex): boolean;

    IsPassive(nEntityIndex: AbilityEntityIndex): boolean;

    IsRecipe(nEntityIndex: AbilityEntityIndex): boolean;

    IsSharedWithTeammates(nEntityIndex: AbilityEntityIndex): boolean;

    IsStealable(nEntityIndex: AbilityEntityIndex): boolean;

    IsStolen(nEntityIndex: AbilityEntityIndex): boolean;

    IsToggle(nEntityIndex: AbilityEntityIndex): boolean;

    GetAOERadius(nEntityIndex: AbilityEntityIndex): number;

    GetBackswingTime(nEntityIndex: AbilityEntityIndex): number;

    GetCastPoint(nEntityIndex: AbilityEntityIndex): number;

    GetChannelStartTime(nEntityIndex: AbilityEntityIndex): number;

    GetChannelTime(nEntityIndex: AbilityEntityIndex): number;

    GetCooldown(nEntityIndex: AbilityEntityIndex): number;

    GetCooldownLength(nEntityIndex: AbilityEntityIndex): number;

    GetCooldownTime(nEntityIndex: AbilityEntityIndex): number;

    GetCooldownTimeRemaining(nEntityIndex: AbilityEntityIndex): number;

    GetDuration(nEntityIndex: AbilityEntityIndex): number;

    GetUpgradeBlend(nEntityIndex: AbilityEntityIndex): number;

    /**
     * Get the local player's current active ability. (Pre-cast targetting state.)
     */
    GetLocalPlayerActiveAbility(): AbilityEntityIndex;

    GetCaster(nAbilityIndex: AbilityEntityIndex): EntityIndex;

    GetCustomValueFor(nAbilityIndex: AbilityEntityIndex, pszAbilityVarName: string): number;

    GetLevelSpecialValueFor(nAbilityIndex: AbilityEntityIndex, szName: string, nLevel: number): number;

    GetSpecialValueFor(nAbilityIndex: AbilityEntityIndex, szName: string): number;

    IsCosmetic(nAbilityIndex: AbilityEntityIndex, nTargetEntityIndex: EntityIndex): boolean;

    /**
     * Attempt to execute the specified ability (Equivalent to clicking the ability in the HUD action bar)
     */
    ExecuteAbility(nAbilityEntIndex: AbilityEntityIndex, nCasterEntIndex: EntityIndex, bIsQuickCast: boolean): boolean;

    /**
     * Attempt to double-tap (self-cast) the specified ability (Equivalent to double-clicking the ability in the HUD action bar)
     */
    CreateDoubleTapCastOrder(nAbilityEntIndex: AbilityEntityIndex, nCasterEntIndex: EntityIndex): void;

    /**
     * Ping the specified ability (Equivalent to alt-clicking the ability in the HUD action bar)
     */
    PingAbility(nAbilityIndex: AbilityEntityIndex): void;

    /**
     * Returns the keybind (as a string) for the specified ability.
     */
    GetKeybind(nAbilityEntIndex: AbilityEntityIndex): string;
}

interface CScriptBindingPR_Items {
    ShouldDisplayCharges(nEntityIndex: ItemEntityIndex): boolean;

    AlwaysDisplayCharges(nEntityIndex: ItemEntityIndex): boolean;

    ShowSecondaryCharges(nEntityIndex: ItemEntityIndex): boolean;

    CanBeSoldByLocalPlayer(nEntityIndex: ItemEntityIndex): boolean;

    CanDoubleTapCast(nEntityIndex: ItemEntityIndex): boolean;

    ForceHideCharges(nEntityIndex: ItemEntityIndex): boolean;

    IsAlertableItem(nEntityIndex: ItemEntityIndex): boolean;

    IsCastOnPickup(nEntityIndex: ItemEntityIndex): boolean;

    IsDisassemblable(nEntityIndex: ItemEntityIndex): boolean;

    IsDroppable(nEntityIndex: ItemEntityIndex): boolean;

    IsInnatelyDisassemblable(nEntityIndex: ItemEntityIndex): boolean;

    IsKillable(nEntityIndex: ItemEntityIndex): boolean;

    IsMuted(nEntityIndex: ItemEntityIndex): boolean;

    IsPermanent(nEntityIndex: ItemEntityIndex): boolean;

    IsPurchasable(nEntityIndex: ItemEntityIndex): boolean;

    IsRecipe(nEntityIndex: ItemEntityIndex): boolean;

    IsRecipeGenerated(nEntityIndex: ItemEntityIndex): boolean;

    IsSellable(nEntityIndex: ItemEntityIndex): boolean;

    IsStackable(nEntityIndex: ItemEntityIndex): boolean;

    ProRatesChargesWhenSelling(nEntityIndex: ItemEntityIndex): boolean;

    RequiresCharges(nEntityIndex: ItemEntityIndex): boolean;

    CanBeExecuted(nEntityIndex: ItemEntityIndex): number;

    GetCost(nEntityIndex: ItemEntityIndex): number;

    GetCurrentCharges(nEntityIndex: ItemEntityIndex): number;

    GetSecondaryCharges(nEntityIndex: ItemEntityIndex): number;

    GetDisplayedCharges(nEntityIndex: ItemEntityIndex): number;

    GetInitialCharges(nEntityIndex: ItemEntityIndex): number;

    GetItemColor(nEntityIndex: ItemEntityIndex): number;

    GetShareability(nEntityIndex: ItemEntityIndex): EShareAbility;

    GetAbilityTextureSF(nEntityIndex: ItemEntityIndex): string;

    GetAssembledTime(nEntityIndex: ItemEntityIndex): number;

    GetPurchaseTime(nEntityIndex: ItemEntityIndex): number;

    GetPurchaser(nItemID: ItemEntityIndex): EntityIndex;

    /**
     * Attempt to have the local player disassemble the specified item. Returns false if the order wasn't issued.
     */
    LocalPlayerDisassembleItem(nItem: ItemEntityIndex): boolean;

    /**
     * Attempt to have the local player drop the specified item from its stash. Returns false if the order wasn't issued.
     */
    LocalPlayerDropItemFromStash(nItem: ItemEntityIndex): boolean;

    /**
     * Attempt to have the local player alert allies about the specified item. Returns false if the order wasn't issued.
     */
    LocalPlayerItemAlertAllies(nItem: ItemEntityIndex): boolean;

    /**
     * Attempt to have the local player move the specified item to its stash. Returns false if the order wasn't issued.
     */
    LocalPlayerMoveItemToStash(nItem: ItemEntityIndex): boolean;

    /**
     * Attempt to have the local player sell the specified item. Returns false if the order wasn't issued.
     */
    LocalPlayerSellItem(nItem: ItemEntityIndex): boolean;
}

interface TeamDetails {
    team_id: DOTATeam_t;
    team_name: string;
    team_max_players: number;
    team_score: number;
    team_num_players: number;
}

interface PlayerInfo {
    player_id: PlayerID;
    player_name: string;
    player_connection_state: DOTAConnectionState_t;
    player_steamid: string;
    player_kills: number;
    player_deaths: number;
    player_assists: number;
    player_selected_hero_id: HeroID;
    player_selected_hero: string;
    player_selected_hero_entity_index: EntityIndex;
    possible_hero_selection: string;
    player_level: number;
    player_respawn_seconds: number;
    player_gold: number;
    player_team_id: DOTATeam_t;
    player_is_local: boolean;
    player_has_host_privileges: boolean;
}

interface MapInfo {
    map_name: string;
    map_display_name: string;
}

interface PrepareUnitOrdersArgument {
    OrderType: dotaunitorder_t;
    TargetIndex?: number;
    Position?: [number, number, number];
    AbilityIndex?: number;
    OrderIssuer?: PlayerOrderIssuer_t;
    UnitIndex?: number;
    QueueBehavior?: OrderQueueBehavior_t;
    ShowEffects?: boolean;
}

interface CScriptBindingPR_Game {
    Time(): number;

    GetGameTime(): number;

    GetGameFrameTime(): number;

    GetDOTATime(bIncludePreGame: boolean, bIncludeNegativeTime: boolean): number;

    IsGamePaused(): boolean;

    IsInToolsMode(): boolean;

    IsInBanPhase(): boolean;

    /**
     * Return the team id of the winning team.
     */
    GetGameWinner(): DOTATeam_t;

    GetStateTransitionTime(): number;

    /**
     * Get the difficulty setting of the game.
     */
    GetCustomGameDifficulty(): number;

    /**
     * Returns true if the user has enabled flipped HUD
     */
    IsHUDFlipped(): boolean;

    /**
     * Returns the width of the display.
     */
    GetScreenWidth(): number;

    /**
     * Returns the height of the display.
     */
    GetScreenHeight(): number;

    /**
     * Converts the specified x,y,z world co-ordinate into an x screen coordinate. Returns -1 if behind the camera
     */
    WorldToScreenX(x: number, y: number, z: number): number;

    /**
     * Converts the specified x,y,z world co-ordinate into a y screen coordinate. Returns -1 if behind the camera
     */
    WorldToScreenY(x: number, y: number, z: number): number;

    /**
     * Converts the specified x, y screen coordinates into a x, y, z world coordinates.
     */
    ScreenXYToWorld(nX: number, nY: number): [number, number, number];

    /**
     * Returns the keybind (as a string) for the requested ability slot.
     */
    GetKeybindForAbility(iSlot: number): string;

    /**
     * Returns the keybind (as a string) for the requested inventory slot.
     */
    GetKeybindForInventorySlot(iSlot: number): string;

    /**
     * Returns the keybind (as a string).
     */
    GetKeybindForCommand(nCommand: DOTAKeybindCommand_t): string;

    GetNianFightTimeLeft(): number;

    GetState(): DOTA_GameState;

    GameStateIs(nState: DOTA_GameState): boolean;

    GameStateIsBefore(nState: DOTA_GameState): boolean;

    GameStateIsAfter(nState: DOTA_GameState): boolean;

    AddCommand(
        pszCommandName: string,
        callback: (name: string, ...args: string[]) => void,
        pszDescription: string,
        nFlags: number,
    ): void;

    GetLocalPlayerID(): PlayerID;

    /**
     * Assign the local player to the specified team
     */
    PlayerJoinTeam(nTeamID: DOTATeam_t): void;

    /**
     * Assign the currently unassigned players to teams
     */
    AutoAssignPlayersToTeams(): void;

    /**
     * Shuffle the team assignments of all of the players currently assigned to a team.
     */
    ShufflePlayerTeamAssignments(): void;

    /**
     * Set the remaining seconds in team setup before the game starts. -1 to stop the countdown timer
     */
    SetRemainingSetupTime(flSeconds: number): void;

    /**
     * Set the amount of time in seconds that will be set as the remaining time when all players are assigned to a team.
     */
    SetAutoLaunchDelay(flSeconds: number): void;

    /**
     * Enable or disable automatically starting the game once all players are assigned to a team
     */
    SetAutoLaunchEnabled(bEnable: boolean): void;

    /**
     * Return true of false indicating if automatically starting the game is enabled.
     */
    GetAutoLaunchEnabled(): boolean;

    /**
     * Lock the team selection preventing players from swiching teams.
     */
    SetTeamSelectionLocked(bLockTeams: boolean): void;

    /**
     * Returns true or false to indicate if team selection is locked
     */
    GetTeamSelectionLocked(): boolean;

    /**
     * Get all team IDs
     */
    GetAllTeamIDs(): DOTATeam_t[];

    /**
     * Get all player IDs
     */
    GetAllPlayerIDs(): PlayerID[];

    /**
     * Get unassigned player IDs
     */
    GetUnassignedPlayerIDs(): PlayerID[];

    /**
     * Get info about the player hero ultimate ability
     */
    GetPlayerUltimateStateOrTime(nPlayerID: PlayerID): number;

    /**
     * Whether the local player has muted text and voice chat for the specified player id
     */
    IsPlayerMuted(nPlayerID: PlayerID): boolean;

    /**
     * Set whether the local player has muted text and voice chat for the specified player id
     */
    SetPlayerMuted(nPlayerID: PlayerID, bMuted: boolean): void;

    /**
     * Get detailed information for the given team
     */
    GetTeamDetails(nTeam: number): TeamDetails;

    /**
     * Get details for the local player
     */
    GetLocalPlayerInfo(): PlayerInfo;

    /**
     * Get info about the player items.
     */
    GetPlayerItems(nPlayerID: PlayerID): ItemEntityIndex[];

    /**
     * Get info about the given player
     */
    GetPlayerInfo(nPlayerID: PlayerID): PlayerInfo;

    /**
     * Get player IDs for the given team
     */
    GetPlayerIDsOnTeam(nTeam: DOTATeam_t): PlayerID[];

    ServerCmd(pMsg: string): void;

    SetDotaRefractHeroes(bEnabled: boolean): void;

    FinishGame(): void;

    Disconnect(): void;

    FindEventMatch(): void;

    /**
     * Emit a sound for the local player. Returns an integer handle that can be passed to StopSound. (Returns 0 on failure.)
     */
    EmitSound(pSoundEventName: string): number;

    /**
     * Stop a current playing sound on the local player. Takes handle from a call to EmitSound.
     */
    StopSound(nHandle: number): void;

    /**
     * Ask whether the in game shop is open.
     */
    IsShopOpen(): boolean;

    /**
     * Set custom shop context.
     */
    SetCustomShopEntityString(pszCustomShopEntityString: string): void;

    /**
     * Return information about the current map.
     */
    GetMapInfo(): MapInfo;

    /**
     * Orders from the local player.
     */
    PrepareUnitOrders(args: PrepareUnitOrdersArgument): void;

    /**
     * Order a unit to drop the specified item at the current cursor location.
     */
    DropItemAtCursor(nControlledUnitEnt: EntityIndex, nItemEnt: ItemEntityIndex): void;

    /**
     * Calculate 2D length.
     */
    Length2D(vec1: [number, number, number], vec2: [number, number, number]): number;

    /**
     * Returns normalized vector.
     */
    Normalized(vec: [number, number, number]): [number, number, number];

    EnterAbilityLearnMode(): void;

    EndAbilityLearnMode(): void;

    IsInAbilityLearnMode(): boolean;

    /**
     * Registers a keybind that can be listened to with Game.AddCommand
     */
    CreateCustomKeyBind(keyName: string, commandName: string): void;
}

interface CPanoramaScript_SteamUGC {
    /**
     * Subscribe to a piece of UGC
     */
    SubscribeItem(pPublishedFileID: string, funcVal: any): void;

    /**
     * Unsubscribe to a piece of UGC
     */
    UnsubscribeItem(pPublishedFileID: string, funcVal: any): void;

    /**
     * Get a key from a custom net table
     */
    GetSubscriptionInfo(pPublishedFileID: string): any;

    /**
     * Vote on a piece of UGC
     */
    SetUserItemVote(pPublishedFileID: string, bVoteUp: boolean, funcVal: any): any;

    /**
     * Get the user's vote on a peice of UGC
     */
    GetUserItemVote(pPublishedFileID: string, funcVal: any): any;

    /**
     * Add an item to the user's favorites list
     */
    AddToFavorites(pPublishedFileID: string, funcVal: any): any;

    /**
     * Remove an item from the user's favorites list
     */
    RemoveFromFavorites(pPublishedFileID: string, funcVal: any): any;

    /**
     * Create a request to query Steam for all UGC
     */
    CreateQueryAllUGCRequest(eQueryType: number, eMatchingeMatchingUGCTypeFileType: number, unPage: number): any;

    /**
     * Creqte a request to query Steam for specific UGC
     */
    CreateQueryUGCDetailsRequest(pPublishedFileIDs: string[]): any;

    /**
     * Adds a required tag to the query
     */
    AddRequiredTagToQuery(handle: number, pchTag: string): any;

    /**
     * Adds an excluded tag to the query
     */
    AddExcludedTagToQuery(handle: number, pchTag: string): any;

    /**
     * Adds a required tag to the query
     */
    ConfigureQuery(handle: number, jsObject: any): any;

    /**
     * Sends the prepared query
     */
    SendUGCQuery(handle: number, funcVal: any): any;

    /**
     * Register a callback to be called when the item is downloaded
     */
    RegisterDownloadItemResultCallback(pPublishedFileID: string, funcVal: any): any;
}

interface CPanoramaScript_SteamFriends {
    /**
     * Requests the user's persona name
     */
    RequestPersonaName(pchSteamID: string, funcVal: any): string;

    /**
     * Sets the avatar image on the image panel
     */
    SetLargeAvatarImage(...unknown: any[]): void;
}

interface CPanoramaScript_SteamUtils {
    /**
     * Returns the connected universe
     */
    GetConnectedUniverse(): number;

    /**
     * Returns the appid of the current app
     */
    GetAppID(): number;
}

interface CPanoramaScript_VRUtils {
    /**
     * Get application properties for a VR app with the specified appID
     */
    GetVRAppPropertyData(nAppID: number): any;

    /**
     * Launches a Steam Application using OpenVR.
     */
    LaunchSteamApp(nAppID: number, pszLaunchSource: string): void;
}

interface DollarStatic {
    (selector: string): Panel;
    FindChildInContext(selector: string): Panel;

    CreatePanel<K extends keyof PanoramaPanelNameMap>(type: K, root: PanelBase, id: string): PanoramaPanelNameMap[K];
    CreatePanel(type: string, root: PanelBase, id: string): Panel;

    /**
     * @param properties An object with XML-style properties added to the created panel.
     * @example
     * $.CreatePanelWithProperties("Label", $.GetContextPanel(), "id", {
     *     class: "MyClass",
     *     text: "Button",
     *     onactivate: "$.Msg('Button Pressed')",
     * });
     */
    CreatePanelWithProperties<K extends keyof PanoramaPanelNameMap>(
        type: K,
        root: PanelBase,
        id: string,
        properties: Record<string, any>,
    ): PanoramaPanelNameMap[K];
    CreatePanelWithProperties(type: string, root: PanelBase, id: string, properties: Record<string, any>): Panel;

    CreatePanelWithCurrentContext(root?: PanelBase): Panel;

    /**
     * Log a message
     */
    Msg(...args: any[]): void;

    /**
     * Trigger an assert.
     * Prints a message with a stack trace to the console.
     */
    AssertHelper(...args: any[]): void;

    /**
     * Log a warning message to specified channel.
     */
    Warning(...args: any[]): void;

    GetContextPanel(): Panel;
    Schedule(time: number, callback: () => void): ScheduleID;
    CancelScheduled(scheduledEvent: ScheduleID): void;
    DispatchEvent(event: string, panelID?: string, ...args: any[]): void;
    DispatchEvent(event: string, panel: PanelBase, ...args: any[]): void;
    DispatchEventAsync(delay: number, event: string, panelID?: string, ...args: any[]): void;
    DispatchEventAsync(delay: number, event: string, panel: PanelBase, ...args: any[]): void;
    Language(): string;
    Localize(token: string, parent?: PanelBase): string;
    RegisterEventHandler(event: string, parent: PanelBase, handler: (...args: any[]) => void): void;
    RegisterForUnhandledEvent(event: string, handler: (...args: any[]) => void): UnhandledEventListenerID;
    UnregisterForUnhandledEvent(event: string, handle: UnhandledEventListenerID): void;
    Each<T>(list: T[], callback: (item: T, index: number) => void): void;
    Each<T>(map: { [key: string]: T }, callback: (value: T, key: string) => void): void;
    Each<T>(map: { [key: number]: T }, callback: (value: T, key: number) => void): void;
    AsyncWebRequest(url: string, data: AsyncWebRequestData): void;

    /**
     * Register a key binding.
     *
     * @param panel Panel or input context to bind on. Using an empty string crashes the game when the key is pressed out of Panorama context.
     * @param key A key name, with keyboard names starting with `key_`. Can be a comma-delimited list to register multiple keys at once.
     */
    RegisterKeyBind<T extends PanelBase = Panel>(
        panel: T | string,
        key: string,
        callback: (source: 'keyboard' | 'gamepad', presses: number, panel: T) => void,
    ): void;

    /**
     * Call during JS startup code to check if script is being reloaded.
     */
    DbgIsReloadingScript(): boolean;

    /**
     * Create a logging channel.
     */
    LogChannel(...unknown: any[]): void;
}

interface AsyncWebRequestResponse {
    statusText: string;
    responseText: string | null;
    status: number;
}

interface AsyncWebRequestData {
    type?: string;
    timeout?: number;
    headers?: object;
    data?: object;
    success?(response: any, result: 'success', statusText: string): void;
    error?(data: AsyncWebRequestResponse, result: 'error', statusText: string): void;
    complete?(data: AsyncWebRequestResponse, result: 'success' | 'error'): void;
}

declare var GameEvents: CDOTA_PanoramaScript_GameEvents;
declare var GameUI: CDOTA_PanoramaScript_GameUI;
declare var CustomNetTables: CDOTA_PanoramaScript_CustomNetTables;
declare var LocalInventory: CDOTA_PanoramaScript_LocalInventory;
declare var EventData: CDOTA_PanoramaScript_EventData;
declare var Particles: CScriptBindingPR_Particles;
declare var Buffs: CScriptBindingPR_Buffs;
declare var Players: CScriptBindingPR_Players;
declare var Entities: CScriptBindingPR_Entities;
declare var Abilities: CScriptBindingPR_Abilities;
declare var Items: CScriptBindingPR_Items;
declare var Game: CScriptBindingPR_Game;
declare var SteamUGC: CPanoramaScript_SteamUGC;
declare var SteamFriends: CPanoramaScript_SteamFriends;
declare var SteamUtils: CPanoramaScript_SteamUtils;
declare var VRUtils: CPanoramaScript_VRUtils;
declare var $: DollarStatic;
declare var panorama: DollarStatic;
