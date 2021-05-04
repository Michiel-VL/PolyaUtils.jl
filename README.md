# PolyaUtils

**Note: this package is a WIP and not yet in a useable state.** 

`PolyaUtils` is a package containing a set of utility tools to go with the metaheuristics package `Polya`. 

## Logging
Logging functionality is provided in the form of a series of loggers that ought to be used in a lo

```

logger_dict = Dict()


ctx = MetaheuristicLogging(metadata=)

```



## Logging
- TimeLogger: logs time of a component
- InputLogger: logs (an) input argument(s)
- OutputLogger: logs (an) output argument(s)
- NeighborhoodLogger


## Future
- **Experiment support & data processing**
- **Algorithm IO**: Write out algorithm structure to a file and read it back in
- **Template-based visualization**: Generate a flowchart of your metaheuristic algorithm and export to svg, png or tikz
- **Problem-visualization utilities**: Generate problem visualization easily using a set of predefined higher-order functions
- **MoveLogger**: log move-specific behavior
- **Vizlogger**: custom logger that can be used to construct template-based visualizations
- First time to target plot
- Metaheuristic algorithms as a composition of a set of atomic components
- Search space visualizations (solution viz, neighborhood viz, search trace viz)