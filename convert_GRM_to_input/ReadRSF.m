%%%%%%%%%%%%%%%%%%%%%%%%%%55
%%2012年2月19日发现在matlab2011中运行，读取dps的RSF频高图时
%%出现读取第三个byte时多读了一位，
%%导致后续的读取都错位，结果出错
%%读取其他频高图没问题GRM
%%修改后能够兼容2011a和matlab7了
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;close all;clc;
% % % now begin to open a data file
tpath=pwd;
[Fname,fpath]=uigetfile('*.RSF','Choose Ionogram data filename');
fname=lower(Fname);
disp(['Opening File:',Fname]);
fid=fopen([fpath,'\',fname],'r','ieee-be');

%%%%RSF Header
RecordType=fread(fid,1,'char');        %   1
HeadLength=fread(fid,1,'char');        %   2
Version=fread(fid,1,'char');           %   3
%%%%General Preface
Year=2000+str2num(dec2hex(fread(fid,1,'uint8')));         %   4
Doy=100*str2num(dec2hex(fread(fid,1,'uint8')))+str2num(dec2hex(fread(fid,1,'uint8')));% 6
Month=str2num(dec2hex(fread(fid,1,'uint8')));             %   7
Day=str2num(dec2hex(fread(fid,1,'uint8')));               %   8
Hour=str2num(dec2hex(fread(fid,1,'uint8')));              %   9
Minute=str2num(dec2hex(fread(fid,1,'uint8')));            %   10
Second=str2num(dec2hex(fread(fid,1,'uint8')));            %   11
disp(['Measurement Time:',num2str(Year),' ',num2str(Month),' ',num2str(Day),' ',num2str(Hour),' ',num2str(Minute),' ',num2str(Second),' UTC']);
fread(fid,6,'uint8');                           %   17
Schedule=str2num(dec2hex(fread(fid,1,'uint8')));%   18
Program=str2num(dec2hex(fread(fid,1,'uint8'))); %   19
FrequencyStart=str2num(dec2hex(fread(fid,1,'uint8')))+str2num(dec2hex(fread(fid,1,'uint8')))/100+str2num(dec2hex(fread(fid,1,'uint8')))/10000;
disp(['Frequency Starting:',num2str(FrequencyStart),' MHz']);
FrequencyStep=str2num(dec2hex(fread(fid,1,'uint8')))/10+str2num(dec2hex(fread(fid,1,'uint8')))/1000;%   24
disp(['Frequency Stepping:',num2str(FrequencyStep),' MHz']);
FrequencyStop=str2num(dec2hex(fread(fid,1,'uint8')))+str2num(dec2hex(fread(fid,1,'uint8')))/100+str2num(dec2hex(fread(fid,1,'uint8')))/10000;
disp(['Frequency Stopping:',num2str(FrequencyStop),' MHz']);
FrequencyFineStep=str2num(dec2hex(fread(fid,1,'uint8')))/10+str2num(dec2hex(fread(fid,1,'uint8')))/1000;%   29
FrequencyStepNumber=fread(fid,1,'schar');%    30
disp(['Frequency Numbers:',num2str(FrequencyStepNumber)]);
PhaseCode=str2num(dec2hex(fread(fid,1,'uint8')));%   31
switch PhaseCode
    case 1
        disp('Phase Code Type: Compliment');
    case 2
        disp('Phase Code Type: Short');
    case 3
        disp('Phase Code Type: 75% Duty');
    case 4
        disp('Phase Code Type: 100% Duty');
    otherwise
        disp('Phase Code Type: No Phase switch');
end
        
OX=fread(fid,1,'schar');%   32
OXSign=floor(OX/8);
OXPolarization=mod(OX,OXSign);
if OXPolarization>1
    disp('Polarization: Only O');
else
    disp('Polarization: Both O and X');
end
NumbeOfFFT=2^str2num(dec2hex(fread(fid,1,'uint8')));%  33
disp(['Number of FFT Point:',num2str(NumbeOfFFT)]);
PulseRepetitionRate=str2num(dec2hex(fread(fid,1,'uint8')))*100+str2num(dec2hex(fread(fid,1,'uint8')));%   34,35
disp(['Pulse Repetition Rate:',num2str(PulseRepetitionRate)]);
HeightStart=str2num(dec2hex(fread(fid,1,'uint8')))*100+str2num(dec2hex(fread(fid,1,'uint8')));%   36,37
disp(['Height Starting:',num2str(HeightStart),' km']);
HeightStepTag=str2num(dec2hex(fread(fid,1,'uint8')));%   38
HeightStep=ceil(HeightStepTag/2.5)*2.5;%    39
disp(['Height Stepping:',num2str(HeightStep),' km']);
HeightStepNumber=str2num(dec2hex(fread(fid,1,'uint8')))*100+str2num(dec2hex(fread(fid,1,'uint8')));%   40,41
disp(['Height Numbers:',num2str(HeightStepNumber)]);
HeightStop=HeightStart+HeightStep*HeightStepNumber;
disp(['Height Stopping:',num2str(HeightStop),' km']);
Delay=str2num(dec2hex(fread(fid,1,'uint8')))*100+str2num(dec2hex(fread(fid,1,'uint8')));
BaseGain=str2num(dec2hex(fread(fid,1,'uint8')));
disp(['Base Gain:',num2str(BaseGain),' dB']);
FrequencySearchEnable=str2num(dec2hex(fread(fid,1,'uint8')));
OperatingMode=str2num(dec2hex(fread(fid,1,'uint8')));
DataFormatTag=str2num(dec2hex(fread(fid,1,'uint8')));
switch DataFormatTag,
    case 0
        DataFormat='NoData';
    case 1
        DataFormat='MMM';
    case 2
        DataFormat='Drift';
    case 3
        DataFormat='PGH';
    case 4
        DataFormat='RSF';
    case 5
        DataFormat='SBF';
    case 6
        DataFormat='BIT';
end
if DataFormatTag>7,
    ArtistTag=1;
else
    ArtistTag=0;
end
PrinterOutput=str2num(dec2hex(fread(fid,1,'uint8')));   %  47
Threshhold=str2num(dec2hex(fread(fid,1,'uint8')));  %   48 
fread(fid,3,'uint8');
CITLength=fread(fid,1,'uint8')*100+fread(fid,1,'uint8');
Journal=fread(fid,1,'char');
HeightWindowBottom=str2num(dec2hex(fread(fid,1,'uint8')))*100+str2num(dec2hex(fread(fid,1,'uint8')));
HeightWindowTop=str2num(dec2hex(fread(fid,1,'uint8')))*100+str2num(dec2hex(fread(fid,1,'uint8')));
HeightNumberStored=str2num(dec2hex(fread(fid,1,'uint8')))*100+str2num(dec2hex(fread(fid,1,'uint8')));%  60
%%%% Preface ended
%%%% Header ended
if HeightStepNumber==128
    FrequencyGroupNum=15;
    HeightBinNumber=128;
elseif HeightStepNumber==256
    FrequencyGroupNum=8;
    HeightBinNumber=249;
elseif HeightStepNumber==512
    FrequencyGroupNum=4;
    HeightBinNumber=501;
else
    disp('Height Step Number Error! Check the Data!'); 
end
FrequencyGroupLength=HeightBinNumber*2+6;
RemainingBytes=4096-FrequencyGroupNum*FrequencyGroupLength-60;
disp(['Remaining Bytes:',num2str(RemainingBytes)]);
FrequencyX=nan(length(FrequencyStart:FrequencyStep:FrequencyStop)-1,1);
FrequencyO=FrequencyX;
AmplitudeX=nan(length(FrequencyStart:FrequencyStep:FrequencyStop)-1,HeightBinNumber);
DopplerX=AmplitudeX;
PhaseX=AmplitudeX;
AzimuthX=AmplitudeX;
AmplitudeO=AmplitudeX;
DopplerO=AmplitudeX;
PhaseO=AmplitudeX;
AzimuthO=AmplitudeX;
Frequency=FrequencyStart:FrequencyStep:FrequencyStop-FrequencyStep;
FrequencyGroupTotal=2*length(Frequency);
BlockNum=ceil(FrequencyGroupTotal/FrequencyGroupNum);
%%%%    Block
ff=1;fq=0;ffo=0;ffx=0;
for block=1:BlockNum,
    %%%%    Block
    fq=fq+1;
    %%%%    Frequency Group
    for freqgrp=1:FrequencyGroupNum
        if fq<=FrequencyGroupTotal
            %%%% Prelude
            Prelude1=fread(fid,1,'uint8'); % Byte1
            Polarization=floor(Prelude1/16);
            GroupSizeTag=mod(Prelude1,16);
            FrequencyReading=str2num(dec2hex(fread(fid,1,'uint8')))+str2num(dec2hex(fread(fid,1,'uint8')))/100; % Byte 2,3
            disp(['Frequency Reading:',num2str(FrequencyReading)]);
            Prelude4=fread(fid,1,'uint8');% Byte 4
            Offset=floor(Prelude4/16);
            AdditionGain=mod(Prelude4,16);
            Sec=str2num(dec2hex(fread(fid,1,'uint8'))); % Byte 5
            MostProbableAmplitude=fread(fid,1,'uint8');% Byte 6
            if Polarization==2,
                ffx=ffx+1;
                FrequencyX(ffx)=FrequencyReading;
                MPAX(ffx)=MostProbableAmplitude;
                ADGX(ffx)=AdditionGain;
                disp('Polarization:X');
           else
                ffo=ffo+1;
                FrequencyO(ffo)=FrequencyReading;
                MPAO(ffo)=MostProbableAmplitude;
                ADGO(ffo)=AdditionGain;
                disp('Polarization:O');
            end
            %%%%    Prelude Ended
            %%%%    Height Bin
            hh=1;
            for i=1:HeightBinNumber,
                ContentByte1=fread(fid,1,'uint8');
                ContentByte2=fread(fid,1,'uint8');
                if Polarization==2,
                    AmplitudeX(ffx,hh)=floor(ContentByte1/8);
                    DopplerX(ffx,hh)=mod(ContentByte1,32);
                    PhaseX(ffx,hh)=floor(ContentByte2/8);
                    AzimuthX(ffx,hh)=mod(ContentByte2,32);
                else
                    AmplitudeO(ffo,hh)=floor(ContentByte1/8);
                    DopplerO(ffo,hh)=mod(ContentByte1,32);
                    PhaseO(ffo,hh)=floor(ContentByte2/8);
                    AzimuthO(ffo,hh)=mod(ContentByte2,32);
                end,
                hh=hh+1;
            end
            %%%%    Height Bin Ended
            ff=ff+1;
        else
            break;
        end,
    end
    %%%% Frequency Group Ended
    fread(fid,RemainingBytes,'uint8');
    fread(fid,60,'uint8');
    %%%% Block Ended
end,
subplot(1,2,1);pcolor(AmplitudeO');
title('O wave');
%set(gca,'xtick',[ceil(FrequencyStart):1:floor(FrequencyStop-FrequencyStep)],'xticklabel',[ceil(FreuencyStart):1:floor(FrequencyStop-FrequencyStep)])
%'ylim',[HeightStart,HeightBinNumber*HeightStep]);
subplot(1,2,2);pcolor(AmplitudeX');
title('X wave');
figure;
hist(AmplitudeO(:),(1:31)); % 注意hist(AmplitudeO(:))与hist(AmplitudeO)是有区别的，前者返回的是一个向量，后者返回的是矩阵，画出的图不一样
set(gca,'xlim',[0,32]);
figure;
subplot(2,1,1);
plot(ADGO);
xlabel('Addition Gain O');
subplot(2,1,2);
plot(MPAO);
xlabel('Most Probable Amplitude O');
figure;
subplot(2,1,1);
%plot(ADGX);
%xlabel('Addition Gain X');
%subplot(2,1,2);
%plot(MPAX);
%xlabel('Most Probable Amplitude X');
%figure;
subplot(221);
imagesc(flipud(AmplitudeO'));
subplot(222);
imagesc(flipud(AmplitudeX'));
subplot(223);
imagesc(flipud(AmplitudeO'));
hold on;
imagesc(flipud(AmplitudeX'));
subplot(224);
imagesc(flipud(AmplitudeX'));
hold on;
imagesc(flipud(AmplitudeO'));


a=median(AmplitudeO',1);
figure;
subplot(311);plot(MPAO);
ylim([0,32]);
subplot(312);plot(3*a);
ylim([0,32]);
subplot(313);plot(MPAO-3*a);
ylim([0,10]);


