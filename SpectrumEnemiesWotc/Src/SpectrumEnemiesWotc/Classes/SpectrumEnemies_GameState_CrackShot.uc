class SpectrumEnemies_GameState_CrackShot extends XComGameState_Effect;

function EventListenerReturn CrackShotCheck(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState NewGameState;
	local XComGameState_Unit SourceUnit, DeadUnit;
    local XComGameState_Item SourceWeapon;
	local XComGameStateHistory History;

	if (!bRemoved)
	{
		AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
		if (AbilityContext != none)
		{
			if (AbilityContext.InputContext.SourceObject.ObjectID == ApplyEffectParameters.SourceStateObjectRef.ObjectID)
			{
				History = `XCOMHISTORY;
				SourceUnit = XComGameState_Unit(History.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
				DeadUnit = XComGameState_Unit(EventData);

				if (`TACTICALRULES.GetCachedUnitActionPlayerRef().ObjectID == SourceUnit.ControllingPlayer.ObjectID)
				{
					if (SourceUnit.IsEnemyUnit(DeadUnit))
					{
						SourceWeapon = SourceUnit.GetPrimaryWeapon();
						if( SourceWeapon != None && SourceWeapon.Ammo < SourceWeapon.GetClipSize() )                            
						{
							NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState(string(GetFuncName()));	
							SourceWeapon = XComGameState_Item(NewGameState.ModifyStateObject(class'XComGameState_Item', SourceWeapon.ObjectID));
							SourceWeapon.Ammo = SourceWeapon.Ammo + 1;
							SubmitNewGameState(NewGameState);
						}
					}
				}
			}
		}
	}

	return ELR_NoInterrupt;
}