class SpectrumEnemies_Weapon_MEC extends SpectrumEnemies_Weapon config(SpectrumEnemies);

var config WeaponDamageValue MECM1_WPN_BASEDAMAGE;
var config WeaponDamageValue MECM2_WPN_BASEDAMAGE;
var config WeaponDamageValue MECM3_WPN_BASEDAMAGE;
var config WeaponDamageValue MECM1_SHORT_WPN_BASEDAMAGE;
var config WeaponDamageValue MECM2_SHORT_WPN_BASEDAMAGE;
var config WeaponDamageValue MECM3_SHORT_WPN_BASEDAMAGE;
var config WeaponDamageValue AdvMEC_M3_MicroMissiles_BaseDamage;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Weapons;

	Weapons.AddItem(CreateTemplate_MECM1_WPN());
	Weapons.AddItem(CreateTemplate_MECM2_WPN());
	Weapons.AddItem(CreateTemplate_MECM3_WPN());
	Weapons.AddItem(CreateTemplate_MECM1_SHORT_WPN());
	Weapons.AddItem(CreateTemplate_MECM2_SHORT_WPN());
	Weapons.AddItem(CreateTemplate_MECM3_SHORT_WPN());
	Weapons.AddItem(CreateTemplate_MECSparkBit());
	Weapons.AddItem(CreateTemplate_AdvMEC_M3_Shoulder_WPN());
    
    return Weapons;
}

static function X2DataTemplate CreateTemplate_MECM1_WPN()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'MECM1_WPN');
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.AdventMecGun";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability


	Template.BaseDamage = default.MECM1_WPN_BASEDAMAGE;
	Template.RangeAccuracy = default.MEDIUM_RANGE;
	Template.iClipSize = default.ASSAULTRIFLE_ADV_ICLIPSIZE;
	Template.iSoundRange = default.ASSAULTRIFLE_ADV_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.ASSAULTRIFLE_ADV_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.MEDIUM_IDEALRANGE;
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Suppression');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_AdvMec_Gun.WP_AdvMecGun";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	Template.DamageTypeTemplateName = 'Projectile_Conventional';

	return Template;
}

static function X2DataTemplate CreateTemplate_MECM2_WPN()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'MECM2_WPN');
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.AdventMecGun";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability


	Template.BaseDamage = default.MECM2_WPN_BASEDAMAGE;
	Template.RangeAccuracy = default.MEDIUM_RANGE;
	Template.iClipSize = default.ASSAULTRIFLE_ADV_ICLIPSIZE;
	Template.iSoundRange = default.ASSAULTRIFLE_ADV_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.ASSAULTRIFLE_ADV_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.MEDIUM_IDEALRANGE;
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Suppression');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_AdvMec_Gun.WP_AdvMecGun";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	Template.DamageTypeTemplateName = 'Projectile_Conventional';

	return Template;
}

static function X2DataTemplate CreateTemplate_MECM3_WPN()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'MECM3_WPN');
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.AdventMecGun";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability


	Template.BaseDamage = default.MECM3_WPN_BASEDAMAGE;
	Template.RangeAccuracy = default.MEDIUM_RANGE;
	Template.iClipSize = default.ASSAULTRIFLE_ADV_ICLIPSIZE;
	Template.iSoundRange = default.ASSAULTRIFLE_ADV_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.ASSAULTRIFLE_ADV_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.MEDIUM_IDEALRANGE;
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Suppression');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_AdvMec_Gun.WP_AdvMecGun";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	Template.DamageTypeTemplateName = 'Projectile_Conventional';

	return Template;
}

static function X2DataTemplate CreateTemplate_MECM1_SHORT_WPN()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'MECM1_SHORT_WPN');
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.AdventMecGun";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability


	Template.BaseDamage = default.MECM1_SHORT_WPN_BASEDAMAGE;
	Template.RangeAccuracy = default.SHORT_RANGE;
	Template.iClipSize = default.ASSAULTRIFLE_ADV_ICLIPSIZE;
	Template.iSoundRange = default.ASSAULTRIFLE_ADV_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.ASSAULTRIFLE_ADV_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.SHORT_IDEALRANGE;
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "Spectrum_Weapons.WP_AdvMecShotgun";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	Template.DamageTypeTemplateName = 'Projectile_Conventional';

	return Template;
}

static function X2DataTemplate CreateTemplate_MECM2_SHORT_WPN()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'MECM2_SHORT_WPN');
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.AdventMecGun";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability


	Template.BaseDamage = default.MECM2_SHORT_WPN_BASEDAMAGE;
	Template.RangeAccuracy = default.SHORT_RANGE;
	Template.iClipSize = default.ASSAULTRIFLE_ADV_ICLIPSIZE;
	Template.iSoundRange = default.ASSAULTRIFLE_ADV_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.ASSAULTRIFLE_ADV_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.SHORT_IDEALRANGE;
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "Spectrum_Weapons.WP_AdvMecShotgun";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	Template.DamageTypeTemplateName = 'Projectile_Conventional';

	return Template;
}

static function X2DataTemplate CreateTemplate_MECM3_SHORT_WPN()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'MECM3_SHORT_WPN');
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.AdventMecGun";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability


	Template.BaseDamage = default.MECM3_SHORT_WPN_BASEDAMAGE;
	Template.RangeAccuracy = default.SHORT_RANGE;
	Template.iClipSize = default.ASSAULTRIFLE_ADV_ICLIPSIZE;
	Template.iSoundRange = default.ASSAULTRIFLE_ADV_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.ASSAULTRIFLE_ADV_IENVIRONMENTDAMAGE;
	Template.iIdealRange = default.SHORT_IDEALRANGE;
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "Spectrum_Weapons.WP_AdvMecShotgun";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;

	Template.DamageTypeTemplateName = 'Projectile_Conventional';

	return Template;
}

static function X2DataTemplate CreateTemplate_MECSparkBit()
{
	local X2GremlinTemplate Template;

	`CREATE_X2TEMPLATE(class'X2GremlinTemplate', Template, 'MECM2_SPARKBIT_WPN');
	Template.WeaponPanelImage = "_Gremlin";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'sparkbit';
	Template.WeaponTech = 'magnetic';
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;
	Template.strImage = "img:///UILibrary_DLC3Images.Inv_Bit_mag";
	Template.EquipSound = "Gremlin_Equip";
	Template.CosmeticUnitTemplate = "SparkBitMk2";
	Template.Tier = 2;

	Template.BaseDamage.Damage = 2;     //  combat protocol
	Template.BaseDamage.Pierce = 1000;  //  ignore armor

	Template.NumUpgradeSlots = 0;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;
	Template.Abilities.AddItem('RepairMEC');

	Template.CanBeBuilt = false;

	Template.DamageTypeTemplateName = 'Electrical';

	Template.bHideDamageStat = true;

	return Template;
}

static function X2DataTemplate CreateTemplate_AdvMEC_M3_Shoulder_WPN()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AdvMEC_M3_Shoulder_WPN');
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'shoulder_launcher';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///UILibrary_Common.AlienWeapons.AdventMecGun";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.AdvMEC_M3_MicroMissiles_BaseDamage;
	Template.iClipSize = 2;
	Template.iSoundRange = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.iIdealRange = class'X2Item_DefaultWeapons'.default.ADVMEC_M2_IDEALRANGE;
	
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.Abilities.AddItem('MicroMissiles');
	Template.Abilities.AddItem('MicroMissileFuse');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_AdvMec_Launcher.WP_AdvMecLauncher";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;
	Template.iRange = 20;


	// This controls how much arc this projectile may have and how many times it may bounce
	Template.WeaponPrecomputedPathData.InitialPathTime = 1.5;
	Template.WeaponPrecomputedPathData.MaxPathTime = 2.5;
	Template.WeaponPrecomputedPathData.MaxNumberOfBounces = 0;

	Template.DamageTypeTemplateName = 'Explosion';

	return Template;
}