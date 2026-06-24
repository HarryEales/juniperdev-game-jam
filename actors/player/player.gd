extends Entity
class_name Player

static var instance : Player

func _ready() -> void:
	super._ready()
	
	if not instance:
		instance = self
	else:
		push_error("A player instance already exists")

#func _process(delta: float) -> void:
#	if Input.is_action_just_pressed("debug"):
#		_handler_parent._handler_dict["MovementHandler"].change_can_move(not _handler_parent._handler_dict["MovementHandler"]._can_move)
