//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class Effect_ShieldRegen extends X2Effect_Persistent;

var int ShieldAmount;
var int ShieldCap;
var name ShieldRegeneratedName;

function bool RegenerationTicked(X2Effect_Persistent PersistentEffect, const out EffectAppliedData ApplyEffectParameters, XComGameState_Effect kNewEffectState, XComGameState NewGameState, bool FirstApplication)
{
	local XComGameState_Unit OldTargetState, NewTargetState;
	local UnitValue ShieldRegenerated;
	local int AmountToShield, Shielded;
	

	OldTargetState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.TargetStateObjectRef.ObjectID));


	if (ShieldRegeneratedName != '')
	{
		OldTargetState.GetUnitValue(ShieldRegeneratedName, ShieldRegenerated);

			// Ensure the unit is not shielded for more than the maximum allowed amount, by exceeding the ShieldCap
			AmountToShield = min(ShieldAmount, (ShieldCap - OldTargetState.GetCurrentStat(eStat_ShieldHP)) );
		if (AmountToShield < 0) { AmountToShield = 0;}
	}
	else
	{
		// If no value tracking for shield regenerated is set, shield for the default amount
		AmountToShield = ShieldAmount;
	}	

	// Perform the shield
	NewTargetState = XComGameState_Unit(NewGameState.CreateStateObject(OldTargetState.Class, OldTargetState.ObjectID));
	NewTargetState.ModifyCurrentStat(estat_ShieldHP, AmountToShield);
	NewGameState.AddStateObject(NewTargetState);

	// If this shield regen is being tracked, save how much the unit was shielded
	if (ShieldRegeneratedName != '')
	{
		Shielded = NewTargetState.GetCurrentStat(eStat_ShieldHP) - OldTargetState.GetCurrentStat(eStat_ShieldHP);
		if (Shielded > 0)
		{
			NewTargetState.SetUnitFloatValue(ShieldRegeneratedName, ShieldRegenerated.fValue + Shielded, eCleanup_BeginTactical);
		}
	}

	return false;
}

simulated function AddX2ActionsForVisualization_Tick(XComGameState VisualizeGameState, out VisualizationActionMetadata ActionMetadata, const int TickIndex, XComGameState_Effect EffectState)
{
	local XComGameState_Unit OldUnit, NewUnit;
	local X2Action_PlaySoundAndFlyOver SoundAndFlyOver;
	local int Shielded;
	
	OldUnit = XComGameState_Unit(ActionMetadata.StateObject_OldState);
	NewUnit = XComGameState_Unit(ActionMetadata.StateObject_NewState);

	Shielded = NewUnit.GetCurrentStat(eStat_ShieldHP) - OldUnit.GetCurrentStat(eStat_ShieldHP);
	
	if( Shielded > 0 )
	{
		SoundAndFlyOver = X2Action_PlaySoundAndFlyOver(class'X2Action_PlaySoundAndFlyOver'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext()));
		SoundAndFlyOver.SetSoundAndFlyOverParameters(None, "+" $ Shielded, '', eColor_Good);
	}
}

defaultproperties
{
	EffectName="ShieldRegen"
	EffectTickedFn=RegenerationTicked
}