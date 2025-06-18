```@meta
EditURL = "doc/README.jl"
```

Translation of [currocam](https://github.com/currocam)'s `slim_wrap.py` to Julia.

Workflow example with `SlimWrap` + `PyCall`

## Example

````julia
using SlimWrap
using PyCall
tskit = pyimport("tskit")
pyslim = pyimport("pyslim")
msprime = pyimport("msprime")
````

````
PyObject <module 'msprime' from '/home/arzwa/.local/lib/python3.10/site-packages/msprime/__init__.py'>
````

Define and run the SLiM simulation

````julia
M = SLiMModel(templates.wf)
params = Dict(
    "POPSIZE"=>100,
    "CHRSIZE"=>1_000_000,
    "RECRATE"=>1e-8,
    "NGEN"   =>1000,
    "OUTFILE"=>tempname())
run(M, constants=params)
````

````
Process(`slim -s 6563984953498643476 -l 2 -d "SLIM_WRAP_PARAMS = Dictionary(readFile('/tmp/jl_cJCHGD2DQv'))" -p -d "POPSIZE=SLIM_WRAP_PARAMS.getValue('POPSIZE');" -d "NGEN=SLIM_WRAP_PARAMS.getValue('NGEN');" -d "CHRSIZE=SLIM_WRAP_PARAMS.getValue('CHRSIZE');" -d "RECRATE=SLIM_WRAP_PARAMS.getValue('RECRATE');" -d "OUTFILE=SLIM_WRAP_PARAMS.getValue('OUTFILE');" /home/arzwa/dev/SlimWrap/src/templates/wf.slim`, ProcessExited(0))
````

Load and simplify the tree sequence

````julia
ts = tskit.load(params["OUTFILE"])
alive = pyslim.individuals_alive_at(ts, 0) .+ 1
sts = ts.simplify(
    ts.individuals_nodes[alive],
    keep_input_roots=true)
demography = msprime.Demography.from_tree_sequence(sts)
rts = pyslim.recapitate(
    sts, random_seed=11,
    demography=demography,
    ploidy=2,
    recombination_rate=params["RECRATE"]
);
````

Simulate neutral mutations

````julia
mts = msprime.sim_mutations(
    ts, random_seed=11,
    rate=1e-8,
    keep=false
);
````

Get coalescence times

````julia
tmrca = mts.diversity(mts.samples(population=1),
    mode="branch", windows=0:100_000:params["CHRSIZE"]) / 2
````

````
10-element Vector{Float64}:
 202.50725526130654
 204.2841005829146
 190.5178457778894
 167.17291633165817
 175.7796540577888
 220.64733668341697
 220.88865190251246
 221.7803015075376
 221.3815927698492
 223.83476951557773
````

---

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*

