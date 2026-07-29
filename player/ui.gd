extends Control

@onready var labelTimer = $labelTimer
var timeX: float
var startTime: bool


func _ready() -> void:
	Global.uiScr = self

func _process(delta: float) -> void:
	labelTimer.text = str(snapped(timeX, 0.1))
	if startTime:
		timeX += delta


func startTimer():
	startTime = true

func stopTimer():
	startTime = false
