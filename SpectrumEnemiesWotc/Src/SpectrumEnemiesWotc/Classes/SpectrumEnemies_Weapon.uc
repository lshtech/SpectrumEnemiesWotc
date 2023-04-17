class SpectrumEnemies_Weapon extends X2Item config(SpectrumEnemies);

//Weapon Damage Arrays
//Advent
var config WeaponDamageValue ASSAULTRIFLE_ADVM1_BASEDAMAGE;
var config WeaponDamageValue ASSAULTRIFLE_ADVM2_BASEDAMAGE;
var config WeaponDamageValue ASSAULTRIFLE_ADVM3_BASEDAMAGE;
var config WeaponDamageValue SHOTGUN_ADVM1_BASEDAMAGE;
var config WeaponDamageValue SHOTGUN_ADVM2_BASEDAMAGE;
var config WeaponDamageValue SHOTGUN_ADVM3_BASEDAMAGE;
var config WeaponDamageValue SHREDDER_ADVM1_BASEDAMAGE;
var config WeaponDamageValue SHREDDER_ADVM2_BASEDAMAGE;
var config WeaponDamageValue SHREDDER_ADVM3_BASEDAMAGE;
var config WeaponDamageValue LMG_ADVM1_BASEDAMAGE;
var config WeaponDamageValue LMG_ADVM2_BASEDAMAGE;
var config WeaponDamageValue LMG_ADVM3_BASEDAMAGE;
var config WeaponDamageValue SNIPERRIFLE_ADVM1_BASEDAMAGE;
var config WeaponDamageValue SNIPERRIFLE_ADVM2_BASEDAMAGE;
var config WeaponDamageValue SNIPERRIFLE_ADVM3_BASEDAMAGE;

//Heavy
var config WeaponDamageValue FLAMETHROWER_BASEDAMAGE;
var config WeaponDamageValue SHREDDERGUN_BASEDAMAGE;

//Range Arrays
var config array<int> SHORT_RANGE;
var config array<int> MEDIUM_RANGE;
var config array<int> LONG_RANGE;
var config array<int> FLAT_RANGE;

//Ideal Ranges
var config int SHORT_IDEALRANGE;
var config int MEDIUM_IDEALRANGE;
var config int LONG_IDEALRANGE;
var config int FLAT_IDEALRANGE;

//Melee
var config int GENERIC_MELEE_ACCURACY;

//Flamethrower Variables
var config int FLAMETHROWER_ISOUNDRANGE;
var config int FLAMETHROWER_IENVIRONMENTDAMAGE;
var config int FLAMETHROWER_IPOINTS;
var config int FLAMETHROWER_ICLIPSIZE;
var config int FLAMETHROWER_RANGE;
var config int FLAMETHROWER_RADIUS;

//ShredderGun Variables
var config int SHREDDERGUN_ISOUNDRANGE;
var config int SHREDDERGUN_IENVIRONMENTDAMAGE;
var config int SHREDDERGUN_IPOINTS;
var config int SHREDDERGUN_ICLIPSIZE;
var config int SHREDDERGUN_RANGE;
var config int SHREDDERGUN_RADIUS;

//Advent Weapon Variables
var config int ASSAULTRIFLE_ADV_AIM;
var config int ASSAULTRIFLE_ADV_CRITCHANCE;
var config int ASSAULTRIFLE_ADV_ICLIPSIZE;
var config int ASSAULTRIFLE_ADV_ISOUNDRANGE;
var config int ASSAULTRIFLE_ADV_IENVIRONMENTDAMAGE;
var config int ASSAULTRIFLE_ADV_IPOINTS;

var config int SHOTGUN_ADV_AIM;
var config int SHOTGUN_ADV_CRITCHANCE;
var config int SHOTGUN_ADV_ICLIPSIZE;
var config int SHOTGUN_ADV_ISOUNDRANGE;
var config int SHOTGUN_ADV_IENVIRONMENTDAMAGE;
var config int SHOTGUN_ADV_IPOINTS;

var config int LMG_ADV_AIM;
var config int LMG_ADV_CRITCHANCE;
var config int LMG_ADV_ICLIPSIZE;
var config int LMG_ADV_ISOUNDRANGE;
var config int LMG_ADV_IENVIRONMENTDAMAGE;
var config int LMG_ADV_IPOINTS;

var config int SNIPERRIFLE_ADV_AIM;
var config int SNIPERRIFLE_ADV_CRITCHANCE;
var config int SNIPERRIFLE_ADV_ICLIPSIZE;
var config int SNIPERRIFLE_ADV_ISOUNDRANGE;
var config int SNIPERRIFLE_ADV_IENVIRONMENTDAMAGE;
var config int SNIPERRIFLE_ADV_IPOINTS;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Weapons;
//Advent Shredders
	Weapons.AddItem(CreateTemplate_Shredder_AdventM1());
	Weapons.AddItem(CreateTemplate_Shredder_AdventM2());
	Weapons.AddItem(CreateTemplate_Shredder_AdventM3());
//Advent Magnetics
	Weapons.AddItem(CreateTemplate_SniperRifle_AdventM1());
	Weapons.AddItem(CreateTemplate_SniperRifle_AdventM2());
	Weapons.AddItem(CreateTemplate_SniperRifle_AdventM3());
	Weapons.AddItem(CreateTemplate_Cannon_AdventM1());
	Weapons.AddItem(CreateTemplate_Cannon_AdventM2());
	Weapons.AddItem(CreateTemplate_Cannon_AdventM3());
	Weapons.AddItem(CreateTemplate_Shotgun_AdventM1());
	Weapons.AddItem(CreateTemplate_Shotgun_AdventM2());
	Weapons.AddItem(CreateTemplate_Shotgun_AdventM3());
	Weapons.AddItem(CreateTemplate_Shredder_AdventM1());
	Weapons.AddItem(CreateTemplate_Shredder_AdventM2());
	Weapons.AddItem(CreateTemplate_Shredder_AdventM3());

//Advent Heavies
	Weapons.AddItem(CreateTemplate_Flamethrower_Advent());
	Weapons.AddItem(CreateTemplate_ShredderGun_Advent());
//Alien Weapons	

		return Weapons;
}


//=====================
//	Advent Magnetics
//=====================

// Sniper Rifles

static function X2DataTemplate CreateTemplate_SniperRifle_AdventM1()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Sniperrifle_AdvM1');
	Template.WeaponPanelImage = "_MagneticSniperRifle";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'sniper_rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.UI_MagSniper.MagSniper_Base";
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 3;

	Template.BaseDamage = default.SNIPERRIFLE_ADVM1_BASEDAMAGE;
	Template.RangeAccuracy = default.LONG_RANGE;
	Template.Aim = default.SNIPERRIFLE_ADV_AIM;
	Template.CritChance = default.SNIPERRIFLE_ADV_CRITCHANCE;
	Template.iClipSize = default.SNIPERRIFLE_ADV_ICLIPSIZE;
	Template.iSoundRange = default.SNIPERRIFLE_ADV_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SNIPERRIFLE_ADV_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.LONG_IDEALRANGE;

	Template.NumUpgradeSlots = 2;

	Template.iTypicalActionCost = 2;
	
	Template.bIsLargeWeapon = true;
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('SniperStandardFire');
	Template.Abilities.AddItem('SniperRifleOverwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	
	Template.GameArchetype = "Spectrum_Weapons.WP_SniperRifle_Adv";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';

	return Template;
}

static function X2DataTemplate CreateTemplate_SniperRifle_AdventM2()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Sniperrifle_AdvM2');
	Template.WeaponPanelImage = "_MagneticSniperRifle";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'sniper_rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.UI_MagSniper.MagSniper_Base";
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 3;

	Template.BaseDamage = default.SNIPERRIFLE_ADVM2_BASEDAMAGE;
	Template.RangeAccuracy = default.LONG_RANGE;
	Template.Aim = default.SNIPERRIFLE_ADV_AIM;
	Template.CritChance = default.SNIPERRIFLE_ADV_CRITCHANCE;
	Template.iClipSize = default.SNIPERRIFLE_ADV_ICLIPSIZE;
	Template.iSoundRange = default.SNIPERRIFLE_ADV_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SNIPERRIFLE_ADV_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.LONG_IDEALRANGE;
	Template.NumUpgradeSlots = 2;
	Template.iTypicalActionCost = 2;

	Template.bIsLargeWeapon = true;
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('SniperStandardFire');
	Template.Abilities.AddItem('SniperRifleOverwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	
	Template.GameArchetype = "Spectrum_Weapons.WP_SniperRifle_Adv";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';

	return Template;
}

static function X2DataTemplate CreateTemplate_SniperRifle_AdventM3()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Sniperrifle_AdvM3');
	Template.WeaponPanelImage = "_MagneticSniperRifle";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'sniper_rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.UI_MagSniper.MagSniper_Base";
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 3;

	Template.BaseDamage = default.SNIPERRIFLE_ADVM3_BASEDAMAGE;
	Template.RangeAccuracy = default.LONG_RANGE;
	Template.Aim = default.SNIPERRIFLE_ADV_AIM;
	Template.CritChance = default.SNIPERRIFLE_ADV_CRITCHANCE;
	Template.iClipSize = default.SNIPERRIFLE_ADV_ICLIPSIZE;
	Template.iSoundRange = default.SNIPERRIFLE_ADV_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SNIPERRIFLE_ADV_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.LONG_IDEALRANGE;
	Template.NumUpgradeSlots = 2;
	Template.iTypicalActionCost = 2;

	Template.bIsLargeWeapon = true;
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('SniperStandardFire');
	Template.Abilities.AddItem('SniperRifleOverwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	
	Template.GameArchetype = "Spectrum_Weapons.WP_SniperRifle_Adv";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';

	return Template;
}

//Cannons

static function X2DataTemplate CreateTemplate_Cannon_AdventM1()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Cannon_AdvM1');
	Template.WeaponPanelImage = "_MagneticCannon";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'cannon';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.UI_MagCannon.MagCannon_Base";
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 3;

	Template.BaseDamage = default.LMG_ADVM1_BASEDAMAGE;
	Template.RangeAccuracy = default.MEDIUM_RANGE;
	Template.Aim = default.LMG_ADV_AIM;
	Template.CritChance = default.LMG_ADV_CRITCHANCE;
	Template.iClipSize = default.LMG_ADV_ICLIPSIZE;
	Template.iSoundRange = default.LMG_ADV_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.LMG_ADV_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.MEDIUM_IDEALRANGE;
	Template.NumUpgradeSlots = 2;
	Template.bIsLargeWeapon = true;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Suppression');
	
	Template.GameArchetype = "Spectrum_Weapons.WP_Cannon_Adv";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';

	return Template;
}

static function X2DataTemplate CreateTemplate_Cannon_AdventM2()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Cannon_AdvM2');
	Template.WeaponPanelImage = "_MagneticCannon";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'cannon';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.UI_MagCannon.MagCannon_Base";
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 3;

	Template.BaseDamage = default.LMG_ADVM2_BASEDAMAGE;
	Template.RangeAccuracy = default.MEDIUM_RANGE;
	Template.Aim = default.LMG_ADV_AIM;
	Template.CritChance = default.LMG_ADV_CRITCHANCE;
	Template.iClipSize = default.LMG_ADV_ICLIPSIZE;
	Template.iSoundRange = default.LMG_ADV_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.LMG_ADV_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.MEDIUM_IDEALRANGE;
	Template.NumUpgradeSlots = 2;
	Template.bIsLargeWeapon = true;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Suppression');
	
	Template.GameArchetype = "Spectrum_Weapons.WP_Cannon_Adv";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';

	return Template;
}

static function X2DataTemplate CreateTemplate_Cannon_AdventM3()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Cannon_AdvM3');
	Template.WeaponPanelImage = "_MagneticCannon";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'cannon';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.UI_MagCannon.MagCannon_Base";
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 3;

	Template.BaseDamage = default.LMG_ADVM3_BASEDAMAGE;
	Template.RangeAccuracy = default.MEDIUM_RANGE;
	Template.Aim = default.LMG_ADV_AIM;
	Template.CritChance = default.LMG_ADV_CRITCHANCE;
	Template.iClipSize = default.LMG_ADV_ICLIPSIZE;
	Template.iSoundRange = default.LMG_ADV_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.LMG_ADV_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.MEDIUM_IDEALRANGE;
	Template.NumUpgradeSlots = 2;
	Template.bIsLargeWeapon = true;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Suppression');
	
	Template.GameArchetype = "Spectrum_Weapons.WP_Cannon_Adv";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';

	return Template;
}

//Shotguns

static function X2DataTemplate CreateTemplate_Shotgun_AdventM1()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Shotgun_AdvM1');
	Template.WeaponPanelImage = "_MagneticShotgun";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'shotgun';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.UI_MagShotgun.MagShotgun_Base";
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 3;

	Template.BaseDamage = default.SHOTGUN_ADVM1_BASEDAMAGE;
	Template.RangeAccuracy = default.SHORT_RANGE;
	Template.Aim = default.SHOTGUN_ADV_AIM;
	Template.CritChance = default.SHOTGUN_ADV_CRITCHANCE;
	Template.iClipSize = default.SHOTGUN_ADV_ICLIPSIZE;
	Template.iSoundRange = default.SHOTGUN_ADV_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SHOTGUN_ADV_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.SHORT_IDEALRANGE;
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	
	Template.GameArchetype = "Spectrum_Weapons.WP_Shotgun_Adv";

	Template.iPhysicsImpulse = 5;

	Template.fKnockbackDamageAmount = 10.0f;
	Template.fKnockbackDamageRadius = 16.0f;

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';

	return Template;
}

static function X2DataTemplate CreateTemplate_Shotgun_AdventM2()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Shotgun_AdvM2');
	Template.WeaponPanelImage = "_MagneticShotgun";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'shotgun';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.UI_MagShotgun.MagShotgun_Base";
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 3;

	Template.BaseDamage = default.SHOTGUN_ADVM2_BASEDAMAGE;
	Template.RangeAccuracy = default.SHORT_RANGE;
	Template.Aim = default.SHOTGUN_ADV_AIM;
	Template.CritChance = default.SHOTGUN_ADV_CRITCHANCE;
	Template.iClipSize = default.SHOTGUN_ADV_ICLIPSIZE;
	Template.iSoundRange = default.SHOTGUN_ADV_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SHOTGUN_ADV_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.SHORT_IDEALRANGE;
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	
	Template.GameArchetype = "Spectrum_Weapons.WP_Shotgun_Adv";

	Template.iPhysicsImpulse = 5;

	Template.fKnockbackDamageAmount = 10.0f;
	Template.fKnockbackDamageRadius = 16.0f;

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';

	return Template;
}

static function X2DataTemplate CreateTemplate_Shotgun_AdventM3()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Shotgun_AdvM3');
	Template.WeaponPanelImage = "_MagneticShotgun";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'shotgun';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.UI_MagShotgun.MagShotgun_Base";
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 3;

	Template.BaseDamage = default.SHOTGUN_ADVM3_BASEDAMAGE;
	Template.RangeAccuracy = default.SHORT_RANGE;
	Template.Aim = default.SHOTGUN_ADV_AIM;
	Template.CritChance = default.SHOTGUN_ADV_CRITCHANCE;
	Template.iClipSize = default.SHOTGUN_ADV_ICLIPSIZE;
	Template.iSoundRange = default.SHOTGUN_ADV_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SHOTGUN_ADV_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.SHORT_IDEALRANGE;
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	
	Template.GameArchetype = "Spectrum_Weapons.WP_Shotgun_Adv";

	Template.iPhysicsImpulse = 5;

	Template.fKnockbackDamageAmount = 10.0f;
	Template.fKnockbackDamageRadius = 16.0f;

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';

	return Template;
}

//Shredders

static function X2DataTemplate CreateTemplate_Shredder_AdventM1()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Shredder_AdvM1');
	Template.WeaponPanelImage = "_MagneticShotgun";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'shotgun';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.UI_MagShotgun.MagShotgun_Base";
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 3;

	Template.BaseDamage = default.SHREDDER_ADVM1_BASEDAMAGE;
	Template.RangeAccuracy = default.SHORT_RANGE;
	Template.Aim = default.SHOTGUN_ADV_AIM;
	Template.CritChance = default.SHOTGUN_ADV_CRITCHANCE;
	Template.iClipSize = default.SHOTGUN_ADV_ICLIPSIZE;
	Template.iSoundRange = default.SHOTGUN_ADV_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SHOTGUN_ADV_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.SHORT_IDEALRANGE;
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	
	Template.GameArchetype = "Spectrum_Weapons.WP_Shotgun_Adv";

	Template.iPhysicsImpulse = 5;

	Template.fKnockbackDamageAmount = 10.0f;
	Template.fKnockbackDamageRadius = 16.0f;

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';

	return Template;
}

static function X2DataTemplate CreateTemplate_Shredder_AdventM2()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Shredder_AdvM2');
	Template.WeaponPanelImage = "_MagneticShotgun";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'shotgun';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.UI_MagShotgun.MagShotgun_Base";
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 3;

	Template.BaseDamage = default.SHREDDER_ADVM2_BASEDAMAGE;
	Template.RangeAccuracy = default.SHORT_RANGE;
	Template.Aim = default.SHOTGUN_ADV_AIM;
	Template.CritChance = default.SHOTGUN_ADV_CRITCHANCE;
	Template.iClipSize = default.SHOTGUN_ADV_ICLIPSIZE;
	Template.iSoundRange = default.SHOTGUN_ADV_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SHOTGUN_ADV_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.SHORT_IDEALRANGE;
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	
	Template.GameArchetype = "Spectrum_Weapons.WP_Shotgun_Adv";

	Template.iPhysicsImpulse = 5;

	Template.fKnockbackDamageAmount = 10.0f;
	Template.fKnockbackDamageRadius = 16.0f;

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';

	return Template;
}

static function X2DataTemplate CreateTemplate_Shredder_AdventM3()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Shredder_AdvM3');
	Template.WeaponPanelImage = "_MagneticShotgun";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'shotgun';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.UI_MagShotgun.MagShotgun_Base";
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 3;

	Template.BaseDamage = default.SHREDDER_ADVM3_BASEDAMAGE;
	Template.RangeAccuracy = default.SHORT_RANGE;
	Template.Aim = default.SHOTGUN_ADV_AIM;
	Template.CritChance = default.SHOTGUN_ADV_CRITCHANCE;
	Template.iClipSize = default.SHOTGUN_ADV_ICLIPSIZE;
	Template.iSoundRange = default.SHOTGUN_ADV_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SHOTGUN_ADV_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.SHORT_IDEALRANGE;
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	
	Template.GameArchetype = "Spectrum_Weapons.WP_Shotgun_Adv";

	Template.iPhysicsImpulse = 5;

	Template.fKnockbackDamageAmount = 10.0f;
	Template.fKnockbackDamageRadius = 16.0f;

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';

	return Template;
}

//=====================
//	Advent Heavies
//=====================

static function X2DataTemplate CreateTemplate_Flamethrower_Advent()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Flamethrower_Adv');
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'pistol';
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_FlameThrower";
	Template.EquipSound = "StrategyUI_Heavy_Weapon_Equip";

	Template.BaseDamage = default.FLAMETHROWER_BASEDAMAGE;
	Template.iSoundRange = default.FLAMETHROWER_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.FLAMETHROWER_IENVIRONMENTDAMAGE;
	Template.iClipSize = default.FLAMETHROWER_ICLIPSIZE;
	Template.iRange = default.FLAMETHROWER_RANGE;
	Template.iRadius = default.FLAMETHROWER_RADIUS;
	Template.PointsToComplete = 0;
	Template.DamageTypeTemplateName = 'Fire';
	Template.fCoverage = 33.0f;
	
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_HeavyWeapon;
	Template.GameArchetype = "WP_HeavyFlamethrower.WP_Heavy_Flamethrower";
	Template.AltGameArchetype = "WP_HeavyFlamethrower.WP_Heavy_Flamethrower_Powered";
	Template.ArmorTechCatForAltArchetype = 'powered';
	Template.bMergeAmmo = true;

	Template.Abilities.AddItem('Flamethrower');

	Template.CanBeBuilt = false;

	return Template;
}

static function X2WeaponTemplate CreateTemplate_ShredderGun_Advent()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'ShredderGun_Adv');
	Template.WeaponCat = 'pistol';
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Shredder_Gun";
	Template.EquipSound = "StrategyUI_Heavy_Weapon_Equip";

	Template.BaseDamage = default.SHREDDERGUN_BASEDAMAGE;
	Template.iSoundRange = default.SHREDDERGUN_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SHREDDERGUN_IENVIRONMENTDAMAGE;
	Template.iClipSize = default.SHREDDERGUN_ICLIPSIZE;
	Template.iRange = default.SHREDDERGUN_RANGE;
	Template.iRadius = default.SHREDDERGUN_RADIUS;
	Template.PointsToComplete = 0;
		
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_HeavyWeapon;
	Template.GameArchetype = "WP_Heavy_ShredderGun.WP_Heavy_ShredderGun";
	Template.AltGameArchetype = "WP_Heavy_ShredderGun.WP_Heavy_ShredderGun_Powered";
	Template.ArmorTechCatForAltArchetype = 'powered';
	Template.bMergeAmmo = true;

	Template.Abilities.AddItem('ShredderGun');

	Template.CanBeBuilt = false;

	return Template;
}