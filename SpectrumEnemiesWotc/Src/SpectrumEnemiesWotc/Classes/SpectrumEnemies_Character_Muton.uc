class SpectrumEnemies_Character_Muton extends SpectrumEnemies_Character config(GameData_CharacterStats);

var config(SpectrumEnemies) bool        EnableMutons;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

    return Templates;   // Unfinished
  
    if (default.EnableMutons)
    {
        //Prometheus Commander
        Templates.AddItem(CreateTemplate_MutonDesolatorM3());

        //Grunt
        Templates.AddItem(CreateTemplate_MutonGruntM4());
        //Reaper
        Templates.AddItem(CreateTemplate_MutonReaperM4());
        //Desolator
        Templates.AddItem(CreateTemplate_MutonDesolatorM4());
        //Warlord
        Templates.AddItem(CreateTemplate_MutonWarlordM4());
    }

	return Templates;
}

static function X2CharacterTemplate CreateTemplate_MutonDesolatorM3()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'MutonDesolatorM3');
	CharTemplate.CharacterGroupName = 'Muton';
	CharTemplate.DefaultLoadout='MutonDesolatorM4_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strBehaviorTree = "Muton::CharacterRoot";
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_Muton.Reaper.ARC_GameUnit_MutonReaper");
	Loot.ForceLevel=0;
	Loot.LootTableName='Muton_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'Muton_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'Muton_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Muton");
	CharTemplate.strTargetingMatineePrefix = "CIN_Muton_FF_StartPos";

	CharTemplate.UnitSize = 1;
	// Traversal Rules
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = true;
	CharTemplate.bCanUse_eTraversal_DropDown = true;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bAppearanceDefinesPawn = false;    
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = true;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bAllowRushCam = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.bAllowSpawnFromATT = false;

	CharTemplate.Abilities.AddItem('AdventColonel');
	CharTemplate.Abilities.AddItem('AlienPoweredArmor');
	CharTemplate.Abilities.AddItem('MutonHealth');
	CharTemplate.Abilities.AddItem('CounterattackPreparation');
	CharTemplate.Abilities.AddItem('CounterattackDescription');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_Muton');

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_MutonGruntM4()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'MutonGruntM4');
	CharTemplate.CharacterGroupName = 'Muton';
	CharTemplate.DefaultLoadout='MutonGruntM4_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strBehaviorTree = "Muton::CharacterRoot";
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_Muton.Grunt.ARC_GameUnit_MutonGrunt");
	Loot.ForceLevel=0;
	Loot.LootTableName='Muton_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'Muton_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'Muton_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Muton");
	CharTemplate.strTargetingMatineePrefix = "CIN_Muton_FF_StartPos";

	CharTemplate.UnitSize = 1;
	// Traversal Rules
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = true;
	CharTemplate.bCanUse_eTraversal_DropDown = true;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bAppearanceDefinesPawn = false;    
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = true;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bAllowRushCam = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.bAllowSpawnFromATT = false;

	CharTemplate.Abilities.AddItem('AdventCaptain');
	CharTemplate.Abilities.AddItem('AlienPoweredArmor');
	CharTemplate.Abilities.AddItem('MutonHealth');
	CharTemplate.Abilities.AddItem('CounterattackPreparation');
	CharTemplate.Abilities.AddItem('CounterattackDescription');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_Muton');

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_MutonReaperM4()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'MutonReaperM4');
	CharTemplate.CharacterGroupName = 'Muton';
	CharTemplate.DefaultLoadout='MutonReaperM4_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strBehaviorTree = "Muton::CharacterRoot";
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_Muton.Reaper.ARC_GameUnit_MutonReaper");
	Loot.ForceLevel=0;
	Loot.LootTableName='Muton_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'Muton_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'Muton_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Muton");
	CharTemplate.strTargetingMatineePrefix = "CIN_Muton_FF_StartPos";

	CharTemplate.UnitSize = 1;
	// Traversal Rules
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = true;
	CharTemplate.bCanUse_eTraversal_DropDown = true;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bAppearanceDefinesPawn = false;    
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = true;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bAllowRushCam = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.bAllowSpawnFromATT = false;

	CharTemplate.Abilities.AddItem('AdventColonel');
	CharTemplate.Abilities.AddItem('AlienPoweredArmor');
	CharTemplate.Abilities.AddItem('MutonHealth');
	CharTemplate.Abilities.AddItem('CounterattackPreparation');
	CharTemplate.Abilities.AddItem('CounterattackDescription');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_Muton');

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_MutonDesolatorM4()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'MutonDesolatorM4');
	CharTemplate.CharacterGroupName = 'Muton';
	CharTemplate.DefaultLoadout='MutonDesolatorM4_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strBehaviorTree = "Muton::CharacterRoot";
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_Muton.Reaper.ARC_GameUnit_MutonReaper");
	Loot.ForceLevel=0;
	Loot.LootTableName='Muton_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'Muton_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'Muton_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Muton");
	CharTemplate.strTargetingMatineePrefix = "CIN_Muton_FF_StartPos";

	CharTemplate.UnitSize = 1;
	// Traversal Rules
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = true;
	CharTemplate.bCanUse_eTraversal_DropDown = true;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bAppearanceDefinesPawn = false;    
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = true;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bAllowRushCam = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.bAllowSpawnFromATT = false;

	CharTemplate.Abilities.AddItem('AdventColonel');
	CharTemplate.Abilities.AddItem('AlienPoweredArmor');
	CharTemplate.Abilities.AddItem('MutonHealth');
	CharTemplate.Abilities.AddItem('CounterattackPreparation');
	CharTemplate.Abilities.AddItem('CounterattackDescription');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_Muton');

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_MutonWarlordM4()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'MutonWarlordM4');
	CharTemplate.CharacterGroupName = 'Muton';
	CharTemplate.DefaultLoadout='MutonWarlordM4_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strBehaviorTree = "Muton::CharacterRoot";
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_Muton.Reaper.ARC_GameUnit_MutonWarlord");
	Loot.ForceLevel=0;
	Loot.LootTableName='Muton_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'Muton_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'Muton_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Muton");
	CharTemplate.strTargetingMatineePrefix = "CIN_Muton_FF_StartPos";

	CharTemplate.UnitSize = 1;
	// Traversal Rules
	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = true;
	CharTemplate.bCanUse_eTraversal_DropDown = true;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = false;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bAppearanceDefinesPawn = false;    
	CharTemplate.bCanTakeCover = false;

	CharTemplate.bIsAlien = true;
	CharTemplate.bIsAdvent = false;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;
	CharTemplate.bAllowRushCam = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;

	CharTemplate.bAllowSpawnFromATT = false;

	CharTemplate.Abilities.AddItem('AdventOverlord');
	CharTemplate.Abilities.AddItem('AlienHeavyPoweredArmor');
	CharTemplate.Abilities.AddItem('MutonHealth');
	CharTemplate.Abilities.AddItem('JuggernautPerk');
	CharTemplate.Abilities.AddItem('CounterattackPreparation');
	CharTemplate.Abilities.AddItem('CounterattackDescription');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_Muton');

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}