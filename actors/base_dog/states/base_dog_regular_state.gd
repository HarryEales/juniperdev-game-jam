extends State
class_name BaseDogRegularState


enum CURRENT_ACTION { WALK, IDLE, FIXING_POSITION }

@export var min_max_walk_time : Vector2 = Vector2(0.7, 1.7)
@export var min_max_walk_intervals : Vector2i = Vector2i(3, 5)
@export var min_max_idle_time : Vector2 = Vector2(2.0, 5.5)

var _current_action : CURRENT_ACTION 

var _root_entity : Entity
var _root_node_2d : Node2D
var _movement_handler : MovementHandler

var _random_direction_array : Array[Vector2] = [
	#Vector2(1, 0),
	#Vector2(1, 0.5),
	#Vector2(1, 1),
	#Vector2(0.5, 1),
	Vector2(0, 1),
	#Vector2(-0.5, 1),
	#Vector2(-1, 1),
	#Vector2(-1, 0.5),
	#Vector2(-1, 0),
	#Vector2(-1, -0.5),
	#Vector2(-1, -1),
	#Vector2(-0.5, -1),
	#Vector2(0, -1),
	#Vector2(0.5, -1),
	#Vector2(1, -1),
	#Vector2(1, -0.5)
]

var _current_random_direction : int = 0

var _current_walk_interval : int = 1
var _current_total_walk_interval : int = 3

var _dog_area : Area2D

@onready var _movement_timer : Timer = $MovementTimer


func _enter() -> void:
	_root_entity = _state_machine._root_entity
	_root_node_2d = _root_entity as Node as Node2D
	await _root_entity.ready
	_movement_handler = _root_entity._handler_parent._handler_dict["MovementHandler"]
	
	var base_dog : BaseDog = _root_entity as BaseDog
	_dog_area = base_dog._dog_area
	
	if not _dog_area:
		print("ayo theres no dog area")
	else:
		print("oi bruv theres a dog area")
	
	_switch_to_walking()
	_movement_timer.timeout.connect(timer_done)

func _update(delta : float) -> void:
	if not _dog_area:
		_dog_area = GameManager.instance._dog_area
	
	if _current_action == CURRENT_ACTION.WALK:
		_movement_handler.move(delta, _random_direction_array[_current_random_direction])
	elif _current_action == CURRENT_ACTION.IDLE:
		_movement_handler.move(delta, Vector2.ZERO)
	else: 
		_movement_handler.move(delta, _root_node_2d.global_position.direction_to(_dog_area.global_position))


func timer_done() -> void:
	if _current_action == CURRENT_ACTION.FIXING_POSITION:
		return
	
	if _current_action == CURRENT_ACTION.WALK and _current_walk_interval >= _current_total_walk_interval:
		# Was walking, and should be idle
		_switch_to_idle()
	elif _current_action == CURRENT_ACTION.WALK and _current_walk_interval < _current_total_walk_interval:
		# Was walking, but isn't finished walking
		_update_walking_interval()
	else: 
		# Was idle, and should be walking
		_switch_to_walking()

func needs_to_fix_position() -> void:
	_current_action = CURRENT_ACTION.FIXING_POSITION

func has_fixed_position() -> void:
	_switch_to_idle()


func _switch_to_walking() -> void:
	_current_action = CURRENT_ACTION.WALK
	
	_current_random_direction = randi_range(0, _random_direction_array.size() - 1)
	_movement_timer.wait_time = randf_range(min_max_walk_time.x, min_max_walk_time.y)
	_current_total_walk_interval = randi_range(min_max_walk_intervals.x, min_max_walk_intervals.y)
	_current_walk_interval = 1
	
	print(_random_direction_array[_current_random_direction])
	_movement_timer.start()

func _update_walking_interval() -> void:
	var positive_or_negative : int = randi_range(1, 2)
	if positive_or_negative == 1:
		_current_random_direction -= 1
		if _current_random_direction < 0:
			_current_random_direction = _random_direction_array.size() - 1
	else:
		_current_random_direction += 1
		if _current_random_direction >= _random_direction_array.size():
			_current_random_direction = 0
	
	_movement_timer.wait_time = randf_range(min_max_walk_time.x, min_max_walk_time.y)
	_current_walk_interval += 1
	
	print(_random_direction_array[_current_random_direction])
	_movement_timer.start()

func _switch_to_idle() -> void:
	_current_action = CURRENT_ACTION.IDLE
	
	_movement_timer.wait_time = randf_range(min_max_idle_time.x, min_max_idle_time.y)
	_movement_timer.start()
