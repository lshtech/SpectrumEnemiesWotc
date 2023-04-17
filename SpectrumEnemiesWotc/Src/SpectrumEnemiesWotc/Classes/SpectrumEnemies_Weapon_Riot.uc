class SpectrumEnemies_Weapon_Riot extends SpectrumEnemies_Weapon config(SpectrumEnemies);

var config WeaponDamageValue ADVSTUNLANCERM1_STUNLANCE_BASEDAMAGE;
var config WeaponDamageValue ADVSTUNLANCERM2_STUNLANCE_BASEDAMAGE;
var config WeaponDamageValue ADVSTUNLANCERM3_STUNLANCE_BASEDAMAGE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Weapons;

	Weapons.AddItem(CreateTemplate_AdvStunLancerM1_RiotLance());	
	Weapons.AddItem(CreateTemplate_AdvStunLancerM2_RiotLance());
	Weapons.AddItem(CreateTemplate_AdvStunLancerM3_RiotLance());

    return Weapons;
}

static function X2DataTemplate CreateTemplate_AdvStunLancerM1_RiotLance()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AdvStunLancerM1_RiotLance');
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'baton';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.Sword";
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "Spectrum_Weapons.WP_StunLance";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.Aim = default.GENERIC_MELEE_ACCURACY;
	//Template.Aim = 10;

	Template.iRange = 0;
	Template.iRadius = 1;
	Template.NumUpgradeSlots = 2;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;
	Template.iIdealRange = 1;

	Template.BaseDamage = default.ADVSTUNLANCERM1_STUNLANCE_BASEDAMAGE;
	Template.BaseDamage.DamageType='Melee';
	Template.iSoundRange = 2;
	Template.iEnvironmentDamage = 0;

	//Build Data
	Template.StartingItem = false;
	Template.CanBeBuilt = false;

	Template.Abilities.AddItem('StunLance');

	return Template;
}

static function X2DataTemplate CreateTemplate_AdvStunLancerM2_RiotLance()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AdvStunLancerM2_RiotLance');
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'baton';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.Sword";
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "Spectrum_Weapons.WP_StunLance";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.Aim = default.GENERIC_MELEE_ACCURACY;

	Template.iRange = 0;
	Template.iRadius = 1;
	Template.NumUpgradeSlots = 2;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.BaseDamage = default.ADVSTUNLANCERM2_STUNLANCE_BASEDAMAGE;
	Template.BaseDamage.DamageType='Melee';
	Template.iSoundRange = 2;
	Template.iEnvironmentDamage = 0;
	Template.iIdealRange = 1;

	//Build Data
	Template.StartingItem = false;
	Template.CanBeBuilt = false;

	Template.Abilities.AddItem('StunLance');

	return Template;
}

static function X2DataTemplate CreateTemplate_AdvStunLancerM3_RiotLance()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AdvStunLancerM3_RiotLance');
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'baton';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.Sword";
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "Spectrum_Weapons.WP_StunLance";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.Aim = default.GENERIC_MELEE_ACCURACY;

	Template.iRange = 0;
	Template.iRadius = 1;
	Template.NumUpgradeSlots = 2;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;
	Template.iIdealRange = 1;

	Template.BaseDamage = default.ADVSTUNLANCERM3_STUNLANCE_BASEDAMAGE;
	Template.BaseDamage.DamageType='Melee';
	Template.iSoundRange = 2;
	Template.iEnvironmentDamage = 0;

	//Build Data
	Template.StartingItem = false;
	Template.CanBeBuilt = false;

	Template.Abilities.AddItem('StunLance');

	return Template;
}
