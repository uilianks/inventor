class_name RecipeBook
extends Node

static func get_all() -> Array[Recipe]:
	var list: Array[Recipe] = []
	list.append(_chair())
	list.append(_table())
	return list

static func get_by_name(recipe_name: String) -> Recipe:
	for r in get_all():
		if r.name == recipe_name:
			return r
	return null

# ─── Recipes ─────────────────────────────────────────────

static func _chair() -> Recipe:
	var r = Recipe.new()
	r.name = "Chair"
	r.time = 5.0
	r.inputs = [
		{ "item": "Wood", "amount": 2 }
	]
	r.output_item = "Chair"
	r.output_amount = 1
	return r

static func _table() -> Recipe:
	var r = Recipe.new()
	r.name = "Table"
	r.time = 8.0
	r.inputs = [
		{ "item": "Wood", "amount": 3 },
		{ "item": "Nail",  "amount": 4 }
	]
	r.output_item = "Table"
	r.output_amount = 1
	return r
