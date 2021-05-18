function tModel = CreateModelFromParameters( afParameters )
	%
	tModel.fPhiFatiguedToActive	= afParameters(1);
	tModel.fPhiActiveToFatigued	= afParameters(2);
	tModel.fPhiRestedToActive	= afParameters(3);
	tModel.fPhiActiveToRested	= afParameters(4);
	%
	tModel.fTotalMuscularUnits	= 30;
	%
end % function

