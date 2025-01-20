extends CharacterBody3D

@export var health: float = 100
@export var move_around: bool = false
@export var speed: float = 5.0

var relative_points: Array[Vector3] = [
	Vector3(0, 0, 0), 
	Vector3(2, 0, 0), 
	Vector3(-1, 0, 2)
]
var spawn_position: Vector3 = Vector3.ZERO
var absolute_points: Array[Vector3] = []
var current_point: int = 0

func _ready():
	_setup_movement_points()

func _physics_process(delta: float) -> void:
	if !move_around or absolute_points.size() < 2:
		return

	velocity = (absolute_points[current_point] - global_transform.origin).normalized() * speed
	move_and_slide()

	if global_transform.origin.distance_to(absolute_points[current_point]) < 0.1:
		global_transform.origin = absolute_points[current_point]
		current_point = (current_point + 1) % absolute_points.size()

func _setup_movement_points():
	spawn_position = global_transform.origin

	for point in relative_points:
		absolute_points.append(spawn_position + point)

	if absolute_points.size() >= 1:
		current_point = 0
