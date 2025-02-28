extends Node
class_name State

var _is_active: bool = false

func enter():
	_is_active = true

func exit():
	_is_active = false
