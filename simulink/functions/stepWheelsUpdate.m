function stepWheelsUpdate(odo, rob, ekf)    
    rob.updateOdometry(odo);
    ekf.prediction(odo);
end

