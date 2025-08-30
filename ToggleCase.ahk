;inspired by: https://www.autohotkey.com/boards/viewtopic.php?t=92646 and updated for AHK v2 compatibility

case_state := 1
MAX_STATE := 3
; expected states:
; 1 = UPPER CASE 
; 2 = lower case
; 3 = Proper Case

#CapsLock::{
    global case_state, MAX_STATE
    temp_clip := A_Clipboard    ; saves clipboard contents before 
    A_Clipboard := ""
    Sleep 150
    Send '^c'                   ; copies currently selected text
    ClipWait

    switch case_state {
        case 1: 
            A_Clipboard := StrUpper(A_Clipboard)
        case 2: 
            A_Clipboard := StrLower(A_Clipboard)
        case 3: 
            A_Clipboard := StrTitle(A_Clipboard)
    }
    if(case_state>=MAX_STATE){
        case_state := 1
    } else {
        case_state := case_state+1
    }

    Send '^v'                   ; pastes formatted text 
    Sleep 100
    A_Clipboard := temp_clip    ; restores original clipboard
    return
}

; converts selected text to UPPER CASE ("Hello World" becomes "HELLO WORLD")
#+u::{ ; Win+Shift+U
    temp_clip := A_Clipboard
    A_Clipboard := ""
    Sleep 150
    Send '^c'
    ClipWait
    A_Clipboard := StrUpper(A_Clipboard)
    Send '^v'
    Sleep 100
    A_Clipboard := temp_clip
    return
}

; converts selected text to lower case ("Hello World" becomes "hello world")
#+l::{ ; Win+Shift+L
    temp_clip := A_Clipboard
    A_Clipboard := ""
    Sleep 150
    Send '^c'
    ClipWait
    A_Clipboard := StrLower(A_Clipboard)
    Send '^v'
    Sleep 100
    A_Clipboard := temp_clip
    return
}

; reference
; # = Windows key
; ! = Alt key
; ^ = Control key
; + = Shift key
; CapsLock