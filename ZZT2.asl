// State variables are not applicate for emulators
// For read variables, see the "update"/"init" block
state("pcsx2", "null") {}

startup
{
  // Settings
  // TODO
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

  vars.Watchers = new MemoryWatcherList
  {
    vars.GameTimeFrames
  };
}

update
{
  // In case of a PCSX2 update changing this, or using this script on another emulator
  const int Pcsx2Offset = 0x20000000;

  // Update memory watchers
  vars.Watchers.UpdateAll(game);
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