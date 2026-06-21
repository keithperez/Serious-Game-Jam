extends Node2D

enum actions {NOTHING, ATTACK, SPECIAL, HEALING}

var player_turn: bool = true
var whatamidoing: actions

@onready var hud = $HUD
@onready var enemy: BaseEnemy = $BaseEnemy

func _ready() -> void:
	hud.wheel.connect("send_out_what_wheel_landed_on", _recieve_wheel_landed_on)
	hud.wheel.load_wheel([0, 1, 2, 3, 4, 5, 6, 7], 0.4, 8, [Color.RED, Color.BLUE, Color.RED, Color.BLUE, Color.RED, Color.BLUE, Color.RED, Color.BLUE], ["res://assets/placeholder/placeholder_logo.png", "","","","","","",""])
	enemy.load_enemy("res://assets/placeholder/placeholder_character.png", 100, 5)
	pass

func _physics_process(_delta: float) -> void:
	if player_turn:
		if Input.is_action_just_pressed("attack") and hud.wheel.idling:
			print("attacking")
			hud.wheel.spin_wheel()
			whatamidoing = actions.ATTACK
			pass
		if Input.is_action_just_pressed("heal") and hud.wheel.idling:
			print("healing")
			hud.wheel.spin_wheel()
			pass
	pass

func _recieve_wheel_landed_on(thing) -> void:
	match whatamidoing:
		actions.ATTACK:
			enemy.take_damage(10 + thing)
			print(10 + thing)
