extends Area2D


func _on_body_entered(body : Node2D) -> void:
	print("body_entered")
	var entity : Entity = body as Node as Entity
	if not entity:
		return
	
	if not entity._entity_type == Entity.ENTITY_TYPE.DOG:
		return
	
	var regular_state : BaseDogRegularState = entity._state_machine._current_state as BaseDogRegularState
	if not regular_state:
		return
	
	regular_state.has_fixed_position()

func _on_body_exited(body : Node2D) -> void:
	print("body_exited")
	var entity : Entity = body as Node as Entity
	if not entity:
		return
	
	if not entity._entity_type == Entity.ENTITY_TYPE.DOG:
		return
	
	var regular_state : BaseDogRegularState = entity._state_machine._current_state as BaseDogRegularState
	if not regular_state:
		return
	
	regular_state.needs_to_fix_position()
