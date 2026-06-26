extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_music("res://assets/music/MKwii losing music.mp3", -15)


func _on_back_to_main_menu_pressed() -> void:
	GameManager.return_to_main_menu()
	pass # Replace with function body.
