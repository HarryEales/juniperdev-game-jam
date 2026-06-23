extends State
class_name PlayerRegularState


var _root_entity : Entity
var _movement_handler : MovementHandler


func _enter() -> void:
	_root_entity = _state_machine._root_entity
	await _root_entity.ready
	_movement_handler = _root_entity._handler_parent._handler_dict["MovementHandler"]

func _update(delta : float) -> void:
	var input : Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	_movement_handler.move(delta, input)
