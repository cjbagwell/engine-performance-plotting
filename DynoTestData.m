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
            if ~isKey(obj.data, key)
                possibleKeys = obj.data.keys();
                em = sprintf("The key %s was not found.  Possible key choices are:\n", key);
                em2 = sprintf("'%s', ",possibleKeys{:});
                ME = MException('MyComponent:noSuchKey', strcat(em, em2));
                throw(ME)
            end
            plot(obj.data('time'), obj.data(key))
            xlim([0, max(obj.data('time'))])
            xlabel(obj.labels('time'))
            ylabel(obj.labels(key))
            title(strcat(key,' vs time'))
        end
    end
end

