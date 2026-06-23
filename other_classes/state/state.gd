@abstract
extends Node
class_name State

@onready var _state_machine : StateMachine = get_parent() as StateMachine

## Called when this state has just been assigned the current state
func _enter() -> void:
	pass

## Called for every _process() when this is the current state
func _update(delta : float) -> void:
	pass

## Called for every _physics_process() when this is the current state
func _physics_update(delta : float) -> void:
	pass

## Called when a new current state is chosen and this was the previous
func _exit() -> void:
	pass
