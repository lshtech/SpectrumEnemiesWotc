class SpectrumEnemies_Character extends X2Character config (SpectrumEnemies);

var config bool 	UseAdventReinforcements;
var config name		AdventReinforcementsAbility;

static function X2CharacterTemplate AdvCaptain_Default(X2CharacterTemplate CharTemplate)
{
	CharTemplate.CharacterGroupName = 'AdventCaptain';
	CharTemplate.RevealMatineePrefix = "CIN_Advent_Captain";
	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";
	CharTemplate.SightedEvents.AddItem('AdventCaptainSighted');

	CharTemplate.Abilities.AddItem('Spectrum_AdventCaptain_CallReinforcements');
	CharTemplate.Abilities.AddItem('MarkTarget');
	CharTemplate.Abilities.AddItem('DarkEventAbility_ReturnFire');

	return SetCommonTraits_Advent(CharTemplate);
}

static function X2CharacterTemplate AdvTrooper_Default(X2CharacterTemplate CharTemplate)
{	
	CharTemplate.CharacterGroupName = 'AdventTrooper';	
    CharTemplate.RevealMatineePrefix = "CIN_Advent_Trooper";
	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";	

	CharTemplate.Abilities.AddItem('DarkEventAbility_LightningReflexes');

	return SetCommonTraits_Advent(CharTemplate);
}

static function X2CharacterTemplate AdvHeavy_Default(X2CharacterTemplate CharTemplate)
{	
	CharTemplate.CharacterGroupName = 'AdventShieldBearer';		
    CharTemplate.RevealMatineePrefix = "CIN_Advent_ShieldBearer";
	CharTemplate.strHackIconImage = "UILibrary_Common.TargetIcons.Hack_captain_icon";	
	return SetCommonTraits_Advent(CharTemplate);
}

static function X2CharacterTemplate SetLootTables(X2CharacterTemplate CharTemplate, LootReference BaseLoot, LootReference TimedLoot, LootReference VultureLoot)
{
    BaseLoot.ForceLevel = 0;
	CharTemplate.Loot.LootReferences.AddItem(BaseLoot);
	TimedLoot.ForceLevel = 0;
	CharTemplate.TimedLoot.LootReferences.AddItem(TimedLoot);	
	VultureLoot.ForceLevel = 0;	
	CharTemplate.VultureLoot.LootReferences.AddItem(VultureLoot);
    
    return CharTemplate;
}

static function X2CharacterTemplate SetCommonTraits_Advent(X2CharacterTemplate CharTemplate)
{
    CharTemplate.BehaviorClass=class'XGAIBehavior';

    CharTemplate.strMatineePackages.AddItem("CIN_Advent");
	CharTemplate.GetRevealMatineePrefixFn = GetAdventMatineePrefix;

	CharTemplate.UnitSize = 1;

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
	CharTemplate.bSetGenderAlways = true;
	CharTemplate.bCanTakeCover = true;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = false;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = true;	

	CharTemplate.AddTemplateAvailablility(CharTemplate.BITFIELD_GAMEAREA_Multiplayer); // Allow in MP!
	CharTemplate.MPPointValue = CharTemplate.XpKillscore * 10;

    CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;

	CharTemplate.Abilities.AddItem('AdventStilettoRounds');	
	CharTemplate.Abilities.AddItem('DarkEventAbility_SealedArmor');
	CharTemplate.Abilities.AddItem('DarkEventAbility_UndyingLoyalty');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Counterattack');
	CharTemplate.Abilities.AddItem('HunkerDown');
	CharTemplate.Abilities.AddItem('Suppress');
    
    return CharTemplate;
}

simulated function string GetAdventMatineePrefix(XComGameState_Unit UnitState)
{
	if(UnitState.kAppearance.iGender == eGender_Male)
	{
		return UnitState.GetMyTemplate().RevealMatineePrefix $ "_Male";
	}
	else
	{
		return UnitState.GetMyTemplate().RevealMatineePrefix $ "_Female";
	}
}

static function X2CharacterTemplate SetCommonTraits_MEC(X2CharacterTemplate CharTemplate)
{
    CharTemplate.BehaviorClass=class'XGAIBehavior';

    CharTemplate.strMatineePackages.AddItem("CIN_AdventMEC");
	CharTemplate.strTargetingMatineePrefix = "CIN_AdventMEC_FF_StartPos";

	CharTemplate.UnitSize = 1;

	CharTemplate.bCanUse_eTraversal_Normal = true;
	CharTemplate.bCanUse_eTraversal_ClimbOver = true;
	CharTemplate.bCanUse_eTraversal_ClimbOnto = true;
	CharTemplate.bCanUse_eTraversal_ClimbLadder = false;
	CharTemplate.bCanUse_eTraversal_DropDown = true;
	CharTemplate.bCanUse_eTraversal_Grapple = false;
	CharTemplate.bCanUse_eTraversal_Landing = true;
	CharTemplate.bCanUse_eTraversal_BreakWindow = true;
	CharTemplate.bCanUse_eTraversal_KickDoor = true;
	CharTemplate.bCanUse_eTraversal_JumpUp = true;
	CharTemplate.bCanUse_eTraversal_WallClimb = false;
	CharTemplate.bCanUse_eTraversal_BreakWall = false;
	CharTemplate.bAppearanceDefinesPawn = false;   
	CharTemplate.bCanTakeCover = false;

	CharTemplate.bIsAlien = false;
	CharTemplate.bIsAdvent = true;
	CharTemplate.bIsCivilian = false;
	CharTemplate.bIsPsionic = false;
	CharTemplate.bIsRobotic = true;
	CharTemplate.bIsSoldier = false;

	CharTemplate.bCanBeTerrorist = false;
	CharTemplate.bCanBeCriticallyWounded = false;
	CharTemplate.bIsAfraidOfFire = false;
	CharTemplate.bFacesAwayFromPod = true;	

	CharTemplate.strScamperBT = "ScamperRoot_Flanker";

    CharTemplate.strTargetIconImage = class'UIUtilities_Image'.const.TargetIcon_Advent;
    CharTemplate.SightedNarrativeMoments.AddItem(XComNarrativeMoment'X2NarrativeMoments.TACTICAL.AlienSitings.Enemy_Sighted_ADVENTMec');

	CharTemplate.AcquiredPhobiaTemplate = 'FearOfMecs';

	CharTemplate.Abilities.AddItem('RobotImmunities');
	CharTemplate.Abilities.AddItem('DarkEventAbility_Barrier');

    return CharTemplate;
}

defaultproperties
{
    bShouldCreateDifficultyVariants = true
}