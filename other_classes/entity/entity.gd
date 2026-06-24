@abstract
extends Node
class_name Entity

enum ENTITY_TYPE { NONE, PLAYER, DOG, HUMAN }

@export var _entity_type : ENTITY_TYPE

@export_subgroup("CharacterBody")
@export var _has_character_body : bool
@export var _does_move : bool 

var _character_body : CharacterBody2D

@onready var _handler_parent : HandlerParent = get_node_or_null("HandlerParent")
@onready var _state_machine : StateMachine = get_node_or_null("StateMachine")
 
func _ready() -> void:
	if _has_character_body: 
		_character_body = self as Node as CharacterBody2D

func _physics_process(delta: float) -> void:
	if _character_body and _does_move:
		_character_body.move_and_slide()
