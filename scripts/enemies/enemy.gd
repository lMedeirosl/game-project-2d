# enemies/enemy.gd
extends CharacterBody2D
class_name Enemy

# Configurações base
@export var max_hp = 30
@export var speed = 100.0
@export var attack_range = 40.0
@export var attack_damage = 5.0
@export var attack_cooldown = 1.0
@export var detection_range = 200.0
@export var xp_reward = 25

# Estado
var current_hp: float
var player: Player
var is_attacking = false
var attack_timer = 0.0
var target_detected = false

# Referências visuais
var sprite: Sprite2D
var animation_player: AnimationPlayer

signal died

func _ready() -> void:
	current_hp = max_hp
	
	# Setup visual
	sprite = Sprite2D.new()
	add_child(sprite)
	sprite.scale = Vector2(1.5, 1.5)
	# sprite.texture = preload("res://assets/enemy.png")
	
	# Hitbox
	var collision = CollisionShape2D.new()
	add_child(collision)
	var shape = CapsuleShape2D.new()
	shape.radius = 7
	shape.height = 14
	collision.shape = shape

func _physics_process(delta: float) -> void:
	if not player:
		return
	
	var distance_to_player = global_position.distance_to(player.global_position)
	
	# Detectar jogador
	target_detected = distance_to_player <= detection_range
	
	if target_detected:
		if distance_to_player > attack_range:
			# Mover em direção ao jogador
			var direction = (player.global_position - global_position).normalized()
			velocity = direction * speed
		else:
			# Próximo o suficiente para atacar
			velocity = Vector2.ZERO
			if not is_attacking:
				attack_player()
	else:
		# Voltar a andar aleatoriamente ou parar
		velocity = velocity.move_toward(Vector2.ZERO, speed * delta)
	
	move_and_slide()
	
	# Atualizar rotação
	if velocity.length() > 0:
		sprite.rotation = velocity.angle()
	
	# Cooldown de ataque
	if is_attacking:
		attack_timer -= delta
		if attack_timer <= 0:
			is_attacking = false

func attack_player() -> void:
	is_attacking = true
	attack_timer = attack_cooldown
	player.take_damage(attack_damage)

func take_damage(damage: float) -> void:
	current_hp -= damage
	
	# Feedback visual (você pode adicionar tween aqui)
	modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
	
	if current_hp <= 0:
		die()

func die() -> void:
	if player:
		player.gain_experience(xp_reward)
	died.emit()
	queue_free()

func set_player(p: Player) -> void:
	player = p
