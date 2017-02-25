log_file = lc.logging.Log('/home/sanae/lcm-1.2.1/gps_hw', 'r');

while true
    try
        ev = log_file.readNext();
        if strcmp(ev.channel, 'GPS')
            
            %build gps object from data in this record
            gps = lc.gps_t(ev.data);
            
            timestamp = gps.timestamp;
            latitude = gps.latitude;
            latitude_s = gps.latitude_s;
            longitude = gps.longitude;
            longitude_s = gps.longitude_s;
            
        end
    catch err
        break;
    end
end

        
            
            
            
            
            
            
            
            
            
            
            