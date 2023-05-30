# Changelog

## TODO:
- need to update from plotly 1.58.4 to 2.16.x or more.  Looks like major 
changes, for example Plotly.plot has been removed from the API in favor 
of Plotly.newPlot (maybe?)


## release 2023-05-29
- bump up the sdk upper limit to 4.0.0

## 0.2.1 (release 2022-10-31)
- Expanded the 'line_and_scatter' example now to show how to use the **on_hover** events 
to display additional information when the mouse is on top of a data point. 
- Improve the examples README

## 0.2.0 (released 2021-12-23)
- Improved the example significantly to show various plot interactions.  
- Moved code from the build method to the init to improve performance.
- Exposed most used Plotly Javascript methods directly in the Plotly Widget.  
This makes the code cleaner.

## 0.1.1 (released 2021-09-13)
- Fixed some to the Plotly config arguments.  Updated some warnings 
for Flutter 2.5.  Getting some js errors in the js console.  Not sure 
how to fix them.  

## 0.1.0 (released 2021-07-11)
- Initial version working.  Starting to use it in prototypes.
