extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_music("res://assets/music/Monkeys Spinning Monkeys_KevinMacloed.mp3", -15)
	pass # Replace with function body.


func _on_back_to_main_menu_pressed() -> void:
	GameManager.return_to_main_menu()
	pass # Replace with function body.
