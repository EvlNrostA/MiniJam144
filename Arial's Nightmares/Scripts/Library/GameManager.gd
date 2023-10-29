extends Node

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
	print("next_level")

	if levels_left.size() == 0:
		current_batch_index += 1
		levels_left = levels[current_batch_index]
	
	var next_level = levels_left.pick_random()
	levels_left.erase(next_level)
	
	if next_level.has("difficulty"):
		difficulty = next_level.difficulty
	
	get_tree().change_scene_to_file(next_level.scene)

func game_over():
	print("game_over")
	get_tree().change_scene_to_file(start_menu)
	
	# Defeat scene?
	# Go to main screen
