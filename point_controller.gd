extends Node2D

@export var generationArea:Area2D
@export var pointCount : int = 10
@export var min_distance : float = 30
@export var pointObject : PackedScene
var points = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func generate_points():
	var confirmedPoints = []
	var attempts = 0
	var maxAttempts = pointCount * 10
	
	while confirmedPoints.size() < pointCount and attempts < maxAttempts:
		var randomPoint = get_random_point()
		var valid = true
		for point in confirmedPoints:
			if randomPoint.distance_to(point) <  min_distance:
				valid = false
				break
				
		if valid:
			confirmedPoints.append(randomPoint)
	if confirmedPoints.size() < pointCount:
		print("Something fucked up")
	return confirmedPoints


func get_random_point() -> Vector2:
	var rect = get_area_bounds()
	var randomX = randf_range(rect.position.x, rect.position.x + rect.size.x)
	var randomY = randf_range(rect.position.y, rect.position.y + rect.size.y)
	return Vector2(randomX,randomY)

func get_area_bounds() -> Rect2:
	var collisionShape : CollisionShape2D = generationArea.get_child(0)
	if collisionShape.shape is RectangleShape2D:
		var rectSize = collisionShape.shape.size - Vector2(100,100)
		return Rect2(collisionShape.global_position - rectSize / 2, rectSize)
	return Rect2()


func _on_timer_timeout() -> void:
	print("Blah")
	points = []
	var children = $Points.get_children()
	if children.size() > 0:
		for c in children:
			c.queue_free()
		
	points = generate_points()
	print(points)
	for point in points:
		$PointTimer.start()
		var p = pointObject.instantiate()
		p.global_position = point
		await $PointTimer.timeout
		$Points.add_child(p)
