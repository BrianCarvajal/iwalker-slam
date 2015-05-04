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
    end
    
    properties (Dependent)
       currentTime
    end
    
      
    methods
        function this = DataLog(iWalkerLog, sim)
            
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
            
            if nargin < 2
               sim = SimulationEngine(); 
            end
            
            
            this.sim = sim;
                        
            this.type = iWalkerLog.type;
            this.endTime = iWalkerLog.endTime;
            this.can = iWalkerLog.can;
            this.lidar = iWalkerLog.lidar;
            
            this.queue = [];
            i = 1;
            i_can = 1; % can index
            i_lid = 1; % lidar index
            t_can = this.can.pose.Time; % can time vector
            t_lid = this.lidar.range.Time; % lidar time vector
            l_can = this.can.pose.TimeInfo.Length; % can samples length
            l_lid = this.lidar.range.TimeInfo.Length; % lidar samples length
            
            while i_can <= l_can || i_lid <= l_lid  
                if (i_lid > l_lid) || ...
                        i_can <= l_can && t_can(i_can) < t_lid(i_lid)                   
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
        
        function [source, data, ts, dt] = getSample(this, step)
            data = [];          
            if step > 0 && step <= this.maxStep()            
                source = this.queue(step).source;
                ts = this.queue(step).timestamp; 
                
                if strcmp(source, 'can')
                    i = this.queue(step).indexCan;
                    data.odo = this.can.odo.Data(i,:);
                    data.pose = this.can.pose.Data(i,:);
                    data.w = this.can.w.Data(i,:);
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
                    i = this.queue(step).indexLidar;
                    data.range = this.lidar.range.Data(i,:);
                    data.angle = this.lidar.angle.Data(i,:);
                    if strcmp(this.type, 'iWalkerRoboPeak')
                        data.count = this.lidar.count.Data(i);
                        data.freq = this.lidar.freq.Data(i);
                        if data.count == 0
                           data.range = 0;
                           data.angle = 0;
                        end
                    end
                    if i == 1
                       dt = this.lidar.range.Time(i);
                    else
                       dt = this.lidar.range.Time(i) - this.lidar.range.Time(i-1);
                    end
                end
            else
                error('No remaining data');
            end
        end
        
        
        
%         function success = simulate(this)
%             success = true;
%             try
%                 h = waitbar(0, ...
%                             '0% simulated', ...
%                             'Name','Simulating...', ...
%                             'WindowStyle', 'normal');
%               
%                         
%                 sim = this.sim;
%                 
%                 sim.init();
%                 this.init();
%                 sim.gmp.keepHist = true;
%                 sim.gmp.init();
%                 il = 1;
%                 
% %                 xlims = [sim.settings.GridMap_LimitsMinX sim.settings.GridMap_LimitsMaxX];
% %                 ylims = [sim.settings.GridMap_LimitsMinY sim.settings.GridMap_LimitsMaxY];
% 
%                 %[~, sim.map] = mapMaker(xlims, ylims);
% %                 sim.ekf.estimateMap = false;
% %                 file = load('omega3-lsi.mat');
% %                 sim.map = file.fmap;
% %                 sim.ekf.map = file.fmap;
%                 iprev = 0;
%                 while this.remainingData()       
%                     [source, data, ts, dt] = this.nextSample();
%                     if (strcmp(source, 'can'))
%                         sim.stepOdometry(data.odo);
%                     else
%                         sim.stepScan(data.range/1000, data.angle);
%                         il = il + 1;                    
%                     end
%  
%                     if ishandle(h)
%                             p = this.index/length(this.queue);
%                             i = int32(p*100);
%                             if i ~= iprev
%                                 txt = sprintf('%d%% simulated', int32(p*100));
%                                 waitbar(p, h, txt);
%                                 iprev = i;
%                             end
%                     else
%                         success = false;
%                         return;
%                     end
%                 end
%                 
%                 
%             catch exception
%                warning(exception.getReport);
%                success = false;
%             end
%             if ishandle(h)
%                 close(h);
%             end
%         end
        
        function m = maxStep(this)
            m = length(this.queue);
        end
        
        function data = setSimulationStep(this, step)
            if step < 0 || step > length(this.queue)
                error('Step simulation out of bounds');
            end

            % delta time
            if step == 0
                dt = 0;
            elseif step == 1
                dt = this.queue(step).timestamp;
            else
                dt = this.queue(step).timestamp - this.queue(step-1).timestamp;
            end
            ekf = this.sim.ekf;
            rob = this.sim.rob;
            lid = this.sim.lid;
            ext = this.sim.ext;
            gmp = this.sim.gmp;
            if step == 0
                source = 'init';
                timestamp = 0;
                i_rob = 1;
                rob.Xr = rob.Xr0;
                ekf.X = rob.Xr0;
                ekf.P = ekf.P0;
                img = gmp.image(1);
                lid.newScan(0, 0);
                pw = lid.pw(:, ~lid.outliers & ~lid.inDeadAngle);
                r = lid.range(~lid.outliers & ~lid.inDeadAngle);
                a = lid.angle(~lid.outliers & ~lid.inDeadAngle);
                ext.extract(r, a, pw);
            else
                source = this.queue(step).source;
                timestamp = this.queue(step).timestamp;
                
                ic =  this.queue(step).indexCan;
                il = this.queue(step).indexLidar;                               
                i_rob = ic+1;
                rob.Xr = rob.Xr_hist(i_rob,:)';
                ekf.X = ekf.history(i_rob).X;
                ekf.P = ekf.history(i_rob).P;
                if strcmp(source, 'lidar')
                    if il > 0
                        range = this.lidar.range.Data(il,:);
                        angle = this.lidar.angle.Data(il,:);               
                        lid.newScan(range/1000, angle);
                    else
                        lid.newScan(0, 0);
                        ext.extract(this.sim.lid);
                    end
                    pw = lid.pw(:, ~lid.outliers & ~lid.inDeadAngle);
                    r = lid.range(~lid.outliers & ~lid.inDeadAngle);
                    a = lid.angle(~lid.outliers & ~lid.inDeadAngle);
                    ext.extract(r, a, pw);
                end
                img = gmp.image(il+1);
            end
            
            % Return struct
            data = [];
            data.step = step;
            data.timestamp = timestamp;
            data.dt = dt;
            data.source = source;
            data.i_rob = i_rob;
            data.img = img;
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
        
        
        function b = remainingData(this)
            b = this.index <= length(this.queue);       
        end
        
        function init(this)
            this.index = 1;            
        end
    end
end

