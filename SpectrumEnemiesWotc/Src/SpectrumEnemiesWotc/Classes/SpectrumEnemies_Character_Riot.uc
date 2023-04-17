class SpectrumEnemies_Character_Riot extends SpectrumEnemies_Character config(GameData_CharacterStats);

var config(SpectrumEnemies) bool 		EnableRiotUnits;
var config(SpectrumEnemies) bool		EnableRiotCaptain;
var config(SpectrumEnemies) bool		EnableRiotTrooper;
var config(SpectrumEnemies) bool		EnableRiotLancer;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

    if (!default.EnableRiotUnits)
        return Templates;

    if (default.EnableRiotCaptain)
    {
        Templates.AddItem(CreateTemplate_AdvCaptain('AdvCaptainB1'));
	    Templates.AddItem(CreateTemplate_AdvCaptain('AdvCaptainB2'));
	    Templates.AddItem(CreateTemplate_AdvCaptain('AdvCaptainB3'));
    }

    if (default.EnableRiotTrooper)
    {
        Templates.AddItem(CreateTemplate_AdvTrooper('AdvTrooperB1'));
	    Templates.AddItem(CreateTemplate_AdvTrooper('AdvTrooperB2'));
	    Templates.AddItem(CreateTemplate_AdvTrooper('AdvTrooperB3'));
    }

	if (default.EnableRiotLancer)
    {
        Templates.AddItem(CreateTemplate_AdvStunLancer('AdvStunLancerB1'));
	    Templates.AddItem(CreateTemplate_AdvStunLancer('AdvStunLancerB2'));
        Templates.AddItem(CreateTemplate_AdvStunLancer('AdvStunLancerB3'));
    }	
	
	return Templates;
}

static function X2CharacterTemplate CreateTemplate_AdvCaptain(name TemplateName)
{
	local X2CharacterTemplate 	CharTemplate;
	local LootReference 		BaseLoot, TimedLoot, VultureLoot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.strBehaviorTree = "AdventRiotCaptain::CharacterRoot";
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_Captains.ARC_GameUnit_AdvCaptainRiot_M");
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_Captains.ARC_GameUnit_AdvCaptainRiot_F");

	switch(TemplateName)
	{
		case 'AdvCaptainB1':
			CharTemplate.DefaultLoadout='AdvCaptainB1_Loadout';
			BaseLoot.LootTableName='AdvCaptainM1_BaseLoot';
			TimedLoot.LootTableName = 'AdvCaptainB1_TimedLoot';
			VultureLoot.LootTableName = 'AdvCaptainM1_VultureLoot';
			break;
		case 'AdvCaptainB2':
			CharTemplate.DefaultLoadout='AdvCaptainB2_Loadout';
			BaseLoot.LootTableName='AdvCaptainM2_BaseLoot';
			TimedLoot.LootTableName = 'AdvCaptainB2_TimedLoot';
			VultureLoot.LootTableName = 'AdvCaptainM2_VultureLoot';
			break;
		case 'AdvCaptainB3':
			CharTemplate.DefaultLoadout='AdvCaptainB3_Loadout';
			BaseLoot.LootTableName='AdvCaptainM3_BaseLoot';
			TimedLoot.LootTableName = 'AdvCaptainB3_TimedLoot';
			VultureLoot.LootTableName = 'AdvCaptainM3_VultureLoot';
			break;
	}

	SetLootTables(CharTemplate, BaseLoot, TimedLoot, VultureLoot);
	
	CharTemplate = RiotDefaultAbilities(CharTemplate);
	switch (TemplateName)
	{
		case 'AdvCaptainB3':	
			CharTemplate.Abilities.AddItem('Spectrum_DeepPockets');		
		case 'AdvCaptainB2':
		case 'AdvCaptainB1':			
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
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_Troopers.ARC_GameUnit_AdvTrooperRiot_M");
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_Troopers.ARC_GameUnit_AdvTrooperRiot_F");

	switch(TemplateName)
	{
		case 'AdvTrooperB1':
			CharTemplate.DefaultLoadout='AdvTrooperB1_Loadout';
			BaseLoot.LootTableName='AdvTrooperM1_BaseLoot';
			TimedLoot.LootTableName = 'AdvTrooperB1_TimedLoot';
			VultureLoot.LootTableName = 'AdvTrooperM1_VultureLoot';
			break;
		case 'AdvTrooperB2':
			CharTemplate.DefaultLoadout='AdvTrooperB2_Loadout';
			BaseLoot.LootTableName='AdvTrooperM2_BaseLoot';
			TimedLoot.LootTableName = 'AdvTrooperB2_TimedLoot';
			VultureLoot.LootTableName = 'AdvTrooperM2_VultureLoot';
			break;
		case 'AdvTrooperB3':
			CharTemplate.DefaultLoadout='AdvTrooperB3_Loadout';
			BaseLoot.LootTableName='AdvTrooperM3_BaseLoot';
			TimedLoot.LootTableName = 'AdvTrooperB3_TimedLoot';
			VultureLoot.LootTableName = 'AdvTrooperM3_VultureLoot';
			break;
	}

	SetLootTables(CharTemplate, BaseLoot, TimedLoot, VultureLoot);
	
	CharTemplate = RiotDefaultAbilities(CharTemplate);
	switch (TemplateName)
	{
		case 'AdvTrooperP3':
		case 'AdvTrooperP2':
		case 'AdvTrooperP1':
			break;
	}

	return AdvTrooper_Default(CharTemplate);
}

static function X2CharacterTemplate CreateTemplate_AdvStunLancer(name TemplateName)
{
	local X2CharacterTemplate 	CharTemplate;
	local LootReference 		BaseLoot, TimedLoot, VultureLoot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.CharacterGroupName = 'AdventStunLancer';	
	CharTemplate.strBehaviorTree = "AdventRiotStunLancer::CharacterRoot";
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_Lancers.ARC_GameUnit_AdvScoutRiot_M");
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_Lancers.ARC_GameUnit_AdvScoutRiot_M");
    CharTemplate.RevealMatineePrefix = "CIN_Advent_StunLancer";
	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";	

	switch(TemplateName)
	{
        case 'AdvStunLancerB1':
			CharTemplate.DefaultLoadout='AdvStunLancerB1_Loadout';
			BaseLoot.LootTableName='AdvStunLancerM1_BaseLoot';
			TimedLoot.LootTableName = 'AdvStunLancerB1_TimedLoot';
			VultureLoot.LootTableName = 'AdvStunLancerM1_VultureLoot';
			break;
		case 'AdvStunLancerB2':
			CharTemplate.DefaultLoadout='AdvStunLancerB2_Loadout';
			BaseLoot.LootTableName='AdvStunLancerM2_BaseLoot';
			TimedLoot.LootTableName = 'AdvStunLancerB2_TimedLoot';
			VultureLoot.LootTableName = 'AdvStunLancerM2_VultureLoot';
			break;
		case 'AdvStunLancerB3':
			CharTemplate.DefaultLoadout='AdvStunLancerB3_Loadout';
			BaseLoot.LootTableName='AdvStunLancerM3_BaseLoot';
			TimedLoot.LootTableName = 'AdvStunLancerB3_TimedLoot';
			VultureLoot.LootTableName = 'AdvStunLancerM3_VultureLoot';
			break;
	}

	SetLootTables(CharTemplate, BaseLoot, TimedLoot, VultureLoot);
	
	CharTemplate = RiotDefaultAbilities(CharTemplate);
	switch (TemplateName)
	{
		case 'AdvStunLancerB3':
			CharTemplate.Abilities.AddItem('Spectrum_Reposition');
		case 'AdvStunLancerB2':
        case 'AdvStunLancerB1':
			CharTemplate.Abilities.AddItem('DarkEventAbility_BendingReed');
			break;
	}

	return SetCommonTraits_Advent(CharTemplate);
}

static function X2CharacterTemplate RiotDefaultAbilities(X2CharacterTemplate CharTemplate)
{
	return CharTemplate;
}