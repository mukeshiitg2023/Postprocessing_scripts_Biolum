function [fileNames, timeSeries] = processCSV(fileWildCard,gridLocation)

temp = dir('allTracks');
fileNames = {};
counter = 0;

for ind = 1:length(temp)
    name = temp(ind).name;
    if(length(name)>=length(fileWildCard) & strcmp(name(1:length(fileWildCard)),fileWildCard) & strcmp(name(end-2:end),'csv'))
        counter = counter+1;
        fileNames{counter} = name;
    end
end

dataStruct.x = [];
dataStruct.y = [];
dataStruct.z = [];
dataStruct.traction = [];
dataStruct.particleID = [];
dataStruct.reasonForTermination = [];

%maxTrac = zeros(100,1);
%curTrac = maxTrac;
%ana = 1e6;
for ind = 1:length(fileNames)
    temp2 = importdata(['allTracks/',fileNames{ind}]);
    temp = temp2.data;
    dataStruct(ind).x = temp(:,end-2);
    dataStruct(ind).y = temp(:,end-1);
    dataStruct(ind).z = temp(:,end);
    dataStruct(ind).particleID = temp(:,end-3);
    dataStruct(ind).reasonForTermination = temp(:,end-4);
    dataStruct(ind).traction = sqrt(temp(:,13).^2 + temp(:,14).^2 + temp(:,15).^2);
    %curTrac(1:length(dataStruct(ind).traction)) = dataStruct(ind).traction;
    %maxTrac = max(curTrac,maxTrac)
    %curTrac = curTrac*0;
    %ana = min(ana,length(temp(:,16)));
    %plot(maxTrac); title(['ind = ',num2str(ind)])
    %scatter3(dataStruct(ind).x, dataStruct(ind).y, dataStruct(ind).z)
    %hold on
    %nParticles = length(dataStruct(ind).x)
end

keepIndex = find(dataStruct(end).reasonForTermination == 1);
keepIDs = dataStruct(end).particleID(keepIndex);
    
for ind = 1:length(dataStruct)
    % Can't think of an elegant way to do this right now
    localIDs = [];
    localIndex = [];
    for innerInd = 1:length(dataStruct(ind).particleID)
        currentID = dataStruct(ind).particleID(innerInd);
        if(any(keepIDs==currentID))
            localIDs = [localIDs, currentID];
            localIndex = [localIndex, innerInd];
        end
    end
    [~,indID] = sort(localIDs);
    keepIndices = localIndex(indID);
    
    timeSeries(:,ind,1) = dataStruct(ind).x(keepIndices);
    timeSeries(:,ind,2) = dataStruct(ind).y(keepIndices);
    timeSeries(:,ind,3) = gridLocation - dataStruct(ind).z(keepIndices);
    timeSeries(:,ind,4) = dataStruct(ind).particleID(keepIndices);
    timeSeries(:,ind,5) = dataStruct(ind).traction(keepIndices);
    fileNames{ind}
    %figure; plot3(timeSeries(35,:,1),timeSeries(35,:,2),timeSeries(35,:,3)); axis equal; grid on
end
