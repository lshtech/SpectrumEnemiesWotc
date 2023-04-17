class SpectrumEnemies_Character_Toxic extends SpectrumEnemies_Character config(GameData_CharacterStats);

var config(SpectrumEnemies) bool		EnableToxicUnits;
var config(SpectrumEnemies) bool		EnableToxicCaptain;
var config(SpectrumEnemies) bool		EnableToxicTrooper;
var config(SpectrumEnemies) bool		EnableToxicHeavy;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

    if (!default.EnableToxicUnits)
        return Templates;

    if (default.EnableToxicCaptain)
    {
        Templates.AddItem(CreateTemplate_AdvCaptain('AdvCaptainG1'));
	    Templates.AddItem(CreateTemplate_AdvCaptain('AdvCaptainG2'));
	    Templates.AddItem(CreateTemplate_AdvCaptain('AdvCaptainG3'));
    }

    if (default.EnableToxicTrooper)
    {
        Templates.AddItem(CreateTemplate_AdvTrooper('AdvTrooperG1'));
	    Templates.AddItem(CreateTemplate_AdvTrooper('AdvTrooperG2'));
	    Templates.AddItem(CreateTemplate_AdvTrooper('AdvTrooperG3'));
    }

	if (default.EnableToxicHeavy)
    {
        Templates.AddItem(CreateTemplate_AdvHeavy('AdvHeavyG2'));
	    Templates.AddItem(CreateTemplate_AdvHeavy('AdvHeavyG3'));
    }	
	
	return Templates;
}

static function X2CharacterTemplate CreateTemplate_AdvCaptain(name TemplateName)
{
	local X2CharacterTemplate 	CharTemplate;
	local LootReference 		BaseLoot, TimedLoot, VultureLoot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.strBehaviorTree = "AdventToxicCaptain::CharacterRoot";
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_Captains.ARC_GameUnit_AdvCaptainToxic_M");
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_Captains.ARC_GameUnit_AdvCaptainToxic_F");

	switch(TemplateName)
	{
		case 'AdvCaptainG1':
			CharTemplate.DefaultLoadout='AdvCaptainG1_Loadout';
			BaseLoot.LootTableName='AdvCaptainM1_BaseLoot';
			TimedLoot.LootTableName = 'AdvCaptainG1_TimedLoot';
			VultureLoot.LootTableName = 'AdvCaptainM1_VultureLoot';
			break;
		case 'AdvCaptainG2':
			CharTemplate.DefaultLoadout='AdvCaptainG2_Loadout';
			BaseLoot.LootTableName='AdvCaptainM2_BaseLoot';
			TimedLoot.LootTableName = 'AdvCaptainG2_TimedLoot';
			VultureLoot.LootTableName = 'AdvCaptainM2_VultureLoot';
			break;
		case 'AdvCaptainG3':
			CharTemplate.DefaultLoadout='AdvCaptainG3_Loadout';
			BaseLoot.LootTableName='AdvCaptainM3_BaseLoot';
			TimedLoot.LootTableName = 'AdvCaptainG3_TimedLoot';
			VultureLoot.LootTableName = 'AdvCaptainM3_VultureLoot';
			break;
	}

	SetLootTables(CharTemplate, BaseLoot, TimedLoot, VultureLoot);
	
	CharTemplate = ToxicDefaultAbilities(CharTemplate);
	switch (TemplateName)
	{
		case 'AdvCaptainG3':
			CharTemplate.Abilities.AddItem('Spectrum_DeepPockets');
			CharTemplate.Abilities.AddItem('MZToxicBullet');
		case 'AdvCaptainG2':
		case 'AdvCaptainG1':
			CharTemplate.Abilities.AddItem('Spectrum_PoisonPurification');
			break;
	}

	return AdvCaptain_Default(CharTemplate);
}

static function X2CharacterTemplate CreateTemplate_AdvTrooper(name TemplateName)
{
	local X2CharacterTemplate 	CharTemplate;
	local LootReference 		BaseLoot, TimedLoot, VultureLoot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.strBehaviorTree = "AdventTrooper::CharacterRoot";
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_Troopers.ARC_GameUnit_AdvTrooperToxic_M");
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_Troopers.ARC_GameUnit_AdvTrooperToxic_F");

	switch(TemplateName)
	{
		case 'AdvTrooperG1':
			CharTemplate.DefaultLoadout='AdvTrooperG1_Loadout';
			BaseLoot.LootTableName='AdvTrooperM1_BaseLoot';
			TimedLoot.LootTableName = 'AdvTrooperG1_TimedLoot';
			VultureLoot.LootTableName = 'AdvTrooperM1_VultureLoot';
			break;
		case 'AdvTrooperG2':
			CharTemplate.DefaultLoadout='AdvTrooperG2_Loadout';
			BaseLoot.LootTableName='AdvTrooperM2_BaseLoot';
			TimedLoot.LootTableName = 'AdvTrooperG2_TimedLoot';
			VultureLoot.LootTableName = 'AdvTrooperM2_VultureLoot';
			break;
		case 'AdvTrooperG3':
			CharTemplate.DefaultLoadout='AdvTrooperG3_Loadout';
			BaseLoot.LootTableName='AdvTrooperM3_BaseLoot';
			TimedLoot.LootTableName = 'AdvTrooperG3_TimedLoot';
			VultureLoot.LootTableName = 'AdvTrooperM3_VultureLoot';
			break;
	}

	SetLootTables(CharTemplate, BaseLoot, TimedLoot, VultureLoot);
	
	CharTemplate = ToxicDefaultAbilities(CharTemplate);
	switch (TemplateName)
	{
		case 'AdvTrooperG3':
			CharTemplate.Abilities.AddItem('MZViperBloodTrigger');
		case 'AdvTrooperG2':
			CharTemplate.Abilities.AddItem('Spectrum_PoisonPurification');
		case 'AdvTrooperG1':
			break;
	}

	return AdvTrooper_Default(CharTemplate);
}

static function X2CharacterTemplate CreateTemplate_AdvHeavy(name TemplateName)
{
	local X2CharacterTemplate 	CharTemplate;
	local LootReference 		BaseLoot, TimedLoot, VultureLoot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.strBehaviorTree = "AdventToxicHeavy::CharacterRoot";
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_ShieldBearers.ARC_GameUnit_AdvHeavyTox_M");
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_ShieldBearers.ARC_GameUnit_AdvHeavyTox_F");

	switch(TemplateName)
	{
		case 'AdvHeavyG2':
			CharTemplate.DefaultLoadout='AdvHeavyG2_Loadout';
			BaseLoot.LootTableName='AdvShieldbearerM2_BaseLoot';
			TimedLoot.LootTableName = 'AdvHeavyG2_TimedLoot';
			VultureLoot.LootTableName = 'AdvShieldbearerM2_VultureLoot';
			break;
		case 'AdvHeavyG3':
			CharTemplate.DefaultLoadout='AdvHeavyG3_Loadout';
			BaseLoot.LootTableName='AdvShieldbearerM3_BaseLoot';
			TimedLoot.LootTableName = 'AdvHeavyG3_TimedLoot';
			VultureLoot.LootTableName = 'AdvShieldbearerM3_VultureLoot';
			break;
	}

	SetLootTables(CharTemplate, BaseLoot, TimedLoot, VultureLoot);
	
	CharTemplate = ToxicDefaultAbilities(CharTemplate);
	switch (TemplateName)
	{
		case 'AdvHeavyG3':
			CharTemplate.Abilities.AddItem('MZPlagueSpear');
		case 'AdvHeavyG2':
			CharTemplate.Abilities.AddItem('Spectrum_PoisonPurification');
			CharTemplate.Abilities.AddItem('MZPoisoningSuppression');
			break;
	}

	return AdvHeavy_Default(CharTemplate);
}

static function X2CharacterTemplate ToxicDefaultAbilities(X2CharacterTemplate CharTemplate)
{
	CharTemplate.Abilities.AddItem('Spectrum_PoisonProof');
	return CharTemplate;
}
