import { promises as fs } from "fs"

const getBaseDir = () => `${process.cwd()}/src/dummyData`

export async function loadDataFileList(): Promise<Record<string, string[]>> {
	const dirs = ["horseys", "skills"]

	const fileNames: Record<string, string[]> = {}

	for (const dirName of dirs) {
		fileNames[dirName] = []
		const dir = await fs.readdir(`${getBaseDir()}/${dirName}`)
		for (const fileName of dir) {
			// const file = await fs.readFile(fileName, { encoding: "utf8" })
			fileNames[dirName].push(fileName)
		}
	}

	return fileNames
}

export async function loadDataFile(
	fileName: string,
	from: string,
): Promise<string> {
	const file = await fs.readFile(`${getBaseDir()}/${from}/${fileName}`, {
		encoding: "utf8",
	})
	return file
}
