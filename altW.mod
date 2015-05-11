param phi {i in 1..J, j in 1..N} ;
param S {i in 1..J, j in 1..J} := sum {k in 1..N} phi[i,k] * phi[j,k];

var u {i in 1..J};
var a {i in 1..N};

subject to solve_u {i in 1..J}:
	sum {j in 1..J} S[i,j] * u[j] = sum {j in 1..N} phi[i,j] * (Y[j] - b);


subject to solve_a {i in 1..J}:
	u[i] = sum {j in 1..N} phi[i,j]*a[j];
