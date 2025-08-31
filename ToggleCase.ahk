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
I tried implementing a slight better approach of reselecting line by line instead of word by word (expect on first
and last lines). It kind of works, but it misbehaves depending on the text editor, the amount of lines and the 
delimiters (characters where the cursor will stop at while navigation with SHIFT+CTRL+LEFT). It gets the number of 
lines correct most of the times, but it misses by a few words on the top line. 

It still mostly works for a single line, but kind of breaks on multiple lines. But it can get the reselection wrong
if the delimiters behave differently than expected. Examples where special characters can be a problem:
    1. The cursor will stop at a "=" and at a ">", but it will go over them if they're together ("=>"). But on the 
      array resulting from StrSplit, each delimiter creates a word. To account for this particular case, i added a
      "=>" as a delimiter as well, but there are many other character combination where this could be a problem.
    2. In VSCode, on a word with a "_", the cursor goes over the whole word when sending a CRTL+LEFT command. But
      on Notepad, it stops at the "_" as if it was a space (eg. "user_name": VSCode: "user_name|" -> "|user_name"
      Notepad: "user_name" -> "user_|name" -> "|user_name").  
*/
ReselectText(original_text){
    lines := StrSplit(Trim(original_text),["`r`n","`n`r"])

    if(lines.Length=1){                         ; special (simpler) case when only one line is selected
        ReselectSingleLine(Trim(original_text))
    } else {
        i := lines.Length                       ; start from last line
        While (i > 0) {
            if(i = lines.Length){               ; first line from the bottom
                Send "+{Home}{Home}"            ; {Home} twice because some editors place the cursor at the start of the last word the first time
            } else if(i > 1){                   ; all lines between bottom and top
                Send "+{Up}"
            } else {                            ; last line to be processed (the top line)
                Send "+^{Left}"
                ReselectSingleLine(lines[i])
            }
            ; Sleep 300
            ; MsgBox lines[i]
            i--
        }
    }
}

ReselectSingleLine(original_text){
    delimiters := [" ","`t",",",".",";","[","]","{","}","@","`'","`"","!","#",":","~","=","+","-","*","(",")","``","<",">","?","/","|","\","->","=>"]
    num_words := StrSplit(original_text,delimiters).Length
    Loop num_words{
        Send "+^{Left}"
    }
}

; special character reference
; # = Windows key
; ! = Alt key
; ^ = Control key
; + = Shift key
; {Left} = Left arrow key
; {Right} = Right arrow key
; {Up} = Left arrow key
; {Down} = Right arrow key
; CapsLock