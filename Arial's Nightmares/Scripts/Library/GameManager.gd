extends Node

var menu_music = "res://Assets/Music/MenuMusic.mp3"
var level_music = "res://Assets/Music/LevelMusic.mp3"

var start_menu = "res://Levels/Menu/StartMenu.tscn"
var game_over_menu = "res://Levels/Menu/GameOverMenu.tscn"
var win_menu = "res://Levels/Menu/WinMenu.tscn"

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
		#"custom_music": true
		}
	]
]

var current_batch_index : int = 0
var levels_left : Array
var difficulty
var global_music
var points : int = 0

func start_level(index):
	UI.points_set(0)
	UI.visible = true
	
	copy_array(levels_left, levels[index])
	var scene_path = get_tree().get_current_scene().scene_file_path
	
	var level_settings = levels_left.filter(func(settings): return settings.scene == scene_path)[0]
	
	prepare_level(level_settings)

func prepare_level(level_settings):
	levels_left.erase(level_settings)
	
	if level_settings.has("difficulty"):
		difficulty = level_settings.difficulty
	
	if not (Audio.is_playing() or level_settings.has("custom_music")):
		play_global_music(level_music)
	
func next_level():
	randomize()
	
	if levels_left.is_empty():
		current_batch_index += 1
		copy_array(levels_left, levels[current_batch_index])
	
	var next_level_settings = levels_left.pick_random()
	prepare_level(next_level_settings)
	
	await change_scene(next_level_settings.scene, true)

func game_over():
	await change_scene(game_over_menu, false)
	
func restart_levels():
	current_batch_index = 0
	copy_array(levels_left, levels[current_batch_index])

func copy_array(array, array_to_copy):
	array.clear()
	array.append_array(array_to_copy.duplicate(true))
	
func change_scene(scene, is_level):
	UI.level_timer.stop()
	
	await fade_in()
	get_tree().change_scene_to_file(scene)
	
	UI.visible = is_level
	
	await fade_out()
	
func fade_in():
	Fade.shadow.visible = true
	Fade.animation_player.play("FadeIn")
	await Fade.animation_player.animation_finished
	
	get_tree().current_scene.queue_free()
	
func fade_out():
	Fade.animation_player.play_backwards("FadeIn")
	await Fade.animation_player.animation_finished
	Fade.shadow.visible = false
	
func randf_list_range(list_range) -> float:
	return randf_range(list_range[0], list_range[1])
	
func play_global_music(music):
	global_music = music
	Audio.stream = load(global_music)
	Audio.play()
