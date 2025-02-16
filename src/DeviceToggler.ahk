#Requires AutoHotkey v2.0.19

;@Ahk2Exe-SetMainIcon resources\main.ico
;@Ahk2Exe-AddResource resources\on.ico, 691
;@Ahk2Exe-AddResource resources\off.ico, 692

#SingleInstance Off
#NoTrayIcon

#Include <PnPDevice>

toggleHotkey := IniRead("options.ini", "Options", "Hotkey")

firstPID := ProcessExist(A_ScriptName) ; Get the process id of the first created process with this name. We assume this is the master instance.
selfPID := ProcessExist() ; Get the process id of self.

; If they're equal, this means that there is no master instance.
if firstPID != selfPID {
	; Send the toggle hotkey.
	SendInput(toggleHotkey)
	return
}

if not A_IsAdmin {
	MsgBox("Administrator privileges are required to toggle the device.")
	return
}

device := PnPDevice(IniRead("options.ini", "Options", "DeviceId"))

; Insert tray icon option to toggle the device.
trayToggleDeviceEntry := "Toggle " . device.Name
trayHotkeyEntry := "Hotkey: " . toggleHotkey

A_TrayMenu.Delete("1&")
A_TrayMenu.Delete("1&")
A_TrayMenu.Insert("1&", trayHotkeyEntry, toggleDevice)
A_TrayMenu.Disable(trayHotkeyEntry)
A_TrayMenu.Insert("1&", trayToggleDeviceEntry, toggleDevice)
A_TrayMenu.Default := trayToggleDeviceEntry
A_TrayMenu.ClickCount := IniRead("options.ini", "Options", "ClickCount")

Hotkey(toggleHotkey, toggleDevice)

Persistent(True) ; Keep script running.
updateTray()
A_IconHidden := false

updateTray() {
	global
	if (device.isEnabled) {
		TraySetIcon(A_ScriptFullPath, -691)
		A_TrayMenu.Check(trayToggleDeviceEntry)
	} else {
		TraySetIcon(A_ScriptFullPath, -692)
		A_TrayMenu.Uncheck(trayToggleDeviceEntry)
	}
}

toggleDevice(*) {
	global
	if device.isEnabled {
		device.Disable()
	} else {
		device.Enable()
	}
	updateTray()
}