module SlimWrap

using JSON

include("slimwrap.jl")
export SLiMModel

templates = (
    mainlandisland=joinpath(@__DIR__, "templates/mainland-island.slim"),
    wf=joinpath(@__DIR__, "templates/wf.slim"),
    )
export templates

end # module Slim
