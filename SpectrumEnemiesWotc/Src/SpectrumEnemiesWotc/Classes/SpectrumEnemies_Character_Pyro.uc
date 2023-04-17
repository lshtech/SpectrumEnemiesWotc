class SpectrumEnemies_Character_Pyro extends SpectrumEnemies_Character config(GameData_CharacterStats);

var config(SpectrumEnemies) bool		EnablePyroUnits;
var config(SpectrumEnemies) bool		EnablePyroCaptain;
var config(SpectrumEnemies) bool		EnablePyroTrooper;
var config(SpectrumEnemies) bool		EnablePyroHeavy;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

    if (!default.EnablePyroUnits)
        return Templates;

    if (default.EnablePyroCaptain)
    {
        Templates.AddItem(CreateTemplate_AdvCaptain('AdvCaptainO1'));
	    Templates.AddItem(CreateTemplate_AdvCaptain('AdvCaptainO2'));
	    Templates.AddItem(CreateTemplate_AdvCaptain('AdvCaptainO3'));
    }

    if (default.EnablePyroTrooper)
    {
        Templates.AddItem(CreateTemplate_AdvTrooper('AdvTrooperO1'));
	    Templates.AddItem(CreateTemplate_AdvTrooper('AdvTrooperO2'));
	    Templates.AddItem(CreateTemplate_AdvTrooper('AdvTrooperO3'));
    }

	if (default.EnablePyroHeavy)
    {
        Templates.AddItem(CreateTemplate_AdvHeavy('AdvHeavyO2'));
	    Templates.AddItem(CreateTemplate_AdvHeavy('AdvHeavyO3'));
    }	
	
	return Templates;
}

static function X2CharacterTemplate CreateTemplate_AdvCaptain(name TemplateName)
{
	local X2CharacterTemplate 	CharTemplate;
	local LootReference 		BaseLoot, TimedLoot, VultureLoot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.strBehaviorTree = "AdventPyroCaptain::CharacterRoot";
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_Captains.ARC_GameUnit_AdvCaptainPyro_M");
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_Captains.ARC_GameUnit_AdvCaptainPyro_F");

	switch(TemplateName)
	{
		case 'AdvCaptainO1':
			CharTemplate.DefaultLoadout='AdvCaptainO1_Loadout';
			BaseLoot.LootTableName='AdvCaptainM1_BaseLoot';
			TimedLoot.LootTableName = 'AdvCaptainO1_TimedLoot';
			VultureLoot.LootTableName = 'AdvCaptainM1_VultureLoot';
			break;
		case 'AdvCaptainO2':
			CharTemplate.DefaultLoadout='AdvCaptainO2_Loadout';
			BaseLoot.LootTableName='AdvCaptainM2_BaseLoot';
			TimedLoot.LootTableName = 'AdvCaptainO2_TimedLoot';
			VultureLoot.LootTableName = 'AdvCaptainM2_VultureLoot';
			break;
		case 'AdvCaptainO3':
			CharTemplate.DefaultLoadout='AdvCaptainO3_Loadout';
			BaseLoot.LootTableName='AdvCaptainM3_BaseLoot';
			TimedLoot.LootTableName = 'AdvCaptainO3_TimedLoot';
			VultureLoot.LootTableName = 'AdvCaptainM3_VultureLoot';
			break;
	}

	SetLootTables(CharTemplate, BaseLoot, TimedLoot, VultureLoot);
	
	CharTemplate = PyroDefaultAbilities(CharTemplate);
	switch (TemplateName)
	{
		case 'AdvCaptainO3':
			CharTemplate.Abilities.AddItem('Spectrum_DeepPockets');
			CharTemplate.Abilities.AddItem('MZBlazeBullet');
		case 'AdvCaptainO2':
		case 'AdvCaptainO1':
			CharTemplate.Abilities.AddItem('ScorchArmor115');
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
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_Troopers.ARC_GameUnit_AdvTrooperPyro_M");
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_Troopers.ARC_GameUnit_AdvTrooperPyro_F");

	switch(TemplateName)
	{
		case 'AdvTrooperO1':
			CharTemplate.DefaultLoadout='AdvTrooperO1_Loadout';
			BaseLoot.LootTableName='AdvTrooperM1_BaseLoot';
			TimedLoot.LootTableName = 'AdvTrooperO1_TimedLoot';
			VultureLoot.LootTableName = 'AdvTrooperM1_VultureLoot';
			break;
		case 'AdvTrooperO2':
			CharTemplate.DefaultLoadout='AdvTrooperO2_Loadout';
			BaseLoot.LootTableName='AdvTrooperM2_BaseLoot';
			TimedLoot.LootTableName = 'AdvTrooperO2_TimedLoot';
			VultureLoot.LootTableName = 'AdvTrooperM2_VultureLoot';
			break;
		case 'AdvTrooperO3':
			CharTemplate.DefaultLoadout='AdvTrooperO3_Loadout';
			BaseLoot.LootTableName='AdvTrooperM3_BaseLoot';
			TimedLoot.LootTableName = 'AdvTrooperO3_TimedLoot';
			VultureLoot.LootTableName = 'AdvTrooperM3_VultureLoot';
			break;
	}

	SetLootTables(CharTemplate, BaseLoot, TimedLoot, VultureLoot);
	
	CharTemplate = PyroDefaultAbilities(CharTemplate);
	switch (TemplateName)
	{
		case 'AdvTrooperO3':
		case 'AdvTrooperO2':
			CharTemplate.Abilities.AddItem('ScorchArmor115');
		case 'AdvTrooperO1':
			break;
	}

	return AdvTrooper_Default(CharTemplate);
}

static function X2CharacterTemplate CreateTemplate_AdvHeavy(name TemplateName)
{
	local X2CharacterTemplate 	CharTemplate;
	local LootReference 		BaseLoot, TimedLoot, VultureLoot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.strBehaviorTree = "AdventPyroHeavy::CharacterRoot";
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_ShieldBearers.ARC_GameUnit_AdvHeavyPyro_M");
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_ShieldBearers.ARC_GameUnit_AdvHeavyPyro_F");

	switch(TemplateName)
	{
		case 'AdvHeavyO2':
			CharTemplate.DefaultLoadout='AdvHeavyO2_Loadout';
			BaseLoot.LootTableName='AdvShieldbearerM2_BaseLoot';
			TimedLoot.LootTableName = 'AdvHeavyO2_TimedLoot';
			VultureLoot.LootTableName = 'AdvShieldbearerM2_VultureLoot';
			break;
		case 'AdvHeavyO3':
			CharTemplate.DefaultLoadout='AdvHeavyO3_Loadout';
			BaseLoot.LootTableName='AdvShieldbearerM3_BaseLoot';
			TimedLoot.LootTableName = 'AdvHeavyO3_TimedLoot';
			VultureLoot.LootTableName = 'AdvShieldbearerM3_VultureLoot';
			break;
	}

	SetLootTables(CharTemplate, BaseLoot, TimedLoot, VultureLoot);
	
	CharTemplate = PyroDefaultAbilities(CharTemplate);
	switch (TemplateName)
	{
		case 'AdvHeavyO3':
			CharTemplate.Abilities.AddItem('MZBlazingSpear');
		case 'AdvHeavyO2':	
			CharTemplate.Abilities.AddItem('MZBurningSuppression');		
			break;
	}

	return AdvHeavy_Default(CharTemplate);
}

static function X2CharacterTemplate PyroDefaultAbilities(X2CharacterTemplate CharTemplate)
{
	CharTemplate.Abilities.AddItem('Spectrum_FireProof');
	return CharTemplate;
}
