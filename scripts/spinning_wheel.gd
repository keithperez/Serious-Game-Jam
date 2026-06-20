extends Control

@export var wheel_start_velocity: float = 100.0
@export var wheel_friction: float = 0.01
@export var options: Array[String] = []

@export var linebreaker: PackedScene

@onready var wheel: Node2D = $ActualSpinnyPart

var wheel_velocity: float = 0.0
var rng: RandomNumberGenerator
var change_in_rotation: float = 0.0

var spacing: float = 0.0

var labelsetting: LabelSettings = LabelSettings.new()

func prep_wheel() -> void:
	for i in range(options.size()):
		var degreeInRadian: float = (-i-1) * spacing
		var linebreak = linebreaker.instantiate()
		linebreak.position = position
		linebreak.rotation = degreeInRadian
		wheel.add_child(linebreak)
		var label = Label.new()
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.text = options[i]
		label.position = position + Vector2(cos(degreeInRadian + spacing*0.5) * 150, sin(degreeInRadian + spacing*0.5) * 150)
		label.rotation = degreeInRadian + spacing*0.5
		label.label_settings = labelsetting
		wheel.add_child(label)

func activate() -> void:
	wheel_velocity = wheel_start_velocity
	rng = RandomNumberGenerator.new()
	wheel_friction += rng.randf_range(-0.005, 0.005)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spacing = 2 * PI / options.size()
	labelsetting.font_color = Color.BLACK

func _physics_process(delta: float) -> void:
	if wheel_velocity > 0.05:
		change_in_rotation += wheel_velocity * delta
		wheel.rotation += wheel_velocity * delta
		wheel_velocity *= 1 - wheel_friction
		if change_in_rotation >= spacing:
			AudioManager.play_sfx("res://assets/sfx/Spinning_Tick_victorabdo_cropped.mp3")
			change_in_rotation -= spacing
	print(get_value())

func get_value() -> String:
	return options[floori(fmod(wheel.rotation, 2*PI) / spacing)]
