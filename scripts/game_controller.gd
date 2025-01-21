extends Node

@onready var UI = $UI
@export var bleedStep: float = 1
@export var bleedMax: float = 100
var timer_running: bool = false
var timer_start: int = 0
var bleedValue: float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bleedValue = bleedMax
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if bleedValue > 0:
		bleedValue = bleedValue - (bleedStep * delta);


func _process(delta: float) -> void:
	UpdateUi()

func UpdateUi() -> void:
	UI.SetBleedBar(bleedValue)
	if timer_running:
		UI.SetTimer(Time.get_unix_time_from_system() -timer_start)


func _on_player_take_over() -> void:
	bleedValue = bleedMax
	if !timer_running:
		timer_running = true
		timer_start = Time.get_unix_time_from_system()
