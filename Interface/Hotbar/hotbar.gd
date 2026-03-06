extends Node

func _ready() -> void:
	$HBoxContainer/Slot.item = "Madeira"
	$HBoxContainer/Slot.quantidade = 3
	$HBoxContainer/Slot.call("_atualizar")
	$HBoxContainer/Slot2.item = "Ferro"
	$HBoxContainer/Slot2.quantidade = 3
	$HBoxContainer/Slot2.call("_atualizar")
