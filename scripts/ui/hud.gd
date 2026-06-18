# ui/hud.gd
extends CanvasLayer
class_name HUD

var player: Player
var enemy_manager: EnemyManager

# Elementos de UI
var health_label: Label
var health_bar: ProgressBar
var level_label: Label
var experience_label: Label
var wave_label: Label
var enemy_count_label: Label

func _ready() -> void:
	# Você pode carregar isso de uma cena ou criar programaticamente
	setup_ui()

func setup_ui() -> void:
	# Container principal
	var container = VBoxContainer.new()
	add_child(container)
	container.anchor_left = 0
	container.anchor_top = 0
	container.anchor_right = 0.2
	container.anchor_bottom = 0.3
	container.offset_top = 10
	container.offset_left = 10
	
	# Label de vida
	health_label = Label.new()
	container.add_child(health_label)
	health_label.text = "Health: 100/100"
	
	# Barra de vida
	health_bar = ProgressBar.new()
	container.add_child(health_bar)
	health_bar.custom_minimum_size = Vector2(150, 20)
	health_bar.min_value = 0
	
	# Label de nível
	level_label = Label.new()
	container.add_child(level_label)
	level_label.text = "Level: 1"
	
	# Label de experiência
	experience_label = Label.new()
	container.add_child(experience_label)
	experience_label.text = "XP: 0"
	
	# Label de onda
	wave_label = Label.new()
	container.add_child(wave_label)
	wave_label.text = "Wave: 1"
	
	# Label de inimigos
	enemy_count_label = Label.new()
	container.add_child(enemy_count_label)
	enemy_count_label.text = "Enemies: 0"

func initialize(player_node: Player, enemy_mgr: EnemyManager) -> void:
	player = player_node
	enemy_manager = enemy_mgr
	
	# Conectar sinais do jogador
	player.health_changed.connect(_on_health_changed)
	
	# Update inicial
	_on_health_changed(player.current_hp)

func _process(_delta: float) -> void:
	if not player:
		return
	
	# Atualizar informações
	experience_label.text = "XP: %d" % player.experience
	level_label.text = "Level: %d" % player.level
	
	if enemy_manager:
		wave_label.text = "Wave: %d" % (enemy_manager.current_wave + 1)
		enemy_count_label.text = "Enemies: %d" % enemy_manager.enemies.size()

func _on_health_changed(new_health: float) -> void:
	if not player:
		return
	
	health_label.text = "Health: %.0f/%.0f" % [new_health, player.max_hp]
	health_bar.max_value = player.max_hp
	health_bar.value = new_health
	
	# Mudar cor da barra baseado em saúde
	if new_health > player.max_hp * 0.5:
		health_bar.modulate = Color.GREEN
	elif new_health > player.max_hp * 0.25:
		health_bar.modulate = Color.YELLOW
	else:
		health_bar.modulate = Color.RED

func _on_level_up(level: int) -> void:
	level_label.text = "Level: %d" % level
	
	# Animação de level up
	var tween = create_tween()
	tween.tween_property(level_label, "scale", Vector2(1.5, 1.5), 0.2)
	tween.tween_property(level_label, "scale", Vector2(1, 1), 0.2)
