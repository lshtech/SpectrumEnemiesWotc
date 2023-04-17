class Abilities_Utility extends X2Ability dependson (XComGameStateContext_Ability);



static function array<X2DataTemplate> CreateTemplates() 
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(Aegis_ShieldVest());

		return Templates;
}

static function X2AbilityTemplate Aegis_ShieldVest()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityTrigger					Trigger;
	local X2AbilityTarget_Self				TargetStyle;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;
	local Effect_ShieldRegen				RegenerationEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Aegis_ShieldVest');

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.AbilityToHitCalc = default.DeadEye;
	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;
	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);
	
	// Build the regeneration effect
	RegenerationEffect = new class'Effect_ShieldRegen';
	RegenerationEffect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnBegin);
	RegenerationEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false, , Template.AbilitySourceName);
	RegenerationEffect.ShieldCap = class'SpectrumEnemiesWotc.Items_New'.default.SHIELD_VEST_REGEN_CAP;
	RegenerationEffect.ShieldAmount = class'SpectrumEnemiesWotc.Items_New'.default.SHIELD_VEST_REGEN;
	RegenerationEffect.ShieldRegeneratedName = 'ShieldRegen';
	Template.AddTargetEffect(RegenerationEffect);

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false, , Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_HP, class'SpectrumEnemiesWotc.Items_New'.default.SHIELD_VEST_HP);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ShieldHP, class'SpectrumEnemiesWotc.Items_New'.default.SHIELD_VEST_REGEN_CAP);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, class'SpectrumEnemiesWotc.Items_New'.default.SHIELD_VEST_MOBILITY);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}