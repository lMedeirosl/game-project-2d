extends Enemy
class_name ArcherEnemy

@export var projectile_speed = 250.0
@export var projectile_scene = "res://enemies/projectile.tscn"

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if target_detected:
		var distance_to_player = global_position.distance_to(player.global_position)
		
		if distance_to_player > attack_range * 1.5:
			var direction = (player.global_position - global_position).normalized()
			velocity = -direction * speed * 0.5

func attack_player() -> void:
	super.attack_player()
	
	var projectile = load(projectile_scene).instantiate()
	get_parent().add_child(projectile)
	projectile.global_position = global_position
	projectile.target = player
	projectile.speed = projectile_speed
