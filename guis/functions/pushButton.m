function h = pushButton(parent, tag, text, callback)
    h = uicontrol('Parent', parent, ...
                  'Tag', tag, ...
                  'Style', 'pushbutton', ...
                  'String', text, ...
                  'callback', callback);
end
