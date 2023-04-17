class SpectrumEnemies_Effect_EnergyShield extends X2Effect_PersistentStatChange;

var float ResistDamageMod; //, ResistCritMod;
var int BaseShield;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local XComGameState_Unit UnitState;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID));
	EffectObj = EffectGameState;

	EventMgr.RegisterForEvent(EffectObj, 'ShieldsExpended', EffectGameState.OnShieldsExpended, ELD_OnStateSubmitted, , UnitState);
}

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
	local XComGameState_Unit	Target;
	local int					Shield;

	Target = XComGameState_Unit(TargetDamageable);
	if ( Target == none || WeaponDamageEffect.bBypassShields == true || CurrentDamage <= 1) { return 0; }

	Shield = Target.GetCurrentStat(eStat_ShieldHP);
	If ( Shield <= BaseShield) { return 0; }

	return -Min(Min(Round(CurrentDamage * ResistDamageMod), CurrentDamage - 1), Shield);
}

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit UnitState;

    UnitState = XComGameState_Unit(kNewTargetState);
    BaseShield = UnitState.GetCurrentStat(eStat_ShieldHP);

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

defaultproperties
{
	EffectName="EnergyShieldEffect"
	DuplicateResponse=eDupe_Refresh
}