class SpectrumEnemies_Effect_Patience extends X2Effect_PersistentStatChange;

function RegisterForEvents(XComGameState_Effect EffectGameState)
{
	local X2EventManager						EventManager;
	local Object								EffectObj, TargetObj;

	EventManager = `XEVENTMGR;
	EffectObj = EffectGameState;
	TargetObj = `XCOMHISTORY.GetGameStateForObjectID(EffectGameState.ApplyEffectParameters.TargetStateObjectRef.ObjectID);

	EventManager.RegisterForEvent(EffectObj, 'UnitMoveFinished', RemoveEffectOnMove, ELD_OnStateSubmitted,,TargetObj,, EffectObj);
}

function bool UniqueToHitModifiers() { return true; }

static function EventListenerReturn RemoveEffectOnMove(Object EventData, Object EventSource, XComGameState NewGameState, Name InEventID, Object CallbackData)
{
	local XComGameState_Effect					EffectState;
	local XComGameStateContext_EffectRemoved	EffectRemovedContext;
	local XComGameState							EffectRemovedGameState;

	EffectState = XComGameState_Effect(CallbackData);

	EffectRemovedContext = class'XComGameStateContext_EffectRemoved'.static.CreateEffectRemovedContext(EffectState);	
	EffectRemovedGameState = `XCOMHISTORY.CreateNewGameState(true, EffectRemovedContext);
	EffectState.RemoveEffect(EffectRemovedGameState, EffectRemovedGameState);
	`TACTICALRULES.SubmitGameState(EffectRemovedGameState);	

	return ELR_NoInterrupt;
}

defaultproperties
{
	bRemoveWhenSourceDies=true
}