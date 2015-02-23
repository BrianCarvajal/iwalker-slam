function ppath = parentpath( path )
%parentpath Get the parent full path of a given full path
    parts = strsplit(path, filesep);
    ppath = parts{1};
    for i = 2: length(parts)-1
        ppath = [ppath filesep parts{i}];
    end
end

