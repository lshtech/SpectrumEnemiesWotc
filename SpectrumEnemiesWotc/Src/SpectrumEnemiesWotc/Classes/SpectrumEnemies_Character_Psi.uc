class SpectrumEnemies_Character_Psi extends SpectrumEnemies_Character config(GameData_CharacterStats);

var config(SpectrumEnemies) bool		EnablePsiUnits;
var config(SpectrumEnemies) bool		EnablePsiCaptain;
var config(SpectrumEnemies) bool		EnablePsiTrooper;
var config(SpectrumEnemies) bool		EnablePsiSniper;
var config(SpectrumEnemies) bool		EnableUndyingExperimental;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

    if (!default.EnablePsiUnits)
        return Templates;

    if (default.EnablePsiCaptain)
    {
        Templates.AddItem(CreateTemplate_AdvCaptain('AdvCaptainP1'));
	    Templates.AddItem(CreateTemplate_AdvCaptain('AdvCaptainP2'));
	    Templates.AddItem(CreateTemplate_AdvCaptain('AdvCaptainP3'));
    }

    if (default.EnablePsiTrooper)
    {
        Templates.AddItem(CreateTemplate_AdvTrooper('AdvTrooperP1'));
	    Templates.AddItem(CreateTemplate_AdvTrooper('AdvTrooperP2'));
	    Templates.AddItem(CreateTemplate_AdvTrooper('AdvTrooperP3'));
    }

	if (default.EnablePsiSniper)
    {
        Templates.AddItem(CreateTemplate_AdvSniper('AdvSniperP2'));
	    Templates.AddItem(CreateTemplate_AdvSniper('AdvSniperP3'));
    }	
	
	return Templates;
}

static function X2CharacterTemplate CreateTemplate_AdvCaptain(name TemplateName)
{
	local X2CharacterTemplate 	CharTemplate;
	local LootReference 		BaseLoot, TimedLoot, VultureLoot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.strBehaviorTree = "AdventPsiOfficer::CharacterRoot";
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_Captains.ARC_GameUnit_AdvCaptainPsi_M");
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_Captains.ARC_GameUnit_AdvCaptainPsi_F");

	switch(TemplateName)
	{
		case 'AdvCaptainP1':
			CharTemplate.DefaultLoadout='AdvCaptainP1_Loadout';
			BaseLoot.LootTableName='AdvCaptainM1_BaseLoot';
			TimedLoot.LootTableName = 'AdvCaptainP1_TimedLoot';
			VultureLoot.LootTableName = 'AdvCaptainM1_VultureLoot';
			break;
		case 'AdvCaptainP2':
			CharTemplate.DefaultLoadout='AdvCaptainP2_Loadout';
			BaseLoot.LootTableName='AdvCaptainM2_BaseLoot';
			TimedLoot.LootTableName = 'AdvCaptainP2_TimedLoot';
			VultureLoot.LootTableName = 'AdvCaptainM2_VultureLoot';
			break;
		case 'AdvCaptainP3':
			CharTemplate.DefaultLoadout='AdvCaptainP3_Loadout';
			BaseLoot.LootTableName='AdvCaptainM3_BaseLoot';
			TimedLoot.LootTableName = 'AdvCaptainP3_TimedLoot';
			VultureLoot.LootTableName = 'AdvCaptainM3_VultureLoot';
			break;
	}

	SetLootTables(CharTemplate, BaseLoot, TimedLoot, VultureLoot);
	
	switch (TemplateName)
	{
		case 'AdvCaptainP3':
			CharTemplate.Abilities.AddItem('Spectrum_DeepPockets');
			CharTemplate.Abilities.AddItem('Squadsight');
		case 'AdvCaptainP2':
			CharTemplate.Abilities.AddItem('SpectrumDeadAura');
		case 'AdvCaptainP1':			
	        CharTemplate.Abilities.AddItem('KillSiredZombies');
			break;
	}

	return AdvCaptain_Default(CharTemplate);
}

static function X2CharacterTemplate CreateTemplate_AdvTrooper(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;
	local LootReference BaseLoot, TimedLoot, VultureLoot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.strBehaviorTree = "AdventPsiTrooper::CharacterRoot";
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_Troopers.ARC_GameUnit_AdvTrooperPsi_M");
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_Troopers.ARC_GameUnit_AdvTrooperPsi_F");

	switch(TemplateName)
	{
		case 'AdvTrooperP1':
			CharTemplate.DefaultLoadout='AdvTrooperP1_Loadout';
			BaseLoot.LootTableName='AdvTrooperM1_BaseLoot';
			TimedLoot.LootTableName = 'AdvTrooperP1_TimedLoot';
			VultureLoot.LootTableName = 'AdvTrooperM1_VultureLoot';
			break;
		case 'AdvTrooperP2':
			CharTemplate.DefaultLoadout='AdvTrooperP2_Loadout';
			BaseLoot.LootTableName='AdvTrooperM2_BaseLoot';
			TimedLoot.LootTableName = 'AdvTrooperP2_TimedLoot';
			VultureLoot.LootTableName = 'AdvTrooperM2_VultureLoot';
			break;
		case 'AdvTrooperP3':
			CharTemplate.DefaultLoadout='AdvTrooperP3_Loadout';
			BaseLoot.LootTableName='AdvTrooperM3_BaseLoot';
			TimedLoot.LootTableName = 'AdvTrooperP3_TimedLoot';
			VultureLoot.LootTableName = 'AdvTrooperM3_VultureLoot';
			break;
	}

	SetLootTables(CharTemplate, BaseLoot, TimedLoot, VultureLoot);
	
	switch (TemplateName)
	{
		case 'AdvTrooperP3':
		case 'AdvTrooperP2':
			CharTemplate.Abilities.AddItem('Undying');
		case 'AdvTrooperP1':
			break;
	}

	return AdvTrooper_Default(CharTemplate);
}

static function X2CharacterTemplate CreateTemplate_AdvSniper(name TemplateName)
{
	local X2CharacterTemplate CharTemplate;
	local LootReference BaseLoot, TimedLoot, VultureLoot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, TemplateName);
	CharTemplate.CharacterGroupName = 'AdventStunLancer';	
	CharTemplate.strBehaviorTree = "AdventPsiSniper::CharacterRoot";
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_Lancers.ARC_GameUnit_AdvScoutPsi_M");
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_Lancers.ARC_GameUnit_AdvScoutPsi_F");
    CharTemplate.RevealMatineePrefix = "CIN_Advent_Trooper";
	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";	

	switch(TemplateName)
	{
		case 'AdvSniperP2':
			CharTemplate.DefaultLoadout='AdvSniperP2_Loadout';
			BaseLoot.LootTableName='AdvTrooperM2_BaseLoot';
			TimedLoot.LootTableName = 'AdvSniperM2_TimedLoot';
			VultureLoot.LootTableName = 'AdvTrooperM2_VultureLoot';
			break;
		case 'AdvSniperP3':
			CharTemplate.DefaultLoadout='AdvSniperP3_Loadout';
			BaseLoot.LootTableName='AdvTrooperM3_BaseLoot';
			TimedLoot.LootTableName = 'AdvSniperM3_TimedLoot';
			VultureLoot.LootTableName = 'AdvTrooperM3_VultureLoot';
			break;
	}

	SetLootTables(CharTemplate, BaseLoot, TimedLoot, VultureLoot);
    SetCommonTraits_Advent(CharTemplate);
	
	switch (TemplateName)
	{
		case 'AdvSniperP3':
			CharTemplate.Abilities.AddItem('Spectrum_PsiPanicShot');
		case 'AdvSniperP2':
			CharTemplate.Abilities.AddItem('Spectrum_PsiDisableShot');
	        CharTemplate.Abilities.AddItem('HunkerDown');
			CharTemplate.Abilities.AddItem('DarkEventAbility_LightningReflexes');
			break;
	}

	return CharTemplate;
}