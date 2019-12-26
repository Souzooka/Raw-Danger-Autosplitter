// State variables are not applicate for emulators
// For read variables, see the "update"/"init" block
state("pcsx2", "null") {}

startup
{
  vars.AreaNames = new string[] {"Joshua Harwell", "Amber Brazil", "Isaac Schiller", "Paige Meyer", "Ivan Kazlov", "Keith Helm"};
  vars.Maps = new Tuple<int[], string>[][]
  {
    new Tuple<int[], string>[]
    {
      Tuple.Create(new int[] {1, 1, 0}, "Banquet Hall"),
      Tuple.Create(new int[] {1, 1, 1}, "Banquet Hall (Flooded)"),
      Tuple.Create(new int[] {1, 1, 5}, "Downtown Geo"),
      Tuple.Create(new int[] {1, 2, 0}, "Downtown Station"),
      Tuple.Create(new int[] {1, 3, 0}, "Del Ray W. Junc."),
      Tuple.Create(new int[] {1, 4, 0}, "Historical Rest Area"),
      Tuple.Create(new int[] {1, 5, 0}, "Del Ray E. Junc."), // END CASE
      Tuple.Create(new int[] {1, 5, 1}, "Angelina Area"),
      Tuple.Create(new int[] {1, 5, 2}, "Care Center"),
      Tuple.Create(new int[] {1, 6, 0}, "Inner Park"),
      Tuple.Create(new int[] {1, 7, 0}, "Central Geo District"),
      Tuple.Create(new int[] {1, 9, 0}, "Media Tower Area Pt. 1"), // END CASE
      Tuple.Create(new int[] {1, 9, 1}, "Media Tower Area Pt. 2") // END CASE (SPECIAL)
    },
    new Tuple<int[], string>[]
    {
      Tuple.Create(new int[] {2, 1, 0}, "Landmark Apartments (Flashback)"),
      Tuple.Create(new int[] {2, 2, 0}, "Police Station"), // SPECIAL CASE
      Tuple.Create(new int[] {2, 3, 0}, "Downtown Geo"),
      Tuple.Create(new int[] {2, 4, 0}, "Downtown Station"), // END CASE
      Tuple.Create(new int[] {2, 5, 0}, "Hudson Tunnel Area"),
      Tuple.Create(new int[] {2, 6, 0}, "Apartment"),
      Tuple.Create(new int[] {2, 7, 0}, "Angelina Area"),
      Tuple.Create(new int[] {2, 8, 0}, "Cascade Dam") // END CASE
    },
    new Tuple<int[], string>[]
    {
      Tuple.Create(new int[] {3, 1, 0}, "Convenience Store Area"),
      Tuple.Create(new int[] {3, 2, 0}, "Downtown Geo"),
      Tuple.Create(new int[] {3, 2, 1}, "Police Station"), // END CASE
      //Tuple.Create(new int[] {3, 3, 0}, "Downtown Station"),
      Tuple.Create(new int[] {3, 5, 0}, "Landmark Apartments"),
      Tuple.Create(new int[] {3, 6, 0}, "NorCal Pt. 1"),
      Tuple.Create(new int[] {3, 6, 1}, "NorCal Pt. 2"),
      Tuple.Create(new int[] {3, 7, 0}, "Discovery Heights"), // SPECIAL CASE
      Tuple.Create(new int[] {3, 8, 0}, "Del Ray High School"),
      //Tuple.Create(new int[] {3, 9, 0}, "Angelina Area"),
      Tuple.Create(new int[] {3, 10, 0}, "Road to Cascade Dam"),
      Tuple.Create(new int[] {3, 11, 0}, "Cascade Dam"),
      Tuple.Create(new int[] {3, 15, 0}, "Media Tower Area") // END CASE
    },
    new Tuple<int[], string>[]
    {
      Tuple.Create(new int[] {4, 2, 0}, "Del Ray High School Pt. 1"),
      Tuple.Create(new int[] {4, 3, 0}, "Del Ray High School Pt. 2") // END CASE
    },
    new Tuple<int[], string>[]
    {
      Tuple.Create(new int[] {5, 1, 0}, "Convenience Store Area"),
      Tuple.Create(new int[] {5, 2, 0}, "Discovery Heights"),
      Tuple.Create(new int[] {5, 3, 0}, "Angelina Area"),
      Tuple.Create(new int[] {5, 5, 0}, "Del Ray High School"),
      Tuple.Create(new int[] {5, 6, 0}, "Central Geo District"),
      Tuple.Create(new int[] {5, 7, 0}, "Substation Area") // END CASE
    },
    new Tuple<int[], string>[]
    {
      Tuple.Create(new int[] {6, 1, 0}, "Media Tower Area") // END CASE
    },
  };
  vars.SpecialMaps = new int[][]
  {
    new int[] {2, 2, 2}, // Amber - Police Station
    new int[] {3, 7, 0}, // Isaac - Discovery Heights
    new int[] {1, 5, 0}, // Ch.1 End
    new int[] {1, 9, 0}, // Ch.1 End
    new int[] {1, 9, 1}, // Ch.1 End
    new int[] {2, 4, 0}, // Ch.2 End
    new int[] {2, 8, 0}, // Ch.2 End
    new int[] {3, 2, 1}, // Ch.3 End
    new int[] {3, 15, 0}, // Ch.3 End
    new int[] {4, 3, 0}, // Ch.4 End
    new int[] {5, 7, 0}, // Ch.5 End
    new int[] {6, 1, 0}, // Ch.6 End
  };

  // SETTINGS
  settings.Add("splits", true, "All Splits");
  for (int i = 0; i < vars.AreaNames.Length; ++i)
  {
    settings.Add(vars.AreaNames[i], false, vars.AreaNames[i], "splits");
    for (int j = 0; j < vars.Maps[i].Length; ++j)
    {
      int[] MapIDs = vars.Maps[i][j].Item1;
      string Key = String.Join("_", MapIDs.Select(id => id.ToString()));
      print(Key);
      string MapName = vars.Maps[i][j].Item2;
      settings.Add(Key, false, MapName, vars.AreaNames[i]);
    }
  }
}

init
{
  // In case of a PCSX2 update changing this, or using this script on another emulator
  const int Pcsx2Offset = 0x20000000;

  // Boolean values to check if the split has already been hit
  vars.Splits = new HashSet<string>();

  // For game time
  vars.FramesPerSecond = 20.0f;
  vars.GameTimeFrames = new MemoryWatcher<int>((IntPtr)0x67DC40 + Pcsx2Offset);
  vars.Area = new MemoryWatcher<int>((IntPtr)0x4922C0 + Pcsx2Offset);
  vars.Level = new MemoryWatcher<int>((IntPtr)0x4922C4 + Pcsx2Offset);
  vars.SubLevel = new MemoryWatcher<int>((IntPtr)0x4922C8 + Pcsx2Offset);

  vars.Watchers = new MemoryWatcherList
  {
    vars.GameTimeFrames,
    vars.Area,
    vars.Level,
    vars.SubLevel
  };
}

update
{
  // In case of a PCSX2 update changing this, or using this script on another emulator
  const int Pcsx2Offset = 0x20000000;

  // Update memory watchers
  vars.Watchers.UpdateAll(game);

  // Whenever timer is paused, clear all the splits;
  if (timer.CurrentPhase == TimerPhase.NotRunning) { vars.Splits.Clear(); }
}

// Prevents the in-game timer from increasing on its own (it's synced to the game's time value)
isLoading 
{ 
  return true; 
}

gameTime 
{ 
  return TimeSpan.FromSeconds(vars.GameTimeFrames.Current / vars.FramesPerSecond); 
}

split
{
  // Return false on very first update to prevent false split -- thankfully 0 is NO SCENE
  if (vars.Area.Old == 0) { return false; }

  // TODO: Handle campaign-end levels

  // Map Changed
  if (vars.Level.Old != vars.Level.Current || vars.SubLevel.Old != vars.SubLevel.Current)
  {
    // Don't split when characters are changed
    if (vars.Area.Old != vars.Area.Current) { return false; }

    int[] CurrentMapIDs = new int[] { vars.Area.Current, vars.Level.Current, vars.SubLevel.Current };
    int[] OldMapIDs = new int[] { vars.Area.Old, vars.Level.Old, vars.SubLevel.Old };
    string Key = String.Join("_", OldMapIDs.Select(id => id.ToString()));
    string NewKey = String.Join("_", CurrentMapIDs.Select(id => id.ToString()));

    // Handle special cases
    if      (Key == "2_2_0" && NewKey != "2_3_0")  { return false; } // Split for police station; prevent split on flashback to apartment
    else if (Key == "3_7_0" && NewKey != "3_10_0") { return false; } // Split for Isaac finding Jaden; prevent split for leaving without Jaden

    // Handle normal cases
    if (!vars.Splits.Contains(Key))
    {
      vars.Splits.Add(Key);
      return settings[Key];
    }
  }
}