%%%%%%%%%%%%%%%%%%%%%%%%%%55
%%2012年2月19日编写，
%% 将grm文件分割为整点时刻的RSF，以dps的grm为例，
%% 每个单点时刻数据开头的字符为07 3c fe
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;close all;clc;
% % % now begin to open a data file
tpath=pwd;
[Fname,fpath]=uigetfile('*.grm','Choose Ionogram ---GRM');
sPre = Fname(1:6);
disp(['Opening File:',Fname]);
fid=fopen([fpath,'\',Fname],'r','ieee-be');
OutDir=[pwd,'\Split\'];
if ~isdir(OutDir)
    mkdir(OutDir);
end
LastHour = 25;
%%%%RSF DataTemp
while ~feof(fid)
    DataTemp = fread(fid,4096,'uint8');
    if ~size(DataTemp),
        break;
    end,
    % 找到单点时刻数据头
    if((DataTemp(2) == 60) & (DataTemp(3) == 254))
    %if 1    
        Year=2000+str2num(dec2hex(DataTemp(4)));
        Doy=100*str2num(dec2hex(DataTemp(5)))+str2num(dec2hex(DataTemp(6)));% 6
        Month=str2num(dec2hex(DataTemp(7)));             %   7
        Day=str2num(dec2hex(DataTemp(8)));               %   8
        Hour=str2num(dec2hex(DataTemp(9)));              %   9
        Minute=str2num(dec2hex(DataTemp(10)));            %   10
        Second=str2num(dec2hex(DataTemp(11)));            %   11
        %if mod((Minute+2),60) < 4,
        if 1
            if Hour ~= LastHour,
                LastHour = Hour;
                disp(['Hourly data at: ',num2str(Year),' ',num2str(Month,'%02d'),' ',num2str(Day,'%02d'),' ',num2str(mod(Hour+floor((Minute+2)/60),24),'%02d'),':00 o''clock']);
            end
            outname = [OutDir,sPre,num2str(Year),num2str(Month,'%02d'),num2str(Day,'%02d'),num2str(Hour,'%02d'),num2str(Minute,'%02d'),num2str(Second,'%02d'),'.SBF'];
            fido = fopen(outname,'a');
            fwrite(fido,DataTemp);
            fclose(fido);
        end
    end
end
fclose(fid);
