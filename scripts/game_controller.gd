extends Node

@onready var UI = $UI
var bleedStep: float = 1
var bleedValue: float
var bleedMax: float = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bleedValue = bleedMax
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	bleedValue = bleedValue - (bleedStep * delta);
	pass
	
func _process(delta: float) -> void:
	UpdateUi()

func UpdateUi() -> void:
	UI.SetBleedBar(bleedValue)

func _on_player_kill_made() -> void:
	if bleedMax > (bleedValue + 40):
		bleedValue = bleedValue + 40
	else:
		bleedValue = bleedMax
