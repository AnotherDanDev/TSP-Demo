extends Node2D



@export var pointController: Node2D
@export var chrisPath : Node2D
@export var gui : Control
var points
var path 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func optimize_path(points: Array, path: Array) -> Array:
	var improved = true
	while improved:
		improved = false
		for i in range(1, path.size() - 2):
			for j in range(i + 1, path.size() - 1):
				var a = points[path[i - 1]]
				var b = points[path[i]]
				var c = points[path[j]]
				var d = points[path[j + 1]]

				var current_dist = a.distance_to(b) + c.distance_to(d)
				var swapped_dist = a.distance_to(c) + b.distance_to(d)

				if swapped_dist < current_dist:
					var reversed_segment = []
					for k in range(j, i - 1, -1): 
						reversed_segment.append(path[k])
					path = path.slice(0, i) + reversed_segment + path.slice(j + 1, path.size())
					improved = true
	return path

func draw_path(path) -> void:
	$Line2D.clear_points()
	for h in path:
		$Line2D.add_point(points[h])

	# Optionally loop back to the start
	$Line2D.add_point(points[path[0]])

	var pointNodes = pointController.find_child("Points").get_children()
	for p in range(0, len(pointNodes)):
		var lbl = pointNodes[p].find_child("Label")
		lbl.text = str(p)
		lbl.visible = true

func calculate_path_length(points: Array, path: Array) -> float:
	var total_length = 0.0
	for i in range(path.size() - 1):
		total_length += points[path[i]].distance_to(points[path[i + 1]])
	total_length += points[path[0]].distance_to(points[path.back()])
	return total_length


func button_pressed() -> void:
	points = pointController.points
	path = chrisPath.chrisPath
	var start_time = Time.get_ticks_usec()
	path = optimize_path(points, path)
	var end_time = Time.get_ticks_usec()
	var elapsed_time = end_time - start_time
	print("Optimized Path Length: ", calculate_path_length(points, path))
	gui.path_distance("optimize", calculate_path_length(points, path))
	gui.time_elapsed("optimize",elapsed_time)
	draw_path(path)
