extends StaticBody3D

@export var currentEnemy: bool

func _ready() -> void:
	await get_tree().process_frame
	if currentEnemy:
		Global.levelScr.enemyNumber += 1

func dead():
	if !Global.uiScr.startTime:
		Global.uiScr.startTimer()
	Global.levelScr.enemyNumber -= 1
	queue_free()
