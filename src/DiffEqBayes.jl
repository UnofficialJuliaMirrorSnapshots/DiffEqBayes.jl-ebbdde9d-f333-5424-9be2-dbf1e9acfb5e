module DiffEqBayes
using DiffEqBase, CmdStan, Distributions, Turing, MacroTools, Mamba
using OrdinaryDiffEq, ParameterizedFunctions, RecursiveArrayTools
using DynamicHMC, TransformVariables, LogDensityProblems
using Parameters, Distributions, Optim
using Distances, ApproxBayes, StatsPlots

STANDARD_PROB_GENERATOR(prob,p) = remake(prob;u0=eltype(p).(prob.u0),p=p)
STANDARD_PROB_GENERATOR(prob::MonteCarloProblem,p) = MonteCarloProblem(remake(prob.prob;u0=eltype(p).(prob.prob.u0),p=p))

include("stan_inference.jl")
include("turing_inference.jl")
include("stan_string.jl")
include("utils.jl")
include("dynamichmc_inference.jl")
include("abc_inference.jl")

export StanModel, stan_inference, turing_inference, stan_string, StanODEData, plot_chain, dynamichmc_inference, LotkaVolterraPosterior, abc_inference

end # module
