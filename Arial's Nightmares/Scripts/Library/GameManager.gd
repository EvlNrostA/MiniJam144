extends Node

#var start_menu = "res://Levels/StartMenu/StartMenu.tscn"
var start_menu = "res://Levels/StartMenu/StartMenu.tscn"
var bullet_hell = "res://Levels/Bullet Hell/BullletHell.tscn"
var whackamole = "res://Levels/Whackamole/Whackamole.tscn"
var guitar_hero = "res://Levels/GuitarHero/GuitarHero.tscn"
var yam_level = "res://Levels/YAM/yam_level.tscn"

var difficulties = ["easy", "normal", "hard"]

var levels = [
	[
		{
		"scene": start_menu,
		}
	],
	# First cutscene
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
		"scene": start_menu,
		}
	]
	# Final cutscene
]

var levels_left : Array
var current_batch_index : int
var difficulty

func next_level():
	var current_level = get_tree().get_current_scene()
	await fade_in(current_level.canvas_animation_player)

	if levels_left.size() == 0:
		current_batch_index += 1
		levels_left = levels[current_batch_index]
	
	var next_level_settings = levels_left.pick_random()
	levels_left.erase(next_level_settings)
	
	if next_level_settings.has("difficulty"):
		difficulty = next_level_settings.difficulty
	
	get_tree().change_scene_to_file(next_level_settings.scene)
	await get_tree().process_frame
	
	var next_level = get_tree().current_scene
	await fade_out(next_level.canvas_animation_player)

func game_over():
	var current_level = get_tree().get_current_scene()
	await fade_in(current_level.canvas_animation_player)
	
	get_tree().change_scene_to_file(start_menu)
	await get_tree().process_frame
	
	var next_level = get_tree().current_scene
	await fade_out(next_level.canvas_animation_player)
	
func fade_in(animation_player):
	animation_player.play("FadeIn")
	await animation_player.animation_finished
	
func fade_out(animation_player):
	animation_player.play_backwards("FadeIn")
	await animation_player.animation_finished
