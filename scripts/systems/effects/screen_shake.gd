# effects/screen_shake.gd
extends Node
class_name ScreenShake

var camera: Camera2D
var original_position: Vector2
var trauma: float = 0.0

const MAX_TRAUMA = 1.0
const TRAUMA_REDUCTION = 0.8  # por frame

func _ready() -> void:
	camera = get_tree().get_first_child_in_group("camera")
	if camera:
		original_position = camera.global_position

func _process(delta: float) -> void:
	if trauma <= 0.0:
		return
	
	trauma = max(0.0, trauma - TRAUMA_REDUCTION * delta)
	
	var amount = trauma * trauma
	var angle = randf() * TAU
	var offset = Vector2(cos(angle), sin(angle)) * amount * 10
	
	if camera:
		camera.offset = offset

func add_trauma(amount: float) -> void:
	trauma = min(MAX_TRAUMA, trauma + amount)
