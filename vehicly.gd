extends VehicleBody3D

@export var max_steering: float = 0.4      # Максимальный угол поворота колес
@export var steering_speed: float = 5.0     # Скорость поворота руля (выше — быстрее)
@export var max_engine_force: float = 800.0   # Максимальная сила мотора
@export var engine_acceleration: float = 5.0  # Плавность разгона
var canMove = true

func _physics_process(delta: float) -> void:
	var steering_input: float
	var throttle_input: float
	if canMove:
		steering_input = Input.get_axis("move_right", "move_left")
		throttle_input = Input.get_axis("move_back", "move_forward")
	var target_steering = steering_input * max_steering
	steering = lerp(steering, target_steering, steering_speed * delta)
	var target_engine_force = throttle_input * max_engine_force
	engine_force = lerp(engine_force, target_engine_force, engine_acceleration * delta)
