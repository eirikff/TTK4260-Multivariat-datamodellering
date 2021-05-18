%% ------------------------ CLUSTERING ANALYSIS ---------------------------

%--- DATA:{
% Required data for this program: Dat_TK8117_OSL.mat
%.........................................................................}

%--- INPUTS:{
% Name            ||| (Explanation)
%-----------------------------------------------------------------
% cluster_number  ||| Desired number of clusters
% task_sel        ||| Select task to perform 
%                 ||| [1]: k-means, [2]: Hierarchical, [3]: Elbow
%.........................................................................}

%% --------------------------- DATA IN ------------------------------------
close all;
clearvars;
load('Dat_TK8117_OSL');
X=load_daily';
prompt0 = 'Choose task ([1]: k-means | [2]: Hierarchical | [3]: Elbow): ';
task_sel = input(prompt0);

if task_sel == 1 || task_sel == 2
    prompt1 = 'Give cluster number: ';
    cluster_number = input(prompt1);
else
    cluster_number = 20;
end

replicates_mnr=100;
tplot=1:24;
clr=zeros(cluster_number,3);
for i=1:cluster_number
    s1 = {'Region'};
    s2 = {num2str(i)};
    lgd(i)=strcat(s1,s2);
    clr=jet(cluster_number);
end
if task_sel == 1
%% ---------------------- K-MEANS CLUSTERING ------------------------------
    [idx,C,sumDist1] = kmeans(X,cluster_number,'Distance','sqeuclidean');
    
    figure;
    for i=1:cluster_number
        p{i} = plot(tplot,X(idx==i,:),'.-','Color',clr(i,:),'MarkerSize',12);
        hold on
    end
    plot(tplot,C(:,:),'k-',...
        'MarkerSize',15,'LineWidth',2)
    title(['Clustered Loads, 1 initialization, Sum of Distances '...
        num2str(sum(sumDist1))]);
    xlabel('time [h]');ylabel('Load');
    xlim([1 24]);
    grid on;
    for j=1:cluster_number
        lgd0(1,j) = p{1,j}(1,:);
    end
    legend(lgd0,lgd);
    hold off
    
    % Choose best out of many intiializations
    opts = statset('Display','final');
    [idx,C,sumDistRep] = kmeans(X,cluster_number,'Distance',...
        'sqeuclidean','Replicates',replicates_mnr,'Options',opts);
    
    figure;
    for i=1:cluster_number
        p{i} = plot(tplot,X(idx==i,:),'.-','Color',clr(i,:),'MarkerSize',12);
        hold on
    end
    plot(tplot,C(:,:),'k-',...
        'MarkerSize',15,'LineWidth',2)
    title(['Clustering after ' num2str(replicates_mnr) ...
        ' initializations, Sum of Distances ' num2str(sum(sumDistRep))]);
    xlabel('time [h]');ylabel('Load');
    xlim([1 24]);
    grid on;
    for j=1:cluster_number
        lgd0(1,j) = p{1,j}(1,:);
    end
    legend(lgd0,lgd);
    hold off
    % Plot Individual clusters
    for i=1:cluster_number
        figure;
        plot(tplot,X(idx==i,:),'.-','Color',clr(i,:),'MarkerSize',12);
        
        xlabel('time [h]');ylabel('Load');
        legend(lgd(i));
        title(['Clusted group of load curves ' num2str(i)]);
        xlim([1 24]);
        grid on;
    end
elseif task_sel == 3
%% -------------------------- ELBOW PLOT  ---------------------------------
    for it=1:1:cluster_number
        % Choose best out of many intiializations
        opts = statset('Display','final');
        [idx,C,sumdistN] = kmeans(X,it,'Distance','sqeuclidean',...
            'Replicates',replicates_mnr,'Options',opts);
        elbow_y(it)=sum(sumdistN);
        elbow_x(it)=it;
    end
    
    figure;
    scatter(elbow_x,elbow_y);
    title 'Elbow Plot'
    xlabel('Number of Clusters');
    ylabel('Total sum of squared distances inside the clusters');
elseif task_sel == 2
%% ---------------------HIERARCHICAL CLUSTERING ---------------------------
    Z = linkage(X,'ward','euclidean');
    T = cluster(Z,'maxclust',cluster_number);
    
    figure;
    cutoff = median([Z(end-cluster_number+1,3) Z(end-cluster_number+2,3)]);
    dendrogram(Z,'ColorThreshold',cutoff)
    
    figure;
    for i=1:cluster_number
        ph{i} = plot(tplot,X(T==i,:),'.-','Color',clr(i,:),'MarkerSize',12);
        hold on
    end
    
    title('Hierarchical Clustering visualization');
    xlabel('time [h]');ylabel('Load');
    xlim([1 24]);
    grid on;
    for j=1:cluster_number
        lgd1(1,j) = ph{1,j}(1,:);
    end
    legend(lgd1,lgd);
    hold off
    %Plot Individual clusters
    for i=1:cluster_number
        figure;
        plot(tplot,X(T==i,:),'.-','Color',clr(i,:),'MarkerSize',12);        
        xlabel('time [h]');ylabel('Load');
        legend(lgd(i));
        title(['Clusted group of load curves ' num2str(i)]);
        xlim([1 24]);
        grid on;
    end
else
    disp('Please run again and give input 1, 2 or 3 ');
end
%% ------------------------- PROGRAM END ----------------------------------