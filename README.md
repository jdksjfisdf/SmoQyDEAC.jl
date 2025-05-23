# SmoQyDEAC

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://SmoQySuite.github.io/SmoQyDEAC.jl/stable/) 

[![Build Status](https://github.com/SmoQySuite/SmoQyDEAC.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/SmoQySuite/SmoQyDEAC.jl/actions/workflows/CI.yml?query=branch%3Amain)
![](https://img.shields.io/badge/Lifecycle-Maturing-007EC6g)
<!--[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://SmoQySuite.github.io/SmoQyDEAC.jl/dev/)-->
This packages utilizes the Differential Evolution for Analytic Continuation (DEAC) method. This package takes imaginary time and Matsubara frequency correlation functions from condensed matter Monte Carlo simulations and provides the associated spectral function on the real axis. This is a reimplementation of the DEAC algorithm developed by Nathan S. Nichols, Paul Sokol, and Adrian Del Maestro [Phys. Rev. E 106, 025312 (2022)](https://journals.aps.org/pre/abstract/10.1103/PhysRevE.106.025312).

## Funding

This work was supported by the U.S. Department of Energy, Office of Science, Office of Basic Energy Sciences, under Award Number DE-SC0022311. N.S.N. was supported by the Argonne Leadership Computing Facility, which is a U.S. Department of Energy Office of Science User Facility operated under contract DE-AC02-06CH11357. 

## Documentation

- [`STABLE`](https://SmoQySuite.github.io/SmoQyDEAC.jl/stable/): Documentation associated with most recent stable commit to the main branch.
<!-- - [`DEV`](https://SmoQySuite.github.io/SmoQyDEAC.jl/dev/): Documentation associated with most recent commit to the main branch. -->

## Notable Package Dependencies

- [`LoopVectorization.jl`](https://github.com/JuliaSIMD/LoopVectorization.jl): Utilizes SIMD instructions (AVX,SSE) to vectorize loops. Note, LoopVectorization will be depracated in Julia 1.11+ but should not break this package.
- [`JLD2.jl`](https://github.com/JuliaIO/JLD2.jl): Package used to write data to binary files in an HDF5 compatible format. 
- [`Chairmarks.jl`](https://github.com/LilithHafner/Chairmarks.jl): Used to determine if internal SIMD double general matrix multiply (DGEMM) is faster than installed linear algebra package.

## Citation
If you found this library to be useful in the course of academic work, please consider citing us:

```bibtex
@Article{10.21468/SciPostPhysCodeb.39,
	title={{SmoQyDEAC.jl: A differential evolution package for the analytic continuation of imaginary time correlation functions}},
	author={James Neuhaus and Nathan S. Nichols and Debshikha Banerjee and Benjamin Cohen-Stead and Thomas A. Maier and Adrian Del Maestro and Steven Johnston},
	journal={SciPost Phys. Codebases},
	pages={39},
	year={2024},
	publisher={SciPost},
	doi={10.21468/SciPostPhysCodeb.39},
	url={https://scipost.org/10.21468/SciPostPhysCodeb.39},
}
```


## Contact us

For questions and comments regarding this package, please email either James Neuhaus at [jneuhau1@utk.edu](mailto:jneuhau1@utk.edu) or Professor Steven Johnston at [sjohn145@utk.edu](mailto:sjohn145@utk.edu).

## Modify Log

I added prior support.

if using a boson kernel other than time_bosonic_symmetric_w, multiply the prior by $\frac{2}{1-\exp(-\beta \omega)}$

It does not help at all currently. Avoid using this.
