TranslateText(text, sourceLang, targetLang) {
    UrlEncode := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    UrlEncode.Open("GET", "https://api.mymemory.translated.net/get?q=" . text . "&langpair=" . sourceLang . "|" . targetLang, false)
    UrlEncode.Send()
    encodedText := UrlEncode.ResponseText
    encodedText := RegExReplace(encodedText, ".*""translatedText"":""([^""]+).*", "$1")
    encodedText := StrReplace(encodedText, "\\\", "\", "All")
    encodedText := StrReplace(encodedText, "\\", "", "All")
    encodedText := StrReplace(encodedText, "\n", "", "All")
    encodedText := StrReplace(encodedText, "\r", "", "All")
    return encodedText
}

^+z::
    clipboard := ""
    SendInput ^c
    ClipWait, 1
    text := clipboard
    translatedText := TranslateText(text, "pl", "en")
    clipboard := translatedText
    MsgBox, 0, Translation Complete!, The translated text has been copied to the clipboard.
return
