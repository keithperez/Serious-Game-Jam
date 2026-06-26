class_name AttackOneNumberMultiplication
extends BaseUpgrade

var effect: float = 2.0
var number: int

func _init() -> void:
	randomize()
	wheel_type = UpgradeDisplayer.wheel_type.ATTACK
	rarity = UpgradeDisplayer.rarity_types.RARE
	number = randi_range(1, 20)
	description = "Adds +100%% damage to the %d number." % number
	upgrade_type = "multiplicative"

func apply_upgrade(rolled_number: int, damage: int):
	if rolled_number == number:
		return floor(damage * effect)
	else:
		return damage
