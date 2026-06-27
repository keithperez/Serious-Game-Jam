extends Node

#signals
signal update_player_health(PlayerHealth: int, PlayerMaxHealth: int, PlayerFlasks: int)
signal notify_player(text: String)

enum CharacterType {BASE}

var PlayerMaxHealth: int = 100
var PlayerHealth: int = PlayerMaxHealth
var PlayerRestorationPotions: int = 5

var PlayerAttackAdditiveUpgrades: Array[BaseUpgrade] = []
var PlayerAttackMultiplicativeUpgrades: Array[BaseUpgrade] = []

var PlayerSpecialAdditiveUpgrades: Array[BaseUpgrade] = []
var PlayerSpecialMultiplicativeUpgrades: Array[BaseUpgrade] = []

var PlayerHealAdditiveUpgrades: Array[BaseUpgrade] = []
var PlayerHealMultiplicativeUpgrades: Array[BaseUpgrade] = []

#legendary effects
var AttackTwiceLegendary: bool = false
var UnderMaxHealthLegendary: bool = false
var MaxHealthOverhealLegendary: bool = false

# yeah i slimed this one out in particular
var InvincibleHealLegendary: bool = false
var InvincibleTurns: int = 0

#boss upgrades
enum BOSS_UPGRADES {MOREUPGRADES, MOREFLASKS, LESSEXPENSIVEWHEEL, MAXHEALTH, CRITS}

var boss_upgrade_dictionary: Dictionary[String, bool] = {
	"MOREUPGRADES" = false,
	"MOREFLASKS" = false,
	"LESSEXPENSIVEWHEEL" = false,
	"MAXHEALTH" = false,
	"CRITS" = false
}

# stuff for fading screens
@onready var fadingscreen_color: ColorRect = $FadingScreen/ColorRect
func fade(target_alpha: float, duration: float = 1.0) -> Tween:
	var tween = create_tween()
	tween.tween_property(fadingscreen_color, "color:a", target_alpha, duration)
	return tween

func win_game_function() -> void:
	await fade(1.0, 3.0).finished
	get_tree().change_scene_to_file("res://scenes/you_win_screen.tscn")
	fade(0.0, 1.0)

func return_to_main_menu() -> void:
	await fade(1.0, 0.5).finished
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	fade(0.0, 0.5)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	pass

# for starting a new game (adaptable with more characters)
func new_game_player_reset(character: CharacterType) -> void:
	match character:
		CharacterType.BASE:
			PlayerMaxHealth = 100
			PlayerHealth = 100
			PlayerRestorationPotions = 5
	boss_upgrade_dictionary = {
		"MOREUPGRADES" = false,
		"MOREFLASKS" = false,
		"LESSEXPENSIVEWHEEL" = false,
		"MAXHEALTH" = false,
		"CRITS" = false
	}
	PlayerAttackAdditiveUpgrades = []
	PlayerAttackMultiplicativeUpgrades = []

	PlayerSpecialAdditiveUpgrades = []
	PlayerSpecialMultiplicativeUpgrades = []

	PlayerHealAdditiveUpgrades = []
	PlayerHealMultiplicativeUpgrades = []

	#legendary effects
	AttackTwiceLegendary = false
	UnderMaxHealthLegendary = false
	MaxHealthOverhealLegendary = false
	await fade(1.0, 1.5).finished
	get_tree().change_scene_to_file("res://scenes/levels/debug_level.tscn")
	fade(0.0, 1.5)

func player_send_status() -> void:
	emit_signal("update_player_health", PlayerHealth, PlayerMaxHealth, PlayerRestorationPotions)

func player_healed_for(heal: int) -> void:
	if MaxHealthOverhealLegendary:
		if PlayerHealth + heal > PlayerMaxHealth:
			PlayerMaxHealth = PlayerHealth + heal
			PlayerHealth = PlayerMaxHealth
		else:
			PlayerHealth = PlayerHealth + heal
	else:
		PlayerHealth = min(PlayerHealth + heal, PlayerMaxHealth)
	emit_signal("update_player_health", PlayerHealth, PlayerMaxHealth, PlayerRestorationPotions)

func player_take_damage(damage: int) -> void:
	if InvincibleTurns > 0:
		InvincibleTurns -= 1
		GameManager.give_player_notification("You negated %d damage! You have %d more turns with invincibility!" % [damage, InvincibleTurns])
		return
	if damage >= PlayerMaxHealth * 0.5:
		AudioManager.play_sfx("res://assets/sfx/FAHHHHHHH.mp3", -10)
	else:
		print("play this sound")
		AudioManager.play_sfx("res://assets/sfx/player_hurt_sfx - Celestial SFX.mp3", -10)
	PlayerHealth -= damage
	GameManager.give_player_notification("You took %d damage!" % damage)
	emit_signal("update_player_health", PlayerHealth, PlayerMaxHealth, PlayerRestorationPotions)
	if PlayerHealth <= 0:
		await fade(1.0, 5.0).finished
		get_tree().change_scene_to_file("res://scenes/game_over_screen.tscn")
		fade(0.0, 1.5)

func give_player_notification(text: String) -> void:
	emit_signal("notify_player", text)
	
func make_list_of_upgrades() -> String:
	var text: String = "Upgrades:\n"
	text += "\n"
	text += "Boss Upgrades:\n"
	for key in boss_upgrade_dictionary:
		if boss_upgrade_dictionary[key]:
			text += key + ": Acquired\n"
	text += "\n"
	text += "Attack Wheel Upgrades:\n"
	if AttackTwiceLegendary: text += "Attack twice per attack spin.\n"
	for upgrade in PlayerAttackAdditiveUpgrades:
		text += upgrade.description + "\n"
	for upgrade in PlayerAttackMultiplicativeUpgrades:
		text += upgrade.description + "\n"
	text += "\n"
	text += "Special Wheel Upgrades:\n"
	if UnderMaxHealthLegendary: text += "Lower HP gives More Special Damage.\n"
	for upgrade in PlayerSpecialAdditiveUpgrades:
		text += upgrade.description + "\n"
	for upgrade in PlayerSpecialMultiplicativeUpgrades:
		text += upgrade.description + "\n"
	text += "\n"
	text += "Heal Wheel Upgrades:\n"
	if MaxHealthOverhealLegendary: text += "Heals past max health, make that the max health.\n"
	for upgrade in PlayerHealAdditiveUpgrades:
		text += upgrade.description + "\n"
	for upgrade in PlayerHealMultiplicativeUpgrades:
		text += upgrade.description + "\n"
	return text
