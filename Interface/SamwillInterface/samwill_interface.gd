extends Control

@onready var mesa = $Panel/VBoxContainer/Mesa
@onready var cadeira = $Panel/VBoxContainer/Cadeira
@onready var option = $Panel/VBoxContainer/HBoxContainer2/OptionButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mesa.hide()
	cadeira.hide()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_option_button_item_selected(index: int) -> void:
	cadeira.hide()
	mesa.hide()
	match index:
		0: cadeira.show()
		1: mesa.show()
