class_name AttackAllMultiplication
extends BaseUpgrade

var effect: float = 1.15

func _init() -> void:
	wheel_type = UpgradeDisplayer.wheel_type.ATTACK
	rarity = UpgradeDisplayer.rarity_types.RARE
	description = "Adds +15% damage to all numbers."
	upgrade_type = "multiplicative"

func apply_upgrade(_rolled_number: int, damage: int) -> int:
	return floor(damage * effect)
