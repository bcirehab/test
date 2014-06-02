 function [ matTrials ] = chinlang_rand( SubjectNr,CondNr )
% function [ matTrials ] = chinlang_rand
%CHINLANG_RAND Summary of this function goes here
%   Detailed explanation goes here
num=100*2;
% num=4*2;
 rng(SubjectNr);
tempseq = randsound(num);

for i=1:num
RandMatrix(i*2,1)=tempseq(i);
if tempseq(i)<(num/2+1)
RandMatrix(i*2-1,1)=tempseq(i)+num;
else
RandMatrix(i*2-1,1)=tempseq(i)+num/2;
end
end

RandSOA = [];

SOA(1,1) = 5;
SOA(1,2) = 0;

for i = 1:size(RandMatrix,1)
    foo = SOA(mod(i,2)+1);
    RandSOA = [RandSOA; foo];
end

%%% define EEG Triggers
TriggerMatrix = [];
for i= 1:size(RandMatrix,1)
    if RandMatrix(i) >=1 && RandMatrix(i)<= num/2
        foo = 1;
    elseif RandMatrix(i) >=num/2+1 && RandMatrix(i)<=num
        foo = 2;
    elseif RandMatrix(i) >=num+1 && RandMatrix(i)<= num/2*3
        foo = 3;
    else
        foo = 4;
    end
    TriggerMatrix = [TriggerMatrix; foo];
end

matTrials=[RandMatrix RandSOA TriggerMatrix];

end

