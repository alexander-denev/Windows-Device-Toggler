; INI utility library.
class INI {
    ; Parse an INI file into an object.
    static parse(text) {
        object := {sections: {}}
        currentSection := ""
        for line in StrSplit(text, "`r`n", " `t") {

            if (line = "" || SubStr(line, 1, 1) = ";") {
                continue
            }

            if (SubStr(line, 1, 1) = "[" && SubStr(line, -1) = "]") {
                currentSection := SubStr(line, 2, -1)
                object.sections.%currentSection% := {}
                continue
            }

            splitIndex := InStr(line, "=")
            key := Trim(SubStr(line, 1, splitIndex - 1))
            value := Trim(SubStr(line, splitIndex + 1), " `t`"")

            if (currentSection) {
                object.sections.%currentSection%.%key% := value
            } else {
                object.%key% := value
            }
        }
        return object
    }
}