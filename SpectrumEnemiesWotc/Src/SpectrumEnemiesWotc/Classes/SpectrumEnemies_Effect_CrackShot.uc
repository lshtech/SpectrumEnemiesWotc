class SpectrumEnemies_Effect_CrackShot extends X2Effect_Persistent;

var name CrackShotThisTurnValue;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager EventMgr;
	local Object EffectObj;

	EventMgr = `XEVENTMGR;

	EffectObj = EffectGameState;

	EventMgr.RegisterForEvent(EffectObj, 'UnitDied', SpectrumEnemies_GameState_CrackShot(EffectGameState).CrackShotCheck, ELD_OnStateSubmitted);
}

DefaultProperties
{
	CrackShotThisTurnValue = "CrackShotThisTurn"
	GameStateEffectClass = class'SpectrumEnemies_GameState_CrackShot'
	EffectName = "CrackShot"
}