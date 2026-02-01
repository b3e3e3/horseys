import { UiSchema } from "@rjsf/utils"

const HorseyUISchema: UiSchema = {
	"ui:field": "LayoutGridField",
	"ui:layoutGrid": {
		"ui:row": {
			className: "grid grid-cols-5 gap-4",
			children: [
				{
					"ui:col": {
						className: "col-span-full",
						children: ["name"],
					},
				},
				{
					"ui:columns": {
						className: "grid-span-2",
						children: [
							"stats.speed",
							"stats.stamina",
							"stats.power",
							"stats.resolve",
							"stats.brainpower",
						],
					},
				},
				{
					"ui:col": {
						className: "col-span-full",
						children: ["skills"],
					},
				},
			],
		},
	},
	stats: {
		// "ui:field": "LayoutHeaderField",

		speed: {
			// "ui:widget": "range",
			// "ui:options": { step: 1 },
		},
		stamina: {
			// "ui:widget": "range",
			// "ui:options": { step: 1 },
		},
		power: {
			// "ui:widget": "range",
			// "ui:options": { step: 1 },
		},
		resolve: {
			// "ui:widget": "range",
			// "ui:options": { step: 1 },
		},
		brainpower: {
			// "ui:widget": "range",
			// "ui:options": { step: 1 },
		},
	},
	skills: {
		// "ui:field": "LayoutHeaderField",
	},
}

export default HorseyUISchema
