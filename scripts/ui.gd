extends CanvasLayer

@onready var _bleed_bar: ProgressBar = $"top center/Bleed Bar"

func SetBleedBar(amount: float) -> void:
	_bleed_bar.value = amount
