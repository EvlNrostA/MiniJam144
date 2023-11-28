extends Node2D

var difficulty_settings = {
	"easy": {
		"wait_time": 1.5,
		"level_timer": 20,
		"speed": 1.5,
		"clothes_speed": 1
	},	
	"normal": {
		"wait_time": 0.8,
		"level_timer": 30,
		"speed": 1.5,
		"clothes_speed": 2
	},
	"hard": {
		"wait_time": 0.5,
		"level_timer": 30,
		"speed": 1.5,
		"clothes_speed": 4
	}
}

const SCREEN_OFFSET = 50
const ITEM_POS_XRANGE = [152, 1000]
const ITEM_POS_YRANGE = [121, 553]

const COIN_WAIT_RANGE = [3, 5]
const COIN_POINTS = 5

@onready var player = $Player
@onready var joystick = $Joystick
@onready var bullet_timer = $BulletTimer
@onready var coin_timer = $CoinTimer

@onready var left_hand = $Environment/HandsLayer/LeftLayout/LeftHand
@onready var right_hand = $Environment/HandsLayer/RightLayout/RightHand

@onready var clothes_scene = preload("res://Nodes/Enemys/Clothes.tscn")
@onready var coin_scene = preload("res://Nodes/Mechanics/Coin.tscn")

var wait_time
var settings

var max_left
var max_top
var max_right
var max_bottom

func _ready():
	if GManager.difficulty == null:
		GManager.start_level("easy")
		
	if not GManager.is_mobile:
		joystick.visible = false
	
	settings = difficulty_settings[GManager.difficulty]
	wait_time = settings.wait_time
	player.speed = settings.speed
	
	var rect = GManager.get_shown_window_rect()

	max_left = rect.position.x - SCREEN_OFFSET
	max_top = rect.position.y - SCREEN_OFFSET
	max_right = rect.size.x + SCREEN_OFFSET
	max_bottom = rect.size.y + SCREEN_OFFSET
	
	UI.set_timer(settings.level_timer, _on_level_timer_timeout)
	
	await GManager.show_tooltip()
	
	bullet_timer.start(wait_time)
	UI.start_timer()
	start_coin_timer()
	
	right_hand.start("RightWave")
	left_hand.start("LeftWave")

func spawn_bullets() -> void:
	var bullet_directions = {
		Vector2.UP: Vector2(GManager.randf_list_range(ITEM_POS_XRANGE), max_bottom),
		Vector2.DOWN: Vector2(GManager.randf_list_range(ITEM_POS_XRANGE), max_top),
		Vector2.LEFT: Vector2(max_right, GManager.randf_list_range(ITEM_POS_YRANGE)),
		Vector2.RIGHT: Vector2(max_left, GManager.randf_list_range(ITEM_POS_YRANGE))
	}
	
	for direction in bullet_directions.keys():
		var bullet = clothes_scene.instantiate()
		add_child(bullet)
		
		bullet.z_index = 1
		bullet.emit_signal("SPAWN", direction, bullet_directions[direction], settings.clothes_speed)
	
	bullet_timer.start(wait_time)

func _on_level_timer_timeout():
	if not player.lost:
		GManager.next_level()

func start_coin_timer():
	coin_timer.start(GManager.randf_list_range(COIN_WAIT_RANGE))

func _on_coin_timer_timeout():
	var coin = coin_scene.instantiate()
	add_child(coin)
	
	coin.z_index = -1
	coin.points = COIN_POINTS
	coin.global_position = Vector2(GManager.randf_list_range(ITEM_POS_XRANGE), GManager.randf_list_range(ITEM_POS_YRANGE))
	
	start_coin_timer()
