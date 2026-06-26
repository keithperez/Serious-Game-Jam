extends Node

var data: Array = [
	# texture path: String, modulate_texture: String, inital_hp: int, atk_damage: int, how_long_to_attack: float, color: Color = Color.WHITE
	["res://assets/enemy_textures/dice_enemy_outline.png", "res://assets/enemy_textures/dice_enemy_whitepart.png", 30, 5, 1.0, Color.WHITE],
	["res://assets/enemy_textures/poolball_outline.png", "res://assets/enemy_textures/poolball_whitespace.png", 40, 7, 1.0, Color.RED],
	["res://assets/enemy_textures/horse_outline.png", "res://assets/enemy_textures/horse_white.png", 50, 10, 1.0, Color.SADDLE_BROWN],
	["res://assets/enemy_textures/chips.png", "res://assets/enemy_textures/chips.png", 40, 12, 1.0, Color.WHITE],
	["res://assets/enemy_textures/Peter_Griffin-1.png.png", "res://assets/enemy_textures/Peter_Griffin-1.png.png", 100, 10, 1.0, Color.WHITE],
	["res://assets/placeholder/enemy_placeholder_art.png", "res://assets/placeholder/enemy_placeholder_art.png", 1, 1, 1.0, Color.WHITE],
	["res://assets/enemy_textures/dice_enemy_outline.png", "res://assets/enemy_textures/dice_enemy_whitepart.png", 70, 8, 1.0, Color.REBECCA_PURPLE],
	["res://assets/enemy_textures/dice_enemy_outline.png", "res://assets/enemy_textures/dice_enemy_whitepart.png", 30, 5, 1.0, Color.WHITE],
	["res://assets/enemy_textures/dice_enemy_outline.png", "res://assets/enemy_textures/dice_enemy_whitepart.png", 30, 5, 1.0, Color.WHITE],
	["res://assets/enemy_textures/dice_enemy_outline.png", "res://assets/enemy_textures/dice_enemy_whitepart.png", 30, 5, 1.0, Color.WHITE],
	["res://assets/enemy_textures/dice_enemy_outline.png", "res://assets/enemy_textures/dice_enemy_whitepart.png", 30, 5, 1.0, Color.WHITE],
	["res://assets/enemy_textures/dice_enemy_outline.png", "res://assets/enemy_textures/dice_enemy_whitepart.png", 30, 5, 1.0, Color.WHITE],
	["res://assets/enemy_textures/dice_enemy_outline.png", "res://assets/enemy_textures/dice_enemy_whitepart.png", 30, 5, 1.0, Color.WHITE],
	["res://assets/enemy_textures/dice_enemy_outline.png", "res://assets/enemy_textures/dice_enemy_whitepart.png", 30, 5, 1.0, Color.WHITE],
	["res://assets/enemy_textures/dice_enemy_outline.png", "res://assets/enemy_textures/dice_enemy_whitepart.png", 30, 5, 1.0, Color.WHITE],
	["res://assets/enemy_textures/dice_enemy_outline.png", "res://assets/enemy_textures/dice_enemy_whitepart.png", 30, 5, 1.0, Color.WHITE],
	["res://assets/enemy_textures/dice_enemy_outline.png", "res://assets/enemy_textures/dice_enemy_whitepart.png", 30, 5, 1.0, Color.WHITE]
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
