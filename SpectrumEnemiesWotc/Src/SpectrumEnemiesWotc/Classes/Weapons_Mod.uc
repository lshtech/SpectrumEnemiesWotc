class Weapons_Mod extends UIScreenListener;
 
 	var bool UpdatedWeapons;

event OnInit(UIScreen Screen)
{
	local X2ItemTemplateManager ItemTemplateManager, LongWarLaserCheck;
	local X2WeaponTemplate Template, Lasers;
	local X2DataTemplate					DifficultyTemplate;
	local array<X2DataTemplate>				DifficultyTemplates;


	if(!UpdatedWeapons)
	{
		ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
		LongWarLaserCheck = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
		Lasers = X2WeaponTemplate(LongWarLaserCheck.FindItemTemplate('AssaultRifle_LS'));
		if(Lasers != none)
		{

			ItemTemplateManager.FindDataTemplateAllDifficulties('AegisRifle_M1',DifficultyTemplates);
			foreach DifficultyTemplates(DifficultyTemplate) {
			Template = X2WeaponTemplate(DifficultyTemplate);
			if(Template != none)
            {
			Template.GameArchetype = "LWAssaultRifle_LS.Archetype.WP_AssaultRifle_LS";

			Template.AddDefaultAttachment('Mag', "LWAttachments_LS.Meshes.SK_Laser_Mag_A", , "img:///UILibrary_LW_LaserPack.LaserRifle_MagA");
			Template.AddDefaultAttachment('Stock', "LWAttachments_LS.Meshes.SK_Laser_Stock_A", , "img:///UILibrary_LW_LaserPack.LaserRifle_StockA");
			Template.AddDefaultAttachment('Reargrip', "LWAttachments_LS.Meshes.SK_Laser_Trigger_A", , "img:///UILibrary_LW_LaserPack.LaserRifle_TriggerA");
			Template.AddDefaultAttachment('Foregrip', "LWAttachments_LS.Meshes.SK_Laser_Foregrip_A", , "img:///UILibrary_LW_LaserPack.LaserRifle_ForegripA");
			}
            }
		

	
			ItemTemplateManager.FindDataTemplateAllDifficulties('AegisRifle_M2',DifficultyTemplates);
			foreach DifficultyTemplates(DifficultyTemplate) {
			Template = X2WeaponTemplate(DifficultyTemplate);
			if(Template != none)
            {
			Template.GameArchetype = "LWAssaultRifle_LS.Archetype.WP_AssaultRifle_LS";

			Template.AddDefaultAttachment('Mag', "LWAttachments_LS.Meshes.SK_Laser_Mag_A", , "img:///UILibrary_LW_LaserPack.LaserRifle_MagA");
			Template.AddDefaultAttachment('Stock', "LWAttachments_LS.Meshes.SK_Laser_Stock_A", , "img:///UILibrary_LW_LaserPack.LaserRifle_StockA");
			Template.AddDefaultAttachment('Reargrip', "LWAttachments_LS.Meshes.SK_Laser_Trigger_A", , "img:///UILibrary_LW_LaserPack.LaserRifle_TriggerA");
			Template.AddDefaultAttachment('Foregrip', "LWAttachments_LS.Meshes.SK_Laser_Foregrip_A", , "img:///UILibrary_LW_LaserPack.LaserRifle_ForegripA");
			}
            }
			

			ItemTemplateManager.FindDataTemplateAllDifficulties('AegisRifle_M3',DifficultyTemplates);
			foreach DifficultyTemplates(DifficultyTemplate) {
			Template = X2WeaponTemplate(DifficultyTemplate);
			if(Template != none)
            {
			Template.GameArchetype = "LWAssaultRifle_LS.Archetype.WP_AssaultRifle_LS";	

			Template.AddDefaultAttachment('Mag', "LWAttachments_LS.Meshes.SK_Laser_Mag_A", , "img:///UILibrary_LW_LaserPack.LaserRifle_MagA");
			Template.AddDefaultAttachment('Stock', "LWAttachments_LS.Meshes.SK_Laser_Stock_A", , "img:///UILibrary_LW_LaserPack.LaserRifle_StockA");
			Template.AddDefaultAttachment('Reargrip', "LWAttachments_LS.Meshes.SK_Laser_Trigger_A", , "img:///UILibrary_LW_LaserPack.LaserRifle_TriggerA");
			Template.AddDefaultAttachment('Foregrip', "LWAttachments_LS.Meshes.SK_Laser_Foregrip_A", , "img:///UILibrary_LW_LaserPack.LaserRifle_ForegripA");
            }
			}

		}

		UpdatedWeapons = true;

	}

}


 	defaultproperties
	{
		ScreenClass = none;
	}