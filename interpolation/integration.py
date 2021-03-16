import numpy as np

def trapezoid(f, a, b, N):
	res = 0

	# Compute values on interval nodes
	h = (b - a)/N # Subdivision width
	x_nodes = np.arange(a, b+h/2, h)
	y_nodes = f(x_nodes)

	# Compute integral with trapezoid rule
	for i in range(N):
		# Explicit averaging of y values in the ith interval
		# This is equivelent to computing the interpolated line
		res += h/2*(y_nodes[i] + y_nodes[i+1])

	return res

def simpson(f, a, b, N):
	res = 0

	# Compute values on interval nodes
	h = (b - a)/N # Subdivision width
	x_nodes = np.arange(a, b+h/2, h)
	y_nodes = f(x_nodes)

	# Compute integral with Simpon's rule
	i = 0
	while i < N:
		res += h/3*(y_nodes[i] + 4*y_nodes[i+1] + y_nodes[i+2])
		i += 2

	return res
