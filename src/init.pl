% local initialization file for the Prolog environment


% set up file search paths
% file_search_path(demo, '/usr/lib/prolog/demo').
% the file specification demo(myfile) will be expanded to /usr/lib/prolog/demo/myfile. 

:- asserta(user:file_search_path(src, 'src')).
:- asserta(user:file_search_path(module, 'src/module')).

:- use_module(library(clpfd)).

