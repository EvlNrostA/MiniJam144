extends Node2D

var difficulty_settings = {
	"easy": {
		"speed": 1,
		"song_path": "res://Assets/Music/Ed-Sheeran-Perfect-Easy.mp3",
		"fail_count": 5
	},
	"normal": {
		"speed": 3,
		"song_path": "res://Assets/Music/Ed-Sheeran-Perfect-Normal.mp3",
		"fail_count": 5
	},
	"hard": {
		"speed": 4,
		"song_path": "res://Assets/Music/Ed-Sheeran-Perfect-Hard.mp3",
		"fail_count": 5
	},
}

const HEIGHT = 100
const MIN_DB = 60
const FREQ_DELTA = 100
const MAX_FREQ = 1200
const MIN_HEIGHT = 10

const ARROW_DELAY = 3
const MIN_TO_SEC = 60

#@onready var canvas = $CanvasLayer
@onready var player = $Player

@onready var spectrum = AudioServer.get_bus_effect_instance(0, 0)

@onready var delay_timer = $DelayTimer
@onready var bpm_timer = $BPMTimer
@onready var level_timer = $LevelTimer

@onready var pressing_bar = $PressingBar
@onready var heart_label = $HeartLabel

@onready var arrow_scene = preload("res://Nodes/Mechanics/Arrow.tscn")
@onready var arrow_positions = {
	"Up": $UpArrowPosition,
	"Left": $LeftArrowPosition,
	"Down": $DownArrowPosition,
	"Right": $RightArrowPosition
}
@onready var arrows_on_target = []
@onready var stopped = false
@onready var current_data = 0

var settings
var arrow_time_delay
var beat_per_sec
var chunk_size

func _ready():
	randomize()
	
	if GManager.difficulty == null:
		GManager.restart_levels()
		
	settings = difficulty_settings[GManager.difficulty]
	player.fail_count = settings.fail_count
	heart_label.text = str(player.fail_count)
	
	Audio.stream = load(settings.song_path)
	
	var audio_length = Audio.stream.get_length()
	level_timer.set_time(audio_length)
	
	beat_per_sec = Audio.stream.get_bpm() / MIN_TO_SEC
	var arrow_offset = beat_per_sec * ARROW_DELAY * settings.speed * 100
	for arrow in arrow_positions.values():
		arrow.position.y = pressing_bar.position.y - arrow_offset
		
	bpm_timer.start(beat_per_sec)
	
	var audio_delay = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
	arrow_time_delay = ARROW_DELAY + audio_delay
	delay_timer.start(arrow_time_delay)
	await delay_timer.timeout
	
	Audio.play()
	level_timer.start_timer(audio_length)

func _process(_delta):
	if player and player.fail_count >= 0:
		heart_label.text = str(player.fail_count)

func add_arrow(direction, speed):
	var arrow = arrow_scene.instantiate()
	add_child(arrow)
	arrow.start(arrow_positions[direction].position,
				direction,
				Vector2.DOWN,
				speed)
				
func _on_bpm_timer_timeout():
	var time_remaining = Audio.stream.get_length() - Audio.get_playback_position()
	
	if time_remaining > arrow_time_delay:
		add_arrow(arrow_positions.keys().pick_random(), settings.speed)
		
		bpm_timer.start(beat_per_sec)

func hz_to_height(min_hz, max_hz) -> float:
	var magnitude = spectrum.get_magnitude_for_frequency_range(min_hz, max_hz).length()
	var height = clamp((MIN_DB + linear_to_db(magnitude)) / MIN_DB, 0, 1) * HEIGHT
	
	return height

func _on_pressing_bar_area_entered(area):
	arrows_on_target.append(area)

func _on_pressing_bar_area_exited(area):
	arrows_on_target.erase(area)
	
	if not area.pressed:
		player.count_miss()
	
	area.animation_player.queue("FadeOut")
	await area.animation_player.animation_finished
	
	area.queue_free()
	
func lost_game():
	GManager.game_over()

func won_game():
	GManager.global_music = GManager.level_music
	GManager.next_level()
