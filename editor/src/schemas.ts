import { RJSFSchema } from "@rjsf/utils"

import * as Skill from "./schemas/skill.schema.json"
import * as Horsey from "./schemas/horsey.schema.json"

export const SCHEMAS: { Horsey: RJSFSchema; Skill: RJSFSchema } = {
	Horsey: Horsey as RJSFSchema,
	Skill: Skill as RJSFSchema,
}

export type SchemaType = "Horsey" | "Skill"
