import math
e = math.e
pi = math.pi

accelerate = lambda x0, x1, x2: (x0*x2 - x1*x1)/(x0 + x2 - 2*x1)

def aitkens(f, p, n, tol = .0002):
	initial_values = [0] * (n+2)
	for i in range(n+2):
		initial_values[i] = f(p)
		p = initial_values[i]
	results = []
	for i in range(n):
		result = accelerate(initial_values[i], initial_values[i+1], initial_values[i+2])
		results.append(result)
		print(f'P{i+1}:\t{result:.7f}')
		if len(results) > 1:
			if abs(results[i] - results[i-1]) < tol: break

if __name__ == '__main__':
	f = lambda x: e**(6*x) + 3 * math.log(2)**2 * e**(2*x) - math.log(8)*e**(4*x) - math.log(2) **2
	aitkens(f, 0, 10)
