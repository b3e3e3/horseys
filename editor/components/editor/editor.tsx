import { Schemas, UiSchemas, SchemaType } from "@/src/schemas"
import Form from "@rjsf/shadcn"
import React from "react"

import validator from "@rjsf/validator-ajv8"
import { Button } from "@/components/ui/button"
import { Separator } from "@/components/ui/separator"

export type Editor = {
	type: SchemaType
	isUnsaved?: boolean
}

export type EditorKey = string
export type EditorIds = Record<EditorKey, Editor>

export type JsonEditorProps = {
	schemaType: SchemaType
	editorData?: any
	onChange?: (formData: any) => void
	onSubmit?: (formData: any) => void
}

const JsonEditor = React.memo(
	({ schemaType, editorData, onChange, onSubmit }: JsonEditorProps) => {
		return (
			<Form
				schema={Schemas[schemaType]}
				uiSchema={UiSchemas[schemaType]}
				formData={editorData}
				validator={validator}
				onChange={({ formData }) => {
					onChange?.(formData)
				}}
				onSubmit={({ formData }) => {
					onSubmit?.(formData)
				}}
			>
				<Separator className="mt-5" />
				<div className="py-3">
					<Button type="submit" className="">
						Save {editorData?.name ?? schemaType}
					</Button>
				</div>
			</Form>
		)
	},
)
export default JsonEditor
