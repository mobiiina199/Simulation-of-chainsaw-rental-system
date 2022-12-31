clc
clear
%%
clock=0; %simulation clock
waittime=0; %when customer was in the tier render
perin=0;
source=100;
p1=0; % The number of people in the delivery queue
p2=0; % The number of people in the queue get
s1=0; % The number of source need to prepare
s2=0; % The number of the source needs to be repaired
m=3;
n=4;
use=0;
servicetime=0;
reject=0;
duenowlist=[];
%%
simtable=[1 0 1 0 ; 2 0 1 0 ; 3 12 2 1];
%%
while clock<=(300*11*60)
%% phase A
clock=min(simtable(simtable(:,3)==2,2));
for i=1:m
    if simtable(i,2)==clock && simtable(i,3)==2
        duenowlist=[duenowlist,i];
    end
end
%% phase B
for i=1:size(duenowlist,2)
    if simtable(duenowlist(i),4)==1 % BS1
        perin=perin+1;
        p1=p1+1;
        m=m+1;
        b=[];
        simtable=[simtable;b];
     
        simtable(m,2)=clock+rand1;
        simtable(m,3)=2;%false
        simtable(m,4)=1;%BS1
    else if simtable(duenowlist(i),4)==2 % BS2
            p1=p1-1;
            source=source-1;
            use=use+1;
            simtable(duenowlist(i),2)=clock + rand11;
        else if simtable(duenowlist(i),4)==3 % BS3
                p2=p2-1;
                use=use-1;
                if(rand2>=0.7)
                    source=source+1;
                else if((0.4<=rand2) && (rand2<0.7))
                        s1=s1+1;
                    else if(0.4>rand2)
                            s2=s2+1;
                        end
                    end
                end
                simtable(duenowlist(i),3)=1;
            else if simtable(duenowlist(i),4)==4 % BS4
                    s1=s1-1;
                    source=source+1;
                    simtable(duenowlist(i),3)=1;
                else if simtable(duenowlist(i),4)==5 % BS5
                        s2=s2-1;
                        s1=s1+1;
                        simtable(duenowlist(i),3)=1;
                    else if simtable(duenowlist(i),4)==6 % BS6
                            use=use-1;
                            p2=p2+1;
                            simtable(duenowlist(i),3)=1;
                        end
                    end
                end
            end
        end
    end
end
duenowlist=[];
%% phase C
if((0<=mod(clock,660)) && (mod(clock,660)<600))
if (simtable(2,3)==1 && p2>=1) % Cs2
    p2=p2-1;
    simtable(2,3)=2;
    servicetime=servicetime + 2;
    simtable(2,2)=clock + 2;
    simtable(2,4)=3; % Bs3
else if(s2==0 && simtable(1,3)==1 && p2>=2)
        p2=p2-1;
        simtable(1,3)=2;
        servicetime=servicetime + 2;
        simtable(1,2)=clock + 2;
        simtable(1,4)=3; %Bs3
    end
end
if(simtable(2,3)==1 && p1>=1) % Cs1
    p1=p1-1;
    simtable(2,3)=2;
    servicetime=servicetime + rand3;
    simtable(2,2)=clock + rand3;
    simtable(2,4)=2; %Bs2
else if(s2==0 && simtable(1,3)==1 && p1>=2)
     p1=p1-1;
     simtable(1,3)=2;
     servicetime=servicetime + rand4;
     simtable(1,2)=clock + rand4;
     simtable(1,4)=2; %Bs2
    end
end
for i=1:m
    if(simtable(1,3)==2 && simtable(i,2)<clock && simtable(m,3)==2)
        waittime=waittime+(clock-simtable(i,2));
    end
end
if(simtable(1,3)==1 && p1<=1 && p2<=1) % Cs4 David
    simtable(1,3)=2;
    s2=s2-1;
    servicetime=servicetime + rand9;
    simtable(1,2)=clock + rand9;
    simtable(1,4)=5; %Bs5
end
if(simtable(2,3)==1 && p2==0 && p1==0) % Cs3 Bety
    simtable(2,3)=2;
    s1=s1-1;
    servicetime=servicetime + rand7;
    simtable(2,2)=clock + rand7;
    simtable(2,4)=4; %Bs4
end
if(simtable(1,3)==1 && p1<=1 && p2<=1 && s2<=5) % Cs3 David
  simtable(1,3)=2;
  s1=s1-1;
  servicetime=servicetime + rand8;
  simtable(1,2)=clock + rand8;
  simtable(1,4)=4; %Bs4
end
else if((600<=mod(clock,660)) && (mod(clock,660)<660))
if(simtable(2,3)==1 || simtable(2,3)==2 || simtable(1,3)==1 || simtable(1,3)==2) % Cs1
    reject=reject+p1;
end
if(simtable(2,3)==1 && p2>=1) % Cs2
    simtable(2,3)=2;
    servicetime=servicetime + 2;
    simtable(2,2)=clock + 2;
    simtable(2,4)=3; %Bs3
    p2=p2-1;
else if(s2==0 && simtable(1,3)==1 && p2>=2)
        simtable(1,3)=2;
        servicetime=servicetime + 2;
        simtable(1,2)=clock +2;
        simtable(1,4)=3; %Bs3
        p2=p2-1;
    end
end
if(simtable(1,3)==1 && s2>=1) % Cs4
    simtable(1,3)=2;
    servicetime=servicetime + rand9;
    simtable(1,2)=clock + rand9;
    simtable(1,4)=5; %Bs5
end
if(simtable(2,3)==1 && s1==0 && s2>=2)
    simtable(2,3)=2;
    servicetime=servicetime + rand10;
    simtable(2,2)=clock + rand10;
    simtable(2,4)=5; %Bs5
end
if(simtable(2,3)==1 && s1>=1) % Cs3
    simtable(2,3)=2;
    servicetime=servicetime + rand7;
    simtable(2,2)=clock + rand7;
    simtable(2,4)=4; %Bs4
end
if(simtable(1,3)==1 && s2==0)
    simtable(1,3)=2;
    servicetime=servicetime + rand8;
    simtable(1,2)=clock + rand8;
    simtable(1,4)=4; %Bs4
end
    end
end
end