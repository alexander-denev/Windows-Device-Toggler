#Requires AutoHotkey v2.0

if !A_IsAdmin {
    try Run("*RunAs " A_ScriptFullPath)
    Exit()
}