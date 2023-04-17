class SpectrumEnemies_Character_MEC extends SpectrumEnemies_Character config(GameData_CharacterStats);

var config(SpectrumEnemies) bool		EnableMECUnits;
var config(SpectrumEnemies) bool		EnableMECOfficer;
var config(SpectrumEnemies) bool		EnableMECScout;
var config(SpectrumEnemies) bool		EnableMECHeavy;
var config(SpectrumEnemies) bool		EnableMECLancer;
var config(SpectrumEnemies) bool		EnableMECSupport;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

    if (!default.EnableMECUnits)
        return Templates;

    if (default.EnableMECOfficer)
    {
        Templates.AddItem(CreateTemplate_AdvMECOfficer('AdvMECOfficerM1'));
        Templates.AddItem(CreateTemplate_AdvMECOfficer('AdvMECOfficerM2'));
        Templates.AddItem(CreateTemplate_AdvMECOfficer('AdvMECOfficerM3'));
    }
	
    if (default.EnableMECHeavy)
    {
        Templates.AddItem(CreateTemplate_AdvMECHeavy('AdvMECHeavyM2'));
        Templates.AddItem(CreateTemplate_AdvMECHeavy('AdvMECHeavyM3'));
    }

    if (default.EnableMECLancer)
    {
        Templates.AddItem(CreateTemplate_AdvMECLancer('AdvMECLancerM2'));
        Templates.AddItem(CreateTemplate_AdvMECLancer('AdvMECLancerM3'));
    }
    
	if (default.EnableMECScout)
    {	
        Templates.AddItem(CreateTemplate_AdvMECScout('AdvMECScoutM1'));
        Templates.AddItem(CreateTemplate_AdvMECScout('AdvMECScoutM2'));
        Templates.AddItem(CreateTemplate_AdvMECScout('AdvMECScoutM3'));
    }

    if (default.EnableMECSupport)
    {
        Templates.AddItem(CreateTemplate_AdvMECSupport('AdvMECSupportM2'));
        Templates.AddItem(CreateTemplate_AdvMECSupport('AdvMECSupportM3'));
    }	
	
	return Templates;
}

static function X2CharacterTemplate CreateTemplate_AdvMECOfficer(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;
	local LootReference BaseLoot, TimedLoot, VultureLoot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.CharacterGroupName = 'AdventMEC';	
	CharTemplate.strBehaviorTree = "AdventMECOfficer::CharacterRoot";
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_MECs.ARC_GameUnit_AdvMECOfficer");
	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_robot_icon";	

	switch(TemplateName)
	{
		case 'AdvMECOfficerM1':
			CharTemplate.DefaultLoadout='AdvMECOfficerM1_Loadout';
			BaseLoot.LootTableName='AdvMEC_M1_BaseLoot';
			TimedLoot.LootTableName = 'AdvMECOfficerM1_TimedLoot';
			VultureLoot.LootTableName = 'AdvMEC_M1_VultureLoot';
			break;
		case 'AdvMECOfficerM2':
			CharTemplate.DefaultLoadout='AdvMECOfficerM2_Loadout';
			BaseLoot.LootTableName='AdvMEC_M2_BaseLoot';
			TimedLoot.LootTableName = 'AdvMECOfficerM2_TimedLoot';
			VultureLoot.LootTableName = 'AdvMEC_M2_VultureLoot';
			break;
		case 'AdvMECOfficerM3':
			CharTemplate.DefaultLoadout='AdvMECOfficerM3_Loadout';
			BaseLoot.LootTableName='AdvMEC_M3_BaseLoot';
			TimedLoot.LootTableName = 'AdvMECOfficerM3_TimedLoot';
			VultureLoot.LootTableName = 'AdvMEC_M3_VultureLoot';
			break;
	}

	SetLootTables(CharTemplate, BaseLoot, TimedLoot, VultureLoot);
    SetCommonTraits_MEC(CharTemplate);
	
	switch (TemplateName)
	{
		case 'AdvMECOfficerM3':
			CharTemplate.Abilities.AddItem('Sentinel');
		case 'AdvMECOfficerM2':
			CharTemplate.Abilities.AddItem('SquadSight');
			CharTemplate.Abilities.AddItem('LongWatch');
		case 'AdvMECOfficerM1':
			CharTemplate.Abilities.AddItem('EverVigilant');
			CharTemplate.Abilities.AddItem('CoveringFire');
            CharTemplate.Abilities.AddItem('OracleTarget');
			CharTemplate.Abilities.AddItem('Spectrum_AdventCaptain_CallReinforcements');
			break;
	}

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvMECHeavy(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;
	local LootReference BaseLoot, TimedLoot, VultureLoot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.CharacterGroupName = 'AdventMEC';	
	CharTemplate.strBehaviorTree = "AdventMECHeavy::CharacterRoot";
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_MECs.ARC_GameUnit_AdvMECHeavy");
	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_robot_icon";	

	switch(TemplateName)
	{
		case 'AdvMECHeavyM2':
			CharTemplate.DefaultLoadout='AdvMECHeavyM2_Loadout';
			BaseLoot.LootTableName='AdvMEC_M2_BaseLoot';
			TimedLoot.LootTableName = 'AdvMECHeavyM2_TimedLoot';
			VultureLoot.LootTableName = 'AdvMEC_M2_VultureLoot';
			break;
		case 'AdvMECHeavyM3':
			CharTemplate.DefaultLoadout='AdvMECHeavyM3_Loadout';
			BaseLoot.LootTableName='AdvMEC_M3_BaseLoot';
			TimedLoot.LootTableName = 'AdvMECHeavyM3_TimedLoot';
			VultureLoot.LootTableName = 'AdvMEC_M3_VultureLoot';
			break;
	}

	SetLootTables(CharTemplate, BaseLoot, TimedLoot, VultureLoot);
    SetCommonTraits_MEC(CharTemplate);
	
	switch (TemplateName)
	{
		case 'AdvMECHeavyM3':
			CharTemplate.Abilities.AddItem('EngageSelfDestructMEC');
		case 'AdvMECHeavyM2':
			CharTemplate.Abilities.AddItem('Bulwark');
			break;
	}

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvMECLancer(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;
	local LootReference BaseLoot, TimedLoot, VultureLoot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.CharacterGroupName = 'AdventMEC';	
	CharTemplate.strBehaviorTree = "AdventMECLancer::CharacterRoot";
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_MECs.ARC_GameUnit_AdvMECLancer");
	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_robot_icon";	

	switch(TemplateName)
	{
		case 'AdvMECLancerM2':
			CharTemplate.DefaultLoadout='AdvMECLancerM2_Loadout';
			BaseLoot.LootTableName='AdvMEC_M2_BaseLoot';
			TimedLoot.LootTableName = 'AdvMECLancerM2_TimedLoot';
			VultureLoot.LootTableName = 'AdvMEC_M2_VultureLoot';
			break;
		case 'AdvMECLancerM3':
			CharTemplate.DefaultLoadout='AdvMECLancerM3_Loadout';
			BaseLoot.LootTableName='AdvMEC_M3_BaseLoot';
			TimedLoot.LootTableName = 'AdvMECLancerM3_TimedLoot';
			VultureLoot.LootTableName = 'AdvMEC_M3_VultureLoot';
			break;
	}

	SetLootTables(CharTemplate, BaseLoot, TimedLoot, VultureLoot);
    SetCommonTraits_MEC(CharTemplate);
	
	switch (TemplateName)
	{
		case 'AdvMECLancerM3':
		case 'AdvMECLancerM2':
			CharTemplate.Abilities.AddItem('DevastatingPunch');
			break;
	}

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvMECScout(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;
	local LootReference BaseLoot, TimedLoot, VultureLoot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.CharacterGroupName = 'AdventMEC';	
	CharTemplate.strBehaviorTree = "AdventMEC::CharacterRoot";
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_MECs.ARC_GameUnit_AdvMECScout");
	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_robot_icon";	

	switch(TemplateName)
	{
		case 'AdvMECScoutM1':
			CharTemplate.DefaultLoadout='AdvMECScoutM1_Loadout';
			BaseLoot.LootTableName='AdvMEC_M1_BaseLoot';
			TimedLoot.LootTableName = 'AdvMECScoutM1_TimedLoot';
			VultureLoot.LootTableName = 'AdvMEC_M1_VultureLoot';
			break;
		case 'AdvMECScoutM2':
			CharTemplate.DefaultLoadout='AdvMECScoutM2_Loadout';
			BaseLoot.LootTableName='AdvMEC_M2_BaseLoot';
			TimedLoot.LootTableName = 'AdvMECScoutM2_TimedLoot';
			VultureLoot.LootTableName = 'AdvMEC_M2_VultureLoot';
			break;
		case 'AdvMECScoutM3':
			CharTemplate.DefaultLoadout='AdvMECScoutM3_Loadout';
			BaseLoot.LootTableName='AdvMEC_M3_BaseLoot';
			TimedLoot.LootTableName = 'AdvMECScoutM3_TimedLoot';
			VultureLoot.LootTableName = 'AdvMEC_M3_VultureLoot';
			break;
	}

	SetLootTables(CharTemplate, BaseLoot, TimedLoot, VultureLoot);
    SetCommonTraits_MEC(CharTemplate);
	
	switch (TemplateName)
	{
		case 'AdvMECScoutM3':
		case 'AdvMECScoutM2':
		case 'AdvMECScoutM1':
			break;
	}

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvMECSupport(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;
	local LootReference BaseLoot, TimedLoot, VultureLoot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.CharacterGroupName = 'AdventMEC';	
	CharTemplate.strBehaviorTree = "AdventMECSupport::CharacterRoot";
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_MECs.ARC_GameUnit_AdvMECSupport");
	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_robot_icon";	

	switch(TemplateName)
	{
		case 'AdvMECSupportM2':
			CharTemplate.DefaultLoadout='AdvMECSupportM2_Loadout';
			BaseLoot.LootTableName='AdvMEC_M2_BaseLoot';
			TimedLoot.LootTableName = 'AdvMECSupportM2_TimedLoot';
			VultureLoot.LootTableName = 'AdvMEC_M2_VultureLoot';
			break;
		case 'AdvMECSupportM3':
			CharTemplate.DefaultLoadout='AdvMECSupportM3_Loadout';
			BaseLoot.LootTableName='AdvMEC_M3_BaseLoot';
			TimedLoot.LootTableName = 'AdvMECSupportM3_TimedLoot';
			VultureLoot.LootTableName = 'AdvMEC_M3_VultureLoot';
			break;
	}

	SetLootTables(CharTemplate, BaseLoot, TimedLoot, VultureLoot);
    SetCommonTraits_MEC(CharTemplate);
	
	switch (TemplateName)
	{
		case 'AdvMECSupportM3':
		case 'AdvMECSupportM2':
            CharTemplate.Abilities.AddItem('EnergyShield');
			break;
	}

	return CharTemplate;
}
