export 
    run_simulation,
    simulate_encounters,
    simulate_encounter

#=
The main script that simulates encounters.
=#

#=
Description:
This method simulates a single encounter. Abstractly, this
entails initializing an encounter, simulating
each uav in the environment taking actions, and then 
simulating the trajectories resulting from these actions.

Parameters:
- environment: the environment in which to simulate the encounter

Return Value:
- encounter: a single encounter object

=#
function simulate_encounter(environment::Environment)
    # select a random start state
    state = start_encounter(environment)

    # create an encounter to track information
    encounter = Encounter()
    update!(encounter, state)

    # simulate the actual encounter
    for idx in 1:environment.max_steps
        actions = get_uav_actions!(environment, state, encounter)
        state = step!(environment, state, actions, encounter)
    end

    return encounter
end


#=
Description:
This method simulates a variable number of encounters using the 
environment provided to it.

Parameters:
- environment: the environment in which to simulate encounters
- num_encounters: the number of encounters to simulate

Return Value:
- encounters: a list of encounter objects which contain all the 
                information needed to visualize each encounter
=#
function simulate_encounters(environment::Environment, num_encounters::Int64)
    
    # simulate num_encounters, collecting encounter information
    encounters = Array(Encounter, num_encounters)
    for idx in 1:num_encounters
        encounters[idx] = simulate_encounter(environment)
    end
    return encounters
end 

#=
Description:
Main method that performs setup and then calls simulate_encounters
to actually simulate encounters.
=#
function run_simulation(;num_encounters = 1)
    # get the environment to simulate encounters in
    environment = build_environment()

    # simulate the encounters
    encounters = simulate_encounters(environment, num_encounters)

end

