class_name Recipe
extends Resource

@export var name: String = ""
@export var time: float = 5.0
@export var output_item: Item = null
@export var output_amount: int = 1
@export var ingredients: Array[RecipeIngredient] = []
