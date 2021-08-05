%main Demonstration Script for Object-Oriented Data Management
%   This script shows some of the simple uses of the
%   DynoTestData class.
clear; clc; close all;

% load and format the data
datasetHandler = DynoTestData('61410004 Test Data.txt');

% plot a single time series plot
datasetHandler.plotSingleTimeseries('engine speed')

% plot multiple timeseries plots together
datasetHandler.plotMultipleTimeseries({'fuel flow rate', 'engine coolant temp', 'engine oil temp'})
