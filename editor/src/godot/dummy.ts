import { promises as fs } from "fs"

const dummyBaseDir = `${process.cwd()}/src/dummyData`

export async function loadDummyFileList(): Promise<Record<string, string[]>> {
	const dirs = ["horseys", "skills"]
	const fileNames: Record<string, string[]> = {}

	for (const dirName of dirs) {
		fileNames[dirName] = await loadDummyFilesFromDir(dirName)
	}

	return fileNames
}

export async function loadDummyFilesFromDir(dirName: string): Promise<string[]> {
	const files = []
	const dir = await fs.readdir(`${dummyBaseDir}/${dirName}`)
	for (const fileName of dir) {
		// const file = await fs.readFile(fileName, { encoding: "utf8" })
		files.push(fileName)
	}

	return files
}

export async function loadDummyFile(
	fileName: string,
	from: string,
): Promise<string> {
	const file = await fs.readFile(`${dummyBaseDir}/${from}/${fileName}`, {
		encoding: "utf8",
	})
	return file
}
