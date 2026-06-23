class_name BaseUpgrade
extends Resource

var upgrade_type: String = "n/a"
var wheel_type: UpgradeDisplayer.wheel_type = UpgradeDisplayer.wheel_type.ATTACK
var rarity: UpgradeDisplayer.rarity_types = UpgradeDisplayer.rarity_types.COMMON
var description: String = "placeholder"

func apply_upgrade(rolled_number: int, damage: int):
	pass
