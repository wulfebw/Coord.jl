# add
pkgs = [
    "GridInterpolations",
    "ODE",
    "JLD"
]

for pkg in pkgs
    try
        Pkg.add(pkg)
    catch e
        println("Exception when adding $(pkg): $(e)")  
    end
end