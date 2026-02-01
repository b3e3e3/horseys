import { SCHEMAS, SchemaType } from "@/src/schemas"
import Form from "@rjsf/shadcn"
import React from "react"

import validator from "@rjsf/validator-ajv8"

export type Editor = {
	type: SchemaType
	isUnsaved?: boolean
}

export type EditorKey = string
export type EditorIds = Record<EditorKey, Editor>

export type JsonEditorProps = {
	schemaType: SchemaType
	editorData?: unknown
	onChange?: (formData: any) => void
	onSubmit?: (formData: any) => void
}

const JsonEditor = React.memo(
	({ schemaType, editorData, onChange, onSubmit }: JsonEditorProps) => {
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
	},
)
export default JsonEditor
