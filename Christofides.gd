extends Node2D

@export var pointController: Node2D
@export var nearestNeighbor: Node2D
@export var gui : Control
var points
var chrisPath
var graph:Array = []

func calculate_path():
	print("Points: ", points)
	generate_graph()
	if graph.size() == 0:
		print("Error: Graph generation failed!")
		return
	var mst = compute_mst(graph)
	var odd_vertices = find_odd_degree_vertices(mst, graph.size())
	var matching = minimum_weight_matching(odd_vertices, graph)
	var eulerian_graph = combine_mst_and_matching(mst, matching)
	var path = create_hamiltonian_path(eulerian_graph, 0)
	print("Initial Path Length: ", calculate_path_length(points, path))
	return path
	


func generate_graph():
	if points.size() == 0:
		print("Error: No points available to generate the graph!")
		return
	
	var n = points.size()
	graph = []
	for i in range(n):
		var row = []
		for j in range(n):
			if i == j:
				row.append(0)
			else:
				row.append(points[i].distance_to(points[j]))
		graph.append(row)
	if graph.size() != points.size() or not graph[0].size() == points.size():
		print("Error: Generated graph is not square!")
	print("Generated Graph: ", graph)

func compute_mst (graph:Array) -> Array:
	var n = graph.size()
	var mst = []
	var visted = Array()
	visted.resize(n)
	visted.fill(false)
	var edges = []

	visted[0] = true
	
	for i in range(n):
		if graph[0][i] > 0:
			var e = [0, i, graph[0][i]]
			edges.append(e)
			
	while len(mst) < n - 1:
		edges.sort_custom(func(a, b): return a[2] < b[2])
		var edge = edges.pop_front()
		
		var u = edge[0]
		var v = edge[1]
		var weight = edge[2]
		
		if visted[v]:
			continue
		mst.append(edge)
		visted[v] = true
		
		for i in range(n):
			if graph[v][i] > 0 and not visted[i]:
				edges.append([v, i, graph[v][i]])
	print("MST: ", mst)
	return mst

func find_odd_degree_vertices(mst:Array, n:int) -> Array:
	var degree = Array()
	degree.resize(n)
	degree.fill(0)
	
	for edge in mst:
		degree[edge[0]] += 1
		degree[edge[1]] += 1
		
	var odd_vertices = []
	for i in range(n):
		if degree[i] % 2 != 0:
			odd_vertices.append(i)
	print("Odd-Degree Vertices: ", odd_vertices)
	return odd_vertices
	
func minimum_weight_matching(odd_vertices: Array, graph: Array) -> Array:
	var matching = []
	while odd_vertices.size() > 1:
		var u = odd_vertices.pop_front()
		var best_v = null
		var best_weight = INF
		for v in odd_vertices:
			if graph[u][v] < best_weight:
				best_weight = graph[u][v]
				best_v = v
		odd_vertices.erase(best_v)
		matching.append([u,best_v,best_weight])
	print("Matching: ", matching)
	return matching

func combine_mst_and_matching(mst: Array, matching: Array) -> Array:
	var eulerian_graph = []
	var edge_set = {}

	for edge in mst:
		var u = edge[0]
		var v = edge[1]
		edge_set[Vector2(u, v)] = true
		eulerian_graph.append(edge)

	for edge in matching:
		var u = edge[0]
		var v = edge[1]
		if not edge_set.has(Vector2(u, v)) and not edge_set.has(Vector2(v, u)):
			eulerian_graph.append(edge)

	eulerian_graph.sort_custom(func(a, b): return a[2] < b[2])

	print("Eulerian Graph: ", eulerian_graph)
	return eulerian_graph

func create_hamiltonian_path(eulerian_graph: Array, start_node: int) -> Array:
	var adjacency = {}
	for edge in eulerian_graph:
		var u = edge[0]
		var v = edge[1]
		if u not in adjacency:
			adjacency[u] = []
		if v not in adjacency:
			adjacency[v] = []
		adjacency[u].append(v)
		adjacency[v].append(u)

	print("Adjacency List: ", adjacency)

	var visited = {}
	var path = []
	var stack = [start_node]

	while stack.size() > 0:
		var current_node = stack.pop_back()

		if current_node not in visited:
			visited[current_node] = true
			path.append(current_node)

		if current_node in adjacency:
			for neighbor in adjacency[current_node]:
				if neighbor not in visited:
					stack.append(neighbor)

	for node in adjacency:
		if node not in visited:
			print("Unvisited node found: ", node)
			path.append(node)

	print("Hamiltonian Path (optimized): ", path)
	print("Total Nodes in Path: ", len(path))
	print("Total Points: ", points.size())
	return path

func draw_path(path) -> void:
	$Line2D.clear_points()
	for p in path:
		$Line2D.add_point(points[p])

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
	var start_time = Time.get_ticks_usec()
	var path = calculate_path()
	var end_time = Time.get_ticks_usec()
	var elapsed_time = end_time - start_time
	gui.path_distance("christofides", calculate_path_length(points, path))
	gui.time_elapsed("christofides", elapsed_time)
	chrisPath = path
	draw_path(path)
	
