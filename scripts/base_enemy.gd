class_name BaseEnemy
extends Node2D

var max_health: int
var health: int
var standard_attack_damage: int
var how_long_to_attack: float = 0.0
var is_boss: bool = false
var boss_num: int

@onready var texture: Sprite2D = $Sprite2D
@onready var modulating_texture: Sprite2D = $ModulatingSprite
@onready var health_bar: ProgressBar = $HealthBar
@onready var health_bar_numbers: Label = $Numbers
@onready var general_timer: Timer = $GeneralTimer

func load_enemy(texture_path: String, inital_hp: int, initial_atk_damage: int, time_to_move: float, color: Color = Color.WHITE) -> void:
	texture.texture = load(texture_path)
	modulating_texture.texture = load(texture_path)
	max_health = inital_hp
	health = inital_hp
	standard_attack_damage = initial_atk_damage
	how_long_to_attack = time_to_move
	health_bar.max_value = inital_hp
	health_bar.value = health
	health_bar_numbers.text = "%d / %d" % [health, max_health]
	modulating_texture.self_modulate = color
	is_boss = false

func load_enemy_from_data(index: int) -> void:
	texture.texture = load(EnemyData.get_texture_path_from_index(index))
	modulating_texture.texture = load(EnemyData.get_modulating_texture_path_from_index(index))
	var intial_hp: int = EnemyData.get_inital_HP_from_index(index)
	max_health = intial_hp
	health = intial_hp
	standard_attack_damage = EnemyData.get_atk_damage_from_index(index)
	how_long_to_attack = EnemyData.get_how_long_to_attack_from_index(index)
	health_bar.max_value = intial_hp
	health_bar.value = intial_hp
	health_bar_numbers.text = "%d / %d" % [health, max_health]
	modulating_texture.self_modulate = EnemyData.get_color_from_index(index)
	is_boss = false

func load_boss_from_data(index: int) -> void:
	texture.texture = load(BossData.get_texture_path_from_index(index))
	modulating_texture.texture = load(BossData.get_modulating_texture_path_from_index(index))
	var intial_hp: int = BossData.get_inital_HP_from_index(index)
	max_health = intial_hp
	health = intial_hp
	standard_attack_damage = BossData.get_atk_damage_from_index(index)
	how_long_to_attack = BossData.get_how_long_to_attack_from_index(index)
	health_bar.max_value = intial_hp
	health_bar.value = intial_hp
	health_bar_numbers.text = "%d / %d" % [health, max_health]
	modulating_texture.self_modulate = BossData.get_color_from_index(index)
	is_boss = true
	boss_num = index

func take_damage(damage: int) -> void:
	health -= damage
	update_health_bar()

func update_health_bar() -> void:
	health_bar.value = health
	health_bar_numbers.text = "%d / %d" % [health, max_health]

func deal_damage() -> void:
	GameManager.player_take_damage(standard_attack_damage)
	GameManager.give_player_notification("You took %d damage!" % standard_attack_damage)
	#general_timer.start(how_long_to_attack)

func _on_general_timer_timeout() -> void:
	GameManager.player_take_damage(standard_attack_damage)
