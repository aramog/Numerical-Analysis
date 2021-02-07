ns = [5, 10, 100, 1000]
res = [[], [], [], []]
for n in ns:
	for i in range(4):
		print(i)
		res[i].append(1/(n**(i+1)))

print("n --- 1/n --- 1/n^2 --- 1/n^3 --- 1/n^4")
for i in range(len(ns)):
	print("{} --- {} --- {} --- {} --- {}".format(ns[i], res[0][i], res[1][i], res[2][i], res[3][i]))
