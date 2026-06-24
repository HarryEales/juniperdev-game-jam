extends Node2D
class_name HandHandler


@export var best_min_speed : float = 100.0
@export var best_max_speed : float = 150.0

@export var half_min_speed : float = 75.0
@export var half_max_speed : float = 175.0

@export var quarter_min_speed : float = 50.0
@export var quarter_max_speed : float = 200.0

@export var score_needed : float = 16.0

var _current_score : float = 0
var _visual_tweening_score : float = 0

var _minigame_is_going : bool

var _position_should_face : Vector2
var _normalised_should_face : Vector2

var _last_rotation : float = 0.0
var _last_hand_position : Vector2

var _distance_this_frame : float = 0.0
var _distance_this_second : float = 0.0


@onready var _minigame_ui_text : RichTextLabel = get_parent().get_node("Control").get_node("RichTextLabel")
@onready var _minigame_ui_progress_bar : TextureProgressBar = get_parent().get_node("Control").get_node("ProgressBar")

@onready var _hand_sprite : Sprite2D = $HandSprite
@onready var _measurement_timer : Timer = $MeasurementTimer


func _ready() -> void:
	_minigame_is_going = true
	
	# UI
	_minigame_ui_progress_bar.max_value = score_needed
	_minigame_ui_progress_bar.value = 0
	_minigame_ui_text.text = ""
	
	_measurement_timer.timeout.connect(_timer_timed_out)

func _process(delta: float) -> void:
	pass
	#if _visual_tweening_score < _current_score:
	#	_visual_tweening_score += 0.03125
	#	_minigame_ui_progress_bar.value = _visual_tweening_score
	#	print("visual score: " + str(_visual_tweening_score) + ". current score: " + str(_current_score))

func _physics_process(delta: float) -> void:
	if _minigame_is_going:
		_minigame_logic()


func _minigame_logic() -> void:
	if Input.is_action_pressed("mouse_down"):
		_rotate_hand()

func _rotate_hand() -> void:
	# Calculate mouse position from center
	_position_should_face = get_global_mouse_position()
	_normalised_should_face = _position_should_face - global_position
	
	# Set rotation of Hand and Sprite
	rotation = _normalised_should_face.angle()
	_hand_sprite.rotation = -(_normalised_should_face.angle())
	
	# Calculate the distance vars
	_distance_this_frame = _hand_sprite.global_position.distance_to(_last_hand_position)
	_distance_this_second += _distance_this_frame
	
	# Set all last frame values
	_last_hand_position = _hand_sprite.global_position
	_last_rotation = rotation

# This will go off every second
func _timer_timed_out() -> void:
	if ! _minigame_is_going:
		return
	
	#print(str(_distance_this_second))
	
	# Update UI Slower/Faster/Perfect text
	if _distance_this_second >= best_min_speed and _distance_this_second <= best_max_speed:
		_minigame_ui_text.text = "Best"
		_current_score += 1
		_minigame_ui_progress_bar.value = _current_score
	elif _distance_this_second >= half_min_speed and _distance_this_second <= half_max_speed:
		_minigame_ui_text.text = "Half"
		_current_score += 0.5
		_minigame_ui_progress_bar.value = _current_score
	elif _distance_this_second >= quarter_min_speed and _distance_this_second <= quarter_max_speed:
		_minigame_ui_text.text = "Quarter"
		_current_score += 0.25
		_minigame_ui_progress_bar.value = _current_score
	else:
		_minigame_ui_text.text = "Bad"
	
	if _current_score >= score_needed:
			print("game is over")
			_minigame_is_going = false
			_minigame_ui_text.text = "Dog Captured!"
	
	_distance_this_second = 0.0
