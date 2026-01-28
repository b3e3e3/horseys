extends Control


const IGNORE: Array = ["version"]

@onready var horsey_data := Global.load_json_file("res://data/horsey.schema.json")
@onready var skill_data := Global.load_json_file("res://data/skill.schema.json")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tabs := TabContainer.new()
	print(skill_data)

	tabs.add_child(create_object_control(horsey_data))
	tabs.add_child(create_object_control(skill_data))

	tabs.set_tab_title(0, "Horseys")
	tabs.set_tab_title(1, "Skills")

	tabs.size_flags_horizontal = SIZE_EXPAND_FILL

	$MainContainer.add_child(tabs)


func create_control(data: Dictionary, prop_name = "") -> Control:
	var control: Control
	var label: Control

	if prop_name is String and not prop_name.is_empty():
		label = Label.new()
		label.text = prop_name
	elif prop_name is Array:
		label = OptionButton.new()
		for p in prop_name:
			label.add_item(p)

	match data.get("type", ""):
		"integer", "number":
			control = SpinBox.new()
		"string":
			if data.has("enum"):
				control = OptionButton.new()
				for o in data.get("enum"):
					control.add_item(o)
			else:
				control = LineEdit.new()
		"object":
			var multi := data.has("additionalProperties") and data.get("additionalProperties") is Dictionary
			print(multi)
			if multi:
				control = create_multi_object_control(data, prop_name)
			else:
				control = create_object_control(data, prop_name)
		"array":
			control = create_array_control(data, prop_name)
		_:
			control = Label.new()
			control.text = "%s (%s) has no match" % [prop_name, data.get("type")]

	var prop_container := HBoxContainer.new()

	if label:
		prop_container.add_child(label)
		label.size_flags_horizontal = SIZE_EXPAND_FILL

	prop_container.add_child(control)

	prop_container.size_flags_horizontal = SIZE_EXPAND_FILL
	control.size_flags_horizontal = SIZE_EXPAND_FILL


	return prop_container


func create_multi_object_control(data: Dictionary, prop_name: String = "Multi") -> Control:
	var main_container := VBoxContainer.new()
	var scroll_container := ScrollContainer.new()
	var items_container := VBoxContainer.new()
	scroll_container.custom_minimum_size.y = 100

	var add_button := Button.new()
	add_button.text = "+Add"

	var add_select := OptionButton.new()

	var properties := data.get("properties", {}) as Dictionary
	var additional_properties = data.get("additionalProperties")

	if data.has("properties"):
		for p in properties:
			add_select.add_item(p)
	# if data.has("additionalProperties") and additional_properties is Dictionary:
	# 	for p in additional_properties:
	# 		add_select.add_item(p)
	# 	)

	add_button.pressed.connect(func():
		var idx := add_select.get_item_text(add_select.selected)
		var new_obj := create_control(properties[idx], properties.keys())
		print(idx)
		items_container.add_child(new_obj)
	)

	scroll_container.add_child(items_container)
	main_container.add_child(scroll_container)
	main_container.add_child(add_button)

	scroll_container.size_flags_horizontal = SIZE_EXPAND_FILL
	main_container.size_flags_horizontal = SIZE_EXPAND_FILL
	items_container.size_flags_horizontal = SIZE_EXPAND_FILL
	add_button.size_flags_horizontal = SIZE_EXPAND_FILL

	return main_container

func create_array_control(data: Dictionary, prop_name: String = "Array") -> Control:
	var main_container := VBoxContainer.new()
	var scroll_container := ScrollContainer.new()
	var items_container := VBoxContainer.new()
	scroll_container.custom_minimum_size.y = 100

	var add_button := Button.new()
	add_button.text = "+Add"

	add_button.pressed.connect(func():
		var items = data.get("items")

		if items is Array:
			var new_obj := create_control(items[0])
			print(items[0])
			items_container.add_child(new_obj)
		elif items is Dictionary:
			var new_obj := create_object_control(items)
			print(items)
			items_container.add_child(new_obj)
	)

	scroll_container.add_child(items_container)
	main_container.add_child(scroll_container)
	main_container.add_child(add_button)

	scroll_container.size_flags_horizontal = SIZE_EXPAND_FILL
	main_container.size_flags_horizontal = SIZE_EXPAND_FILL
	items_container.size_flags_horizontal = SIZE_EXPAND_FILL
	add_button.size_flags_horizontal = SIZE_EXPAND_FILL

	return main_container

func create_object_control(data: Dictionary, prop_name: String = "") -> Control:
	var main_container := MarginContainer.new()
	var panel_container := PanelContainer.new()
	var scroll_container := ScrollContainer.new()
	var obj_container := VBoxContainer.new()


	var properties: Dictionary = data.get("properties", {})
	var additional_properties = data.get("additionalProperties")

	var handle := func(prop: Dictionary, p: String):
		var control := create_control(prop, p)
		obj_container.add_child.call_deferred(control)

	for p in properties:
		handle.call(properties.get(p), p)

	if additional_properties is Dictionary:
		handle.call(additional_properties, "")


	panel_container.add_child(obj_container)
	main_container.add_child(panel_container)

	main_container.size_flags_horizontal = SIZE_EXPAND_FILL
	panel_container.size_flags_horizontal = SIZE_EXPAND_FILL
	scroll_container.size_flags_horizontal = SIZE_EXPAND_FILL
	obj_container.size_flags_horizontal = SIZE_EXPAND_FILL

	return main_container
