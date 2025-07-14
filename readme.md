About MetaLibrary                                                   {#mainpage}
===============================================================================

MetaLibrary is the collection of code I've written for
[WmDOT](http://www.tt-forums.net/viewtopic.php?f=65&t=53698), my AI for
[OpenTTD](http://www.openttd.org/), that I felt should properly be in a
library. Separating my AI from this library has made it easier to write my
AI, but I also hope will this code will help some aspiring AI writer get off
the ground a little bit faster. ;)

GameScript
===============================================================================
A GameScript version of this library is also available. All functions are
available, although some may require an active company context.

Sub-Libraries Available                                         {#sublibraries}
===============================================================================

- `%MinchinWeb.Atlas` ← \_MinchinWeb\_Atlas\_
    - given a list of 'sources' and 'attractions', will weight the combinations
        and generate a list of pairs to connect.
- `%MinchinWeb.Array` ← \_MinchinWeb\_Array\_
    - Array functions
- `%MinchinWeb.Constants` ← \_MinchinWeb\_C\_
- `%MinchinWeb.DLS` ← \_MinchinWeb\_DLS\_
    - **Dominion Land System** -- a wrapper on the road pathfinder to encourage
      roads to be built on a grid.
- `%MinchinWeb.Extras` ← \_MinchinWeb\_Extras\_
    - Extra functions, for things like math, map geometry, ship support, etc.
- `%MinchinWeb.Lakes` ← \_MinchinWeb\_Lakes\_
    - **Lakes** serves as a check to determine if two points are in the same
      waterbody. It was written as a replacement for Waterbody Check. Lakes
      remembers the work it has previously done, which makes subsequent requests
      much faster.
- `%MinchinWeb.LineWalker` ← \_MinchinWeb\_LW\_
    - **Line Walker** -- walk the map between two points, or start at a given
      point and walk out at a given slope.
- `%MinchinWeb.Log` ← \_MinchinWeb\_Log\_
    - help (dynamically) control the amount of debugging output displayed.
- `%MinchinWeb.Industry` ← \_MinchinWeb\_Industry\_
- `%MinchinWeb.Marine` ← \_MinchinWeb\_Marine\_
    - Marine and ship related functions.
- `%MinchinWeb.ShipPathfinder` ← \_MinchinWeb\_ShipPathfinder\_
    - A geometry based Ship Pathfinder.
- `%MinchinWeb.SpiralWalker` ← \_MinchinWeb\_SW\_
    - **Spiral Walker** -- allows you to define a starting point, and then
      'walk' all the tiles in a spiral outward. It was originally used to find a
      buildable spot for my HQ in WmDOT, but is useful for many other things as
      well.
- `%MinchinWeb.Station` ← \_MinchinWeb\_Station\_
    - some station related functions
- `%MinchinWeb.RoadPathfinder` ← \_MinchinWeb\_RoadPathfinder\_
    - Based on NoAI Team's pathfinder. The pathfinder uses the A* search pattern
      and includes functions to find the path, determine its cost, and build it.
      Can bridge over rivers, canals, and railroad tracks.
- `%MinchinWeb.WaterbodyCheck` ← \_MinchinWeb\_WBC\_
    - **Note**: Waterbody Check has been deprecated in favour of Lakes
    - Waterbody Check - in effect a specialized pathfinder. It serves to check
      whether two points are in the same waterbody (i.e. a ship could travel
      between them). It is optimized to run extremely fast (I hope!). It can be
      called separately, but was originally designed as a pre-run check for my
      Ship Pathfinder.

Changelog
===============================================================================
### Version 9

Released 2015-01-10

- bug fix to Python build script (specifically, fix NoGo library version)
- update build script to work with Python 3000

Read the complete [Changelog](md_openttd-metalibrary_changelog.html).

Installation                                                    {#installation}
===============================================================================

The easiest way install MetaLibrary is the use the in-game downloader in
OpenTTD.

If you want to manually install it, download the folder and place it in your
`../OpenTTD/ai/library/` folder.

For you to use the library in your AI's you'll need to import it. Somewhere
outside of any other class or function, add an import statement like:

    Import("util.MinchinWeb", "MinchinWeb", 10);

Requirements                                                    {#requirements}
===============================================================================

If installed from the in-game downloader, the dependencies will
automatically be downloaded and installed. Otherwise, you'll need the
following libraries:

- [Binary Heap], v.1    (`Queue.BinaryHeap-1.tar`)  
- [Fibonacci Heap], v.3 (`Queue.FibonacciHeap-3.tar`)
- [Graph.AyStar], v.6   (`Graph.AyStar-6.tar`)

[Binary Heap]: https://bananas.openttd.org/package/ai-library/51554248
[Graph.AyStar]: https://bananas.openttd.org/package/ai-library/4752412a
[Fibonacci Heap]: https://bananas.openttd.org/package/ai-library/51554648

OpenTTD is able to read uncompressed `tar` files without any problem.

FAQ                                                                      {#faq}
===============================================================================

**Q:**  How do I use the sub-libraries directly?

**A:**  Import the main library, and then create global points to the
        sub-libaries you want to use. Eg:

~~~
        Import("util.MinchinWeb", "MinchinWeb", 9);
        Arrays <- MinchinWeb.Arrays;
~~~

*Info:* See the sub-library files for the functions available and their
            implementation.

**Q:**  What is the \_MinchinWeb\_ ... all over the place?

**A:**  I can't answer it better than Zuu when he put together his SuperLib, so
        I'll quote him.

> " Unfortunately due to constraints in OpenTTD and Squirrel, only the
>   main class of a library will be renamed at import. For [MetaLib]
>   that is the [MetaLib] class in this file. Every other class in this
>   file or other .nut files that the library is built up by will end
>   up at the global scope at the AI that imports the library. The
>   global scope of the library will get merged with the global scope
>   of your AI.
>
> " To reduce the risk of causing you conflict problems this library
>   prefixes everything that ends up at the global scope of AIs with
>   [ \_MinchinWeb\_ ]. That is also why the library is not named Utils or
>   something with higher risk of you already having at your global
>   scope.
>
> " You should however never need to use any of the [ \_MinchinWeb\_ ... ]
>   names as a user of this library. It is not even recommended to do
>   so as it is part of the implementation and could change without
>   notice. "
>
> -- Zuu, SuperLib v.7 documentation

A grand 'Thank You' to Zuu for his SuperLib that provided a very useful
    model, to all the NoAI team to their work on making the AI system work,
    and to everyone that has brought us the amazing game of OpenTTD.

License                                                              {#license}
===============================================================================

**Minchinweb's MetaLibrary** v.9 [2015-01-10]

Copyright © 2011-15 by W. Minchin.
For more info,
    please visit <https://github.com/MinchinWeb/openttd-metalibrary>

Permission is granted to you to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell this software, and provide these
rights to others, provided:

- The above copyright notice and this permission notice shall be included
    in all copies or substantial portions of the software.
- Attribution is provided in the normal place for recognition of 3rd party
    contributions.
- You accept that this software is provided to you "as is", without warranty.

\note   \_MinchinWeb\_RoadPathfinder\_ is separately licensed under
        LGPL v.2.1.

Links                                                                  {#links}
===============================================================================
-   Discussion thread for MetaLibarary on TT-Forums --
    <http://www.tt-forums.net/viewtopic.php?f=65&t=57903>
-   MetaLibrary code, hosted on GitHub --
    <https://github.com/MinchinWeb/openttd-metalibrary/>
-   MetaLibrary documentation --
    <http://minchin.ca/openttd-metalibrary/>

Notes To Me                                                            {#notes}
===============================================================================
\todo       Notes about static classes, what they are, and which classes
            are 'static'  
\todo       Consider Fibonacci Heap version in NoCAB  
\todo       Add picture of the in-game downloader  
\todo       Look into theming dOxygen output  
\todo       Add 'News' tab pointing back to my Blog updates on MetaLibrary  
