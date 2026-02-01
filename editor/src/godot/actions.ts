"use server"

import { loadDataFileList } from "./useGodot"

export async function getGlobalFileList() {
	return await loadDataFileList()
}
