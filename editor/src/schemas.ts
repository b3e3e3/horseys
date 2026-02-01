import { RJSFSchema, UiSchema } from "@rjsf/utils"

import * as Skill from "./schemas/skill.schema.json"
import * as Horsey from "./schemas/horsey.schema.json"
import HorseyUISchema from "./schemas/ui/horsey"
import SkillUISchema from "./schemas/ui/skill"

export const Schemas: { Horsey: RJSFSchema; Skill: RJSFSchema } = {
	Horsey: Horsey as RJSFSchema,
	Skill: Skill as RJSFSchema,
}

export const UiSchemas: { Horsey: UiSchema; Skill: UiSchema } = {
	Horsey: HorseyUISchema,
	Skill: SkillUISchema,
}

export type SchemaType = "Horsey" | "Skill"
