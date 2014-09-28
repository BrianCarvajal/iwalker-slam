function stepGridMap( rob, lid, gm, gh )
    x = rob.x;
    T = se2(x(1), x(2), x(3)) * se2(lid.x(1), lid.x(2), lid.x(3));
    p = pTransform(lid.p, T);

    xs = pTransform([0.6; 0], T);
    for i = 1:length(p)
       if lid.range(i) > 0.02                   
            gm.setBeam(xs', p(:,i)', lid.range(i) < 3.8);
       end
    end
    set(gh, 'CData', gm.map);
end

