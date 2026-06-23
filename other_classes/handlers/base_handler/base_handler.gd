@abstract
extends Node
class_name BaseHandler

@onready var _root : Node = get_parent().get_parent()
@onready var _entity_root : Entity = _root as Entity
