class SpectrumEnemies_Ability_Base extends SpectrumEnemies_Ability config(SpectrumEnemies);

var config int 					ReinforcementsAbilityUsesCommander;
var config int 					LowProfileDefenseIncrease;
var config int 					PatienceAimBonus;
var config int 					PatienceDefenseMalus;
var config float				PavementShrapnelRadius;
var config int					PavementShrapnelCooldown;
var config int					PavementShrapnelBaseDamage;
var config int					PavementShrapnelSpread;
var config int					PavementShrapnelCrit;
var config int				    PavementShrapnelShred;
var config int 					SprayAmmoCost;
var config int 					SprayCooldown;
var config int 					SprayWidth;
var config int 					SprayLength;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	// Commander
	Templates.AddItem(ReinforceAbility('Spectrum_AdventCommander_CallReinforcements', default.ReinforcementsAbilityUsesCommander));

	// Scout
	Templates.AddItem(RepositionAbility());
	Templates.AddItem(RepositionPassiveAbility());
	Templates.AddItem(LowProfileAbility());

	// Sniper
	Templates.AddItem(CrackShotAbility());
    Templates.AddItem(PatienceAbility());

	// Shredder
	Templates.AddItem(PavementShrapnelAbility());

	// Heavy
	Templates.AddItem(SprayAbility());

	return Templates;
}

static function X2AbilityTemplate RepositionAbility()
{
	local X2AbilityTemplate             Template, SecondaryTemplate;	
	local X2Condition_Visibility        VisibilityCondition;
	local X2AbilityCost_Ammo 			AmmoCost;
	local X2AbilityCost_ActionPoints 	ActionPointCost;
	local X2Effect_Knockback			KnockbackEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Spectrum_Reposition');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_standard";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_SHOT_PRIORITY;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.Hostility = eHostility_Offensive;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.DisplayTargetHitChance = true;
	Template.AddShooterEffectExclusions();

	VisibilityCondition = new class'X2Condition_Visibility';
	VisibilityCondition.bRequireGameplayVisible = true;
	VisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(VisibilityCondition);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);
	
	Template.bAllowAmmoEffects = true;
	Template.bAllowBonusWeaponEffects = true;

	Template.bAllowFreeFireWeaponUpgrade = true;

	Template.AddTargetEffect(class'X2Ability_Chosen'.static.HoloTargetEffect());
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);

	Template.AbilityToHitCalc = default.SimpleStandardAim;
	Template.AbilityToHitOwnerOnMissCalc = default.SimpleStandardAim;
		
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.bUsesFiringCamera = true;
	Template.CinescriptCameraType = "StandardGunFiring";	

	Template.AssociatedPassives.AddItem('HoloTargeting');

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;	
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 2;
	Template.AddTargetEffect(KnockbackEffect);

	class'X2StrategyElement_XpackDarkEvents'.static.AddStilettoRoundsEffect(Template);

	Template.PostActivationEvents.AddItem('Spectrum_RepositionActivated');
	Template.OverrideAbilities.AddItem('StandardShot');

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
	
	Template.AlternateFriendlyNameFn = class'X2Ability_WeaponCommon'.static.StandardShot_AlternateFriendlyName;;
	Template.bFrameEvenWhenUnitIsHidden = true;

	SecondaryTemplate = RepositionTrigger();
	SecondaryTemplate.bShowActivation = true;
	
	Template.AdditionalAbilities.AddItem(SecondaryTemplate.DataName);

	SpectrumEnemies_Ability(class'XComEngine'.static.GetClassDefaultObject(default.class)).ExtraTemplates.AddItem(SecondaryTemplate);

	return Template;
}

static function X2AbilityTemplate RepositionTrigger()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTrigger_EventListener	EventListener;
	local X2Effect_GrantActionPoints		GrantActionPoints;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Spectrum_RepositionTrigger');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_dash";
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	Template.AdditionalAbilities.AddItem('Spectrum_RepositionPassive');

	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	EventListener.ListenerData.EventID = 'Spectrum_RepositionActivated';
	EventListener.ListenerData.Filter = eFilter_Unit;
	Template.AbilityTriggers.AddItem(EventListener);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	GrantActionPoints = new class'X2Effect_GrantActionPoints';
	GrantActionPoints.bApplyOnMiss = true;
	GrantActionPoints.NumActionPoints = 1;
	GrantActionPoints.PointType = class'X2CharacterTemplateManager'.default.MoveActionPoint;
	
	Template.AddTargetEffect(GrantActionPoints);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bSkipFireAction = true;

	return Template;
}

static function X2AbilityTemplate RepositionPassiveAbility()
{
	local X2AbilityTemplate						Template;

	Template = PurePassive('Spectrum_RepositionPassive', "img:///UILibrary_PerkIcons.UIPerk_dash", , 'eAbilitySource_Standard');

	return Template;
}

static function X2AbilityTemplate LowProfileAbility()
{
	local X2AbilityTemplate		Template;
	local SpectrumEnemies_Effect_LowProfile		LowProfileEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Spectrum_LowProfile');
	Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.str_lowprofile";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bIsPassive = true;
	Template.bCrossClassEligible = false;

	// Create an effect that adds Low Profile defense modifier
	LowProfileEffect = new class'SpectrumEnemies_Effect_LowProfile';
	LowProfileEffect.BuildPersistentEffect (1, true, false);
	LowProfileEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(LowProfileEffect);
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;
}

static function X2AbilityTemplate CrackShotAbility()
{
	local X2AbilityTemplate						Template;
	local SpectrumEnemies_Effect_CrackShot      CrackShotEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Spectrum_CrackShot');

	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_implacable";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	CrackShotEffect = new class'SpectrumEnemies_Effect_CrackShot';
	CrackShotEffect.BuildPersistentEffect(1, true, false, false);
	CrackShotEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	CrackShotEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(CrackShotEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	Template.bCrossClassEligible = true;

	return Template;
}

static function X2AbilityTemplate PatienceAbility()
{
	local X2AbilityTemplate				    Template;
	local X2Effect_Persistent			    PersistentEffect;
	local SpectrumEnemies_Effect_Patience	StatChangeEffect;
	local X2Condition_UnitValue			    ValueCondition;
	local X2Condition_PlayerTurns		    TurnsCondition;


	Template = CreatePassiveAbility('Spectrum_Patience', "img:///UILibrary_PerkIcons.UIPerk_implacable",, false);


	PersistentEffect = new class'X2Effect_Persistent';
	PersistentEffect.EffectName = 'PatienceEffect';
	PersistentEffect.BuildPersistentEffect(1, true, false, false, eGameRule_PlayerTurnBegin);
	PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage,,, Template.AbilitySourceName);

    StatChangeEffect = new class'SpectrumEnemies_Effect_Patience';
    StatChangeEffect.EffectName = 'Patience';
    StatChangeEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
    StatChangeEffect.AddPersistentStatChange(eStat_Offense, default.PatienceAimBonus);
    StatChangeEffect.AddPersistentStatChange(eStat_Defense, default.PatienceDefenseMalus);
    StatChangeEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.LocHelpText, Template.IconImage, true);

	ValueCondition = new class'X2Condition_UnitValue';
	ValueCondition.AddCheckValue('MovesThisTurn', 1, eCheck_LessThan);
	StatChangeEffect.TargetConditions.AddItem(ValueCondition);

	TurnsCondition = new class'X2Condition_PlayerTurns';
	TurnsCondition.NumTurnsCheck.CheckType = eCheck_GreaterThan;
	TurnsCondition.NumTurnsCheck.Value = 1;
	StatChangeEffect.TargetConditions.AddItem(TurnsCondition);

	PersistentEffect.ApplyOnTick.AddItem(StatChangeEffect);
	Template.AddShooterEffect(PersistentEffect);

	return Template;
}

static function X2AbilityTemplate PavementShrapnelAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityTrigger_PlayerInput 		InputTrigger;
	local X2AbilityMultiTarget_Radius		RadiusMultiTarget;
	local X2Effect_ApplyWeaponDamage        DamageEffect;
	local X2AbilityCooldown					Cooldown;
	local X2AbilityCost_ActionPoints 		ActionPointCost;
	local X2Condition_UnitProperty			UnitPropertyCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Spectrum_PavementShrapnel');

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Offensive;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_andromedon_wallsmash";
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);

	Template.AbilityToHitCalc = default.DeadEye;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.PavementShrapnelRadius;
	RadiusMultiTarget.bIgnoreBlockingCover = false;
	RadiusMultiTarget.bAllowDeadMultiTargetUnits = false;
	RadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	Template.bFriendlyFireWarning = true;

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeHostileToSource = false;
	UnitPropertyCondition.FailOnNonUnits = true;
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.PavementShrapnelCooldown;
	Template.AbilityCooldown = Cooldown;

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bExplosiveDamage = true;
	DamageEffect.DamageTag = 'PavementShrapnel';
	DamageEffect.EffectDamageValue.Damage = default.PavementShrapnelBaseDamage;
	DamageEffect.EffectDamageValue.Spread = default.PavementShrapnelSpread;
	DamageEffect.EffectDamageValue.PlusOne = 50;
	DamageEffect.EffectDamageValue.Crit = default.PavementShrapnelCrit;
	DamageEffect.EffectDamageValue.Pierce = 0;
	DamageEffect.EffectDamageValue.Shred = default.PavementShrapnelShred;
	Template.AddMultiTargetEffect(DamageEffect);

 	Template.CustomFireAnim = 'HL_EnergyShieldA';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;		
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;  
	Template.CinescriptCameraType = "AdvShieldBearer_EnergyShieldArmor";
	Template.bSkipPerkActivationActions = true;
	Template.bShowActivation = true;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

 	return Template;
}

static function X2AbilityTemplate SprayAbility()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Cone         ConeMultiTarget;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2AbilityCooldown                 Cooldown;
	local X2Effect_Shredder					WeaponDamageEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Spectrum_Spray');

	// Boilerplate setup
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CAPTAIN_PRIORITY;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_shreddergun";
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.CinescriptCameraType = "StandardGunFiring";
	Template.bCrossClassEligible = false;
	Template.Hostility = eHostility_Offensive;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.TargetingMethod = class'X2TargetingMethod_Cone';

	// Boilerplate setup
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetConditions.AddItem(default.LivingTargetUnitOnlyProperty);
	
	// Ammo effects apply
	Template.bAllowAmmoEffects = true;

	// Requires one action point and ends turn
	ActionPointCost = new class 'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	// Configurable ammo cost
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = default.SprayAmmoCost;
	Template.AbilityCosts.AddItem(AmmoCost);

	// Configurable cooldown
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.SprayCooldown;
	Template.AbilityCooldown = Cooldown;

	// Can hurt allies
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	// Cannot be used while disoriented, burning, etc.
	Template.AddShooterEffectExclusions();

	// Standard aim calculation
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bMultiTargetOnly = false; 
	StandardAim.bGuaranteedHit = false;
	StandardAim.bOnlyMultiHitWithSuccess = false;
	StandardAim.bAllowCrit = true;
	Template.AbilityToHitCalc = StandardAim;
	Template.bOverrideAim = false;

	// Manual targetting
	CursorTarget = new class'X2AbilityTarget_Cursor';
	Template.AbilityTargetStyle = CursorTarget;	

	// Can shred
	WeaponDamageEffect = new class'X2Effect_Shredder';
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(WeaponDamageEffect);
	Template.bFragileDamageOnly = true;
	Template.bCheckCollision = true;
	
	// Add miss target damage
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	Template.AddMultiTargetEffect(default.WeaponUpgradeMissDamage);

	// Cone style target, does not go through full cover
	ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
	ConeMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	ConeMultiTarget.ConeEndDiameter = default.SprayWidth * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.bUseWeaponRangeForLength = false;
	ConeMultiTarget.ConeLength = default.SprayLength * class'XComWorldData'.const.WORLD_StepSize;
	ConeMultiTarget.fTargetRadius = 99;     //  large number to handle weapon range - targets will get filtered according to cone constraints
	ConeMultiTarget.bIgnoreBlockingCover = false;
	Template.AbilityMultiTargetStyle = ConeMultiTarget;

	// Standard visualization
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	// Standard interactions with Shadow, Chosen, and the Lost
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	Template.ActionFireClass = class'X2Action_Fire_Flamethrower';

	// If this ability is set up as a cross class ability, but it's not directly assigned to any classes, this is the weapon slot it will use
	Template.DefaultSourceItemSlot = eInvSlot_PrimaryWeapon;

	return Template;
}

// Set this as the VisualizationFn on an X2Effect_Persistent to have it display a flyover over the target when applied.
simulated static function EffectFlyOver_Visualization(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const name EffectApplyResult)
{
	local X2Action_PlaySoundAndFlyOver	SoundAndFlyOver;
	local X2AbilityTemplate             AbilityTemplate;
	local XComGameStateContext_Ability  Context;
	local AbilityInputContext           AbilityContext;
	local EWidgetColor					MessageColor;
	local XComGameState_Unit			SourceUnit;
	local bool							bGoodAbility;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	AbilityContext = Context.InputContext;
	AbilityTemplate = class'XComGameState_Ability'.static.GetMyTemplateManager().FindAbilityTemplate(AbilityContext.AbilityTemplateName);
	
	SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.SourceObject.ObjectID));

	bGoodAbility = SourceUnit.IsFriendlyToLocalPlayer();
	MessageColor = bGoodAbility ? eColor_Good : eColor_Bad;

	if (EffectApplyResult == 'AA_Success' && XGUnit(ActionMetadata.VisualizeActor).IsAlive())
	{
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded));
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, AbilityTemplate.LocFlyOverText, '', MessageColor, AbilityTemplate.IconImage);
	}
}