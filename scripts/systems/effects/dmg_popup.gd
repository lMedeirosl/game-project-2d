# ui/damage_popup.gd
extends Node2D
class_name DamagePopup

var damage_number_scene = preload("res://scenes/dmg_numbers.tscn")

func show_damage(world_position: Vector2, damage: float, is_crit: bool = false) -> void:
	var number = damage_number_scene.instantiate()
	get_tree().current_scene.add_child(number)
	number.global_position = world_position
	number.display_damage(damage, is_crit)
