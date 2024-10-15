#Requires AutoHotkey >=v2.1-

; Require admin privileges.
;@Ahk2Exe-UpdateManifest 0

#SingleInstance Off
#NoTrayIcon

#Include <INI>
#Include <PnPDevice>
#Include <AdminRights>

Main()

Main() {
    text := FileRead("config.ini")
    config := INI.parse(text)

    A_TrayMenu.Delete() ; Clear tray menu.

    for section in config.sections {
        funky(*) {
            if (section.device.enabled) {
                section.device.Disable()
                A_TrayMenu.Uncheck(section.device.sectionName)
            } else {
                section.device.Enable()
                A_TrayMenu.Check(section.device.sectionName)
            }
        }

        ; Tray menu
        A_TrayMenu.Add(section.sectionName, (*) => (section.device.enabled ? (section.device.Disable(), A_TrayMenu.Uncheck(section.device.sectionName)) : (section.device.Enable(), A_TrayMenu.Check(section.device.sectionName))))
        try {
            section.device := PnPDevice(section.id)
            if (section.device.enabled) {
                A_TrayMenu.Check(section.sectionName)
            }
        }
        catch {
            A_TrayMenu.Disable(section.sectionName)
            continue
        }
        try
            isDefault := section.default
        catch
            isDefault := false
        if (isDefault)
            A_TrayMenu.Default := section.sectionName
        ; Hotkey
        try
            sectionHotkey := section.hotkey
        catch
            sectionHotkey := ""
        if (sectionHotkey) {
            hotkeyPressed(*) {
                MsgBox(section.sectionName)
            }
            Hotkey(section.hotkey, hotkeyPressed)

        }
    }

    A_TrayMenu.Add()
    A_TrayMenu.Add("Restart", (*) => Reload())
    A_TrayMenu.Add("Exit", (*) => ExitApp())

    A_TrayMenu.ClickCount := Number(config.clickCount)

    A_IconHidden := false
    Persistent(true)
}