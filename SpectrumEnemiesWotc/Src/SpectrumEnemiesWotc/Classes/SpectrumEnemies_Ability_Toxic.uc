class SpectrumEnemies_Ability_Toxic extends SpectrumEnemies_Ability;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate>     Templates;

    Templates.AddItem(PurePassive('AdvToxicImmunities', "img:///UILibrary_PerkIcons.UIPerk_immunities"));
	Templates.AddItem(CreatePoisonProofAbility());
	Templates.AddItem(PurePassive('AdvToxicPrufication', "img:///UILibrary_PerkIcons.UIPerk_immunities"));
	Templates.AddItem(CreatePurificationAbility());
	Templates.AddItem(PurePassive('AdvToxicPoisonBlood', "img:///UILibrary_PerkIcons.UIPerk_immunities"));

	return Templates;
}

static function X2AbilityTemplate CreatePoisonProofAbility()
{
	local X2AbilityTemplate         Template;
	local X2Effect_DamageImmunity   DamageImmunity;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Spectrum_PoisonProof');

	Template.bDontDisplayInAbilitySummary = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.AdditionalAbilities.AddItem('AdvToxicImmunities');

	// Build the immunities
	DamageImmunity = new class'X2Effect_DamageImmunity';
	DamageImmunity.BuildPersistentEffect(1, true, false, true);
	DamageImmunity.ImmuneTypes.AddItem('Poison');
	DamageImmunity.ImmuneTypes.AddItem(class'X2Item_DefaultDamageTypes'.default.ParthenogenicPoisonType);
	Template.AddTargetEffect(DamageImmunity);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate CreatePurificationAbility()
{
	local X2AbilityTemplate         			Template;
	local SpectrumEnemies_Effect_Purification 	PurificationEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Spectrum_PoisonPurification');

	Template.bDontDisplayInAbilitySummary = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.AdditionalAbilities.AddItem('AdvToxicPrufication');

	PurificationEffect = new class'SpectrumEnemies_Effect_Purification';
	PurificationEffect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnEnd);
	PurificationEffect.HealAmount = 2;
	Template.AddTargetEffect(PurificationEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate CreatePoisonBloodAbility()
{
	local X2AbilityTemplate		Template;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Spectrum_PoisonBlood');

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_viper_getoverhere";
	Template.AbilitySourceName = 'eAbilitySource_Perk';

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);	

	Template.AdditionalAbilities.AddItem('MZViperBloodTrigger');

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = none;

	return Template;
}