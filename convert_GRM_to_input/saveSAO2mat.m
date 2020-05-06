%SAO File Dir
SAO_DIR = 'F:\Ionosonde\Wuhan\2018';
file=dir(fullfile(SAO_DIR));
   for ifile=length(file):-1:1,
       if file(ifile).isdir==1, file(ifile)=[]; continue; end;
       if isempty(strfind(lower(file(ifile).name),'sao')),
          file(ifile)=[]; continue;
       end;
       [t_F2O,t_F1O,t_EO,TS] = ReadSAOTrace(SAO_DIR,file(ifile).name);
       save_name = ['SAO_pick/',file(ifile).name,'.mat']
       save(save_name,'t_EO','t_F1O','t_F2O','TS')
   end;