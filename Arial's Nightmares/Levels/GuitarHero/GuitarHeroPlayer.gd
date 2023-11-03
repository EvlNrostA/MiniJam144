extends Player_library

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
const FLOATING_TEXT_SIZE = 16

@onready var manager = get_parent()
var fail_count : int

func _unhandled_key_input(event):	
	for direction in manager.arrow_positions.keys():
		if Input.is_action_just_pressed(direction):
			check_arrows(direction)

func check_arrows(direction):
	var arrows_on_target = manager.arrows_on_target
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

func score(area):
	var distance = abs(area.global_position.y - manager.pressing_bar.global_position.y)
	var options
	
	if distance <= PERFECT_DISTANCE:
		options = SCORE_TEXT_OPTIONS.PERFECT
	elif distance <= GREAT_DISTANCE:
		options = SCORE_TEXT_OPTIONS.GREAT
	else:
		options = SCORE_TEXT_OPTIONS.OKAY
	
	await area.floating_text.display(options.text,
									 FLOATING_TEXT_OFFSET,
									 FLOATING_TEXT_SIZE,
									 Color.hex(options.colorhex))
	
	UI.points_add(options.score)

func count_miss():
	fail_count -= 1
	
	if fail_count == 0:
		manager.lost_game()
