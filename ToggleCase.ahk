;inspired by: https://www.autohotkey.com/boards/viewtopic.php?t=92646 and updated for AHK v2 compatibility

case_state := 1
MAX_STATE := 3
; expected states:
; 1 = UPPER CASE 
; 2 = lower case
; 3 = Proper Case

ToggleTextCase(SelectedCaseCBFn){
    temp_clip := A_Clipboard    ; saves clipboard contents before 
    A_Clipboard := ""
    Sleep 150
    Send '^c'                   ; copies currently selected text

    isText := ClipWait(0.3, 0)  ; wait up to .3 seconds for clipboard data (0 = text only)
    if(!isText || A_Clipboard = ""){
        ; valididate clipboard, return if no text is selected
        return
    }

    A_Clipboard := SelectedCaseCBFn(A_Clipboard)

    Send '^v'                   ; pastes formatted text 
    Sleep 100
    A_Clipboard := temp_clip    ; restores original clipboard
    return
}


#CapsLock::{ ; Win+CapsLock
    global case_state, MAX_STATE
    switch case_state {
        case 1: 
            ToggleTextCase(StrUpper)
        case 2:
            ToggleTextCase(StrLower)
        case 3:
            ToggleTextCase(StrTitle)
    }

    ; increments or resets current state
    case_state := (case_state>=MAX_STATE) ? 1 : case_state := case_state+1
    
    return
}

; converts SELECTED TEXT to UPPER CASE ("Hello World" becomes "HELLO WORLD")
; converts selected text to lower case ("Hello World" becomes "hello world")
; converts selected text to Proper Case ("HELLO WORLD" becomes "Hello World")

; reference
; # = Windows key
; ! = Alt key
; ^ = Control key
; + = Shift key
; CapsLock