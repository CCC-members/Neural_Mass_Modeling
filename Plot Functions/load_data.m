%% Access to the generated data and create tensor with the information for each run

Run_address = 'D:\OneDrive - CCLAB\PhD research\Projects\new Corticothalamic Simulation\Output\Connectivity Study\Shuffle';
dirRun = dir(Run_address);
Run_isub = [dirRun(:).isdir]; %# returns logical vector
Run_nameFolds = {dirRun(Run_isub).name}';
Run_nameFolds(ismember(Run_nameFolds,{'.','..'})) = [];

% Accessing to Run folders
for i=31:length(Run_nameFolds)   % itrarting in Run folders
    Run_dirName =strcat(Run_address,'\',Run_nameFolds{i}); %\
    dirConnectivity = dir(Run_dirName);
    Connectivity_isub = [dirConnectivity(:).isdir]; %# returns logical vector
    Connectivity_nameFolds = {dirConnectivity(Connectivity_isub).name}';
    Connectivity_nameFolds(ismember(Connectivity_nameFolds,{'.','..'})) = [];

    % Ordering Connectivity folders
    for k=1:length(Connectivity_nameFolds)     % iterating in Connectivity folders
        idx_C=strfind(Connectivity_nameFolds{k,1},'_');
        tempConnectivityDouble(k) = str2double(Connectivity_nameFolds{k,1}(idx_C(end)+1:end));
    end
    [~,idxConnnectivity]=sort(tempConnectivityDouble);
    Connectivity_nameFolds = Connectivity_nameFolds(idxConnnectivity);

    % Reading Connectivity folders
    for connex=1:length(Connectivity_nameFolds)
        ind_Connectivity_dirName = strcat(Run_dirName,'\',Connectivity_nameFolds{connex});%\
        Delay_nameFolds = getAllFiles(ind_Connectivity_dirName);

        % Ordering Delay files
        for d=1:length(Delay_nameFolds)     % iterating in Connectivity folders
            idx_D=strfind(Delay_nameFolds{d,1},'_');
            tempDelayDouble(d) = str2double(Delay_nameFolds{d,1}(idx_D(end)+1:end-4));%-4 because .mat
        end
        [~,idxDelay]=sort(tempDelayDouble);
        Delay_nameFolds = Delay_nameFolds(idxDelay);
        
        % Loading Delay files
        for delay=1:length(Delay_nameFolds)
            load(Delay_nameFolds{delay,1}, 'Z');
            Zpyr(delay,connex,:) = Z(1,:); 
        end
    end
    save('Zpyr_Run'+string(i)+'.mat','Zpyr')  % Saving generated data in each Run
end
