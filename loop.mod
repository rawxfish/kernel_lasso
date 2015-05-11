option loqo_options 'steplen=0.97 iterlim=500 verbose=2 timing=1';
option presolve 0;

param M integer;
param J := (M + 1) * (M + 2) * (M + 3)/6;
param N integer;
param nzeros integer;
param sigma;

# used for bound search
param max_lasso > 0;

param Y {j in 1..N};
param classification {n in 1..N};
param err integer;

param X {i in 1..M, j in 1..N};
param tilde_X {i in 1..M+1, j in 1..N} := if i == M+1 then 1 else X[i,j] / sigma;
param W {i in 1..M+1, j in 1..M+1}; 
var b;
param counter;

var d {i in 1..M+1};


data (first(NAME) & ".dat");

# initialize d
let {i in 1..M+1} d[i] := 1;
fix d[M+1];

model altW.mod;
model ("altD_" & first(KERNEL) & ".mod");


for {t in 1..(M - nzeros)} {
	display t;
	display t >>("output/output_" & first(NAME) & "_" & first(KERNEL) & "_sigma=" & sigma & ".out");

	restore solve_u;
	restore solve_a;
	fix d;
	unfix u;
	unfix a;
	unfix b;
	drop lasso;
	drop error_bound;

	commands ("calc_phi_" & first(KERNEL) & ".mod");

	solve;

	for {i in 1..M+1, j in 1..M+1} {
		let W[i, j] := sum {n in 1..N} a[n] * tilde_X[i, n] * tilde_X[j, n];
	}

	if t == 1
	then {
		printf {i in 1..M+1, j in 1..M+1} "%f\n ", W[i, j] > ("output/W_" & first(NAME) & "_sigma=" & sigma & ".out");
		print b > ("output/b_" & first(NAME) & "_sigma=" & sigma & ".out");
	}


	commands ("classify_" & first(KERNEL) & ".mod"); 
	let err := 0;
	for {n in 1..N} {
		if Y[n] * classification[n] < 0
		then let err := err + 1;
	}
	print err >> ("output/error_" & first(NAME) & "_" & first(KERNEL) & "_sigma=" & sigma & ".out");



	drop solve_u;
	drop solve_a;
	for {i in 1..M+1} {
		if d[i] != 0
		then unfix d[i];
	}
	fix d[M+1];
	fix u;
	fix a;
	fix b;
	restore lasso;
	restore error_bound;

	let max_lasso := M + 1 - t;

	display error_bound >> ("output/output_" & first(NAME) & "_" & first(KERNEL) & "_sigma=" & sigma & ".out");


	solve;


	let counter := 1;
	for {i in 2..M+1} {
		if (d[i] < d[counter] && d[i] != 0) || d[counter] == 0
		then let counter := i;
	}
	let d[counter] := 0;
        for {i in 2..M+1} {
                if d[i] < 0
                then let d[i] := 0;
        }

	display d;
	display d >>  ("output/output_" & first(NAME) & "_" & first(KERNEL) & "_sigma=" & sigma & ".out");
	display error_bound >>  ("output/output_" & first(NAME) & "_" & first(KERNEL) & "_sigma=" & sigma & ".out");
	display sum {i in 1..M} abs(d[i]) >>  ("output/output_" & first(NAME) & "_" & first(KERNEL) & "_sigma=" & sigma & ".out");

} 



# printf {i in 1..M+1, j in 1..M+1} "%f\n ", W[i, j] > ("output/final_W_" & first(NAME) & "_sigma=" & sigma & ".out");
# print b > ("output/final_b_" & first(NAME) & "_sigma=" & sigma & ".out");
# printf {i in 1..N} "%f\n ", classification[i] > ("output/classification_" & first(NAME) & "_sigma=" & sigma & ".out");
