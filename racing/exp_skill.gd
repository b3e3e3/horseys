class_name ExpressionSkill extends Skill

@export_multiline var should_activate_expression: String
@export_multiline var on_activate_expression: String


func activate(info: RaceInfo, horsey: Horsey) -> void:
	evaluate_exp(on_activate_expression, get_exp_context(info, horsey))
	super.activate(info, horsey)

func can_activate(info: RaceInfo, horsey: Horsey) -> bool:
	return evaluate_exp(
		should_activate_expression,
		get_exp_context(info, horsey)
	) and super.can_activate(info, horsey)

func get_exp_context(info: RaceInfo, horsey: Horsey) -> Dictionary:
	var context = {
		"phase": info.get_current_phase(horsey),
		"act_chance": 0.5,
		"random": randf_range(0.0, 1.0),
		"horsey": horsey,
		# "info": info,
	}

	for key in RaceInfo.Phase.keys():
		context[key] = RaceInfo.Phase[key]

	return context

func evaluate_exp(command, context: Dictionary = {}) -> Variant:
	var expression = Expression.new()
	var error = expression.parse(command, context.keys())
	if error != OK:
		push_error(expression.get_error_text())
		return null

	var result = expression.execute(context.values(), self)

	if expression.has_execute_failed(): return null
	return result
