% 画出ICA 独立分量
% Zica : ICs
% fs : fs
% d : offset 
function icaplot(Zica,fs,d)
level = length(Zica(:,1));
L = length(Zica(1,:));
t=(0:(L-1))/fs;
figure;
offs= 1:1:level;
d= 10;
for ics = 1:level
    plot(t,Zica(ics,:) + offs(ics)*d,'k');hold on;
end
ylim([0 d*(level+1)]); title('Independent Components');
IC = regexp(sprintf('IC-%02d ',[1:level]),' ','split');
set(gca,'YTick',[d:d:d*(level)],'YTickLabel',IC(1:end));
end