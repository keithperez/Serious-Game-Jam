extends Node

#signals
signal update_player_health(PlayerHealth: int, PlayerMaxHealth: int)

enum CharacterType {BASE}

var PlayerMaxHealth: int = 100
var PlayerHealth: int = PlayerMaxHealth
var PlayerRestorationPotions: int = 0

# stuff for fading screens
@onready var fadingscreen_color: ColorRect = $FadingScreen/ColorRect
func fade(target_alpha: float, duration: float = 1.0) -> Tween:
	var tween = create_tween()
	tween.tween_property(fadingscreen_color, "color:a", target_alpha, duration)
	return tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#AudioManager.play_music("res://assets/music/Monkeys Spinning Monkeys_KevinMacloed.mp3")
	pass

# for starting a new game (adaptable with more characters)
func new_game_player_reset(character: CharacterType) -> void:
	match character:
		CharacterType.BASE:
			PlayerMaxHealth = 100
			PlayerHealth = 100
			PlayerRestorationPotions = 5
	await fade(1.0, 1.5).finished
	get_tree().change_scene_to_file("res://scenes/levels/debug_level.tscn")
	fade(0.0, 1.5)

func player_take_damage(damage: int) -> void:
	PlayerHealth -= damage
	emit_signal("update_player_health", PlayerHealth, PlayerMaxHealth)
