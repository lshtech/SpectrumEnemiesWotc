class Items_New extends X2Item config(SpectrumUtility);

var config int SHIELD_VEST_HP;
var config int SHIELD_VEST_ARMOR;
var config int SHIELD_VEST_MOBILITY;
var config int SHIELD_VEST_REGEN;
var config int SHIELD_VEST_REGEN_CAP;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Items;

	Items.AddItem(ShieldVest());

	return Items;
}

static function X2DataTemplate ShieldVest()
{
	local X2EquipmentTemplate 	Template;
	local ArtifactCost 			Artifacts;
	local ArtifactCost 			Resources;

	`CREATE_X2TEMPLATE(class'X2EquipmentTemplate', Template, 'ShieldVest');
	Template.ItemCat = 'defense';
	Template.InventorySlot = eInvSlot_Utility;
	Template.strImage = "img:///Spectrum_Weapon.Inv_ShieldVest";
	Template.EquipSound = "StrategyUI_Vest_Equip";

	Template.Abilities.AddItem('Aegis_ShieldVest');

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 25;
	Template.PointsToComplete = 0;
	Template.Tier = 2;

	Resources.ItemTemplateName = 'Supplies';
 	Resources.Quantity = 100;
 	Template.Cost.ResourceCosts.AddItem(Resources);

	Resources.ItemTemplateName = 'AlienAlloy';
	Resources.Quantity = 10;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Artifacts.ItemTemplateName = 'CorpseAdventShieldBearer';
	Artifacts.Quantity = 2;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	Template.RewardDecks.AddItem('ExperimentalArmorRewards');

	return Template;
}

defaultproperties
{
	bShouldCreateDifficultyVariants = true
}