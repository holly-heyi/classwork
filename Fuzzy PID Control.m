%模糊PID
%Fuzzy PID Control
close all;
clear all;

a=readfis('fuzzpid');   %Load fuzzpid.fis

% ts=0.001;
% sys=tf(5.235e005,[1,87.35,1.047e004,0]);
% dsys=c2d(sys,ts,'tustin');
% [num,den]=tfdata(dsys,'v');

ts=0.1;  %采样时间=0.1s
sys=tf(4.23,[1,1.64,8.46],'ioDelay',3); %建立被控对象传递函数
dsys=c2d(sys,ts,'z')     %离散化
[num,den]=tfdata(dsys,'v');   %

x=[0,0,0]';

e_1=0;
ec_1=0;

kp0=0.35;
ki0=0.35;
kd0=1;

for j=1:32;
    u(j)=0.0;
end

for k=1:1:3000
time(k)=k*ts;

r(k)=1;
%Using fuzzy inference to tunning PID
k_pid=evalfis([e_1,ec_1],a);
kp(k)=kp0+k_pid(1);
ki(k)=ki0+k_pid(2);
kd(k)=kd0+k_pid(3);
y(1)=0;y(2)=0;
    y(k+2)=-1*den(3)*y(k-2+2)-1*den(2)*y(k-1+2)+num(2)*u(k-31+32)+num(3)*u(k-32+32);%系统响应输出序列
    e(k)=r(k)-y(k+2);
u(k+32)=kp(k)*x(1)+kd(k)*x(2)+ki(k)*x(3);

   
   x(1)=e(k);            % Calculating P
   x(2)=e(k)-e_1;        % Calculating D
   x(3)=x(3)+e(k)*ts;    % Calculating I

   ec_1=x(2);
   e_2=e_1;
   e_1=e(k);
end

figure(1);
plot(time,r,'b',time,y(3:3002),'r');
xlim([0,300]);ylim([0,1.2]);grid on;
xlabel('time(s)');ylabel('rin,yout');
figure(2);
plot(time,e,'r');
xlabel('time(s)');ylabel('error');
figure(3);
plot(time,u(33:3032),'r');
xlabel('time(s)');ylabel('u');
figure(4);
plot(time,kp,'r');
xlabel('time(s)');ylabel('kp');
figure(5);
plot(time,ki,'r');
xlabel('time(s)');ylabel('ki');
figure(6);
plot(time,kd,'r');
xlabel('time(s)');ylabel('kd');
