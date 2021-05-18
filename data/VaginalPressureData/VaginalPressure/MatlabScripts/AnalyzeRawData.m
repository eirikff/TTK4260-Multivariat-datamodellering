% first, check the raw data as time series
figure('name','sensor readings for player A','units','normalized','outerposition',[0 0 1 1])
plot(PlayerA(:,1:8)) % plot only the sensors readings
figure('name','sensor readings for player B','units','normalized','outerposition',[0 0 1 1])
plot(PlayerB(:,1:8)) % plot only the sensors readings

%% ------------------------------------------------------------------------
% shall we remove the useless data? In other words, shall we do
% PlayerA = PlayerA(:,2:8);
% PlayerB = PlayerB(:,1:8);
% ?
% non-trivial issue, though: how may we do if we want to compare data with different dimension?
% => decision = keep the same data because we want at the end to do comparisons
PlayerA = PlayerA(:,1:8);
PlayerB = PlayerB(:,1:8);

%% ------------------------------------------------------------------------
% shall we also rescale the data? This may lead to better visualization
%
% alternative proposals:
% - mean
% - mode
% - min
%
for iSensor = 1:8;
	PlayerA(:,iSensor) = PlayerA(:,iSensor) - mode( PlayerA(:,iSensor) );
	PlayerB(:,iSensor) = PlayerB(:,iSensor) - mode( PlayerB(:,iSensor) );
end %
%
figure('name','sensor readings for player A','units','normalized','outerposition',[0 0 1 1])
plot(PlayerA(:,1:8)) % plot only the sensors readings
figure('name','sensor readings for player B','units','normalized','outerposition',[0 0 1 1])
plot(PlayerB(:,1:8)) % plot only the sensors readings

%% ------------------------------------------------------------------------
% let's look at the data in a different way
figure('name','3','units','normalized','outerposition',[0 0 1 1])
tSurface = surf(PlayerA(1:100,:));
tSurface.EdgeColor = 'none';
view(90,90);
figure('name','4','units','normalized','outerposition',[0 0 1 1])
tSurface = surf(PlayerB(1:100,:));
tSurface.EdgeColor = 'none';
view(90,90);

%% ------------------------------------------------------------------------
% intuition: PCA may remove these differences, and the persons may just be "offsets" of each other
[UA, SA, VA] = svd(PlayerA');
[UB, SB, VB] = svd(PlayerB');
%
% compare the first components
for iComponent = 1:3
	strFigureName = sprintf('Comparison of PC %d', iComponent);
	figure('name',strFigureName,'units','normalized','outerposition',[0 0 1 1])
	plot(UA(:,iComponent), 'r')
	hold on
	plot(UB(:,iComponent), 'k')
	legend('player A', 'player B')
	hold off
end %

