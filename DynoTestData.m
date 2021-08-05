classdef DynoTestData
    %DynoTestData A simple class for dynamometer test analysis
    %   This simple class manages all of the data associated with a
    %   dynamometer test.  It contains a constructor for populating the
    %   property fields as well as methods for quickly visualizing any test
    %   results.
    
    properties (SetAccess = private, GetAccess = public)
        labels
        data
    end
    
    methods (Access = private)
        function validateKey(obj, key)
            %validateKey Validates that a key exists
            % This method validates the key parameter to ensure that it
            % exists.  If not this method throws a noSuchKey exception.
            if ~isKey(obj.data, key)
                possibleKeys = obj.data.keys();
                em = sprintf("The key %s was not found.  Possible key choices are:\n", key);
                em2 = sprintf("'%s', ",possibleKeys{:});
                ME = MException('MyComponent:noSuchKey', strcat(em, em2));
                throw(ME)
            end
        end
    end
    
    methods
        function obj = DynoTestData(fileName)
            %DynoTestData Construct an instance of DynoTestData
            %   This constructor reads in the file 'fileName' which should
            %   contain data from a dynamometer test.  The first row in the
            %   file should contain the data headers, and the columns
            %   should store the data in this order and format:
            %
            %   1.  Time[sec]
            %   2.  Dyno_Speed[mph]
            %   3.  Dyno_Tractive_Effort[N]
            %   4.  Test_Cell_Temp[C]
            %   5.  Test_Cell_RH[%]
            %   6.  Phase_#
            %   7.  Engine_Speed[rpm]
            %   8.  Fuel_Flow_Bench_Modal[g/s]
            %   9.  Engine_Coolant_Temp[C]
            %   10. Engine_Oil_Temp[C]
            
            fptr = fopen(fileName);
            labelsTemp = textscan(fptr, '%s %s %s %s %s %s %s %s %s %s', 1);
            keys = {'time', 'dyno speed', 'tractive effort', 'testCellTemp', ...
                'test cell RH', 'phase number', 'engine speed', 'fuel flow rate', ...
                'engine coolant temp', 'engine oil temp'};
            obj.labels = containers.Map(keys, labelsTemp);
            
            dataTemp = textscan(fptr, '%f %f %f %f %f %f %f %f %f %f', 'Headerlines', 1);
            obj.data = containers.Map(keys, dataTemp);
            fclose(fptr);
        end
        
        function plotSingleTimeseries(obj, key)
            %plotSingleTimeseries Plots an individual test metric
            %   This method plots an individual test metric from the test
            %   data.  For example, to have a time series plot of engine
            %   speed during the test you would use
            %   "obj.plotSingleTimeseries('engine speed')"
            
            obj.validateKey(key);
            plot(obj.data('time'), obj.data(key))
            xlim([0, max(obj.data('time'))])
            xlabel(obj.labels('time'))
            ylabel(obj.labels(key), 'Interpreter', 'None')
            title(strcat(key,' vs time'))
        end
        
        function plotMultipleTimeseries(obj, keys)
            %plotMultipleTimeseries Plots a time series of all plots
            %   This method plots multiple time series plots on the same
            %   figure.  All datapoints associated with the cell of strings
            %   'keys' will be plotted together.  The leftmost y axis will
            %   display tick marks for the first key, and the rightmost y
            %   axis will be used for all other plots.
            
            figure
            hold on
            xlim([0, max(obj.data('time'))])
            xlabel(obj.labels('time'))
            yyaxis left
            
            % Plot Data
            for i = 1:length(keys)
                if i ~= 1
                    yyaxis right
                end
                key = string(keys(i));
                obj.validateKey(key);
                plot(obj.data('time'), obj.data(key))
            end
            
            % Create Legend
            for i = 1:length(keys)
               legendLabels(i) = obj.labels(string(keys(i)));
            end
            legend(legendLabels, 'Interpreter', 'none')
            
            % Create Title
            plotTitle = keys(1);
            for i = 2:length(keys)
                plotTitle = strcat(plotTitle,sprintf(" and %s", string(keys(i))));
            end
            plotTitle = strcat(plotTitle, " vs time");
            title(plotTitle);
        end % function
    end % methods
end % classdef

