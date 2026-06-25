extends Entity
class_name BaseDog


var _game_manager : GameManager 

var _dog_area : Area2D

@onready var _parent : Node2D = get_parent()


func _ready() -> void:
	await _parent.ready
	
	_game_manager = GameManager.instance
	_dog_area = _game_manager._dog_area
	
	super._ready()
