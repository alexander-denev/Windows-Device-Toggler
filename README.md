# Windows-Device-Toggler

Toggle a HID/PnP device with this script.

Run once to open to tray.  
Run while opened to tray to toggle.  
Example: Windows stylus button => run script => toggle touchscreen

## Options
Example of the options file can be found in `/out`

### Device Id
This can be found in  
`Device Manager => Choose Device => Details => Hardware Instance Path`

### Hotkey
This uses Autohotkey's hotkey syntax. [See here.](https://www.autohotkey.com/docs/v2/KeyList.htm)

### ClickCount
This is the amount of times you must click on the tray icon in rapid succession to toggle the device.