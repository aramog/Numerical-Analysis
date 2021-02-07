def newton(f, fprime, p_0, tol = 1e-5, max_iters = 1000, verbose = False):
	"""
	Use Newton's method to find a root of f within tolerance.
	fprime is the derivate function of f.
	p_0 is the starting point of the algo.
	"""
	i = 0
	while i < max_iters:
		# Compute next iteration
		p = p_0 - f(p_0)/fprime(p_0)
		# Check stopping condition
		if verbose:
			print("Iteration {}: p={}, absolute error = {}".format(i, p, abs(p-p_0)))
		if abs(p - p_0) < tol: return p
		# Otherwise step the iteration
		p_0 = p
		i+= 1
	return p_0

def secant(f, p_0, p_1, tol=1e-5, max_iters=1000, verbose=False):
	"""
	Same desired behavior as Newton's method function, but uses the secant
	method to avoid computing fprime(p) 
	"""
	i = 0
	while i < max_iters:
		# Compute approximation to f'(p_1)
		sec = (f(p_1) - f(p_0)) / (p_1 - p_0)
		# Compute next iteration
		p = p_1 - f(p_1)/sec
		# Check stopping condition
		if verbose:
			print("Iteration {}: p={}, absolute error={}".format(i, p, abs(p-p_1)))
		if abs(p - p_1) < tol: return p
		# Otherwise step the iteration
		p_0, p_1 = p_1, p
		i+=1
	return p_1

if __name__ == "__main__":
	import numpy as np
	def f_6c(x):
		return 2*x*np.cos(2*x) - (x-2)**2
	def fprime_6c(x):
		return 2*np.cos(2*x) - 4*x*np.sin(2*x) - 2*(x-2)
	
	print("FINDING ROOT IN [2, 3]")
	p = secant(f_6c, 2,3, verbose=True)
	print("\n"*5)
	print("FINDING ROOT IN [3, 4]")
	p = secant(f_6c, 3,4, verbose=True)


