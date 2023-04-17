class SpectrumEnemies_Character_Aegis extends SpectrumEnemies_Character config(GameData_CharacterStats);

var config(SpectrumEnemies) bool		EnableAegisUnits;
var config(SpectrumEnemies) bool		EnableAegisCaptain;
var config(SpectrumEnemies) bool		EnableAegisTrooper;
var config(SpectrumEnemies) bool		EnableAegisHeavy;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

    if (!default.EnableAegisUnits)
        return Templates;

    if (default.EnableAegisCaptain)
    {
        Templates.AddItem(CreateTemplate_AdvCaptain('AdvCaptainW1'));
	    Templates.AddItem(CreateTemplate_AdvCaptain('AdvCaptainW2'));
	    Templates.AddItem(CreateTemplate_AdvCaptain('AdvCaptainW3'));
    }

    if (default.EnableAegisTrooper)
    {
        Templates.AddItem(CreateTemplate_AdvTrooper('AdvTrooperW1'));
	    Templates.AddItem(CreateTemplate_AdvTrooper('AdvTrooperW2'));
	    Templates.AddItem(CreateTemplate_AdvTrooper('AdvTrooperW3'));
    }

	if (default.EnableAegisHeavy)
    {
        Templates.AddItem(CreateTemplate_AdvHeavy('AdvHeavyW2'));
	    Templates.AddItem(CreateTemplate_AdvHeavy('AdvHeavyW3'));
    }	
	
	return Templates;
}

static function X2CharacterTemplate CreateTemplate_AdvCaptain(name TemplateName)
{
	local X2CharacterTemplate 	CharTemplate;
	local LootReference 		BaseLoot, TimedLoot, VultureLoot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	
	CharTemplate.strBehaviorTree = "AdventAegisCaptain::CharacterRoot";
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_Captains.ARC_GameUnit_AdvCaptainAegis_M");
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_Captains.ARC_GameUnit_AdvCaptainAegis_F");
    
	switch(TemplateName)
	{
		case 'AdvCaptainW1':
			CharTemplate.DefaultLoadout='AdvCaptainW1_Loadout';
			BaseLoot.LootTableName='AdvCaptainM1_BaseLoot';
			TimedLoot.LootTableName = 'AdvCaptainW1_TimedLoot';
			VultureLoot.LootTableName = 'AdvCaptainM1_VultureLoot';
			break;
		case 'AdvCaptainW2':
			CharTemplate.DefaultLoadout='AdvCaptainW2_Loadout';
			BaseLoot.LootTableName='AdvCaptainM2_BaseLoot';
			TimedLoot.LootTableName = 'AdvCaptainw2_TimedLoot';
			VultureLoot.LootTableName = 'AdvCaptainM2_VultureLoot';
			break;
		case 'AdvCaptainW3':
			CharTemplate.DefaultLoadout='AdvCaptainW3_Loadout';
			BaseLoot.LootTableName='AdvCaptainM3_BaseLoot';
			TimedLoot.LootTableName = 'AdvCaptainW3_TimedLoot';
			VultureLoot.LootTableName = 'AdvCaptainM3_VultureLoot';
			break;
	}

	SetLootTables(CharTemplate, BaseLoot, TimedLoot, VultureLoot);
    	
	switch (TemplateName)
	{
		case 'AdvCaptainW3':
			CharTemplate.Abilities.AddItem('Spectrum_DeepPockets');
		case 'AdvCaptainW2':
		case 'AdvCaptainW1':			
			CharTemplate.Abilities.AddItem(GetEnergyShieldVersion(TemplateName));			
			break;
	}

	return AdvCaptain_Default(CharTemplate);
}

static function X2CharacterTemplate CreateTemplate_AdvTrooper(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;
	local LootReference BaseLoot, TimedLoot, VultureLoot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.strBehaviorTree = "AdventAegisTrooper::CharacterRoot";
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_Troopers.ARC_GameUnit_AdvTrooperAegis_M");
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_Troopers.ARC_GameUnit_AdvTrooperAegis_F");

	switch(TemplateName)
	{
		case 'AdvTrooperW1':
			CharTemplate.DefaultLoadout='AdvTrooperW1_Loadout';
			BaseLoot.LootTableName='AdvTrooperM1_BaseLoot';
			TimedLoot.LootTableName = 'AdvTrooperW1_TimedLoot';
			VultureLoot.LootTableName = 'AdvTrooperM1_VultureLoot';
			break;
		case 'AdvTrooperW2':
			CharTemplate.DefaultLoadout='AdvTrooperW2_Loadout';
			BaseLoot.LootTableName='AdvTrooperM2_BaseLoot';
			TimedLoot.LootTableName = 'AdvTrooperW2_TimedLoot';
			VultureLoot.LootTableName = 'AdvTrooperM2_VultureLoot';
			break;
		case 'AdvTrooperW3':
			CharTemplate.DefaultLoadout='AdvTrooperW3_Loadout';
			BaseLoot.LootTableName='AdvTrooperM3_BaseLoot';
			TimedLoot.LootTableName = 'AdvTrooperW3_TimedLoot';
			VultureLoot.LootTableName = 'AdvTrooperM3_VultureLoot';
			break;
	}

	SetLootTables(CharTemplate, BaseLoot, TimedLoot, VultureLoot);
	
	switch (TemplateName)
	{
		case 'AdvTrooperW3':
		case 'AdvTrooperW2':
		case 'AdvTrooperW1':
			CharTemplate.Abilities.AddItem(GetEnergyShieldVersion(TemplateName));			
			break;
	}

	return AdvTrooper_Default(CharTemplate);
}

static function X2CharacterTemplate CreateTemplate_AdvHeavy(name TemplateName)
{
	local X2CharacterTemplate 	CharTemplate;
	local LootReference 		BaseLoot, TimedLoot, VultureLoot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.strBehaviorTree = "AdventAegisHeavy::CharacterRoot";
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_ShieldBearers.ARC_GameUnit_AdvHeavyAegis_M");
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_ShieldBearers.ARC_GameUnit_AdvHeavyAegis_F");

	switch(TemplateName)
	{
		case 'AdvHeavyW2':
			CharTemplate.DefaultLoadout='AdvHeavyW2_Loadout';
			BaseLoot.LootTableName='AdvShieldbearerM2_BaseLoot';
			TimedLoot.LootTableName = 'AdvHeavyW2_TimedLoot';
			VultureLoot.LootTableName = 'AdvShieldbearerM2_VultureLoot';
			break;
		case 'AdvHeavyW3':
			CharTemplate.DefaultLoadout='AdvHeavyW3_Loadout';
			BaseLoot.LootTableName='AdvShieldbearerM3_BaseLoot';
			TimedLoot.LootTableName = 'AdvHeavyW2_TimedLoot';
			VultureLoot.LootTableName = 'AdvShieldbearerM3_VultureLoot';
			break;
	}

	SetLootTables(CharTemplate, BaseLoot, TimedLoot, VultureLoot);
	
	switch (TemplateName)
	{
		case 'AdvHeavyW3':
			break;
		case 'AdvHeavyW2':
			CharTemplate.Abilities.AddItem(GetEnergyShieldVersion(TemplateName));
			break;
	}

	return AdvHeavy_Default(CharTemplate);
}

static function name GetEnergyShieldVersion(name TemplateName)
{
	if (Right(Templatename, 1) == "3")
		return 'EnergyShieldSingleMk3';
	return 'EnergyShieldSingle';
}