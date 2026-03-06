extends Panel

var item = null
var quantidade = 0
var item_aceito = null       # null = aceita qualquer coisa
var quantidade_necessaria = 1

signal slot_atualizado

func _ready() -> void:
	_atualizar()

func _atualizar() -> void:
	if item == null or quantidade == 0:
		if item_aceito:
			$Label.text = item_aceito + "\n(0/" + str(quantidade_necessaria) + ")"
		else:
			$Label.text = "[ ]"
	else:
		if item_aceito:
			$Label.text = item + "\n(" + str(quantidade) + "/" + str(quantidade_necessaria) + ")"
		else:
			$Label.text = item + "\nx" + str(quantidade)

func _get_drag_data(at_position: Vector2) -> Variant:
	if item == null:
		return null
	var preview = Label.new()
	preview.text = item + " x" + str(quantidade)
	set_drag_preview(preview)
	return self

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if not data is Panel:
		return false
	# Verifica se o item é aceito
	if item_aceito != null and data.item != item_aceito:
		return false
	return true

func _drop_data(at_position: Vector2, data: Variant) -> void:
	var outro = data as Panel
	if outro.item == item and item != null:
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
	_atualizar()
	outro._atualizar()
	slot_atualizado.emit()
