class_name SpecialAllMultiplication
extends BaseUpgrade

var effect: float = 1.30

func _init() -> void:
	wheel_type = UpgradeDisplayer.wheel_type.SPECIAL
	rarity = UpgradeDisplayer.rarity_types.RARE
	description = "Adds +30% damage to all rolls."
	upgrade_type = "multiplicative"

func apply_upgrade(_rolled_number: int, damage: int) -> int:
	return floor(damage * effect)
