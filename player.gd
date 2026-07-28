extends Node3D

@onready var cameraCar = $"../Camera3D"
@onready var cameraPlayer = $Camera3D
var isNowCar = true


var sensitivityNorm: float = 0.005 # # Чувствительность мыши обычная
var sensitivityZoom: float = 0.0005 # # Чувствительность мыши при зуме
var sensitivity: float = 0.005 # Чувствительность мыши
var min_max_pitch: float = 60.0 # Ограничения по вертикали (в градусах)
var min_max_yaw: float = 90.0 # Ограничения по горизонтали (в градусах)
var rot_x: float = 0.0 # Текущие углы поворота в радианах
var rot_y: float = 0.0




func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED # Прячем курсор и фиксируем его в центре экрана


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("changeCharacter"):
		stateChange(isNowCar)
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_action_just_pressed("ui_shoot"):
		shoot()
	
	if Input.is_action_pressed("ui_zoom"):
		cameraPlayer.fov = 20
		sensitivity = sensitivityZoom
	else:
		cameraPlayer.fov = 75
		sensitivity = sensitivityNorm


func shoot():
	var ray = $Camera3D/RayCast3D
	if ray.get_collider():
		var obj = ray.get_collider()
		if obj.is_in_group("enemy"):
			obj.queue_free()


func _input(event: InputEvent) -> void:
	# Считываем движение мыши
	if event is InputEventMouseMotion and !isNowCar:
		# Изменяем углы на основе смещения мыши и чувствительности
		rot_x -= event.relative.y * sensitivity
		rot_y -= event.relative.x * sensitivity
		var min_p_rad = deg_to_rad(min_max_pitch)# Ограничиваем вертикальный угол (Pitch)
		rot_x = clamp(rot_x, -min_p_rad, min_p_rad)
		var min_y_rad = deg_to_rad(min_max_yaw)# Ограничиваем горизонтальный угол (Yaw)
		rot_y = clamp(rot_y, -min_y_rad, min_y_rad)
		# Сбрасываем поворот объекта и применяем новые ограниченные углы
		cameraPlayer.transform.basis = Basis() 
		cameraPlayer.rotate_object_local(Vector3.UP, rot_y)    # Поворот влево-вправо
		cameraPlayer.rotate_object_local(Vector3.RIGHT, rot_x) # Поворот вверх-вниз



func stateChange(isNowCar:bool):
	if isNowCar:
		cameraPlayer.make_current()
	else:
		cameraCar.make_current()
	self.isNowCar = !isNowCar
	$"..".canMove = self.isNowCar
