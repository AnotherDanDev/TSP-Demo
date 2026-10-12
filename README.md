A Godot 4.3 app that visualizes and compares approaches to the Traveling Salesman Problem. It scatters random points on the screen, and you can adjust the number of points and the minimum spacing between them. Then you draw a tour through them with one of three methods:

Nearest Neighbor: starts at point 0 and always moves to the closest unvisited point.
Christofides-inspired: builds a minimum spanning tree, pairs up its odd-degree vertices and walks the combined graph into a tour. It's a simplified version of Christofides that pairs the vertices greedily, so it doesn't carry the algorithm's 1.5× guarantee.
Optimize: improves the Christofides tour with 2-opt, reversing segments whenever that shortens the tour. Run Christofides first.

The panel shows each tour's length and how long its algorithm took in microseconds, so you can compare speed against quality.

To run it, open the folder in Godot 4.3 and press Play.

This was for a class back in 2024, I don't remember the exact class. 
