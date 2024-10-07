; debugger
class Debug {
    __New(filename) {
        this.filename := filename
        this.file := FileOpen(filename, "w")
    }
    ; Append to debug log
    append(text) {
        this.file.WriteLine(text)
    }
    close() {
        this.file.Close()
    }
}