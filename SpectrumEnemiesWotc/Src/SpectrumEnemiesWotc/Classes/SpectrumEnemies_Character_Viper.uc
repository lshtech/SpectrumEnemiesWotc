class SpectrumEnemies_Character_Viper extends SpectrumEnemies_Character config(GameData_CharacterStats);

var config(SpectrumEnemies) bool        EnableVipers;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
  
    if (default.EnableVipers)
    {
		Templates.AddItem(CreateTemplate_ViperHuntressM2());
        Templates.AddItem(CreateTemplate_ViperHuntressM3());
        Templates.AddItem(CreateTemplate_ViperHuntressM4());        
    }

	return Templates;
}

static function X2CharacterTemplate CreateTemplate_ViperHuntressM2()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'ViperHuntressM2');
	CharTemplate.CharacterGroupName = 'Viper';
	CharTemplate.DefaultLoadout='ViperHuntressM2_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strBehaviorTree = "Viper::CharacterRoot";
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_Viper.ARC_GameUnit_ViperPandora");
	Loot.ForceLevel=0;
	Loot.LootTableName='Viper_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'Viper_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'Viper_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	CharTemplate.strMatineePackages.AddItem("CIN_Viper");
	CharTemplate.strMatineePackages.AddItem("CIN_AdventMEC");
	CharTemplate.strTargetingMatineePrefix = "CIN_AdventMEC_FF_StartPos";

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

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.AcquiredPhobiaTemplate = 'FearOfVipers';

	CharTemplate.ImmuneTypes.AddItem('Poison');

	CharTemplate.bAllowSpawnFromATT = false;

	CharTemplate.Abilities.AddItem('ShadowStep');

	CharTemplate.Abilities.AddItem('Bind');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Tygan_AlienSightings_Viper');
	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_Viper');

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_ViperHuntressM3()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'ViperHuntressM3');
	CharTemplate.CharacterGroupName = 'Viper';
	CharTemplate.DefaultLoadout='ViperHuntressM3_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strBehaviorTree = "Viper::CharacterRoot";
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_Viper.ARC_GameUnit_ViperPandora");
	Loot.ForceLevel=0;
	Loot.LootTableName='Viper_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'Viper_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'Viper_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	
	CharTemplate.strMatineePackages.AddItem("CIN_Viper");
	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.strMatineePackages.AddItem("CIN_AdventMEC");
	CharTemplate.strTargetingMatineePrefix = "CIN_AdventMEC_FF_StartPos";

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

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.AcquiredPhobiaTemplate = 'FearOfVipers';

	CharTemplate.ImmuneTypes.AddItem('Poison');

	CharTemplate.bAllowSpawnFromATT = false;

	CharTemplate.Abilities.AddItem('ShadowStep');

	CharTemplate.Abilities.AddItem('Bind');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Tygan_AlienSightings_Viper');
	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_Viper');

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}

static function X2CharacterTemplate CreateTemplate_ViperHuntressM4()
{
	local X2CharacterTemplate CharTemplate;
	local LootReference Loot;

	`CREATE_X2CHARACTER_TEMPLATE(CharTemplate, 'ViperHuntressM4');
	CharTemplate.CharacterGroupName = 'Viper';
	CharTemplate.DefaultLoadout='ViperHuntressM4_Loadout';
	CharTemplate.BehaviorClass=class'XGAIBehavior';
	CharTemplate.strBehaviorTree = "Viper::CharacterRoot";
	CharTemplate.strPawnArchetypes.AddItem("Spectrum_Viper.ARC_GameUnit_ViperPandora");
	Loot.ForceLevel=0;
	Loot.LootTableName='Viper_BaseLoot';
	CharTemplate.Loot.LootReferences.AddItem(Loot);

	// Timed Loot
	Loot.ForceLevel = 0;
	Loot.LootTableName = 'Viper_TimedLoot';
	CharTemplate.TimedLoot.LootReferences.AddItem(Loot);
	Loot.LootTableName = 'Viper_VultureLoot';
	CharTemplate.VultureLoot.LootReferences.AddItem(Loot);

	
	CharTemplate.strMatineePackages.AddItem("CIN_Viper");
	CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.strMatineePackages.AddItem("CIN_AdventMEC");
	CharTemplate.strTargetingMatineePrefix = "CIN_AdventMEC_FF_StartPos";

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

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;
	CharTemplate.AcquiredPhobiaTemplate = 'FearOfVipers';

	CharTemplate.ImmuneTypes.AddItem('Poison');

	CharTemplate.bAllowSpawnFromATT = false;

	CharTemplate.Abilities.AddItem('ShadowStep');
	
	CharTemplate.Abilities.AddItem('Bind');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Tygan_AlienSightings_Viper');
	CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.T_Central_AlienSightings_Viper');

	CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Alien;

	return CharTemplate;
}
