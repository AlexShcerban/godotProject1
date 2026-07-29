extends Node

var enemyNumber:int

func _ready() -> void:
	Global.levelScr = self

func endGame():
	if enemyNumber <= 0:
		Global.uiScr.stopTimer()
