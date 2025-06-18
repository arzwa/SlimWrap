# [2025-06-16] Translated from Curro's script slimwrap.py (without all
# the checks and informative error handling...)

struct SLiMModel
    model_src::String  # path to SLiM template source code
end

Base.run(M::SLiMModel; kwargs...) = run(buildcmd(M; kwargs...))

function buildcmd(M::SLiMModel; 
        seed=0, constants=Dict(), check=true, progress=true, verbose=2)
    seed = (seed == 0 ? rand(Int) : seed)
    pfile = _write_paramfile(constants)
    cmds = ["slim", "-s", "$seed", "-l", "$verbose", "-d", "SLIM_WRAP_PARAMS = Dictionary(readFile('$pfile'))"]
    progress && push!(cmds, "-p")
    for (k, v) in constants
        push!(cmds, "-d", _dstring(k, v))
    end
    push!(cmds, M.model_src)
    Cmd(cmds)
end

_dstring(k, v) = "$k=SLIM_WRAP_PARAMS.getValue('$k');"
function _dstring(k, v::AbstractMatrix) 
    m, n = size(v)
    "$k=matrix(SLIM_WRAP_PARAMS.getValue('$k'), nrow=$m, ncol=$n, byrow=T);"
end

function _write_paramfile(d::Dict)
    y = copy(d)
    _flat(x) = x
    _flat(x::AbstractMatrix) = vcat(x'...)
    for (k, v) in d
        y[k] = _flat(v)
    end
    pfile = tempname() 
    open(pfile, "w") do f
        write(f, json(y))
    end
    return pfile
end
