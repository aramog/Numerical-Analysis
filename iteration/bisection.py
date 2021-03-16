import numpy as np

def f(x):
	return x + 1 - 2*np.sin(np.pi*x)

def avg(x, y):
	return (x+y)/2

def bisect(f,x,y,tol=1e-5):
	"""
	f(x) and f(y) must have opposite signs.
	returns x* st |f(x*)| < tol
	"""
	# check if x or y a solution
	if abs(f(x)) < tol: return x
	if abs(f(y)) < tol: return y
	# check signs different
	assert np.sign(f(x)) != np.sign(f(y))
	# compute midpoint
	p = avg(x, y)
	fp = f(p)
	# check if p a solution
	if abs(fp) < tol: return p
	# otherwise recurse
	if np.sign(fp) != np.sign(f(x)): return bisect(f, x, p, tol)
	else: return bisect(f, p, y, tol)

