extends CharacterBody3D

#movement consts
const SPEED: float = 8.0
const ACCELERATION: float = 12.0
const JUMP_VELOCITY: float = 4.5
const GRAVITY_FORCE: float = 10.0

#movement variables
#puur @export toegevoegd voor het tweaken enzo
@export var current_speed: float = SPEED
@export var acceleration: float = ACCELERATION
@export var gravity_force:float = GRAVITY_FORCE
@export var sensitivity:float  = 0.1
@export var minimum_angle:float = -80
@export var maximum_angle:float = 90

@onready var head: Node3D = $Head
var look_rotation: Vector2

#attacking variables
@onready var camera = $Head/Camera3D
var can_attack: bool = true
@onready var weapon: Node3D = $Weapon
@onready var attack_cooldown: Timer = $WeaponCooldown

func init_new_character() -> void:
	if get_tree().get_nodes_in_group("enemy").size() <= 1:
		print ("You won! You absolute beast of a gamer!")
	
	head = get_node("Head")
	camera = get_node("Head/Camera3D")
	weapon = get_node("Weapon")
	attack_cooldown = get_node("WeaponCooldown")
	if !attack_cooldown.timeout.is_connected(_on_weapon_cooldown_timeout):
		attack_cooldown.timeout.connect(_on_weapon_cooldown_timeout)
	head.position.y = get_meta("Head_Height")
	set_process_input(true)
	
func _physics_process(delta: float) -> void:
	gravity(delta)
	handle_movement(delta)
	move_and_slide()
	set_camera_direction()
	
func gravity(delta: float)-> void:
	if not is_on_floor():
		velocity.y -= gravity_force * delta

func handle_movement(delta: float)-> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = lerp(velocity.x, direction.x * current_speed, acceleration * delta)
		velocity.z = lerp(velocity.z, direction.z * current_speed, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, acceleration * delta)
		velocity.z = lerp(velocity.z, 0.0, acceleration * delta)

func set_camera_direction()-> void:
	head.rotation_degrees.x = look_rotation.x
	rotation_degrees.y = look_rotation.y

func attack()-> void:
	can_attack = false
	attack_cooldown.start(weapon.get_cooldown())
	var targetDict: Dictionary = weapon.attack(camera)
	var target:Node3D = targetDict.get("collider")
	if target != null && target.is_in_group("enemy"):
		take_over(target)

func take_over(target: Node3D)-> void:
	remove_child(head)
	target.add_child(head)
	head.set_owner(target)
	target.set_script(load("res://scripts/player_controller.gd"))
	die()
	set_script(null)
	target.init_new_character()
	

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
