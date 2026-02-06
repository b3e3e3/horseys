export type GlobalCtxObject<T> = {
	value: T
	[key: string]: any
}

export type GodotSignal = {
	connect: (callback: (...any) => void, flags: ConnectFlags = ConnectFlags.CONNECT_NORMAL) => void
}

export type GodotGlobal = {
	[key: any]: any
	ctx: {
		[key: any]: any
		horseys: GlobalCtxObject<string[]>
		skills: GlobalCtxObject<string[]>
	}
	loader: {
		getFilesInDir: (dirName: string) => string[]
		getFileContents: (fileName: string, dirName: string) => string
		testFuncRemoveAsap?: () => string

		fileLoaded?: GodotSignal
		dirLoaded?: GodotSignal
	}
}
