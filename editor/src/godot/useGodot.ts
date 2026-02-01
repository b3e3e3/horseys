import { promises as fs } from "fs"

export async function loadDataFileList(): Promise<Record<string, string[]>> {
	const dirs = ["horseys", "skills"]

	const fileNames: Record<string, string[]> = {}

	for (const dirName of dirs) {
		fileNames[dirName] = []
		const dir = await fs.readdir(
			`${process.cwd()}/src/dummyData/${dirName}`,
		)
		for (const fileName of dir) {
			// const file = await fs.readFile(fileName, { encoding: "utf8" })
			fileNames[dirName].push(fileName)
		}
	}

	return fileNames
}
