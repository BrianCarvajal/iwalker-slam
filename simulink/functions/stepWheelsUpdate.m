function stepWheelsUpdate(rpm, rob, ekf)
    
    rpm = double(rpm)/100;
    odo = rob.updateDifferential(rpm);
    tic;
    %ekf.prediction(odo);   
end

