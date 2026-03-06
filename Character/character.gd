extends Node2D

@onready var player_inventory = $PlayerInventory

func _ready() -> void:
	player_inventory.hide()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_focus_next"):
		if player_inventory.visible:
			player_inventory.hide()
		else:
			player_inventory.show()
