class SpectrumEnemies_Ability_Pyro extends SpectrumEnemies_Ability;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate>     Templates;

    Templates.AddItem(PurePassive('AdvPyroImmunities', "img:///UILibrary_PerkIcons.UIPerk_immunities"));
	Templates.AddItem(CreateFireProofAbility());

	return Templates;
}

static function X2AbilityTemplate CreateFireProofAbility()
{
	local X2AbilityTemplate         Template;
	local X2Effect_DamageImmunity   DamageImmunity;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Spectrum_FireProof');

	Template.bDontDisplayInAbilitySummary = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	// Build the immunities
	DamageImmunity = new class'X2Effect_DamageImmunity';
	DamageImmunity.BuildPersistentEffect(1, true, false, true);
	DamageImmunity.ImmuneTypes.AddItem('Fire');
	DamageImmunity.EffectName = 'AdvPyroImmunities';
	Template.AddTargetEffect(DamageImmunity);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}