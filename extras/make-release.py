#! python34
# -*- coding: utf-8 -*-

#   Minchinweb's MetaLibrary v.9 [2015-01-10],
#   Copyright © 2011-15 by W. Minchin. For more info,
#       please visit https://github.com/MinchinWeb/openttd-metalibrary
#
#   Permission is granted to you to use, copy, modify, merge, publish,
#   distribute, sublicense, and/or sell this software, and provide these
#   rights to others, provided:
#
#   + The above copyright notice and this permission notice shall be included
#       in all copies or substantial portions of the software.
#   + Attribution is provided in the normal place for recognition of 3rd party
#       contributions.
#   + You accept that this software is provided to you "as is", without warranty.
#

"""This script is a Python script to generate a tar file of MetaLibrary for
upload to BaNaNaS. v2.0.2 [2015-01-10]"""

import codecs
import os
import re
import shutil
import tarfile
from os.path import join

SourceDir = join("..")
OutputDir = join("..", "releases")
TempDir = join("..", "temp")
if not os.path.exists(OutputDir):
    os.makedirs(OutputDir)
if not os.path.exists(TempDir):
    os.makedirs(TempDir)


def multiple_replacer(*key_values):
    """multiple replacement"""
    # from  http://stackoverflow.com/questions/6116978/python-replace-multiple-strings
    #
    # Usage:
    # >>> replacements = (u"café", u"tea"), (u"tea", u"café"), (u"like", u"love")
    # >>> print multiple_replace(u"Do you like café? No, I prefer tea.", *replacements)
    # Do you love tea? No, I prefer café.
    replace_dict = dict(key_values)
    replacement_function = lambda match: replace_dict[match.group(0)]
    pattern = re.compile("|".join([re.escape(k) for k, v in key_values]), re.M)
    return lambda string: pattern.sub(replacement_function, string)


def multiple_replace(string, *key_values):
    return multiple_replacer(*key_values)(string)


mdReplacements = ("%MinchinWeb", "MinchinWeb"), ("\\_", "_"), ("←", "<-")

aimdReplacements = (
    ("v.3 (`Queue.FibonacciHeap-3.tar`)", "v.2 (`Queue.FibonacciHeap-2.tar`)"),
    (
        "https://bananas.openttd.org/package/ai-library/51554248",
        "https://bananas.openttd.org/package/game-script-library/47514248",
    ),
    (
        "https://bananas.openttd.org/package/ai-library/4752412a",
        "https://bananas.openttd.org/package/game-script-library/4747412a",
    ),
    (
        "https://bananas.openttd.org/package/ai-library/51554648",
        "https://bananas.openttd.org/package/game-script-library/47514648",
    ),
    ("`../OpenTTD/ai/library/`", "`../OpenTTD/gs/library/`"),
)

aiReplacements = (
    ('"queue.fibonacci_heap", "", 3);', '"queue.fibonacci_heap", "", 2);'),
    ("Fibonacci Heap v.3", "Fibonacci Heap v.2"),
    ("AIAccounting", "GSAccounting"),
    ("AIAirport", "GSAirport"),
    ("AIBase", "GSBase"),
    ("AIBaseStation", "GSBaseStation"),
    ("AIBridge", "GSBridge"),
    ("AIBridgeList", "GSBridgeList"),
    ("AIBridgeList_Length", "GSBridgeList_Length"),
    ("AICargo", "GSCargo"),
    ("AICargoList", "GSCargoList"),
    ("AICargoList_IndustryAccepting", "GSCargoList_IndustryAccepting"),
    ("AICargoList_IndustryProducing", "GSCargoList_IndustryProducing"),
    ("AICargoList_StationAccepting", "GSCargoList_StationAccepting"),
    ("AICompany", "GSCompany"),
    ("AIController", "GSController"),
    ("AIDate", "GSDate"),
    ("AIDepotList", "GSDepotList"),
    ("AIEngine", "GSEngine"),
    ("AIEngineList", "GSEngineList"),
    ("AIError", "GSError"),
    ("AIEvent", "GSEvent"),
    ("AIEventAircraftDestTooFar", "GSEventAircraftDestTooFar"),
    ("AIEventCompanyAskMerger", "GSEventCompanyAskMerger"),
    ("AIEventCompanyBankrupt", "GSEventCompanyBankrupt"),
    ("AIEventCompanyInTrouble", "GSEventCompanyInTrouble"),
    ("AIEventCompanyMerger", "GSEventCompanyMerger"),
    ("AIEventCompanyNew", "GSEventCompanyNew"),
    ("AIEventCompanyTown", "GSEventCompanyTown"),
    ("AIEventController", "GSEventController"),
    ("AIEventDisasterZeppelinerCleared", "GSEventDisasterZeppelinerCleared"),
    ("AIEventDisasterZeppelinerCrashed", "GSEventDisasterZeppelinerCrashed"),
    ("AIEventEngineAvailable", "GSEventEngineAvailable"),
    ("AIEventEnginePreview", "GSEventEnginePreview"),
    ("AIEventExclusiveTransportRights", "GSEventExclusiveTransportRights"),
    ("AIEventIndustryClose", "GSEventIndustryClose"),
    ("AIEventIndustryOpen", "GSEventIndustryOpen"),
    ("AIEventRoadReconstruction", "GSEventRoadReconstruction"),
    ("AIEventStationFirstVehicle", "GSEventStationFirstVehicle"),
    ("AIEventSubsidyAwarded", "GSEventSubsidyAwarded"),
    ("AIEventSubsidyExpired", "GSEventSubsidyExpired"),
    ("AIEventSubsidyOffer", "GSEventSubsidyOffer"),
    ("AIEventSubsidyOfferExpired", "GSEventSubsidyOfferExpired"),
    ("AIEventTownFounded", "GSEventTownFounded"),
    ("AIEventVehicleCrashed", "GSEventVehicleCrashed"),
    ("AIEventVehicleLost", "GSEventVehicleLost"),
    ("AIEventVehicleUnprofitable", "GSEventVehicleUnprofitable"),
    ("AIEventVehicleWaitingInDepot", "GSEventVehicleWaitingInDepot"),
    ("AIExecMode", "GSExecMode"),
    ("AIGameSettings", "GSGameSettings"),
    ("AIGroup", "GSGroup"),
    ("AIGroupList", "GSGroupList"),
    ("AIIndustry", "GSIndustry"),
    ("AIIndustryList", "GSIndustryList"),
    ("AIIndustryList_CargoAccepting", "GSIndustryList_CargoAccepting"),
    ("AIIndustryList_CargoProducing", "GSIndustryList_CargoProducing"),
    ("AIIndustryType", "GSIndustryType"),
    ("AIIndustryTypeList", "GSIndustryTypeList"),
    ("AIInfo", "GSInfo"),
    ("AIInfrastructure", "GSInfrastructure"),
    ("AILibrary", "GSLibrary"),
    ("AIList", "GSList"),
    ("AILog", "GSLog"),
    ("AIMap", "GSMap"),
    ("AIMarine", "GSMarine"),
    ("AIOrder", "GSOrder"),
    ("AIRail", "GSRail"),
    ("AIRailTypeList", "GSRailTypeList"),
    ("AIRoad", "GSRoad"),
    ("AISign", "GSSign"),
    ("AISignList", "GSSignList"),
    ("AIStation", "GSStation"),
    ("AIStationList", "GSStationList"),
    ("AIStationList_Vehicle", "GSStationList_Vehicle"),
    ("AISubsidy", "GSSubsidy"),
    ("AISubsidyList", "GSSubsidyList"),
    ("AITestMode", "GSTestMode"),
    ("AITile", "GSTile"),
    ("AITileList", "GSTileList"),
    ("AITileList_IndustryAccepting", "GSTileList_IndustryAccepting"),
    ("AITileList_IndustryProducing", "GSTileList_IndustryProducing"),
    ("AITileList_StationType", "GSTileList_StationType"),
    ("AITown", "GSTown"),
    ("AITownEffectList", "GSTownEffectList"),
    ("AITownList", "GSTownList"),
    ("AITunnel", "GSTunnel"),
    ("AIVehicle", "GSVehicle"),
    ("AIVehicleList", "GSVehicleList"),
    ("AIVehicleList_DefaultGroup", "GSVehicleList_DefaultGroup"),
    ("AIVehicleList_Depot", "GSVehicleList_Depot"),
    ("AIVehicleList_Group", "GSVehicleList_Group"),
    ("AIVehicleList_SharedOrders", "GSVehicleList_SharedOrders"),
    ("AIVehicleList_Station", "GSVehicleList_Station"),
    ("AIWaypoint", "GSWaypoint"),
    ("AIWaypointList", "GSWaypointList"),
    ("AIWaypointList_Vehicle", "GSWaypointList_Vehicle"),
)


"find version"
version = 0
with open(join(SourceDir, "library.nut"), "r") as VersionFile:
    for line in VersionFile:
        if "GetVersion()" in line:
            version = line[line.find("return") + 6 : line.find(";")].strip()

"Create AI version"
MetaLibVersion = "MetaLib-" + version
TarFileName = join(OutputDir, MetaLibVersion + "-AI.tar")
with tarfile.open(name=TarFileName, mode="w") as MyTarFile:
    for File in os.listdir(SourceDir):
        if os.path.isfile(join(SourceDir, File)):
            # print(File)
            if File.endswith(".nut"):
                MyTarFile.add(join(SourceDir, File), join(MetaLibVersion, File))
            elif File.endswith(".txt"):
                MyTarFile.add(join(SourceDir, File), join(MetaLibVersion, File))
            elif File.endswith(".md"):
                File2 = File[:-3] + ".txt"
                with codecs.open(join(SourceDir, File), "r", "utf-8") as FileOpen:
                    FileData = FileOpen.read()
                FileDataFixed = ""
                for line in str(FileData).replace("\r", "").split("\n"):
                    FileDataFixed = (
                        FileDataFixed + multiple_replace(line, *mdReplacements) + "\r\n"
                    )
                FileDataFixed = FileDataFixed.encode("utf-8")
                with codecs.open(join(TempDir, File2), mode="wb") as TempFile:
                    TempFile.write(FileDataFixed)
                MyTarFile.add(join(TempDir, File2), join(MetaLibVersion, File2))
print("    " + MetaLibVersion + "-AI.tar created!")

"Create GameScript version"
LineCount = 0
TarFileName = join(OutputDir, MetaLibVersion + "-GS.tar")
with tarfile.open(name=TarFileName, mode="w") as MyTarFile:
    for File in os.listdir(SourceDir):
        if os.path.isfile(join(SourceDir, File)):
            if File.endswith(".nut"):
                with codecs.open(join(SourceDir, File), "r", "utf-8") as FileOpen:
                    FileData = FileOpen.read()
                FileDataFixed = ""
                for line in str(FileData).replace("\r", "").split("\n"):
                    "replace the AI API with GS API"
                    FileDataFixed = (
                        FileDataFixed + multiple_replace(line, *aiReplacements) + "\r\n"
                    )
                    LineCount += 1
                FileDataFixed = FileDataFixed.encode("utf-8")
                with codecs.open(join(TempDir, File), mode="wb") as TempFile:
                    TempFile.write(FileDataFixed)
                MyTarFile.add(join(TempDir, File), join(MetaLibVersion, File))
            elif File.endswith(".txt"):
                MyTarFile.add(join(SourceDir, File), join(MetaLibVersion, File))
            elif File.endswith(".md"):
                File2 = File[:-3] + ".txt"
                with codecs.open(join(SourceDir, File), "r", "utf-8") as FileOpen:
                    FileData = FileOpen.read()
                FileDataFixed = ""
                for line in str(FileData).replace("\r", "").split("\n"):
                    line2 = multiple_replace(line, *mdReplacements)
                    line3 = multiple_replace(line2, *aimdReplacements)
                    FileDataFixed = FileDataFixed + line3 + "\r\n"
                    LineCount += 1
                FileDataFixed = FileDataFixed.encode("utf-8")
                with codecs.open(join(TempDir, File2), mode="wb") as TempFile:
                    TempFile.write(FileDataFixed)
                MyTarFile.add(join(TempDir, File2), join(MetaLibVersion, File2))
print("    " + MetaLibVersion + "-GS.tar created!")

"delete temp directory"
shutil.rmtree(TempDir)

print("        " + str(LineCount) + " lines of code")
