function [] = DPMqc(reg_files, param_paths)
%
% function [] = DPMqc(reg_paths_txt_file, diffparams_paths_txt_file, template_option)
% 
% Create a report of the quality of diffusion MRI parameter maps, using white 
% matter ROIs to aid identification of outliers.
%
% Inputs:
% REG_FILES - Path to .txt file listing target images for 
% atlas registration.
% If parameter maps are in a template space the text file contains the 
% filename of the template target image. 
% If the parameter maps are in native space the text file contains a list 
% target images for each dataset. 
% PARAM_PATHS - Path to .txt file listing folders containing 
% diffusion parameter maps.

%
% Outputs:
% - list of subjects mean parameter values for each ROI
% - violin plot of distribution of mean parameter values for each ROI
% across subjects
% - report on the parameter map quality
% 
% Example usage:
% DPMqc('~/mytargetfiles.txt', '~/myparampaths.txt, false)
% where ~/myparampaths.txt might look like this:
% ~/mystudy/subj1/DiffusionMaps
% ~/mystudy/subj2/DiffusionMaps
% ...
% ~/mystudy/subjN/DiffusionMaps
%
% and ~/mytargetfiles.txt might look like this:
% ~/mystudy/subj1/DiffusionMaps/dti_FA.nii.gz
% ~/mystudy/subj2/DiffusionMaps/dti_FA.nii.gz
% ...
% ~/mystudy/subjN/DiffusionMaps/dti_FA.nii.gz

%% Processing folder
mkdir('DPMqc');

%% Targets and maps
reg_files=readtable(reg_files,'ReadVariableNames',false); 
param_paths=readtable(params_paths,'ReadVariableNames',false); 
nreg=numel(reg_files);
ndata=numel(param_paths);

%% Atlas
jhu_path='/usr/local/fsl/data/atlases/JHU';
atlas_image=[jhu_path '/JHU-ICBM-FA-1mm.nii.gz'];
atlas_labels=[jhu_path '/JHU-ICBM-labels-1mm'];

%% List Registration Pairs
parfor i=1:nreg
    regpairs{i}{1}=reg_files{i};
    regpairs{i}{2}=atlas_image;
end

%% Register
parfor i=1:nreg
    registerimages(regpairs{i},i);
end

%% Propagate Labels
parfor i=1:nreg
    transformlabels(atlas_labels,regpairs{1},i);
end

%% Mean parameters in ROIs
parfor i=1:ndata
    
end


%% Plot

%% Report