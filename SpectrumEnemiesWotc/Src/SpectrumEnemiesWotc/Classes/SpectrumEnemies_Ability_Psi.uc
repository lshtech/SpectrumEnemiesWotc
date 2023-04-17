class SpectrumEnemies_Ability_Psi extends SpectrumEnemies_Ability config(SpectrumEnemies);

var config int PSI_DISABLE_SHOT_LOCAL_COOLDOWN;
var config int PSI_DISABLE_SHOT_GLOBAL_COOLDOWN;
var config int PSI_PANIC_SHOT_LOCAL_COOLDOWN;
var config int PSI_PANIC_SHOT_GLOBAL_COOLDOWN;
var config int MASS_REANIMATION_MIN_ACTION_COST;
var config int MASS_REANIMATION_RADIUS_METERS;
var config int MASS_REANIMATION_RANGE_METERS;
var config int MASS_REANIMATION_CHARGES;
var config int SOULMENDM1_HPHEAL;
var config int SOULMENDM2_HPHEAL;
var config float PSI_DEATH_EXPLOSION_RADIUS_METERS;

var name ZombieLinkName;
var privatewrite name HolyWarriorEffectName;
var private name DeathExplosionUnitValName;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate>     Templates;

    Templates.AddItem(CreateUndyingAbility());
    Templates.AddItem(PsiDisableShot());
	Templates.AddItem(PsiPanicShot());
	Templates.AddItem(AuraOfTheDead());
	Templates.AddItem(SoulmendM1());
	Templates.AddItem(SoulmendM2());
	Templates.AddItem(RandomDebuff());
	Templates.AddItem(CreatePsiExplode());

	return Templates;
}

static function X2AbilityTemplate CreateUndyingAbility()
{
	local X2AbilityTemplate						Template;
	local X2AbilityTarget_Self					TargetStyle;
	local X2AbilityTrigger_EventListener		EventListener;
	local SpectrumEnemies_Effect_SpawnPsiZombie SwitchToZombieEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Undying');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_sectoid_psireanimate";
	
	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventListener.ListenerData.EventID = 'UnitDied';
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.Priority = 45;  //This ability must get triggered after the rest of the on-death listeners (namely, after mind-control effects get removed)
	Template.AbilityTriggers.AddItem(EventListener);

	// The target will now be turned into a robot
	SwitchToZombieEffect = new class'SpectrumEnemies_Effect_SpawnPsiZombie';
	SwitchToZombieEffect.BuildPersistentEffect(1);
	SwitchToZombieEffect.ZombieFlyoverText = class'X2Ability_DarkEvents'.default.UndyingLoyaltyFlyoverText;
	Template.AddTargetEffect(SwitchToZombieEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = SwitchPsiZombie_BuildVisualization;
	Template.MergeVisualizationFn = SwitchPsiZombie_VisualizationMerge;

	return Template;
}

simulated function SwitchPsiZombie_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateContext_Ability Context;
	local XComGameStateHistory History;
	local VisualizationActionMetadata EmptyTrack, SpawnedUnitTrack, DeadUnitTrack;
	local XComGameState_Unit SpawnedUnit, DeadUnit;
	local UnitValue SpawnedUnitValue;
	local SpectrumEnemies_Effect_SpawnPsiZombie SwitchToZombieEffect;
	local XComGameState_Ability AbilityState;
	local X2AbilityTemplate AbilityTemplate;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	History = `XCOMHISTORY;

	DeadUnit = XComGameState_Unit(VisualizeGameState.GetGameStateForObjectID(Context.InputContext.PrimaryTarget.ObjectID));
	`assert(DeadUnit != none);

	DeadUnit.GetUnitValue(class'X2Effect_SpawnUnit'.default.SpawnedUnitValueName, SpawnedUnitValue);

	// The Spawned unit should appear and play its change animation
	DeadUnitTrack = EmptyTrack;
	DeadUnitTrack.StateObject_OldState = DeadUnit;
	DeadUnitTrack.StateObject_NewState = DeadUnitTrack.StateObject_OldState;
	DeadUnitTrack.VisualizeActor = History.GetVisualizer(DeadUnit.ObjectID);

	// The Spawned unit should appear and play its change animation
	SpawnedUnitTrack = EmptyTrack;
	SpawnedUnitTrack.StateObject_OldState = History.GetGameStateForObjectID(SpawnedUnitValue.fValue, eReturnType_Reference, VisualizeGameState.HistoryIndex);
	SpawnedUnitTrack.StateObject_NewState = SpawnedUnitTrack.StateObject_OldState;
	SpawnedUnit = XComGameState_Unit(SpawnedUnitTrack.StateObject_NewState);
	`assert(SpawnedUnit != none);
	SpawnedUnitTrack.VisualizeActor = History.GetVisualizer(SpawnedUnit.ObjectID);

	// Only first target effect is X2Effect_SwitchToRobot
	SwitchToZombieEffect = SpectrumEnemies_Effect_SpawnPsiZombie(Context.ResultContext.TargetEffectResults.Effects[0]);

	if( SwitchToZombieEffect == none )
	{
		// This can happen due to replays. In replays, when moving Context visualizations forward the Context has not
		// been fully filled in.
		AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(Context.InputContext.AbilityRef.ObjectID));
		AbilityTemplate = AbilityState.GetMyTemplate();
		SwitchToZombieEffect = SpectrumEnemies_Effect_SpawnPsiZombie(AbilityTemplate.AbilityTargetEffects[0]);
	}

	if( SwitchToZombieEffect == none )
	{
		`RedScreenOnce("SwitchPsiZombie_BuildVisualization: Missing X2Effect_XZSpawnPsiZombie @gameplay");
	}
	else
	{
		SwitchToZombieEffect.AddSpawnVisualizationsToTracks(Context, SpawnedUnit, SpawnedUnitTrack, DeadUnit, DeadUnitTrack);
	}
}

static function SwitchPsiZombie_VisualizationMerge(X2Action BuildTree, out X2Action VisualizationTree)
{
	local X2Action_Death DeathAction;		
	local X2Action BuildTreeStartNode, BuildTreeEndNode;	
	local XComGameStateVisualizationMgr LocalVisualizationMgr;

	LocalVisualizationMgr = `XCOMVISUALIZATIONMGR;

	DeathAction = X2Action_Death(LocalVisualizationMgr.GetNodeOfType(VisualizationTree, class'X2Action_Death'));
	BuildTreeStartNode = LocalVisualizationMgr.GetNodeOfType(BuildTree, class'X2Action_MarkerTreeInsertBegin');	
	BuildTreeEndNode = LocalVisualizationMgr.GetNodeOfType(BuildTree, class'X2Action_MarkerTreeInsertEnd');	
	LocalVisualizationMgr.InsertSubtree(BuildTreeStartNode, BuildTreeEndNode, DeathAction);
}

static function X2AbilityTemplate PsiDisableShot()
{
	local X2AbilityTemplate 				Template;
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints 		ActionPointCost;
	local X2AbilityCooldown_LocalAndGlobal 	Cooldown;
	
	local X2Condition_UnitProperty 			UnitPropertyCondition;
	local X2Condition_Visibility 			TargetVisibilityCondition;
	local X2AbilityTarget_Single 			SingleTarget;
	local X2AbilityToHitCalc_StandardAim 	StandardAim;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Spectrum_PsiDisableShot');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_psibomb";

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	AmmoCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(AmmoCost);

	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.bShowActivation = true;
	Template.Hostility = eHostility_Offensive;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown_LocalAndGlobal';
	Cooldown.iNumTurns = default.PSI_DISABLE_SHOT_LOCAL_COOLDOWN;
	Cooldown.NumGlobalTurns = default.PSI_DISABLE_SHOT_GLOBAL_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bAllowCrit = false;
	Template.AbilityToHitCalc = StandardAim;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AddShooterEffectExclusions();

	// Target must be an enemy
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.RequireWithinRange = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);
	
	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

	SingleTarget = new class'X2AbilityTarget_Single';
	Template.AbilityTargetStyle = SingleTarget;

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	Template.bAllowBonusWeaponEffects = true;	

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "Psionic_FireAtUnit";
	Template.CustomFireAnim = 'HL_Psi_ProjectileMedium';

	Template.AddTargetEffect(new class'X2Effect_DisableWeapon');

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	
	return Template;
}

static function X2AbilityTemplate PsiPanicShot()
{
	local X2AbilityTemplate 				Template;
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints 		ActionPointCost;
	local X2AbilityCooldown_LocalAndGlobal 	Cooldown;
	
	local X2Condition_UnitProperty 			UnitPropertyCondition;
	local X2Condition_Visibility 			TargetVisibilityCondition;
	local X2AbilityTarget_Single 			SingleTarget;
	local X2AbilityToHitCalc_StandardAim 	StandardAim;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Spectrum_PsiPanicShot');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_psibomb";

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	AmmoCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(AmmoCost);

	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.bShowActivation = true;
	Template.Hostility = eHostility_Offensive;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown_LocalAndGlobal';
	Cooldown.iNumTurns = default.PSI_PANIC_SHOT_LOCAL_COOLDOWN;
	Cooldown.NumGlobalTurns = default.PSI_PANIC_SHOT_GLOBAL_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bAllowCrit = false;
	Template.AbilityToHitCalc = StandardAim;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AddShooterEffectExclusions();

	// Target must be an enemy
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = true;
	UnitPropertyCondition.RequireWithinRange = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);
	
	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

	SingleTarget = new class'X2AbilityTarget_Single';
	Template.AbilityTargetStyle = SingleTarget;

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	Template.bAllowBonusWeaponEffects = true;	

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "Psionic_FireAtUnit";
	Template.CustomFireAnim = 'HL_Psi_ProjectileMedium';

	Template.AddTargetEffect(class'X2StatusEffects'.static.CreatePanickedStatusEffect());

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	
	return Template;
}

static function X2AbilityTemplate SoulmendM1()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Condition_UnitProperty          TargetProperty;
	local X2Condition_UnitStatCheck         UnitStatCheckCondition;
	local X2Condition_UnitEffects           UnitEffectsCondition;
	local X2Effect_ApplyMedikitHeal			HealingEffect;
	local X2AbilityCooldown                 Cooldown;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SoulmendM1');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 2;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	TargetProperty = new class'X2Condition_UnitProperty';
	TargetProperty.ExcludeDead = true;
	TargetProperty.ExcludeRobotic = true;
	TargetProperty.ExcludeHostileToSource = true;
	TargetProperty.ExcludeFriendlyToSource = false;
	TargetProperty.ExcludeFullHealth = true;
	TargetProperty.RequireSquadmates = true;
	Template.AbilityTargetConditions.AddItem(TargetProperty);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	UnitStatCheckCondition = new class'X2Condition_UnitStatCheck';
	UnitStatCheckCondition.AddCheckStat(eStat_HP, 0, eCheck_GreaterThan);
	Template.AbilityTargetConditions.AddItem(UnitStatCheckCondition);

	UnitEffectsCondition = new class'X2Condition_UnitEffects';
	UnitEffectsCondition.AddExcludeEffect(class'X2StatusEffects'.default.BleedingOutName, 'AA_UnitIsImpaired');
	Template.AbilityTargetConditions.AddItem(UnitEffectsCondition);

	HealingEffect = CreateSoulMendHeal(default.SOULMENDM1_HPHEAL);
	Template.AddTargetEffect(HealingEffect);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.Hostility = eHostility_Defensive;

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_soulfire";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.bShowActivation = true;
	Template.CustomFireAnim = 'HL_Priest_Medium';

	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "Psionic_FireAtUnit";

	return Template;
}

static function X2AbilityTemplate SoulmendM2()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Condition_UnitProperty          TargetProperty;
	local X2Condition_UnitStatCheck         UnitStatCheckCondition;
	local X2Condition_UnitEffects           UnitEffectsCondition;
	local X2Effect_ApplyMedikitHeal			HealingEffect;
	local X2AbilityCooldown                 Cooldown;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SoulmendM2');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 2;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	TargetProperty = new class'X2Condition_UnitProperty';
	TargetProperty.ExcludeDead = true;
	TargetProperty.ExcludeRobotic = true;
	TargetProperty.ExcludeHostileToSource = true;
	TargetProperty.ExcludeFriendlyToSource = false;
	TargetProperty.ExcludeFullHealth = true;
	TargetProperty.RequireSquadmates = true;
	Template.AbilityTargetConditions.AddItem(TargetProperty);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	UnitStatCheckCondition = new class'X2Condition_UnitStatCheck';
	UnitStatCheckCondition.AddCheckStat(eStat_HP, 0, eCheck_GreaterThan);
	Template.AbilityTargetConditions.AddItem(UnitStatCheckCondition);

	UnitEffectsCondition = new class'X2Condition_UnitEffects';
	UnitEffectsCondition.AddExcludeEffect(class'X2StatusEffects'.default.BleedingOutName, 'AA_UnitIsImpaired');
	Template.AbilityTargetConditions.AddItem(UnitEffectsCondition);


	HealingEffect = CreateSoulMendHeal(default.SOULMENDM2_HPHEAL);
	Template.AddTargetEffect(HealingEffect);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.Hostility = eHostility_Defensive;

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_soulfire";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.bShowActivation = true;
	Template.CustomFireAnim = 'HL_Priest_Medium';
	
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "Psionic_FireAtUnit";

	return Template;
}

static function X2Effect_ApplyMedikitHeal CreateSoulMendHeal(int HealAmount)
{
	local X2Effect_ApplyMedikitHeal HealingEffect;

	HealingEffect = new class'X2Effect_ApplyMedikitHeal';
	HealingEffect.PerUseHP = HealAmount;

	return HealingEffect;
}

static function X2AbilityTemplate RandomDebuff()
{
	local X2AbilityTemplate										Template;
	local X2Condition_UnitProperty								TargetProperty;
	local X2Condition_Visibility								VisCondition;
	local X2AbilityTarget_Single								PrimaryTarget;
	local X2AbilityCost_ActionPoints							ActionPointCost;
	local SpectrumEnemies_Effect_RandomDebuff					Effect;
	local X2AbilityCooldown                 					Cooldown;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'RandomDebuff');
	Template.IconImage = "img:///UILibrary_WOTC_APA_Class_Pack.perk_AidProtocol"; 
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY + 1;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Offensive;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	TargetProperty = new class'X2Condition_UnitProperty';
	TargetProperty.ExcludeDead = true;
	TargetProperty.ExcludeRobotic = true;
	TargetProperty.ExcludeHostileToSource = false;
	TargetProperty.ExcludeFriendlyToSource = true;
	Template.AbilityTargetConditions.AddItem(TargetProperty);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 2;
	Template.AbilityCooldown = Cooldown;

	// Visibility/Range restrictions and Targeting
	VisCondition = new class'X2Condition_Visibility';
	VisCondition.bRequireGameplayVisible = true;
	VisCondition.bActAsSquadsight = true;
	Template.AbilityTargetConditions.AddItem(VisCondition);

	PrimaryTarget = new class'X2AbilityTarget_Single';
	PrimaryTarget.OnlyIncludeTargetsInsideWeaponRange = false;
	PrimaryTarget.bAllowInteractiveObjects = false;
	PrimaryTarget.bAllowDestructibleObjects = false;
	Template.AbilityTargetSTyle = PrimaryTarget;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);	

	Effect = new class'SpectrumEnemies_Effect_RandomDebuff';
	Effect.BuildPersistentEffect(3, false, false, false, eGameRule_PlayerTurnBegin);
	Effect.AddPersistentStatChange(eStat_HP, 10);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocHelpText, Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;
}

static function X2AbilityTemplate CreatePsiExplode()
{	
	local X2AbilityTemplate					Template;
	local X2AbilityTrigger_EventListener	EventListener;
	local X2AbilityMultiTarget_Radius		MultiTarget;
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2Effect_ApplyWeaponDamage		DamageEffect;
	local X2Condition_UnitValue				UnitValue;
	local X2Effect_SetUnitValue				SetUnitValEffect;
	local X2Effect_KillUnit					KillUnitEffect;
	local X2AbilityToHitCalc_StandardAim	StandardAim;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SpectrumEnemiesPsiExplode');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_deathexplosion";
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Offensive;
	Template.bDontDisplayInAbilitySummary = true;

	//Conditions
	UnitValue = new class'X2Condition_UnitValue';
	UnitValue.AddCheckValue(default.DeathExplosionUnitValName, 1, eCheck_LessThan);
	Template.AbilityShooterConditions.AddItem(UnitValue);

	//Exclusions
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeAlive = false;
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeHostileToSource = false;
	UnitPropertyCondition.FailOnNonUnits = false;
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	//Targeting
	Template.AbilityTargetStyle = default.SelfTarget;

	//ToHit Calc
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bMultiTargetOnly = true;
	StandardAim.bIndirectFire = true;
	StandardAim.bAllowCrit = false;
	Template.AbilityToHitCalc = StandardAim;

	MultiTarget = new class'X2AbilityMultiTarget_Radius';
	MultiTarget.fTargetRadius = default.PSI_DEATH_EXPLOSION_RADIUS_METERS;
	MultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = MultiTarget;

	//Triggers
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'UnitDied';
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self_VisualizeInGameState;
	Template.AbilityTriggers.AddItem(EventListener);

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'UnitUnconscious';
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self_VisualizeInGameState;
	Template.AbilityTriggers.AddItem(EventListener);

	//Once this ability is fired, set the DeathPsiExplosion Unit Value so it will not happen again
	SetUnitValEffect = new class'X2Effect_SetUnitValue';
	SetUnitValEffect.UnitName = default.DeathExplosionUnitValName;
	SetUnitValEffect.NewValueToSet = 1;
	SetUnitValEffect.CleanupType = eCleanup_BeginTactical;
	Template.AddTargetEffect(SetUnitValEffect);
	
	//Damage Effect
	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.EffectDamageValue = class'X2Item_XPackWeapons'.default.PSI_DEATH_EXPLOSION_BASEDAMAGE;
	DamageEffect.EnvironmentalDamageAmount = class'X2Ability_ChosenWarlock'.default.PSI_EXPLOSION_ENV_DMG;
	Template.AddMultiTargetEffect(DamageEffect);

	//Kill Effect
	KillUnitEffect = new class'X2Effect_KillUnit';
	KillUnitEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnEnd);
	KillUnitEffect.EffectName = 'KillUnit';
	KillUnitEffect.DeathActionClass = class'SpectrumEnemies_Action_ExplodingPsiDeathAction';  //Overrides standard death animation with death explosion animation
	Template.AddTargetEffect(KillUnitEffect);
	Template.AddTargetEffect(new class'X2Effect_SetSpecialDeath');

	//Add the Lost Spawn Trigger from the explosion sound.
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.GrenadeLostSpawnIncreasePerUse;
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_Death'.static.DeathExplosion_BuildVisualization;
	Template.MergeVisualizationFn = class'X2Ability_Death'.static.DeathExplostion_MergeVisualization;
	Template.bFrameEvenWhenUnitIsHidden = true;
	
	return Template;
}

static function X2AbilityTemplate AuraOfTheDead( )
{
	local X2AbilityTemplate						Template;
	local X2AbilityTrigger_EventListener		EventListener;
	local X2Condition_UnitProperty UnitPropertyCondition;
	local X2Condition_Visibility TargetVisibilityCondition;
	local X2Effect_SpawnPsiZombie SwitchToZombieEffect;
	local X2Condition_UnitValue UnitValue;
	local X2Condition_UnitEffects ExcludeEffects;
	local X2Condition_UnitType	UnitTypeCondition;
	`CREATE_X2ABILITY_TEMPLATE(Template, 'SpectrumDeadAura');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_item_wraith";
	Template.AbilitySourceName = 'eAbilitySource_Psionic';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityTargetStyle = new class'X2AbilityTarget_Single';
	
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);// Prevent ability from being available when dead
	Template.AddShooterEffectExclusions();

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.EventID = 'UnitDied';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	//EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = AuraoftheDeadListener;
	EventListener.ListenerData.Priority = 25;  //This ability must get triggered after the rest of the on-death listeners (namely, after mind-control effects get removed)
	Template.AbilityTriggers.AddItem(EventListener);

	// The unit must be organic, dead, and not an alien
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = false;
	UnitPropertyCondition.ExcludeAlive = true;
	UnitPropertyCondition.ExcludeRobotic = true;
	UnitPropertyCondition.ExcludeOrganic = false;
	UnitPropertyCondition.ExcludeAlien = true;
	UnitPropertyCondition.ExcludeCivilian = false;
	UnitPropertyCondition.ExcludeCosmetic = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeHostileToSource = false;
	UnitPropertyCondition.FailOnNonUnits = true;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	UnitTypeCondition = new class'X2Condition_UnitType';
	UnitTypeCondition.ExcludeTypes.AddItem('TheLost'); // just don't bother
	Template.AbilityTargetConditions.AddItem(UnitTypeCondition);
	// Must be able to see the dead unit to reanimate it
	TargetVisibilityCondition = new class'X2Condition_Visibility';	
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

	// This ability is only valid if the target has not yet been turned into a zombie
	UnitValue = new class'X2Condition_UnitValue';
	UnitValue.AddCheckValue(class'X2Effect_SpawnPsiZombie'.default.TurnedZombieName, 1, eCheck_LessThan);
	Template.AbilityTargetConditions.AddItem(UnitValue);

	ExcludeEffects = new class'X2Condition_UnitEffects';
	ExcludeEffects.AddExcludeEffect(class'X2Ability_CarryUnit'.default.CarryUnitEffectName, 'AA_UnitIsImmune');
	ExcludeEffects.AddExcludeEffect(class'X2AbilityTemplateManager'.default.BeingCarriedEffectName, 'AA_UnitIsImmune');
	Template.AbilityTargetConditions.AddItem(ExcludeEffects);

	// The target will now be turned into a robot
	SwitchToZombieEffect = new class'X2Effect_SpawnPsiZombie';
	SwitchToZombieEffect.BuildPersistentEffect(1);
	//SwitchToZombieEffect.ZombieFlyoverText = default.UndyingLoyaltyFlyoverText;
	Template.AddTargetEffect(SwitchToZombieEffect);

	Template.bShowActivation = true;
	Template.bSkipFireAction = true;
	Template.bSkipPerkActivationActions = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = PuppetReanimation_BuildVisualization;

	return Template;
}

simulated function PuppetReanimation_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability Context;
	local StateObjectReference InteractingUnitRef;
	local X2Action_PlayAnimation AnimationAction;
	local VisualizationActionMetadata EmptyTrack;
	local VisualizationActionMetadata ActionMetadata, ZombieTrack, DeadUnitTrack;
	local XComGameState_Unit SpawnedUnit, DeadUnit, SectoidUnit;
	local UnitValue SpawnedUnitValue;
	local X2Effect_SpawnPsiZombie SpawnPsiZombieEffect;
	//local X2Action_TimedWait ReanimateTimedWaitAction;	

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;

	//Configure the visualization track for the shooter
	//****************************************************************************************
	ActionMetadata = EmptyTrack;
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);


	SectoidUnit = XComGameState_Unit(ActionMetadata.StateObject_NewState);

	if( SectoidUnit != none )
	{
		// Configure the visualization track for the psi zombie
		//******************************************************************************************
		DeadUnitTrack.StateObject_OldState = History.GetGameStateForObjectID(Context.InputContext.PrimaryTarget.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex);
		DeadUnitTrack.StateObject_NewState = DeadUnitTrack.StateObject_OldState;
		DeadUnit = XComGameState_Unit(VisualizeGameState.GetGameStateForObjectID(Context.InputContext.PrimaryTarget.ObjectID));
		`assert(DeadUnit != none);
		DeadUnitTrack.VisualizeActor = History.GetVisualizer(DeadUnit.ObjectID);

		// Get the ObjectID for the ZombieUnit created from the DeadUnit
		DeadUnit.GetUnitValue(class'X2Effect_SpawnUnit'.default.SpawnedUnitValueName, SpawnedUnitValue);

		ZombieTrack = EmptyTrack;
		ZombieTrack.StateObject_OldState = History.GetGameStateForObjectID(SpawnedUnitValue.fValue, eReturnType_Reference, VisualizeGameState.HistoryIndex);
		ZombieTrack.StateObject_NewState = ZombieTrack.StateObject_OldState;
		SpawnedUnit = XComGameState_Unit(ZombieTrack.StateObject_NewState);
		`assert(SpawnedUnit != none);
		ZombieTrack.VisualizeActor = History.GetVisualizer(SpawnedUnit.ObjectID);

		// Only one target effect and it is X2Effect_SpawnPsiZombie
		SpawnPsiZombieEffect = X2Effect_SpawnPsiZombie(Context.ResultContext.TargetEffectResults.Effects[0]);

		if( SpawnPsiZombieEffect == none )
		{
			`RedScreenOnce("PsiReanimation_BuildVisualization: Missing X2Effect_SpawnPsiZombie -dslonneger @gameplay");
			return;
		}

		// Build the tracks
		//class'X2Action_ExitCover'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);
		class'X2Action_AbilityPerkStart'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);

		// Dead unit should wait for the Sectoid to play its Reanimation animation
		// Preferable to have an anim notify from content but can't do that currently, animation gave the time to wait before the zombie rises
		//ReanimateTimedWaitAction = X2Action_TimedWait(class'X2Action_TimedWait'.static.AddToVisualizationTree(DeadUnitTrack, Context));
		//ReanimateTimedWaitAction.DelayTimeSec = class'X2Ability_Sectoid'.default.SECTOID_REANIMATION_ZOMBIE_RISE_DELAY;

		SpawnPsiZombieEffect.AddSpawnVisualizationsToTracks(Context, SpawnedUnit, ZombieTrack, DeadUnit, DeadUnitTrack);

		AnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
		AnimationAction.Params.AnimName = 'HL_SignalPositiveA';

		class'X2Action_AbilityPerkEnd'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);
		//class'X2Action_EnterCover'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);
	}
}

static function EventListenerReturn AuraoftheDeadListener(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameState_Unit ShooterUnit, TargetUnit;
	local XComGameState_Ability		AbilityState;
	ShooterUnit = XComGameState_Unit(EventSource);
	TargetUnit = XComGameState_Unit(EventData);
	AbilityState = XComGameState_Ability(CallbackData);
	if( GameState.GetContext().InterruptionStatus == eInterruptionStatus_Interrupt )
	{
		return ELR_NoInterrupt;
	}

	if (ShooterUnit != none && TargetUnit != none && AbilityState != none)
	{
		AbilityState.AbilityTriggerAgainstSingleTarget(TargetUnit.GetReference(), false);
	}

	return ELR_NoInterrupt;
}



defaultproperties
{
	ZombieLinkName ="ZombieLinkName"
}