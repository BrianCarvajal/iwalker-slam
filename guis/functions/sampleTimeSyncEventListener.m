function sampleTimeSyncEventListener(rtb, ~)
    handles = guidata(get_param(rtb.BlockHandle, 'UserData'));
    t = rtb.CurrentTime;
    s = num2str(t, '%.1f');
    set(handles.currentTimeText, 'String', s);
    
    if t > handles.stopTime
        setState(handles, 'Stop'); 
    end   
end