class_name specific_weapon_behaviour extends Node

var ray_range = 5000
var cooldown = 0.5

func shoot(camera: Camera3D)-> Dictionary:
	var space_state = camera.get_world_3d().direct_space_state
	var screen_center = get_viewport().size / 2
	var origin = camera.project_ray_origin(screen_center)
	var end_point = origin + camera.project_ray_normal(screen_center) * ray_range
	var query = PhysicsRayQueryParameters3D.create(origin, end_point)
	query.collide_with_bodies = true
	return space_state.intersect_ray(query)
