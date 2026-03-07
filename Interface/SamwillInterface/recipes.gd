extends Control

@onready var mesa = $Mesa
@onready var cadeira = $Cadeira
@onready var option = $OptionButton

func _ready() -> void:
	mesa.hide()
	cadeira.hide()
	pass

func _process(delta: float) -> void:
	pass

func _on_option_button_item_selected(index: int) -> void:
	cadeira.hide()
	mesa.hide()
	match index:
		0: cadeira.show()
		1: mesa.show()
