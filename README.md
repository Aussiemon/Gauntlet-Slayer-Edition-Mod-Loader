## Gauntlet: Slayer Edition Mod Loader

Rudimentary mod loader using a modified game bundle as an entrypoint. Similar to Darktide's implementation, but no mod framework support yet or maybe ever. It depends on motivation, and I've never actually played the game.

Features:

1. Developer console window for real-time logging.
2. Basic hook system for modifying functions. Make sure the function exists before trying to hook it.
3. File replacement system (every file in the `mods` folder will be loaded before same-named game scripts).
4. Skips the splash screens as a proof of concept.

Made for the GOG version of Gauntlet: Slayer Edition, but should work with all PC versions.

## Gauntlet: Slayer Edition Source Code
https://bitbucket.org/Aussiemon/gauntlet-slayer-edition-source-code/src/main/

## Installation

1. Extract the contents to your game folder.
  - `mod_loader` should be at the folder root.
  - The modified game bundle `9e13b2414b41b842` should be in the `Contents` folder, or wherever the rest of the game bundles are. Replace the existing file.
2. Start the game. If the game opens to the main menu with a developer console in a second window, mods are active.

## Making mods

- `mod_loader` is a Lua file. Open it with a text editor to see some syntax examples.
- Drop files in the `mods` folder to load them through Lua. Same-named files will automatically replace scripts in the game bundles.
- Use `Mods.hook.set()` to place hooks on game functions. These hooks will execute the attached function whenever the original function executes as part of a hook chain. The hooked function must exist, so you should create the hook as part of a replaced game script instead of creating it in the `mod_loader`.
- Use `Mods.original_require()` to access the original `require` function without searching the `mods` folder.

## Uninstallation

1. Verify game files to restore the modified game bundle, or restore it from a backup.
2. Delete the `mod_loader` file and `mods` folder to clean up leftover files.

## Background

_Gauntlet: Slayer Edition_'s Lua files are LuaJIT 2.0 bytecode in Bitsquid bundles. The bundles are zipped with _zlib_ in a format that matches the original _Warhammer: Vermintide 1_ bundles; `0xf0000004`. Vermintide 1 eventually switched to a new format with small header changes (`0xf0000005`). _Warhammer: Vermintide 2_ started on `0xf0000005`, but switched to _zstd_ and a completely different format. _Warhammer: Darktide_ started on `0xf0000006`, but switched to Oodle before launch. Luckily, my upgraded version of _walterr_'s old NodeJS extraction script still works on Gauntlet's `0xf0000004`.

With the files extracted, decompilation is as simple as using luajit-decompiler-v2. Only one file failed decompilation - interestingly with both the legacy LJD and the new decompiler. WB is probably less friendly with decompiled game files than Fatshark, so the decompilation is hosted elsewhere.

So, with all these existing tools, getting the code is actually the easy part. I'm sure it'd also be easy for some people to make a dinput hook that injects scripts, but that isn't part of my knowledge set. Instead, I made a simple script that loads another script using the `io` library in Lua. The simple script is padded to be the same size as the original `lua\boot\boot.lua` file, and replaces that file in the game bundles. The script it calls is `mod_loader` in the game directory, which contains a copy of `boot.lua`, as well as calls to set up a rudimentary framework through a combination of my own work, legacy _Vermintide Mod Framework_, and _Darktide Mod Framework_.

The modified game bundle was unpacked and repacked using _IAmLupo_'s old VT1 bundle unpacker.
