__precompile__(true)
module Coord

using Reexport
@reexport using GridInterpolations
@reexport using ODE
@reexport using JLD

include("tables.jl")
include("state.jl")
include("dynamics.jl")
include("uav.jl")
include("encounter.jl")
include("strategies.jl")
include("environment.jl")
include("build_simulation.jl")
include("run_simulation.jl")

end # module
