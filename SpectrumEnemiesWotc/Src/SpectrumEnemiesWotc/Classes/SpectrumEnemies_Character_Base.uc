class SpectrumEnemies_Character_Base extends SpectrumEnemies_Character config(GameData_CharacterStats);

var config(SpectrumEnemies) bool     	EnableBaseUnits;
var config(SpectrumEnemies) bool		EnableCommander;
var config(SpectrumEnemies) bool		EnableScout;
var config(SpectrumEnemies) bool		EnableSniper;
var config(SpectrumEnemies) bool		EnableHeavy;
var config(SpectrumEnemies) bool		EnableShredder;	

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

    if (!default.EnableBaseUnits)
        return Templates;

    if (default.EnableCommander)
    {
        Templates.AddItem(CreateTemplate_AdvCommander('AdvCommanderM0'));
        Templates.AddItem(CreateTemplate_AdvCommander('AdvCommanderM1'));
        Templates.AddItem(CreateTemplate_AdvCommander('AdvCommanderM2'));
        Templates.AddItem(CreateTemplate_AdvCommander('AdvCommanderM3'));
    }
	
    if (default.EnableScout)
    {
        Templates.AddItem(CreateTemplate_AdvScout('AdvScoutM1'));
        Templates.AddItem(CreateTemplate_AdvScout('AdvScoutM2'));
        Templates.AddItem(CreateTemplate_AdvScout('AdvScoutM3'));
    }

    if (default.EnableSniper)
    {
        Templates.AddItem(CreateTemplate_AdvSniper('AdvSniperM2'));
	    Templates.AddItem(CreateTemplate_AdvSniper('AdvSniperM3'));
    }
    
	if (default.EnableHeavy)
    {
        Templates.AddItem(CreateTemplate_AdvHeavy('AdvHeavyM2'));
	    Templates.AddItem(CreateTemplate_AdvHeavy('AdvHeavyM3'));	
    }

    if (default.EnableShredder)
    {
        Templates.AddItem(CreateTemplate_AdvShredder('AdvShredderM2'));
	    Templates.AddItem(CreateTemplate_AdvShredder('AdvShredderM3'));
    }	
	
	return Templates;
}

static function X2CharacterTemplate CreateTemplate_AdvCommander(name TemplateName)
{
	local X2CharacterTemplate 	CharTemplate;
	local LootReference 		BaseLoot, TimedLoot, VultureLoot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.strBehaviorTree = "AdventCommander::CharacterRoot";
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_ShieldBearers.ARC_GameUnit_AdvCommander_M");
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_ShieldBearers.ARC_GameUnit_AdvCommander_F");

	CharTemplate.CharacterGroupName = 'AdventCaptain';
	CharTemplate.RevealMatineePrefix = "CIN_Advent_Captain";
	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.SightedEvents.AddItem('AdventCaptainSighted');

	switch(TemplateName)
	{
		case 'AdvCommanderM0':
			CharTemplate.DefaultLoadout='AdvCommanderM0_Loadout';
			BaseLoot.LootTableName='AdvCaptainM1_BaseLoot';
			TimedLoot.LootTableName = 'AdvCommanderM0_TimedLoot';
			VultureLoot.LootTableName = 'AdvShieldBearerM2_VultureLoot';
			break;
		case 'AdvCommanderM1':
			CharTemplate.DefaultLoadout='AdvCommanderM1_Loadout';
			BaseLoot.LootTableName='AdvCaptainM1_BaseLoot';
			TimedLoot.LootTableName = 'AdvCommanderM1_TimedLoot';
			VultureLoot.LootTableName = 'AdvShieldBearerM2_VultureLoot';
			break;
		case 'AdvCommanderM2':
			CharTemplate.DefaultLoadout='AdvCommanderM2_Loadout';
			BaseLoot.LootTableName='AdvCaptainM2_BaseLoot';
			TimedLoot.LootTableName = 'AdvCommanderM2_TimedLoot';
			VultureLoot.LootTableName = 'AdvShieldBearerM2_VultureLoot';
			break;
		case 'AdvCommanderM3':
			CharTemplate.DefaultLoadout='AdvCommanderM3_Loadout';
			BaseLoot.LootTableName='AdvCaptainM3_BaseLoot';
			TimedLoot.LootTableName = 'AdvCommanderM3_TimedLoot';
			VultureLoot.LootTableName = 'AdvShieldBearerM2_VultureLoot';
			break;
	}

	SetLootTables(CharTemplate, BaseLoot, TimedLoot, VultureLoot);
	SetCommonTraits_Advent(CharTemplate);
	
	switch (TemplateName)
	{
		case 'AdvCommanderM3':
			CharTemplate.Abilities.AddItem('Spectrum_DeepPockets');
			CharTemplate.Abilities.AddItem('APRounds');
		case 'AdvCommanderM2':
			CharTemplate.Abilities.AddItem('Sustain');
		case 'AdvCommanderM1':
			CharTemplate.Abilities.AddItem(GetEnergyShieldVersion(TemplateName));
		case 'AdvCommanderM0':
            CharTemplate.Abilities.AddItem('StasisVestBonus');
			CharTemplate.Abilities.AddItem('Spectrum_AdventCommander_CallReinforcements');
			CharTemplate.Abilities.AddItem('MarkTarget');
			CharTemplate.Abilities.AddItem('DarkEventAbility_ReturnFire');
			break;
	}

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvScout(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;
	local LootReference BaseLoot, TimedLoot, VultureLoot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.CharacterGroupName = 'AdventStunLancer';
	CharTemplate.strBehaviorTree = "AdventScout::CharacterRoot";
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_Lancers.ARC_GameUnit_AdvScoutSpotter_M");
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_Lancers.ARC_GameUnit_AdvScoutSpotter_F");
    CharTemplate.RevealMatineePrefix = "CIN_Advent_Captain";
    CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	
	switch (TemplateName)
	{
		case 'AdvScoutM1':
			CharTemplate.DefaultLoadout = 'AdvScoutM1_Loadout';
			BaseLoot.LootTableName = 'AdvTrooperM1_BaseLoot';
			TimedLoot.LootTableName = 'AdvScoutM1_TimedLoot';
			VultureLoot.LootTableName = 'AdvTrooperM1_VultureLoot';
			break;
		case 'AdvScoutM2':
			CharTemplate.DefaultLoadout = 'AdvScoutM2_Loadout';
			BaseLoot.LootTableName = 'AdvTrooperM2_BaseLoot';
			TimedLoot.LootTableName = 'AdvScoutM2_TimedLoot';
			VultureLoot.LootTableName = 'AdvTrooperM2_VultureLoot';
			break;
		case 'AdvScoutM3':
			CharTemplate.DefaultLoadout = 'AdvScoutM3_Loadout';
			BaseLoot.LootTableName='AdvTrooperM3_BaseLoot';
			TimedLoot.LootTableName = 'AdvScoutM3_TimedLoot';
			VultureLoot.LootTableName = 'AdvTrooperM3_VultureLoot';
			break;
	}	

    SetLootTables(CharTemplate, BaseLoot, TimedLoot, VultureLoot);
    SetCommonTraits_Advent(CharTemplate);

	switch (TemplateName)
	{
		case 'AdvScoutM3':
			CharTemplate.Abilities.AddItem('Spectrum_Reposition');
		case 'AdvScoutM2':
			CharTemplate.Abilities.AddItem('Shadowstep');
		case 'AdvScoutM1':
			CharTemplate.Abilities.AddItem('MarkTarget');
			CharTemplate.Abilities.AddItem('Spectrum_LowProfile');
			CharTemplate.Abilities.AddItem('DarkEventAbility_LightningReflexes');
			break;
	}

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvSniper(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;
	local LootReference BaseLoot, TimedLoot, VultureLoot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.CharacterGroupName = 'AdventStunLancer';
	CharTemplate.strBehaviorTree = "AdventSniper::CharacterRoot";
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_Lancers.ARC_GameUnit_AdvScoutSniper_M");
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_Lancers.ARC_GameUnit_AdvScoutSniper_F");
	CharTemplate.RevealMatineePrefix = "CIN_Advent_Captain";
    CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";

    switch (TemplateName)
	{
		case 'AdvSniperM2':
			CharTemplate.DefaultLoadout = 'AdvSniperM2_Loadout';
			BaseLoot.LootTableName = 'AdvTrooperM2_BaseLoot';
			TimedLoot.LootTableName = 'AdvSniperM2_TimedLoot';
			VultureLoot.LootTableName = 'AdvTrooperM2_VultureLoot';
			break;
		case 'AdvSniperM3':
			CharTemplate.DefaultLoadout = 'AdvSniperM3_Loadout';
			BaseLoot.LootTableName='AdvTrooperM3_BaseLoot';
			TimedLoot.LootTableName = 'AdvSniperM3_TimedLoot';
			VultureLoot.LootTableName = 'AdvTrooperM3_VultureLoot';
			break;
	}

    SetLootTables(CharTemplate, BaseLoot, TimedLoot, VultureLoot);
    SetCommonTraits_Advent(CharTemplate);

	switch (TemplateName)
	{
		case 'AdvSniperM3':
			CharTemplate.Abilities.AddItem('Spectrum_Patience');
		case 'AdvSniperM2':
            CharTemplate.Abilities.AddItem('Spectrum_CrackShot');
            CharTemplate.Abilities.AddItem('Squadsight');
			CharTemplate.Abilities.AddItem('HunkerDown');
			CharTemplate.Abilities.AddItem('DarkEventAbility_LightningReflexes');
			break;
	}

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_AdvShredder(name TemplateName)
{
	local X2CharacterTemplate 	CharTemplate;
	local LootReference 		BaseLoot, TimedLoot, VultureLoot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.strBehaviorTree = "AdventShredder::CharacterRoot";
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_Shieldbearers.ARC_GameUnit_AdvShredder_M");
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_Shieldbearers.ARC_GameUnit_AdvShredder_F");

    switch (TemplateName)
	{
		case 'AdvShredderM2':
			CharTemplate.DefaultLoadout = 'AdvShredderM2_Loadout';
			BaseLoot.LootTableName = 'AdvShieldBearerM2_BaseLoot';
			TimedLoot.LootTableName = 'AdvShredderM2_TimedLoot';
			VultureLoot.LootTableName = 'AdvShieldbearerM2_VultureLoot';
			break;
		case 'AdvShredderM3':
			CharTemplate.DefaultLoadout = 'AdvShredderM3_Loadout';
			BaseLoot.LootTableName='AdvShieldBearerM3_BaseLoot';
			TimedLoot.LootTableName = 'AdvShredderM3_TimedLoot';
			VultureLoot.LootTableName = 'AdvShieldbearerM3_VultureLoot';
			break;
	}

    SetLootTables(CharTemplate, BaseLoot, TimedLoot, VultureLoot);

	switch (TemplateName)
	{
		case 'AdvShredderM3':
			CharTemplate.Abilities.AddItem('Spectrum_PavementShrapnel');
		case 'AdvShredderM2':
			break;
	}

	return AdvHeavy_Default(CharTemplate);
}

static function X2CharacterTemplate CreateTemplate_AdvHeavy(name TemplateName)
{
	local X2CharacterTemplate 	CharTemplate;
	local LootReference 		BaseLoot, TimedLoot, VultureLoot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.strBehaviorTree = "AdventHeavy::CharacterRoot";
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_Shieldbearers.ARC_GameUnit_AdvHeavy_M");
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_Shieldbearers.ARC_GameUnit_AdvHeavy_F");

    switch (TemplateName)
	{
		case 'AdvHeavyM2':
			CharTemplate.DefaultLoadout = 'AdvHeavyM2_Loadout';
			BaseLoot.LootTableName = 'AdvShieldBearerM2_BaseLoot';
			TimedLoot.LootTableName = 'AdvHeavyM2_TimedLoot';
			VultureLoot.LootTableName = 'AdvShieldbearerM2_VultureLoot';
			break;
		case 'AdvHeavyM3':
			CharTemplate.DefaultLoadout = 'AdvHeavyM3_Loadout';
			BaseLoot.LootTableName='AdvShieldBearerM3_BaseLoot';
			TimedLoot.LootTableName = 'AdvHeavyM3_TimedLoot';
			VultureLoot.LootTableName = 'AdvShieldbearerM3_VultureLoot';
			break;
	}

    SetLootTables(CharTemplate, BaseLoot, TimedLoot, VultureLoot);

	switch (TemplateName)
	{
		case 'AdvHeavyM3':
			CharTemplate.Abilities.AddItem('Spectrum_Spray');
		case 'AdvHeavyM2':            
			break;
	}

	return AdvHeavy_Default(CharTemplate);
}

static function name GetEnergyShieldVersion(name TemplateName)
{
	if (Right(Templatename, 1) == "3")
		return 'EnergyShieldMk3';
	return 'EnergyShield';
}