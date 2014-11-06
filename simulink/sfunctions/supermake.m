[path, ~, ~] = fileparts(mfilename('fullpath'));

fprintf('Building simulink sfunctions\n');

fprintf('========[CANBUS sfunctions]========\n');
run([path '/CANBUS/make']);

fprintf('========[URG-04LX sfunctions]========\n');
run([path '/URG-04LX/make']);

fprintf('========[RPLIDAR sfunctions]========\n');
run([path '/RPLIDAR/make']);

fprintf('========[SampleTimeSync sfunctions]========\n');
run([path '/SampleTimeSync/make']);


