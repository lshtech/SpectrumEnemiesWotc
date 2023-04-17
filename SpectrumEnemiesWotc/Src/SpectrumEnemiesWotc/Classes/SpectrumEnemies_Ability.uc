class SpectrumEnemies_Ability extends X2Ability config (SpectrumEnemies);

var config int 					ReinforcementsLocalCooldown;
var config int 					ReinforcementsGlobalCooldown;
var config int 					ReinforcementsAbilityUsesCaptain;
var config int 					DeepPocketsBonus;

var array<X2AbilityTemplate>    ExtraTemplates;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(ReinforceAbility('Spectrum_AdventCaptain_CallReinforcements', default.ReinforcementsAbilityUsesCaptain));
	Templates.AddItem(DeepPocketsAbility());
	
	return Templates;
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

static function X2AbilityTemplate CreatePassiveAbility(name AbilityName, optional string IconString, optional name IconEffectName = AbilityName, optional bool bDisplayIcon = true)
{
	
	local X2AbilityTemplate					Template;
	local X2Effect_Persistent				IconEffect;
	
	`CREATE_X2ABILITY_TEMPLATE (Template, AbilityName);
	Template.IconImage = IconString;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bCrossClassEligible = false;
	Template.bUniqueSource = true;
	Template.bIsPassive = true;

	// Dummy effect to show a passive icon in the tactical UI for the SourceUnit
	IconEffect = new class'X2Effect_Persistent';
	IconEffect.BuildPersistentEffect(1, true, false);
	IconEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocHelpText, Template.IconImage, bDisplayIcon,, Template.AbilitySourceName);
	IconEffect.EffectName = IconEffectName;
	Template.AddTargetEffect(IconEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;
}

static function X2AbilityTemplate ReinforceAbility(name TemplateName, int iCharges)
{
	local X2AbilityTemplate 				Template;
	local X2AbilityCost_ActionPoints 		ActionPointCost;
	local X2AbilityCharges 					Charges;
	local X2AbilityCost_Charges 			ChargeCost;
	local SpectrumEnemies_Effect_Reinforce	ReinforceEffect;
	local X2AbilityCooldown_LocalAndGlobal 	Cooldown;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_evac";
	Template.Hostility = eHostility_Defensive;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Charges = new class 'X2AbilityCharges';
	Charges.InitialCharges = iCharges; 
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	Cooldown = new class'X2AbilityCooldown_LocalAndGlobal';
	Cooldown.iNumTurns = default.ReinforcementsLocalCooldown;
	Cooldown.NumGlobalTurns = default.ReinforcementsGlobalCooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = Reinforce_BuildVisualization;
	Template.bShowActivation = true;
	Template.bSkipFireAction = true;

	ReinforceEffect = new class 'SpectrumEnemies_Effect_Reinforce';
	Template.AddShooterEffect(ReinforceEffect);

	return Template;
}

simulated function Reinforce_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory 			History;
	local XComGameStateContext_Ability  Context;
	local XComGameState_Ability			Ability;
	local StateObjectReference 			InteractingUnitRef;
	local VisualizationActionMetadata 	EmptyTrack;
	local VisualizationActionMetadata 	BuildTrack;
	local X2Action_PlayAnimation 		PlayAnimationAction;
	local X2Action_PlaySoundAndFlyOver 	SoundAndFlyover;

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;

	BuildTrack = EmptyTrack;
	BuildTrack.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	BuildTrack.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	BuildTrack.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	Ability = XComGameState_Ability(History.GetGameStateForObjectID(context.InputContext.AbilityRef.ObjectID, 1, VisualizeGameState.HistoryIndex - 1));
	SoundAndFlyover = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(BuildTrack, context));
	SoundAndFlyover.SetSoundAndFlyOverParameters(none, Ability.GetMyTemplate().LocFlyOverText, 'None', eColor_Alien);

	PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(BuildTrack, Context));
	PlayAnimationAction.Params.AnimName = 'NO_CallReinforcementsA'; 
	PlayAnimationAction.bFinishAnimationWait = true;
}

static function X2AbilityTemplate DeepPocketsAbility()
{
	local X2AbilityTemplate         Template;

	Template = PurePassive('Spectrum_DeepPockets', "img:///UILibrary_PerkIcons.UIPerk_aceinthehole");	
	
	Template.GetBonusWeaponAmmoFn = DeepPockets_BonusWeaponAmmo;

	return Template;
}

function int DeepPockets_BonusWeaponAmmo(XComGameState_Unit UnitState, XComGameState_Item ItemState)
{
	if (ItemState.InventorySlot == eInvSlot_Utility)
		return default.DeepPocketsBonus;

	return 0;
}