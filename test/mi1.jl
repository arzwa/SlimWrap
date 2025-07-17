using SlimWrap, Plots, WrightDistribution

# This one works, but annoyingly variable dominance requires a different
# script...
N = 100
α = 1
s = 0.05
h = 0.5
m = (s*h)/10
G = 100_000
u = s/200
A = [[G÷3, s, h], [2*(G÷3), 0.5s, 0.0]]
prms = Dict(
    "CHRLEN" => G - 1,
    "RECRATE" => 1e-6,
    "NGEN" => 100N,
    "NE1" => α*N,
    "NE2" => N,
    "MIGRATION_RATE"=> m,
    "BARRIERS" => A,
    "BARRIER_POS" => collect(keys(A)),
    "OUTFILE" => tempname(),
    "MU" => u
)
run(SLiMModel(templates.mi1b), constants=prms)

ss = readlines(prms["OUTFILE"])[2:end]
Ps = map(x->parse(Float64, x), ss)
qs = reshape(Ps, 2length(prms["BARRIER_POS"]), prms["NGEN"]) |> permutedims
plot(qs)
hline!([1-m/(h*s)])

d = Wright(-2N*s, 2N*u, 2N*(m + u), h)
stephist(qs[:,1], norm=true)
plot!(0:0.001:1, p->pdf(d, p))
