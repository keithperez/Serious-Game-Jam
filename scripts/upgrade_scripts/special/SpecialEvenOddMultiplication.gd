class_name SpecialEvenOddMultiplication
extends BaseUpgrade

var effect: float = 1.50
var even_or_odd: bool

func _init() -> void:
	randomize()
	wheel_type = UpgradeDisplayer.wheel_type.SPECIAL
	rarity = UpgradeDisplayer.rarity_types.RARE
	even_or_odd = randi() % 2 == 1 # 0 for even, 1 for odd
	if even_or_odd:
		description = "Adds +50% damage to odd numbers."
	else:
		description = "Adds +50% damage to even numbers."
	upgrade_type = "multiplicative"

func apply_upgrade(rolled_number: int, damage: int) -> int:
	if even_or_odd and rolled_number % 2 == 1: # if odd
		return floor(damage * effect)
	elif !even_or_odd and rolled_number % 2 == 0:
		return floor(damage * effect)
	else:
		return damage
