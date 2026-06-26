extends Control

func _ready() -> void:
	AudioManager.play_music("res://assets/music/Monkeys Spinning Monkeys_KevinMacloed.mp3", -10)
	pass

func _on_character_one_button_pressed() -> void:
	GameManager.new_game_player_reset(GameManager.CharacterType.BASE)
