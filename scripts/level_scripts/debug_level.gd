extends Node2D

enum actions {NOTHING, ATTACK, SPECIAL, HEALING}

var player_turn: bool = true
var whatamidoing: actions

@onready var hud = $HUD
@onready var enemy: BaseEnemy = $BaseEnemy
@onready var player: Player = $Player

func _ready() -> void:
	player.connect("action_emitter", _action_pressed_by_player)
	hud.wheel.connect("send_out_what_wheel_landed_on", _recieve_wheel_landed_on)
	hud.wheel.load_roulette_wheel(0.95)
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
			
func _action_pressed_by_player(action) -> void:
	match action:
		player.actionSelected.ATTACK:
			whatamidoing = actions.ATTACK
		player.actionSelected.MAGIC:
			print("magicking")
			pass
		player.actionSelected.HEAL:
			print("healing")
			pass
	hud.wheel.spin_wheel()
	player_turn = false
	player.buttons.visible = false
	pass
