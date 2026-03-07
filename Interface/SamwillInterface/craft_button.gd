extends Control

@onready var button = $Button
@onready var option = $"../Body/Recipes/OptionButton"
@onready var mesa = $"../Body/Recipes/Mesa"
@onready var cadeira = $"../Body/Recipes/Cadeira"

# Mesa slots
@onready var mesa_input = $"../Body/Recipes/Mesa/Input/Slot"
@onready var mesa_output = $"../Body/Recipes/Mesa/Output/Slot"

# Cadeira slots
@onready var chair_input = $"../Body/Recipes/Cadeira/Input/Slot"
@onready var chair_output = $"../Body/Recipes/Cadeira/Output/Slot"

var timer: Timer
var crafting: bool = false
var current: String = "Cadeira"

func _ready() -> void:
	button.disabled = true
	mesa.hide()
	cadeira.hide()

	timer = Timer.new()
	timer.one_shot = true
	timer.timeout.connect(_on_craft_done)
	add_child(timer)

	button.pressed.connect(_on_craft)
	mesa_input.slot_atualizado.connect(_check)
	chair_input.slot_atualizado.connect(_check)
	option.item_selected.connect(_on_option_button_item_selected)

	_check()

func _on_option_button_item_selected(index: int) -> void:
	cadeira.hide()
	mesa.hide()
	match index:
		0:
			cadeira.show()
			current = "Cadeira"
		1:
			mesa.show()
			current = "Mesa"
	_check()

func _check() -> void:
	if crafting or current == "":
		button.disabled = true
		return
	match current:
		"Cadeira":
			button.disabled = !(chair_input.item == chair_input.item_aceito and chair_input.quantidade >= chair_input.quantidade_necessaria)
		"Mesa":
			button.disabled = !(mesa_input.item == mesa_input.item_aceito and mesa_input.quantidade >= mesa_input.quantidade_necessaria)

func _on_craft() -> void:
	crafting = true
	button.disabled = true
	match current:
		"Cadeira": timer.wait_time = 3.0
		"Mesa":    timer.wait_time = 5.0
	timer.start()

func _on_craft_done() -> void:
	crafting = false
	match current:
		"Cadeira":
			chair_input.quantidade -= chair_input.quantidade_necessaria
			if chair_input.quantidade <= 0:
				chair_input.item = null
				chair_input.quantidade = 0
			chair_input.call("_update")
			chair_output.item = "Cadeira"
			chair_output.quantidade += 1
			chair_output.call("_update")
		"Mesa":
			mesa_input.quantidade -= mesa_input.quantidade_necessaria
			if mesa_input.quantidade <= 0:
				mesa_input.item = null
				mesa_input.quantidade = 0
			mesa_input.call("_update")
			mesa_output.item = "Mesa"
			mesa_output.quantidade += 1
			mesa_output.call("_update")
	_check()
