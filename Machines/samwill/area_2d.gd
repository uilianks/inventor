extends Area2D

@onready var label = $"../Control/InteractButton"
@onready var panel = $"../Control/Panel"
@onready var btn_close = $"../Control/Panel/Button"

func _ready() -> void:
	label.hide()
	panel.hide()
	btn_close.pressed.connect(_close)
	input_pickable = true

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if label.visible:
			_open()

func _input_event(_viewport, event, _shape_idx) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if label.visible:
				_open()

func _open() -> void:
	panel.show()
	label.hide()

func _close() -> void:
	panel.hide()
	label.show()

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		label.show()

func _on_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		label.hide()
		panel.hide()
