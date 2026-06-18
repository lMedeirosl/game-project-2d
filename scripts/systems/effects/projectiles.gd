# systems/projectile.gd
extends Area2D
class_name Projectile

@export var speed = 250.0
@export var lifetime = 5.0

var target: Node2D
var damage = 5.0
var direction = Vector2.ZERO

func _ready() -> void:
	area_entered.connect(_on_hit)
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	if target:
		direction = (target.global_position - global_position).normalized()
		global_position += direction * speed * delta
		rotation = direction.angle()

func _on_hit(area: Area2D) -> void:
	if area.get_parent() is Player:
		var player = area.get_parent()
		player.take_damage(damage)
		queue_free()
