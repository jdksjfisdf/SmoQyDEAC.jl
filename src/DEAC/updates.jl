# Calculate the initial fits
function initial_fit!(pop, fitness, model, avg_p, Kp, W, params, use_SIMD, normalize, normK, target_zeroth, norm_array)
    if normalize
        normalize!(pop, norm_array, params, use_SIMD, normK, target_zeroth)
    end
    GEMM!(model, Kp, pop, use_SIMD)

    Χ²!(fitness, avg_p, model, W)

    # return fitness

end

# Normalize a population
function normalize!(pop_array, norm_array, params, use_SIMD, normK, target_zeroth)
    GEMM!(norm_array, normK, pop_array, use_SIMD)

    @turbo for pop in 1:params.population_size, ω in 1:size(params.out_ωs, 1)
        pop_array[ω, pop] *= target_zeroth / norm_array[1, pop]
    end

    return
end

# Randomly set new weights for crossover_probability and differential_weight
function update_weights!(cp_new, dw_new, cp_old, dw_old, rng, params)
    for p in 1:params.population_size
        cp_new[p] = (Random.rand(rng, Float64) < params.self_adapting_crossover_probability) ? rand(rng, Float64) : cp_old[p]
        dw_new[p] = (Random.rand(rng, Float64) < params.self_adapting_differential_weight_probability) ? 2.0 * rand(rng, Float64) : dw_old[p]
    end

end

# Determine which genes mutate
function rand_mutate_array!(mutate_indices, mutate_indices_rnd, crossover_probability_new, rng, params)
    Random.rand!(rng, mutate_indices_rnd)
    for pop in 1:params.population_size
        for i in 1:size(params.out_ωs, 1)
            mutate_indices[i, pop] = Float64(mutate_indices_rnd[i, pop] < crossover_probability_new[pop])
        end
        # @. mutate_indices[:,pop] = Float64(mutate_indices_rnd[:,pop] < crossover_probability_new[pop])
    end


end


# Population update routine
#
# Below is the unoptimized verson which is easier to read
#   Note, mutate_indices[pop,ω] here is a bool, in the actual function it is 1.0 or 0.0
#
# for pop in 1:params.population_size
#     for ω in 1:size(params.out_ωs,1)
#         if mutate_indices[pop,ω]
#             population_new[ω,pop] = abs(population_old[ω,mutant_indices[1,pop]] + differential_weights_new[pop]*
#                                         (population_old[ω,mutant_indices[2,pop]]-population_old[ω,mutant_indices[3,pop]]))
#         else
#             population_new[ω,pop] = population_old[ω,pop]
#         end
#     end
# end
function propose_populations!(population_new, population_old, mutate_indices, differential_weights_new, mutant_indices, params, normalize, normK, target_zeroth, norm_array, use_SIMD)
    @turbo for pop in 1:params.population_size, ω in 1:size(params.out_ωs, 1)
        population_new[ω, pop] =
            population_old[ω, pop] * (1.0 - mutate_indices[ω, pop]) + # If false keep old gene
            #if true do update
            mutate_indices[ω, pop] * abs(population_old[ω, mutant_indices[1, pop]] + differential_weights_new[pop] *
                                                                                     (population_old[ω, mutant_indices[2, pop]] - population_old[ω, mutant_indices[3, pop]]))

    end # pop


    if normalize
        normalize!(population_new, norm_array, params, use_SIMD, normK, target_zeroth)
    end
end

# If population's fit improves, do an update, else keep as is
function update_populations!(fitness_old, crossover_probability_old, differential_weights_old, population_old, fitness_new, crossover_probability_new, differential_weights_new, population_new)
    for pop in axes(fitness_old, 1)
        if fitness_new[pop] <= fitness_old[pop]
            fitness_old[pop] = fitness_new[pop]
            crossover_probability_old[pop] = crossover_probability_new[pop]
            differential_weights_old[pop] = differential_weights_new[pop]
            for ω in axes(population_old, 1)

                population_old[ω, pop] = population_new[ω, pop]
            end
        end
    end
end


