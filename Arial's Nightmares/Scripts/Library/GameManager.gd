extends Node

var start_menu = "res://Levels/StartMenu/StartMenu.tscn"
var game_over_menu = "res://Levels/EndScreen/GameOverMenu.tscn"
var win_menu = "res://Levels/EndScreen/WinMenu.tscn"

var bullet_hell = "res://Levels/Bullet Hell/BullletHell.tscn"
var whackamole = "res://Levels/Whackamole/Whackamole.tscn"
var guitar_hero = "res://Levels/GuitarHero/GuitarHero.tscn"
var yam_level = "res://Levels/YAM/yam_level.tscn"

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
	#get_tree().paused = true
	var current_level = get_tree().get_current_scene()
	await fade_in(current_level.canvas_animation_player)

	if levels_left.is_empty():
		current_batch_index += 1
		copy_array(levels_left, levels[current_batch_index])
	
	var next_level_settings = levels_left.pick_random()
	levels_left.erase(next_level_settings)
	
	if next_level_settings.has("difficulty"):
		difficulty = next_level_settings.difficulty
	
	get_tree().change_scene_to_file(next_level_settings.scene)
	#get_tree().paused = false

func game_over():
	var current_level = get_tree().get_current_scene()
	fade_in(current_level.canvas_animation_player)
	
	restart_levels()
	
	get_tree().change_scene_to_file(game_over_menu)

func restart_levels():
	current_batch_index = 0
	copy_array(levels_left, levels[current_batch_index])
	
func copy_array(array, array_to_copy):
	array.clear()
	array.append_array(array_to_copy.duplicate(true))

func fade_in(animation_player):
	animation_player.play("FadeIn")
	await animation_player.animation_finished
	
func fade_out(animation_player):
	animation_player.play_backwards("FadeIn")
	await animation_player.animation_finished
