class Weapons_New extends X2Item config(AegisRifle);

var config  WeaponDamageValue  ADVCAPTAINM1_WPN_BASEDAMAGE;
var config  WeaponDamageValue  ADVCAPTAINM2_WPN_BASEDAMAGE;
var config  WeaponDamageValue  ADVCAPTAINM3_WPN_BASEDAMAGE;

var config  int ADVCAPTAINM1_IDEALRANGE;
var config  int ADVCAPTAINM2_IDEALRANGE;
var config  int ADVCAPTAINM3_IDEALRANGE;

var config  int ASSAULTRIFLE_MAGNETIC_AIM;
var config  int ASSAULTRIFLE_MAGNETIC_CRITCHANCE;
var config  int ASSAULTRIFLE_MAGNETIC_ICLIPSIZE;
var config  int ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
var config  int ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
var config  int ASSAULTRIFLE_MAGNETIC_IPOINTS;

var config array<int> FLAT_CONVENTIONAL_RANGE;


static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Weapons;

	Weapons.AddItem(AegisRifleM1());
	Weapons.AddItem(AegisRifleM2());
	Weapons.AddItem(AegisRifleM3());
	
	return Weapons;
}

static function X2DataTemplate AegisRifleM1()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AegisRifle_M1');
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.AdventAssaultRifle";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.RangeAccuracy = default.FLAT_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.ADVCAPTAINM1_WPN_BASEDAMAGE;
	Template.iClipSize = default.ASSAULTRIFLE_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.ADVCAPTAINM1_IDEALRANGE;
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_AssaultRifle_MG.WP_AssaultRifle_MG_Advent";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	Template.DamageTypeTemplateName = 'Projectile_Conventional';

	return Template;
}

static function X2DataTemplate AegisRifleM2()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AegisRifle_M2');
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.AdventAssaultRifle";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.RangeAccuracy = default.FLAT_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.ADVCAPTAINM2_WPN_BASEDAMAGE;
	Template.iClipSize = default.ASSAULTRIFLE_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.ADVCAPTAINM2_IDEALRANGE;
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_AssaultRifle_MG.WP_AssaultRifle_MG_Advent";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	Template.DamageTypeTemplateName = 'Projectile_Conventional';

	return Template;
}

static function X2DataTemplate AegisRifleM3()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AegisRifle_M3');
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.AdventAssaultRifle";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.RangeAccuracy = default.FLAT_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.ADVCAPTAINM3_WPN_BASEDAMAGE;
	Template.iClipSize = default.ASSAULTRIFLE_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.ADVCAPTAINM3_IDEALRANGE;
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_AssaultRifle_MG.WP_AssaultRifle_MG_Advent";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	Template.DamageTypeTemplateName = 'Projectile_Conventional';

	return Template;
}

defaultproperties
{
bShouldCreateDifficultyVariants = true
}
