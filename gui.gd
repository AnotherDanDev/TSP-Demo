extends Control

@export var pointController : Node2D
@export var nearestNeighbor : Node2D
@export var christofides : Node2D
@export var optimize : Node2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func hide_lines() -> void:
	nearestNeighbor.visible = false
	christofides.visible = false
	optimize.visible = false

func clear_path_labels() -> void:
	$PathLabels/nearestPath.text = ""
	$PathLabels/christofidesPath.text = ""
	$PathLabels/optimizedPath.text = ""

func clear_elapsed_time_labels() -> void:
	$ElapsedTime/nearestPath.text = ""
	$ElapsedTime/christofidesPath.text = ""
	$ElapsedTime/optimizedPath.text = ""

func _on_h_slider_value_changed(value: float) -> void:
	$Panel2/NumberOfPoints/PointNumber.text = str(value)
	pointController.pointCount = value
	var pointTimer : Timer = pointController.find_child("Timer")
	hide_lines()
	clear_path_labels()
	clear_elapsed_time_labels()
	pointTimer.start()
	


func _on_min_distance_value_changed(value: float) -> void:
	$Panel2/MinDistance/MinDistanceLbl.text = str(value)
	pointController.min_distance = value
	var pointTimer : Timer = pointController.find_child("Timer")
	hide_lines()
	clear_path_labels()
	clear_elapsed_time_labels()
	pointTimer.start()


func path_distance(source, distance) -> void:
	if source == "nearest":
		$PathLabels/nearestPath.text = str(round(distance * 100)/100)
	elif source == "christofides":
		$PathLabels/christofidesPath.text = str(round(distance * 100)/100)
	elif source == "optimize":
		$PathLabels/optimizedPath.text = str(round(distance * 100)/100)

func time_elapsed(source, time) -> void:
	if source == "nearest":
		$ElapsedTime/nearestPath.text = str(time)
	elif source == "christofides":
		$ElapsedTime/christofidesPath.text = str(time)
	elif source == "optimize":
		$ElapsedTime/optimizedPath.text = str(time)



func _on_nearest_neighbor_pressed() -> void:
	nearestNeighbor.visible = true
	nearestNeighbor.button_pressed()
	christofides.visible = false
	optimize.visible = false
	

func _on_calculate_pressed() -> void:
	nearestNeighbor.visible = false
	christofides.visible = true
	christofides.button_pressed()
	optimize.visible = false


func _on_optimize_pressed() -> void:
	nearestNeighbor.visible = false
	christofides.visible = false
	optimize.visible = true
	optimize.button_pressed()
