%第一个文件，用于制定定模糊规则，文件名"Fuzzyrule"
%Fuzzy Tunning PID Control
clear all;
close all;

a=newfis('fuzzpid');

a=addvar(a,'input','e',[-3,3]);                        %Parameter e
a=addmf(a,'input',1,'NB','zmf',[-3,-1]);
a=addmf(a,'input',1,'NM','trimf',[-3,-2,0]);
a=addmf(a,'input',1,'NS','trimf',[-3,-1,1]);
a=addmf(a,'input',1,'Z','trimf',[-2,0,2]);
a=addmf(a,'input',1,'PS','trimf',[-1,1,3]);
a=addmf(a,'input',1,'PM','trimf',[0,2,3]);
a=addmf(a,'input',1,'PB','smf',[1,3]);

a=addvar(a,'input','ec',[-3,3]);                       %Parameter ec
a=addmf(a,'input',2,'NB','zmf',[-3,-1]);
a=addmf(a,'input',2,'NM','trimf',[-3,-2,0]);
a=addmf(a,'input',2,'NS','trimf',[-3,-1,1]);
a=addmf(a,'input',2,'Z','trimf',[-2,0,2]);
a=addmf(a,'input',2,'PS','trimf',[-1,1,3]);
a=addmf(a,'input',2,'PM','trimf',[0,2,3]);
a=addmf(a,'input',2,'PB','smf',[1,3]);

a=addvar(a,'output','kp',[-0.3,0.3]);                   %Parameter kp
a=addmf(a,'output',1,'NB','zmf',[-0.3,-0.1]);
a=addmf(a,'output',1,'NM','trimf',[-0.3,-0.2,0]);
a=addmf(a,'output',1,'NS','trimf',[-0.3,-0.1,0.1]);
a=addmf(a,'output',1,'Z','trimf',[-0.2,0,0.2]);
a=addmf(a,'output',1,'PS','trimf',[-0.1,0.1,0.3]);
a=addmf(a,'output',1,'PM','trimf',[0,0.2,0.3]);
a=addmf(a,'output',1,'PB','smf',[0.1,0.3]);

a=addvar(a,'output','ki',[-0.06,0.06]);             %Parameter ki
a=addmf(a,'output',2,'NB','zmf',[-0.06,-0.02]);
a=addmf(a,'output',2,'NM','trimf',[-0.06,-0.04,0]);
a=addmf(a,'output',2,'NS','trimf',[-0.06,-0.02,0.02]);
a=addmf(a,'output',2,'Z','trimf',[-0.04,0,0.04]);
a=addmf(a,'output',2,'PS','trimf',[-0.02,0.02,0.06]);
a=addmf(a,'output',2,'PM','trimf',[0,0.04,0.06]);
a=addmf(a,'output',2,'PB','smf',[0.02,0.06]);

a=addvar(a,'output','kd',[-3,3]);                   %Parameter kp
a=addmf(a,'output',3,'NB','zmf',[-3,-1]);
a=addmf(a,'output',3,'NM','trimf',[-3,-2,0]);
a=addmf(a,'output',3,'NS','trimf',[-3,-1,1]);
a=addmf(a,'output',3,'Z','trimf',[-2,0,2]);
a=addmf(a,'output',3,'PS','trimf',[-1,1,3]);
a=addmf(a,'output',3,'PM','trimf',[0,2,3]);
a=addmf(a,'output',3,'PB','smf',[1,3]);

rulelist=[1 1 7 1 5 1 1;%前m个数字表示各输入语言变量的语言之（隶属度函数的编号），此处m=2
		  1 2 7 1 3 1 1;%随后的n个数字表示输出语言变量的语言值，此处n=3
          1 3 6 2 1 1 1;%第n+m+1个数字是该规则的权重，权重的值在0到1之间，一般为1
          1 4 6 2 1 1 1;%第n+m+2个数字为0或1两者之一，各输入语言变量之间的关系，1为与，0为或
          1 5 5 3 1 1 1;
          1 6 4 4 2 1 1;
          1 7 4 4 5 1 1;
          
          2 1 7 1 5 1 1;
          2 2 7 1 3 1 1;
          2 3 6 2 1 1 1;
          2 4 5 3 2 1 1;
          2 5 5 3 2 1 1;
          2 6 4 4 3 1 1;
          2 7 3 4 4 1 1;
          
          3 1 6 1 4 1 1;
          3 2 6 2 3 1 1;
          3 3 6 3 2 1 1;
          3 4 5 3 2 1 1;
          3 5 4 4 3 1 1;
          3 6 3 5 3 1 1;
          3 7 3 5 4 1 1;
          
          4 1 6 2 4 1 1;
          4 2 6 2 3 1 1;
          4 3 5 3 3 1 1;
          4 4 4 4 3 1 1;
          4 5 3 5 3 1 1;
          4 6 2 6 3 1 1;
          4 7 2 6 4 1 1;
          
          5 1 5 2 4 1 1;
          5 2 5 3 4 1 1;
          5 3 4 4 4 1 1;
          5 4 3 5 4 1 1;
          5 5 3 5 4 1 1;
          5 6 2 6 4 1 1;
          5 7 2 7 4 1 1;
          
          6 1 5 4 7 1 1;
          6 2 4 4 5 1 1;
          6 3 3 5 5 1 1;
          6 4 2 5 5 1 1;
          6 5 2 6 5 1 1;
          6 6 2 7 5 1 1; 
          6 7 1 7 7 1 1;

          7 1 4 4 7 1 1; 
          7 2 4 4 6 1 1;
          7 3 2 5 6 1 1;
          7 4 2 6 6 1 1;
          7 5 2 6 5 1 1;
          7 6 1 7 5 1 1;
          7 7 1 7 7 1 1];
       
a=addrule(a,rulelist);
a=setfis(a,'DefuzzMethod','centroid');
writefis(a,'fuzzpid');

a=readfis('fuzzpid');

figure(1);
plotmf(a,'input',1);
figure(2);
plotmf(a,'input',2);
figure(3);
plotmf(a,'output',1);
figure(4);
plotmf(a,'output',2);
figure(5);
plotmf(a,'output',3);
figure(6);
plotfis(a);

fuzzy fuzzpid;
showrule(a);
ruleview fuzzpid;

