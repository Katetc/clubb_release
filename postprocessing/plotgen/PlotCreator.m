function PlotCreator( caseName, plotTitle, plotNum, plotType, startTime, endTime, startHeight, endHeight, plotUnits, tickCount, dispLegend, varargin )

%Add functions to be used in case files
addpath('CaseFunctions');

%Display the variables that were passed in (debug output)
ConsoleOutput.message(['Case Name: ' caseName]);
ConsoleOutput.message(['Plot Title: ' plotTitle]);
ConsoleOutput.message(['Units: ' plotUnits]);
ConsoleOutput.message(['Plot Number: ' int2str(plotNum)]);
ConsoleOutput.message(['Plot Type: ' plotType]);
ConsoleOutput.message(['Start Time: ' int2str(startTime) ' min.']);
ConsoleOutput.message(['End Time: ' int2str(endTime) ' min.']);
ConsoleOutput.message(['Start Height: ' int2str(startHeight) ' m']);
ConsoleOutput.message(['End Height: ' int2str(endHeight) ' m']);

%Quick sanity check
if startTime == endTime
    ConsoleOutput.severe('Start time and end time are the same, nothing to plot.');
	return;
end

%Figure out the number of optional arguments passed in
optargin = size(varargin,2);

%Optional argument format is as follows:
%'/PATH/TO/FILE', 'timeseries or profile', 'varname', 'title', 'units', 'lineWidth', 'lineType', 'lineColor'

%This means we can easily figure out the number of lines on the plot by dividing by the number of arguments per line
argsPerLine = 6;
numLines = optargin / argsPerLine;

%Create a blank plot of the proper type so we have somewhere to draw lines
fig_height = 220;
fig_width = 250;

% Open figure to set size.
figure('Position',[ 0 0 fig_width fig_height ])
set(gcf, 'PaperPositionMode', 'manual')
set(gcf, 'PaperUnits', 'points')
set(gcf, 'PaperPosition', [ 0.0 0.0 fig_width fig_height ])

%Pre-allocate minimum and maximum values
minVals(1:numLines) = 0;
maxVals(1:numLines) = 0;

%Preallocate the arrays needed for legend construction
lines(1:numLines) = 0; %This is the collection where lines are stored
clear legendText;

%Loop through each line on the plot
for i=1:numLines
	filePath = varargin{1 + ((i - 1) * argsPerLine)};
	varExpression = varargin{2 + ((i - 1) * argsPerLine)};
	lineName = ['\fontsize{6}', varargin{3 + ((i - 1) * argsPerLine)}]; %Font size is set here as well
	lineWidth = varargin{4 + ((i - 1) * argsPerLine)};
	lineType = varargin{5 + ((i - 1) * argsPerLine)};
	lineColor = varargin{6 + ((i - 1) * argsPerLine)};

	%If the color is passed in as one of the MATLAB defined strings, we need to
	%convert it to its corresponding RGB array
	lineColor = ParseColorFromExpression(lineColor);

	%Determine the type of file being read in
	extension = DetermineExtension(filePath);

	%Determine the variables that need to be read in
	varsToRead = ParseVariablesFromExpression(varExpression);

	%Read in the necessary variables
	for j=1:size(varsToRead,2);
		%We need to convert the variable name to read from a cell array to a string
		varString = cell2mat(varsToRead(j));
        	ConsoleOutput.message(['Reading variable ' varString]);
		
		try
			if strcmp(extension, '.ctl')
				[variableData, levels] = VariableReadGrADS(filePath, varString, startTime, endTime, plotType);
			elseif strcmp(extension, '.nc')
				[variableData, levels] = VariableReadNC(filePath, varString, startTime, endTime, plotType);
			end

			%Store the read in values to the proper variable name (ex. variable rtm will be read in to the variable named rtm,
			%this allows the expression to be used as is).
			eval([varString, '= variableData;']);
		catch
			ConsoleOutput.warning(['Variable ' varString ' not found!']);

			%If levels is defined, don't set it to 0
			if exist('levels') == 0
				levels = [startHeight; endHeight];
			end

			eval([varString, '= 0;']);
		end
	end

	%Load timestep information
	if strcmp(extension, '.ctl')
		[dummy, dummy , dummy, t_time_steps, time_step_length, dummy, dummy] = header_read_expanded(filePath);
	elseif strcmp(extension, '.nc')
		[dummy, dummy , dummy, t_time_steps, time_step_length, dummy, dummy] = header_read_expanded_netcdf(filePath);
	end

	%Figure out indicies for start and end height
	if strcmp(plotType, 'profile')	
		bottomIndex = find(levels >= startHeight, 1, 'first');
		topIndex = find(levels <= endHeight, 1, 'last');
	elseif strcmp(plotType, 'timeseries')
		%For timeseries, we want the start and end time indexes	
		t_start_index = ceil(startTime / time_step_length);
		t_end_index = round(endTime / time_step_length);
		
		%Create a time array
		times = startTime:time_step_length:endTime;
	end

	%Now evaluate the expression using the read in values,
	eval(['valueToPlot =', varExpression, ';']);
	
	%Plot zeroes if data is missing
	if endTime > (t_time_steps * time_step_length)
        	ConsoleOutput.severe('ERROR: End time of plot greater than end time of data');
		valueToPlot = 0;
	end

	%At this point, the value of the expression is contained in valueToPlot

	%Add a the line to the plot
	if strcmp(plotType, 'profile')
		%If no variables were found, expand the profile to the right size and plot a line of zeroes
		if max(size(valueToPlot)) == 1
			bottomIndex = 1;
			topIndex = 2;
			levels = [startHeight; endHeight];
			valueToPlot = [0; 0];
		end

		lines(i) = ProfileFunctions.addLine( levels, valueToPlot, lineWidth, lineType, lineColor);
	elseif strcmp(plotType, 'timeseries')
		try
			lines(i) = TimeseriesFunctions.addLine( times, valueToPlot(t_start_index:t_end_index), lineWidth, lineType, lineColor);
		catch
			%Variable was not found, just plot 0
			valueToPlot(t_start_index:t_end_index) = 0;
			lines(i) = TimeseriesFunctions.addLine( times, valueToPlot(t_start_index:t_end_index), lineWidth, lineType, lineColor);
		end
	end
	
	%Store values needed for axis scaling
	if strcmp(plotType, 'profile')
		minVals(i) = min(valueToPlot(bottomIndex:topIndex));
		maxVals(i) = max(valueToPlot(bottomIndex:topIndex));
	elseif strcmp(plotType, 'timeseries')
		minVals(i) = min(valueToPlot(t_start_index:t_end_index));
		maxVals(i) = max(valueToPlot(t_start_index:t_end_index));
	end

	%Set the text for the legend
	legendText(i,1:size(lineName,2)) = lineName;
end

%Add a legend and scale the axis
if strcmp(plotType, 'profile')	
	ProfileFunctions.setTitle(plotTitle);
	ProfileFunctions.setAxisLabels(plotUnits, 'Height [m]'); 
	ProfileFunctions.setAxis(min(minVals), max(maxVals), startHeight, endHeight);
        if(dispLegend == 1)
		ProfileFunctions.addLegend(lines, legendText);
	end
elseif strcmp(plotType, 'timeseries')		
	TimeseriesFunctions.setTitle(plotTitle);
	TimeseriesFunctions.setAxisLabels('Time [min]', plotUnits); 	
	TimeseriesFunctions.setAxis(min(minVals), max(maxVals), startTime, endTime);
	if(dispLegend == 1)
		TimeseriesFunctions.addLegend(lines, legendText);
	end
end

%Output the EPS file
%mkdir([ '/tmp/', 'output_', int2str(tickCount)]);
output_file_name = [ '/tmp/', 'output_', int2str(tickCount), '/', caseName, '_', int2str(plotNum), '.eps' ];
print( '-depsc2', output_file_name );
close;
