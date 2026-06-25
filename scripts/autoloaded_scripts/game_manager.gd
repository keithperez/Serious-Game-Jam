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
var InvincibleHealLegendary: bool = false
var InvincibleTurns: int = 0

#boss upgrades
enum BOSS_UPGRADES {MOREUPGRADES, MOREFLASKS, LESSEXPENSIVEWHEEL, MAXHEALTH, CRITS}

var boss_upgrade_dictionary: Dictionary[String, bool] = {
	"MOREUPGRADES" = false,
	"MOREFLASKS" = false,
	"LESSEXPENSIVEWHEEL" = false,
	"MAXHEALTH" = false,
	"CRITS" = true
}

# stuff for fading screens
@onready var fadingscreen_color: ColorRect = $FadingScreen/ColorRect
func fade(target_alpha: float, duration: float = 1.0) -> Tween:
	var tween = create_tween()
	tween.tween_property(fadingscreen_color, "color:a", target_alpha, duration)
	return tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#AudioManager.play_music("res://assets/music/Monkeys Spinning Monkeys_KevinMacloed.mp3")
	AudioManager.play_music("res://assets/music/Goat_sim_song.mp3", -15)
	pass

# for starting a new game (adaptable with more characters)
func new_game_player_reset(character: CharacterType) -> void:
	match character:
		CharacterType.BASE:
			PlayerMaxHealth = 100
			PlayerHealth = 100
			PlayerRestorationPotions = 5
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
		PlayerHealth = min(PlayerHealth + heal, PlayerMaxHealth)
	emit_signal("update_player_health", PlayerHealth, PlayerMaxHealth, PlayerRestorationPotions)

func player_take_damage(damage: int) -> void:
	if damage >= PlayerMaxHealth * 0.5:
		AudioManager.play_sfx("res://assets/sfx/FAHHHHHHH.mp3")
	PlayerHealth -= damage
	emit_signal("update_player_health", PlayerHealth, PlayerMaxHealth, PlayerRestorationPotions)

func give_player_notification(text: String) -> void:
	emit_signal("notify_player", text)
	
