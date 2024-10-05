/*
Requires administrator privileges.
This class is made to simplify using Windows API's "Win32_PnPEntity" class.
For examples see the bottom of the definition file.
For documentation, see https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-pnpentity.
*/
class HIDDevice {
    __New(deviceName) {
        this.winmgmts := ComObjGet("winmgmts:")
        this.update(deviceName)
    }
    update(name := this.device.Name) {
        this.device := this.winmgmts.ExecQuery("SELECT * FROM Win32_PnPEntity WHERE Name = '" name "'").ItemIndex(0)
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

Example:

myTouchscreen := HIDDevice("HID-compliant touch screen")
if myTouchscreen.enabled {
    myTouchscreen.Disable()
} else {
    myTouchscreen.Enable()
}
MsgBox(myTouchscreen.DeviceID)

*/
