module SlimWrap

using JSON

include("slimwrap.jl")
export SLiMModel

templates = (
    mi1=joinpath(@__DIR__, "templates/mainland-island-divsel.slim"),
    mi2=joinpath(@__DIR__, "templates/mainland-island-divsel-bgs.slim"),
    wf =joinpath(@__DIR__, "templates/wf.slim"),
    )
export templates

end # module Slim
