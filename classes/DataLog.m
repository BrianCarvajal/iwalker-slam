classdef DataLog < hgsetget
    
    properties
        type
        can
        lidar
        endTime
    end
    
    properties (Access = public)       
        index
        queue        
        sim
        img
    end
    
    properties (Dependent)
       currentTime
    end
    
      
    methods
        function this = DataLog(iWalkerLog)
            
            if ~isfield(iWalkerLog, 'type')
                error('The input struct must have a field named ''type''');             
            end
            if ~isfield(iWalkerLog, 'endTime')
                error('The input struct must have a field named ''endTime''');             
            end
            if ~isfield(iWalkerLog, 'can')
                error('The input struct must have a field named ''can''');             
            end
            if ~isfield(iWalkerLog, 'lidar')
                error('The input struct must have a field named ''lidar''');             
            end
            
            switch iWalkerLog.type
                case 'iWalkerRoboPeak'

                case 'iWalkerHokuyo'
                    
                otherwise
                    error('Incorrect log type');
            end
                        
            this.type = iWalkerLog.type;
            this.endTime = iWalkerLog.endTime;
            this.can = iWalkerLog.can;
            this.lidar = iWalkerLog.lidar;
            
            this.queue = [];
            i = 1;
            i_can = 1;
            i_lid = 1;
            t_can = this.can.pose.Time;
            t_lid = this.lidar.range.Time;
            l_can = this.can.pose.TimeInfo.Length;
            l_lid = this.lidar.range.TimeInfo.Length;
            
            while i_can <= l_can || i_lid <= l_lid  
                if (i_lid > l_lid) || ...
                        i_can <= l_can && t_can(i_can) <= t_lid(i_lid)                   
                    this.queue(i).indexCan = i_can;
                    this.queue(i).indexLidar = i_lid-1;
                    this.queue(i).source = 'can';
                    this.queue(i).timestamp = t_can(i_can);
                    i_can = i_can + 1;             
                else
                    this.queue(i).indexCan = i_can-1;
                    this.queue(i).indexLidar = i_lid;
                    this.queue(i).source = 'lidar';
                    this.queue(i).timestamp = t_lid(i_lid);
                    i_lid = i_lid + 1;                  
                end
                i = i + 1;
            end
            this.init();          
        end
        
        
        
        function success = simulate(this, sim)
            try
                h = waitbar(0, ...
                            '0% simulated', ...
                            'Name','Simulating...', ...
                            'WindowStyle', 'modal');

                this.sim = sim;
                sim.settings.GridMap_Enabled = true;
                nl = this.lidar.range.TimeInfo.Length;

                % Array of gridmaps: 1+n images: the first one is the empty
                % map and the rest the n lidar updates
                this.img = zeros([sim.gmp.sizeMap nl+1], 'like', sim.gmp.image);
                this.img(:,:,1) = sim.gmp.image;

                sim.init();
                this.init();
                il = 1;

                while this.remainingData()
                    [source, data, ts, dt] = this.nextSample();
                    if (strcmp(source, 'can'))
                        sim.stepOdometry(data.odo);
                    else
                        sim.stepScan(data.range/1000, data.angle);
                        il = il + 1;
                        this.img(:,:,il) = sim.gmp.image();                    
                    end

                    p = this.index/length(this.queue);
                    txt = sprintf('%d%% simulated', int32(p*100));

                    if ishandle(h)
                        waitbar(p, h, txt);
                    else
                        success = false;
                        return;
                    end

                end
                sim.settings.GridMap_Enabled = false;
                close(h);
                success = true;
            catch
               success = false; 
            end
        end
        
        function m = maxStep(this)
            m = length(this.queue);
        end
        
        function data = setSimulationStep(this, step)
            this.sim.settings.GridMap_Enabled = false;
            if step < 0
                step = 0;
            elseif step > length(this.queue)
                step = length(this.queue);
            end
            data = [];
            data.step = step;
            data.lid = this.sim.lid;
            if step == 0
                data.dt = 0;
            elseif step == 1
                data.dt = this.queue(step).timestamp;
            else
                data.dt = this.queue(step).timestamp - this.queue(step-1).timestamp;
            end
            
            if step == 0
                data.source = 'init';
                data.timestamp = 0;
                data.rob.x = this.sim.rob.x_hist(1,:)';
                    data.rob.x_back = this.sim.rob.x_hist(1,:);
                    data.rob.x_forw = this.sim.rob.x_hist(2:end,:);
                this.sim.rob.x = data.rob.x;
                data.img = this.img(:,:,1);              
                data.lid.newScan(0, 0);
                data.landmarks = [];
            else
                data.source = this.queue(step).source;
                ic =  this.queue(step).indexCan;
                il = this.queue(step).indexLidar;               
                data.timestamp = this.queue(step).timestamp;
                data.rob.x = this.sim.rob.x_hist(ic+1,:)';
                data.rob.x_back = this.sim.rob.x_hist(1:ic+1,:);
                data.rob.x_forw = this.sim.rob.x_hist(ic+2:end,:);
                this.sim.rob.x = data.rob.x;
                
                if il > 0
                    range = this.lidar.range.Data(il,:);
                    angle = this.lidar.angle.Data(il,:);               
                    data.lid.newScan(range/1000, angle);
                    data.landmarks = this.sim.ext.extract(data.lid);
                else
                    data.lid.newScan(0, 0);
                    data.landmarks = [];
                end                
                data.img = this.img(:,:,il+1);                              
            end          
        end

        
        function t = get.currentTime(this)
            if this.remainingData()
                t = this.queue(this.index).timestamp;
            else
                t = this.endTime;
            end
        end
        
        function dt = nextDelay(this, step)
            if step == 0 
                dt = this.queue(1).timestamp;
            elseif step < length(this.queue)
               dt = this.queue(step+1).timestamp - this.queue(step).timestamp;
            else
               dt = 0;
            end                      
        end
           
        % returns the bounding box [-xy +xy] of the area
        function lims = limits(this)
            %first data is always zero, second is offset. We recover
            %all the data and substract the offset
            y = this.can.pose.Data(2:end,1) - this.can.pose.Data(2,1); 
            x = this.can.pose.Data(2:end,2) - this.can.pose.Data(2,2);              
            xl = max(abs(x'));
            yl = max(abs(y'));
            m = max([xl yl]);
            lims = [-m m];
        end     
    end
    
    methods (Access = private)
        function [source, data, ts, dt] = nextSample(this)
            data = [];          
            if this.remainingData()              
                source = this.queue(this.index).source;
                ts = this.queue(this.index).timestamp; 
                
                if strcmp(source, 'can')
                    i = this.queue(this.index).indexCan;
                    data.odo = this.can.odo.Data(i,:);
                    data.pose = this.can.pose.Data(i,:);
                    data.w = this.can.pose.Data(i,:);
                    if strcmp(this.type, 'iWalkerHokuyo')
                        data.imu =  this.can.imu.Data(i,:);
                        data.forces = this.can.forces.Data(i,:);
                    end
                    if i == 1
                        dt = this.can.pose.Time(i);
                    else
                       dt = this.can.pose.Time(i) - this.can.pose.Time(i-1);
                    end                    
                else
                    i = this.queue(this.index).indexLidar;
                    data.range = this.lidar.range.Data(i,:);
                    data.angle = this.lidar.angle.Data(i,:);
                    if strcmp(this.type, 'iWalkerRoboPeak')
                        data.count = this.lidar.count.Data(i);
                        data.freq = this.lidar.freq.Data(i);
                    end
                    if i == 1
                       dt = this.lidar.range.Time(i);
                    else
                       dt = this.lidar.range.Time(i) - this.lidar.range.Time(i-1);
                    end
                end
                this.index = this.index + 1;
            else
                error('No remaining data');
            end
        end
        
        function b = remainingData(this)
            b = this.index <= length(this.queue);       
        end
        
        function init(this)
            this.index = 1;            
        end
    end
end

