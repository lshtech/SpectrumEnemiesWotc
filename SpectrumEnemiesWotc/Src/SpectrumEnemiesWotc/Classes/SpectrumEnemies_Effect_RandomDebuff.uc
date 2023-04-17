class SpectrumEnemies_Effect_RandomDebuff extends X2Effect_ModifyStats;

var array<StatChange>	m_aStatChanges;

simulated function AddPersistentStatChange(ECharStatType StatType, float StatAmount, optional EStatModOp InModOp=MODOP_Addition )
{
	local StatChange NewChange;
	
	NewChange.StatType = StatType;
	NewChange.StatAmount = StatAmount;
	NewChange.ModOp = InModOp;

	m_aStatChanges.AddItem(NewChange);
}

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local array<ECharStatType>  StatOptions;
	local ECharStatType			RandomStat;
	local float					RandomValue;
	local int idx;

	NewEffectState.StatChanges = m_aStatChanges;


	StatOptions.AddItem(eStat_CritChance);
	StatOptions.AddItem(eStat_Defense);
	StatOptions.AddItem(eStat_Dodge);
	StatOptions.AddItem(eStat_Mobility);
	StatOptions.AddItem(eStat_Offense);
	StatOptions.AddItem(eStat_PsiOffense);
	StatOptions.AddItem(eStat_SightRadius);
	StatOptions.AddItem(eStat_Will);
	StatOptions.AddItem(eStat_Strength);
	StatOptions.AddItem(eStat_Hacking);

	RandomStat = StatOptions[`SYNC_RAND(StatOptions.Length)];
	RandomValue = -(`SYNC_RAND(15));

	

	for (idx = 0; idx < NewEffectState.StatChanges.Length; ++idx)
	{
		RandomStat = StatOptions[`SYNC_RAND(StatOptions.Length)];
		RandomValue = -(`SYNC_RAND(15));

		NewEffectState.StatChanges[idx].StatType = RandomStat;
		NewEffectState.StatChanges[idx].StatAmount = RandomValue;

		`Log("Spectrum: Modifying " $ RandomStat $ " by " $ RandomValue);
	}

	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}