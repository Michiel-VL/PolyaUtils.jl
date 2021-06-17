# Logging
The main purpose of providing logging tools is to be able to gain a deeper understanding of how metaheuristics work. To achieve this, we start from the viewpoint of a(n) (S-)metaheuristic as a program $solve: S \to S$, which upon calling with as input initial solution $s_{init}$, returns as output a solution $s_{final}$ after $\Delta_t$ time units. The function $solve$ is itself (recursively) a composition of several smaller functions, each of which operate as one of a few basic allowed components. The logging functions in this package serve to gain understanding about how these components work and interact in a given metaheuristic, hopefully leading to the possibility to create visualizations that allow differentiation between distinct algorithms.


# Supported components
- Neighborhood Generation: log the sequence of evaluated neighbors
- Neighborhood Selection: log which neighbor(s) were selected from a given neighborhood
- Acceptance criteria: log whether a given neighbor is accepted over the incumbent solution


## Neighborhood Generation
- Provide a wrapper for a neighborhood-structure which pushes a string-hash of the currently called neighbor to a list
- Make the list shared by all neighborhood-structures => breaks down for parallel, obviously


# Time to target plots
Assumption: cpu times fit a shifted exponential distribution

1. For a given problem instance, measure the CPU time to find an objective funtion value at least as good as a given target value
2. Heuristic is run n times on the instance, using the given target solution
3. Independent runs (in case of stochastic approach)
4. Compare empirical and theoretical distributions following a standard graphical methodology => ttt plots
5. For each instance/target pair, the running times are sorted in increasing order
6. Associate with i-th sorted running time t(i) a probability p(i) = (i-1/2)/n and plot z(i) = [t(i), p(i)] for i = 1:n
7. 