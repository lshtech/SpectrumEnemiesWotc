//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_SpectrumEnemiesWotc.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_SpectrumEnemiesWotc extends X2DownloadableContentInfo;

/// <summary>
/// This method is run if the player loads a saved game that was created prior to this DLC / Mod being installed, and allows the 
/// DLC / Mod to perform custom processing in response. This will only be called once the first time a player loads a save that was
/// create without the content installed. Subsequent saves will record that the content was installed.
/// </summary>
static event OnLoadedSavedGame()
{}

/// <summary>
/// Called when the player starts a new campaign while this DLC / Mod is installed
/// </summary>
static event InstallNewCampaign(XComGameState StartState)
{}

static event OnPostTemplatesCreated()
{
    local XComOnlineEventMgr			EventManager;
    local int							Index;
    
    EventManager = `ONLINEEVENTMGR;
	for(Index = EventManager.GetNumDLC() - 1; Index >= 0; Index--)
	{
		if(EventManager.GetDLCNames(Index)=='WOTCAdventReinforcements')
		{
			ReplaceCallReinforcements('AdvCommanderM0', 'Spectrum_AdventCommander_CallReinforcements');
            ReplaceCallReinforcements('AdvCommanderM1', 'Spectrum_AdventCommander_CallReinforcements');
            ReplaceCallReinforcements('AdvCommanderM2', 'Spectrum_AdventCommander_CallReinforcements');
            ReplaceCallReinforcements('AdvCommanderM3', 'Spectrum_AdventCommander_CallReinforcements');

            ReplaceCallReinforcements('AdvCaptainB1', 'Spectrum_AdventCaptain_CallReinforcements');
            ReplaceCallReinforcements('AdvCaptainB2', 'Spectrum_AdventCaptain_CallReinforcements');
            ReplaceCallReinforcements('AdvCaptainB3', 'Spectrum_AdventCaptain_CallReinforcements');

            ReplaceCallReinforcements('AdvCaptainG1', 'Spectrum_AdventCaptain_CallReinforcements');
            ReplaceCallReinforcements('AdvCaptainG2', 'Spectrum_AdventCaptain_CallReinforcements');
            ReplaceCallReinforcements('AdvCaptainG3', 'Spectrum_AdventCaptain_CallReinforcements');

            ReplaceCallReinforcements('AdvCaptainO1', 'Spectrum_AdventCaptain_CallReinforcements');
            ReplaceCallReinforcements('AdvCaptainO2', 'Spectrum_AdventCaptain_CallReinforcements');
            ReplaceCallReinforcements('AdvCaptainO3', 'Spectrum_AdventCaptain_CallReinforcements');

            ReplaceCallReinforcements('AdvCaptainP1', 'Spectrum_AdventCaptain_CallReinforcements');
            ReplaceCallReinforcements('AdvCaptainP2', 'Spectrum_AdventCaptain_CallReinforcements');
            ReplaceCallReinforcements('AdvCaptainP3', 'Spectrum_AdventCaptain_CallReinforcements');

            ReplaceCallReinforcements('AdvCaptainW1', 'Spectrum_AdventCaptain_CallReinforcements');
            ReplaceCallReinforcements('AdvCaptainW2', 'Spectrum_AdventCaptain_CallReinforcements');
            ReplaceCallReinforcements('AdvCaptainW3', 'Spectrum_AdventCaptain_CallReinforcements');
		
            ReplaceCallReinforcements('AdvMECOfficerM1', 'Spectrum_AdventCaptain_CallReinforcements');
            ReplaceCallReinforcements('AdvMECOfficerM2', 'Spectrum_AdventCaptain_CallReinforcements');
            ReplaceCallReinforcements('AdvMECOfficerM3', 'Spectrum_AdventCaptain_CallReinforcements');
        }
	}
}

static function ReplaceCallReinforcements(Name CharacterName, Name AbilityName)
{
    local X2CharacterTemplate           CharacterTemplate;
    local X2CharacterTemplateManager    CharacterTemplateManager;

    CharacterTemplateManager = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

    CharacterTemplate = CharacterTemplateManager.FindCharacterTemplate(CharacterName);
    CharacterTemplate.Abilities.RemoveItem(AbilityName);
    CharacterTemplate.Abilities.AddItem('AdventCommander_CallReinforcements');
}