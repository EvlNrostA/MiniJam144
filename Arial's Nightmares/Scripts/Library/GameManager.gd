extends Node2D

const DEFAULT_WINDOW_SIZE = Vector2i(1152, 648)

var start_menu = "res://Nodes/Menu/StartMenu.tscn"
var game_over_menu = "res://Nodes/Menu/GameOverMenu.tscn"
var win_menu = "res://Nodes/Menu/WinMenu.tscn"

var bullet_hell = "res://Levels/BulletHell/BulletHell.tscn"
var whackamole = "res://Levels/Whackamole/Whackamole.tscn"
var guitar_hero = "res://Levels/GuitarHero/GuitarHero.tscn"
var endless_runner = "res://Levels/EndlessRunner/EndlessRunner.tscn"
var heist = "res://Levels/Heist/Heist.tscn"
var nir_level = "res://Levels/nirodef/nir_level.tscn"

# joystick is for nir & heist level
var arrows_wasd_tooltip = "res://Nodes/Mechanics/TemplateTooltip.tscn" #"res://Nodes/Tooltips/ArrowsWASDTooltip.tscn"
var joystick_tooltip = "res://Nodes/Mechanics/TemplateTooltip.tscn" #"res://Nodes/Tooltips/JoystickTooltip.tscn"
var guitar_hero_mobile_tooltip = "res://Nodes/Mechanics/TemplateTooltip.tscn" #"res://Nodes/Tooltips/GuitarHeroTooltip.tscn"
var endless_runner_mobile_tooltip = "res://Nodes/Mechanics/TemplateTooltip.tscn" #"res://Nodes/Tooltips/EndlessRunnerTooltip.tscn"

var difficulties = {
	"easy": 0,
	"normal": 1, 
	"hard": 2
}

var levels = [
	[
		{
		"scene": bullet_hell,
		"difficulty": "easy",
		"desktop_tooltip": arrows_wasd_tooltip,
		"mobile_tooltip": joystick_tooltip
		},
		{
		"scene": whackamole,
		"difficulty": "easy",
		"desktop_tooltip": arrows_wasd_tooltip,
		"mobile_tooltip": joystick_tooltip
		},
		{
		"scene": guitar_hero,
		"difficulty": "easy",
		"custom_music": true,
		"desktop_tooltip": arrows_wasd_tooltip,
		"mobile_tooltip": guitar_hero_mobile_tooltip
		},
		{
		"scene": endless_runner,
		"difficulty": "easy",
		"desktop_tooltip": arrows_wasd_tooltip,
		"mobile_tooltip": endless_runner_mobile_tooltip
		},
		{
		"scene": heist,
		"difficulty": "easy",
		"desktop_tooltip": arrows_wasd_tooltip,
		"mobile_tooltip": joystick_tooltip
		},
		{
		"scene": nir_level,
		"difficulty": "easy",
		"desktop_tooltip": arrows_wasd_tooltip,
		"mobile_tooltip": joystick_tooltip
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
		"scene": endless_runner,
		"difficulty": "normal"
		},
		{
		"scene": heist,
		"difficulty": "normal",
		},
		{
		"scene": nir_level,
		"difficulty": "normal",
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
		"scene": endless_runner,
		"difficulty": "hard"
		},
		{
		"scene": heist,
		"difficulty": "hard",
		},
		{
		"scene": nir_level,
		"difficulty": "hard",
		}
	],
	[
		{
		"scene": win_menu,
		"custom_music": true,
		"playing": false
		}
	]
]

var is_mobile = OS.has_feature("mobile") or \
				OS.has_feature("web_android") or \
				OS.has_feature("web_ios")

var playing : bool = false
var current_batch_index : int = 0
var levels_left : Array
var difficulty
var level_settings

# DEBUGGING FUNCTION
func start_level(selected_difficulty):
	playing = true
	
	UI.points_set(0)
	UI.visible = true
	
	copy_array(levels_left, levels[difficulties[selected_difficulty]])
	var scene_path = get_tree().get_current_scene().scene_file_path
	level_settings = levels_left.filter(func(settings): return settings.scene == scene_path)[0]
	
	prepare_level()
	show_mobile()

func start():
	if not Fade.fading():
		playing = true
		
		UI.points_set(0)
		next_level()

func prepare_level():
	randomize()
	
	levels_left.erase(level_settings)
	
	if level_settings.has("difficulty"):
		difficulty = level_settings.difficulty
	
	if Audio.stream != Audio.level_music and not level_settings.has("custom_music"):
		Audio.play_music(Audio.level_music)
		
	if level_settings.has("playing"):
		playing = level_settings.playing
	
func show_tooltip():
	var tooltip_setting = "mobile_tooltip" if is_mobile else "desktop_tooltip"
	if level_settings.has(tooltip_setting):
		await UI.show_tooltip(level_settings[tooltip_setting])
	
func next_level():
	if levels_left.is_empty():
		current_batch_index += 1
		copy_array(levels_left, levels[current_batch_index])
	
	level_settings = levels_left.pick_random()
	
	prepare_level()
	change_scene(level_settings.scene)
	
func show_mobile():
	#GManager.is_mobile = true
	var mobile_nodes = get_tree().get_nodes_in_group("Mobile")
	for node in mobile_nodes:
		node.visible = is_mobile

func game_over():
	playing = false
	change_scene(game_over_menu)
	
func change_scene(scene):
	UI.level_timer.stop()
	
	await Fade.fade_in()
	get_tree().change_scene_to_file(scene)
	
	UI.visible = playing
	show_mobile()
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

func tween_and_wait(object, property, final_val, duration, timer):
	var tween = create_tween()
	tween.tween_property(object, property, final_val, duration)
	
	timer.start(duration)
	await timer.timeout
