# SpikeApp
An app for generating spike raster plot and peristimulus time histogram (PTSH) for spike time data from electrical recording of neuronal clusters. 

* Any MATLAB workspace containing the spike times data and the recording duration can be imported into the app to generate plots, as long as the variable names and data structures are consistent.
The workspace must: 
  * be a MATLAB workspace (.mat) file 
  * contain clusters represented as Nx2 arrays of continuous spike times
  * contain the total recording duration as a 'Rectime' variable
* As an option, the interval duration can be modified based on the needs of the experiment. The default is 5 seconds. 
* Test workspace files have been provided as an example of input format.


![Screenshot 2023-10-17 203409](https://github.com/n-shenoy/SpikeApp/assets/51956619/721cbbc1-2825-40c0-bc8a-f43e341da948)


## Installation 
1. Download the SpikeApp.mlappinstall file
2. Open the file in MATLAB
3. Follow the prompts to install the app within the MATLAB interface
4. SpikeApp will be accessible from the APPS tab in MATLAB


## Plotting Spike Times
1. Click the **Import** button to import a workspace file.
2. (Optional) Enter the desired duration of each interval. The default is 5 seconds.
3. Click the dropdown menu to select a cluster.
4. The spike rastor plot and the PTSH will appear in the panels on the right. The status will appear under the dropdown menu.

## Saving the Plots
1. Hover the cursor over the plot.
2. Options to save, copy, zoom, etc. will appear on the top-right of the plot.
   

