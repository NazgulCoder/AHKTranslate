; Read language codes from lang.txt
FileRead, lang, lang.txt   ; Open the file "lang.txt" and store its contents in the variable "lang"
StringSplit, lang, lang, `n, `r   ; Split the contents of "lang" into separate lines and store them in the array "lang"

; Define translation function
TranslateText(text, sourceLang, targetLang) {
    UrlEncode := ComObjCreate("WinHttp.WinHttpRequest.5.1")   ; Create a WinHttpRequest object to make a GET request
    UrlEncode.Open("GET", "https://api.mymemory.translated.net/get?q=" . text . "&langpair=" . sourceLang . "|" . targetLang, false)   ; Set the GET request URL with the provided text and language codes
    UrlEncode.Send()   ; Send the GET request
    encodedText := UrlEncode.ResponseText   ; Store the response text in the variable "encodedText"
    encodedText := RegExReplace(encodedText, ".*""translatedText"":""([^""]+).*", "$1")   ; Use regex to extract the translated text from the response
    encodedText := StrReplace(encodedText, "\\\", "\", "All")   ; Replace any escaped backslashes with regular backslashes
    encodedText := StrReplace(encodedText, "\\", "", "All")   ; Remove any remaining backslashes
    encodedText := StrReplace(encodedText, "\n", "", "All")   ; Remove any newline characters
    encodedText := StrReplace(encodedText, "\r", "", "All")   ; Remove any carriage return characters
    return encodedText   ; Return the translated text
}

; Define hotkey to translate clipboard text
^+z::   ; Define the hotkey as CTRL+SHIFT+Z
    clipboard := ""   ; Clear the clipboard
    SendInput ^c   ; Simulate pressing CTRL+C to copy the selected text to the clipboard
    ClipWait, 1   ; Wait for the clipboard to contain data for up to 1 second
    text := clipboard   ; Store the contents of the clipboard in the variable "text"
    translatedText := TranslateText(text, lang1, lang2)   ; Call the TranslateText function with the text and language codes from lang.txt and store the translated text in the variable "translatedText"
    clipboard := translatedText   ; Copy the translated text to the clipboard
    MsgBox, 0, Translation Complete!, The translated text has been copied to the clipboard.   ; Display a message box indicating that the translation is complete
return   ; End of hotkey definition
