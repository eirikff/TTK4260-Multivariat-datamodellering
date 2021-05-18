% how shall we define m_a(t) and u(t)?
%
% potential choices:
% - average signal
% - "max" signal
% - loading of first component
% - average loading of first n components
m_a_AMean		= mean( PlayerA(:, 1:8), 2 );
m_a_AMax  		= max( PlayerA(:, 1:8), [], 2 );
m_a_ALoading	= UA(:,1)' * ( PlayerA(:, 1:8)' );
%
% figure('name','comparison of different potential m_a signals','units','normalized','outerposition',[0 0 1 1])
% plot(m_a_AMean, 'k')
% hold on
% plot(m_a_AMax, 'r')
% plot(m_a_ALoading, 'b')
% legend('mean', 'max', 'loading')
% hold off

% %%
% % let's choose the first loading, just to use the PCA
% % m_a_A = -m_a_ALoading;
% m_a_A = m_a_AMean;
% %
% % compute also the u(t)
% u_A = ( abs(m_a_A) > 0.5 );
% %
% % figure('name','chosen m_a and u signals','units','normalized','outerposition',[0 0 1 1])
% % plot(m_a_A, 'k')
% % hold on
% % plot(u_A, 'r')
% % legend('m_a', 'u')
% % hold off
% 
% %%
% % estimate the parameters
% tLearnedModelA = Learn( m_a_A, u_A );
% % tLearnedModelA.fPhiFatiguedToActive = 0.9637
% % tLearnedModelA.fPhiActiveToFatigued = 0.8602
% % tLearnedModelA.fPhiRestedToActive = 0.4267
% % tLearnedModelA.fPhiActiveToRested = 0.7231
% %
% % check the simulation performance in training:
% % first, simulate the signal
% simulated_m_a_A = Simulate( tLearnedModelA, 0, m_a_A(1), u_A );
% %
% % then plot it
% figure('name','simulated m_a_A','units','normalized','outerposition',[0 0 1 1])
% plot(m_a_A, 'k')
% hold on
% plot(simulated_m_a_A, 'b')
% plot(u_A, 'r')
% legend('m_a', 'simulated m_a', 'u')
% hold off
% 
