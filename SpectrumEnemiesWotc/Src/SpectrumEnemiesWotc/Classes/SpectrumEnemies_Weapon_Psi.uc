class SpectrumEnemies_Weapon_Psi extends SpectrumEnemies_Weapon config(SpectrumEnemies);

var config WeaponDamageValue SNIPERRIFLE_ADVP2_BASEDAMAGE;
var config WeaponDamageValue SNIPERRIFLE_ADVP3_BASEDAMAGE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Weapons;

	Weapons.AddItem(CreateTemplate_PsiAmp_CV_Adv());
	Weapons.AddItem(CreateTemplate_PsiAmp_MG_Adv());
	Weapons.AddItem(CreateTemplate_PsiAmp_BM_Adv());
	Weapons.AddItem(CreateTemplate_SniperRifle_AdventP2());
	Weapons.AddItem(CreateTemplate_SniperRifle_AdventP3());

    return Weapons;
}

static function X2DataTemplate CreateTemplate_PsiAmp_CV_Adv()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'PsiAmp_CV_Adv');
	Template.WeaponPanelImage = "_PsiAmp";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'psiamp';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Psi_Amp";
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability
	// This all the resources; sounds, animations, models, physics, the works.
	
	Template.GameArchetype = "WP_PsiAmp_MG.WP_PsiAmp_MG_Advent";

	Template.Abilities.AddItem('RandomDebuff');

	Template.CanBeBuilt = false;

	Template.DamageTypeTemplateName = 'Psi';

	return Template;
}

static function X2DataTemplate CreateTemplate_PsiAmp_MG_Adv()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'PsiAmp_MG_Adv');
	Template.WeaponPanelImage = "_PsiAmp";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'psiamp';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Psi_Amp";
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability
	// This all the resources; sounds, animations, models, physics, the works.
	
	Template.GameArchetype = "WP_PsiAmp_MG.WP_PsiAmp_MG_Advent";

	Template.Abilities.AddItem('PsiReanimation');
	Template.Abilities.AddItem('MindSpin');
	Template.Abilities.AddItem('SoulmendM1');

	Template.CanBeBuilt = false;

	Template.DamageTypeTemplateName = 'Psi';

	return Template;
}

static function X2DataTemplate CreateTemplate_PsiAmp_BM_Adv()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'PsiAmp_BM_Adv');
	Template.WeaponPanelImage = "_PsiAmp";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'psiamp';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Psi_Amp";
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.StowedLocation = eSlot_RightBack;
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability
	// This all the resources; sounds, animations, models, physics, the works.
	
	Template.GameArchetype = "WP_PsiAmp_MG.WP_PsiAmp_MG_Advent";

	Template.Abilities.AddItem('MindSpin');
	Template.Abilities.AddItem('SoulmendM2');

	Template.CanBeBuilt = false;

	Template.DamageTypeTemplateName = 'Psi';

	return Template;
}

static function X2DataTemplate CreateTemplate_SniperRifle_AdventP2()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Sniperrifle_AdvP2');
	Template.WeaponPanelImage = "_MagneticSniperRifle";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'sniper_rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.UI_MagSniper.MagSniper_Base";
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 3;

	Template.BaseDamage = default.SNIPERRIFLE_ADVP2_BASEDAMAGE;
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

	Template.DamageTypeTemplateName = 'Psi';

	return Template;
}

static function X2DataTemplate CreateTemplate_SniperRifle_AdventP3()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Sniperrifle_AdvP3');
	Template.WeaponPanelImage = "_MagneticSniperRifle";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'sniper_rifle';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.UI_MagSniper.MagSniper_Base";
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 3;

	Template.BaseDamage = default.SNIPERRIFLE_ADVP3_BASEDAMAGE;
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

	Template.DamageTypeTemplateName = 'Psi';

	return Template;
}
