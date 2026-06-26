class_name AttackRangeMultiplication
extends BaseUpgrade

var effect: float = 1.5
var lower_limit: int
var upper_limit: int

func _init() -> void:
	randomize()
	wheel_type = UpgradeDisplayer.wheel_type.ATTACK
	rarity = UpgradeDisplayer.rarity_types.RARE
	match randi_range(0, 3):
		0:
			lower_limit = 1
			upper_limit = 5
		1:
			lower_limit = 6
			upper_limit = 10
		2:
			lower_limit = 11
			upper_limit = 15
		3:
			lower_limit = 16
			upper_limit = 20
		
	description = "Adds +50%% damage to numbers %d-%d." % [lower_limit, upper_limit]
	upgrade_type = "multiplicative"

func apply_upgrade(rolled_number: int, damage: int):
	if lower_limit <= rolled_number and rolled_number <= upper_limit:
		return floor(damage * effect)
	return damage
