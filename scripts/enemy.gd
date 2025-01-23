extends CharacterBody3D

#ai variables
@export var health: float = 100
@export var move_around: bool = false
@export var speed: float = 2.0

# Below are variables and functionality for moving enemies (for testing)
var relative_points: Array[Vector3] = [
	Vector3(0, 0, 0), 
	Vector3(3, 0, 0), 
	Vector3(-2, 0, 2)
]
var spawn_position: Vector3 = Vector3.ZERO
var absolute_points: Array[Vector3] = []
var current_point: int = 0

#player controller variables
#movement consts
const SPEED: float = 8.0
const ACCELERATION: float = 12.0
const JUMP_VELOCITY: float = 7
const GRAVITY_FORCE: float = 18

#movement variables
#puur @export toegevoegd voor het tweaken enzo
@export var current_speed: float = SPEED
@export var acceleration: float = ACCELERATION
@export var gravity_force:float = GRAVITY_FORCE
@export var sensitivity:float  = 0.1
@export var minimum_angle:float = -80
@export var maximum_angle:float = 90

var head: Node3D
var look_rotation: Vector2
var is_taken: bool
var is_dead: bool = false

signal take_over
#attacking variables
var camera: Camera3D
var can_attack: bool = true
var weapon: Node3D
@onready var attack_cooldown: Timer = $WeaponCooldown 


func _ready():
	is_taken = get_meta("is_player")
	_setup_movement_points()
	
	if is_taken:
		head = $Head
		camera = $Head/Camera3D
		weapon = $Head/Weapon
		set_process_input(true)
	else:
		set_process_input(false)
		weapon = $Weapon

func _physics_process(delta: float) -> void:
	gravity(delta)

	if is_taken:
		player_movement(delta)
	elif !is_dead:
		ai_movement()
	move_and_slide()
	
func ai_movement()-> void:
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
		


func init_new_character() -> void:
	get_node("Head/Weapon").free()
	head = get_node("Head")
	get_node("Weapon").reparent(head)
	camera = get_node("Head/Camera3D")
	weapon = get_node("Head/Weapon")
	attack_cooldown.stop()
	can_attack = true
	head.position.y = get_meta("Head_Height")
	set_process_input(true)
	
func take_over_enemy(target: Node3D)-> void:
	is_dead = true
	is_taken = false
	
	remove_child(head)
	target.add_child(head)
	head.set_owner(target)
	target.is_taken = true
	take_over.emit()
	target.init_new_character()
	die()
	set_script(null)

func player_movement(delta: float) -> void:
	handle_movement(delta)
	set_camera_direction()
	
func gravity(delta: float)-> void:
	if not is_on_floor():
		velocity.y -= gravity_force * delta

func handle_movement(delta: float)-> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = lerp(velocity.x, direction.x * current_speed, acceleration * delta)
			velocity.z = lerp(velocity.z, direction.z * current_speed, acceleration * delta)
		else:
			velocity.x = lerp(velocity.x, 0.0, acceleration * delta)
			velocity.z = lerp(velocity.z, 0.0, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, direction.x * current_speed, 2 * delta)
		velocity.z = lerp(velocity.z, direction.z * current_speed, 2 * delta)

func set_camera_direction()-> void:
	head.rotation_degrees.x = look_rotation.x
	rotation_degrees.y = look_rotation.y

func attack()-> void:
	can_attack = false
	attack_cooldown.start(weapon.get_cooldown())
	var targetDict: Dictionary = weapon.attack(camera)
	var target:Node3D = targetDict.get("collider")
	if target != null && target.is_in_group("enemy"):
		take_over_enemy(target)


func die()-> void:
	remove_from_group("enemy")
	#attach death script that makes it so the body lies on the ground :D
	queue_free() #for now we just remove the node
	

func _input(event):
	#attacking input
	if Input.is_action_just_pressed("attack") && can_attack:
		attack()
	#looking around
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			look_rotation.y -= (event.relative.x * sensitivity)
			look_rotation.x -= (event.relative.y * sensitivity)
			look_rotation.x = clamp(look_rotation.x, minimum_angle, maximum_angle)

func _on_weapon_cooldown_timeout() -> void:
	can_attack = true
