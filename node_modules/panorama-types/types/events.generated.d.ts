interface GameEventDeclarations {
    /**
     * Send once a server starts.
     */
    server_spawn: ServerSpawnEvent;
    /**
     * Server is about to be shut down.
     */
    server_pre_shutdown: ServerPreShutdownEvent;
    /**
     * Server shut down.
     */
    server_shutdown: ServerShutdownEvent;
    /**
     * A generic server message.
     */
    server_message: ServerMessageEvent;
    /**
     * A server console var has changed.
     */
    server_cvar: ServerCvarEvent;
    server_addban: ServerAddbanEvent;
    server_removeban: ServerRemovebanEvent;
    player_activate: PlayerActivateEvent;
    /**
     * Player has sent final message in the connection sequence.
     */
    player_connect_full: PlayerConnectFullEvent;
    player_say: PlayerSayEvent;
    player_full_update: PlayerFullUpdateEvent;
    /**
     * A new client connected.
     */
    player_connect: PlayerConnectEvent;
    /**
     * A client was disconnected.
     */
    player_disconnect: PlayerDisconnectEvent;
    /**
     * A player changed his name.
     */
    player_info: PlayerInfoEvent;
    /**
     * Player spawned in game.
     */
    player_spawn: PlayerSpawnEvent;
    player_team: PlayerTeamEvent;
    local_player_team: object;
    player_changename: PlayerChangenameEvent;
    /**
     * A player changed his class.
     */
    player_class: PlayerClassEvent;
    /**
     * Players scores changed.
     */
    player_score: PlayerScoreEvent;
    player_hurt: PlayerHurtEvent;
    /**
     * Player shoot his weapon.
     */
    player_shoot: PlayerShootEvent;
    /**
     * A public player chat.
     */
    player_chat: PlayerChatEvent;
    /**
     * Emits a sound to everyone on a team.
     */
    teamplay_broadcast_audio: TeamplayBroadcastAudioEvent;
    finale_start: FinaleStartEvent;
    player_stats_updated: PlayerStatsUpdatedEvent;
    /**
     * Fired when achievements/stats are downloaded from Steam or XBox Live.
     */
    user_data_downloaded: object;
    ragdoll_dissolved: RagdollDissolvedEvent;
    /**
     * Info about team.
     */
    team_info: TeamInfoEvent;
    /**
     * Team score changed.
     */
    team_score: TeamScoreEvent;
    /**
     * A spectator/player is a cameraman.
     */
    hltv_cameraman: HltvCameramanEvent;
    /**
     * Shot of a single entity.
     */
    hltv_chase: HltvChaseEvent;
    /**
     * A camera ranking.
     */
    hltv_rank_camera: HltvRankCameraEvent;
    /**
     * An entity ranking.
     */
    hltv_rank_entity: HltvRankEntityEvent;
    /**
     * Show from fixed view.
     */
    hltv_fixed: HltvFixedEvent;
    /**
     * A HLTV message send by moderators.
     */
    hltv_message: HltvMessageEvent;
    /**
     * General HLTV status.
     */
    hltv_status: HltvStatusEvent;
    hltv_title: HltvTitleEvent;
    /**
     * A HLTV chat msg sent by spectators.
     */
    hltv_chat: HltvChatEvent;
    hltv_versioninfo: HltvVersioninfoEvent;
    demo_start: DemoStartEvent;
    demo_stop: object;
    demo_skip: DemoSkipEvent;
    map_shutdown: object;
    map_transition: object;
    hostname_changed: HostnameChangedEvent;
    difficulty_changed: DifficultyChangedEvent;
    /**
     * A message send by game logic to everyone.
     */
    game_message: GameMessageEvent;
    /**
     * Send when new map is completely loaded.
     */
    game_newmap: GameNewmapEvent;
    round_start: RoundStartEvent;
    round_end: RoundEndEvent;
    round_start_pre_entity: object;
    round_start_post_nav: object;
    round_freeze_end: object;
    /**
     * Round restart.
     */
    teamplay_round_start: TeamplayRoundStartEvent;
    /**
     * A game event, name may be 32 charaters long.
     */
    player_death: PlayerDeathEvent;
    player_footstep: PlayerFootstepEvent;
    player_hintmessage: PlayerHintmessageEvent;
    break_breakable: BreakBreakableEvent;
    break_prop: BreakPropEvent;
    entity_killed: EntityKilledEvent;
    door_open: DoorOpenEvent;
    door_close: DoorCloseEvent;
    door_unlocked: DoorUnlockedEvent;
    vote_started: VoteStartedEvent;
    vote_failed: VoteFailedEvent;
    vote_passed: VotePassedEvent;
    vote_changed: VoteChangedEvent;
    vote_cast_yes: VoteCastYesEvent;
    vote_cast_no: VoteCastNoEvent;
    achievement_event: AchievementEventEvent;
    achievement_earned: AchievementEarnedEvent;
    achievement_write_failed: object;
    bonus_updated: BonusUpdatedEvent;
    spec_target_updated: object;
    entity_visible: EntityVisibleEvent;
    /**
     * The player pressed use but a use entity wasn't found.
     */
    player_use_miss: PlayerUseMissEvent;
    gameinstructor_draw: object;
    gameinstructor_nodraw: object;
    flare_ignite_npc: FlareIgniteNpcEvent;
    helicopter_grenade_punt_miss: object;
    physgun_pickup: PhysgunPickupEvent;
    inventory_updated: InventoryUpdatedEvent;
    cart_updated: object;
    store_pricesheet_updated: object;
    item_schema_initialized: object;
    drop_rate_modified: object;
    event_ticket_modified: object;
    gc_connected: object;
    instructor_start_lesson: InstructorStartLessonEvent;
    instructor_close_lesson: InstructorCloseLessonEvent;
    instructor_server_hint_create: InstructorServerHintCreateEvent;
    instructor_server_hint_stop: InstructorServerHintStopEvent;
    set_instructor_group_enabled: SetInstructorGroupEnabledEvent;
    clientside_lesson_closed: ClientsideLessonClosedEvent;
    dynamic_shadow_light_changed: object;
    /**
     * Shot of a single entity.
     */
    dota_chase_hero: DotaChaseHeroEvent;
    dota_combatlog: DotaCombatlogEvent;
    dota_game_state_change: DotaGameStateChangeEvent;
    hero_selected: HeroSelectedEvent;
    dota_player_pick_hero: DotaPlayerPickHeroEvent;
    modifier_event: ModifierEventEvent;
    dota_player_kill: DotaPlayerKillEvent;
    dota_player_deny: DotaPlayerDenyEvent;
    dota_barracks_kill: DotaBarracksKillEvent;
    dota_tower_kill: DotaTowerKillEvent;
    dota_effigy_kill: DotaEffigyKillEvent;
    dota_roshan_kill: DotaRoshanKillEvent;
    dota_courier_lost: DotaCourierLostEvent;
    dota_courier_respawned: DotaCourierRespawnedEvent;
    dota_glyph_used: DotaGlyphUsedEvent;
    dota_super_creeps: DotaSuperCreepsEvent;
    dota_item_purchase: DotaItemPurchaseEvent;
    dota_item_gifted: DotaItemGiftedEvent;
    dota_item_placed_in_neutral_stash: DotaItemPlacedInNeutralStashEvent;
    dota_rune_pickup: DotaRunePickupEvent;
    dota_ward_killed: DotaWardKilledEvent;
    dota_rune_spotted: DotaRuneSpottedEvent;
    dota_item_spotted: DotaItemSpottedEvent;
    dota_no_battle_points: DotaNoBattlePointsEvent;
    dota_chat_informational: DotaChatInformationalEvent;
    dota_action_item: DotaActionItemEvent;
    dota_chat_ban_notification: DotaChatBanNotificationEvent;
    dota_chat_event: DotaChatEventEvent;
    dota_chat_timed_reward: DotaChatTimedRewardEvent;
    dota_pause_event: DotaPauseEventEvent;
    dota_chat_kill_streak: DotaChatKillStreakEvent;
    dota_chat_first_blood: DotaChatFirstBloodEvent;
    dota_chat_assassin_announce: DotaChatAssassinAnnounceEvent;
    dota_chat_assassin_denied: DotaChatAssassinDeniedEvent;
    dota_chat_assassin_success: DotaChatAssassinSuccessEvent;
    dota_player_update_hero_selection: DotaPlayerUpdateHeroSelectionEvent;
    dota_player_update_selected_unit: object;
    dota_player_update_query_unit: object;
    dota_player_update_killcam_unit: object;
    dota_player_take_tower_damage: DotaPlayerTakeTowerDamageEvent;
    dota_hud_error_message: DotaHudErrorMessageEvent;
    dota_action_success: object;
    dota_starting_position_changed: object;
    dota_team_neutral_stash_items_changed: DotaTeamNeutralStashItemsChangedEvent;
    dota_team_neutral_stash_items_acknowledged_changed: DotaTeamNeutralStashItemsAcknowledgedChangedEvent;
    dota_money_changed: object;
    dota_enemy_money_changed: object;
    dota_portrait_unit_stats_changed: object;
    dota_portrait_unit_modifiers_changed: DotaPortraitUnitModifiersChangedEvent;
    dota_force_portrait_update: object;
    dota_inventory_changed: object;
    dota_item_suggestions_changed: object;
    dota_estimated_match_duration_changed: object;
    dota_hero_ability_points_changed: object;
    dota_item_picked_up: DotaItemPickedUpEvent;
    dota_inventory_item_changed: DotaInventoryItemChangedEvent;
    dota_ability_changed: DotaAbilityChangedEvent;
    dota_spectator_talent_changed: DotaSpectatorTalentChangedEvent;
    dota_portrait_ability_layout_changed: object;
    dota_inventory_item_added: DotaInventoryItemAddedEvent;
    dota_inventory_changed_query_unit: object;
    dota_link_clicked: DotaLinkClickedEvent;
    dota_set_quick_buy: DotaSetQuickBuyEvent;
    dota_quick_buy_changed: DotaQuickBuyChangedEvent;
    dota_player_shop_changed: DotaPlayerShopChangedEvent;
    dota_hero_entered_shop: DotaHeroEnteredShopEvent;
    dota_player_show_killcam: DotaPlayerShowKillcamEvent;
    dota_player_show_minikillcam: DotaPlayerShowMinikillcamEvent;
    gc_user_session_created: object;
    team_data_updated: object;
    guild_data_updated: object;
    guild_open_parties_updated: object;
    fantasy_updated: object;
    fantasy_league_changed: object;
    fantasy_score_info_changed: object;
    league_admin_info_updated: object;
    league_series_info_updated: object;
    player_info_updated: object;
    player_info_individual_updated: PlayerInfoIndividualUpdatedEvent;
    game_rules_state_change: object;
    match_history_updated: MatchHistoryUpdatedEvent;
    match_details_updated: MatchDetailsUpdatedEvent;
    team_details_updated: TeamDetailsUpdatedEvent;
    live_games_updated: object;
    recent_matches_updated: RecentMatchesUpdatedEvent;
    news_updated: object;
    persona_updated: PersonaUpdatedEvent;
    tournament_state_updated: object;
    party_updated: object;
    lobby_updated: object;
    dashboard_caches_cleared: object;
    last_hit: LastHitEvent;
    player_completed_game: PlayerCompletedGameEvent;
    player_reconnected: PlayerReconnectedEvent;
    nommed_tree: NommedTreeEvent;
    dota_rune_activated_server: DotaRuneActivatedServerEvent;
    dota_player_gained_level: DotaPlayerGainedLevelEvent;
    dota_player_learned_ability: DotaPlayerLearnedAbilityEvent;
    dota_player_used_ability: DotaPlayerUsedAbilityEvent;
    dota_non_player_used_ability: DotaNonPlayerUsedAbilityEvent;
    dota_player_begin_cast: DotaPlayerBeginCastEvent;
    dota_non_player_begin_cast: DotaNonPlayerBeginCastEvent;
    dota_ability_channel_finished: DotaAbilityChannelFinishedEvent;
    dota_holdout_revive_complete: DotaHoldoutReviveCompleteEvent;
    dota_holdout_revive_eliminated: DotaHoldoutReviveEliminatedEvent;
    dota_player_killed: DotaPlayerKilledEvent;
    bindpanel_open: object;
    bindpanel_close: object;
    keybind_changed: object;
    dota_item_drag_begin: object;
    dota_item_drag_end: object;
    dota_shop_item_drag_begin: object;
    dota_shop_item_drag_end: object;
    dota_item_purchased: DotaItemPurchasedEvent;
    dota_item_combined: DotaItemCombinedEvent;
    dota_item_used: DotaItemUsedEvent;
    dota_item_auto_purchase: DotaItemAutoPurchaseEvent;
    dota_unit_event: DotaUnitEventEvent;
    dota_quest_started: DotaQuestStartedEvent;
    dota_quest_completed: DotaQuestCompletedEvent;
    gameui_activated: object;
    gameui_hidden: object;
    player_fullyjoined: PlayerFullyjoinedEvent;
    dota_spectate_hero: DotaSpectateHeroEvent;
    dota_match_done: DotaMatchDoneEvent;
    dota_match_done_client: object;
    joined_chat_channel: JoinedChatChannelEvent;
    left_chat_channel: LeftChatChannelEvent;
    gc_chat_channel_list_updated: object;
    file_downloaded: FileDownloadedEvent;
    player_report_counts_updated: PlayerReportCountsUpdatedEvent;
    scaleform_file_download_complete: ScaleformFileDownloadCompleteEvent;
    item_purchased: ItemPurchasedEvent;
    gc_mismatched_version: object;
    dota_workshop_fileselected: DotaWorkshopFileselectedEvent;
    dota_workshop_filecanceled: object;
    rich_presence_updated: object;
    live_leagues_updated: object;
    dota_hero_random: DotaHeroRandomEvent;
    dota_river_painted: DotaRiverPaintedEvent;
    dota_scan_used: DotaScanUsedEvent;
    dota_scan_found_enemy: DotaScanFoundEnemyEvent;
    dota_rd_chat_turn: DotaRdChatTurnEvent;
    dota_ad_nominated_ban: DotaAdNominatedBanEvent;
    dota_ad_ban: DotaAdBanEvent;
    dota_ad_ban_count: DotaAdBanCountEvent;
    dota_ad_hero_collision: DotaAdHeroCollisionEvent;
    dota_favorite_heroes_updated: object;
    profile_opened: object;
    profile_closed: object;
    item_preview_closed: object;
    dashboard_switched_section: DashboardSwitchedSectionEvent;
    dota_tournament_item_event: DotaTournamentItemEventEvent;
    dota_hero_swap: DotaHeroSwapEvent;
    dota_reset_suggested_items: object;
    halloween_high_score_received: object;
    halloween_phase_end: HalloweenPhaseEndEvent;
    halloween_high_score_request_failed: object;
    dota_hud_skin_changed: DotaHudSkinChangedEvent;
    dota_inventory_player_got_item: DotaInventoryPlayerGotItemEvent;
    player_is_experienced: object;
    player_is_notexperienced: object;
    dota_tutorial_lesson_start: object;
    dota_tutorial_task_advance: object;
    dota_tutorial_shop_toggled: DotaTutorialShopToggledEvent;
    map_location_updated: object;
    richpresence_custom_updated: object;
    game_end_visible: object;
    enable_china_logomark: object;
    highlight_hud_element: HighlightHudElementEvent;
    hide_highlight_hud_element: object;
    intro_video_finished: object;
    matchmaking_status_visibility_changed: object;
    practice_lobby_visibility_changed: object;
    dota_courier_transfer_item: DotaCourierTransferItemEvent;
    full_ui_unlocked: object;
    client_disconnect: ClientDisconnectEvent;
    hero_selector_preview_set: HeroSelectorPreviewSetEvent;
    antiaddiction_toast: AntiaddictionToastEvent;
    hero_picker_shown: object;
    hero_picker_hidden: object;
    dota_local_quickbuy_changed: object;
    show_center_message: ShowCenterMessageEvent;
    hud_flip_changed: HudFlipChangedEvent;
    frosty_points_updated: object;
    defeated: DefeatedEvent;
    reset_defeated: object;
    booster_state_updated: object;
    custom_game_difficulty: CustomGameDifficultyEvent;
    tree_cut: TreeCutEvent;
    ugc_details_arrived: UgcDetailsArrivedEvent;
    ugc_subscribed: UgcSubscribedEvent;
    ugc_unsubscribed: UgcUnsubscribedEvent;
    ugc_download_requested: UgcDownloadRequestedEvent;
    ugc_installed: UgcInstalledEvent;
    prizepool_received: PrizepoolReceivedEvent;
    microtransaction_success: MicrotransactionSuccessEvent;
    dota_rubick_ability_steal: DotaRubickAbilityStealEvent;
    community_cached_names_updated: object;
    spec_item_pickup: SpecItemPickupEvent;
    spec_aegis_reclaim_time: SpecAegisReclaimTimeEvent;
    account_trophies_changed: AccountTrophiesChangedEvent;
    account_all_hero_challenge_changed: AccountAllHeroChallengeChangedEvent;
    team_showcase_ui_update: TeamShowcaseUiUpdateEvent;
    dota_match_signout: object;
    dota_illusions_created: DotaIllusionsCreatedEvent;
    dota_year_beast_killed: DotaYearBeastKilledEvent;
    dota_player_spawned: DotaPlayerSpawnedEvent;
    dota_hero_undoselection: DotaHeroUndoselectionEvent;
    dota_challenge_socache_updated: object;
    dota_player_team_changed: object;
    party_invites_updated: object;
    lobby_invites_updated: object;
    custom_game_mode_list_updated: object;
    custom_game_lobby_list_updated: object;
    friend_lobby_list_updated: object;
    dota_team_player_list_changed: object;
    dota_player_details_changed: object;
    player_profile_stats_updated: PlayerProfileStatsUpdatedEvent;
    custom_game_player_count_updated: CustomGamePlayerCountUpdatedEvent;
    custom_game_friends_played_updated: CustomGameFriendsPlayedUpdatedEvent;
    custom_games_friends_play_updated: object;
    dota_player_update_assigned_hero: DotaPlayerUpdateAssignedHeroEvent;
    dota_player_hero_selection_dirty: object;
    dota_npc_goal_reached: DotaNpcGoalReachedEvent;
    dota_player_selected_custom_team: DotaPlayerSelectedCustomTeamEvent;
    dota_coin_wager: DotaCoinWagerEvent;
    dota_wager_token: DotaWagerTokenEvent;
    dota_rank_wager: DotaRankWagerEvent;
    dota_bounty: DotaBountyEvent;
    colorblind_mode_changed: object;
    dota_report_submitted: DotaReportSubmittedEvent;
    client_reload_game_keyvalues: object;
    dota_hero_inventory_item_change: DotaHeroInventoryItemChangeEvent;
    game_rules_shutdown: object;
    aegis_event: AegisEventEvent;
    dota_buyback: DotaBuybackEvent;
    bought_back: BoughtBackEvent;
    dota_shrine_kill: DotaShrineKillEvent;
    particle_system_start: ParticleSystemStartEvent;
    particle_system_stop: ParticleSystemStopEvent;
    dota_combat_event_message: DotaCombatEventMessageEvent;
    dota_item_spawned: DotaItemSpawnedEvent;
    dota_player_reconnected: DotaPlayerReconnectedEvent;
    dota_on_hero_finish_spawn: DotaOnHeroFinishSpawnEvent;
    dota_creature_gained_level: DotaCreatureGainedLevelEvent;
    dota_hero_teleport_to_unit: DotaHeroTeleportToUnitEvent;
    dota_neutral_creep_camp_cleared: DotaNeutralCreepCampClearedEvent;
    npc_spawned: NpcSpawnedEvent;
    npc_replaced: NpcReplacedEvent;
    entity_hurt: EntityHurtEvent;
    /**
     * The specified channel contains new messages.
     */
    chat_new_message: ChatNewMessageEvent;
    /**
     * The specified channel has had players leave or join.
     */
    chat_members_changed: ChatMembersChangedEvent;
    dota_team_kill_credit: DotaTeamKillCreditEvent;
}
/**
 * Send once a server starts.
 */
interface ServerSpawnEvent {
    /**
     * Public host name.
     */
    hostname: string;
    /**
     * Hostame, IP or DNS name.
     */
    address: string;
    /**
     * Server port.
     */
    port: number;
    /**
     * Game dir.
     */
    game: string;
    /**
     * Map name.
     */
    mapname: string;
    /**
     * Addon name.
     */
    addonname: string;
    /**
     * Max players.
     */
    maxplayers: number;
    /**
     * WIN32, LINUX.
     */
    os: string;
    /**
     * True if dedicated server.
     */
    dedicated: 0 | 1;
    /**
     * True if password protected.
     */
    password: 0 | 1;
}

/**
 * Server is about to be shut down.
 */
interface ServerPreShutdownEvent {
    /**
     * Reason why server is about to be shut down.
     */
    reason: string;
}

/**
 * Server shut down.
 */
interface ServerShutdownEvent {
    /**
     * Reason why server was shut down.
     */
    reason: string;
}

/**
 * A generic server message.
 */
interface ServerMessageEvent {
    /**
     * The message text.
     */
    text: string;
}

/**
 * A server console var has changed.
 */
interface ServerCvarEvent {
    /**
     * Cvar name, eg "mp_roundtime".
     */
    cvarname: string;
    /**
     * New cvar value.
     */
    cvarvalue: string;
}

interface ServerAddbanEvent {
    /**
     * Player name.
     */
    name: string;
    /**
     * User ID on server.
     */
    userid: EntityIndex;
    /**
     * Player network (i.e steam) id.
     */
    networkid: string;
    /**
     * IP address.
     */
    ip: string;
    /**
     * Length of the ban.
     */
    duration: string;
    /**
     * Banned by...
     */
    by: string;
    /**
     * Whether the player was also kicked.
     */
    kicked: 0 | 1;
}

interface ServerRemovebanEvent {
    /**
     * Player network (i.e steam) id.
     */
    networkid: string;
    /**
     * IP address.
     */
    ip: string;
    /**
     * Removed by...
     */
    by: string;
}

interface PlayerActivateEvent {
    /**
     * User ID on server.
     */
    userid: EntityIndex;
}

/**
 * Player has sent final message in the connection sequence.
 */
interface PlayerConnectFullEvent {
    /**
     * User ID on server.
     */
    userid: EntityIndex;
    /**
     * Player slot (entity index-1).
     */
    index: number;
    PlayerID: PlayerID;
}

interface PlayerSayEvent {
    /**
     * User ID on server.
     */
    userid: EntityIndex;
    /**
     * The say text.
     */
    text: string;
}

interface PlayerFullUpdateEvent {
    /**
     * User ID on server.
     */
    userid: EntityIndex;
    /**
     * Number of this full update.
     */
    count: number;
}

/**
 * A new client connected.
 */
interface PlayerConnectEvent {
    /**
     * Player name.
     */
    name: string;
    /**
     * Player slot (entity index-1).
     */
    index: number;
    /**
     * User ID on server (unique on server).
     */
    userid: EntityIndex;
    /**
     * Player network (i.e steam) id.
     */
    networkid: string;
    /**
     * Ip:port.
     */
    address: string;
    bot: 0 | 1;
}

/**
 * A client was disconnected.
 */
interface PlayerDisconnectEvent {
    /**
     * User ID on server.
     */
    userid: EntityIndex;
    /**
     * See networkdisconnect enum protobuf.
     */
    reason: number;
    /**
     * Player name.
     */
    name: string;
    /**
     * Player network (i.e steam) id.
     */
    networkid: string;
    PlayerID: PlayerID;
}

/**
 * A player changed his name.
 */
interface PlayerInfoEvent {
    /**
     * Player name.
     */
    name: string;
    /**
     * Player slot (entity index-1).
     */
    index: number;
    /**
     * User ID on server (unique on server).
     */
    userid: EntityIndex;
    /**
     * Player network (i.e steam) id.
     */
    networkid: string;
    /**
     * True if player is a AI bot.
     */
    bot: 0 | 1;
}

/**
 * Player spawned in game.
 */
interface PlayerSpawnEvent {
    /**
     * User ID on server.
     */
    userid: EntityIndex;
}

interface PlayerTeamEvent {
    /**
     * User ID on server.
     */
    userid: EntityIndex;
    /**
     * Team id.
     */
    team: number;
    /**
     * Old team id.
     */
    oldteam: number;
    /**
     * Team change because player disconnects.
     */
    disconnect: 0 | 1;
    /**
     * True if the player was auto assigned to the team.
     */
    autoteam: 0 | 1;
    /**
     * If true wont print the team join messages.
     */
    silent: 0 | 1;
    name: string;
    isbot: 0 | 1;
}

interface PlayerChangenameEvent {
    /**
     * User ID on server.
     */
    userid: EntityIndex;
    /**
     * Players old (current) name.
     */
    oldname: string;
    /**
     * Players new name.
     */
    newname: string;
}

/**
 * A player changed his class.
 */
interface PlayerClassEvent {
    /**
     * User ID on server.
     */
    userid: EntityIndex;
    /**
     * New player class / model.
     */
    class: string;
}

/**
 * Players scores changed.
 */
interface PlayerScoreEvent {
    /**
     * User ID on server.
     */
    userid: EntityIndex;
    /**
     * # of kills.
     */
    kills: number;
    /**
     * # of deaths.
     */
    deaths: number;
    /**
     * Total game score.
     */
    score: number;
}

interface PlayerHurtEvent {
    /**
     * Player index who was hurt.
     */
    userid: EntityIndex;
    /**
     * Player index who attacked.
     */
    attacker: number;
    /**
     * Remaining health points.
     */
    health: number;
}

/**
 * Player shoot his weapon.
 */
interface PlayerShootEvent {
    /**
     * User ID on server.
     */
    userid: EntityIndex;
    /**
     * Weapon ID.
     */
    weapon: number;
    /**
     * Weapon mode.
     */
    mode: number;
}

/**
 * A public player chat.
 */
interface PlayerChatEvent {
    /**
     * True if team only chat.
     */
    teamonly: 0 | 1;
    /**
     * Chatting player.
     */
    userid: EntityIndex;
    /**
     * Chatting player ID.
     */
    playerid: PlayerID;
    /**
     * Chat text.
     */
    text: string;
}

/**
 * Emits a sound to everyone on a team.
 */
interface TeamplayBroadcastAudioEvent {
    /**
     * Unique team id.
     */
    team: number;
    /**
     * Name of the sound to emit.
     */
    sound: string;
}

interface FinaleStartEvent {
    rushes: number;
}

interface PlayerStatsUpdatedEvent {
    forceupload: 0 | 1;
}

interface RagdollDissolvedEvent {
    entindex: EntityIndex;
}

/**
 * Info about team.
 */
interface TeamInfoEvent {
    /**
     * Unique team id.
     */
    teamid: number;
    /**
     * Team name eg "Team Blue".
     */
    teamname: string;
}

/**
 * Team score changed.
 */
interface TeamScoreEvent {
    /**
     * Team id.
     */
    teamid: number;
    /**
     * Total team score.
     */
    score: number;
}

/**
 * A spectator/player is a cameraman.
 */
interface HltvCameramanEvent {
    /**
     * Camera man entity index.
     */
    index: number;
}

/**
 * Shot of a single entity.
 */
interface HltvChaseEvent {
    /**
     * Primary traget index.
     */
    target1: number;
    /**
     * Secondary traget index or 0.
     */
    target2: number;
    /**
     * Camera distance.
     */
    distance: number;
    /**
     * View angle horizontal.
     */
    theta: number;
    /**
     * View angle vertical.
     */
    phi: number;
    /**
     * Camera inertia.
     */
    inertia: number;
    /**
     * Diretcor suggests to show ineye.
     */
    ineye: number;
}

/**
 * A camera ranking.
 */
interface HltvRankCameraEvent {
    /**
     * Fixed camera index.
     */
    index: number;
    /**
     * Ranking, how interesting is this camera view.
     */
    rank: number;
    /**
     * Best/closest target entity.
     */
    target: number;
}

/**
 * An entity ranking.
 */
interface HltvRankEntityEvent {
    /**
     * Entity index.
     */
    index: number;
    /**
     * Ranking, how interesting is this entity to view.
     */
    rank: number;
    /**
     * Best/closest target entity.
     */
    target: number;
}

/**
 * Show from fixed view.
 */
interface HltvFixedEvent {
    /**
     * Camera position in world.
     */
    posx: number;
    posy: number;
    posz: number;
    /**
     * Camera angles.
     */
    theta: number;
    phi: number;
    offset: number;
    fov: number;
    /**
     * Follow this entity or 0.
     */
    target: number;
}

/**
 * A HLTV message send by moderators.
 */
interface HltvMessageEvent {
    text: string;
}

/**
 * General HLTV status.
 */
interface HltvStatusEvent {
    /**
     * Number of HLTV spectators.
     */
    clients: number;
    /**
     * Number of HLTV slots.
     */
    slots: number;
    /**
     * Number of HLTV proxies.
     */
    proxies: number;
    /**
     * Disptach master IP:port.
     */
    master: string;
}

interface HltvTitleEvent {
    text: string;
}

/**
 * A HLTV chat msg sent by spectators.
 */
interface HltvChatEvent {
    text: string;
}

interface HltvVersioninfoEvent {
    version: number;
}

interface DemoStartEvent {
    /**
     * CSVCMsgList_GameEvents that are combat log events.
     */
    dota_combatlog_list: any;
    /**
     * CSVCMsgList_GameEvents.
     */
    dota_hero_chase_list: any;
    /**
     * CSVCMsgList_GameEvents.
     */
    dota_pick_hero_list: any;
}

interface DemoSkipEvent {
    /**
     * Current playback tick.
     */
    playback_tick: number;
    /**
     * Tick we're going to.
     */
    skipto_tick: number;
    /**
     * CSVCMsgList_UserMessages.
     */
    user_message_list: any;
    /**
     * CSVCMsgList_GameEvents.
     */
    dota_hero_chase_list: any;
}

interface HostnameChangedEvent {
    hostname: string;
}

interface DifficultyChangedEvent {
    newDifficulty: number;
    oldDifficulty: number;
    /**
     * New difficulty as string.
     */
    strDifficulty: string;
}

/**
 * A message send by game logic to everyone.
 */
interface GameMessageEvent {
    /**
     * 0 = console, 1 = HUD.
     */
    target: number;
    /**
     * The message text.
     */
    text: string;
}

/**
 * Send when new map is completely loaded.
 */
interface GameNewmapEvent {
    /**
     * Map name.
     */
    mapname: string;
    /**
     * True if this is a transition from one map to another.
     */
    transition: 0 | 1;
}

interface RoundStartEvent {
    /**
     * Round time limit in seconds.
     */
    timelimit: number;
    /**
     * Frag limit in seconds.
     */
    fraglimit: number;
    /**
     * Round objective.
     */
    objective: string;
}

interface RoundEndEvent {
    /**
     * Winner team/user i.
     */
    winner: number;
    /**
     * Reson why team won.
     */
    reason: number;
    /**
     * End round message.
     */
    message: string;
    time: number;
}

/**
 * Round restart.
 */
interface TeamplayRoundStartEvent {
    /**
     * Is this a full reset of the map.
     */
    full_reset: 0 | 1;
}

/**
 * A game event, name may be 32 charaters long.
 */
interface PlayerDeathEvent {
    /**
     * User ID who died.
     */
    userid: EntityIndex;
    /**
     * User ID who killed.
     */
    attacker: number;
}

interface PlayerFootstepEvent {
    userid: EntityIndex;
}

interface PlayerHintmessageEvent {
    /**
     * Localizable string of a hint.
     */
    hintmessage: string;
}

interface BreakBreakableEvent {
    entindex: EntityIndex;
    userid: EntityIndex;
    /**
     * BREAK_GLASS, BREAK_WOOD, etc.
     */
    material: number;
}

interface BreakPropEvent {
    entindex: EntityIndex;
    userid: EntityIndex;
    player_held: 0 | 1;
    player_thrown: 0 | 1;
    player_dropped: 0 | 1;
}

interface EntityKilledEvent {
    entindex_killed: EntityIndex;
    entindex_attacker: EntityIndex;
    entindex_inflictor: EntityIndex;
    damagebits: number;
}

interface DoorOpenEvent {
    /**
     * Who opened the door.
     */
    userid: EntityIndex;
    /**
     * Is the door a checkpoint door.
     */
    checkpoint: 0 | 1;
    /**
     * Was the door closed when it started opening?
     */
    closed: 0 | 1;
}

interface DoorCloseEvent {
    /**
     * Who closed the door.
     */
    userid: EntityIndex;
    /**
     * Is the door a checkpoint door.
     */
    checkpoint: 0 | 1;
}

interface DoorUnlockedEvent {
    /**
     * Who opened the door.
     */
    userid: EntityIndex;
    /**
     * Is the door a checkpoint door.
     */
    checkpoint: 0 | 1;
}

interface VoteStartedEvent {
    issue: string;
    param1: string;
    votedata: string;
    team: number;
    /**
     * Entity id of the player who initiated the vote.
     */
    initiator: number;
    /**
     * This event is reliable.
     */
    reliable: 1;
}

interface VoteFailedEvent {
    team: number;
    /**
     * This event is reliable.
     */
    reliable: 1;
}

interface VotePassedEvent {
    details: string;
    param1: string;
    team: number;
    /**
     * This event is reliable.
     */
    reliable: 1;
}

interface VoteChangedEvent {
    yesVotes: number;
    noVotes: number;
    potentialVotes: number;
}

interface VoteCastYesEvent {
    team: number;
    /**
     * Entity id of the voter.
     */
    entityid: number;
}

interface VoteCastNoEvent {
    team: number;
    /**
     * Entity id of the voter.
     */
    entityid: number;
}

interface AchievementEventEvent {
    /**
     * Non-localized name of achievement.
     */
    achievement_name: string;
    /**
     * # of steps toward achievement.
     */
    cur_val: number;
    /**
     * Total # of steps in achievement.
     */
    max_val: number;
}

interface AchievementEarnedEvent {
    /**
     * Entindex of the player.
     */
    player: number;
    /**
     * Achievement ID.
     */
    achievement: number;
}

interface BonusUpdatedEvent {
    numadvanced: number;
    numbronze: number;
    numsilver: number;
    numgold: number;
}

interface EntityVisibleEvent {
    /**
     * The player who sees the entity.
     */
    userid: EntityIndex;
    /**
     * Entindex of the entity they see.
     */
    subject: number;
    /**
     * Classname of the entity they see.
     */
    classname: string;
    /**
     * Name of the entity they see.
     */
    entityname: string;
}

/**
 * The player pressed use but a use entity wasn't found.
 */
interface PlayerUseMissEvent {
    /**
     * Userid of user.
     */
    userid: EntityIndex;
}

interface FlareIgniteNpcEvent {
    /**
     * Entity ignited.
     */
    entindex: EntityIndex;
}

interface PhysgunPickupEvent {
    /**
     * Entity picked up.
     */
    entindex: EntityIndex;
}

interface InventoryUpdatedEvent {
    itemdef: number;
    itemid: number;
}

interface InstructorStartLessonEvent {
    /**
     * The player who this lesson is intended for.
     */
    userid: EntityIndex;
    /**
     * Name of the lesson to start.  Must match instructor_lesson.txt.
     */
    hint_name: string;
    /**
     * Entity id that the hint should display at. Leave empty if controller target.
     */
    hint_target: number;
    vr_movement_type: number;
    vr_single_controller: 0 | 1;
    vr_controller_type: number;
}

interface InstructorCloseLessonEvent {
    /**
     * The player who this lesson is intended for.
     */
    userid: EntityIndex;
    /**
     * Name of the lesson to start.  Must match instructor_lesson.txt.
     */
    hint_name: string;
}

interface InstructorServerHintCreateEvent {
    /**
     * User ID of the player that triggered the hint.
     */
    userid: EntityIndex;
    /**
     * Entity id of the env_instructor_hint that fired the event.
     */
    hint_entindex: EntityIndex;
    /**
     * What to name the hint. For referencing it again later (e.g. a kill command for
     * the hint instead of a timeout).
     */
    hint_name: string;
    /**
     * Type name so that messages of the same type will replace each other.
     */
    hint_replace_key: string;
    /**
     * Entity id that the hint should display at.
     */
    hint_target: number;
    /**
     * Userid id of the activator.
     */
    hint_activator_userid: EntityIndex;
    /**
     * How long in seconds until the hint automatically times out, 0 = never.
     */
    hint_timeout: number;
    /**
     * The hint icon to use when the hint is onscreen. e.g. "icon_alert_red".
     */
    hint_icon_onscreen: string;
    /**
     * The hint icon to use when the hint is offscreen. e.g. "icon_alert".
     */
    hint_icon_offscreen: string;
    /**
     * The hint caption. e.g. "#ThisIsDangerous".
     */
    hint_caption: string;
    /**
     * The hint caption that only the activator sees e.g. "#YouPushedItGood".
     */
    hint_activator_caption: string;
    /**
     * The hint color in "r,g,b" format where each component is 0-255.
     */
    hint_color: string;
    /**
     * How far on the z axis to offset the hint from entity origin.
     */
    hint_icon_offset: number;
    /**
     * Range before the hint is culled.
     */
    hint_range: number;
    /**
     * Hint flags.
     */
    hint_flags: number;
    /**
     * Bindings to use when use_binding is the onscreen icon.
     */
    hint_binding: string;
    /**
     * If false, the hint will dissappear if the target entity is invisible.
     */
    hint_allow_nodraw_target: 0 | 1;
    /**
     * If true, the hint will not show when outside the player view.
     */
    hint_nooffscreen: 0 | 1;
    /**
     * If true, the hint caption will show even if the hint is occluded.
     */
    hint_forcecaption: 0 | 1;
    /**
     * If true, only the local player will see the hint.
     */
    hint_local_player_only: 0 | 1;
    /**
     * Game sound to play.
     */
    hint_start_sound: string;
    /**
     * Path for Panorama layout file.
     */
    hint_layoutfile: string;
    /**
     * Attachment type for the Panorama panel.
     */
    hint_vr_panel_type: number;
    /**
     * Height offset for attached panels.
     */
    hint_vr_height_offset: number;
    /**
     * Offset for attached panels.
     */
    hint_vr_offset_x: number;
    /**
     * Offset for attached panels.
     */
    hint_vr_offset_y: number;
    /**
     * Offset for attached panels.
     */
    hint_vr_offset_z: number;
}

interface InstructorServerHintStopEvent {
    /**
     * The hint to stop. Will stop ALL hints with this name.
     */
    hint_name: string;
    /**
     * Entity id of the env_instructor_hint that fired the event.
     */
    hint_entindex: EntityIndex;
}

interface SetInstructorGroupEnabledEvent {
    group: string;
    enabled: number;
}

interface ClientsideLessonClosedEvent {
    lesson_name: string;
}

/**
 * A HLTV chat msg sent by spectators.
 */
interface HltvChatEvent {
    name: string;
    text: string;
    steamID: number;
}

/**
 * Shot of a single entity.
 */
interface DotaChaseHeroEvent {
    /**
     * Primary traget index.
     */
    target1: number;
    /**
     * Secondary traget index or 0.
     */
    target2: number;
    type: number;
    priority: number;
    gametime: number;
    /**
     * If set, a result of highlight reel mode.
     */
    highlight: 0 | 1;
    target1playerid: PlayerID;
    target2playerid: PlayerID;
    /**
     * EDOTAHeroChaseEventType.
     */
    eventtype: number;
}

interface DotaCombatlogEvent {
    type: number;
    sourcename: number;
    targetname: number;
    attackername: number;
    inflictorname: number;
    attackerillusion: 0 | 1;
    targetillusion: 0 | 1;
    value: number;
    health: number;
    timestamp: number;
    targetsourcename: number;
    timestampraw: number;
    attackerhero: 0 | 1;
    targethero: 0 | 1;
    ability_toggle_on: 0 | 1;
    ability_toggle_off: 0 | 1;
    ability_level: number;
    gold_reason: number;
    xp_reason: number;
}

interface DotaGameStateChangeEvent {
    old_state: number;
    new_state: number;
}

interface HeroSelectedEvent {
    player_id: PlayerID;
    team_number: number;
    hero_unit: string;
}

interface DotaPlayerPickHeroEvent {
    player: number;
    heroindex: number;
    hero: string;
}

/**
 * A new client connected.
 */
interface PlayerConnectEvent {
    /**
     * Player name.
     */
    name: string;
    /**
     * Player slot (entity index-1).
     */
    index: number;
    /**
     * User ID on server (unique on server).
     */
    userid: EntityIndex;
    /**
     * Player network (i.e steam) id.
     */
    networkid: string;
    /**
     * Ip:port.
     */
    address: string;
}

interface ModifierEventEvent {
    eventname: string;
    caster: number;
    ability: number;
}

interface DotaPlayerKillEvent {
    victim_userid: EntityIndex;
    killer1_userid: EntityIndex;
    killer2_userid: EntityIndex;
    killer3_userid: EntityIndex;
    killer4_userid: EntityIndex;
    killer5_userid: EntityIndex;
    bounty: number;
    neutral: number;
    greevil: number;
}

interface DotaPlayerDenyEvent {
    killer_userid: EntityIndex;
    victim_userid: EntityIndex;
}

interface DotaBarracksKillEvent {
    barracks_id: number;
    killer_playerid: PlayerID;
    killer_team: number;
    bounty_amount: number;
}

interface DotaTowerKillEvent {
    killer_userid: EntityIndex;
    teamnumber: number;
    gold: number;
}

interface DotaEffigyKillEvent {
    owner_userid: EntityIndex;
}

interface DotaRoshanKillEvent {
    teamnumber: number;
    gold: number;
}

interface DotaCourierLostEvent {
    killerid: number;
    teamnumber: number;
    bounty_gold: number;
}

interface DotaCourierRespawnedEvent {
    teamnumber: number;
}

interface DotaGlyphUsedEvent {
    teamnumber: number;
}

interface DotaSuperCreepsEvent {
    teamnumber: number;
}

interface DotaItemPurchaseEvent {
    userid: EntityIndex;
    item_ability_id: number;
}

interface DotaItemGiftedEvent {
    userid: EntityIndex;
    item_ability_id: number;
    sourceid: number;
}

interface DotaItemPlacedInNeutralStashEvent {
    userid: EntityIndex;
    item_ability_id: number;
}

interface DotaRunePickupEvent {
    userid: EntityIndex;
    type: number;
    rune: number;
    bounty_amount: number;
}

interface DotaWardKilledEvent {
    userid: EntityIndex;
    type: number;
    bounty_amount: number;
}

interface DotaRuneSpottedEvent {
    userid: EntityIndex;
    rune: number;
    map_location: string;
    rune_team: number;
}

interface DotaItemSpottedEvent {
    userid: EntityIndex;
    item_ability_id: number;
}

interface DotaNoBattlePointsEvent {
    userid: EntityIndex;
    reason: number;
}

interface DotaChatInformationalEvent {
    userid: EntityIndex;
    type: number;
}

interface DotaActionItemEvent {
    reason: number;
    itemdef: number;
    message: number;
}

interface DotaChatBanNotificationEvent {
    userid: EntityIndex;
}

interface DotaChatEventEvent {
    userid: EntityIndex;
    gold: number;
    message: number;
}

interface DotaChatTimedRewardEvent {
    userid: EntityIndex;
    itmedef: number;
    message: number;
}

interface DotaPauseEventEvent {
    userid: EntityIndex;
    value: number;
    message: number;
}

interface DotaChatKillStreakEvent {
    gold: number;
    killer_id: number;
    killer_streak: number;
    killer_multikill: number;
    victim_id: number;
    victim_streak: number;
}

interface DotaChatFirstBloodEvent {
    gold: number;
    killer_id: number;
    victim_id: number;
}

interface DotaChatAssassinAnnounceEvent {
    assassin_id: number;
    target_id: number;
    message: number;
}

interface DotaChatAssassinDeniedEvent {
    assassin_id: number;
    target_id: number;
    message: number;
}

interface DotaChatAssassinSuccessEvent {
    assassin_id: number;
    target_id: number;
    message: number;
}

interface DotaPlayerUpdateHeroSelectionEvent {
    tabcycle: 0 | 1;
}

interface DotaPlayerTakeTowerDamageEvent {
    PlayerID: PlayerID;
    damage: number;
}

interface DotaHudErrorMessageEvent {
    reason: number;
    message: string;
}

interface DotaTeamNeutralStashItemsChangedEvent {
    teamnumber: number;
}

interface DotaTeamNeutralStashItemsAcknowledgedChangedEvent {
    teamnumber: number;
}

interface DotaPortraitUnitModifiersChangedEvent {
    modifier_affects_abilities: 0 | 1;
}

interface DotaItemPickedUpEvent {
    itemname: string;
    PlayerID: PlayerID;
    ItemEntityIndex: EntityIndex;
    HeroEntityIndex: EntityIndex;
}

interface DotaInventoryItemChangedEvent {
    entityIndex: EntityIndex;
}

interface DotaAbilityChangedEvent {
    entityIndex: EntityIndex;
}

interface DotaSpectatorTalentChangedEvent {
    abilityname: string;
    playerid: PlayerID;
}

interface DotaInventoryItemAddedEvent {
    itemname: string;
}

interface DotaLinkClickedEvent {
    link: string;
    /**
     * Internal to item panel - preserve the nav stack.
     */
    nav: 0 | 1;
    /**
     * Internal to item panel - preserve the nav stack.
     */
    nav_back: 0 | 1;
    recipe: number;
    /**
     * Show the item in a particular shop.
     */
    shop: number;
}

interface DotaSetQuickBuyEvent {
    item: string;
    recipe: number;
    toggle: 0 | 1;
}

interface DotaQuickBuyChangedEvent {
    item: string;
    recipe: number;
}

interface DotaPlayerShopChangedEvent {
    prevshopmask: number;
    shopmask: number;
}

interface DotaHeroEnteredShopEvent {
    shop_type: number;
    shop_entindex: EntityIndex;
    hero_entindex: EntityIndex;
}

interface DotaPlayerShowKillcamEvent {
    nodes: number;
    player: number;
}

interface DotaPlayerShowMinikillcamEvent {
    nodes: number;
    player: number;
}

interface PlayerInfoIndividualUpdatedEvent {
    account_id: number;
}

interface MatchHistoryUpdatedEvent {
    SteamID: number;
}

interface MatchDetailsUpdatedEvent {
    matchID: number;
    result: number;
}

interface TeamDetailsUpdatedEvent {
    teamID: number;
}

interface RecentMatchesUpdatedEvent {
    Page: number;
}

interface PersonaUpdatedEvent {
    SteamID: number;
}

interface LastHitEvent {
    PlayerID: PlayerID;
    EntKilled: number;
    FirstBlood: 0 | 1;
    HeroKill: 0 | 1;
    TowerKill: 0 | 1;
}

interface PlayerCompletedGameEvent {
    PlayerID: PlayerID;
    Winner: number;
}

interface PlayerReconnectedEvent {
    PlayerID: PlayerID;
}

interface NommedTreeEvent {
    PlayerID: PlayerID;
}

interface DotaRuneActivatedServerEvent {
    PlayerID: PlayerID;
    rune: number;
}

interface DotaPlayerGainedLevelEvent {
    player: number;
    player_id: PlayerID;
    level: number;
    hero_entindex: EntityIndex;
    PlayerID: PlayerID;
}

interface DotaPlayerLearnedAbilityEvent {
    PlayerID: PlayerID;
    player: number;
    abilityname: string;
}

interface DotaPlayerUsedAbilityEvent {
    PlayerID: PlayerID;
    abilityname: string;
    caster_entindex: EntityIndex;
}

interface DotaNonPlayerUsedAbilityEvent {
    abilityname: string;
    caster_entindex: EntityIndex;
}

interface DotaPlayerBeginCastEvent {
    PlayerID: PlayerID;
    abilityname: string;
    caster_entindex: EntityIndex;
}

interface DotaNonPlayerBeginCastEvent {
    abilityname: string;
    caster_entindex: EntityIndex;
}

interface DotaAbilityChannelFinishedEvent {
    abilityname: string;
    interrupted: 0 | 1;
}

interface DotaHoldoutReviveCompleteEvent {
    caster: number;
    target: number;
    channel_time: number;
}

interface DotaHoldoutReviveEliminatedEvent {
    caster: number;
    target: number;
    channel_time: number;
}

interface DotaPlayerKilledEvent {
    PlayerID: PlayerID;
    HeroKill: 0 | 1;
    TowerKill: 0 | 1;
}

interface DotaItemPurchasedEvent {
    PlayerID: PlayerID;
    itemname: string;
    itemcost: number;
}

interface DotaItemCombinedEvent {
    PlayerID: PlayerID;
    itemname: string;
    itemcost: number;
}

interface DotaItemUsedEvent {
    PlayerID: PlayerID;
    itemname: string;
}

interface DotaItemAutoPurchaseEvent {
    item_id: number;
}

interface DotaUnitEventEvent {
    victim: number;
    attacker: number;
    basepriority: number;
    priority: number;
    /**
     * EDOTAHeroChaseEventType.
     */
    eventtype: number;
}

interface DotaQuestStartedEvent {
    /**
     * Entity index.
     */
    questIndex: number;
}

interface DotaQuestCompletedEvent {
    /**
     * Entity index.
     */
    questIndex: number;
}

interface PlayerFullyjoinedEvent {
    /**
     * User ID on server.
     */
    userid: EntityIndex;
    /**
     * Player name.
     */
    name: string;
}

interface DotaSpectateHeroEvent {
    entindex: EntityIndex;
}

interface DotaMatchDoneEvent {
    /**
     * The ID of the winning team.
     */
    winningteam: number;
}

interface JoinedChatChannelEvent {
    channelName: string;
}

interface LeftChatChannelEvent {
    channelName: string;
}

interface FileDownloadedEvent {
    success: 0 | 1;
    local_filename: string;
    remote_url: string;
}

interface PlayerReportCountsUpdatedEvent {
    positive_remaining: number;
    negative_remaining: number;
    positive_total: number;
    negative_total: number;
}

interface ScaleformFileDownloadCompleteEvent {
    success: 0 | 1;
    local_filename: string;
    remote_url: string;
}

interface ItemPurchasedEvent {
    itemid: number;
}

interface DotaWorkshopFileselectedEvent {
    filename: string;
}

interface DotaHeroRandomEvent {
    userid: EntityIndex;
    heroid: number;
}

interface DotaRiverPaintedEvent {
    userid: EntityIndex;
    riverid: number;
}

interface DotaScanUsedEvent {
    teamnumber: number;
}

interface DotaScanFoundEnemyEvent {
    teamnumber: number;
}

interface DotaRdChatTurnEvent {
    userid: EntityIndex;
}

interface DotaAdNominatedBanEvent {
    heroid: number;
}

interface DotaAdBanEvent {
    heroid: number;
}

interface DotaAdBanCountEvent {
    count: number;
}

interface DotaAdHeroCollisionEvent {
    heroid: number;
    playerid1: PlayerID;
    playerid2: PlayerID;
}

interface DashboardSwitchedSectionEvent {
    section: number;
}

interface DotaTournamentItemEventEvent {
    winner_count: number;
    event_type: number;
}

interface DotaHeroSwapEvent {
    playerid1: PlayerID;
    playerid2: PlayerID;
}

interface HalloweenPhaseEndEvent {
    phase: number;
    team: number;
}

interface DotaHudSkinChangedEvent {
    skin: string;
    style: number;
}

interface DotaInventoryPlayerGotItemEvent {
    itemname: string;
}

interface DotaTutorialShopToggledEvent {
    shop_opened: 0 | 1;
}

interface HighlightHudElementEvent {
    elementname: string;
    duration: number;
}

interface DotaCourierTransferItemEvent {
    hero_entindex: EntityIndex;
    courier_entindex: EntityIndex;
    item_entindex: EntityIndex;
}

interface ClientDisconnectEvent {
    reason_code: number;
    reason_desc: string;
}

interface HeroSelectorPreviewSetEvent {
    setindex: number;
}

interface AntiaddictionToastEvent {
    message: string;
    duration: number;
}

interface ShowCenterMessageEvent {
    message: string;
    duration: number;
    clear_message_queue: 0 | 1;
}

interface HudFlipChangedEvent {
    flipped: 0 | 1;
}

interface DefeatedEvent {
    entindex: EntityIndex;
}

interface CustomGameDifficultyEvent {
    difficulty: number;
}

interface TreeCutEvent {
    tree_x: number;
    tree_y: number;
}

interface UgcDetailsArrivedEvent {
    published_file_id: number;
}

interface UgcSubscribedEvent {
    published_file_id: number;
}

interface UgcUnsubscribedEvent {
    published_file_id: number;
}

interface UgcDownloadRequestedEvent {
    published_file_id: number;
}

interface UgcInstalledEvent {
    published_file_id: number;
}

interface PrizepoolReceivedEvent {
    success: 0 | 1;
    prizepool: number;
    leagueid: number;
}

interface MicrotransactionSuccessEvent {
    txnid: number;
}

interface DotaRubickAbilityStealEvent {
    abilityIndex: number;
    abilityLevel: number;
}

interface SpecItemPickupEvent {
    player_id: PlayerID;
    item_name: string;
    purchase: 0 | 1;
    gift: 0 | 1;
    gift_player_id: PlayerID;
}

interface SpecAegisReclaimTimeEvent {
    reclaim_time: number;
}

interface AccountTrophiesChangedEvent {
    account_id: number;
}

interface AccountAllHeroChallengeChangedEvent {
    account_id: number;
}

interface TeamShowcaseUiUpdateEvent {
    show: 0 | 1;
    account_id: number;
    hero_entindex: EntityIndex;
    display_ui_on_left: 0 | 1;
}

interface DotaIllusionsCreatedEvent {
    original_entindex: EntityIndex;
}

interface DotaYearBeastKilledEvent {
    killer_player_id: PlayerID;
    message: number;
    beast_id: number;
}

interface DotaPlayerSpawnedEvent {
    PlayerID: PlayerID;
}

interface DotaHeroUndoselectionEvent {
    playerid1: PlayerID;
}

interface PlayerProfileStatsUpdatedEvent {
    account_id: number;
}

interface CustomGamePlayerCountUpdatedEvent {
    custom_game_id: number;
}

interface CustomGameFriendsPlayedUpdatedEvent {
    custom_game_id: number;
}

interface DotaPlayerUpdateAssignedHeroEvent {
    playerid: PlayerID;
}

interface DotaNpcGoalReachedEvent {
    /**
     * Entity index of the npc which was following a path and has reached a goal
     * entity.
     */
    npc_entindex: EntityIndex;
    /**
     * Entity index of the path goal entity which has been reached.
     */
    goal_entindex: EntityIndex;
    /**
     * Entity index of the next goal entity on the path (if any) which the npc will
     * now be pathing towards.
     */
    next_goal_entindex: EntityIndex;
}

interface DotaPlayerSelectedCustomTeamEvent {
    /**
     * Player id of the player who select a team.
     */
    player_id: PlayerID;
    /**
     * Id of the team the player selected.
     */
    team_id: number;
    /**
     * Was the player successfully assigned to the selected team.
     */
    success: 0 | 1;
}

interface DotaCoinWagerEvent {
    userid: EntityIndex;
    message: number;
    coins: number;
}

interface DotaWagerTokenEvent {
    userid: EntityIndex;
    message: number;
    amount: number;
}

interface DotaRankWagerEvent {
    userid: EntityIndex;
}

interface DotaBountyEvent {
    userid: EntityIndex;
    target: number;
    bounty_event: number;
}

interface DotaReportSubmittedEvent {
    result: number;
    report_flags: number;
    message: string;
}

interface DotaHeroInventoryItemChangeEvent {
    player_id: number;
    hero_entindex: EntityIndex;
    item_entindex: EntityIndex;
    removed: 0 | 1;
}

interface AegisEventEvent {
    player_id: PlayerID;
    chat_message_type: number;
}

interface DotaBuybackEvent {
    entindex: EntityIndex;
    player_id: number;
}

interface BoughtBackEvent {
    player_id: PlayerID;
}

interface DotaShrineKillEvent {
    killer_userid: EntityIndex;
    teamnumber: number;
    gold: number;
}

interface ParticleSystemStartEvent {
    targetname: string;
}

interface ParticleSystemStopEvent {
    targetname: string;
    immediate: 0 | 1;
}

interface DotaCombatEventMessageEvent {
    message: string;
    teamnumber: number;
    player_id: number;
    player_id2: number;
    value: number;
    int_value: number;
    ability_name: string;
    locstring_value: string;
    string_replace_token: string;
}

interface DotaItemSpawnedEvent {
    item_ent_index: EntityIndex;
    player_id: number;
}

interface DotaPlayerReconnectedEvent {
    player_id: number;
}

interface DotaOnHeroFinishSpawnEvent {
    heroindex: number;
    hero: string;
}

interface DotaCreatureGainedLevelEvent {
    entindex: EntityIndex;
    level: number;
}

interface DotaHeroTeleportToUnitEvent {
    hero_entindex: EntityIndex;
    unit_entindex: EntityIndex;
}

interface DotaNeutralCreepCampClearedEvent {
    camp_name: string;
    camp_type: number;
    killer_player_id: number;
}

interface NpcSpawnedEvent {
    entindex: EntityIndex;
}

interface NpcReplacedEvent {
    old_entindex: EntityIndex;
    new_entindex: EntityIndex;
}

interface EntityHurtEvent {
    entindex_killed: EntityIndex;
    entindex_attacker: EntityIndex;
    entindex_inflictor: EntityIndex;
    damagebits: number;
    damage: number;
}

/**
 * The specified channel contains new messages.
 */
interface ChatNewMessageEvent {
    channel: number;
}

/**
 * The specified channel has had players leave or join.
 */
interface ChatMembersChangedEvent {
    channel: number;
}

interface DotaTeamKillCreditEvent {
    killer_userid: EntityIndex;
    victim_userid: EntityIndex;
    teamnumber: number;
    herokills: number;
}
