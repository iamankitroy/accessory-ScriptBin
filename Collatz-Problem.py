#!/Users/roy/anaconda3/bin/python

# Script to calculate the Collatz-problem trajectories for different numbers and count the number of steps it takes to converge

import sys
import pandas as pd

x = []
y = []
z = []

for n in range(1, 10002, 100):
	original_n = n
	count = 0
	while(n not in [4, 2, 1]):
		x.append(count)
		y.append(n)
		z.append(original_n)
		if n%2 == 0:
			n = n/2
		else:	
			n = 3*n + 1
		count += 1
	print(f"{original_n:^10}:{count:^15.2e}")

result = pd.DataFrame(list(zip(x, y, z)), columns = ['Count', 'Number', 'Original'])
result.to_csv("Collatz-output.csv", index = False)

# Ankit Roy
# 9th September, 2021
