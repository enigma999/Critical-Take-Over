extends CharacterBody3D


const SPEED: float = 5
const JUMP_VELOCITY: float = 4.5

@export var current_speed: float = 5
@export var accelaration: float = 5


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = lerp(velocity.x, direction.x * current_speed, accelaration * delta)
		velocity.z = lerp(velocity.z, direction.z * current_speed, accelaration * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, accelaration * delta)
		velocity.z = lerp(velocity.z, 0.0, accelaration * delta)

	move_and_slide()
