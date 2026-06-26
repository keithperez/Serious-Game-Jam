extends Node

var num_players: int = 4
var bus: String = "SFX"

var available: Array = []
var queue: Array = []

var music: AudioStreamPlayer = AudioStreamPlayer.new()

func _ready() -> void:
	# Create the pool of AudioStreamPlayer nodes.
	for i: int in num_players:
		var player: AudioStreamPlayer = AudioStreamPlayer.new()
		add_child(player)
		available.append(player)
		player.finished.connect(_on_stream_finished.bind(player))
		player.bus = bus

	add_child(music)

# once the stream is finished, add it back to the available players
func _on_stream_finished(stream: AudioStreamPlayer) -> void:
	available.append(stream)
	

func play_sfx(path: String, change_decibels: int = 0) -> void:
	var data: Array = [path, change_decibels]
	queue.append(data)

func play_music(path: String, change_decibels: int) -> void:
	music.bus = "Music"
	music.stream = load(path)
	music.volume_db = change_decibels
	music.play()

func _process(_delta: float) -> void:
	if not queue.is_empty() and not available.is_empty():
		var sound: Array = queue.pop_front()
		available[0].stream = load(sound[0])
		available[0].volume_db = sound[1]
		available[0].play()
		available.pop_front()
