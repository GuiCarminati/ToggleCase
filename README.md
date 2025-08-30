# ToggleCase - AutoHotkey Text Case Converter

A simple AutoHotkey v2 script that provides quick keyboard shortcuts to change the case of selected text in any application.

## Features

- **Toggle Mode**: Cycle through 3 text case formats with a single shortcut (UPPER -> lower -> Proper)
- **Direct Mode**: Change to a specific case format from one of the direct [shortcuts](#keyboard-shortcuts)
- **Universal**: Works in most applications that supports text selection
- **Clipboard Safe**: Preserves your original clipboard contents

## Case Formats Supported

1. **UPPER CASE** - Converts all text to uppercase
2. **lower case** - Converts all text to lowercase  
3. **Proper Case** - Capitalizes the first letter of each word

## Examples

**Original text:** `Hello world`

- **UPPER CASE:** `HELLO WORLD`
- **lower case:** `hello world`
- **Proper Case:** `Hello World`

## How to Use

1. **Select text** in any application (Word, Notepad, browser, etc.)
2. **Press one of the shortcuts** [above](#keyboard-shortcuts)
3. **Text is converted** to the chosen case format

## Keyboard Shortcuts

### Toggle Mode (Cycles through all cases)

- `Win + CapsLock` - Cycles: UPPER → lower → Proper → UPPER...

### Direct Mode (Change to specific case)

- `CapsLock + U` or `CapsLock + Q` - Convert to **UPPER CASE**
- `CapsLock + L` or `CapsLock + Z` - Convert to **lower case**
- `CapsLock + P` or `CapsLock + A` - Convert to **Proper Case**

Note: Alternative keys (Q, Z, A) are positioned close to CapsLock for ergonomic access (Q->Upper keyboard row, Z->Lower keyboard row, A->in between).

## Requirements

- AutoHotkey v2.0 or higher (if compiling source code)
- Windows operating system

## Installation

No installation required.

Download and run the [ToggleCase.exe file](https://github.com/GuiCarminati/ToggleCase/releases/latest/download/ToggleCase.exe), it will show in your Windows System Tray while it's running.

To stop execution, right click on the icon in the system tray and select "Pause Script" or "Exit".

If you'd like the script to start up with Windows, you can add it to the Windows Startup folder:

1. Press Win+R, type shell:startup and press Enter.
2. In the folder that opens, right-click → New → Shortcut
3. Browse to your ToggleCase.ahk script and finish the shortcut wizard.
4. Anything in this folder runs when you log in.

If you prefer to customize or compile the .exe yourself, follow these steps:

1. Download and install [AutoHotkey v2](https://www.autohotkey.com/download/ahk-v2.exe)
2. Clone the repo to your machine: ```git clone https://github.com/GuiCarminati/ToggleCase.git```, or download the source code in the [latest release](https://github.com/GuiCarminati/ToggleCase/releases/latest)
4. Modify the `ToggleCase.ahk` file in your local repository (optional)
5. Run AutoHokey Dash and select the "Compile" option
6. Select the Source path of the .ahk file
7. Select the Destination path for the .exe file
8. Select the Base File for your operating system (x64 or x32) (the script is written in AHK v2, so the v1 option won't work)
9. Click Convert
10. Double-click the newly generated .exe file to run it. See above to set up Windows startup. 

## Credits

Inspired by [this AutoHotkey community post](https://www.autohotkey.com/boards/viewtopic.php?t=92646) and updated for AutoHotkey v2 compatibility.

## License

Free to use and modify for personal and commercial purposes.