extends Node
class_name StateMachine


signal changed_state

@export var _starting_state_name : String

var _state_dict : Dictionary[String, State]
var _current_state : State

@onready var _root : Node = get_parent()


func _ready() -> void:
	_state_dict.clear()
	
	# Get all child states
	for child : Node in get_children():
		var state : State = child as State
		if state:
			_state_dict[state.name] = state
	
	if _state_dict.is_empty():
		push_error(_root.name, " has no states underneath it's StateMachine. This may affect gameplay.")
	else:
		change_state(get_children()[0].name)

func _process(delta: float) -> void:
	if _current_state:
		_current_state._update(delta)

func _physics_process(delta: float) -> void:
	if _current_state:
		_current_state._physics_update(delta)


func change_state(state_name : String) -> void:
	if not _state_dict.has(state_name):
		push_error(_root.name + " doesn't have a state called: " + state_name)
		return
	
	if _current_state:
		_current_state._exit()
	
	_current_state = _state_dict[state_name]
	_current_state._enter()
	
	changed_state.emit()
