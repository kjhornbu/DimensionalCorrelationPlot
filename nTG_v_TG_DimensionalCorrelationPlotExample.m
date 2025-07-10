clear all;
close all;

Stats_1 = civm_read_table("/20.5xFAD.01/stats/Scalar_and_Volume/anova-StratifiedGenotype_allFixed/Non_Erode/Bilateral__ntg/Group_Statistical_Results_withoutPairwiseComparisions_Sex_Strain_Scanner.csv");
Stats_2 = civm_read_table("/20.5xFAD.01/stats/Scalar_and_Volume/anova-StratifiedGenotype_allFixed/Non_Erode/Bilateral__tg/Group_Statistical_Results_withoutPairwiseComparisions_Sex_Strain_Scanner.csv");

Group_Data_1 = civm_read_table("/20.5xFAD.01/stats/Scalar_and_Volume/anova-StratifiedGenotype_allFixed/Non_Erode/Bilateral__ntg/Group_Data_Table_Sex_Strain_Scanner.csv");
Group_Data_2 = civm_read_table("/20.5xFAD.01/stats/Scalar_and_Volume/anova-StratifiedGenotype_allFixed/Non_Erode/Bilateral__tg/Group_Data_Table_Sex_Strain_Scanner.csv");

pval_type = 'NEGLog10_pval';
pval_type = 'NEGLog10_pval_BH';
pval_type = 'pval_BH';
pval_type = 'pval';

%save path and file name for the output plot
save_path = '/20.5xFAD.01/stats/Scalar_and_Volume/anova-StratifiedGenotype_allFixed/Non_Erode/pval_test.svg'; 

%% Dimension 1 Information
% This sets the percent change values across Dim 1; the First entry here is
% the control condition  -- This is used for the size and color of the ROI
% dot
Filter{1} = table;
Filter{1}.Data{1} = Group_Data_1;
Filter{1}.Field{1} = {'Sex','Strain','Scanner'}; 
Filter{1}.Entry{1} = {'M','^(-)$','^(-)$'};

Filter{1}.Data{2} = Group_Data_1;
Filter{1}.Field{2} = {'Sex','Strain','Scanner'};
Filter{1}.Entry{2} = {'F','^(-)$','^(-)$'};
%this is the actual data that is plotted for the given dimension (pvalue
%comparisions for a given source and contrast)
stats_Filter{1} = table;
stats_Filter{1}.Data{1} = Stats_1;
stats_Filter{1}.source{1} = {'^(Sex)$'};
stats_Filter{1}.contrast{1} = {'volume_fraction'};

%% Dimension 2 Information
% This sets the percent change values across Dim 2; the First entry here is
% the control condition  -- This is used for the size and color of the ROI
% dot
Filter{2} = table;
Filter{2}.Data{1} = Group_Data_2;
Filter{2}.Field{1} = {'Sex','Strain','Scanner'};
Filter{2}.Entry{1} = {'M','^(-)$','^(-)$'};

Filter{2}.Data{2} = Group_Data_2;
Filter{2}.Field{2} = {'Sex','Strain','Scanner'};
Filter{2}.Entry{2} = {'F','^(-)$','^(-)$'};

%this is the actual data that is plotted for the given dimension (pvalue
%comparisions for a given source and contrast) -- This ones source and
%contrast must be the same as Dimension 1's information
stats_Filter{2} = table;
stats_Filter{2}.Data{1} = Stats_2;
stats_Filter{2}.source{1} = {'^(Sex)$'};
stats_Filter{2}.contrast{1} = {'volume_fraction'};

dimensional_plot_main(stats_Filter,Filter,save_path,pval_type); 