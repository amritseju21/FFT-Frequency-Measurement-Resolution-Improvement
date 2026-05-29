%% Cosine function as per given paper
function w = cosine_window(L)
    wc=[0.355768  0.487396  0.144232  0.012604];
    index=[-L/2-1:L/2];
    p=[];
    for i = 1:L
        p(i) = wc(1) * cos(2 * pi * 0 * index(i) / L) + wc(2) * cos(2 * pi * 1 * index(i) / L)+ wc(3) * cos(2 * pi * 2 * index(i) / L)+ wc(4) * cos(2 * pi * 3 * index(i) / L);
        w=p';
    end
end