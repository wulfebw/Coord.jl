
function get_real_uav()
    opts = SimulationOptions()
    uavs = build_uavs(opts)
    return uavs[1]
end

# some functions and constants common to multiple test files
const SHOW_PLOTS = false


