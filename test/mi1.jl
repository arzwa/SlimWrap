using SlimWrap, Plots, WrightDistribution

N = 500
α = 1
s = 0.08
h = 0.5
m = 0.005 #(s*h)/5
G = 1000
u = s/50
#A = Dict(G÷3=>[5s, h], 2G÷3=>[s, 0.0])
A = Dict(G÷2=>(s, h))
prms = Dict(
    "CHRLEN" => G - 1,
    "RECRATE" => 1e-8,
    "NGEN" => 500N,
    "NE1" => α*N,
    "NE2" => N,
    "MIGRATION_RATE"=> m,
    "BARRIERS" => A,
    "OUTFILE" => tempname(),
    "MU" => u
)
run(SLiMModel(templates.mi1), constants=prms)

ss = readlines(prms["OUTFILE"])[2:end]
Ps = map(x->parse(Float64, x), ss)
qs = reshape(Ps, length(A), prms["NGEN"]) |> permutedims
P1 = plot(qs, color=:black, alpha=0.2)
hline!([1-m/(h*s)], color=:black)
d = Wright(-2N*s, 2N*u, 2N*(m + u), h)
P2 = stephist(qs[10N:end,1], norm=true, fill=true, alpha=0.2, color=:black, legend=false)
plot!(0:0.001:1, p->pdf(d, p), color=:black)
plot(P1, P2, size=(800,300))

