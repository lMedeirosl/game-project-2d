# effects/particle_effects.gd
extends Node2D
class_name ParticleEffects

static func create_hit_effect(position: Vector2) -> void:
	var particles = GPUParticles2D.new()
	particles.global_position = position
	particles.amount = 20
	particles.lifetime = 0.5
	
	# Configurar shader/material
	var material = StandardMaterial3D.new()
	# ... configurar material
	
	get_tree().get_root().add_child(particles)
	await get_tree().create_timer(1.0).timeout
	particles.queue_free()

static func create_loot_sparkle(position: Vector2, color: Color) -> void:
	var tween = create_tween()
	
	for i in range(8):
		var particle = Sprite2D.new()
		particle.global_position = position
		particle.modulate = color
		particle.scale = Vector2(0.5, 0.5)
		
		get_tree().get_root().add_child(particle)
		
		var angle = (TAU / 8.0) * i
		var direction = Vector2(cos(angle), sin(angle))
		
		var tween_particle = create_tween()
		tween_particle.set_parallel(true)
		tween_particle.tween_property(particle, "position", 
			position + direction * 50, 0.5)
		tween_particle.tween_property(particle, "modulate:a", 0.0, 0.5)
		tween_particle.tween_callback(particle.queue_free)
