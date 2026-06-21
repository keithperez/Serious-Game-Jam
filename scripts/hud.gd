extends Control

@onready var wheel: Wheel = $BetterSpinningWheel
@onready var health_bar: ProgressBar = $BarContainer/HealthContainer/HealthBar
@onready var number_of_heals: Label = $BarContainer/HealContainer/PotionsRemaining

func _ready() -> void:
	GameManager.connect("update_player_health", _update_player_health)


func _update_player_health(PlayerHealth: int, PlayerMaxHealth: int) -> void:
	health_bar.max_value = PlayerMaxHealth
	health_bar.value = PlayerHealth
