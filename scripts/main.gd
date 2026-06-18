extends Node2D
class_name Main

@export var dungeon_width = 2000
@export var dungeon_height = 2000
@export var tile_size = 16

var player: Player
var camera: Camera2D
var enemy_manager: EnemyManager
var loot_manager: LootManager
var hud: HUD

func _ready() -> void:
	print("=== INICIANDO JOGO ===")
	
	# Setup da câmera fluida
	# Carregar TileMap
	print("Carregando TileMap...")
	var tilemap_scene = preload("res://sprites/tilemap.png")
	var tilemap = tilemap_scene.instantiate()
	add_child(tilemap)
	print("TileMap carregado!")
	print("Criando câmera...")
	camera = Camera2D.new()
	add_child(camera)
	camera.zoom = Vector2(2, 2)
	camera.position_smoothing_enabled = true
	camera.position_smoothing_speed = 8.0
	print("Câmera criada!")
	
	# Criar jogador
	print("Carregando player.tscn...")
	var player_scene = preload("res://scenes/player/player.tscn")
	print("player.tscn carregado: ", player_scene)
	
	player = player_scene.instantiate()
	print("Player instanciado: ", player)
	
	add_child(player)
	print("Player adicionado à cena")
	
	player.position = Vector2(float(dungeon_width) / 2, float(dungeon_height) / 2)
	print("Position do player: ", player.position)
	
	# Câmera segue o jogador
	camera.global_position = player.global_position
	print("Câmera posicionada")
	
	# Setup de inimigos
	print("Criando enemy_manager...")
	enemy_manager = EnemyManager.new()
	add_child(enemy_manager)
	enemy_manager.initialize(self, player)
	print("Enemy manager criado!")
	
	# Setup de HUD
	print("Criando HUD...")
	hud = HUD.new()
	add_child(hud)
	hud.initialize(player, enemy_manager)
	print("HUD criado!")
	
	# Setup de loot
	print("Criando loot_manager...")
	loot_manager = LootManager.new()
	add_child(loot_manager)
	loot_manager.initialize(player)
	print("Loot manager criado!")
	
	print("=== JOGO INICIADO COM SUCESSO ===")

func _process(_delta: float) -> void:
	if player:
		camera.global_position = player.global_position
