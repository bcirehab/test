function seq = randsound(num)
% 2014.06.02

seq=randperm(num);
loc1=find(seq>num/2);
loc2=find(seq<num/2+1);
count=1;
cloc1=[];
cloc2=[];

for i=1:size(loc1)-1    
    if loc1(i+1)==loc1(i)+1
        count=count+1;
    else
        count=1;
    end
    
    if count==5
        cloc1=[cloc1;loc1(i+1)-2];
        count=1;
    end
end

for i=1:size(loc2)-1    
    if loc2(i+1)==loc2(i)+1
        count=count+1;
    else
        count=1;
    end
    
    if count==5
        cloc2=[cloc2;loc2(i+1)-2];
        count=1;
    end
end

if isempty(cloc2)
if ~isempty(cloc1)
    t=size(cloc1,1);
    for j=1:size(loc2,2)-2
        if loc2(j+2)-loc2(j+1)<4 && loc2(j+1)-loc2(j)<4
            temp=seq(cloc1(size(cloc1,1)-t+1));
            seq(cloc1(size(cloc1,1)-t+1))=seq(loc2(j+1));
            seq(loc2(j+1))=temp;
            t=t-1;
        end
        if t==0
            break;
        end
    end
end

else
    if isempty(cloc1)
       t=size(cloc2,1);
    for j=1:size(loc1,2)-2
        if loc1(j+2)-loc1(j+1)<4 && loc1(j+1)-loc1(j)<4
            temp=seq(cloc2(size(cloc2,1)-t+1));
            seq(cloc2(size(cloc2,1)-t+1))=seq(loc1(j+1));
            seq(loc1(j+1))=temp;
            t=t-1;
        end
        if t==0
            break;
        end
    end
    else
        if size(cloc1,1)==size(cloc2,1)
            for k=1:size(cloc1,1)
            temp=seq(cloc2(k));
            seq(cloc2(k))=seq(cloc1(k));
            seq(cloc1(k))=temp;
            end
        end
        if size(cloc1,1)>size(cloc2,1)
            for k=1:size(cloc2,1)
            temp=seq(cloc2(k));
            seq(cloc2(k))=seq(cloc1(k));
            seq(cloc1(k))=temp;
            end
            
             t=size(cloc1,1)-size(cloc2,1);
        for j=1:size(loc2,2)-2
        if loc2(j+2)-loc2(j+1)<4 && loc2(j+1)-loc2(j)<4
            temp=seq(cloc1(size(cloc1,1)-size(cloc2,1)-t+1));
            seq(cloc1(size(cloc1,1)-size(cloc2,1)-t+1))=seq(loc2(j+1));
            seq(loc2(j+1))=temp;
            t=t-1;
        end
        if t==0
            break;
        end
        end
        end
        if size(cloc1,1)<size(cloc2,1)
            for k=1:size(cloc1,1)
            temp=seq(cloc2(k));
            seq(cloc2(k))=seq(cloc1(k));
            seq(cloc2(k))=temp;
            end
            
            t=size(cloc2,1)-size(cloc1,1);
    for j=1:size(loc1,2)-2
        if loc1(j+2)-loc1(j+1)<4 && loc1(j+1)-loc1(j)<4
            temp=seq(cloc2(size(cloc2,1)-size(cloc1,1)-t+1));
            seq(cloc2(size(cloc2,1)-size(cloc1,1)-t+1))=seq(loc1(j+1));
            seq(loc1(j+1))=temp;
            t=t-1;
        end
        if t==0
            break;
        end
    end
        end
    end
end
%RANDSOUND Summary of this function goes here
%   Detailed explanation goes here


end

