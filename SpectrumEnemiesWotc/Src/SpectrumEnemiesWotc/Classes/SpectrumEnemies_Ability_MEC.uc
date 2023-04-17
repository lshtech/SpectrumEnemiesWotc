class SpectrumEnemies_Ability_MEC extends SpectrumEnemies_Ability config(SpectrumEnemies);

var config WeaponDamageValue MEC_DEATH_EXPLOSION_BASEDAMAGE;
var config int MEC_SHIELD_RANGE_METERS;	
var config int MEC_SHIELD_COOLDOWN;
var config int MEC_SHIELD_GLOBAL_COOLDOWN;
var config int MEC_SHIELD_DURATION;
var config int MEC_SHIELD_HP;
var config WeaponDamageValue MEC_LIGHTINGFIELD_BASEDAMAGE;
var config int LIGHTNINGFIELD_LOCAL_COOLDOWN;
var config int LIGHTNINGFIELD_GLOBAL_COOLDOWN;
var config float LIGHTNINGFIELD_TILE_RADIUS;
var config int REPAIR_HEAL;
var config int REPAIR_COOLDOWN;
var config int HEAVYDUTY_EXTRAHEAL;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate>     Templates;

    // Oracle
    Templates.AddItem(CreateOracleTargetAbility());

    // Heavy
    Templates.AddItem(CreateEngageSelfDestructAbility());
    Templates.AddItem(CreateSparkDeathExplosionAbility());

    // Support
    Templates.AddItem(CreateRepairAbility());

	return Templates;
}

static function X2DataTemplate CreateOracleTargetAbility()
{
	local X2AbilityTemplate Template;
	local X2AbilityCost_ActionPoints ActionPointCost;
	local X2Condition_UnitProperty UnitPropertyCondition;
	local X2Condition_Visibility TargetVisibilityCondition;
	local X2Condition_UnitEffects UnitEffectsCondition;
	local X2AbilityTarget_Single SingleTarget;
	local X2AbilityTrigger_PlayerInput InputTrigger;
	local X2Effect_Persistent MarkedEffect;
	local X2AbilityCooldown_LocalAndGlobal Cooldown;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'OracleTarget');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_advent_marktarget";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.Hostility = eHostility_Offensive;

	Cooldown = new class'X2AbilityCooldown_LocalAndGlobal';
	Cooldown.iNumTurns = 1;
	Template.AbilityCooldown = Cooldown;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 0;
	ActionPointCost.bFreeCost = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	// The shooter cannot be mind controlled
	UnitEffectsCondition = new class'X2Condition_UnitEffects';
	UnitEffectsCondition.AddExcludeEffect(class'X2Effect_MindControl'.default.EffectName, 'AA_UnitIsMindControlled');
	Template.AbilityShooterConditions.AddItem(UnitEffectsCondition);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	// Target must be an enemy
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.RequireWithinRange = false;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);
	
	// Target must be visible and may use squad sight
	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

	// Target cannot already be marked
	UnitEffectsCondition = new class'X2Condition_UnitEffects';
	UnitEffectsCondition.AddExcludeEffect(class'X2StatusEffects'.default.MarkedName, 'AA_UnitIsMarked');
	Template.AbilityTargetConditions.AddItem(UnitEffectsCondition);

	// 100% chance to hit
	Template.AbilityToHitCalc = default.DeadEye;

	SingleTarget = new class'X2AbilityTarget_Single';
	Template.AbilityTargetStyle = SingleTarget;

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);

	//// Create the Marked effect
	MarkedEffect = class'X2StatusEffects'.static.CreateMarkedEffect(2, false);

	Template.AddTargetEffect(MarkedEffect); //BMU - changing to an immediate execution for evaluation

	Template.CustomFireAnim = 'HL_SignalPoint';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TargetGettingMarked_BuildVisualization;
	Template.CinescriptCameraType = "Mark_Target";
	
	return Template;
}

simulated function TargetGettingMarked_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory				History;
	local XComGameStateContext_Ability		Context;
	local StateObjectReference				ShooterUnitRef;
	local StateObjectReference				TargetUnitRef;
	local XComGameState_Ability				Ability;
	local X2AbilityTemplate					AbilityTemplate;
	local AbilityInputContext				AbilityContext;
	
	local VisualizationActionMetadata		EmptyTrack;
	local VisualizationActionMetadata		ActionMetadata;

	local X2Action_PlaySoundAndFlyOver		SoundAndFlyOver;	
	local X2Action_PlayAnimation            PlayAnimation;

	local Actor								TargetVisualizer, ShooterVisualizer;
	local X2VisualizerInterface				TargetVisualizerInterface, ShooterVisualizerInterface;
	local int								EffectIndex;

	local name								ApplyResult;
	

	History = `XCOMHISTORY;
	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());

	AbilityContext = Context.InputContext;
	Ability = XComGameState_Ability(History.GetGameStateForObjectID(AbilityContext.AbilityRef.ObjectID));
	AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(AbilityContext.AbilityTemplateName);
	
	//Configure the visualization track for the shooter
	//****************************************************************************************
	ShooterUnitRef = Context.InputContext.SourceObject;
	ShooterVisualizer = History.GetVisualizer(ShooterUnitRef.ObjectID);
	ShooterVisualizerInterface = X2VisualizerInterface(ShooterVisualizer);

	ActionMetadata = EmptyTrack;
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(ShooterUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(ShooterUnitRef.ObjectID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(ShooterUnitRef.ObjectID);

	if (AbilityTemplate != None)
	{
		if (!AbilityTemplate.bSkipFireAction && !AbilityTemplate.bSkipExitCoverWhenFiring)
		{
			class'X2Action_ExitCover'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);
		}
	}

	SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
	SoundAndFlyOver.SetSoundAndFlyOverParameters(None, Ability.GetMyTemplate().LocFlyOverText, '', eColor_Bad);

	PlayAnimation = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
	PlayAnimation.Params.AnimName = 'HL_SignalPoint';

	if (AbilityTemplate != None && AbilityTemplate.AbilityTargetEffects.Length > 0)			//There are effects to apply
	{
		//Add any X2Actions that are specific to this effect being applied. These actions would typically be instantaneous, showing UI world messages
		//playing any effect specific audio, starting effect specific effects, etc. However, they can also potentially perform animations on the 
		//track actor, so the design of effect actions must consider how they will look/play in sequence with other effects.
		for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityTargetEffects.Length; ++EffectIndex)
		{
			ApplyResult = Context.FindTargetEffectApplyResult(AbilityTemplate.AbilityTargetEffects[EffectIndex]);

			// Source effect visualization
			AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualizationSource(VisualizeGameState, ActionMetadata, ApplyResult);
		}
	}

	if (ShooterVisualizerInterface != none)
	{
		ShooterVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, ActionMetadata);
	}

	if (AbilityTemplate != None)
	{
		if (!AbilityTemplate.bSkipFireAction && !AbilityTemplate.bSkipExitCoverWhenFiring)
		{
			class'X2Action_EnterCover'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);
		}
	}

		//****************************************************************************************

	//Configure the visualization track for the target
	//****************************************************************************************
	TargetUnitRef = Context.InputContext.PrimaryTarget;
	TargetVisualizer = History.GetVisualizer(AbilityContext.PrimaryTarget.ObjectID);
	TargetVisualizerInterface = X2VisualizerInterface(TargetVisualizer);

	ActionMetadata = EmptyTrack;
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(TargetUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(TargetUnitRef.ObjectID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(TargetUnitRef.ObjectID);
					
	Ability = XComGameState_Ability(History.GetGameStateForObjectID(Context.InputContext.AbilityRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1));

	if (AbilityTemplate != None && AbilityTemplate.AbilityTargetEffects.Length > 0)			//There are effects to apply
	{
		//Add any X2Actions that are specific to this effect being applied. These actions would typically be instantaneous, showing UI world messages
		//playing any effect specific audio, starting effect specific effects, etc. However, they can also potentially perform animations on the 
		//track actor, so the design of effect actions must consider how they will look/play in sequence with other effects.
		for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityTargetEffects.Length; ++EffectIndex)
		{
			ApplyResult = Context.FindTargetEffectApplyResult(AbilityTemplate.AbilityTargetEffects[EffectIndex]);

			// Target effect visualization
			AbilityTemplate.AbilityTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, ApplyResult);
		}

		if (TargetVisualizerInterface != none)
		{
			//Allow the visualizer to do any custom processing based on the new game state. For example, units will create a death action when they reach 0 HP.
			TargetVisualizerInterface.BuildAbilityEffectsVisualization(VisualizeGameState, ActionMetadata);
		}
	}
	
		//****************************************************************************************
}

static function X2AbilityTemplate CreateEngageSelfDestructAbility()
{
	local X2AbilityTemplate						Template;
	local X2Effect_Persistent                   SelfDestructEffect;
	local X2Effect_DamageImmunity               DamageImmunity;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'EngageSelfDestructMEC');
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_DLC3Images.UIPerk_spark_kamikaze";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideIfOtherAvailable;
	Template.HideIfAvailable.AddItem('TriggerSelfDestruct');

	Template.AdditionalAbilities.AddItem('TriggerSelfDestruct');
	Template.AdditionalAbilities.AddItem('MECDeathExplosion');
	Template.AdditionalAbilities.AddItem('ExplodingSparkInitialState');

	Template.AbilityCosts.AddItem(default.FreeActionCost);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	SelfDestructEffect = new class'X2Effect_Persistent';
	SelfDestructEffect.BuildPersistentEffect(1, true, false, true);
	SelfDestructEffect.EffectName = class'X2Ability_SparkAbilitySet'.default.SparkSelfDestructEffectName;
	SelfDestructEffect.VisualizationFn = EngageSelfDestruct_Visualization;
	Template.AddShooterEffect(SelfDestructEffect);

	// Build the immunities
	DamageImmunity = new class'X2Effect_DamageImmunity';
	DamageImmunity.BuildPersistentEffect(1, true, true, true);
	DamageImmunity.ImmuneTypes.AddItem(class'X2Item_DefaultDamageTypes'.default.KnockbackDamageType);
	DamageImmunity.EffectName = 'SelfDestructEngagedImmunities';
	Template.AddShooterEffect(DamageImmunity);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildAppliedVisualizationSyncFn = EngageSelfDestruct_BuildVisualizationSync;

	Template.bShowActivation = true;
	Template.CustomFireAnim = 'FF_Self_Destruct_Start';

	Template.TwoTurnAttackAbility = 'TriggerSelfDestruct'; // AI using this ability triggers more AI overwatchers.
	return Template;
}

static function EngageSelfDestruct_Visualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local X2Action_SetRagdoll SetRagdollAction;

	if( EffectApplyResult != 'AA_Success' )
	{
		return;
	}

	SetRagdollAction = X2Action_SetRagdoll(class'X2Action_SetRagdoll'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
	SetRagdollAction.RagdollFlag = ERagdoll_Never;
}

simulated function EngageSelfDestruct_BuildVisualizationSync( name EffectName, XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata )
{
	local XComGameStateContext_Ability  Context;
	local X2AbilityTemplate AbilityTemplate;
	local int EffectIndex;

	if( EffectName == class'X2Ability_SparkAbilitySet'.default.SparkSelfDestructEffectName )
	{
		Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());

		AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate( Context.InputContext.AbilityTemplateName);

		for( EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityShooterEffects.Length; ++EffectIndex )
		{
			AbilityTemplate.AbilityShooterEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, Context.ResultContext.ShooterEffectResults.ApplyResults[EffectIndex]);
		}
	}
}

static function X2AbilityTemplate CreateSparkDeathExplosionAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityTrigger_EventListener    EventListener;
	local X2AbilityMultiTarget_Radius       MultiTarget;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2Condition_UnitEffects           EffectConditions;
	local X2Effect_ApplyWeaponDamage        DamageEffect;
	local X2Effect_OverrideDeathAnimOnLoad  OverrideDeathAnimEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MECDeathExplosion');
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_deathexplosion";

	Template.bDontDisplayInAbilitySummary = true;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Offensive;

	EffectConditions = new class'X2Condition_UnitEffects';
	EffectConditions.AddRequireEffect(class'X2Ability_SparkAbilitySet'.default.SparkSelfDestructEffectName, 'AA_MissingRequiredEffect');
	Template.AbilityShooterConditions.AddItem(EffectConditions);

	// This ability is only valid if there has not been another death explosion on the unit
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = false;
	UnitPropertyCondition.ExcludeDeadFromSpecialDeath = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'UnitDied';
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self_VisualizeInGameState;
	Template.AbilityTriggers.AddItem(EventListener);

	// Targets the unit so the blast center is its dead body
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityToHitCalc = default.DeadEye;

	// Target everything in this blast radius
	MultiTarget = new class'X2AbilityMultiTarget_Radius';
	MultiTarget.fTargetRadius = class'X2Ability_SparkAbilitySet'.default.SPARK_DEATH_EXPLOSION_RADIUS_METERS;
	Template.AbilityMultiTargetStyle = MultiTarget;

	Template.AddTargetEffect(new class'X2Effect_SetSpecialDeath');

	OverrideDeathAnimEffect = new class'X2Effect_OverrideDeathAnimOnLoad';
	OverrideDeathAnimEffect.EffectName = 'SparkDeathAnimOnLoad';
	OverrideDeathAnimEffect.OverrideAnimNameOnLoad = 'FF_Self_Destruct_Boom';
	OverrideDeathAnimEffect.BuildPersistentEffect(1, true, false, true);
	OverrideDeathAnimEffect.EffectRank = 10;
	Template.AddTargetEffect(OverrideDeathAnimEffect);

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeHostileToSource = false;
	UnitPropertyCondition.FailOnNonUnits = false; //The grenade can affect interactive objects, others
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	// Everything in the blast radius receives physical damage
	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.EffectDamageValue = default.MEC_DEATH_EXPLOSION_BASEDAMAGE;
	DamageEffect.EnvironmentalDamageAmount = class'X2Ability_SparkAbilitySet'.default.SPARK_PSI_EXPLOSION_ENV_DMG;
	Template.AddMultiTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_Death'.static.DeathExplosion_BuildVisualization;
	Template.MergeVisualizationFn = class'X2Ability_Death'.static.DeathExplostion_MergeVisualization;
	//Template.MergeVisualizationFn = class'X2Ability_Gatekeeper'.DeathExplosion_VisualizationTrackInsert;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.GrenadeLostSpawnIncreasePerUse;
	Template.bFrameEvenWhenUnitIsHidden = true;
	
	return Template;
}

static function X2AbilityTemplate MECLightningFieldAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTrigger_PlayerInput      InputTrigger;
	local X2AbilityMultiTarget_Radius		RadiusMultiTarget;
	local X2Condition_UnitProperty UnitProperty;
	local X2Effect_ApplyWeaponDamage DamageEffect;
	local X2AbilityCooldown_LocalAndGlobal Cooldown;
	
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'MECLightningField');
	//IconImage needs to be changed once there is an icon for this
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_lightningfield";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Offensive;
	
	UnitProperty = new class'X2Condition_UnitProperty';
	UnitProperty.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(UnitProperty);
	Template.AbilityToHitCalc = default.DeadEye;

	// Targets enemies
	UnitProperty = new class'X2Condition_UnitProperty';
	UnitProperty.ExcludeFriendlyToSource = true;
	UnitProperty.ExcludeDead = true;
	UnitProperty.IsOutdoors = true;
	Template.AbilityMultiTargetConditions.AddItem(UnitProperty);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	//Triggered by player or AI
	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);

	//fire from self, with a radius amount
	Template.AbilityTargetStyle = default.SelfTarget;
	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.LIGHTNINGFIELD_TILE_RADIUS * class'XComWorldData'.const.WORLD_StepSize * class'XComWorldData'.const.WORLD_UNITS_TO_METERS_MULTIPLIER;
	RadiusMultiTarget.bIgnoreBlockingCover = false;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	//Weapon damage to all affected
	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.EffectDamageValue = default.MEC_LIGHTINGFIELD_BASEDAMAGE;
	Template.AddMultiTargetEffect(DamageEffect);

	//Cooldowns
	Cooldown = new class'X2AbilityCooldown_LocalAndGlobal';
	Cooldown.iNumTurns = default.LIGHTNINGFIELD_LOCAL_COOLDOWN;
	Cooldown.NumGlobalTurns = default.LIGHTNINGFIELD_GLOBAL_COOLDOWN;
	Template.AbilityCooldown = Cooldown;
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bShowActivation = true;
	Template.bSkipFireAction = false;
	Template.bSkipExitCoverWhenFiring = true;
	Template.CustomFireAnim = 'NO_LightningFieldA';
	Template.CinescriptCameraType = "Sectopod_LightningField";
	
	return Template;
}

static function X2DataTemplate CreateMECShieldAbility()
{
	local X2AbilityTemplate Template;
	local X2AbilityCost_ActionPoints ActionPointCost;
	//local X2AbilityCharges Charges;
	//local X2AbilityCost_Charges ChargeCost;
	local X2AbilityCooldown_LocalAndGlobal Cooldown;
	local X2Condition_UnitProperty UnitPropertyCondition;
	local X2AbilityTrigger_PlayerInput InputTrigger;
	local X2Effect_PersistentStatChange ShieldedEffect;
	local X2AbilityMultiTarget_Radius MultiTarget;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MECShield');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_adventshieldbearer_energyshield";

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.Hostility = eHostility_Defensive;

	// This ability is a free action
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown_LocalAndGlobal';
	Cooldown.iNumTurns = default.MEC_SHIELD_COOLDOWN;
	Cooldown.NumGlobalTurns = default.MEC_SHIELD_GLOBAL_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	//Can't use while dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	// Add dead eye to guarantee
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	// Multi target
	MultiTarget = new class'X2AbilityMultiTarget_Radius';
	MultiTarget.fTargetRadius = default.MEC_SHIELD_RANGE_METERS;
	MultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = MultiTarget;

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);

	// The Targets must be within the AOE, LOS, and friendly
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeHostileToSource = true;
	UnitPropertyCondition.ExcludeCivilian = true;
	UnitPropertyCondition.FailOnNonUnits = true;
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	// Friendlies in the radius receives a shield receives a shield
	ShieldedEffect = CreateShieldedEffect(Template.LocFriendlyName, Template.GetMyLongDescription(), default.MEC_SHIELD_HP);

	Template.AddShooterEffect(ShieldedEffect);
	Template.AddMultiTargetEffect(ShieldedEffect);

	Template.CustomFireAnim = 'HL_SignalPositiveA';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "AdvShieldBearer_EnergyShieldArmor";
	
	return Template;
}

static function X2Effect_PersistentStatChange CreateShieldedEffect(string FriendlyName, string LongDescription, int ShieldHPAmount)
{
	local X2Effect_EnergyShield ShieldedEffect;

	ShieldedEffect = new class'X2Effect_EnergyShield';
	ShieldedEffect.BuildPersistentEffect(default.MEC_SHIELD_DURATION, false, true, , eGameRule_PlayerTurnEnd);
	ShieldedEffect.SetDisplayInfo(ePerkBuff_Bonus, FriendlyName, LongDescription, "img:///UILibrary_PerkIcons.UIPerk_adventshieldbearer_energyshield", true);
	ShieldedEffect.AddPersistentStatChange(eStat_ShieldHP, ShieldHPAmount);

	return ShieldedEffect;
}

static function X2AbilityTemplate CreateRepairAbility()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCost_ActionPoints            ActionPointCost;
	local X2AbilityCooldown						Cooldown;
	local X2Effect_ApplyRepairHeal				HealEffect;
	local X2Effect_RepairArmor					ArmorEffect;
	local X2Condition_UnitProperty              UnitCondition;
	local X2Effect_RemoveEffectsByDamageType	RemoveEffects;
	local name HealType;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'RepairMEC');
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_MW.UIPerk_repair";

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('RapidRepair');
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.REPAIR_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	HealEffect = new class'X2Effect_ApplyRepairHeal';
	HealEffect.PerUseHP = default.REPAIR_HEAL;
	Template.AddTargetEffect(HealEffect);

	ArmorEffect = new class'X2Effect_RepairArmor';
	Template.AddTargetEffect(ArmorEffect);

	RemoveEffects = new class'X2Effect_RemoveEffectsByDamageType';
	foreach class'X2Ability_DefaultAbilitySet'.default.MedikitHealEffectTypes(HealType)
	{
		RemoveEffects.DamageTypesToRemove.AddItem(HealType);
	}
	Template.AddTargetEffect(RemoveEffects);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	UnitCondition = new class'X2Condition_UnitProperty';
	UnitCondition.ExcludeDead = true;
	UnitCondition.ExcludeHostileToSource = true;
	UnitCondition.ExcludeFriendlyToSource = false;
	UnitCondition.ExcludeFullHealth = true;
	UnitCondition.ExcludeOrganic = true;
	Template.AbilityTargetConditions.AddItem(UnitCondition);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SingleTargetWithSelf;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.bStationaryWeapon = true;
	Template.PostActivationEvents.AddItem('ItemRecalled');
	Template.CustomSelfFireAnim = 'NO_Repair';
	Template.bSkipPerkActivationActions = true;

	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.AttachGremlinToTarget_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_SpecialistAbilitySet'.static.GremlinSingleTarget_BuildVisualization;
	
	Template.CinescriptCameraType = "Spark_SendBit";

	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
	
	return Template;
}