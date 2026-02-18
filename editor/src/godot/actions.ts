"use server"


import { loadDummyFile, /* loadDummyFileList,*/ loadDummyFilesFromDir } from "./dummy"

// export async function getDummyFileList(
// ): Promise<Record<string, string[]>> {
// 	return await loadDummyFileList()
// }

// export async function getDummyFilesFromDir(dirName: string): Promise<string[]> {
// 	return await loadDummyFilesFromDir(dirName)
// }

// export async function getDummyFileContents(
// 	fileName: string,
// 	from: string,
// ): Promise<string> {
// 	return await loadDummyFile(fileName, from)
// }

// export async function requestFilesInDir(godot_window: GodotWindow, dir_name: string) {
// 	godot_window.sendIpcMessage?.(JSON.stringify({
// 		type: "request_files_in_dir",
// 		dir: dir_name,
// 	}))
// }

// export async function requestFileContents(godot_window: GodotWindow, file_name: string, dir_name: string) {
// 	godot_window.sendIpcMessage?.(JSON.stringify({
// 		type: "request_file_contents",
// 		file: file_name,
// 		dir: dir_name,
// 	}))
// }