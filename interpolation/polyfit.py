import numpy as np

def lagrange(xs, ys, max_deg=None):
	"""
	Fit (x, y) datapoints to max_deg polynomial using Lagrange interpolation:
	N = len(x)
	L(x) = sum_{i = 0:N}( y[i]*prod_{j = 0:N; j != i}( (x - x[j])/(x[i] - x[j]) ) )
	"""
	
	# Compute interpolated polynomial coefficients
	N = len(xs)
	lagrange_coeffs = np.array(ys)*np.ones(N) # ith coeff for prod(x - x_j; j != i) term
	for i in range(N):
		xi = xs[i]
		prod = 1
		for j in range(N):
			if i == j: continue
			prod *=  1 / (xi - xs[j]) 
		lagrange_coeffs[i] *= prod

	# Evaluate interpolated polynomial
	def L(x):
		res = 0
		for i in range(N):
			res += lagrange_coeffs[i] * np.prod([x - xs[j] for j in range(N) if i != j])
		return res
	
	return L

def hermite(xs, ys, yprimes):
	# TODO
	pass
