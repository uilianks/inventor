class_name Recipe
extends Resource

@export var name: String = ""
@export var time: float = 5.0
var inputs: Array = []
# Each input: { "item": "Wood", "amount": 2 }
@export var output_item: String = ""
@export var output_amount: int = 1
