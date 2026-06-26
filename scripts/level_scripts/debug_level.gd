extends Node2D

enum actions {NOTHING, ATTACK, SPECIAL, HEALING}
enum gamestate {PLAYERTURN, PLAYERDOING, ENEMYTURN, ENEMYDOING, CLAIMINGUPGRADE, INBETWEEN, GAMEJUSTSTARTED, ENEMYSPAWNED}

var whatamidoing: actions # for doing actions
var what_is_going_on: gamestate = gamestate.GAMEJUSTSTARTED # for things going on in the game

@onready var hud: HUD = $HUD
@onready var enemy: BaseEnemy = $BaseEnemy
@onready var player: Player = $Player
@onready var tutorial: Panel = $"Quick Tutorial"
@onready var tutorialButton: Button = $CloseTutorialButton
@onready var general_timer: Timer = $GeneralTimer

@onready var whogoesfirsttext: Label = $ExplainingText
@onready var blackbutton: Button = $Black
@onready var redbutton: Button = $Red
var playerCalled: int # 0 for red, 1 for black

var rng = RandomNumberGenerator.new()
var spins_left: int = 0
var health_taken: int = 0

var enemy_index: int = 0
var boss_indexes: Array[int] = [5, 10, 15]
var boss_index: int = 0

var shown_upgrades: Array[BaseUpgrade] = []

var common_attacking_pool: Array = [AttackAllAddition, AttackEvenOddAddition, AttackRangeAddition, AttackOneNumberAdditive, AttackAllMultiplication]
var rare_attacking_pool: Array = []

var common_special_pool: Array = []
var rare_special_pool: Array = []

var common_healing_pool: Array = []
var rare_healing_pool: Array = []

func _ready() -> void:
	AudioManager.play_music("res://assets/music/Whims of Fate - Persona 5.mp3.mp3", -20)
	reset_upgrades_visibility()
	player.connect("action_emitter", _action_pressed_by_player)
	hud.wheel.connect("send_out_what_wheel_landed_on", _recieve_wheel_landed_on)
	hud.connect("upgrade_selected", _upgrade_selected)
	hud.wheel.load_roulette_wheel(0.04)
	GameManager.player_send_status()
	run_game_logic()

# always run per thing that happens

# this is where all game screen stuff is stored
func _physics_process(_delta: float) -> void:
	pass

func run_game_logic() -> void:
	match what_is_going_on:
		gamestate.GAMEJUSTSTARTED:
			tutorial.visible = true
			tutorialButton.visible = true
		gamestate.PLAYERTURN:
			player.buttons.visible = true
		gamestate.PLAYERDOING:
			player.buttons.visible = false
		gamestate.ENEMYTURN:
			general_timer.start()
			what_is_going_on = gamestate.ENEMYDOING
		gamestate.ENEMYDOING:
			pass
		gamestate.CLAIMINGUPGRADE:
			enemy.visible = false
			var amountOfUpgrades = 3
			if GameManager.boss_upgrade_dictionary["MOREUPGRADES"]: amountOfUpgrades += 1
			if enemy.is_boss:
				print(shown_upgrades.size())
				generate_random_boss_upgrade()
				generate_random_boss_upgrade()
				generate_random_boss_upgrade()
				pass
			else:
				for i in range(0, amountOfUpgrades):
					generate_random_upgrade()
			show_upgrades()
		gamestate.INBETWEEN:
			if enemy_index in boss_indexes:
				enemy.load_boss_from_data(boss_indexes.find(enemy_index))
				AudioManager.play_music("res://assets/music/Blooming Villian - Persona 5.mp3", -20)
			else:
				enemy.load_enemy_from_data(enemy_index)
			enemy.visible = true
			what_is_going_on = gamestate.ENEMYSPAWNED
			run_game_logic()
		gamestate.ENEMYSPAWNED:
			enemy.visible = true
			enemy.update_health_bar()
			player.buttons.visible = false
			blackbutton.visible = true
			redbutton.visible = true
			whogoesfirsttext.visible = true


func _recieve_wheel_landed_on(rolled_number: int) -> void:
	if what_is_going_on == gamestate.ENEMYSPAWNED:
		if hud.wheel.get_current_slice_index() % 2 != playerCalled:
			what_is_going_on = gamestate.PLAYERTURN
			print("player turn")
			run_game_logic()
			return
		else:
			what_is_going_on = gamestate.ENEMYTURN
			print("enemy turn")
			run_game_logic()
			return
	match whatamidoing:
		actions.ATTACK:
			if rolled_number == 20: 
				spins_left+= 1
				AudioManager.play_sfx("res://assets/sfx/peggle_free_ball_sfx.mp3", -10)
			var damage_done = calculate_attack_damage(rolled_number)
			enemy.take_damage(damage_done)
			AudioManager.play_sfx("res://assets/sfx/Player_Attack_Sfx - Barogs Gaming.mp3", -20)
			GameManager.give_player_notification("You dealt %d damage to the enemy!" % damage_done)
		actions.SPECIAL:
			if rolled_number == 20:
				GameManager.player_healed_for(health_taken)
				AudioManager.play_sfx("res://assets/sfx/peggle_free_ball_sfx.mp3", -10)
			var damage_done = calculate_special_damage(rolled_number)
			enemy.take_damage(damage_done)
			AudioManager.play_sfx("res://assets/sfx/Player_Special_sfx.mp3", -10)
			GameManager.give_player_notification("You dealt %d damage to the enemy!" % damage_done)
		actions.HEALING:
			if rolled_number == 20:
				GameManager.PlayerRestorationPotions += 1
				GameManager.player_send_status()
				AudioManager.play_sfx("res://assets/sfx/peggle_free_ball_sfx.mp3", -10)
			var healing_done = calculate_healing(rolled_number)
			GameManager.player_healed_for(healing_done)
			AudioManager.play_sfx("res://assets/sfx/Player_Healing_Sfx.mp3", 10)
			GameManager.give_player_notification("You healed %d health!" % healing_done)
	if enemy.health <= 0:
		if enemy.is_boss:
			AudioManager.play_sfx("res://assets/sfx/Boss_Death_sfx - Xubors.mp3", -20)
			AudioManager.play_music("res://assets/music/Whims of Fate - Persona 5.mp3.mp3", -20)
			GameManager.PlayerMaxHealth += 25
			GameManager.PlayerHealth = GameManager.PlayerMaxHealth
			if GameManager.boss_upgrade_dictionary["MOREFLASKS"]:
				GameManager.PlayerRestorationPotions = 7
			else:
				GameManager.PlayerRestorationPotions = 5
		what_is_going_on = gamestate.CLAIMINGUPGRADE
		enemy_index += 1
		run_game_logic()
		return
	if what_is_going_on == gamestate.PLAYERDOING and spins_left == 0:
		what_is_going_on = gamestate.ENEMYTURN
		run_game_logic()
	if spins_left > 0:
		spins_left -= 1
		hud.wheel.spin_wheel()

func calculate_attack_damage(rolled_number: int) -> int:
	var damage: int = rolled_number
	if GameManager.boss_upgrade_dictionary["CRITS"] and randf() <= 0.1: 
		damage *= 3
		AudioManager.play_sfx("res://assets/sfx/crit_sfx.mp3")
	for upgrade in GameManager.PlayerAttackAdditiveUpgrades:
		damage = upgrade.apply_upgrade(rolled_number, damage)
	for upgrade in GameManager.PlayerAttackMultiplicativeUpgrades:
		damage = upgrade.apply_upgrade(rolled_number, damage)
	return damage

func calculate_special_damage(rolled_number: int) -> int:
	var damage: int = rolled_number + 10
	if GameManager.boss_upgrade_dictionary["CRITS"] and randf() <= 0.1: 
		damage *= 3
		AudioManager.play_sfx("res://assets/sfx/crit_sfx.mp3")
	for upgrade in GameManager.PlayerSpecialAdditiveUpgrades:
		damage = upgrade.apply_upgrade(rolled_number, damage)
	for upgrade in GameManager.PlayerSpecialMultiplicativeUpgrades:
		damage = upgrade.apply_upgrade(rolled_number, damage)
	return damage

func calculate_healing(rolled_number: int) -> int:
	var healing: int = rolled_number
	if GameManager.boss_upgrade_dictionary["CRITS"] and randf() <= 0.1: 
		healing *= 3
		AudioManager.play_sfx("res://assets/sfx/crit_sfx.mp3")
	for upgrade in GameManager.PlayerHealAdditiveUpgrades:
		healing = upgrade.apply_upgrade(rolled_number, healing)
	for upgrade in GameManager.PlayerHealMultiplicativeUpgrades:
		healing = upgrade.apply_upgrade(rolled_number, healing)
	return healing * 5

func _action_pressed_by_player(action) -> void:
	if what_is_going_on != gamestate.PLAYERTURN:
		print(what_is_going_on)
		return
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
			if GameManager.boss_upgrade_dictionary["LESSEXPENSIVEWHEEL"]:
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
	run_game_logic()

func _upgrade_selected(index: int) -> void:
	match shown_upgrades[index].wheel_type:
		UpgradeDisplayer.wheel_type.ATTACK: # for attacks
			match shown_upgrades[index].upgrade_type:
				"additive":
					GameManager.PlayerAttackAdditiveUpgrades.append(shown_upgrades[index])
				"multiplicative":
					GameManager.PlayerAttackMultiplicativeUpgrades.append(shown_upgrades[index])
		UpgradeDisplayer.wheel_type.BOSS:
			GameManager.boss_upgrade_dictionary[shown_upgrades[index].boss_type_upgrade] = true
			if shown_upgrades[index].boss_type_upgrade == "MAXHEALTH":
				GameManager.PlayerMaxHealth += 25
				GameManager.PlayerHealth = GameManager.PlayerMaxHealth
				GameManager.player_send_status()
	hud.upgradebuttoncontainer.visible = false
	shown_upgrades = [] #empty the upgrades
	what_is_going_on = gamestate.INBETWEEN
	run_game_logic()
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

func generate_random_boss_upgrade() -> void:
	var upgrade: BaseUpgrade = BaseUpgrade.new()
	upgrade.wheel_type = UpgradeDisplayer.wheel_type.BOSS
	upgrade.rarity = UpgradeDisplayer.rarity_types.NONE
	while true:
		var randomKey: String = GameManager.boss_upgrade_dictionary.keys().pick_random()
		if !GameManager.boss_upgrade_dictionary[randomKey] and check_shown_upgrades_for_the_same_boss_type_upgrade(randomKey): # is not true and is not already in the shown upgrades
			match randomKey:
				"MOREUPGRADES":
					upgrade.description = "Get another upgrade choice from non-bosses."
					upgrade.boss_type_upgrade = "MOREUPGRADES"
					pass
				"MOREFLASKS":
					upgrade.description = "Gain 2 healing flasks."
					upgrade.boss_type_upgrade = "MOREFLASKS"
					pass
				"LESSEXPENSIVEWHEEL":
					upgrade.description = "Damage taken from the special wheel is halved."
					upgrade.boss_type_upgrade = "LESSEXPENSIVEWHEEL"
					pass
				"MAXHEALTH":
					upgrade.description = "Gain an extra 25 max health."
					upgrade.boss_type_upgrade = "MAXHEALTH"
					pass
				"CRITS":
					upgrade.description = "Every wheel roll now has a 10% chance to crit, tripling the base rolled number."
					upgrade.boss_type_upgrade = "CRITS"
					pass
			break
	shown_upgrades.append(upgrade)
	
# worlds longest function name
func check_shown_upgrades_for_the_same_boss_type_upgrade(upgrade_type: String) -> bool:
	for upgrade in shown_upgrades:
		if upgrade.boss_type_upgrade == upgrade_type:
			return false
	return true

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


func _on_close_tutorial_button_pressed() -> void:
	AudioManager.play_sfx("res://assets/sfx/Spinning_Tick_victorabdo_cropped.mp3")
	tutorial.visible = false
	tutorialButton.visible = false
	enemy.load_enemy_from_data(enemy_index)
	what_is_going_on = gamestate.ENEMYSPAWNED
	run_game_logic()
	pass # Replace with function body.


func _on_black_pressed() -> void:
	playerCalled = 1
	blackbutton.visible = false
	redbutton.visible = false
	whogoesfirsttext.visible = false
	hud.wheel.spin_wheel()
	pass # Replace with function body.


func _on_red_pressed() -> void:
	playerCalled = 0
	blackbutton.visible = false
	redbutton.visible = false
	whogoesfirsttext.visible = false
	hud.wheel.spin_wheel()
	pass # Replace with function body.


func _on_general_timer_timeout() -> void:
	enemy.deal_damage()
	what_is_going_on = gamestate.PLAYERTURN
	run_game_logic()
	pass # Replace with function body.
