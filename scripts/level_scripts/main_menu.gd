extends Control


func _on_character_one_button_pressed() -> void:
	GameManager.new_game_player_reset(GameManager.CharacterType.BASE)
	print(GameManager.PlayerMaxHealth, GameManager.PlayerHealth, GameManager.PlayerRestorationPotions)
