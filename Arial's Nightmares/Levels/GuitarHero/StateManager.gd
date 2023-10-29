extends Node2D

var difficulties = {
	"easy": {
		"speed": 1,
		"song_path": "res://Levels/GuitarHero/Ed-Sheeran-Perfect-Easy.mp3"
	},
	"normal": {
		"speed": 3,
		"song_path": "res://Levels/GuitarHero/Ed-Sheeran-Perfect-Normal.mp3"
	},
	"hard": {
		"speed": 5,
		"song_path": "res://Levels/GuitarHero/Ed-Sheeran-Perfect-Hard.mp3"
	},
}

const HEIGHT = 100
const MIN_DB = 60

@onready var audio_player = $AudioStreamPlayer
@onready var spectrum = AudioServer.get_bus_effect_instance(0, 0)

@onready var player = $"Player_Tamplate"
@onready var level_timer = $LevelTimer
@onready var bpm_timer = $BPMTimer

@onready var arrow_scene = preload("res://Nodes/Arrow.tscn")
@onready var arrow_positions = {
	"Up": $UpArrowPosition,
	"Left": $LeftArrowPosition,
	"Down": $DownArrowPosition,
	"Right": $RightArrowPosition
}

@onready var current_arrows = []
var settings

func _ready():
	start("normal")
	
func _process(_delta):
	#for direction in arrow_positions.keys():
	#	if Input.is_action_just_pressed(direction) and \
	#	   arrow_positions[direction].get_overlapping_bodies().has():
	pass

func add_arrow(direction, speed):
	var arrow = arrow_scene.instantiate()
	current_arrows.append(arrow)
	add_child(arrow)
	arrow.start(arrow_positions[direction].position,
				direction,
				Vector2.DOWN,
				speed)
				
func _on_bpm_timer_timeout():
	var freq_volumes = []
	var freq_jump = 100
	for hz in range(0, 1200, freq_jump):
		freq_volumes.append(hz_to_height(hz, hz + freq_jump))
	
	if freq_volumes.max() > 10:
		add_arrow(arrow_positions.keys().pick_random(), settings.speed)
	
func start(difficulty):
	settings = difficulties[difficulty]
	
	audio_player.stream = load(settings.song_path)
	bpm_timer.wait_time = audio_player.stream.get_bpm() / 60
	
	bpm_timer.start()
	audio_player.play()
		
	#level_timer.wait_time = settings.level_timer
	#level_timer.start()
	
	#AudioStreamPlayer
	#var song_file = FileAccess.open(song_file_path, FileAccess.READ)
	#var sound = AudioStreamMP3.new()
	#sound.data = song_file.get_buffer(song_file.get_length())
	#print(sound.data.slice(0, 100))

func hz_to_height(min_hz, max_hz) -> float:
	#var hz = i * FREQ_MAX / VU_COUNT;
	var magnitude = spectrum.get_magnitude_for_frequency_range(min_hz, max_hz).length()
	var height = clamp((MIN_DB + linear_to_db(magnitude)) / MIN_DB, 0, 1) * HEIGHT
	
	return height

func _on_pressing_bar_area_entered(area):
	area.is_on_target = true

func _on_pressing_bar_area_exited(area):
	area.is_on_target = false
	current_arrows[current_arrows.find(area)].queue_free()
	current_arrows.erase(area)
