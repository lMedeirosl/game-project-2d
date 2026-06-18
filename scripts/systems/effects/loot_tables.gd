# systems/loot_tables.gd
extends Node
class_name LootTables

# Tabelas de drop por raridade
static var COMMON_DROPS = {
	"health_potion": 0.4,
	"stamina_potion": 0.3,
	"gold": 0.3,
}

static var UNCOMMON_DROPS = {
	"iron_sword": 0.3,
	"leather_armor": 0.3,
	"mana_potion": 0.2,
	"health_potion": 0.2,
}

static var RARE_DROPS = {
	"steel_sword": 0.4,
	"steel_armor": 0.3,
	"spell_tome": 0.3,
}

static var LEGENDARY_DROPS = {
	"legendary_sword": 0.5,
	"legendary_armor": 0.3,
	"artifact": 0.2,
}

static func get_random_drop(rarity: Item.Rarity) -> String:
	var table = COMMON_DROPS
	
	match rarity:
		Item.Rarity.UNCOMMON:
			table = UNCOMMON_DROPS
		Item.Rarity.RARE:
			table = RARE_DROPS
		Item.Rarity.LEGENDARY:
			table = LEGENDARY_DROPS
	
	var roll = randf()
	var cumulative = 0.0
	
	for item_key in table:
		cumulative += table[item_key]
		if roll <= cumulative:
			return item_key
	
	return table.keys()[0]
