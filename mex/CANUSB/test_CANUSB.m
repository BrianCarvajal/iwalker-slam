
canusb = CANUSBInterface();

for i = 1:10
   if canusb.connect()
       canusb.disconnect();
   end
end

canusb.delete();
clear canusb;