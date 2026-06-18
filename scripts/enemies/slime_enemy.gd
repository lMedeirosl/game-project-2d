extends Enemy
class_name SlimeEnemy

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if target_detected:
		if randf() < 0.02:
			velocity.y -= 300
	
	velocity.y += 500 * delta
