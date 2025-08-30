# ToggleCase - AutoHotkey Text Case Converter

A simple AutoHotkey v2 script that provides quick keyboard shortcuts to change the case of selected text in any application.

## Features

- **Toggle Mode**: Cycle through 3 text case formats with a single shortcut (UPPER -> lower -> Proper)
- **Direct Mode**: Jump directly to a specific case format
- **Universal**: Works in any application that supports text selection
- **Smart Selection**: Only processes actual text selections (ignores empty selections)
- **Clipboard Safe**: Preserves your original clipboard contents

## Case Formats Supported

1. **UPPER CASE** - Converts all text to uppercase
2. **lower case** - Converts all text to lowercase  
3. **Proper Case** - Capitalizes the first letter of each word

## Keyboard Shortcuts

### Toggle Mode (Cycles through all cases)
- `Win + CapsLock` - Cycles: UPPER → lower → Proper → UPPER...

### Direct Mode (Jump to specific case)
- `CapsLock + U` or `CapsLock + Q` - Convert to **UPPER CASE**
- `CapsLock + L` or `CapsLock + Z` - Convert to **lower case**
- `CapsLock + P` or `CapsLock + A` - Convert to **Proper Case**

*Note: Alternative keys (Q, Z, A) are positioned close to CapsLock for ergonomic access*

## How to Use

1. **Select text** in any application (Word, Notepad, browser, etc.)
2. **Press one of the shortcuts** above
3. **Text is instantly converted** to the chosen case format
4. **Selection is maintained** for easy further editing

## Requirements

- AutoHotkey v2.0 or higher
- Windows operating system

## Installation

1. Download and install [AutoHotkey v2](https://www.autohotkey.com/download/ahk-v2.exe)
2. Save the script as `ToggleCase.ahk`
3. Double-click the script file to run it
4. The script will run in the system tray

## Examples

**Original text:** `Hello World`

- **UPPER CASE:** `HELLO WORLD`
- **lower case:** `hello world`
- **Proper Case:** `Hello World`

## Credits

Inspired by [this AutoHotkey community post](https://www.autohotkey.com/boards/viewtopic.php?t=92646) and updated for AutoHotkey v2 compatibility.

## License

Free to use and modify for personal and commercial purposes.