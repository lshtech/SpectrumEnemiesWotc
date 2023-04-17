class SpectrumEnemies_Effect_Reinforce extends X2Effect config (SpectrumEnemies);

	var config name EncounterID;
	var config int 	SpawnTileOffset;

	simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
	{
		local XComTacticalMissionManager MissionManager;
		local ConfigurableEncounter Encounter;
		local bool bFound;
		local Vector RandomVector;
		local XcomGameState GameState;
		GameState = NewGameState;
		RandomVector = VRand();

		//EncounterID = 'OPNx3_Standard';
		MissionManager = `TACTICALMISSIONMGR;
		foreach MissionManager.ConfigurableEncounters(Encounter)
		{
			if( EncounterID == Encounter.EncounterID )
			{
				bFound = true;
				break;
			}
		}
		if( bFound )
		{
			class'XComGameState_AIReinforcementSpawner'.static.InitiateReinforcements(default.EncounterID, ,true,RandomVector,default.SpawnTileOffset,GameState);
		}
	}