"use client"

import { SchemaList } from "@/components/schemaList"
import EditorsContainer from "../../components/editor/editorsContext"
import { use$g } from "@/components/godotProvider"

export default function Home() {
	const $g = use$g()

	if (!$g) return <h1>LOADING</h1>

	return (
		<div className="min-h-screen">
			<div className="flex">
				<aside className="w-64 bg-background border-r">
					<div className="p-4">
						<SchemaList
							onFileSelected={(name: string, from: string) =>
								console.log(
									`Loading file ${name} from ${from}...`,
								)
							}
							items={[
								{
									value: "horseys",
									trigger: "Horseys",
									files: $g.horseys.value,
								},
								{
									value: "skills",
									trigger: "Skills",
									files: $g.skills.value,
								},
							]}
						/>
					</div>
				</aside>
				<main className="flex-1 overflow-auto p-5">
					<EditorsContainer />
				</main>
			</div>
		</div>
	)
}
