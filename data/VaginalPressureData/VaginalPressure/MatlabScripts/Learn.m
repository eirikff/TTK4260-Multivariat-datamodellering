% algorithm:
%
% - allocate the necessary stuff
% - execute the optimization step and check how it exited
% - copy the learned parameters
%
function tLearnedModel =						...
			Learn(	afMeasuredPressureLevels,	...
					abMeasuredActivityZones		)
	%
	% select the options for the numerical optimization step
	tOptions = optimset('MaxIter',		5000,	...
						'MaxFunEvals',	5000	);
	%
	% get an initial guess of the to-be-learned parameters
	afInitialParametersGuess = zeros( 4, 1 );
	%
	% select which cost function to be used
	tHandleToCostFunction = @L2;
%	tHandleToCostFunction = @RegularizedL2;
	%
	% compute the best guess for the parameters
    [	afEstimatedModelParameters,				...
		fFinalCostValue,						...
		iExitFlag,								...
		tMessagesFromTheOptimizer	] =			...
			fminsearch(							...
				tHandleToCostFunction,			...
				afInitialParametersGuess,		...
				tOptions,						...
				afMeasuredPressureLevels,		...
				abMeasuredActivityZones			);
	%
	% check what happened in the optimization process
	switch iExitFlag
		%
		case 1
			% everything fine
		%
		case 0
			warning('the minimization process was terminated earlier than convergence because of reaching the MAXITER limit. Maybe consider increasing the MAXITER value in the default parameters.');
		%
		case -1
			warning('something wrong happened in the computation of the cost function. Debug it!')
		%
		otherwise
			error('unsupported exit flag')
		%
	end;% checking what happened in the optimization process
	%
	% create the auxiliary structure
	tLearnedModel = CreateModelFromParameters( afEstimatedModelParameters );
	%
tLearnedModel.fPhiFatiguedToActive = 0.9416;
tLearnedModel.fPhiActiveToFatigued = 0.5639;
tLearnedModel.fPhiRestedToActive = 0.2007;
tLearnedModel.fPhiActiveToRested = 0.9252;
	%
	% DEBUG
	fprintf('finished learning the model!\n');
	fprintf('\ttLearnedModel.fPhiFatiguedToActive = %.3f\n', tLearnedModel.fPhiFatiguedToActive);
	fprintf('\ttLearnedModel.fPhiActiveToFatigued = %.3f\n', tLearnedModel.fPhiActiveToFatigued);
	fprintf('\ttLearnedModel.fPhiRestedToActive   = %.3f\n', tLearnedModel.fPhiRestedToActive);
	fprintf('\ttLearnedModel.fPhiActiveToRested   = %.3f\n', tLearnedModel.fPhiActiveToRested);
	fprintf('\ttLearnedModel.fTotalMuscularUnits  = %.3f\n', tLearnedModel.fTotalMuscularUnits);
	%
	figure(10912)
	afSimulatedPressureLevels = Simulate( tLearnedModel, 0, 0, abMeasuredActivityZones );
	plot(afMeasuredPressureLevels, 'k')
	hold on
	plot(afSimulatedPressureLevels, 'r')
	plot(abMeasuredActivityZones, 'g')
	hold off
	%
end % function

