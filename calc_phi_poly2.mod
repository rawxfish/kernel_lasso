for {n in 1..N} {
	let counter := 1;
	for {i in 1..M+1, j in i..M+1} {
		if i == j
		then {
			let phi[counter, n] := d[i] * tilde_X[i,n]^2;
			let counter := counter + 1;
		}

		else {
			let phi[counter, n] := sqrt(2) * sqrt(d[i]) * tilde_X[i,n] * sqrt(d[j]) * tilde_X[j,n];
			let counter := counter + 1;
		}
	}	
}
