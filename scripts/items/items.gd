# items/item.gd
extends Node
class_name Item

enum ItemType {
	WEAPON,
	ARMOR,
	CONSUMABLE,
	QUEST,
	MISCELLANEOUS
}

enum Rarity {
	COMMON,
	UNCOMMON,
	RARE,
	LEGENDARY,
	EXOTIC
}

@export var item_name = "Item"
@export var item_type: ItemType = ItemType.MISCELLANEOUS
@export var rarity: Rarity = Rarity.COMMON
@export var weight = 1.0
@export var value = 10

var stats: Dictionary = {}  # ex: {"damage": 5, "hp": 10}
var texture: Texture2D

# Cores de raridade (estilo ROTMG)
var rarity_colors = {
	Rarity.COMMON: Color.WHITE,
	Rarity.UNCOMMON: Color.GREEN,
	Rarity.RARE: Color.CYAN,
	Rarity.LEGENDARY: Color.YELLOW,
	Rarity.EXOTIC: Color.MAGENTA
}

signal used

func _ready() -> void:
	pass

func get_rarity_color() -> Color:
	return rarity_colors.get(rarity, Color.WHITE)

func get_display_name() -> String:
	return "[%s]%s" % [Rarity.keys()[rarity], item_name]

func use() -> void:
	if item_type == ItemType.CONSUMABLE:
		used.emit()
