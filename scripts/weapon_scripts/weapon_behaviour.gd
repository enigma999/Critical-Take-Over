extends Node3D

@onready var specific_weapon_behaviour_node = $specific_weapon_behaviour

func attack(camera: Camera3D)-> Dictionary:
	return specific_weapon_behaviour_node.shoot(camera)
	
func get_cooldown()-> float:
	return specific_weapon_behaviour_node.cooldown
