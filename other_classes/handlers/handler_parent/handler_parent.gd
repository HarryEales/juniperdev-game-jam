extends Node
class_name HandlerParent

var _handler_dict : Dictionary[String, BaseHandler]

func _ready() -> void:
	_handler_dict.clear()
	
	for node : Node in get_children():
		var handler : BaseHandler = node as BaseHandler
		if handler:
			_handler_dict[handler.name] = handler
