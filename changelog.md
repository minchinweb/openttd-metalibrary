Changelog
===============================================================================

Version 11                                                               {#v11}
===============================================================================
Released 2025-09-30

- better ship selection features
- introductory functions for streetcar support

Version 10                                                               {#v10}
===============================================================================
Prepared 2025-07-14

- allow option to replace null values (rather than crash) when converting
  Arrays (and Arrays of Tiles) to strings (see [WmDOT Issue
  18](https://github.com/minchinweb/openttd-wmdot/issues/18))
- return a buoy count of zero on an unfinished ship path (see [WmDOT Issues
  15](https://github.com/minchinweb/openttd-wmdot/issues/15) and
  [17](https://github.com/minchinweb/openttd-wmdot/issues/17))
- add `Extras.MultiMax()` function

Version 9                                                                 {#v9}
===============================================================================
Released 2015-01-10

- bug fix to Python build script (specifically, fix NoGo library version)
- update build script to work with Python 3000

Version 8                                                                 {#v8}
===============================================================================
Released 2014-03-10

- speed up Lakes by 9-30x
- Fix bug in Array.ToStringTiles2D()

Version 7                                                                 {#v7}
===============================================================================
Released 2014-02-28

- Added Lakes as a replacement for WaterBodyCheck
- Ship Pathfinder now uses Lakes rather than WaterBodyCheck
- Ship Pathfinder now makes sure every point is in the same waterbody before
    adding it to the path
- WaterBodyCheck is now deprecated in favour of Lakes
- Documentation for MetaLibrary is now online at
    [Minchin.ca](http://minchin.ca/openttd-metalibrary)
- Fix array creation bugs in Array.Create2D(), Array.Create3D()
- Added Array.RemoveDuplicates(Array)
- Added Array.ToAIList(Array)
- Added Extras.MinDistance(TileID, TargetArray); can be used as a valuator
- Split Constants from Extras (file only, function access remains the same)
- Split Industry from Extras (file only, function access remains the same)
- Split Station from Extras (file only, function access remains the same)
- Bumped maximum Log `Debug_Level` to 8
- Added separate Changelog file
- Rename `Readme.txt` to `Readme.md`
- Update requirement to Fibonacci Heap, v.3

Version 6                                                                 {#v6}
===============================================================================
Released 2012-12-31

- Added Dominion Land System (DLS) which allows for grid based pathfinding
- Update license statement
- Moved source code to
    [GitHub](https://github.com/MinchinWeb/openttd-metalibrary/) and
    updated URL's
- Road Pathfinder no longer chokes if a bridge doesn't have a parent path

Version 5                                                                 {#v5}
===============================================================================
Released 2012-06-27

- Added MinchinWeb.Station.IsNextToDock(TileID)
- Added MinchinWeb.Marine.RankShips(EngineID, Life, Cargo)
- Added MinchinWeb.Marine.NearestDepot(TileID)
- Ship depot builder no longer will build the depot next to a dock

Version 4                                                                 {#v4}
===============================================================================
Released 2012-01-30

- Added Log
- Bug fix to Spiral Walker

Version 3                                                                 {#v3}
===============================================================================
Released 2012-01-14
- Minor update; released to coincide with the release of WmDOT v8
- Bug fixes and improvements to the Ship and Road Pathfinder
- Road Pathfinder can now bridge over canals, rivers, and railroads

Version 2                                                                 {#v2}
===============================================================================
Released 2012-01-11

- Major update; released to coincide with the release of WmDOT v7
- Added the Ship Pathfinder (v2), Line Walker (v1), and Atlas (v1) classes
- Added Constants, Station, Industry, and Marine (v1) class functions
- Updated Extras (v.2) and Arrays (v.3)

Version 1                                                                 {#v1}
===============================================================================
Released 2011-04-28

- Initial public release; released to coincide with the release of WmDOT v6
- Included Arrays v2, Extras v1, Road Pathfinder v7, Spiral Walker v2, and
    Waterbody Check v1
