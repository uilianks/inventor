extends Control

@onready var button = $Button
@onready var option = $"../Body/Recipes/OptionButton"
@onready var body = $"../Body/Recipes"

var timer: Timer
var crafting: bool = false
var current_recipe: Recipe = null
var recipe_slots: Dictionary = {}

@export var recipes: Array[Recipe] = []

const SLOT_SCENE = preload("res://Interface/Slot/slot.tscn")

func _ready() -> void:
	button.disabled = true

	timer = Timer.new()
	timer.one_shot = true
	timer.timeout.connect(_on_craft_done)
	add_child(timer)

	button.pressed.connect(_on_craft)
	option.item_selected.connect(_on_recipe_selected)

	option.clear()
	for r in recipes:
		option.add_item(r.name)
		_generate_recipe_node(r)

	if recipes.size() > 0:
		_on_recipe_selected(0)

func _generate_recipe_node(recipe: Recipe) -> void:
	var hbox = HBoxContainer.new()
	hbox.name = recipe.name
	hbox.hide()
	hbox.add_theme_constant_override("separation", 20)

	# Input
	var input_vbox = VBoxContainer.new()
	input_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var input_label = Label.new()
	input_label.text = "Input"
	input_vbox.add_child(input_label)

	var input_slots = []
	for ingredient in recipe.ingredients:
		if ingredient == null or ingredient.item == null:
			continue
		var slot = SLOT_SCENE.instantiate()
		slot.item_aceito = ingredient.item.name
		slot.quantidade_necessaria = ingredient.amount
		input_vbox.add_child(slot)
		input_slots.append(slot)

	# Output
	var output_vbox = VBoxContainer.new()
	output_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var output_label = Label.new()
	output_label.text = "Output"
	output_vbox.add_child(output_label)

	var slot_output = SLOT_SCENE.instantiate()
	output_vbox.add_child(slot_output)

	hbox.add_child(input_vbox)
	hbox.add_child(output_vbox)
	body.add_child(hbox)

	# Chama _update depois de estar na árvore
	for slot in input_slots:
		slot.call("_update")
	slot_output.call("_update")

	# Conecta sinais
	for slot in input_slots:
		slot.slot_atualizado.connect(_check)

	recipe_slots[recipe.name] = { "inputs": input_slots, "output": slot_output }

func _on_recipe_selected(index: int) -> void:
	# Desconecta todos os slots de todas as receitas
	for rname in recipe_slots:
		for slot in recipe_slots[rname]["inputs"]:
			if slot.slot_atualizado.is_connected(_check):
				slot.slot_atualizado.disconnect(_check)

	current_recipe = recipes[index]

	# Esconde tudo menos o OptionButton
	for child in body.get_children():
		if child != option:
			child.hide()

	# Mostra a receita selecionada
	var recipe_node = body.get_node_or_null(current_recipe.name)
	if recipe_node:
		recipe_node.show()

	# Reconecta só os slots da receita atual
	if recipe_slots.has(current_recipe.name):
		for slot in recipe_slots[current_recipe.name]["inputs"]:
			slot.slot_atualizado.connect(_check)

	_check()

func _check() -> void:
	if crafting or current_recipe == null:
		button.disabled = true
		return
	if not recipe_slots.has(current_recipe.name):
		button.disabled = true
		return
	var data = recipe_slots[current_recipe.name]
	var input_slots = data["inputs"]
	for i in input_slots.size():
		var slot = input_slots[i]
		var ingredient = current_recipe.ingredients[i]
		if slot.item == null or slot.item.name != ingredient.item.name or slot.quantidade < ingredient.amount:
			button.disabled = true
			return
	button.disabled = false

func _on_craft() -> void:
	crafting = true
	button.disabled = true
	timer.wait_time = current_recipe.time
	timer.start()

func _on_craft_done() -> void:
	crafting = false
	var data = recipe_slots[current_recipe.name]
	var input_slots = data["inputs"]
	var output_slot = data["output"]
	for i in input_slots.size():
		var slot = input_slots[i]
		var ingredient = current_recipe.ingredients[i]
		slot.quantidade -= ingredient.amount
		if slot.quantidade <= 0:
			slot.item = null
			slot.quantidade = 0
		slot.call("_update")
	output_slot.item = current_recipe.output_item
	output_slot.quantidade += current_recipe.output_amount
	output_slot.call("_update")
	_check()
