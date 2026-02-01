"use client"

import { getGlobalFileList } from "@/src/godot/actions"
import { GlobalCtx } from "@/src/godot/types"
import { createContext, useContext, useEffect, useState } from "react"

const GodotContext = createContext<any>(null)

const init = async () => {
	const global: GlobalCtx = {
		horseys: {
			value: [],
		},
		skills: {
			value: [],
		},
	}
	const fileList = await getGlobalFileList()

	Object.entries(fileList).forEach(([type, files]) => {
		global[type].value = files
	})

	return global
}

export function useGodot() {
	const [$g, set$g] = useState<GlobalCtx | null>(null)

	useEffect(() => {
		const the = () => {
			init().then((ctx) => {
				;(window as any).$g ??= ctx
				set$g((window as any).$g)
			})
		}

		if ("godot" in window) {
			window.addEventListener("godot.ready", the, { once: true })
		} else the()
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
