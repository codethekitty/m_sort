%% edit path

addpath('functions');

%% Get superblocks
clear

clc
tic
rf_user_list=[2:3];

tank_path = 'Z:\khri-ses-lab\Shore-Basic-Science\Mike\Analysis\Single Unit Data\X Treatment Animals\X4_10_28_2020';
save_dir = 'Z:\khri-ses-lab\Shore-Basic-Science\Mike\Analysis\Single Unit Data\X Treatment Animals\X4_debug';
superblocks = build_sb(tank_path, save_dir, rf_user_list)
%
% coordinate=struct;
% coordinate.angle=35;
% coordinate.x=-3;
% coordinate.y=3.5;
% coordinate.z=7;
% save(fullfile(save_dir,'coordinate.mat'),'coordinate','-v7.3')

toc
%% Load superblock
clear;clc;
tank_path = 'Z:\Jenn\Analysis\Electrophysiology\S animal data\S8';
save_dir = 'Z:\Jenn\Analysis\Electrophysiology\S animal data\S8\Position 1';
superblocks=load_sb(save_dir)

%% Sorting
clc
m_sort(superblocks, tank_path, save_dir,'skip') 



%% Typing

fdir = '\\maize.umhsnas.med.umich.edu\khri-ses-lab\Calvin\Analysis\scc\CW_SCn1\loc2';

fdir = save_dir;

if ~exist(fullfile(fdir,'type'))
   mkdir(fullfile(fdir,'type'));
   x=0;
else
   x=1;
end

alldata = what(fdir);
alldata = alldata.mat;
alldata = cellfun(@(x) x(1:end-4),alldata,'uniformoutput',0);

sorteddata = what(fullfile(fdir,'type'));
sorteddata = sorteddata.mat;
sorteddata = cellfun(@(x) x(1:end-6),sorteddata,'uniformoutput',0);

w = alldata(find(~contains(alldata,sorteddata),1)-x:end);

for i=1:length(w)
   fname = w{i};
   L=load(fullfile(fdir,fname));
   for j=1:length(L.sst_sorted)
      sst=L.sst_sorted{j};
      fprintf('typing %s-%d...\n',fname,j);
      result = unitTypingAuto(sst)
      if ~isempty(result)
        [result.user_str,result.user_bf,result.user_thr] = unitTypingGUI(sst,result.bf);
      else
        [result.user_str,result.user_bf,result.user_thr] = unitTypingGUI(sst);
      end
      save(fullfile(fdir,'type',[fname '-' num2str(j) '.mat']),'result','-v7.3');
      fprintf('%s-%d saved.\n\n',fname,j);
   end
end
fprintf('\nall done.\n');