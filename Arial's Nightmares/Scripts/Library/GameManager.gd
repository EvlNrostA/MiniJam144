extends Node

const DEFAULT_WINDOW_SIZE = Vector2i(1152, 648)

var start_menu = "res://Nodes/Menu/StartMenu.tscn"
var game_over_menu = "res://Nodes/Menu/GameOverMenu.tscn"
var win_menu = "res://Nodes/Menu/WinMenu.tscn"

var bullet_hell = "res://Levels/BulletHell/BulletHell.tscn"
var whackamole = "res://Levels/Whackamole/Whackamole.tscn"
var guitar_hero = "res://Levels/GuitarHero/GuitarHero.tscn"
var yam_level = "res://Levels/EndlessRunner/EndlessRunner.tscn"

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
		}
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
		}
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
		}
	],
	[
		{
		"scene": win_menu,
		"custom_music": true
		}
	]
]

var current_batch_index : int = 0
var levels_left : Array
var difficulty
var global_music
var is_mobile = OS.has_feature("mobile") or \
				OS.has_feature("web_android") or \
				OS.has_feature("web_ios")

func start_level(selected_difficulty):
	UI.points_set(0)
	UI.visible = true
	
	copy_array(levels_left, levels[difficulties[selected_difficulty]])
	var scene_path = get_tree().get_current_scene().scene_file_path
	var level_settings = levels_left.filter(func(settings): return settings.scene == scene_path)[0]
	#GManager.is_mobile = true
	prepare_level(level_settings)

func prepare_level(level_settings):
	randomize()
	
	levels_left.erase(level_settings)
	
	if level_settings.has("difficulty"):
		difficulty = level_settings.difficulty
	
	if Audio.stream != Audio.level_music and not level_settings.has("custom_music"):
		Audio.play_music(Audio.level_music)
	
func next_level():
	if levels_left.is_empty():
		current_batch_index += 1
		copy_array(levels_left, levels[current_batch_index])
	
	var next_level_settings = levels_left.pick_random()
	
	prepare_level(next_level_settings)
	change_scene(next_level_settings.scene, true)

func game_over():
	change_scene(game_over_menu, false)
	
func change_scene(scene, is_level):
	UI.level_timer.stop()
	
	await Fade.fade_in()
	get_tree().change_scene_to_file(scene)
	
	UI.visible = is_level
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
	var window_size = DisplayServer.window_get_size()

	var default_gcd = gcd(DEFAULT_WINDOW_SIZE.x, DEFAULT_WINDOW_SIZE.y)
	var current_gcd = gcd(window_size.x, window_size.y)
	var shrunk_window_size = (window_size / current_gcd) * default_gcd
	
	var start_pos = (DEFAULT_WINDOW_SIZE - shrunk_window_size) / 2
	return Rect2(start_pos, start_pos + shrunk_window_size)

func gcd(a: int, b: int) -> int:
	return a if b == 0.0 else gcd(b, a % b)
