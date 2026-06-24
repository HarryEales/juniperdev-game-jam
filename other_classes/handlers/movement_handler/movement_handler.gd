extends BaseHandler
class_name MovementHandler


enum FACING_DIRECTION { LEFT, RIGHT }

@export var max_speed : float = 1950.0
@export var accel : float = 5200.0
@export var friction : float = 5000.0

@export_subgroup("Animation Handling")
@export var _should_animate : bool
@export var _has_idle : bool
@export var _has_walk : bool

@export_subgroup("Flip Handling")
@export var _should_flip : bool

var _can_move : bool = true

var _animation_player : AnimationPlayer
var _sprite : Sprite2D

var _facing_direction : FACING_DIRECTION

@onready var _root_character_body : CharacterBody2D = _root as CharacterBody2D


func _ready() -> void:
	_can_move = true
	
	if _should_animate:
		_animation_player = _root_character_body.get_node("AnimationPlayer")
	
	if _should_flip:
		_sprite = _root_character_body.get_node("Sprite2D")
		_facing_direction = FACING_DIRECTION.LEFT


func move(delta : float, direction : Vector2) -> void:
	direction = direction.normalized()
	if direction and direction != Vector2.ZERO and _can_move:
		_root_character_body.velocity += direction * accel * delta
		_root_character_body.velocity = _root_character_body.velocity.limit_length(max_speed)
		
		if _should_animate and _has_walk:
			_animation_player.play("walk")
		
		if _should_flip:
			_check_should_flip(direction.x)
	else:
		if _root_character_body.velocity.length() > (friction * delta):
			_root_character_body.velocity -= _root_character_body.velocity.normalized() * (friction * delta)
			
			if _should_animate and _has_walk:
				_animation_player.play("walk")
		else:
			_root_character_body.velocity = Vector2.ZERO
			
			if _should_animate and _has_idle:
				_animation_player.play("idle")

func constant_move(direction : Vector2) -> void:
	direction = direction.normalized()
	if direction and direction != Vector2.ZERO and _can_move:
		_root_character_body.velocity = direction * max_speed
		_root_character_body.velocity = _root_character_body.velocity.limit_length(max_speed)
	else:
		_root_character_body.velocity = Vector2.ZERO

func stop_current_movement() -> void:
	_root_character_body.velocity = Vector2.ZERO

func change_can_move(can_move : bool) -> void:
	_can_move = can_move


func _check_should_flip(x_direction_moving : float) -> void:
	if x_direction_moving < 0:
		_facing_direction = FACING_DIRECTION.LEFT
		_sprite.flip_h = false
	elif x_direction_moving > 0:
		_facing_direction = FACING_DIRECTION.RIGHT
		_sprite.flip_h = true
