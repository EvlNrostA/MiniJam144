extends Node2D

const DEFAULT_WINDOW_SIZE = Vector2i(1152, 648)

var start_menu = "res://Nodes/Menu/StartMenu.tscn"
var game_over_menu = "res://Nodes/Menu/GameOverMenu.tscn"
var win_menu = "res://Nodes/Menu/WinMenu.tscn"

var bullet_hell = "res://Levels/BulletHell/BulletHell.tscn"
var whackamole = "res://Levels/Whackamole/Whackamole.tscn"
var guitar_hero = "res://Levels/GuitarHero/GuitarHero.tscn"
var yam_level = "res://Levels/EndlessRunner/EndlessRunner.tscn"
var nir_level = "res://Levels/nirodef/nir_level.tscn"

var difficulties = {
	"easy": 0,
	"normal": 1, 
	"hard": 2
}

var levels = [
	[
		{
		"scene": bullet_hell,
		"difficulty": "easy"
		},
		{
		"scene": whackamole,
		"difficulty": "easy"
		},
		{
		"scene": guitar_hero,
		"difficulty": "easy",
		"custom_music": true
		},
		{
		"scene": yam_level,
		"difficulty": "easy"
		},
		#{
		#"scene": nir_level,
		#"difficulty": "easy"
		#}
	],
	[
		{
		"scene": bullet_hell,
		"difficulty": "normal"
		},
		{
		"scene": whackamole,
		"difficulty": "normal"
		},
		{
		"scene": guitar_hero,
		"difficulty": "normal",
		"custom_music": true
		},
		{
		"scene": yam_level,
		"difficulty": "normal"
		},
		#{
		#"scene": nir_level,
		#"difficulty": "normal"
		#}
	],
	[
		{
		"scene": bullet_hell,
		"difficulty": "hard"
		},
		{
		"scene": whackamole,
		"difficulty": "hard"
		},
		{
		"scene": guitar_hero,
		"difficulty": "hard",
		"custom_music": true
		},
		{
		"scene": yam_level,
		"difficulty": "hard"
		},
		#{
		#"scene": nir_level,
		#"difficulty": "hard"
		#}
	],
	[
		{
		"scene": win_menu,
		"custom_music": true,
		"playing": false
		}
	]
]

var playing : bool = false
var current_batch_index : int = 0
var levels_left : Array
var difficulty
var is_mobile = OS.has_feature("mobile") or \
				OS.has_feature("web_android") or \
				OS.has_feature("web_ios")

# DEBUGGING FUNCTION
func start_level(selected_difficulty):
	UI.points_set(0)
	UI.visible = true
	
	copy_array(levels_left, levels[difficulties[selected_difficulty]])
	var scene_path = get_tree().get_current_scene().scene_file_path
	var level_settings = levels_left.filter(func(settings): return settings.scene == scene_path)[0]
	
	prepare_level(level_settings)

func start():
	playing = true
	UI.points_set(0)
	
	next_level()

func prepare_level(level_settings):
	GManager.is_mobile = true
	randomize()
	
	levels_left.erase(level_settings)
	
	if level_settings.has("difficulty"):
		difficulty = level_settings.difficulty
	
	if Audio.stream != Audio.level_music and not level_settings.has("custom_music"):
		Audio.play_music(Audio.level_music)
		
	if level_settings.has("playing"):
		playing = level_settings.playing
	
func next_level():
	if levels_left.is_empty():
		current_batch_index += 1
		copy_array(levels_left, levels[current_batch_index])
	
	var next_level_settings = levels_left.pick_random()
	
	prepare_level(next_level_settings)
	change_scene(next_level_settings.scene)

func game_over():
	playing = false
	change_scene(game_over_menu)
	
func change_scene(scene):
	UI.level_timer.stop()
	
	await Fade.fade_in()
	get_tree().change_scene_to_file(scene)
	
	UI.visible = playing
	await Fade.fade_out()
	
func restart_levels():
	current_batch_index = 0
	copy_array(levels_left, levels[current_batch_index])
	
func copy_array(array, array_to_copy):
	array.clear()
	array.append_array(array_to_copy.duplicate(true))
	
func randf_list_range(list_range) -> float:
	return randf_range(list_range[0], list_range[1])

func add_input(action, pressed):
	var input = InputEventAction.new()
	input.action = action
	input.pressed = pressed
	Input.parse_input_event(input)
	
func get_shown_window_rect() -> Rect2:
	var expansion = (Vector2i(get_viewport_rect().size) - DEFAULT_WINDOW_SIZE) / 2
	var shown_window_rect = Rect2(-expansion, DEFAULT_WINDOW_SIZE + expansion)
	
	return shown_window_rect

func gcd(a: int, b: int) -> int:
	return a if b == 0.0 else gcd(b, a % b)
	
func vibrate():
	Input.start_joy_vibration(1, 0.2, 0.2, 0.2)
	Input.vibrate_handheld(40)
