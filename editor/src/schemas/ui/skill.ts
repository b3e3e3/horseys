import { UiSchema } from "@rjsf/utils"

const SkillUISchema: UiSchema = {
	"ui:field": "LayoutGridField",
	"ui:layoutGrid": {
		"ui:row": {
			className: "grid grid-cols-12 gap-4",
			children: [
				{
					"ui:col": {
						className: "col-span-6",
						children: ["name"],
					},
				},
				{
					"ui:col": {
						className: "col-span-6",
						children: ["bp_effectiveness"],
					},
				},
				{
					"ui:col": {
						className: "col-span-6",
						children: ["conditions"],
					},
				},
				{
					"ui:col": {
						className: "col-span-6",
						children: ["effects"],
					},
				},
			],
		},
	},
	bp_effectiveness: {
		"ui:widget": "range",
		"ui:options": {
			step: 0.05,
		},
	},
}

export default SkillUISchema
