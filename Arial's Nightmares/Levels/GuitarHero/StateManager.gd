extends Node2D

var difficulty_settings = {
	"easy": {
		"speed": 100,
		"song_path": "res://Assets/Music/Ed-Sheeran-Perfect-Easy.mp3",
		"fail_count": 5,
		"scores": {
			"PERFECT": 1,
			"GREAT": 0,
			"OKAY": 0
		}
	},
	"normal": {
		"speed": 300,
		"song_path": "res://Assets/Music/Ed-Sheeran-Perfect-Normal.mp3",
		"fail_count": 5,
		"scores": {
			"PERFECT": 2,
			"GREAT": 1,
			"OKAY": 0
		}
	},
	"hard": {
		"speed": 400,
		"song_path": "res://Assets/Music/Ed-Sheeran-Perfect-Hard.mp3",
		"fail_count": 5,
		"scores": {
			"PERFECT": 2,
			"GREAT": 1,
			"OKAY": 0
		}
	},
}

const SCORE_TEXT_OPTIONS = {
	"PERFECT": {
		"text": "perfect",
		"colorhex": 0x08B6F7FF
	},
	"GREAT": {
		"text": "great",
		"colorhex": 0x27BF28FF
	},
	"OKAY": {
		"text": "okay",
		"colorhex": 0xEBBD14FF
	}
}

const GREAT_DISTANCE = 20
const PERFECT_DISTANCE = 10

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
@onready var pressing_bar = $PressingBar
@onready var heart_animation_player = $Heart/AnimationPlayer
@onready var heart_label = $Heart/Label

@onready var spectrum = AudioServer.get_bus_effect_instance(0, 0)
@onready var delay_timer = $DelayTimer
@onready var bpm_timer = $BPMTimer

@onready var floating_text_scene = preload("res://Nodes/Mechanics/FloatingText.tscn")
@onready var arrow_scene = preload("res://Nodes/Mechanics/Arrow.tscn")
@onready var arrow_positions = {
	"Up": $UpArrowPosition,
	"Left": $LeftArrowPosition,
	"Down": $DownArrowPosition,
	"Right": $RightArrowPosition
}
@onready var arrows_on_target = []

@onready var buttons = $Buttons

var settings
var arrow_time_delay
var beat_per_sec
var chunk_size
var fail_count : int

func _ready():
	if GManager.difficulty == null:
		GManager.start_level("easy")
	
	if not GManager.is_mobile:
		buttons.visible = false

	Audio.stop()
		
	settings = difficulty_settings[GManager.difficulty]
	fail_count = settings.fail_count
	heart_label.text = str(fail_count)
	
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
	heart_label.text = str(fail_count)

func add_arrow(direction):
	var arrow = arrow_scene.instantiate()
	
	arrow.position = arrow_positions[direction].position
	arrow.direction = direction
	arrow.velocity = Vector2.DOWN
	arrow.speed = settings.speed

	add_child(arrow)
	
func check_arrows(direction):
	if arrows_on_target.size() == 0:
		count_miss()
	
	for area in arrows_on_target:
		var correct_direction = direction == area.direction
		if not correct_direction or area.pressed:
			count_miss()
					
		if not area.pressed:
			var animation_name = "PressedRight" if correct_direction else "PressedWrong"
			area.animation_player.queue(animation_name)
			
			if correct_direction:
				score(area)
	
		area.pressed = true
		
func count_miss():
	fail_count -= 1
	
	player.play_sound(player.death_sound)
	heart_animation_player.play("Beat")
	
	if fail_count == 0:
		GManager.game_over()

func score(area):
	var area_size = area.sprite.get_rect().size.y
	var distance = pressing_bar.global_position.y - area.global_position.y 

	var scoring
	if distance > GREAT_DISTANCE or distance < 0:
		scoring = "OKAY"
	elif distance <= PERFECT_DISTANCE:
		scoring = "PERFECT"
	elif distance <= GREAT_DISTANCE:
		scoring = "GREAT"	
	
	var options = SCORE_TEXT_OPTIONS[scoring]
	var floating_text = floating_text_scene.instantiate()
	add_child(floating_text)
	
	var floating_text_position = Vector2(area.global_position.x, pressing_bar.global_position.y) + FLOATING_TEXT_OFFSET
	await floating_text.display(options.text,
								floating_text_position,
								FLOATING_TEXT_SIZE,
								Color.hex(options.colorhex))
	floating_text.queue_free()
	
	UI.points_add(settings.scores[scoring])
				
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
		count_miss()
	
	area.animation_player.queue("FadeOut")
	await area.animation_player.animation_finished
	
	area.queue_free()

func _on_level_timer_timeout():
	Audio.stop()
	GManager.next_level()
