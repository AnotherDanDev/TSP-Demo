extends Node2D

@export var pointController: Node2D
@export var gui : Control
var points
var graph:Array = []
# Called when the node enters the scene tree for the first time.


func nearest_neighbor(points: Array, start: int) -> Array:
	var num_cities = points.size()
	var visited = []  # Track visited cities
	var path = []  # Track the order of visited cities
	var current_city = start
	var total_distance = 0.0

	# Initialize visited array with false
	for i in range(num_cities):
		visited.append(false)
	
	# Start at the initial city
	path.append(current_city)
	visited[current_city] = true

	# Visit all cities
	for i in range(num_cities - 1):
		var nearest_city = -1
		var min_distance = INF
		
		# Find the nearest unvisited city
		for next_city in range(num_cities):
			if not visited[next_city]:
				var distance = points[current_city].distance_to(points[next_city])
				if distance < min_distance:
					min_distance = distance
					nearest_city = next_city
		
		# Update path and distances
		if nearest_city != -1:
			path.append(nearest_city)
			total_distance += min_distance
			visited[nearest_city] = true
			current_city = nearest_city
	
	# Return to the starting city
	total_distance += points[current_city].distance_to(points[start])
	path.append(start)  # Add starting city to the end of the path

	return [path, total_distance]


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
	print("POINTS")
	print(path)
	var total_length = 0.0
	for i in range(path.size() - 1):
		total_length += points[path[0][i]].distance_to(points[path[0][i + 1]])
	total_length += points[path[0][0]].distance_to(points[path[0].back()])
	return total_length


func button_pressed() -> void:
	var start_city = 0  # Starting at the first point in the list
	points = pointController.points
	var start_time = Time.get_ticks_usec()
	print(start_time)
	var path = nearest_neighbor(points, start_city)
	var end_time = Time.get_ticks_usec()
	print(end_time)
	var elapsed_time = end_time - start_time
	var path_length = calculate_path_length(points,path)
	gui.path_distance("nearest",path[1])
	gui.time_elapsed("nearest",elapsed_time)
	print("Time elapsed: ", elapsed_time)
	draw_path(path[0])
	print("Path: ", path[0])  # Prints the order of visited points
	print("Total Distance: ", path[1])  # Prints the total distance of the path
