extends Control

@onready var grid = $GridContainer

const SLOT_SIZE = 36
const HOTBAR_LINES = 1
const TOTAL_LINES = 4

const MADEIRA = preload("res://Items/madeira.tres")
const FERRO = preload("res://Items/ferro.tres")

var is_open = false

func _ready() -> void:
	$GridContainer/Slot.item = MADEIRA
	$GridContainer/Slot.quantidade = 3
	$GridContainer/Slot.call("_update")
	$GridContainer/Slot2.item = FERRO
	$GridContainer/Slot2.quantidade = 3
	$GridContainer/Slot2.call("_update")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_focus_next"):
		if is_open:
			_close()
		else:
			_open()

func _open() -> void:
	is_open = true
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(grid, "position:y", -SLOT_SIZE * (TOTAL_LINES - HOTBAR_LINES), 0.3)

func _close() -> void:
	is_open = false
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(grid, "position:y", 0.0, 0.3)
