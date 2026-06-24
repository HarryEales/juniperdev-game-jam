extends State
class_name BaseDogRegularState


enum CURRENT_ACTION { WALK, IDLE }

@export var min_max_walk_time : Vector2 = Vector2(0.7, 1.7)
@export var min_max_walk_intervals : Vector2i = Vector2i(3, 5)
@export var min_max_idle_time : Vector2 = Vector2(2.0, 5.5)

var _current_action : CURRENT_ACTION 

var _root_entity : Entity
var _movement_handler : MovementHandler

var _random_direction_array : Array[Vector2] = [
	Vector2(1, 0),
	Vector2(1, 0.5),
	Vector2(1, 1),
	Vector2(0.5, 1),
	Vector2(0, 1),
	Vector2(-0.5, 1),
	Vector2(-1, 1),
	Vector2(-1, 0.5),
	Vector2(-1, 0),
	Vector2(-1, -0.5),
	Vector2(-1, -1),
	Vector2(-0.5, -1),
	Vector2(0, -1),
	Vector2(0.5, -1),
	Vector2(1, -1),
	Vector2(1, -0.5)
]

var _current_random_direction : int = 0

var _current_walk_interval : int = 1
var _current_total_walk_interval : int = 3

@onready var _movement_timer : Timer = $MovementTimer


func _enter() -> void:
	_root_entity = _state_machine._root_entity
	await _root_entity.ready
	_movement_handler = _root_entity._handler_parent._handler_dict["MovementHandler"]
	
	_current_action = CURRENT_ACTION.WALK
	_current_random_direction = randi_range(0, _random_direction_array.size() - 1)
	_movement_timer.wait_time = randf_range(min_max_walk_time.x, min_max_walk_time.y)
	_current_walk_interval = 1
	_current_total_walk_interval = randi_range(min_max_walk_intervals.x, min_max_walk_intervals.y)
	
	_movement_timer.timeout.connect(timer_done)
	_movement_timer.start()

func _update(delta : float) -> void:
	if _current_action == CURRENT_ACTION.WALK:
		_movement_handler.move(delta, _random_direction_array[_current_random_direction])
	else:
		_movement_handler.move(delta, Vector2.ZERO)


func timer_done() -> void:
	if _current_action == CURRENT_ACTION.WALK and _current_walk_interval >= _current_total_walk_interval:
		_current_action = CURRENT_ACTION.IDLE
		_movement_timer.wait_time = randf_range(min_max_idle_time.x, min_max_idle_time.y)
		_movement_timer.start()
	elif _current_action == CURRENT_ACTION.WALK and _current_walk_interval < _current_total_walk_interval:
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
	else:
		_current_action = CURRENT_ACTION.WALK
		_current_random_direction = randi_range(0, _random_direction_array.size() - 1)
		_movement_timer.wait_time = randf_range(min_max_walk_time.x, min_max_walk_time.y)
		_current_walk_interval = 1
		_current_total_walk_interval = randi_range(min_max_walk_intervals.x, min_max_walk_intervals.y)
		print(_random_direction_array[_current_random_direction])
		_movement_timer.start()
