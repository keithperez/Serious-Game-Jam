extends Node

var data: Array = [
	["res://assets/boss_textures/Garret_Bobby_Ferguson-1.png (1).png", "res://assets/boss_textures/Garret_Bobby_Ferguson-1.png (1).png",  100, 15, 1.0, Color.WHITE],
	["res://assets/boss_textures/boss_slot_machine.png", "res://assets/boss_textures/boss_slot_machine.png",  250, 20, 1.0, Color.WHITE],
	["res://assets/placeholder/boss_placeholder_art.png", "res://assets/placeholder/boss_placeholder_art.png",  400, 25, 1.0, Color.WHITE]
]

func get_data_from_index(index: int) -> Array:
	return data[index]

func get_texture_path_from_index(index: int) -> String:
	return data[index][0]

func get_modulating_texture_path_from_index(index: int) -> String:
	return data[index][1]

func get_inital_HP_from_index(index: int) -> int:
	return data[index][2]

func get_atk_damage_from_index(index: int) -> int:
	return data[index][3]

func get_how_long_to_attack_from_index(index: int) -> float:
	return data[index][4]
	
func get_color_from_index(index: int) -> Color:
	return data[index][5]
