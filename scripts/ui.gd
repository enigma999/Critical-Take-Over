extends CanvasLayer

@onready var _bleed_bar: ProgressBar = $"top center/Bleed Bar"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func SetBleedBar(amount: float) -> void:
	_bleed_bar.value = amount
