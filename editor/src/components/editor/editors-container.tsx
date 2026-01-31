import React from "react"

import * as Skill from "../../schemas/skill.schema.json"
import * as Horsey from "../../schemas/horsey.schema.json"

import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { Button } from "@/components/ui/button"

import Form from "@rjsf/shadcn"
import { RJSFSchema } from "@rjsf/utils"

import validator from "@rjsf/validator-ajv8"
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
import { Plus, X } from "lucide-react"
import {
	DropdownMenu,
	DropdownMenuContent,
	DropdownMenuTrigger,
	DropdownMenuItem,
} from "@/components/ui/dropdown-menu"
import { ButtonGroup } from "@/components/ui/button-group"

const SCHEMAS: { Horsey: RJSFSchema; Skill: RJSFSchema } = {
	Horsey: Horsey as RJSFSchema,
	Skill: Skill as RJSFSchema,
}

type SchemaType = "Horsey" | "Skill"

type Editor = {
	type: SchemaType
	isUnsaved?: boolean
}

type EditorKey = string

type EditorIds = Record<EditorKey, Editor>

type JsonEditorProps = {
	schemaType: SchemaType
	editorData?: unknown
	onChange?: (formData: any) => void
	onSubmit?: (formData: any) => void
}

function JsonEditor({
	schemaType,
	editorData,
	onChange,
	onSubmit,
}: JsonEditorProps) {
	return (
		<Form
			schema={SCHEMAS[schemaType]}
			formData={editorData}
			validator={validator}
			onChange={({ formData }) => {
				onChange?.(formData)
			}}
			onSubmit={({ formData }) => {
				onSubmit?.(formData)
			}}
		/>
	)
}

export default function EditorsContainer() {
	const [editorsById, setEditorById] = React.useState<EditorIds>({})
	const [editorOrder, setEditorOrder] = React.useState<string[]>([])
	const [activeEditorId, setActiveEditorId] = React.useState<EditorKey>("")
	const [editorDataById, setEditorDataById] = React.useState<
		Record<EditorKey, any>
	>({})

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

	function createEditor(type: SchemaType) {
		const id = `${type.toLowerCase()}${countByType(type) + 1}`
		console.log("Creating editor...")
		setEditorById((prev) => ({
			...prev,
			[id]: { id, type },
		}))

		setEditorOrder((prev) => [...prev, id])
		setActiveEditorId(id)
		setEditorDataById((prev) => ({
			...prev,
			[id]: {},
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

		// delete editorDataRef.current[id]
		setEditorDataById((prev) => {
			const { [id]: _, ...rest } = prev
			return rest
		})
	}

	function handleEditorChange(id: EditorKey, formData: any) {
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
	}

	return (
		<>
			<Dialog>
				<Tabs value={activeEditorId} onValueChange={setActiveEditorId}>
					<TabsList>
						{editorOrder.map((id) => {
							const data = editorDataById[id]
							return (
								<ButtonGroup>
									<TabsTrigger value={id} key={id}>
										{data.name ?? "Untitled"}
										{editorsById[id].isUnsaved && (
											<span className="text-destructive">
												*
											</span>
										)}
									</TabsTrigger>
									{activeEditorId == id ? (
										<DialogTrigger asChild>
											<Button
												size="xs"
												className="m-auto"
												variant={"ghost"}
											>
												<X />
											</Button>
										</DialogTrigger>
									) : null}
								</ButtonGroup>
							)
						})}
						<NewDropdown>
							<DropdownMenuTrigger asChild>
								<Button variant={"ghost"}>
									<Plus />
								</Button>
							</DropdownMenuTrigger>
						</NewDropdown>
					</TabsList>

					{/* No editors open splash */}
					{Object.keys(editorsById).length == 0 && (
						<div className="w-full">
							<h3 className="text-center text-gray-400 w-full">
								No editors open!{" "}
								<NewDropdown>
									<DropdownMenuTrigger asChild>
										<Button
											variant={"link"}
											className="underline"
										>
											Create a file?
										</Button>
									</DropdownMenuTrigger>
								</NewDropdown>
							</h3>
						</div>
					)}

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
		</>
	)
}
