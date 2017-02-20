# tests for the UAV type and related functions.

# using Base.Test
# using GridInterpolations

# push!(LOAD_PATH, ".")
# include("includes.jl")

function get_test_uav()
    actions = [-1., 1.]
    joint_actions = ones(2, 2)
    joint_actions[:, 1] = -1

    r = collect(0:10)
    q_table = zeros(10^7, size(joint_actions, 2))
    q_grid = RectangleGrid(r, r, r, r, r, r, r)
    policy = PolicyTable(q_table, q_grid, 10^7)

    c_table = zeros(10, 10, 10, 10, 10)
    c_grid = RectangleGrid(r, r, r, r, r)
    coord = CoordinationTable(c_table, c_grid, 10^5)

    strategy = coordinated_strategy
    act_select = "best"

    rng = MersenneTwister(1)
    sensor_range_std = 15.
    sensor_theta_std = deg2rad(1.)
    sensor_psi_std = deg2rad(1.)
    sensor_velocity_std = 1.
    use_sensor_noise = false

    uav = UAV(1, actions, joint_actions, policy, coord, false, strategy, act_select, rng, sensor_range_std, sensor_theta_std, sensor_psi_std, sensor_velocity_std, use_sensor_noise)
    return uav
end

# UAV tests
function test_uav_constructor()
   get_test_uav()
end

function test_get_polar_state()
    uav = get_test_uav()
    uav_state = UAVState(ones(Float64, 8)...)
    state = State([uav_state, uav_state])
    state.responding_states = [1,0]
    polar_state = get_polar_state(uav, state)
    if uav.is_policy_joint == true
        @test polar_state == [0,0,0,sqrt(2),sqrt(2),1,0]
    else
        @test polar_state == [0,0,0,sqrt(2),sqrt(2),1]
    end
end

function test_get_belief_state()
    uav = get_test_uav()
    uav_state = UAVState(ones(Float64, 8)...)
    state = State([uav_state, uav_state])
    state.responding_states = [1,1]
    belief_state = get_belief_state(uav, state)
    @test length(belief_state) == uav.policy_table.num_states
end

function test_get_action()
    uav = get_test_uav()
    uav_state = UAVState(ones(Float64, 8)...)
    state = State([uav_state, uav_state])
    state.responding_states = [1,1]
    action, signals, _ = get_action(uav, state)
    @test action == -1.0
    @test signals == [:no_signal, :no_signal]
end
tic()
# UAV tests
test_uav_constructor()

# function tests
test_get_polar_state()
test_get_belief_state()
test_get_action()
toc()