extends Control

@onready var mesa = $Panel/VBoxContainer/Mesa
@onready var cadeira = $Panel/VBoxContainer/Cadeira
@onready var option = $Panel/VBoxContainer/HBoxContainer2/OptionButton
@onready var btn_craft = $Panel/VBoxContainer/Button

# Chair slots
@onready var chair_input = $Panel/VBoxContainer/Cadeira/VBoxContainer/Slot
@onready var chair_output = $Panel/VBoxContainer/Cadeira/VBoxContainer2/Slot

# Table slots
@onready var table_input1 = $Panel/VBoxContainer/Mesa/VBoxContainer/Slot
@onready var table_input2 = $Panel/VBoxContainer/Mesa/VBoxContainer/Slot2
@onready var table_output = $Panel/VBoxContainer/Mesa/VBoxContainer2/Slot

var recipes: Array[Recipe] = []
var current_recipe: Recipe = null
var crafting: bool = false
var timer: Timer

func _ready() -> void:
	mesa.hide()
	cadeira.hide()

	# Load recipes from RecipeBook
	recipes = RecipeBook.get_all()

	# Populate OptionButton
	option.clear()
	for r in recipes:
		option.add_item(r.name)

	# Setup slots
	_setup_slots()

	# Timer
	timer = Timer.new()
	timer.one_shot = true
	timer.timeout.connect(_on_craft_done)
	add_child(timer)

	btn_craft.pressed.connect(_on_craft)
	btn_craft.disabled = true

func _setup_slots() -> void:
	var chair = RecipeBook.get_by_name("Chair")
	chair_input.item_aceito = chair.inputs[0]["item"]
	chair_input.quantidade_necessaria = chair.inputs[0]["amount"]
	chair_input.slot_atualizado.connect(_check_can_craft)

	var table = RecipeBook.get_by_name("Table")
	table_input1.item_aceito = table.inputs[0]["item"]
	table_input1.quantidade_necessaria = table.inputs[0]["amount"]
	table_input1.slot_atualizado.connect(_check_can_craft)

	table_input2.item_aceito = table.inputs[1]["item"]
	table_input2.quantidade_necessaria = table.inputs[1]["amount"]
	table_input2.slot_atualizado.connect(_check_can_craft)

func _on_option_button_item_selected(index: int) -> void:
	cadeira.hide()
	mesa.hide()
	current_recipe = recipes[index]
	match index:
		0: cadeira.show()
		1: mesa.show()
	_check_can_craft()

func _check_can_craft() -> void:
	if crafting or current_recipe == null:
		btn_craft.disabled = true
		return

	var input_slots = _get_current_input_slots()
	for slot in input_slots:
		if slot.item != slot.item_aceito or slot.quantidade < slot.quantidade_necessaria:
			btn_craft.disabled = true
			return

	btn_craft.disabled = false

func _on_craft() -> void:
	crafting = true
	btn_craft.disabled = true
	timer.wait_time = current_recipe.time
	timer.start()
	print("Crafting %s... (%.1fs)" % [current_recipe.name, current_recipe.time])

func _on_craft_done() -> void:
	crafting = false

	# Consume inputs
	for slot in _get_current_input_slots():
		slot.quantidade -= slot.quantidade_necessaria
		if slot.quantidade <= 0:
			slot.item = null
			slot.quantidade = 0
		slot.call("_atualizar")

	# Place output
	var output_slot = _get_current_output_slot()
	output_slot.item = current_recipe.output_item
	output_slot.quantidade = current_recipe.output_amount
	output_slot.call("_atualizar")

	print("Done! %s x%d" % [current_recipe.output_item, current_recipe.output_amount])
	_check_can_craft()

func _get_current_input_slots() -> Array:
	match current_recipe.name:
		"Chair": return [chair_input]
		"Table": return [table_input1, table_input2]
	return []

func _get_current_output_slot():
	match current_recipe.name:
		"Chair": return chair_output
		"Table": return table_output
	return null
