function data = sgLoadData(myDirectory)
%sgLoadData Summary of this function goes here
%   Detailed explanation goes here
prompt = 'Enter Participant Number: ';
pNum = input(prompt);

sgParticipants = setdiff({myDirectory([myDirectory.isdir]).name}, {'.','..'});
ds = tabularTextDatastore(sgParticipants{pNum},'IncludeSubfolders',true,'FileExtensions','.csv');

idx = ismember(ds.VariableNames,["name","time","activity","pitch","roll"]);
ds.SelectedVariableNames = ds.VariableNames(idx);

dsFormats = string(ds.SelectedFormats);
dsFormats(1) = "%C";  
ds.SelectedFormats = dsFormats;

data = readall(ds);
data.time = datetime(uint64(data.time)/1e9, 'ConvertFrom', 'posixtime', 'Format', 'dd-MMM-yyyy HH:mm:ss');

data(ismember(data.activity,-1),:)=[];
data = table2timetable(data);
end

