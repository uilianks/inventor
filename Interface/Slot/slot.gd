extends Panel

var item: Item = null
var quantidade = 0
@export var item_aceito: String = ""
@export var quantidade_necessaria: int = 1

signal slot_atualizado

func _ready() -> void:
	_update()

func _update() -> void:
	if item == null or quantidade == 0:
		if item_aceito != "":
			$Label.text = item_aceito + "\n(0/" + str(quantidade_necessaria) + ")"
		else:
			$Label.text = "[ ]"
	else:
		if item_aceito != "":
			$Label.text = item.name + "\n(" + str(quantidade) + "/" + str(quantidade_necessaria) + ")"
		else:
			$Label.text = item.name + "\nx" + str(quantidade)

func _get_drag_data(at_position: Vector2) -> Variant:
	if item == null:
		return null

	var preview = Label.new()

	if Input.is_key_pressed(KEY_SHIFT) and quantidade > 1:
		var metade = int(quantidade / 2)
		quantidade -= metade
		_update()

		var slot_temp = load("res://Interface/Slot/slot.tscn").instantiate()
		slot_temp.item = item
		slot_temp.quantidade = metade
		preview.text = item.name + " x" + str(metade)
		set_drag_preview(preview)
		return slot_temp
	else:
		preview.text = item.name + " x" + str(quantidade)
		set_drag_preview(preview)
		return self

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if not data is Panel:
		return false
	if data.item == null:
		return false
	if item_aceito != "" and data.item.name != item_aceito:
		return false
	return true

func _drop_data(at_position: Vector2, data: Variant) -> void:
	var outro = data as Panel
	if outro.item != null and item != null and outro.item.name == item.name:
		quantidade += outro.quantidade
		outro.item = null
		outro.quantidade = 0
	else:
		var temp_item = item
		var temp_qtd = quantidade
		item = outro.item
		quantidade = outro.quantidade
		outro.item = temp_item
		outro.quantidade = temp_qtd
	_update()
	outro._update()
	slot_atualizado.emit()
	outro.slot_atualizado.emit()
