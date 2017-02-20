# tests for the dynamics type and related functions.

using Base.Test
# using PyPlot

const OUTPUTS_DIRECTORY = "data/plots/"

# Dynamics type tests
function test_dyn_constructor()
    m = MersenneTwister(1)
    d = Dynamics(3, 1., 4., 5., 5., false, m)
    @test d.dt == 3
    @test d.dt_step == 1.
    @test d.pid_omega == 4
    @test d.pid_b_std == 5
end

# pid controller tests
function test_build_pid_policy()
    m = MersenneTwister(1)
    d = Dynamics(3, 1., 4., 5., 5., false, m)
    action = deg2rad(10)
    uav_state_vector = collect(1.:8)
    pid = build_pid_policy(d, action)
    actual_action = pid(uav_state_vector)
    @test actual_action == -173.20747319680908
end

# step tests
function test_multi_uav_step()
    m = MersenneTwister(1)
    omega = .3
    d = Dynamics(1, 1., omega, 0., 0., false, m)
    uav_state_own = UAVState(ones(Float64, 8)...)
    uav_state_int = UAVState(ones(Float64, 8)...)
    state = State([uav_state_own; uav_state_int])
    actions = [deg2rad(10); deg2rad(10)]
    next_state = step(d, state, actions)
end

function test_single_uav_step()
    m = MersenneTwister(1)
    omega = .3
    d = Dynamics(0, 0., omega, 0., 0., false, m)
    action = deg2rad(10)
    pid = build_pid_policy(d, action)
    uav_state = UAVState(ones(Float64, 8)...)
    next_uav_state = step(uav_state, pid, 1, 1.)
end

tic()
# dynamics tests
test_dyn_constructor()

# # pid controller tests
test_build_pid_policy()

# step tests
test_multi_uav_step()
test_single_uav_step()
toc()
