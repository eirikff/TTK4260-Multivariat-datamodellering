%% ---------------------- DESIGN LSTM NN ----------------------------------
%--------------------Load data, Choose network topology--------------------

%--- DATA:{
% Required data for this program: Dat_TK8117_OSL.mat
%.........................................................................}

%% ----------------------- Network Architecture ---------------------------
clearvars
load('Dat_TK8117_OSL.mat')
data = DataOSLS2(:,1)';
TrDatFrac = 0.9;

numTimeStepsTrain = floor(TrDatFrac*numel(data));
dataTrain = data(1:numTimeStepsTrain+1);
dataTest = data(numTimeStepsTrain+1:end);
mu = mean(dataTrain);
sig = std(dataTrain);

% z-score data
dataTrainStandardized = (dataTrain - mu) / sig;
XTrain = dataTrainStandardized(1:end-1);
YTrain = dataTrainStandardized(2:end);

% Architecture
numFeatures = 1;
numResponses = 1;
numHiddenUnits = 5; % nominal 200

layers = [ ...
    sequenceInputLayer(numFeatures)
    lstmLayer(numHiddenUnits)
    fullyConnectedLayer(numResponses)
    regressionLayer];

options = trainingOptions('adam', ...      % nominal adam,sgdm
    'MaxEpochs',150, ...                   % nominal 250
    'GradientThreshold',1, ...
    'InitialLearnRate',0.005, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropPeriod',125, ...
    'LearnRateDropFactor',0.2, ...
    'Verbose',0, ...
    'Plots','training-progress');

% Train the net
net = trainNetwork(XTrain,YTrain,layers,options);
%% ------------------- Assign standardized Test Data ----------------------
dataTestStandardized = (dataTest - mu) / sig;
XTest = dataTestStandardized(1:end-1);
YTest = dataTest(2:end);
%% -------------- Use the net to predict several time steps ---------------
net = predictAndUpdateState(net,XTrain);
spi= YTrain(end);
[net,YPred] = predictAndUpdateState(net,spi);

% numTimeStepsTest = numel(XTest);
numTimeStepsTest = 24;
YTest = dataTest(2:25);

for i = 2:numTimeStepsTest
    [net,YPred(:,i)] = predictAndUpdateState(net,YPred(:,i-1),...
        'ExecutionEnvironment','cpu');
end

% De-standardixe the values
YPred = sig*YPred + mu;


rmse = sqrt(mean((YPred-YTest).^2))

figure
plot(dataTrain(1:end-1))
hold on
idx = numTimeStepsTrain:(numTimeStepsTrain+numTimeStepsTest);
plot(idx,[data(numTimeStepsTrain) YPred],'.-')
hold off
xlabel("Hour")
ylabel("Load")
title("Forecast")
legend(["Observed" "Forecast"])

figure
subplot(2,1,1)
plot(YTest)
hold on
plot(YPred,'.-')
hold off
legend(["Observed" "Forecast"])
ylabel("Cases")
title("Forecast")

subplot(2,1,2)
stem(YPred - YTest)
xlabel("Hour")
ylabel("Error")
title("RMSE = " + rmse)
%% --------------- Use the net to predict ONE time step -------------------
YTest = dataTest(2:end);
net = resetState(net);
net = predictAndUpdateState(net,XTrain);

YPred = [];
numTimeStepsTest = numel(XTest);
for i = 1:numTimeStepsTest
    [net,YPred(:,i)] = predictAndUpdateState(net,XTest(:,i),...
        'ExecutionEnvironment','cpu');
end

% De-standardixe the values
YPred = sig*YPred + mu;

rmse = sqrt(mean((YPred-YTest).^2))

figure
plot(dataTrain(1:end-1))
hold on
idx = numTimeStepsTrain:(numTimeStepsTrain+numTimeStepsTest);
plot(idx,[data(numTimeStepsTrain) YPred],'-')
hold off
xlabel("Hour")
ylabel("Load")
title("Forecast")
legend(["Observed" "Forecast"])

figure
subplot(2,1,1)
plot(YTest)
hold on
plot(YPred,'.-')
hold off
legend(["Observed" "Predicted"])
ylabel("Load")
title("Forecast with Updates")

subplot(2,1,2)
stem(YPred - YTest)
xlabel("Hour")
ylabel("Error")
title("RMSE = " + rmse)