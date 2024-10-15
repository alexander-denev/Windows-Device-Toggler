; INI utility library.
class INI {
    ; Parse an INI file into an object.
    static parse(text) {
        object := { sections: [] }
        currentSection := ""
        for line in StrSplit(text, "`r`n", " `t") {

            if (line = "" || SubStr(line, 1, 1) = ";") {
                continue
            }

            if (SubStr(line, 1, 1) = "[" && SubStr(line, -1) = "]") {
                currentSection := SubStr(line, 2, -1)
                object.sections.Push({ sectionName: currentSection })
                continue
            }

            splitIndex := InStr(line, "=")
            key := Trim(SubStr(line, 1, splitIndex - 1))
            value := Trim(SubStr(line, splitIndex + 1), " `t`"")

            if (currentSection) {
                object.sections[-1].%key% := value
            } else {
                object.%key% := value
            }
        }
        /* object example:
        {
            globalValue: "global value",
            sections: [
                {
                    sectionName: "section1",
                    key1: "value1",
                    key2: "value2"
                }
                {
                    sectionName: "section2",
                    key1: "value1",
                    key2: "value2"
                }
            ]
        }
        
        */
        return object
    }
}