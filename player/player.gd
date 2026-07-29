extends Node3D


var sensitivityNorm: float = 0.003 # # Чувствительность мыши обычная
var sensitivityZoom: float = 0.0007 # # Чувствительность мыши при зуме
var currentSensitivity: float = 0.005 # Чувствительность мыши
var rot_x: float = 0.0 # Текущие углы поворота в радианах
var rot_y: float = 0.0
enum state {car, player, zoom, reload} #какие бывают состояния
var currentState: int = state.car # текущее состояние
@onready var carScr = $".."
@onready var cameraPlayer = $CameraPlayer
@onready var ray = $CameraPlayer/RayCast3D



func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED # Прячем курсор и фиксируем его в центре экрана


func _process(delta: float) -> void:
	# смена режима на стрелка
	if Input.is_action_just_pressed("changeCharacter"):
		if currentState != state.car:
			changeState(state.car)
		else:
			changeState(state.player)
	
	# выстрел
	if Input.is_action_just_pressed("ui_shoot"):
		shoot()
	
	# zoom
	if currentState != state.car: # если не машина, то при нажатии zoom, а при отпускании не zoom (player)
		if Input.is_action_pressed("ui_zoom"):
			changeState(state.zoom)
		else:
			changeState(state.player)
	
	# esc
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

# движение мыши
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and currentState != state.car:
		fpsCamera(event)



# выстрел
func shoot():
	if ray.get_collider():
		var obj = ray.get_collider()
		if obj.is_in_group("enemy"):
			obj.dead()


# переключение на новое состояние
func changeState(nextState: int):
	currentState = nextState
	match currentState:
		state.car:
			carScr.camera.make_current()
			carScr.canMove = true
		state.player:
			cameraPlayer.make_current()
			carScr.canMove = false
			cameraPlayer.fov = 75
			currentSensitivity = sensitivityNorm
		state.zoom:
			cameraPlayer.fov = 20
			currentSensitivity = sensitivityZoom


# управление камерой внутри машины
func fpsCamera(event: InputEvent):
	rot_x -= event.relative.y * currentSensitivity
	rot_y -= event.relative.x * currentSensitivity
	var min_p_rad = deg_to_rad(60.0)# Ограничиваем вертикальный угол (Pitch) 60
	rot_x = clamp(rot_x, -min_p_rad, min_p_rad)
	var min_y_rad = deg_to_rad(90.0)# Ограничиваем горизонтальный угол (Yaw) 90
	rot_y = clamp(rot_y, -min_y_rad, min_y_rad)
	
	# Сбрасываем поворот объекта и применяем новые ограниченные углы
	cameraPlayer.transform.basis = Basis() 
	cameraPlayer.rotate_object_local(Vector3.UP, rot_y)    # Поворот влево-вправо
	cameraPlayer.rotate_object_local(Vector3.RIGHT, rot_x) # Поворот вверх-вниз
