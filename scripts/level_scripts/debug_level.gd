extends Node2D

enum actions {NOTHING, ATTACK, SPECIAL, HEALING}

var player_turn: bool = true
var whatamidoing: actions

@onready var hud: HUD = $HUD
@onready var enemy: BaseEnemy = $BaseEnemy
@onready var player: Player = $Player

var rng = RandomNumberGenerator.new()

var shown_upgrades: Array[BaseUpgrade] = []

var common_attacking_pool: Array = [AttackAllAddition, AttackEvenOddAddition, AttackRangeAddition, AttackOneNumberAdditive, AttackAllMultiplication]

func _ready() -> void:
	reset_upgrades_visibility()
	player.connect("action_emitter", _action_pressed_by_player)
	hud.wheel.connect("send_out_what_wheel_landed_on", _recieve_wheel_landed_on)
	hud.connect("upgrade_selected", _upgrade_selected)
	hud.wheel.load_roulette_wheel(0.04)
	enemy.load_enemy("res://assets/placeholder/placeholder_character.png", 100, 5)
	GameManager.player_send_status()
	generate_random_upgrade()
	generate_random_upgrade()
	generate_random_upgrade()
	show_upgrades()

func _physics_process(_delta: float) -> void:
	pass

func _recieve_wheel_landed_on(rolled_number: int) -> void:
	match whatamidoing:
		actions.ATTACK:
			var damage_done = calculate_attack_damage(rolled_number)
			enemy.take_damage(damage_done)
			print(damage_done)

func calculate_attack_damage(rolled_number: int) -> int:
	var damage: int = rolled_number
	for upgrade in GameManager.PlayerAttackAdditiveUpgrades:
		damage = upgrade.apply_upgrade(rolled_number, damage)
	for upgrade in GameManager.PlayerAttackMultiplicativeUpgrades:
		damage = upgrade.apply_upgrade(rolled_number, damage)
	return damage

func _action_pressed_by_player(action) -> void:
	match action:
		player.actionSelected.ATTACK:
			whatamidoing = actions.ATTACK
		player.actionSelected.SPECIAL:
			whatamidoing = actions.SPECIAL
			pass
		player.actionSelected.HEAL:
			whatamidoing = actions.HEALING
			pass
	hud.wheel.spin_wheel()
	player_turn = false
	player.buttons.visible = false
	pass

func _upgrade_selected(index: int) -> void:
	match shown_upgrades[index].wheel_type:
		UpgradeDisplayer.wheel_type.ATTACK: # for attacks
			match shown_upgrades[index].upgrade_type:
				"additive":
					GameManager.PlayerAttackAdditiveUpgrades.append(shown_upgrades[index])
				"multiplicative":
					GameManager.PlayerAttackMultiplicativeUpgrades.append(shown_upgrades[index])
	hud.upgradebuttoncontainer.visible = false
	shown_upgrades = [] #empty the upgrades
	pass

func reset_upgrades_visibility() -> void:
	for i in hud.upgrade_buttons.get_children():
		i.visible = false
	hud.upgradebuttoncontainer.visible = false

func show_upgrades() -> void:
	hud.upgradebuttoncontainer.visible = true
	for i in range(0, shown_upgrades.size()):
		hud.change_button(i, shown_upgrades[i])
		pass
	pass

func generate_random_upgrade() -> void:
	var wheel_index: int = rng.randi_range(0, 0)
	var number_roll: float = rng.randf()
	match wheel_index:
		0: # attacking wheel
			var upgrade: BaseUpgrade = common_attacking_pool.pick_random().new()
			shown_upgrades.append(upgrade)
		1: # special wheel
			pass
		2: # healing wheel
			pass
