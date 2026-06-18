extends CharacterBody2D
class_name Player

@export var max_speed = 200.0
@export var acceleration = 800.0
@export var friction = 600.0
@export var max_hp = 100
@export var base_damage = 10
@export var attack_range = 50
@export var attack_cooldown = 0.5

var current_hp: float
var experience = 0
var level = 1
var inventory: Inventory
var is_attacking = false
var attack_timer = 0.0
var direction = Vector2.ZERO

signal health_changed(new_health)
signal level_up(new_level)
signal died

func _ready() -> void:
	current_hp = max_hp
	inventory = Inventory.new()
	
	# DESENHAR QUADRADO AZUL (placeholder)
	var color_rect = ColorRect.new()
	add_child(color_rect)
	color_rect.color = Color.BLUE
	color_rect.custom_minimum_size = Vector2(32, 48)
	color_rect.position = Vector2(-16, -24)
	
	# Hitbox
	var collision = CollisionShape2D.new()
	add_child(collision)
	var shape = CapsuleShape2D.new()
	shape.radius = 8
	shape.height = 16
	collision.shape = shape

func _physics_process(delta: float) -> void:
	# Input de movimento
	direction = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	
	direction = direction.normalized()
	
	# Movimento
	if direction.length() > 0:
		velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	
	# Ataque
	if Input.is_action_pressed("ui_accept") and not is_attacking:
		perform_attack()
	
	if is_attacking:
		attack_timer -= delta
		if attack_timer <= 0:
			is_attacking = false

func perform_attack() -> void:
	is_attacking = true
	attack_timer = attack_cooldown
	print("JOGADOR ATACOU!")

func take_damage(damage: float) -> void:
	current_hp -= damage
	health_changed.emit(current_hp)
	if current_hp <= 0:
		die()

func heal(amount: float) -> void:
	current_hp = min(current_hp + amount, max_hp)
	health_changed.emit(current_hp)

func gain_experience(amount: int) -> void:
	experience += amount
	var next_level_xp = level * 100
	if experience >= next_level_xp:
		leveled_up()

func leveled_up() -> void:
	level += 1
	max_hp += 20
	base_damage += 5
	current_hp = max_hp
	level_up.emit(level)

func die() -> void:
	died.emit()
	queue_free()

func get_inventory() -> Inventory:
	return inventory
