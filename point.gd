extends Node2D

@onready var animationPlayer = $Circle/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animationPlayer.play("expand_in")
