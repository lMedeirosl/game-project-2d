# enemies/enemy_manager.gd
extends Node2D
class_name EnemyManager

@export var initial_enemy_count = 5
@export var spawn_radius = 300.0
@export var difficulty_scale = 1.1

var enemies: Array[Enemy] = []
var player: Player
var game: Node2D
var current_wave = 0
var difficulty_multiplier = 1.0

func initialize(game_node: Node2D, player_node: Player) -> void:
	game = game_node
	player = player_node
	spawn_initial_enemies()

func spawn_initial_enemies() -> void:
	for i in range(initial_enemy_count):
		spawn_enemy_at_distance()

func spawn_enemy_at_distance() -> void:
	var angle = randf() * TAU
	var distance = spawn_radius + randf_range(-50, 50)
	var spawn_pos = player.global_position + Vector2(cos(angle), sin(angle)) * distance
	
	var enemy = preload("res://scenes/enemies/enemy.tscn").instantiate()
	game.add_child(enemy)
	enemy.global_position = spawn_pos
	enemy.set_player(player)
	enemy.died.connect(_on_enemy_died.bindv([enemy]))
	
	# Aplicar multiplicador de dificuldade
	enemy.max_hp *= difficulty_multiplier
	enemy.current_hp = enemy.max_hp
	enemy.attack_damage *= difficulty_multiplier
	enemy.speed *= difficulty_multiplier
	
	enemies.append(enemy)

func _on_enemy_died(enemy: Enemy) -> void:
	enemies.erase(enemy)
	
	# Spawn de novos inimigos quando a onda é eliminada
	if enemies.is_empty():
		spawn_new_wave()

func spawn_new_wave() -> void:
	current_wave += 1
	difficulty_multiplier *= difficulty_scale
	
	# Aumentar quantidade de inimigos
	var enemy_count = initial_enemy_count + current_wave * 2
	for i in range(enemy_count):
		spawn_enemy_at_distance()

func get_enemies() -> Array[Enemy]:
	return enemies
