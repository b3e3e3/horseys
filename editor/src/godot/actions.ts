"use server"

import { loadDataFile, loadDataFileList } from "./useGodot"

export async function getGlobalFileList(): Promise<Record<string, string[]>> {
	return await loadDataFileList()
}

export async function getDataFileContents(
	fileName: string,
	from: string,
): Promise<string> {
	return await loadDataFile(fileName, from)
}
