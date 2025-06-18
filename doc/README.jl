
# Translation of [currocam](https://github.com/currocam)'s `slim_wrap.py` to Julia.

# Workflow example with `SlimWrap` + `PyCall`

# ## Example

using SlimWrap
using PyCall
tskit = pyimport("tskit")
pyslim = pyimport("pyslim")
msprime = pyimport("msprime")

# Define and run the SLiM simulation
M = SLiMModel(templates.wf)
params = Dict(
    "POPSIZE"=>100,
    "CHRSIZE"=>1_000_000,
    "RECRATE"=>1e-8,
    "NGEN"   =>1000,
    "OUTFILE"=>tempname())
run(M, constants=params)

# Load and simplify the tree sequence
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
)

# Simulate neutral mutations
mts = msprime.sim_mutations(
    ts, random_seed=11,
    rate=1e-8,
    keep=false
)

# Get coalescence times
tmrca = mts.diversity(mts.samples(population=1),
    mode="branch", windows=0:100_000:params["CHRSIZE"]) / 2

