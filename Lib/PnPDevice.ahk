/*
Requires administrator privileges.
This class is made to simplify using Windows API's "Win32_PnPEntity" class.
For examples see the bottom of the definition file.
For documentation, see https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-pnpentity.
*/
class PnPDevice {
    __New(id) {
        this.winmgmts := ComObjGet("winmgmts:")
        this.update(id)
    }
    update(id := this.device.DeviceID) {
        idEscaped := StrReplace(id, "\", "\\")
        this.device := this.winmgmts.ExecQuery("SELECT * FROM Win32_PnPEntity WHERE DeviceID = '" idEscaped "'").ItemIndex(0)
    }
    enabled {
        get {
            this.update()
            return this.device.Status = "OK" ? 1 : 0
        }
    }
    __Get(Key, Params) {
        return this.device.%Key%[Params*]
    }
    __Call(Key, Params) {
        return this.device.%Key%(Params*)
    }
}

/*

;Example:

myTouchscreen := HIDDevice("HID\GXTP7386&COL01\5&3B967D17&0&0000") ; This is the DeviceID a.k.a "Device instance path" in Device Manager
if myTouchscreen.enabled {
    myTouchscreen.Disable()
} else {
    myTouchscreen.Enable()
}
MsgBox(myTouchscreen.Name)

*/
