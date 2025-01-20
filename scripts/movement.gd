extends CharacterBody3D


const SPEED: float = 8.0
const ACCELERATION: float = 12.0
const JUMP_VELOCITY: float = 4.5
const GRAVITY: float = 10.0

#puur @export toegevoegd voor het tweaken enzo
@export var current_speed: float = SPEED
@export var acceleration: float = ACCELERATION
@export var gravity:float = GRAVITY
@export var sensitivity:float  = 0.1
@export var minimum_angle:float = -80
@export var maximum_angle:float = 90

@onready var head = $Head

var look_rotation: Vector2

#func _ready() -> void:
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
		# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = lerp(velocity.x, direction.x * current_speed, acceleration * delta)
		velocity.z = lerp(velocity.z, direction.z * current_speed, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, acceleration * delta)
		velocity.z = lerp(velocity.z, 0.0, acceleration * delta)

	move_and_slide()
	set_camera_direction()

func set_camera_direction()->void:
	head.rotation_degrees.x = look_rotation.x
	rotation_degrees.y = look_rotation.y

func _input(event):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			look_rotation.y -= (event.relative.x * sensitivity)
			look_rotation.x -= (event.relative.y * sensitivity)
			look_rotation.x = clamp(look_rotation.x, minimum_angle, maximum_angle)
