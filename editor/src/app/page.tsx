"use client"

import EditorsContainer from "@/components/editor/editorsContainer"
import { use$g } from "@/components/godotProvider"

export default function Home() {
	const $g = use$g()

	if (!$g) return <h1>LOADING</h1>

	return (
		<div className="h-screen">
			<EditorsContainer context={$g} />
		</div>
	)
}
