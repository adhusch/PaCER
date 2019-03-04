fprintf('Hello ARTENOLIS.\n'); 
% if the location of pacer is not yet known
if isempty(which('SETUP_PACER.m'))
   % move back to the root of the repository
   cd([fileparts(which('testAll.m')) filesep '..'])

   % assign the path
   CBTDIR = pwd;
else
   CBTDIR = fileparts(which('SETUP_PACER.m'));
   cd(CBTDIR);
end 