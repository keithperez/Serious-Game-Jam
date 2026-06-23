class_name AttackAllMultiplication
extends BaseUpgrade

var effect: float = 1.15

func _init() -> void:
	wheel_type = UpgradeDisplayer.wheel_type.ATTACK
	rarity = UpgradeDisplayer.rarity_types.UNCOMMON
	description = "Adds +%d%% damage to all attack rolls." % ((effect - 1) * 100)
	upgrade_type = "multiplicative"

func apply_upgrade(_rolled_number: int, damage: int) -> int:
	return floor(damage * effect)
