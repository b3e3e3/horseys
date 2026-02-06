class_name FileLoader extends RefCounted

signal fileLoaded(contents: String, dirName: String)
signal dirLoaded(files: Array[String], dirName: String)

const baseDir := "res://data"


func getFilesInDir(dirName: String) -> Array[String]:
    var dir := DirAccess.open("%s/%s" % [baseDir, dirName])
    var files := dir.get_files()
    dirLoaded.emit(files, dirName)

    return files

func getFileContents(fileName: String, dirName: String) -> String:
    var file := FileAccess.open("%s/%s/%s" % [baseDir, dirName, fileName], FileAccess.READ)
    var contents := file.get_as_text()

    fileLoaded.emit(contents, dirName)

    return contents

func testFuncRemoveAsap() -> void:
    print("Hello, world!!!")