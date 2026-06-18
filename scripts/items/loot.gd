# items/loot_manager.gd
extends Node2D
class_name LootManager

var player: Player

var item_pool: Dictionary = {
	"health_potion": {
		"rarity": Item.Rarity.COMMON,
		"drop_chance": 0.3,
		"stats": {"heal": 25}
	},
	"mana_potion": {
		"rarity": Item.Rarity.COMMON,
		"drop_chance": 0.2,
		"stats": {"mana_restore": 20}
	},
	"iron_sword": {
		"rarity": Item.Rarity.UNCOMMON,
		"drop_chance": 0.05,
		"stats": {"damage": 15}
	},
	"steel_armor": {
		"rarity": Item.Rarity.UNCOMMON,
		"drop_chance": 0.05,
		"stats": {"defense": 10}
	},
	"legendary_blade": {
		"rarity": Item.Rarity.LEGENDARY,
		"drop_chance": 0.001,
		"stats": {"damage": 50, "crit_chance": 0.25}
	}
}

func initialize(player_node: Player) -> void:
	player = player_node

func drop_loot(position: Vector2, enemy_level: int) -> void:
	# Decidir qual item dropar baseado em probabilidades
	for item_key in item_pool:
		var item_data = item_pool[item_key]
		if randf() < item_data.drop_chance:
			create_loot_item(position, item_key, item_data)

func create_loot_item(position: Vector2, item_key: String, item_data: Dictionary) -> void:
	var item = Item.new()
	item.item_name = item_key
	item.rarity = item_data.rarity
	item.stats = item_data.stats
	
	# Criar visual de loot
	var loot_visual = Node2D.new()
	loot_visual.position = position
	add_child(loot_visual)
	
	# Sprite do loot
	var sprite = Sprite2D.new()
	loot_visual.add_child(sprite)
	sprite.modulate = item.get_rarity_color()
	# sprite.texture = preload("res://assets/loot_icon.png")
	sprite.scale = Vector2(0.8, 0.8)
	
	# Area de pickup
	var area = Area2D.new()
	loot_visual.add_child(area)
	var collision = CollisionShape2D.new()
	area.add_child(collision)
	var shape = CircleShape2D.new()
	shape.radius = 15
	collision.shape = shape
	
	area.area_entered.connect(func(a):
		if a.get_parent() == player:
			pick_up_loot(item, loot_visual)
	)
	
	# Animação de flutuação
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(sprite, "position:y", -5, 0.5)
	tween.tween_property(sprite, "position:y", 0, 0.5)

func pick_up_loot(item: Item, visual: Node2D) -> void:
	if player.inventory.add_item(item):
		visual.queue_free()
