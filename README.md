# PolyaUtils

`PolyaUtils` is a package containing a set of utility tools for the use, analysis and visualization of metaheuristic algorithms. Its main purpose is an auxiliary package for the `Polya`-package for metaheuristic algorithms, but some of its functionality can be used independently. 

Following functionality is currently available in `PolyaUtils`

## Logging
- TimeLogger: logs time of a component
- InputLogger: logs (an) input argument(s)
- OutputLogger: logs (an) output argument(s)
- MoveLogger: TODO
- Vizlogger: custom logger that can be used to construct template-based visualizations

## Data processing

## Plotting
- First time to target plot

## Visualization
The visualization components of `PolyaUtils` include:
- Metaheuristic algorithms as a composition of a set of atomic components
- Search space visualizations (solution viz, neighborhood viz, search trace viz)

## Algorithm IO
Write out algorithm structure to a file and read it back in. Currently only supports a custom XML-format. 