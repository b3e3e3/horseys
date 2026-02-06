"use server"


import { loadDummyFile, /* loadDummyFileList,*/ loadDummyFilesFromDir } from "./dummy"

// export async function getDummyFileList(
// ): Promise<Record<string, string[]>> {
// 	return await loadDummyFileList()
// }

export async function getDummyFilesFromDir(dirName: string): Promise<string[]> {
	return await loadDummyFilesFromDir(dirName)
}

export async function getDummyFileContents(
	fileName: string,
	from: string,
): Promise<string> {
	return await loadDummyFile(fileName, from)
}
