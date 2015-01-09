% whenOnInCycle.m

function phases = whenOnInCycle(data,threshold)

len = length(data);
dataFirst = data(1:len/2);
len2 = length(dataFirst);
dataSecond = data(len2+1:len);
t = 0;

cross1 = crossing2(t,abs(dataFirst),threshold);
if size(cross1)<2
    cross1 = [0.5 0.5]*len2;
end
cross2 = crossing2(t,abs(dataSecond),threshold);
if size(cross2)<2
    cross2 = [0.5 0.5]*len2;
end
phases = [cross1(1) cross1(end) cross2(1)+len2 cross2(end)+len2]/len;
end