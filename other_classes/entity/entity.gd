@abstract
extends Node
class_name Entity

enum ENTITY_TYPE { NONE, PLAYER, DOG, HUMAN }

@export var _entity_type : ENTITY_TYPE

@onready var _handler_parent : HandlerParent = get_node_or_null("HandlerParent")
@onready var _state_machine : StateMachine = get_node_or_null("StateMachine")
 
