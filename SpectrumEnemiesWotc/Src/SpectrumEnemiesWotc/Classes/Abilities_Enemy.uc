class Abilities_Enemy extends X2Ability dependson (XComGameStateContext_Ability) config(SpectrumAbilities);

// Unthemed units


var config int PSIDET_ENV_DMG;
var config float PSIDET_RADIUS_METERS;
var config int SECTOID_MINDSPIN_DISORIENTED_DURATION;
var config int SECTOID_MINDSPIN_CONFUSED_DURATION;
var config int SECTOID_MINDSPIN_CONTROL_DURATION;
var config float SECTOID_REANIMATION_ZOMBIE_RISE_DELAY;

var name DelayedPsiExplosionEffectName;
var name PsiExplosionTriggerName;
var name SireZombieLinkName;




var config int PSI_BOMB_LOCAL_COOLDOWN;
var config int PSI_BOMB_GLOBAL_COOLDOWN;
var config int PSI_BOMB_RADIUS_METERS;
var config int PSI_BOMB_RANGE_METERS;
var config StatCheck PSI_BOMB_SOURCE_CHECK;
var config StatCheck PSI_BOMB_TARGET_CHECK;
var config float PSI_BOMB_STAGE1_START_WARNING_FX_SEC;
var config float PSI_BOMB_STAGE2_START_EXPLOSION_FX_SEC;
var config float PSI_BOMB_STAGE2_NOTIFY_TARGETS_SEC;


var name CyberusTemplateName;

var name Stage1PsiBombEffectName;
var name PsiBombTriggerName;
var name DamageTeleportDamageChainIndexName;

var array<X2AbilityTemplate>    ExtraTemplates;

var private name CyberusForcedDeadName;
var privatewrite name OriginalCyberusValueName;

defaultproperties
{
	CyberusTemplateName="Cyberus"
	CyberusForcedDeadName="CyberusForcedDead"
	Stage1PsiBombEffectName="Stage1PsiBombEffect"
	PsiBombTriggerName="PsiBombTrigger"
	DamageTeleportDamageChainIndexName="DamageTeleportDamageChainIndexName"
	OriginalCyberusValueName="OriginalCyberusValue"
}

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	


	Templates.AddItem(MindspinAdv());
	Templates.AddItem(PsiBomb_Adv1());
	Templates.AddItem(PsiBomb_Adv2());	

	return Templates;
}

static function X2DataTemplate MindspinAdv()
{
	local X2AbilityTemplate Template;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2Condition_UnitProperty UnitPropertyCondition;
	local X2Condition_Visibility TargetVisibilityCondition;
	local X2Condition_UnitEffects UnitEffectsCondition;
	local X2AbilityTarget_Single SingleTarget;
	local X2AbilityTrigger_PlayerInput InputTrigger;
	local X2AbilityCooldown_LocalAndGlobal Cooldown;
	local X2Condition_UnitEffects		ExcludeEffects;
	local X2Effect_PersistentStatChange DisorientedEffect;
	local X2Condition_UnitImmunities	UnitImmunityCondition;
	local X2Effect_Panicked             PanickedEffect;


	`CREATE_X2ABILITY_TEMPLATE(Template, 'Mindspin_Adv');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_advent_marktarget";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.Hostility = eHostility_Offensive;

	Cooldown = new class'X2AbilityCooldown_LocalAndGlobal';
	Cooldown.iNumTurns = 2;
	Template.AbilityCooldown = Cooldown;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bFreeCost = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	UnitEffectsCondition = new class'X2Condition_UnitEffects';
	UnitEffectsCondition.AddExcludeEffect(class'X2Effect_MindControl'.default.EffectName, 'AA_UnitIsMindControlled');
	Template.AbilityShooterConditions.AddItem(UnitEffectsCondition);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.RequireWithinRange = false;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);
	
	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

	Template.AbilityToHitCalc = new class'X2AbilityToHitCalc_StatCheck_UnitVsUnit';

	SingleTarget = new class'X2AbilityTarget_Single';
	Template.AbilityTargetStyle = SingleTarget;

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);

	ExcludeEffects = new class'X2Condition_UnitEffects';
	ExcludeEffects.AddExcludeEffect(class'X2Ability_CarryUnit'.default.CarryUnitEffectName, 'AA_UnitIsImmune');
	Template.AbilityTargetConditions.AddItem(ExcludeEffects);

	UnitImmunityCondition = new class'X2Condition_UnitImmunities';
	UnitImmunityCondition.AddExcludeDamageType('Mental');
	UnitImmunityCondition.bOnlyOnCharacterTemplate = true;
	Template.AbilityTargetConditions.AddItem(UnitImmunityCondition);

	DisorientedEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect();
	DisorientedEffect.iNumTurns = 2;
	DisorientedEffect.MinStatContestResult = 1;
	DisorientedEffect.MaxStatContestResult = 2;
	Template.AddTargetEffect(DisorientedEffect);

	PanickedEffect = class'X2StatusEffects'.static.CreatePanickedStatusEffect();
	PanickedEffect.MinStatContestResult = 3;
	PanickedEffect.MaxStatContestResult = 10;
	Template.AddTargetEffect(PanickedEffect);

	Template.TargetMissSpeech = 'SoldierResistsMindControl';

	Template.bShowActivation = true;
	Template.CustomFireAnim = 'HL_Psi_MindControl';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.CinescriptCameraType = "Psionic_FireAtUnit";

	return Template;
}


static function X2AbilityTemplate PsiBomb_Adv1()
{
	local X2AbilityTemplate Template;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2AbilityCooldown_LocalAndGlobal Cooldown;
	local X2AbilityMultiTarget_Radius RadiusMultiTarget;
	local X2Effect_MarkValidActivationTiles MarkTilesEffect;
	local X2AbilityTarget_Cursor CursorTarget;
	local X2Effect_DelayedAbilityActivation DelayedDimensionalRiftEffect;
	local X2Effect_DisableWeapon DisableWeapon;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'PsiBombAdvStage1');

	Template.AdditionalAbilities.AddItem('PsiBombAdvStage2');
	Template.AdditionalAbilities.AddItem('SniperRifleOverwatch');
	Template.TwoTurnAttackAbility = 'PsiBombStage2';
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_psibomb";

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.bShowActivation = true;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown_LocalAndGlobal';
	Cooldown.iNumTurns = default.PSI_BOMB_LOCAL_COOLDOWN;
	Cooldown.NumGlobalTurns = default.PSI_BOMB_GLOBAL_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.PSI_BOMB_RADIUS_METERS;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	MarkTilesEffect = new class'X2Effect_MarkValidActivationTiles';
	MarkTilesEffect.AbilityToMark = 'PsiBombStage2';
	MarkTilesEffect.OnlyUseTargetLocation = true;
	Template.AddShooterEffect(MarkTilesEffect);

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToSquadsightRange = true;
	CursorTarget.FixedAbilityRange = default.PSI_BOMB_RANGE_METERS;
	Template.AbilityTargetStyle = CursorTarget;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	//Effect on a successful test is adding the delayed marked effect to the target
	DelayedDimensionalRiftEffect = new class 'X2Effect_DelayedAbilityActivation';
	DelayedDimensionalRiftEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin);
	DelayedDimensionalRiftEffect.EffectName = default.Stage1PsiBombEffectName;
	DelayedDimensionalRiftEffect.TriggerEventName = default.PsiBombTriggerName;
	DelayedDimensionalRiftEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true, , Template.AbilitySourceName);
	Template.AddShooterEffect(DelayedDimensionalRiftEffect);

	DisableWeapon = new class'X2Effect_DisableWeapon';
	DisableWeapon.TargetConditions.AddItem(default.LivingTargetUnitOnlyProperty);
	Template.AddMultiTargetEffect(DisableWeapon);

	Template.TargetingMethod = class'X2TargetingMethod_VoidRift';

	Template.CustomFireAnim = 'HL_Malfunction';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = PsiBombStage1_BuildVisualization;
	Template.BuildAffectedVisualizationSyncFn = PsiBombStage1_BuildAffectedVisualization;
	Template.CinescriptCameraType = "Codex_PsiBomb_Stage1";
	Template.DamagePreviewFn = PsiBombDamagePreview;

	return Template;
}

function bool PsiBombDamagePreview(XComGameState_Ability AbilityState, StateObjectReference TargetRef, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
	local XComGameState_Unit AbilityOwner;
	local StateObjectReference PsiBombStage2Ref;
	local XComGameState_Ability PsiBombStage2Ability;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;
	AbilityOwner = XComGameState_Unit(History.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
	PsiBombStage2Ref = AbilityOwner.FindAbility('PsiBombStage2');
	PsiBombStage2Ability = XComGameState_Ability(History.GetGameStateForObjectID(PsiBombStage2Ref.ObjectID));
	if( PsiBombStage2Ability == none )
	{
		`RedScreenOnce("Unit has PsiBombStage1 but is missing PsiBombStage2. No es Bueno. -dslonneger @gameplay");
	}
	else
	{
		PsiBombStage2Ability.GetDamagePreview(TargetRef, MinDamagePreview, MaxDamagePreview, AllowsShield);
	}
	return true;
}

simulated function PsiBombStage1_BuildAffectedVisualization(name EffectName, XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata )
{
	local XComGameStateContext_Ability Context;
	local X2Action_PlayEffect EffectAction;
	local X2Action_StartStopSound SoundAction;
	local XComGameState_Unit CyberusUnit;
	local XComWorldData World;
	local vector TargetLocation;
	local TTile TargetTile;
	
	if( !`XENGINE.IsMultiplayerGame() && EffectName == default.Stage1PsiBombEffectName )
	{
		Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
		CyberusUnit = XComGameState_Unit(ActionMetadata.StateObject_NewState);

		if( (Context == none) || (CyberusUnit == none) )
		{
			return;
		}

		World = `XWORLD;

		// Display the Warning FX (convert to tile and back to vector because stage 2 is at the GetPositionFromTileCoordinates coord
		EffectAction = X2Action_PlayEffect(class'X2Action_PlayEffect'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
		EffectAction.EffectName = "FX_Psi_Bomb.P_Psi_Bomb_Warning";

		TargetLocation = Context.InputContext.TargetLocations[0];
		TargetTile = World.GetTileCoordinatesFromPosition(TargetLocation);

		EffectAction.EffectLocation = World.GetPositionFromTileCoordinates(TargetTile);

		// Play Target Activate Sound
		SoundAction = X2Action_StartStopSound(class'X2Action_StartStopSound'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
		SoundAction.Sound = new class'SoundCue';
		SoundAction.Sound.AkEventOverride = AkEvent'SoundX2CyberusFX.Cyberus_Psi_Bomb_Target_Activate';
		SoundAction.iAssociatedGameStateObjectId = CyberusUnit.ObjectID;
		SoundAction.bStartPersistentSound = true;
		SoundAction.bIsPositional = true;
		SoundAction.vWorldPosition = EffectAction.EffectLocation;
	}
}

simulated function PsiBombStage1_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability Context;
	local StateObjectReference InteractingUnitRef;
	local X2VisualizerInterface Visualizer;
	local VisualizationActionMetadata CyberusBuildTrack, ActionMetadata, EmptyTrack;
	local X2Action_PlayEffect EffectAction;
	local X2Action_StartStopSound SoundAction;
	local XComGameState_Unit CyberusUnit;
	local XComWorldData World;
	local vector TargetLocation;
	local TTile TargetTile;
	local X2Action_TimedWait WaitAction;
	local X2Action_PlaySoundAndFlyOver SoundCueAction;
	local int i, j;
	local X2VisualizerInterface TargetVisualizerInterface;
	local X2Action_Fire_CloseUnfinishedAnim CloseFireAction;
	local XGUnit CodexUnit;
	local XComUnitPawn CodexPawn;
	local X2Action ExitCoverAction;

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());

	//Configure the visualization track for the shooter
	//****************************************************************************************
	InteractingUnitRef = Context.InputContext.SourceObject;
	CyberusBuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	CyberusBuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	CyberusBuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	CyberusUnit = XComGameState_Unit(CyberusBuildTrack.StateObject_NewState);

	if( CyberusUnit != none )
	{
		World = `XWORLD;

		// Exit cover
		ExitCoverAction = class'X2Action_ExitCover'.static.AddToVisualizationTree(CyberusBuildTrack, Context);

		//If we were interrupted, insert a marker node for the interrupting visualization code to use. In the move path version above, it is expected for interrupts to be 
		//done during the move.
		if (Context.InterruptionStatus != eInterruptionStatus_None)
		{
			//Insert markers for the subsequent interrupt to insert into
			class'X2Action'.static.AddInterruptMarkerPair(CyberusBuildTrack, Context, ExitCoverAction);
		}

		class'X2Action_Fire_OpenUnfinishedAnim'.static.AddToVisualizationTree(CyberusBuildTrack, Context);

		// Wait to time the start of the warning FX
		WaitAction = X2Action_TimedWait(class'X2Action_TimedWait'.static.AddToVisualizationTree(CyberusBuildTrack, Context));
		WaitAction.DelayTimeSec = default.PSI_BOMB_STAGE1_START_WARNING_FX_SEC;

		// Display the Warning FX (convert to tile and back to vector because stage 2 is at the GetPositionFromTileCoordinates coord
		EffectAction = X2Action_PlayEffect(class'X2Action_PlayEffect'.static.AddToVisualizationTree(CyberusBuildTrack, Context));
		EffectAction.EffectName = "FX_Psi_Bomb.P_Psi_Bomb_Warning";

		TargetLocation = Context.InputContext.TargetLocations[0];
		TargetTile = World.GetTileCoordinatesFromPosition(TargetLocation);

		EffectAction.EffectLocation = World.GetPositionFromTileCoordinates(TargetTile);

		// Play Target Activate Sound
		SoundAction = X2Action_StartStopSound(class'X2Action_StartStopSound'.static.AddToVisualizationTree(CyberusBuildTrack, Context));
		SoundAction.Sound = new class'SoundCue';
		SoundAction.Sound.AkEventOverride = AkEvent'SoundX2CyberusFX.Cyberus_Psi_Bomb_Target_Activate';
		SoundAction.iAssociatedGameStateObjectId = CyberusUnit.ObjectID;
		SoundAction.bStartPersistentSound = true;
		SoundAction.bIsPositional = true;
		SoundAction.vWorldPosition = EffectAction.EffectLocation;

		// Play the sound cue
		SoundCueAction = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(CyberusBuildTrack, Context));
		SoundCueAction.SetSoundAndFlyOverParameters(SoundCue'SoundX2CyberusFX.Cyberus_Psi_Bomb_Target_Activate_Cue', "", '', eColor_Good);

		CloseFireAction = X2Action_Fire_CloseUnfinishedAnim(class'X2Action_Fire_CloseUnfinishedAnim'.static.AddToVisualizationTree(CyberusBuildTrack, Context));
		CloseFireAction.bNotifyTargets = true;

		Visualizer = X2VisualizerInterface(CyberusBuildTrack.VisualizeActor);
		if( Visualizer != none )
		{
			Visualizer.BuildAbilityEffectsVisualization(VisualizeGameState, CyberusBuildTrack);
		}

		class'X2Action_EnterCover'.static.AddToVisualizationTree(CyberusBuildTrack, Context);

		CodexUnit = XGUnit(CyberusBuildTrack.VisualizeActor);
		if( CodexUnit != none )
		{
			CodexPawn = CodexUnit.GetPawn();
			if( CodexPawn != none )
			{
				X2Action_SetWeapon(class'X2Action_SetWeapon'.static.AddToVisualizationTree(CyberusBuildTrack, Context)).WeaponToSet = XComWeapon(CodexPawn.Weapon);
			}
		}
		//****************************************************************************************

		//****************************************************************************************
		//Configure the visualization track for the targets
		//****************************************************************************************
		for( i = 0; i < Context.InputContext.MultiTargets.Length; ++i )
		{
			InteractingUnitRef = Context.InputContext.MultiTargets[i];
			if( InteractingUnitRef == CyberusUnit.GetReference() )
			{
				ActionMetadata = CyberusBuildTrack;
			}
			else
			{
				ActionMetadata = EmptyTrack;
				ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
				ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
				ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);
			}

			if( InteractingUnitRef != CyberusUnit.GetReference() )
			{
				class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);
			}

			for( j = 0; j < Context.ResultContext.MultiTargetEffectResults[i].Effects.Length; ++j )
			{
				Context.ResultContext.MultiTargetEffectResults[i].Effects[j].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, Context.ResultContext.MultiTargetEffectResults[i].ApplyResults[j]);
			}

			TargetVisualizerInterface = X2VisualizerInterface(ActionMetadata.VisualizeActor);
			if( TargetVisualizerInterface != none )
			{
				//Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
				TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, ActionMetadata);
			}
		}

		TypicalAbility_AddEffectRedirects(VisualizeGameState, CyberusBuildTrack);
	}
}

static function X2AbilityTemplate PsiBomb_Adv2()
{
	local X2AbilityTemplate Template;
	local X2AbilityMultiTarget_Radius RadiusMultiTarget;
	local X2Condition_UnitProperty LivingTargetCondition;
	local X2AbilityTrigger_EventListener DelayedEventListener;
	local X2Effect_ApplyWeaponDamage RiftDamageEffect;
	local X2Effect_PerkAttachForFX FXEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'PsiBombAdvStage2');

	Template.bDontDisplayInAbilitySummary = true;
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';

	Template.AbilityToHitCalc = default.DeadEye;

	LivingTargetCondition = new class'X2Condition_UnitProperty';
	LivingTargetCondition.ExcludeFriendlyToSource = false;
	LivingTargetCondition.ExcludeHostileToSource = false;
	LivingTargetCondition.ExcludeAlive = false;
	LivingTargetCondition.ExcludeDead = true;
	LivingTargetCondition.FailOnNonUnits = true;
	Template.AbilityMultiTargetConditions.AddItem(LivingTargetCondition);

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.PSI_BOMB_RADIUS_METERS;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	// TODO: This doesn't actually target self but needs an AbilityTargetStyle
	Template.AbilityTargetStyle = default.SelfTarget;

	// This ability fires when the event DelayedExecuteRemoved fires on this unit
	DelayedEventListener = new class'X2AbilityTrigger_EventListener';
	DelayedEventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	DelayedEventListener.ListenerData.EventID = default.PsiBombTriggerName;
	DelayedEventListener.ListenerData.Filter = eFilter_Unit;
	DelayedEventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_ValidAbilityLocation;
	Template.AbilityTriggers.AddItem(DelayedEventListener);

	// This effect is here to attach perk FX to
	FXEffect = new class'X2Effect_PerkAttachForFX';
	Template.AddShooterEffect(FXEffect);

	RiftDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	RiftDamageEffect.EffectDamageValue.DamageType = 'Psi';
	RiftDamageEffect.EffectDamageValue = class'X2Item_DefaultWeapons'.default.CYBERUS_PSI_BOMB_BASEDAMAGE;
	Template.AddMultiTargetEffect(RiftDamageEffect);

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = PsiBombStage2_BuildVisualization;
	Template.CinescriptCameraType = "Codex_PsiBomb_Stage2";

	return Template;
}

simulated function PsiBombStage2_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  Context;
	local StateObjectReference InteractingUnitRef;
	local X2AbilityTemplate AbilityTemplate;
	local VisualizationActionMetadata EmptyTrack;
	local VisualizationActionMetadata CyberusBuildTrack, ActionMetadata;
	local int i, j;
	local X2VisualizerInterface TargetVisualizerInterface;
	local XComGameState_EnvironmentDamage EnvironmentDamageEvent;
	local XComGameState_WorldEffectTileData WorldDataUpdate;
	local XComGameState_InteractiveObject InteractiveObject;
	local X2Action_PlayEffect EffectAction;
	local X2Action_StartStopSound SoundAction;
	local XComGameState_Unit CyberusUnit;
	local X2Action_TimedInterTrackMessageAllMultiTargets MultiTargetMessageAction;
	local X2Action_TimedWait WaitAction;

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;

	AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(Context.InputContext.AbilityTemplateName);

	//****************************************************************************************
	//Configure the visualization track for the source
	//****************************************************************************************
	CyberusBuildTrack = EmptyTrack;
	History.GetCurrentAndPreviousGameStatesForObjectID(InteractingUnitRef.ObjectID,
													   CyberusBuildTrack.StateObject_OldState, CyberusBuildTrack.StateObject_NewState,
													   eReturnType_Reference,
													   VisualizeGameState.HistoryIndex);
	CyberusBuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	CyberusUnit = XComGameState_Unit(CyberusBuildTrack.StateObject_OldState);

	if( CyberusUnit != none )
	{
		// Stop the Loop audio
		SoundAction = X2Action_StartStopSound(class'X2Action_StartStopSound'.static.AddToVisualizationTree(CyberusBuildTrack, Context));
		SoundAction.Sound = new class'SoundCue';
		SoundAction.Sound.AkEventOverride = AkEvent'SoundX2CyberusFX.Stop_CodexPsiBombLoop';
		SoundAction.iAssociatedGameStateObjectId = InteractingUnitRef.ObjectID;
		SoundAction.bIsPositional = true;
		SoundAction.bStopPersistentSound = true;

		// Stop the Warning FX
		EffectAction = X2Action_PlayEffect(class'X2Action_PlayEffect'.static.AddToVisualizationTree(CyberusBuildTrack, Context));
		EffectAction.EffectName = "FX_Psi_Bomb.P_Psi_Bomb_Warning";
		EffectAction.EffectLocation = Context.InputContext.TargetLocations[0];
		EffectAction.bStopEffect = true;

		// Play the Collapsing audio
		SoundAction = X2Action_StartStopSound(class'X2Action_StartStopSound'.static.AddToVisualizationTree(CyberusBuildTrack, Context));
		SoundAction.Sound = new class'SoundCue';
		SoundAction.Sound.AkEventOverride = AkEvent'SoundX2CyberusFX.Cyberus_Ability_Psi_Bomb_Collapse';
		SoundAction.bIsPositional = true;
		SoundAction.vWorldPosition = Context.InputContext.TargetLocations[0];

		// Play the Collapse FX
		EffectAction = X2Action_PlayEffect(class'X2Action_PlayEffect'.static.AddToVisualizationTree(CyberusBuildTrack, Context));
		EffectAction.EffectName = "FX_Psi_Bomb.P_Psi_Bomb_Build_Up";
		EffectAction.EffectLocation = Context.InputContext.TargetLocations[0];
		EffectAction.bWaitForCompletion = false;
		EffectAction.bWaitForCameraCompletion = false;

		// Wait to time the start of the explosion FX
		WaitAction = X2Action_TimedWait(class'X2Action_TimedWait'.static.AddToVisualizationTree(CyberusBuildTrack, Context));
		WaitAction.DelayTimeSec = default.PSI_BOMB_STAGE2_START_EXPLOSION_FX_SEC;

		// Play the Explosion audio
		SoundAction = X2Action_StartStopSound(class'X2Action_StartStopSound'.static.AddToVisualizationTree(CyberusBuildTrack, Context));
		SoundAction.Sound = new class'SoundCue';
		SoundAction.Sound.AkEventOverride = AkEvent'SoundX2AvatarFX.Avatar_Ability_Dimensional_Rift_Explode';
		SoundAction.bIsPositional = true;
		SoundAction.vWorldPosition = Context.InputContext.TargetLocations[0];

		// Play the Explosion FX
		EffectAction = X2Action_PlayEffect(class'X2Action_PlayEffect'.static.AddToVisualizationTree(CyberusBuildTrack, Context));
		EffectAction.EffectName = "FX_Psi_Bomb.P_Psi_Bomb_Explosion";
		EffectAction.EffectLocation = Context.InputContext.TargetLocations[0];

		// Notify multi targets of explosion
		MultiTargetMessageAction = X2Action_TimedInterTrackMessageAllMultiTargets(class'X2Action_TimedInterTrackMessageAllMultiTargets'.static.AddToVisualizationTree(CyberusBuildTrack, Context));
		MultiTargetMessageAction.SendMessagesAfterSec = default.PSI_BOMB_STAGE2_NOTIFY_TARGETS_SEC;
	}
	//****************************************************************************************

	//****************************************************************************************
	//Configure the visualization track for the targets
	//****************************************************************************************
	for (i = 0; i < Context.InputContext.MultiTargets.Length; ++i)
	{
		InteractingUnitRef = Context.InputContext.MultiTargets[i];

		if( InteractingUnitRef == CyberusUnit.GetReference() )
		{
			ActionMetadata = CyberusBuildTrack;

			WaitAction = X2Action_TimedWait(class'X2Action_TimedWait'.static.AddToVisualizationTree(CyberusBuildTrack, Context));
			WaitAction.DelayTimeSec = default.PSI_BOMB_STAGE2_NOTIFY_TARGETS_SEC;
		}
		else
		{
			ActionMetadata = EmptyTrack;
			ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
			ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
			ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

			class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);
		}

		for( j = 0; j < Context.ResultContext.MultiTargetEffectResults[i].Effects.Length; ++j )
		{
			Context.ResultContext.MultiTargetEffectResults[i].Effects[j].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, Context.ResultContext.MultiTargetEffectResults[i].ApplyResults[j]);
		}

		TargetVisualizerInterface = X2VisualizerInterface(ActionMetadata.VisualizeActor);
		if( TargetVisualizerInterface != none )
		{
			//Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
			TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, ActionMetadata);
		}
	}

	//****************************************************************************************
	//Configure the visualization tracks for the environment
	//****************************************************************************************
	foreach VisualizeGameState.IterateByClassType(class'XComGameState_EnvironmentDamage', EnvironmentDamageEvent)
	{
		ActionMetadata = EmptyTrack;
		ActionMetadata.VisualizeActor = none;
		ActionMetadata.StateObject_NewState = EnvironmentDamageEvent;
		ActionMetadata.StateObject_OldState = EnvironmentDamageEvent;

		//Wait until signaled by the shooter that the projectiles are hitting
		class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);

		for( i = 0; i < AbilityTemplate.AbilityMultiTargetEffects.Length; ++i )
		{
			AbilityTemplate.AbilityMultiTargetEffects[i].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, 'AA_Success');	
		}

			}

	foreach VisualizeGameState.IterateByClassType(class'XComGameState_WorldEffectTileData', WorldDataUpdate)
	{
		ActionMetadata = EmptyTrack;
		ActionMetadata.VisualizeActor = none;
		ActionMetadata.StateObject_NewState = WorldDataUpdate;
		ActionMetadata.StateObject_OldState = WorldDataUpdate;

		//Wait until signaled by the shooter that the projectiles are hitting
		class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);

		for( i = 0; i < AbilityTemplate.AbilityMultiTargetEffects.Length; ++i )
		{
			AbilityTemplate.AbilityMultiTargetEffects[i].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, 'AA_Success');	
		}

			}
	//****************************************************************************************

	//Process any interactions with interactive objects
	foreach VisualizeGameState.IterateByClassType(class'XComGameState_InteractiveObject', InteractiveObject)
	{
		// Add any doors that need to listen for notification
		if( InteractiveObject.IsDoor() && InteractiveObject.HasDestroyAnim() && InteractiveObject.InteractionCount % 2 != 0 ) //Is this a closed door?
		{
			ActionMetadata = EmptyTrack;
			//Don't necessarily have a previous state, so just use the one we know about
			ActionMetadata.StateObject_OldState = InteractiveObject;
			ActionMetadata.StateObject_NewState = InteractiveObject;
			ActionMetadata.VisualizeActor = History.GetVisualizer(InteractiveObject.ObjectID);
			class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);
			class'X2Action_BreakInteractActor'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);

					}
	}

	TypicalAbility_AddEffectRedirects(VisualizeGameState, CyberusBuildTrack);
}










static function array<X2DataTemplate> CreateTemplatesEvent()
{
	local array<X2DataTemplate> BaseTemplates, NewTemplates;
	local X2DataTemplate CurrentBaseTemplate;
	local int Index;

	BaseTemplates = CreateTemplates();
	for (Index = 0; Index < default.ExtraTemplates.Length; ++Index)
		BaseTemplates.AddItem(default.ExtraTemplates[Index]);

	for( Index = 0; Index < BaseTemplates.Length; ++Index )
	{
		CurrentBaseTemplate = BaseTemplates[Index];
		CurrentBaseTemplate.ClassThatCreatedUs = default.Class;

		if( default.bShouldCreateDifficultyVariants )
		{
			CurrentBaseTemplate.bShouldCreateDifficultyVariants = true;
		}

		if( CurrentBaseTemplate.bShouldCreateDifficultyVariants )
		{
			CurrentBaseTemplate.CreateDifficultyVariants(NewTemplates);
		}
		else
		{
			NewTemplates.AddItem(CurrentBaseTemplate);
		}
	}

	return NewTemplates;
}