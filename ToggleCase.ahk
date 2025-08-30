;inspired by: https://www.autohotkey.com/boards/viewtopic.php?t=92646 and updated for AHK v2 compatibility

case_state := 1
MAX_STATE := 3
; expected states:
; 1 = UPPER CASE 
; 2 = lower case
; 3 = Proper Case

SetTextCase(SelectedCaseCBFn){
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

; Cycles through possible case states (UPPER -> lower -> Proper)
#CapsLock::{ ; Win+CapsLock
    global case_state, MAX_STATE
    switch case_state {
        case 1: 
            SetTextCase(StrUpper)
        case 2:
            SetTextCase(StrLower)
        case 3:
            SetTextCase(StrTitle)
    }

    ; increments or resets current state
    case_state := (case_state >= MAX_STATE) ? 1 : case_state + 1
    
    return
}

; CAPSLOCK+U or CAPSLOCK+Q (U for UpperCase, Q because it's the closest letter to CAPS in the upper row of the keyboard)
; converts selected text to UPPER CASE ("Hello World" becomes "HELLO WORLD")
CapsLock & U::                  
CapsLock & Q::{ 
    SetTextCase(StrUpper) 
}

; CAPSLOCK+L or CAPSLOCK+Z (L for LowerCase, Z because it's the closest letter to CAPS in the lower row of the keyboard)
; converts selected text to lower case ("Hello World" becomes "hello world")
CapsLock & L::                  
CapsLock & Z::{ 
    SetTextCase(StrLower) 
}

; CAPSLOCK+P or CAPSLOCK+A (P for ProperCase, A because it's in between the Upper and Lower shortcuts)
; converts selected text to Proper Case ("HELLO WORLD" becomes "Hello World")
CapsLock & P::                  
CapsLock & A::{ 
    SetTextCase(StrTitle) 
}