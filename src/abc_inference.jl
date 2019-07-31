function createabcfunction(prob, t, distancefunction, alg; kwargs...)
    function simfunc(params, constants, data)
        sol = solve(STANDARD_PROB_GENERATOR(prob, params), alg; saveat = t, kwargs...)
        if any((s.retcode != :Success for s in sol)) && any((s.retcode != :Terminated for s in sol))
            return Inf,nothing
        else
            simdata = convert(Array, sol)
            return distancefunction(data, simdata), nothing
        end
    end
end

function abc_inference(prob::DiffEqBase.DEProblem, alg, t, data, priors; ϵ=0.001,
                       distancefunction = euclidean, ABCalgorithm = ABCSMC, progress = false,
                       num_samples = 500, maxiterations = 10^5, kwargs...)

    abcsetup = ABCalgorithm(createabcfunction(prob, t, distancefunction, alg; kwargs...),
                            length(priors),
                            ϵ,
                            ApproxBayes.Prior(priors);
                            nparticles = num_samples,
                            maxiterations = maxiterations
                            )

    abcresult = runabc(abcsetup, data, progress = progress)
    return abcresult
end
