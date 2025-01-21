extends Node3D

@onready var specific_weapon_behaviour = $specific_weapon_behaviour

func attack(camera: Camera3D)-> Dictionary:
	return specific_weapon_behaviour.shoot(camera)
	
func get_cooldown()-> float:
	return specific_weapon_behaviour.cooldown
