/*	Engine functions v.1 [2025-07-19],
 *		part of Minchinweb's MetaLibrary v.11
 *	Copyright © 2025 by W. Minchin. For more info,
 *		please visit https://github.com/MinchinWeb/openttd-metalibrary
 *
 *	Permission is granted to you to use, copy, modify, merge, publish,
 *	distribute, sublicense, and/or sell this software, and provide these
 *	rights to others, provided:
 *
 *	+ The above copyright notice and this permission notice shall be included
 *		in all copies or substantial portions of the software.
 *	+ Attribution is provided in the normal place for recognition of 3rd party
 *		contributions.
 *	+ You accept that this software is provided to you "as is", without warranty.
 */

/**	\brief		Engine functions
 *	\version	v.1 (2025-07-19)
 *	\author		W. Minchin (%MinchinWeb)
 *	\since		MetaLibrary v.11
 *
 *	These functions related to Engines.
 */

class _MinchinWeb_Engine_ {
	// _infinity = null;	///< pointer to \_MinchinWeb\_C\_::Infinity()

	constructor() {
		// this._infinity = _MinchinWeb_C_.Infinity();
	}

	/**	\brief	Vehicle Scoring v2. Deprecated in favour of v3.
	 *
	 *	Given an EngineID, the function will score them; higher is better.
	 *  \param  Cargo   Cargo you want to carry. Ensure that the ship can
	 *					retrofit to the desired cargo.
	 *  \param  TargetCapacity  (Approximate) amount of cargo you want to
	 *							carry. Often the industry's monthly production.
	 *  \param  MaxSpend    Hard upper limit on Engine cost. Set to zero (the
	 *						default) to ignore. Does not include retrofit costs.
	 *	\note	Designed to run as a valuator on a AIList of EngineID's.
	 *	\note	Capacity is measured in the default cargo.
	 *  \note   Assumes this vehicle will be continuously replaced, rather than
	 *			over a pre-defined "lifetime".
	 *	\note	Does not check for vehicles type (assumes you'll do that)
	 *	\todo	Add example of validator code.
	 *	\todo	Implement vehicle capacity in given cargo.
	 *	\since	MetaLibrary v10.1
	 *	\see	\_MinchinWeb\_Marine\_.RateShips2()
	 *	\see	Rate3()
	 *	\static
	 */
	function Rate2(EngineID, Cargo, TargetCapacity, MaxSpend = 0);

	/**	\brief	Vehicle Scoring v3
	 *
	 *	Given an EngineID, the function will score them; higher is better.
	 *  \param  Cargo   Cargo you want to carry. Ensure that the ship can
	 *					retrofit to the desired cargo.
	 *  \param  MonthlyProduction  Amount of cargo produced in a month.
	 *  \param  TravelDistance	The distance (in map tiles) that the engine is
	 *							expected to travel between pickup and drop off.
	 *							Assumes that the return distance is the same.
	 *  \param  PayDistance The Manhattan distance between the source and
	 *						destination (which is what is used for payments).
	 *						If set to `0` (the default), `TravelDistance` will
	 *						be used instead.
	 *  \param  MaxSpend    Hard upper limit on Engine cost. Set to zero (the
	 *						default) to ignore. Does not include retrofit costs.
	 *	\note	Designed to run as a valuator on a AIList of EngineID's.
	 *	\note	Capacity is measured in the default cargo.
	 *  \note   Assumes this vehicle will be continuously replaced, rather than
	 *			over a pre-defined "lifetime".
	 *	\note	Does not check for vehicles type (assumes you'll do that)
	 *  \note   Will rate invalid vehicles as "0", which may be selected if
	 *			every other vehicle would loose you money (as shown by a
	 *			negative score).
	 *	\todo	Add example of validator code.
	 *	\todo	Implement vehicle capacity in given cargo.
	 *	\since	MetaLibrary v10.1
	 *	\see	\_MinchinWeb\_Marine\_.RateShips3()
	 *	\static
	 */
	function Rate3(EngineID, Cargo, MonthlyProduction, TravelDistance, PayDistance = 0, MaxSpend = 0);
};


class _MinchinWeb_Engine_.Info {
	_main = null;

	function GetVersion()       { return 1; }
	// function GetMinorVersion()	{ return 0; }
	function GetRevision()		{ return 250719; }
	function GetDate()          { return "2025-07-19"; }
	function GetName()          { return "Engine"; }

	constructor(main) {
		this._main = main;
	}
};

//	== Function definitions =================================================
function _MinchinWeb_Engine_::Rate2(EngineID, Cargo, TargetCapacity, MaxSpend = 0) {
	//	Designed to Run as a validator
	//	Given the EngineID, it will score them; higher is better
	//	   Score = [(Capacity in Cargo) * Reliability * Speed]
	// 				* CapacityFactor
	// 				/ [ (Purchase Price / Life) + (Running Costs) ]
	//
	//  Note: Cargo doesn't fully work yet. Capacity is measured in the default cargo.

	// only buildable engines
	if (AIEngine.IsBuildable(EngineID)) {
		// pass
	} else {
		return -1 * _MinchinWeb_C_.Infinity();
	}

	// only return vehicles under our hard cost limit
	if ((MaxSpend > 0) && (AIEngine.GetPrice(EngineID) > MaxSpend)) {
		return -1 * _MinchinWeb_C_.Infinity();
	}

	// only those that can carry our cargo
	if (AIEngine.CanRefitCargo(EngineID, Cargo)) {
		// pass
	} else {
		return -1 * _MinchinWeb_C_.Infinity();
	}

	local my_capacity = AIEngine.GetCapacity(EngineID);
	// will be 0..1
	local capacity_factor = 0;
	if (my_capacity == TargetCapacity) {
		capacity_factor = 1.0;
	} else if (my_capacity > TargetCapacity) {
		capacity_factor = TargetCapacity.tofloat() / my_capacity.tofloat();
	} else {
		// my_capacity < TargetCapacity
		capacity_factor = my_capacity.tofloat() / TargetCapacity.tofloat();
	}

	// AIEngine.GetMaxAge() returns a value in (calendar) days
	local max_age = AIEngine.GetMaxAge(EngineID).tofloat() / 365.0;
	local annualize_purchase = AIEngine.GetPrice(EngineID).tofloat() / max_age;

	local costs = 0.0001 + annualize_purchase + AIEngine.GetRunningCost(EngineID).tofloat();
	// AIEngine.GetMaxSpeed() can be divided by 27 to get tiles per day
	local benefits = (
		0.0001
		+ AIEngine.GetCapacity(EngineID).tofloat()
		* (AIEngine.GetReliability(EngineID).tofloat() / 100)
		* (AIEngine.GetMaxSpeed(EngineID).tofloat() / 27 * 365)
	);

	local score = benefits * capacity_factor * 1000 / costs;
	score = score.tointeger();
	_MinchinWeb_Log_.Note(
		"Engine.Rate2 : " + score
		+ " : " + EngineID
		+ " : " + AIEngine.GetName(EngineID)
		+ " : " + AIEngine.GetCapacity(EngineID)
		+ " * (" + AIEngine.GetReliability(EngineID) + " /100)"
		+ " * (" + AIEngine.GetMaxSpeed(EngineID) + " / 27 * 365)"
		+ " * " + capacity_factor
		+ " * 1000"
		+ " / (" + annualize_purchase.tointeger()
		+ " + " + AIEngine.GetRunningCost(EngineID)
		+")",
		7
	);
	return score;
}

function _MinchinWeb_Engine_::Rate3(EngineID, Cargo, MonthlyProduction, TravelDistance, PayDistance = 0, MaxSpend = 0) {
	//	Designed to Run as a validator
	//	Given the EngineID, it will score them; higher is better
	//  Note: Cargo doesn't fully work yet. Capacity is measured in the default
	//	cargo.

	//	payout = Capacity * Payout(Distance, time)
	//	payout{$} = Capacity{ton} * Payout(Distance, time){$/ton}
	//
	//	time = LoadingTime + TravelTime * 2
	//	time = [Capacity / MonthlyProduction] + [ Distance / speed ] * 2
	//	time = [Capacity / MonthlyProduction] * + [ Distance / [speed] ] * 2
	//	time{days} = [Capacity{ton} / MonthlyProduction{ton/month}] * 30{day/month}
	// 					+ [ Distance{tiles} * 100{km/h}/3.6{tiles} / [speed{km/h}] ] * 2
	//
	//	cost = (Purchase Price / Life) + (Running Costs)
	//	cost = (PurchasePrice{$} / Life{year}) + (RunningCosts{$/year})
	//	cost{$/day} = (PurchasePrice{$} / Life{year}) + (RunningCosts{$/year}) * {year}/365{day}
	//
	//	score = payout / time - cost)

	local _magnifier = 1000;
	// only buildable engines
	if (AIEngine.IsBuildable(EngineID)) {
		// pass
	} else {
		return -1 * _MinchinWeb_C_.Infinity() * _magnifier;
	}

	// only return vehicles under our hard cost limit
	if ((MaxSpend > 0) && (AIEngine.GetPrice(EngineID) > MaxSpend)) {
		return -1 * _MinchinWeb_C_.Infinity() * _magnifier;
	}

	// only those that can carry our cargo
	if (AIEngine.CanRefitCargo(EngineID, Cargo)) {
		// pass
	} else {
		return -1 * _MinchinWeb_C_.Infinity() * _magnifier;
	}

	if (PayDistance == 0) {
		PayDistance = TravelDistance;
	}

	local time = AIEngine.GetCapacity(EngineID).tofloat() / MonthlyProduction.tofloat() * 30;
	time += (TravelDistance.tofloat() * 100.0 / 3.6 / AIEngine.GetMaxSpeed(EngineID).tofloat()) * 2;

	// AIEngine.GetMaxAge() returns a value in (calendar) days
	local _max_age = AIEngine.GetMaxAge(EngineID).tofloat();
	local _daily_purchase = AIEngine.GetPrice(EngineID).tofloat() / _max_age;
	local cost = _daily_purchase;
	cost += AIEngine.GetRunningCost(EngineID).tofloat() / 365.0;

	local payout = AICargo.GetCargoIncome(Cargo, PayDistance, time.tointeger());
	payout *= AIEngine.GetCapacity(EngineID);
	payout = payout.tofloat();

	local score = payout / time - cost;
	// scale up scores so integers can be used
	score *= _magnifier;

	score = score.tointeger();
	_MinchinWeb_Log_.Note(
		"Engine.Rate3 : " + score
		+ " : " + EngineID
		+ " : " + AIEngine.GetName(EngineID)
		+ " : " + AIEngine.GetCapacity(EngineID) + " tons"
		+ " : " + payout
		+ " / " + time
		+ " - " + cost
		+ " * " + _magnifier,
		7
	);
	return score;
}

// EOF
