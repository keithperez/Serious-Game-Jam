extends Node2D

enum actions {NOTHING, ATTACK, SPECIAL, HEALING}
enum gamestate {PLAYERTURN, PLAYERDOING, ENEMYTURN, ENEMYDOING, CLAIMINGUPGRADE, INBETWEEN}

var whatamidoing: actions # for doing actions
var what_is_going_on: gamestate # for things going on in the game

@onready var hud: HUD = $HUD
@onready var enemy: BaseEnemy = $BaseEnemy
@onready var player: Player = $Player

var rng = RandomNumberGenerator.new()
var spins_left: int = 0
var health_taken: int = 0

var shown_upgrades: Array[BaseUpgrade] = []

var common_attacking_pool: Array = [AttackAllAddition, AttackEvenOddAddition, AttackRangeAddition, AttackOneNumberAdditive, AttackAllMultiplication]

func _ready() -> void:
	reset_upgrades_visibility()
	player.connect("action_emitter", _action_pressed_by_player)
	hud.wheel.connect("send_out_what_wheel_landed_on", _recieve_wheel_landed_on)
	hud.connect("upgrade_selected", _upgrade_selected)
	hud.wheel.load_roulette_wheel(0.04)
	enemy.load_enemy("res://assets/placeholder/placeholder_character.png", 30, 5)
	GameManager.player_send_status()

# always run per thing that happens

# this is where all game logic is stored
func _physics_process(_delta: float) -> void:
	match what_is_going_on:
		gamestate.PLAYERTURN:
			player.buttons.visible = true
		gamestate.PLAYERDOING:
			player.buttons.visible = false
		gamestate.ENEMYTURN:
			pass
		gamestate.ENEMYDOING:
			pass
		gamestate.CLAIMINGUPGRADE:
			pass
		gamestate.INBETWEEN:
			pass

func _recieve_wheel_landed_on(rolled_number: int) -> void:
	match whatamidoing:
		actions.ATTACK:
			if rolled_number == 20: spins_left+= 1
			var damage_done = calculate_attack_damage(rolled_number)
			enemy.take_damage(damage_done)
		actions.SPECIAL:
			if rolled_number == 20:
				GameManager.player_healed_for(health_taken)
			var damage_done = calculate_special_damage(rolled_number)
			enemy.take_damage(damage_done)
		actions.HEALING:
			if rolled_number == 20:
				GameManager.PlayerRestorationPotions += 1
				GameManager.player_send_status()
			var healing_done = calculate_healing(rolled_number)
			GameManager.player_healed_for(healing_done)
	if spins_left > 0:
		spins_left -= 1
		hud.wheel.spin_wheel()
	what_is_going_on = gamestate.ENEMYTURN

func calculate_attack_damage(rolled_number: int) -> int:
	var damage: int = rolled_number
	for upgrade in GameManager.PlayerAttackAdditiveUpgrades:
		damage = upgrade.apply_upgrade(rolled_number, damage)
	for upgrade in GameManager.PlayerAttackMultiplicativeUpgrades:
		damage = upgrade.apply_upgrade(rolled_number, damage)
	return damage

func calculate_special_damage(rolled_number: int) -> int:
	var damage: int = rolled_number + 10
	for upgrade in GameManager.PlayerSpecialAdditiveUpgrades:
		damage = upgrade.apply_upgrade(rolled_number, damage)
	for upgrade in GameManager.PlayerSpecialMultiplicativeUpgrades:
		damage = upgrade.apply_upgrade(rolled_number, damage)
	return damage

func calculate_healing(rolled_number: int) -> int:
	var healing: int = rolled_number
	for upgrade in GameManager.PlayerHealAdditiveUpgrades:
		healing = upgrade.apply_upgrade(rolled_number, healing)
	for upgrade in GameManager.PlayerHealMultiplicativeUpgrades:
		healing = upgrade.apply_upgrade(rolled_number, healing)
	return healing * 5

func _action_pressed_by_player(action) -> void:
	match action:
		player.actionSelected.ATTACK:
			whatamidoing = actions.ATTACK
			if GameManager.AttackTwiceLegendary:
				spins_left = 1
			else:
				spins_left = 0
		player.actionSelected.SPECIAL:
			whatamidoing = actions.SPECIAL
			health_taken = 0
			if GameManager.Boss_LessExpesniveWheel:
				health_taken = floor(GameManager.PlayerMaxHealth * 0.075)
			else:
				health_taken = floor(GameManager.PlayerMaxHealth * 0.15)
			if GameManager.PlayerHealth - health_taken <= 0:
				GameManager.PlayerHealth = 1
				GameManager.player_send_status()
			else:
				GameManager.player_take_damage(health_taken)
		player.actionSelected.HEAL:
			whatamidoing = actions.HEALING
			GameManager.PlayerRestorationPotions -= 1
			GameManager.player_send_status()
			pass
	hud.wheel.spin_wheel()
	what_is_going_on = gamestate.PLAYERDOING

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
	var wheel_index: int = rng.randi_range(0, 0) # attack, special, healing
	var number_roll: float = rng.randf() # 0.85 < common
	match wheel_index: 
		0: # attacking wheel
			var upgrade: BaseUpgrade = common_attacking_pool.pick_random().new()
			shown_upgrades.append(upgrade)
		1: # special wheel
			pass
		2: # healing wheel
			pass
