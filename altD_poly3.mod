subject to lasso: 
	max_lasso - 0.5<= sum {i in 1..M} abs(d[i]) <= max_lasso;

minimize error_bound:
	sum {n in 1..N} ((sum {i in 1..M+1, j in 1..M+1} tilde_X[i, n] * tilde_X[j, n] * d[i] * d[j] * W[i, j]) + b - Y[n])^2;

