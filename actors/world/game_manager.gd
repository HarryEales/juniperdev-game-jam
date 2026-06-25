extends Node2D
class_name GameManager

static var instance : GameManager

@onready var _dog_area : Area2D = $DogArea


func _ready() -> void:
	if not instance:
		instance = self
	else:
		push_error("There is more than one GameManager instance")
