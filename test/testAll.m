% load the different environment variables
global refDataPath
global inputDataPath

refDataPath = [getenv('PACER_DATA_PATH') filesep 'ref']
inputDataPath = [getenv('PACER_DATA_PATH') filesep 'input']

% request explicitly from the user to launch test suite locally
if isempty(strfind(getenv('HOME'), 'jenkins'))
   reply = '';
   while isempty(reply)
       reply = input([' -> Do you want to launch the test suite locally? Time estimate: more than 60 minutes Y/N: '], 's');
   end

   if strcmpi(reply, 'y') || strcmpi(reply, 'yes')
       launchTestSuite = true;
   else
       launchTestSuite = false;
   end
else
   % on the CI, always reset the path to make absolutely sure, that we test
   % the current version
   restoredefaultpath()
   launchTestSuite = true;
end

% save the current folder
origDir = pwd;

% if the location of pacer is not yet known
if isempty(which('SETUP_PACER.m'))
   % move back to the root of the repository
   cd([fileparts(which('testAll.m')) filesep '..'])

   % assign the path
   PACERDIR = pwd;
else
   PACERDIR = fileparts(which('SETUP_PACER.m'));
   cd(PACERDIR);
end

% include the root folder and all subfolders.
addpath(genpath([pwd filesep 'test']));

if launchTestSuite
    if ~isempty(getenv('MOCOV_PATH')) && ~isempty(getenv('JSONLAB_PATH'))
        addpath(genpath(getenv('MOCOV_PATH')))
        addpath(genpath(getenv('JSONLAB_PATH')))
        COVERAGE = true;
        fprintf('MoCov and JsonLab are on path, coverage will be computed.\n')
    else
        COVERAGE = false;
    end

    % change to the test folder
    currentDir = cd('test');
    testDirContent = getFilesInDir('type', 'all');  % Get all currently present files in the folder.
    testDirPath = pwd;
    cd(currentDir);

    % define a success exit code
    exit_code = 0;

    % enable profiler
    profile on;

    if COVERAGE
        % Get the ignored Files from gitIgnore
        % only retain the lines that end with .txt and .m and
        % are not comments and point to files in the /src folder
        ignoredPatterns = {'^.{0,3}$', ...  % Is smaller than four.
                        ['^[^s][^r][^c][^' regexptranslate('escape', filesep) ']']};  % does not start with src/
        filterPatterns = {'\.txt$', '\.m$'};  % Is either a .m file or a .txt file.
        ignoreFiles = getIgnoredFiles(ignoredPatterns, filterPatterns);

        % check the code quality
        listFiles = getFilesInDir('type', 'tracked', 'restrictToPattern', '^.*\.m$', 'checkSubFolders', true);

        % count the number of failed code quality checks per file
        nMsgs = 0;
        nCodeLines = 0;
        nEmptyLines = 0;
        nCommentLines = 0;

        for i = 1:length(listFiles)
            nMsgs = nMsgs + length(checkcode(listFiles{i}));
            fid = fopen(listFiles{i});

            while ~feof(fid)
                lineOfFile = strtrim(char(fgetl(fid)));
                if length(lineOfFile) > 0 && length(strfind(lineOfFile(1), '%')) ~= 1  ...
                    && length(strfind(lineOfFile, 'end')) ~= 1 && length(strfind(lineOfFile, 'otherwise')) ~= 1 ...
                    && length(strfind(lineOfFile, 'switch')) ~= 1 && length(strfind(lineOfFile, 'else')) ~= 1  ...
                    && length(strfind(lineOfFile, 'case')) ~= 1 && length(strfind(lineOfFile, 'function')) ~= 1
                        nCodeLines = nCodeLines + 1;

                elseif length(lineOfFile) == 0
                    nEmptyLines = nEmptyLines + 1;

                elseif length(strfind(lineOfFile(1), '%')) == 1
                    nCommentLines = nCommentLines + 1;
                end
            end
            fclose(fid);
        end

        % average number of messages per codeLines
        avMsgsPerc = floor(nMsgs / nCodeLines * 100);

        grades = {'A', 'B', 'C', 'D', 'E', 'F'};
        intervals = [0, 3;
                    3, 6;
                    6, 9;
                    9, 12;
                    12, 15;
                    15, 100];

        grade = 'F';
        for i = 1:length(intervals)
            if avMsgsPerc >= intervals(i, 1) && avMsgsPerc < intervals(i, 2)
                grade = grades{i};
            end
        end

        fprintf('\n\n -> The code grade is %s (%1.2f%%).\n\n', grade, avMsgsPerc);

        % set the new badge
        if ~isempty(strfind(getenv('HOME'), 'jenkins'))
            coverageBadgePath = [getenv('ARTENOLIS_DATA_PATH') filesep 'PaCER' filesep 'codegrade' filesep];
            system(['cp ' coverageBadgePath 'codegrade-', grade, '.svg '  coverageBadgePath 'codegrade.svg']);
        end
    end

end

try
   if launchTestSuite

      % ensure that we ALWAYS call exit
      if ~isempty(strfind(getenv('HOME'), 'jenkins')) || ~isempty(strfind(getenv('USERPROFILE'), 'jenkins'))
         exit(exit_code);
      end
   end
catch ME
   if ~isempty(strfind(getenv('HOME'), 'jenkins')) || ~isempty(strfind(getenv('USERPROFILE'), 'jenkins'))
       % only exit on jenkins.
       exit(1);
   else
       % switch back to the folder we were in and rethrow the error
       cd(origDir);
       rethrow(ME);
   end
end
