extends CanvasLayer

@onready var _bleed_bar: ProgressBar = $"top center/VBoxContainer/HBoxContainer/Bleed Bar"
@onready var _timerLabel: Label = $"top center/VBoxContainer/HBoxContainer/TimerLabel"

func SetBleedBar(amount: float) -> void:
	_bleed_bar.value = amount

func SetTimer(seconds: int) -> void:
	_timerLabel.SetTimerFromSeconds(seconds)
