clear;close all;clc;
% % % now begin to open a data file
tpath=pwd;
% cd([tpath,'\MData']);
[Fname,fpath]=uigetfile('*.SBF','Choose Ionogram data filename');
% cd ..
fname=lower(Fname);
disp(['Opening File:',Fname]);
fid=fopen([fpath,'\',fname],'r','ieee-be');
%%%%RSF Header
RecordType=fread(fid,1,'char');        %   1
HeadLength=fread(fid,1,'char');        %   2
Version=fread(fid,1,'uint8');           %   3
%Version=fread(fid,1,'char'); 
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
HeightStep=ceil(HeightStepTag/2.5)*2.5;
disp(['Height Stepping:',num2str(HeightStep),' km']);
HeightStepNumber=str2num(dec2hex(fread(fid,1,'uint8')))*100+str2num(dec2hex(fread(fid,1,'uint8')));%   39,40
disp(['Height Numbers:',num2str(HeightStepNumber)]);
HeightStop=HeightStart+HeightStep*HeightStepNumber;
disp(['Height Stopping:',num2str(HeightStop),' km']);
Delay=str2num(dec2hex(fread(fid,1,'uint8')))*100+str2num(dec2hex(fread(fid,1,'uint8')));% 41,42
BaseGain=str2num(dec2hex(fread(fid,1,'uint8')));%43
disp(['Base Gain:',num2str(BaseGain),' dB']);
FrequencySearchEnable=str2num(dec2hex(fread(fid,1,'uint8')));%44
OperatingMode=str2num(dec2hex(fread(fid,1,'uint8')));%45
DataFormatTag=str2num(dec2hex(fread(fid,1,'uint8')));%46
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
fread(fid,3,'uint8');% 49,50,51
CITLength=fread(fid,1,'uint8')*100+fread(fid,1,'uint8');%52,53
Journal=fread(fid,1,'char');%54
HeightWindowBottom=str2num(dec2hex(fread(fid,1,'uint8')))*100+str2num(dec2hex(fread(fid,1,'uint8')));%55,56
HeightWindowTop=str2num(dec2hex(fread(fid,1,'uint8')))*100+str2num(dec2hex(fread(fid,1,'uint8')));%57,58
HeightNumberStored=str2num(dec2hex(fread(fid,1,'uint8')))*100+str2num(dec2hex(fread(fid,1,'uint8')));%  59,60
%%%% Preface ended
%%%% Header ended
if HeightStepNumber==128
    FrequencyGroupNum=30;
    HeightBinNumber=128;
elseif HeightStepNumber==256
    FrequencyGroupNum=15;
    HeightBinNumber=256;
elseif HeightStepNumber==512
    FrequencyGroupNum=8;
    HeightBinNumber=498;
else
    disp('Height Step Number Error! Check the Data!'); 
end
FrequencyGroupLength=HeightBinNumber+6;
RemainingBytes=4096-FrequencyGroupNum*FrequencyGroupLength-60;
disp(['Remaining Bytes:',num2str(RemainingBytes)]);
FrequencyX=nan(length(FrequencyStart:FrequencyStep:FrequencyStop)-1,1);
FrequencyO=FrequencyX;
AmplitudeX=nan(HeightBinNumber,length(FrequencyStart:FrequencyStep:FrequencyStop)-1);
DopplerX=AmplitudeX;
AmplitudeO=AmplitudeX;
DopplerO=AmplitudeX;
Frequency=FrequencyStart:FrequencyStep:FrequencyStop-FrequencyStep;
FrequencyGroupTotal=2*length(Frequency);
BlockNum=ceil(FrequencyGroupTotal/FrequencyGroupNum);
%%%%    Block
ff=1;fq=0;ffo=0;ffx=0;
for block=1:BlockNum,
    %%%%    Frequency Group
    for freqgrp=1:FrequencyGroupNum
        fq=fq+1;
        if fq<=FrequencyGroupTotal
            %%%% Prelude
            Prelude1=fread(fid,1,'uint8'); % Byte1
            Polarization=floor(Prelude1/16);
            GroupSizeTag=mod(Prelude1,16);
            FrequencyReading=str2num(dec2hex(fread(fid,1,'uint8')))+str2num(dec2hex(fread(fid,1,'uint8')))/100; % Byte 2,3
%             disp(['Frequency Reading:',num2str(FrequencyReading)]);
            Prelude4=fread(fid,1,'uint8');% Byte 4
            Offset=floor(Prelude4/16);
            AdditionGain=mod(Prelude4,16);
            Sec=str2num(dec2hex(fread(fid,1,'uint8'))); % Byte 5
            MostProbableAmplitude=fread(fid,1,'uint8');% Byte 6
            %             disp(['Most Probable Amplitude:',num2str(MostProbableAmplitude)]);
            if Polarization==2,
                ffx=ffx+1;
                FrequencyX(ffx)=FrequencyReading;
                MPAX(ffx)=MostProbableAmplitude;
                ADGX(ffx)=AdditionGain;
%                 disp(['Frequency :',num2str(FrequencyReading),'  X wave']);
                %                 disp(['Most Probable Amplitude:',num2str(MostProbableAmplitude)]);
            else
                ffo=ffo+1;
                FrequencyO(ffo)=FrequencyReading;
                MPAO(ffo)=MostProbableAmplitude;
                ADGO(ffo)=AdditionGain;
%                 disp(['Frequency :',num2str(FrequencyReading),'  O wave']);
                %                 disp(['Most Probable Amplitude:',num2str(MostProbableAmplitude)]);
            end
            %%%%    Prelude Ended
            %%%%    Height Bin
            hh=1;
            for i=1:HeightBinNumber,
                ContentByte1=fread(fid,1,'uint8');
                if Polarization==2,
                    AmplitudeX(hh,ffx)=floor(ContentByte1/8);
                    DopplerX(hh,ffx)=mod(ContentByte1,32);
                else
                    AmplitudeO(hh,ffo)=floor(ContentByte1/8);
                    DopplerO(hh,ffo)=mod(ContentByte1,32);
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
end,
%%%% Block Ended



subplot(321);pcolor(AmplitudeO);shading interp;

AmplitudeO1 = AmplitudeO;
for i = 1:length(MPAO),
    tmp = AmplitudeO1(:,i);
    tmp(tmp < MPAO(i) + 3 ) = 0;
    AmplitudeO1(:,i) = tmp;
end,
subplot(322);pcolor(AmplitudeO1);%shading interp;

AmplitudeO1 = AmplitudeO;
for i = 1:length(MPAO),
    tmp = AmplitudeO1(:,i);
    tmp(tmp < MPAO(i) + 6 ) = 0;
    AmplitudeO1(:,i) = tmp;
end,
subplot(323);pcolor(AmplitudeO1);%shading interp;

AmplitudeO1 = AmplitudeO;
for i = 1:length(MPAO),
    tmp = AmplitudeO1(:,i);
    tmp(tmp < MPAO(i) + 0 ) = 0;
    AmplitudeO1(:,i) = tmp;
end,
subplot(324);pcolor(AmplitudeO1);shading interp;

    AmplitudeO1 = AmplitudeO;
for i = 1:length(MPAO),
    tmp = AmplitudeO1(:,i);
    tmp(tmp < MPAO(i) + 1 ) = 0;
    AmplitudeO1(:,i) = tmp;
end,
subplot(325);pcolor(AmplitudeO1);shading interp;

AmplitudeO1 = AmplitudeO;
for i = 1:length(MPAO),
    tmp = AmplitudeO1(:,i);
    tmp(tmp < MPAO(i) + 2 ) = 0;
    AmplitudeO1(:,i) = tmp;
end,
subplot(326);pcolor(AmplitudeO1);shading interp;



% %title([num2str(Year),' ',num2str(Month),' ',num2str(Day),' ',num2str(Hour),' ',num2str(Minute),' ',num2str(Second)]);
% subplot(1,2,1);pcolor(AmplitudeO);colorbar;
% title('O wave');
% subplot(1,2,2);pcolor(AmplitudeX);colorbar;
% title('X wave');
% figure;
% hist(AmplitudeO(:),(1:31)); % 注意hist(AmplitudeO(:))与hist(AmplitudeO)是有区别的，前者返回的是一个向量，后者返回的是矩阵，画出的图不一样
% set(gca,'xlim',[0,32]);
% figure;
% subplot(2,1,1);
% plot(ADGO);
% subplot(2,1,2);
% plot(MPAO/3);
% 
% a=median(AmplitudeO,1);
% figure;
% subplot(311);plot(MPAO);
% ylim([0,32]);
% subplot(312);plot(a);
% ylim([0,32]);
% subplot(313);plot(MPAO-a);
% ylim([0,32]);
