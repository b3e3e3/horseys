"use client"

import { getDummyFileContents, getDummyFilesFromDir } from "@/src/godot/actions"
// import { getDummyFileList } from "@/src/godot/actions"
import { GodotGlobal } from "@/src/godot/types"
import { createContext, useContext, useEffect, useState } from "react"

const GodotContext = createContext<any>(null)

export const ctxIsGodot = (ctx: any) => ctx["___callbacks"] !== undefined

export function useGodot() {
	const [$g, set$g] = useState<GodotGlobal | null>(null)

	useEffect(() => {
		if ((window as any).$g) {
			console.log("Found Godot context in window.")
		}


		console.log("Initialized :P");

		var dummyGlobal: GodotGlobal = {
			ctx: {
				horseys: { value: [] },
				skills: { value: [] },
			},
			loader: {
				getFilesInDir: (dirName: string) => ["foobar.json"],//getDummyFilesFromDir(dirName),
				getFileContents: (fileName: string, from: string) => `{"name": "NaH"}`,//getDummyFileContents(fileName, from)
			}
		};

		// if ((window as any).$g) {
		// 	const g = (window as any).$g
		// 	g.loader = {
		// 		getFilesInDir: async (dirName: string) => {
		// 			(window as any).$g.loader.getFilesIndir(dirName)
		// 		},
		// 		getFileContents: async (fileName: string, from: string) => {
		// 			(window as any).$g.loader.getFileContents()
		// 		}
		// 	}

		// 	set$g(g)
		// } else {
		// 	set$g(dummyGlobal)
		// }
		set$g((window as any).$g ?? dummyGlobal)

		// the()
	}, [])

	return $g
}

export function GodotProvider({ children }: any) {
	const $g = useGodot()
	return <GodotContext.Provider value={$g}>{children}</GodotContext.Provider>
}

export function use$g() {
	return useContext(GodotContext)
}
