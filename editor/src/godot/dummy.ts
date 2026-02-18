import * as fs from "fs"

const dummyBaseDir = `${process.cwd()}/src/dummyData`

export function loadDummyFileList(): Record<string, string[]> {
	const dirs = ["horseys", "skills"]
	const fileNames: Record<string, string[]> = {}

	for (const dirName of dirs) {
		fileNames[dirName] = loadDummyFilesFromDir(dirName)
	}

	return fileNames
}

export function loadDummyFilesFromDir(dirName: string): string[] {
	const files = []
	const dir = fs.readdirSync(`${dummyBaseDir}/${dirName}`)
	for (const fileName of dir) {
		files.push(fileName)
	}

	return files
}

export function loadDummyFile(
	fileName: string,
	from: string,
): string {
	const file = fs.readFileSync(`${dummyBaseDir}/${from}/${fileName}`, {
		encoding: "utf8",
	})
	return file
}
