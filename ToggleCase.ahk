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

    ReselectText(A_Clipboard)   ; reselects original text (can be slower for longer selections)

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

/*
Problems with the approach below:
    - Too slow 
    - Selects one extra character per line (if more than 1 line selected). From what I debugged, 
    this happens because the line break counts as two characters, but it registers only once when selecting.
The extra character problem could be solved by processing each line individually, but given how ineficient this 
approach already yes, i don't think it's worth it to try to make it "better".
But this works for selections in a single line (tho it's kinda slow, you can notice the cursor selecting each char). 
*/
ReselectText_byChar(original_text){
    num_char := StrLen((original_text))
    Loop num_char{
        Send "+{Left}"
    }
}


/*
Problems with the approach below:
    - Faster than _byChar, but noticeable on longer selections
    - Hard to account for all possible delimiters. Also, CTRL+R/L Arrows navigation can behave differently on 
    each application. 
    - Tabs/spaces at the start and end of a line can be tricky to handle. You want trim trailling tabs/spaces 
    so that they don't count as multiple words, but if ignoring them completely, the total word count will be less. 
The trailling tabs/spaces problem could probably be solved by handling first and last lines differently than middle
lines. For example, having a SHIFT+HOME command, followed by SHIFT+UP on subsequent lines, and then SHIFT+LEFT for 
the number of words on the last line (the most top line going bottom->top).

This works for selections in a single line (but it still has a noticeable dealy, you can notice the cursor selecting each char). 
*/
ReselectText(original_text){
    lines := StrSplit(original_text,"`r`n")
    delimiters := [" ","`t",",",".",";","[","]","{","}","@","`'","`"","!","#",":","~","=","+","-","*","(",")","``"]
    Loop lines.Length{
        line := Trim(lines[A_Index])    ; process each line ignoring spaces at start and end
        num_words := StrSplit(line,delimiters).Length
        Loop num_words{
            Send "+^{Left}"
        }
    }
}

; reference
; # = Windows key
; ! = Alt key
; ^ = Control key
; + = Shift key
; {Left} = Left arrow key
; {Right} = Right arrow key
; CapsLock