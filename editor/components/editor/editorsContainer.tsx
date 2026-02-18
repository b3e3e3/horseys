import React, { PropsWithChildren, useEffect } from "react"

import { SchemaType } from "@/src/schemas"
import JsonEditor, { EditorIds, EditorKey } from "@/components/editor/editor"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { Button } from "@/components/ui/button"
import {
	Dialog,
	DialogClose,
	DialogContent,
	DialogDescription,
	DialogFooter,
	DialogHeader,
	DialogTitle,
	DialogTrigger,
} from "@/components/ui/dialog"
import {
	DropdownMenu,
	DropdownMenuContent,
	DropdownMenuTrigger,
	DropdownMenuItem,
} from "@/components/ui/dropdown-menu"
import { ButtonGroup } from "@/components/ui/button-group"

import { Plus, X } from "lucide-react"
import { SchemaList } from "@/components/schemaList"
import { flushSync } from "react-dom"

export function requestFilesInDir(dir_name: string) {
	(window as GodotWindow).sendIpcMessage?.(JSON.stringify({
		type: "request_files_in_dir",
		dir: dir_name,
	}))
}

export function requestFileContents(file_name: string, dir_name: string) {
	(window as GodotWindow).sendIpcMessage?.(JSON.stringify({
		type: "request_file_contents",
		file: file_name,
		dir: dir_name,
	}))
}

// TODO: why does ctx get stored in an object {ctx: {...}}? this is not defined anywhere??
export default function EditorsContainer() {
	const [editorsById, setEditorById] = React.useState<EditorIds>({})
	const [editorOrder, setEditorOrder] = React.useState<string[]>([])
	const [activeEditorId, setActiveEditorId] = React.useState<EditorKey>("")
	const [editorDataById, setEditorDataById] = React.useState<
		Record<EditorKey, any>
	>({})

	const [horseyFileList, setHorseyFileList] = React.useState<[string] | []>([])
	const [skillFileList, setSkillFileList] = React.useState<[string] | []>([]);


	useEffect(() => {
		(window as GodotWindow).onIpcMessage = function (msg) {
			var response = JSON.parse(msg)
			if (typeof response === "string") {
				console.log("WARNING: IPC response is string", msg)
				return
			}
			var type = response["type"]

			console.log("Got IPC message: ", type, response["data"])
			switch (type) {
				case "files_in_dir":
					var data = response["data"]
					var dir = response["dir"] as string
					switch (dir) {
						case "horseys":
							console.log("Setting horsey file list")
							setHorseyFileList(data)
							break
						case "skills":
							console.log("Setting skills file list")
							setSkillFileList(data)
							break
						default:
							console.log("Couldn't find dir ", dir)
							break
					}

					break
				case "file_contents":
					var data = JSON.parse(response["data"])
					var dir = response["dir"] as string
					break
				default:
					console.log("Couldn't find IPC type ", type)
					break
			}
		}

		requestFilesInDir("horseys")
		requestFilesInDir("skills");
	})

	const countByType = (type: SchemaType) =>
		Object.values(editorsById).filter((e) => e.type === type).length

	function NewDropdown({ children }: any) {
		return (
			<DropdownMenu>
				{children}
				<DropdownMenuContent>
					<DropdownMenuItem
						onClick={() => {
							createEditor("Horsey")
						}}
					>
						Create Horsey...
					</DropdownMenuItem>
					<DropdownMenuItem
						onClick={() => {
							createEditor("Skill")
						}}
					>
						Create Skill...
					</DropdownMenuItem>
				</DropdownMenuContent>
			</DropdownMenu>
		)
	}

	function createEditor(type: SchemaType, initialData?: any) {
		const id = `${type.toLowerCase()}${countByType(type) + 1}`
		console.log("Creating editor... with type", type)
		setEditorById((prev) => ({
			...prev,
			[id]: { id, type },
		}))

		setEditorOrder((prev) => [...prev, id])
		setActiveEditorId(id)
		setEditorDataById((prev) => ({
			...prev,
			[id]: initialData ?? {},
		}))
	}

	function closeEditor(id: EditorKey) {
		setEditorById((prev) => {
			const { [id]: _, ...rest } = prev
			return rest
		})

		setEditorOrder((prev) => {
			const idx = prev.indexOf(id)
			const next = prev[idx - 1] ?? prev[idx + 1]

			setActiveEditorId(next ?? "")

			return prev.filter((x) => x !== id)
		})

		setEditorDataById((prev) => {
			const { [id]: _, ...rest } = prev
			return rest
		})
	}

	const handleEditorChange = React.useCallback(
		(id: EditorKey, formData: any) => {
			setEditorDataById((prev) => {
				if (prev[id] === formData) return prev

				return {
					...prev,
					[id]: formData,
				}
			})

			setEditorById((prevEditor) => ({
				...prevEditor,
				[id]: {
					...prevEditor[id],
					isUnsaved: true,
				},
			}))
		},
		[],
	)

	const addButton = (
		<Button variant={"ghost"}>
			<Plus />
		</Button>
	)

	const noEditorsSplash = (
		<div className="w-full">
			<h3 className="text-center text-gray-400 w-full">
				No editors open!{" "}
				<NewDropdown>
					<DropdownMenuTrigger asChild>
						<Button variant={"link"} className="underline">
							Create a file?
						</Button>
					</DropdownMenuTrigger>
				</NewDropdown>
			</h3>
		</div>
	)

	return (
		<div className="flex h-full">
			<aside className="w-64 bg-background border-r">
				<div className="p-4">
					<SchemaList
						onFileSelected={async (name: string, from: string) => {
							console.log(`Loading file ${name} from ${from}...`)
							// const contents = loader.getFileContents(
							// 	name,
							// 	from,
							// ) ?? "{}"

						}}
						items={[
							{
								value: "horseys",
								trigger: "Horseys",
								files: horseyFileList,
							},
							{
								value: "skills",
								trigger: "Skills",
								files: skillFileList,
							},
						]}
					/>
				</div>
			</aside>
			<main className="flex-1 overflow-auto p-5">
				<Dialog>
					<Tabs
						value={activeEditorId}
						onValueChange={setActiveEditorId}
					>
						<TabsList>
							{editorOrder.map((id) => {
								const data = editorDataById[id]
								const unsavedMarker = (
									<span className="text-destructive">*</span>
								)
								const closeButton = (
									<Button
										size="xs"
										className="m-auto"
										variant={"ghost"}
									>
										<X />
									</Button>
								)
								return (
									<ButtonGroup key={id}>
										<TabsTrigger value={id} key={id}>
											{data.name ?? "Untitled"}
											{editorsById[id].isUnsaved &&
												unsavedMarker}
										</TabsTrigger>
										{activeEditorId == id ? (
											<DialogTrigger asChild>
												{closeButton}
											</DialogTrigger>
										) : null}
									</ButtonGroup>
								)
							})}
							<NewDropdown>
								<DropdownMenuTrigger asChild>
									{addButton}
								</DropdownMenuTrigger>
							</NewDropdown>
						</TabsList>

						{Object.keys(editorsById).length == 0 &&
							noEditorsSplash}

						{/* Editor windows */}
						{editorOrder.map((id) => {
							const editor = editorsById[id]
							const data = editorDataById[id]

							return (
								<TabsContent key={id} value={id}>
									<JsonEditor
										schemaType={editor.type}
										editorData={data ?? {}}
										onChange={(formData) => {
											handleEditorChange(id, formData)
										}}
									/>
								</TabsContent>
							)
						})}
					</Tabs>

					{/* Close warning dialog */}
					<DialogContent>
						<DialogHeader>
							<DialogTitle>Are you absolutely sure?</DialogTitle>
							<DialogDescription>
								Document has not been saved.
							</DialogDescription>
						</DialogHeader>
						<DialogFooter>
							<DialogClose asChild>
								<Button variant={"outline"}>Cancel</Button>
							</DialogClose>
							<DialogClose type="submit" asChild>
								<Button
									variant={"destructive"}
									onClick={() => {
										closeEditor(activeEditorId)
									}}
								>
									Close
								</Button>
							</DialogClose>
						</DialogFooter>
					</DialogContent>
				</Dialog>
			</main>
		</div>
	)
}
