function [ Clusters, Results ] = DDC_ver01_1_CAMS( varargin )
%% Start Main Function
if size(varargin,2)<4
    sprintf('Input error - not enough inputs.')
    return
end
DataIn=varargin{1}; % Read Array of Data
InitR=varargin{2}; % Read Initial Radius
Verbose=varargin{4}; % Read flag for plotting during the run
Merge=varargin{3}; % Read flag for merging final clusters
%% Initialise
if size(InitR,2)==1 % create equal radii across each domension if only one provided
    if Verbose==1
    sprintf('Using equal radii')
    end
    InitR=ones(size(DataIn,2),1)*InitR;
elseif size(InitR,2)<size(DataIn,2)
    sprintf('Radii not single or equal to data dimensions')
    return
end
NumClusters=0; % initial number of clusters
Results=zeros(size(DataIn,1),size(DataIn,2)+1); % initiate empty array

%% ### DDC routine ###
Glob_Mean=mean(DataIn,1); % array of means of data dim
Glob_Scalar=sum(sum((DataIn.*DataIn),2),1)/size(DataIn,1); % array of scalar products for each data dim

while size(DataIn,1)>0
    % size(DataIn,1) % uncomment to trace remaining data
    NumClusters=NumClusters+1;
    Clusters.Rad(NumClusters,:)=InitR;
    %% Find Cluster Centre
    Glob_Mean=mean(DataIn,1); % array of means of data dim
    Glob_Scalar=sum(sum((DataIn.*DataIn),2),1)/size(DataIn,1); % array of scalar products for each data dim
    GDensity=pdist2(DataIn,Glob_Mean,'euclidean').^2 + Glob_Scalar - sum(Glob_Mean.^2); % calculate global densities
    [~, CentreIndex]=min(GDensity); % find index of max densest point
  
    %% Find points belonging to cluster
    Include=bsxfun(@minus,DataIn,DataIn(CentreIndex,:)).^2; % sum square of distances from centre
    RadSq=Clusters.Rad(NumClusters,:).^2; % square radii
    Include=sum(bsxfun(@rdivide,Include,RadSq),2); % divide by radii and add terms
    Include=find(Include<1);
    
    %% Remove outliers >3sigma
    Dist=pdist2(DataIn(Include,:),DataIn(CentreIndex,:)); % distances to all potential members
    Include=Include(abs(Dist - mean(Dist) <= 3*std(Dist))==1,:); % keep only indices of samples with 3 sigma

    %% Move cluster centre to local densest point
    LocMean=mean(DataIn(Include,:),1);
    LocScalar=sum((DataIn(Include,:).^2),2)/size(Include,1); % array of scalar products of data dims
    LocDens=pdist2(DataIn(Include,:),LocMean,'euclidean').^2 + LocScalar - sum(LocMean.^2); % calculate local densities
    [~,CentreIndex]=min(LocDens);
    CentreIndex=Include(CentreIndex);
    Clusters.Centre(NumClusters,:)=DataIn(CentreIndex,:); % assign cluster centre
    
    %% Assign data to new centre
    Include=bsxfun(@minus,DataIn,Clusters.Centre(NumClusters,:)).^2; % sum square of distances from centre
    RadSq=Clusters.Rad(NumClusters,:).^2; % square radii
    Include=sum(bsxfun(@rdivide,Include,RadSq),2); % divide by radii and add terms
    Include=find(Include<1);

    %% Remove outliers >3sigma
    Dist=pdist2(Clusters.Centre(NumClusters,:),DataIn(Include,:)); % distances to all potential members
    Include=Include(abs(Dist - mean(Dist) <= 3*std(Dist))==1,:); % keep only indices of samples with 3 sigma

    %% Update radii to maximum distances
    for idx=1:size(DataIn,2)
        value01=pdist2(DataIn(Include,idx),Clusters.Centre(NumClusters,idx),'Euclidean');
        if max(value01)>0
            Clusters.Rad(NumClusters,idx)=max(value01);
        end
    end
    
    %% Assign data to cluster based on new radii
    Include=bsxfun(@minus,DataIn,Clusters.Centre(NumClusters,:)).^2; % sum square of distances from centre
    RadSq=Clusters.Rad(NumClusters,:).^2; % square radii
    Include=sum(bsxfun(@rdivide,Include,RadSq),2); % divide by radii and add terms
    Include=find(Include<1);
 
    %% Remove outliers >3sigma
    Dist=pdist2(Clusters.Centre(NumClusters,:),DataIn(Include,:)); % distances to all potential members
    Include=Include(abs(Dist - mean(Dist) <= 3*std(Dist))==1,:); % keep only indices of samples with 3 sigma
    
    %% Update radii to maximum distances
    
    for idx=1:size(DataIn,2)
        value01=pdist2(DataIn(Include,idx),Clusters.Centre(NumClusters,idx),'Euclidean');
        if max(value01)>0
            Clusters.Rad(NumClusters,idx)=max(value01);
        else
%             Clusters.Rad(NumClusters,idx)=DefaultRadii(idx);
        end
    end
 
    %% Plot
    if Verbose==1
        hold off;scatter(DataIn(:,1),DataIn(:,2));hold on
        scatter(DataIn(CentreIndex,1),DataIn(CentreIndex,2),'r')
        scatter(DataIn(Include,1),DataIn(Include,2),'g');
        scatter(Clusters.Centre(NumClusters,1),Clusters.Centre(NumClusters,2),'*','r')
        title(sprintf('Clustered: %i, Remaining: %i',size(Results,1)-size(DataIn,1), size(DataIn,1)))
        axis([0 1 0 1])
        drawnow
        for zz=1:size(Clusters.Centre,1)
            rectangle('Position',[Clusters.Centre(zz,1)-Clusters.Rad(zz,1), Clusters.Centre(zz,2)-Clusters.Rad(zz,2), 2*Clusters.Rad(zz,1), 2*Clusters.Rad(zz,2)],'Curvature',[1,1])
        end
    end
    %% Assign data to final clusters
    StartIdx=find(all(Results==0,2),1,'first');
    EndIdx=StartIdx+size(Include,1)-1;
    Results(StartIdx:EndIdx,:)=[DataIn(Include,:),ones(size(Include,1),1)*NumClusters];
    DataIn(Include,:)=[]; % remove clustered data
end

%% Merge clusters if centre is within another cluster
if Merge==1;
MergeAny=1;
    while MergeAny==1
        if Verbose==1
            figure(2)
            clf
            for zz=1:size(Clusters.Centre,1)
                rectangle('Position',[Clusters.Centre(zz,1)-Clusters.Rad(zz,1),...
                    Clusters.Centre(zz,2)-Clusters.Rad(zz,2), 2*Clusters.Rad(zz,1),...
                    2*Clusters.Rad(zz,2)],'Curvature',[1,1])
            end
            hold on
            scatter(Clusters.Centre(:,1),Clusters.Centre(:,2),'*','r')
            drawnow
        end

        MergeAny=0;
        Merges=[];
        % for each cluster & find if cluster centre is within other clusters
        for idx1=1:size(Clusters.Centre,1); 
            InEll=bsxfun(@minus,Clusters.Centre,Clusters.Centre(idx1,1:end)).^2;
            InEll=sum(bsxfun(@rdivide,InEll,Clusters.Rad(idx1,:).^2),2); % divide by rad^2 & add
            InEll=(InEll<1);
            Merges(idx1,:)=InEll.';
        end
        Merges(logical(eye(size(Merges))))=0;
        % Merge clusters
        for idx=1:size(Clusters.Centre,1)
            [~,idx1]=find(Merges(idx,:),1);
            Results(ismember(Results(:,end),idx1),end)=idx;
            if idx1
                MergeAny=1;
            end
        end
        %% renumber clusters
        [C,~,ic]=unique(Results(:,end));
        C=1:size(C,1);
        Results(:,end)=C(ic);
        %% Re-create cluster data
        Clusters.Centre=[];
        Clusters.Rad=[];
        for idx1=1:max(Results(:,end))
            Clusters.Centre(idx1,:)=mean(Results(Results(:,3)==idx1,1:end-1),1);
            for idx2=1:size(Results,2)-1
                value01=pdist2(Results(Results(:,3)==idx1,idx2),Clusters.Centre(idx1,idx2),'Euclidean');
                if max(value01)>0
                    Clusters.Rad(idx1,idx2)=max(value01);
                else
                    Clusters.Rad(idx1,idx2)=0;
                end
            end
        end

    end
end

end % end function