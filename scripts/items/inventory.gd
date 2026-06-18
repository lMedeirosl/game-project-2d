	# items/inventory.gd
extends Node
class_name Inventory

@export var max_slots = 20

var items: Array[Item] = []

signal item_added(item: Item)
signal item_removed(item: Item)

func add_item(item: Item) -> bool:
	if items.size() < max_slots:
		items.append(item)
		item_added.emit(item)
		return true
	return false

func remove_item(item: Item) -> void:
	if items.has(item):
		items.erase(item)
		item_removed.emit(item)

func get_items() -> Array[Item]:
	return items

func get_total_weight() -> float:
	var weight = 0.0
	for item in items:
		weight += item.weight
	return weight

func use_consumable(item: Item) -> void:
	if item.item_type == Item.ItemType.CONSUMABLE:
		item.use()
		remove_item(item)
