extends BaseHandler
class_name MovementHandler


@export var max_speed : float = 3000.0
@export var accel : float = 7000.0
@export var _friction : float = 3800.0

@onready var _root_cb : CharacterBody2D = _root as CharacterBody2D


func move(delta : float, direction : Vector2) -> void:
	if direction and direction != Vector2.ZERO:
		_root_cb.velocity += direction * accel * delta
		_root_cb.velocity = _root_cb.velocity.limit_length(max_speed)
	else:
		if _root_cb.velocity.length() > (_friction * delta):
			_root_cb.velocity -= _root_cb.velocity.normalized() * (_friction * delta)
		else:
			_root_cb.velocity = Vector2.ZERO

func constant_move(direction : Vector2) -> void:
	if direction and direction != Vector2.ZERO:
		_root_cb.velocity = direction * max_speed
		_root_cb.velocity = _root_cb.velocity.limit_length(max_speed)
	else:
		_root_cb.velocity = Vector2.ZERO

func stop_movement() -> void:
	_root_cb.velocity = Vector2.ZERO
