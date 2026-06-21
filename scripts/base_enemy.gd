class_name BaseEnemy
extends Node2D

var health: int
var standard_attack_damage: int
var alternative_move_chance: float = 0.0

@onready var texture: Sprite2D = $Sprite2D
@onready var health_bar: ProgressBar = $HealthBar

func load_enemy(texture_path: String, inital_hp: int, initial_atk_damage: int, alt_move_chance: float = 0.0) -> void:
	texture.texture = load(texture_path)
	health = inital_hp
	standard_attack_damage = initial_atk_damage
	alternative_move_chance = alt_move_chance
	health_bar.max_value = inital_hp
	health_bar.value = health

func take_damage(damage: int) -> void:
	health -= damage
	health_bar.value = health

func deal_damage() -> void:
	pass
