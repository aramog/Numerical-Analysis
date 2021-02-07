def fixed_point_iterator(f, p_0, tol = 1e-2, max_iters = 1000):
	"""
	Solves the fixed point problem f(p) = p with accuracy given by tol.
	"""
	p = p_0
	i = 0
	# Will loop till a break condition or max iters
	while i < max_iters:
		# Compute f(p). Break and return p if |f(p) - p| < tol
		if abs(f(p) - p) < tol: break
		# Otherwise set p = f(p) and tick the iterator
		p = f(p)
		i+=1
	return p

if __name__ == "__main__":
	def f(x):
		return (x+1)**(1/3)
	fp = fixed_point_iterator(f, 1, 1e-3)
	print("Computed fixed point: {}".format(fp))
	print("x = {}: x^3 - x - 1 = {}".format(fp, fp**3 - fp - 1))


