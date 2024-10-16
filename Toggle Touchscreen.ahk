﻿; This script works only when compiled.

#Requires AutoHotkey v2.0

;@Ahk2Exe-SetMainIcon resources\mainIcon.ico
;@Ahk2Exe-AddResource resources\touchOn.ico, 691
;@Ahk2Exe-AddResource resources\touchOff.ico, 692

#SingleInstance Off
#NoTrayIcon

#Include <PnPDevice>

toggleHotkey := "^#!t"

firstPID := ProcessExist(A_ScriptName) ; Get the process id of the first created process with this name. We assume this is the master instance.
selfPID := ProcessExist() ; Get the process id of self.

; If they're equal, this means that there is no master instance.
if firstPID != selfPID { 
	; Send the toggle hotkey.
	SendInput(toggleHotkey)
	return
}

if not A_IsAdmin {
	MsgBox("Administrator privileges are required to toggle the touchscreen device.")
	return
}

touchScreenDevice := PnPDevice("HID-compliant touch screen")

changeTrayIcon(touchScreenDevice.enabled)

; Insert tray icon option to toggle the touchscreen.
A_TrayMenu.Delete("1&")
A_TrayMenu.Delete("1&")
A_TrayMenu.Insert("1&", "Toggle Touchscreen", toggleTouchscreen)
A_TrayMenu.Default := "Toggle Touchscreen"
A_TrayMenu.ClickCount := 1

Hotkey(toggleHotkey, toggleTouchscreen)

Persistent(True) ; Keep script running.
A_IconHidden := false

; Function to change tray icon.
changeTrayIcon(value) {
	TraySetIcon(A_ScriptFullPath, (value ? -691 : -692))
}

; Function to toggle the touchscreen HID device.
toggleTouchscreen(*) {
	global
	if touchScreenDevice.enabled {
		touchScreenDevice.Disable()
	} else {
		touchScreenDevice.Enable()
	}
	changeTrayIcon(touchScreenDevice.enabled)
}