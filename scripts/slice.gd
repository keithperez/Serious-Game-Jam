extends Control

@onready var white: Sprite2D = $WhitePart
@onready var logo: Sprite2D = $LogoPart

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_color(color: Color) -> void:
	white.modulate = color
	
func set_texture(path: String) -> void:
	logo.texture = load(path)
	pass
