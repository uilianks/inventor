extends Node

func _ready() -> void:
	$HBoxContainer/Slot.item = "Wood"
	$HBoxContainer/Slot.quantidade = 3
	$HBoxContainer/Slot.call("_atualizar")
