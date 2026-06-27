extends Control

@onready var sprite: AnimatedSprite2D = $running_sprite

func _ready() -> void:
	AudioManager.play_music("res://assets/music/Phantom - Persona 5.mp3", -10)
	sprite.play()
	pass

func _physics_process(_delta: float) -> void:
	if sprite.position.x > -50:
		sprite.position.x -= 5
	else:
		sprite.position.x = 2000
		match randi_range(0, 2):
			0:
				sprite.play("boss_balatro")
			1:
				sprite.play("enemy_snake_eyes")
			2:
				sprite.play("enemy_garybobby")
	pass

func _on_character_one_button_pressed() -> void:
	GameManager.new_game_player_reset(GameManager.CharacterType.BASE)
