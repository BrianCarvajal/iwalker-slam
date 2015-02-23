function odo = stepWheelsDifferentialUpdate(rph, rob, ekf)   
    odo = rob.updateDifferential(double(rph));
    ekf.prediction(odo);
end

