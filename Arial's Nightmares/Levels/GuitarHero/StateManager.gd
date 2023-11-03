extends Node2D

var difficulty_settings = {
	"easy": {
		"speed": 100,
		"song_path": "res://Assets/Music/Ed-Sheeran-Perfect-Easy.mp3",
		"fail_count": 5
	},
	"normal": {
		"speed": 300,
		"song_path": "res://Assets/Music/Ed-Sheeran-Perfect-Normal.mp3",
		"fail_count": 5
	},
	"hard": {
		"speed": 400,
		"song_path": "res://Assets/Music/Ed-Sheeran-Perfect-Hard.mp3",
		"fail_count": 5
	},
}

const SCORE_TEXT_OPTIONS = {
	"PERFECT": {
		"text": "perfect",
		"score": 2,
		"colorhex": 0x08B6F7FF
	},
	"GREAT": {
		"text": "great",
		"score": 1,
		"colorhex": 0x27BF28FF
	},
	"OKAY": {
		"text": "okay",
		"score": 0,
		"colorhex": 0xEBBD14FF
	}
}

const GREAT_DISTANCE = 15
const PERFECT_DISTANCE = 5

const FLOATING_TEXT_OFFSET = Vector2(5, -20)
const FLOATING_TEXT_SIZE = 32

const HEIGHT = 100
const MIN_DB = 60
const FREQ_DELTA = 100
const MAX_FREQ = 1200
const MIN_HEIGHT = 10

const ARROW_DELAY = 3
const MIN_TO_SEC = 60

@onready var player = $Player

@onready var spectrum = AudioServer.get_bus_effect_instance(0, 0)
@onready var delay_timer = $DelayTimer
@onready var bpm_timer = $BPMTimer

@onready var pressing_bar = $PressingBar
@onready var heart_label = $Heart/Label

@onready var arrow_scene = preload("res://Nodes/Mechanics/Arrow.tscn")
@onready var arrow_positions = {
	"Up": $UpArrowPosition,
	"Left": $LeftArrowPosition,
	"Down": $DownArrowPosition,
	"Right": $RightArrowPosition
}
@onready var floating_text_scene = preload("res://Nodes/Mechanics/FloatingText.tscn")
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
		GManager.start_level(GManager.difficulties.easy)
		
	settings = difficulty_settings[GManager.difficulty]
	player.fail_count = settings.fail_count
	heart_label.text = str(player.fail_count)
	
	Audio.stream = load(settings.song_path)
	
	var audio_length = Audio.stream.get_length()
	UI.set_time(audio_length)
	
	beat_per_sec = Audio.stream.get_bpm() / MIN_TO_SEC
	var arrow_offset = beat_per_sec * ARROW_DELAY * settings.speed
	for arrow in arrow_positions.values():
		arrow.position.y = pressing_bar.position.y - arrow_offset
		
	bpm_timer.start(beat_per_sec)
	
	var audio_delay = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
	arrow_time_delay = ARROW_DELAY + audio_delay
	delay_timer.start(arrow_time_delay)
	await delay_timer.timeout
	
	Audio.play()
	UI.start_timer(audio_length, _on_level_timer_timeout)

func _process(_delta):
	if player and player.fail_count >= 0:
		heart_label.text = str(player.fail_count)

func add_arrow(direction):
	var arrow = arrow_scene.instantiate()
	
	arrow.position = arrow_positions[direction].position
	arrow.direction = direction
	arrow.velocity = Vector2.DOWN
	arrow.speed = settings.speed

	add_child(arrow)
	
func score(area):
	var distance = abs(area.global_position.y - pressing_bar.global_position.y)
	var options
	
	if distance <= PERFECT_DISTANCE:
		options = SCORE_TEXT_OPTIONS.PERFECT
	elif distance <= GREAT_DISTANCE:
		options = SCORE_TEXT_OPTIONS.GREAT
	else:
		options = SCORE_TEXT_OPTIONS.OKAY
	
	var floating_text = floating_text_scene.instantiate()
	add_child(floating_text)
	
	var floating_text_position = Vector2(area.global_position.x, pressing_bar.global_position.y) + FLOATING_TEXT_OFFSET
	await floating_text.display(options.text,
									 floating_text_position,
									 FLOATING_TEXT_SIZE,
									 Color.hex(options.colorhex))
	floating_text.queue_free()
	
	UI.points_add(options.score)
				
func _on_bpm_timer_timeout():
	var time_remaining = Audio.stream.get_length() - Audio.get_playback_position()
	
	if time_remaining > arrow_time_delay:
		add_arrow(arrow_positions.keys().pick_random())
		
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

func _on_level_timer_timeout():
	Audio.stop()
	GManager.next_level()
