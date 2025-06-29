/*	Array SubLibrary, v.6 [2014-03-03],
 *		part of Minchinweb's MetaLibrary v.8,
 *		originally part of WmDOT v.5  r.53d	[2011-04-09]
 *			and WmArray library v.1  r.1 [2011-02-13].
 *	Copyright © 2011-14 by W. Minchin. For more info,
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

/**	\brief		Array
 *	\version	v.5 (2014-02-28)
 *	\author		W. Minchin (%MinchinWeb)
 *	\since		MetaLibrary v.6
 *
 *	This is a collection of functions to make working with Arrays easier.
 *	\note	While Arrays are powerful, also consider using
 *			[AIList](http://noai.openttd.org/api/trunk/classAIList.html)'s.
 */


class _MinchinWeb_Array_ {
	main = null;

	/**	\publicsection
	 *	\brief	Creates a one dimensional (1-D) array.
	 *	\param	length	the desired length of the array
	 *	\return	empty array of the given size
	 *	\see	Create2D()
	 *	\see	Create3D()
	 *	\static
	 */
	function Create1D(length) { return array[length]; }

	/**	\brief	Creates a two dimensional (2-D) array.
	 *	\param	length	the desired length of the array (in the first
	 *					dimension)
	 *	\param	width	the desired length of the array (in the second
	 *					dimension)
	 *	\return	empty array of the given size (in two dimensions)
	 *	\see	Create1D()
	 *	\see	Create3D()
	 *	\static
	 */
	function Create2D(length, width);

	/**	\brief	Creates a three dimensional (3-D) array.
	 *	\param	length	the desired length of the array (in the first
	 *					dimension)
	 *	\param	width	the desired length of the array (in the second
	 *					dimension)
	 *	\param	height	the desired length of the array (in the third
	 *					dimension)
	 *	\return	empty array of the given size (in three dimensions)
	 *	\see	Create1D()
	 *	\see	Create2D()
	 *	\static
	 */
	function Create3D(length, width, height);

	/**	\brief	Converts a one dimensional array to a nice string format.
	 *
	 *	This function was created to aid in the output of arrays to the AI
	 *	debug screen.
	 *	\param	InArray		one dimensional (1-D) array
	 *	\param	DisplayLength	whether to prefix the output with the length
	 *							of the array
	 *	\param	replaceNull		whether the replace `null` values with '-'
	 *	\return	string version of array. e.g. `The array is 3 long.  3  4  5`.
	 *	\return	`null` if `InArray` is `null`.
	 *	\see	ToString2D()
	 *	\see	ToStringTiles1D()
	 *	\todo	Add error check that an array is provided
	 *	\static
	 */
	function ToString1D(InArray, DisplayLength = true, replaceNull = false);

	/**	\brief	Converts a one dimensional array to a nice string format.
	 *
	 *	This function was created to aid in the output of arrays to the AI
	 *	debug screen.
	 *	\param	InArray			two dimensional (2-D) array
	 *	\param	DisplayLength	whether to prefix the output with the length
	 *							of the array
	 *	\return	string version of array.
	 *			e.g. `The array is 2 long.  3  4  /  5  6`.
	 *	\return	`null` if `InArray`
	 *			is `null`.
	 *	\see	ToString1D()
	 *	\see	ToStringTiles2D()
	 *	\todo	Add error check that a 2D array is provided
	 *	\static
	 */
	function ToString2D(InArray, DisplayLength = true);

	/**	\brief	Searches an array for a given value.
	 *
	 *	\param	InArray		array to search
	 *						(assumed to be one dimensional (1-D))
	 *	\param	SearchValue	what is searched for
	 *	\return	`true` if found at least once, `false` if not. `null` if
	 *			`InArray` is `null`.
	 *	\see	ContainedIn1DIn2D()
	 *	\see	ContainedIn2D()
	 *	\see	ContainedIn3D()
	 *	\see	Find1D()
	 *	\todo	Add error check that an array is provided
	 *	\static
	 */
	function ContainedIn1D(InArray, SearchValue);

	/**	\brief	Searches a (two dimensional) array for a given value.
	 *	\param	InArray		array to search
	 *						(assumed to be two dimensional (2-D))
	 *	\param	SearchValue	what is searched for
	 *	\return	`true` if found at least once, `false` if not. `null` if
	 *			`InArray` is `null`.
	 *	\note	using this to see if an given array is an element of the parent
	 *			array does not seem to be returning expected results. Use
	 *			ContainedInPairs() instead.
	 *	\see	ContainedInPairs()
	 *	\see	ContainedIn1DIn2D()
	 *	\see	ContainedIn1D()
	 *	\see	ContainedIn3D()
	 *	\see	Find2D()
	 *	\todo	Add error check that an array is provided
	 *	\static
	 */
	function ContainedIn2D(InArray, SearchValue);

	/**	\brief	Searches a (three dimensional) array for a given value.
	 *	\param	InArray		array to search
	 *						(assumed to be three dimensional (3-D))
	 *	\param	SearchValue	what is searched for
	 *	\return	`true` if found at least once, `false` if not. `null` if
	 *			`InArray` is `null`.
	 *	\see	Find3D()
	 *	\todo	Add error check that an array is provided
	 *	\static
	 */
	function ContainedIn3D(InArray, SearchValue);

	/**	\brief	Searches a two dimensional array for a given one dimensional array.
	 *	\param	InArray		array to search
	 *						(assumed to be two dimensional (2-D))
	 *	\param	SearchValue	array to search for
	 *						(assumed to be one dimensional (1-D))
	 *	\return	`true` if found at least once, `false` if not.  `null` if
	 *			`InArray` is `null`.
	 *	\see	ContainedIn1D()
	 *	\todo	Add error check that arrays are provided
	 *	\static
	 */
	function ContainedIn1DIn2D(InArray2D, SearchArray1D);

	/**	\brief	Searches an array for a given value.
	 *	\param	InArray			array to search
	 *							(assumed to be two dimensional (2-D))
	 *	\param	SearchArray		array to search for
	 *							(assumed to be one dimensional (1-D))
	 *	\return	array index of the first time `SearchValue` is found (as an
	 *			integer), `false` if not. `null` if `InArray` is `null`.
	 *	\see	ContainedIn1D()
	 *	\see	Find2D()
	 *	\see	Find3D()
	 *	\see	FindPairs()
	 *	\note	using this to see if an given array is an element of the parent
	 *			array does not seem to be returning expected results. Use
	 *			FindPairs() instead.
	 *	\todo	Add error check that an array is provided
	 *	\static
	 */
	function Find1D(InArray, SearchValue);

	/**	\brief	Searches an array for a given value.
	 *	\param	InArray		array to search
	 *						(assumed to be two dimensional (2-D))
	 *	\param	SearchValue	what is searched for
	 *	\return	array index of the first time `SearchValue` is found (as an
	 *			two dimensional array, of the from `[i, j]`), `false` if not.
	 *			`null` if `InArray` is `null`.
	 *	\see	ContainedIn2D()
	 *	\see	Find1D()
	 *	\see	Find3D()
	 *	\todo	Add error check that an array is provided
	 *	\static
	 */
	function Find2D(InArray, SearchValue);

	/**	\brief	Searches an array for a given value.
	 *	\param	InArray		array to search
	 *						(assumed to be three dimensional (3-D))
	 *	\param	SearchValue	what is searched for
	 *	\return	array index of the first time `SearchValue` is found (as an
	 *			three dimensional array, of the from `[i, j, k]`), `false` if
	 *			not. `null` if `InArray` is `null`.
	 *	\see	ContainedIn3D()
	 *	\see	Find1D()
	 *	\see	Find2D()
	 *	\todo	Add error check that an array is provided
	 *	\static
	 */
	function Find3D(InArray, SearchValue);

	/**	\brief	Removes an element from the array.
	 *
	 *	Removes the value at the index, and shifts the rest of the array to the
	 *	left. The returned array is thus one shorter than the supplied array.
	 *	\param	InArray		the array to remove the element from
	 *	\param	Index		the index of the element to remove
	 *	\return	`InArray` sans the element at `Index`, the elements beyond it
	 *			are shifted to the left.
	 *	\todo	Add error check that an array is provided
	 *	\static
	 */
	function RemoveValueAt(InArray, Index);

	/**	\brief	Adds an element from the array.
	 *
	 *	Adds `Value` to the `InArray` at the given `Index`. The rest of the
	 *	array is shifted one place to the right. The returned array is thus one
	 *	longer than `InArray`.
	 *	\param	InArray		the array to add the element to
	 *	\param	Index		the index of where to add `Value` at
	 *	\param	Value		the element to add
	 *	\return	`InArray`, now with the element `Value` at `Index`, the elements
	 *			beyond it shifted to the right.
	 *	\todo	Add error check that an array is provided
	 *	\todo	Add error check that `Index` is reasonable
	 *	\static
	 */
	function InsertValueAt(InArray, Index, Value);

	/**	\brief	Converts a one dimensional array of tiles to a nice string format.
	 *
	 *	This function was created to aid in the output of arrays of tiles to the
	 *	AI debug screen.
	 *	\param	InArrayOfTiles		one dimensional (1-D) array of Tiles
	 *	\param	ArrayLength	(`true` or `false`) whether to print the prefix
	 *						noting the length of the array. Default is `false`.
	 *	\return	string version of array. e.g. `The array is 3 long.  12,45
	 *			62,52  59,10`.
	 *	\return	`null` if `InArrayOfTiles` is `null`.
	 *	\see	ToString1D()
	 *	\see	ToStringTiles2D()
	 *	\todo	Add error check that an array is provided
	 *	\todo	Add a better error message if you try and feed it not a 1-D array
	 *	\static
	 */
	function ToStringTiles1D(InArrayOfTiles, ArrayLength = false);

	/**	\brief	Converts a one dimensional array of tiles to a nice string format.
	 *
	 *	This function was created to aid in the output of arrays of tiles to the
	 *	AI debug screen.
	 *	\param	InArrayOfTiles	two dimensional (2-D) array of Tiles
	 *	\param	ArrayLength		(`true` or `false`) whether to print the prefix
	 *							noting the length of the array. Default is
	 *							`false`.
	 *	\return	string version of array. e.g. `The array is 2 long.  12,45
	 *			62,52  /  59,10  5,37`.
	 *	\return	`null` if `InArrayOfTiles` is `null`.
	 *	\see	ToString2D()
	 *	\see	ToStringTiles1D()
	 *	\todo	Add error check that an array is provided
	 *	\todo	Add a better error message if you try and feed it not a 2-D array
	 *	\static
	 */
	function ToStringTiles2D(InArrayOfTiles, ArrayLength = false);

	/**	\brief	Searches an array for a given pair of values.
	 *
	 *	The idea is to provide an array of arrays of pairs (e.g. tile x and tile
	 *	y, starting and ending points, etc.), and find out if `SearchValue1` and
	 *	`SearchValue2` are among the pairs. The order that `SearchValue1` and
	 *	`SearchValue2` is not considered.
	 *	\param	InArray2D		two dimensional (2-D) array
	 *	\param	SearchValue1	values to search for
	 *	\param	SearchValue2	values to search for
	 *	\return	index (as an integer) of the array matching the search values.
	 *			`null` if `InArray2D` is `null`.
	 *	\see	ContainedInPairs()
	 *	\todo	Add error check that a 2D array is provided
	 *	\static
	 */
	function FindPairs(InArray2D, SearchValue1, SearchValue2);

	/**	\brief	Searches an array for a given pair of values.
	 *
	 *	The idea is to provide an array of arrays of pairs (e.g. tile x and tile
	 *	y, starting and ending points, etc.), and find out if `SearchValue1` and
	 *	`SearchValue2` are among the pairs. The order that `SearchValue1` and
	 *	`SearchValue2` are in is not considered.
	 *	\param	InArray2D		two dimensional (2-D) array
	 *	\param	SearchValue1	value to search for
	 *	\param	SearchValue2	value to search for
	 *	\return	`true` if the search values are found at least once, `false`
	 *			otherwise. `null` if `InArray2D` is `null`.
	 *	\see	FindInPairs()
	 *	\todo	Add error check that a 2D array is provided
	 *	\static
	 */
	function ContainedInPairs(InArray2D, SearchValue1, SearchValue2);

	/**	\brief	Compares the two arrays item for item.
	 *
	 *	Returns true if every item pair matches.
	 *	\param	InArray1D		one dimensional (1-D) array, that is considered
	 *							'known'
	 *	\param	TestArray1D		one dimensional (1-D) array, that is considered
	 *							'unknown'
	 *	\return	`true` if the `InArray1D` and `TestArray1D` equal each other for
	 *			the comparison of each pair of elements. `false` otherwise.
	 *	\note	I wrote this because I don't trust `InArray == TestArray` to
	 *			work this way...
	 *	\static
	 */
	function Compare1D(InArray1D, TestArray1D);

	/**	\brief	Appends one array to another.
	 *	\param	Array1	the first array
	 *	\param	Array2	the second array
	 *	\return	An array that the items has `Array2` appended to the end of the
	 *			items of `Array1`
	 *	\static
	 *	\note	Consider using Squirrel's built-in function:
	 *			`MyArray.append(Item)` to append individual items to an array
	 */
	function Append(Array1, Array2);

	/**	\brief	Removes duplicates from an array.
	 *
	 *	The item is maintain at its first location and removed at all subsequent
	 *	locations.
	 *	\param	Array	array to remove duplicates from
	 *	\return	An array minus the duplicate items.
	 *	\todo	Add error check that an array is provided.
	 *	\static
	 */
	function RemoveDuplicates(Array);

	/**	\brief	Turns an Array in an AIList
	 *	\return	An AIList with the contents of the Array
	 *	\todo	Add error check that an array is provided.
	 *	\static
	 */
	function ToAIList(Array);
};

//	== Function definitions ==================================================

function _MinchinWeb_Array_::Create2D(length, width) {
	local ReturnArray = array(length);
	local tempArray = array(width);
	for (local i=0; i < length; i++) {
		ReturnArray[i] = array(width);
	}
	return ReturnArray;
}

function _MinchinWeb_Array_::Create3D(length, width, height) {
	local ReturnArray = array(length);

	for (local i=0; i < length; i++) {
		ReturnArray[i] = array(width)
		for (local j=0; j < width; j++) {
			ReturnArray[i][j] = array(height);
		}
	}

	return ReturnArray;
}

function _MinchinWeb_Array_::ToString1D(InArray, DisplayLength = true, replaceNull = false) {
	if (InArray == null) {
		return null;
	} else {
		local Length = InArray.len();
		local i = 0;
		local Temp = "";
		while (i < InArray.len() ) {
			if ((replaceNull == true) && (InArray[i] == null)) {
				Temp = Temp + "-" + "  ";
			} else {
				Temp = Temp + InArray[i] + "  ";
			}
			i++;
		}
		if (DisplayLength == true) {
			Temp = "The array is " + Length + " long.  " + Temp;
		}
		return (Temp);
	}
}

function _MinchinWeb_Array_::ToString2D(InArray, DisplayLength = true) {
	if (InArray == null) {
		return null;
	} else {
		local Length = InArray.len();
		local i = 0;
		local Temp = "";
		while (i < InArray.len() ) {
			local InnerArray = [];
			InnerArray = InArray[i];
			local j = 0;
			while (j < InnerArray.len() ) {
				Temp = Temp + InnerArray[j] + "  ";
				j++;
			}
			Temp = Temp + "/  ";
			i++;
		}
		//	get rid of last slash
		if (Temp.len() > 3) {
			Temp = Temp.slice(0, Temp.len() - 3);
		}

		if (DisplayLength == true) {
			Temp = "The array is " + Length + " long.  " + Temp;
		}
		return (Temp);
	}
}

function _MinchinWeb_Array_::ContainedIn1D(InArray, SearchValue) {
	if (InArray == null) {
		return null;
	} else {
		for (local i = 0; i < InArray.len(); i++ ) {
				if (InArray[i] == SearchValue) {
					return true;
				}
		}
		return false;
	}
}

function _MinchinWeb_Array_::ContainedIn2D(InArray, SearchValue) {
	if (InArray == null) {
		return null;
	} else {
		for (local i = 0; i < InArray.len(); i++ ) {
			for (local j=0; j < InArray[i].len(); j++ ) {
				if (InArray[i][j] == SearchValue) {
					return true;
				}
			}
		}
		return false;
	}
}

function _MinchinWeb_Array_::ContainedIn3D(InArray, SearchValue) {
	if (InArray == null) {
		return null;
	} else {
		for (local i = 0; i < InArray.len(); i++ ) {
			for (local j=0; j < InArray[i].len(); j++ ) {
				for (local k=0; k < InArray[i].len(); k++)
					if (InArray[i][j][k] == SearchValue) {
						return true;
					}
			}
		}
		return false;
	}
}

function _MinchinWeb_Array_::ContainedIn1DIn2D(InArray2D, SearchArray1D) {
	if (InArray2D == null) {
		return null;
	} else {
		for (local i = 0; i < InArray2D.len(); i++ ) {
			if (_MinchinWeb_Array_.Compare1D(InArray2D[i], SearchArray1D) == true) {
				return true;
			}
		}
		return false;
	}
}

function _MinchinWeb_Array_::Find1D(InArray, SearchValue) {
	if (InArray == null) {
		return null;
	} else {
		for (local i = 0; i < InArray.len(); i++ ) {
				if (InArray[i] == SearchValue) {
					return i;
				}
		}
		return false;
	}
}

function _MinchinWeb_Array_::Find2D(InArray, SearchValue) {
	if (InArray == null) {
		return null;
	} else {
		for (local i = 0; i < InArray.len(); i++ ) {
			for (local j=0; j < InArray[i].len(); j++ ) {
				if (InArray[i][j] == SearchValue) {
					return [i, j];
				}
			}
		}
		return false;
	}
}

function _MinchinWeb_Array_::Find3D(InArray, SearchValue) {
	if (InArray == null) {
		return null;
	} else {
		for (local i = 0; i < InArray.len(); i++ ) {
			for (local j=0; j < InArray[i].len(); j++ ) {
				for (local k=0; k < InArray[i].len(); k++)
					if (InArray[i][j][k] == SearchValue) {
						return [i,j,k];
					}
			}
		}
		return false;
	}
}

function _MinchinWeb_Array_::RemoveValueAt(InArray, Index) {
	local i = 0;
	local Return = [];

	for (i; i < Index; i++) {
		Return.push(InArray[i]);
	}
	i++;
	for (i; i < InArray.len(); i++) {
		Return.push(InArray[i]);
	}
	return Return;
}

function _MinchinWeb_Array_::InsertValueAt(InArray, Index, Value) {
	local i = 0;
	local Return = [];

	for (i; i < Index; i++) {
		Return.push(InArray[i]);
	}
	Return.push(Value);
	for (i; i < InArray.len(); i++) {
		Return.push(InArray[i]);
	}
	return Return;
}

function _MinchinWeb_Array_::ToStringTiles1D(InArrayOfTiles, ArrayLength = false) {
	if (InArrayOfTiles == null) {
		return null;
	} else {
		local Length = InArrayOfTiles.len();
		local Temp = "";
		foreach (Tile in InArrayOfTiles) {
			Temp = Temp + "  " + AIMap.GetTileX(Tile) + "," + AIMap.GetTileY(Tile);
		}
		if (ArrayLength == true) {
			Temp = "The array is " + Length + " long.  " + Temp;
		}
		return Temp;
	}
}

function _MinchinWeb_Array_::ToStringTiles2D(InArrayOfTiles, ArrayLength = false) {
	if (InArrayOfTiles == null) {
		return null;
	} else {
		local Length = InArrayOfTiles.len();
		local i = 0;
		local Temp = "";
		while (i < InArrayOfTiles.len() ) {
			local InnerArray = [];
			InnerArray = InArrayOfTiles[i];
			local j = 0;
			while (j < InnerArray.len() ) {
				Temp = Temp + AIMap.GetTileX(InnerArray[j]) + "," + AIMap.GetTileY(InnerArray[j]) + "  ";
				j++;
			}
			Temp = Temp + "/  ";
			i++;
		}
		//	get rid of last slash
		if (Temp.len() > 3) {
			Temp = Temp.slice(0, Temp.len() - 3);
		}

		if (ArrayLength == true) {
			Temp = "The array is " + Length + " long.  " + Temp;
		}
		return (Temp);
	}
}

function _MinchinWeb_Array_::FindPairs(InArray2D, SearchValue1, SearchValue2) {
	if (InArray2D == null) {
		return null;
	} else {
		local Return1 = false;
		local Return2 = false;
		for (local i = 0; i < InArray2D.len(); i++ ) {
			for (local j=0; j < InArray2D[i].len(); j++ ) {
				if ((InArray2D[i][j] == SearchValue1) && !Return1) {
					Return1 = true;
				} else if (InArray2D[i][j] == SearchValue2) {
					Return2 = true;
				}
			}
			if (Return1 && Return2) {
				return i;
			} else {
				Return1 = false;
				Return2 = false;
			}
		}
		return false;
	}
}

function _MinchinWeb_Array_::ContainedInPairs(InArray2D, SearchValue1, SearchValue2) {
	if (InArray2D == null) {
		return null;
	} else {
		local Return1 = false;
		local Return2 = false;
		for (local i = 0; i < InArray2D.len(); i++ ) {
			for (local j=0; j < InArray2D[i].len(); j++ ) {
				if ((InArray2D[i][j] == SearchValue1) && !Return1) {
					Return1 = true;
				} else if (InArray2D[i][j] == SearchValue2) {
					Return2 = true;
				}
			}
			if (Return1 && Return2) {
				return true;
			} else {
				Return1 = false;
				Return2 = false;
			}
		}
		return false;
	}
}

function _MinchinWeb_Array_::Compare1D(InArray1D, TestArray1D) {
	if (InArray1D.len() != TestArray1D.len() ) {
		return false;
	}
	for (local i = 0; i < InArray1D.len(); i++) {
		if (InArray1D[i] != TestArray1D[i]) {
			return false;
		}
	}

	return true;
}

function _MinchinWeb_Array_::Append(Array1, Array2) {
	local ReturnArray = [];
	for (local i=0; i < Array1.len(); i++) {
		ReturnArray.push(Array1[i]);
	}
	for (local i=0; i < Array2.len(); i++) {
		ReturnArray.push(Array2[i]);
	}

	return ReturnArray;
}

function _MinchinWeb_Array_::RemoveDuplicates(Array) {
	local ReturnArray = Array;
	for (local i=0; i < ReturnArray.len(); i++) {
		for (local j=i+1; j < ReturnArray.len(); j++) {
			if (ReturnArray[i] == ReturnArray[j]) {
				ReturnArray = _MinchinWeb_Array_.RemoveValueAt(ReturnArray, j);
				j--;
			}
		}
	}
	return ReturnArray;
}

function _MinchinWeb_Array_::ToAIList(Array) {
	local list = AIList();
	foreach (item in Array) {
		list.AddItem(item, 0);
	}
	return list;
}
// EOF
