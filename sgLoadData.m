function data = sgLoadData(myDirectory)
%sgLoadData loads required Participant data for pre-processing tasks
%   The input variable is the working directory with glove data for all
%   participants. The output is a timetable consisting of a observation
%   timestamp, glove name, activity number, pitch and roll values. 

%Prompt user to enter participant number 
prompt = 'Enter Participant Number: ';
pNum = input(prompt);

%Use directory and set operations to obtain name of subfolders
sgParticipants = setdiff({myDirectory([myDirectory.isdir]).name}, {'.','..','.git'});
%Create a tabular text datastore of all raw data for selected participant
ds = tabularTextDatastore(sgParticipants{pNum},'IncludeSubfolders',true,'FileExtensions','.csv');

%Filter columns required for further analysis and reassing to datastore
idx = ismember(ds.VariableNames,["name","time","activity","pitch","roll"]);
ds.SelectedVariableNames = ds.VariableNames(idx);

%Convert formatting of name column in datastore to type categorical
dsFormats = string(ds.SelectedFormats);
dsFormats(1) = "%C";  
ds.SelectedFormats = dsFormats;

%Load all files in datastore
data = readall(ds);
%Convert time stamp to readable data time format
data.time = datetime(uint64(data.time)/1e9, 'ConvertFrom', 'posixtime', 'Format', 'dd-MMM-yyyy HH:mm:ss');

%Remove activity '-1' from data and convert to timetable
data(ismember(data.activity,-1),:)=[];
data = table2timetable(data);
end

