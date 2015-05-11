for {n in 1..N} {
	let classification[n] := 
		if (b + sum {i in 1..M+1, j in 1..M+1} tilde_X[i, n] * tilde_X[j, n] * d[i] * d[j] * W[i, j]) < 0
		then -1
		else 1 ;
}

