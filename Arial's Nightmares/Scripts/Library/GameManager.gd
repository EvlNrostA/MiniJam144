extends Node

var start_menu = "res://Levels/Menu/StartMenu.tscn"
var game_over_menu = "res://Levels/Menu/GameOverMenu.tscn"
var win_menu = "res://Levels/Menu/WinMenu.tscn"

var bullet_hell = "res://Levels/BulletHell/BulletHell.tscn"
var whackamole = "res://Levels/Whackamole/Whackamole.tscn"
var guitar_hero = "res://Levels/GuitarHero/GuitarHero.tscn"
var yam_level = "res://Levels/EndlessRunner/EndlessRunner.tscn"

var difficulties = ["easy", "normal", "hard"]

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
		"difficulty": "easy"
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
		"difficulty": "normal"
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
		"difficulty": "hard"
		},
		{
		"scene": yam_level,
		"difficulty": "hard"
		}
	],
	[
		{
		"scene": win_menu,
		}
	]
]

var current_batch_index : int = 0
var levels_left : Array
var difficulty

func next_level():
	#var current_level = get_tree().get_current_scene()
	await fade_in()

	if levels_left.is_empty():
		current_batch_index += 1
		copy_array(levels_left, levels[current_batch_index])
	
	var next_level_settings = levels_left.pick_random()
	levels_left.erase(next_level_settings)
	
	if next_level_settings.has("difficulty"):
		difficulty = next_level_settings.difficulty
	
	get_tree().change_scene_to_file(next_level_settings.scene)

func game_over():
	#var current_level = get_tree().get_current_scene()
	await fade_in()
	
	#restart_levels()
	get_tree().change_scene_to_file(game_over_menu)

func restart_levels():
	current_batch_index = 0
	copy_array(levels_left, levels[current_batch_index])
	
func copy_array(array, array_to_copy):
	array.clear()
	array.append_array(array_to_copy.duplicate(true))

func fade_in():
	Fade.shadow.visible = true
	Fade.animation_player.play("FadeIn")
	await Fade.animation_player.animation_finished
	Fade.shadow.visible = false
	
func fade_out():
	Fade.shadow.visible = true
	Fade.animation_player.play_backwards("FadeIn")
	await Fade.animation_player.animation_finished
	Fade.shadow.visible = false
