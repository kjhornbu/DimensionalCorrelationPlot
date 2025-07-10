function [plotting_Data] = clean_for_plotting(reduced_Filtered_Stats,pval_type)
%% Marker_Setup
MarkerSize_value = linspace(4,18,15); %Range of values for the Markers
MarkerSize_setting = (MarkerSize_value-MarkerSize_value(1))/(MarkerSize_value(end)-MarkerSize_value(1)); %getting a 0 to 1 range to compare with
%% Marker Face Colors
MarkerFaceColor =[[26 133 255]/255; [26 133 255]/255;  [212 17 89]/255; [212 17 89]/255];
%% Marker Edge Colors
MarkerEdgeColor = [[0.75 0.75 0.75]; [212 17 89]/255;[26 133 255]/255;[0.75 0.75 0.75]];

%% Scaling to 0 - 1 Values
for n = 1:numel(reduced_Filtered_Stats)
    Color(:,n)=reduced_Filtered_Stats{n}.PercentChange;
    ABS_color(:,n) = abs(reduced_Filtered_Stats{n}.PercentChange);
end

min_Color = min(reshape(ABS_color,1,[]));
max_Color = max(reshape(ABS_color,1,[]));
ColorLogical = Color>0;

for n = 1:numel(reduced_Filtered_Stats)
    ColorCell{:,n} = num2str(ColorLogical(:,n));
    reduced_Filtered_Stats{n}.minMaxScaled_PercentChange = (ABS_color(:,n)-min_Color)./(max_Color-min_Color);
end

ColorStr=horzcat(ColorCell{:});
color_idx=bin2dec(ColorStr)+1;

plotting_Data=table;

PerChange_MinMaxScale_Avg = mean([reduced_Filtered_Stats{1}.minMaxScaled_PercentChange, reduced_Filtered_Stats{2}.minMaxScaled_PercentChange],2);
[~,idx]=min(abs(PerChange_MinMaxScale_Avg-MarkerSize_setting)');

plotting_Data.MarkerSize = MarkerSize_value(idx)';

plotting_Data.MarkerFaceColor_r=MarkerFaceColor(color_idx,1);
plotting_Data.MarkerFaceColor_g=MarkerFaceColor(color_idx,2);
plotting_Data.MarkerFaceColor_b=MarkerFaceColor(color_idx,3);

plotting_Data.MarkerEdgeColor_r=MarkerEdgeColor(color_idx,1);
plotting_Data.MarkerEdgeColor_g=MarkerEdgeColor(color_idx,2);
plotting_Data.MarkerEdgeColor_b=MarkerEdgeColor(color_idx,3);

%% Really need a join here to make sure order is proper remove everything don't need in total filtered stats? and append straitfication/ pval type with dim # -- yes
for n=1:numel(reduced_Filtered_Stats)
    if n==1 %For first dimension only setup what you need into the table.
        plotting_Data.GN_Symbol=reduced_Filtered_Stats{n}.GN_Symbol;
        plotting_Data.contrast=reduced_Filtered_Stats{n}.contrast;
        plotting_Data.source_of_variation=reduced_Filtered_Stats{n}.source_of_variation;

        plotting_Data.(strcat('stratification_Dim',num2str(n))) = reduced_Filtered_Stats{n}.stratification;
        plotting_Data.(strcat(pval_type,'_Dim',num2str(n))) = reduced_Filtered_Stats{n}.(pval_type);

        [strat_keeper]=unique(reduced_Filtered_Stats{n}.stratification);
        [contrast_keeper]=unique(reduced_Filtered_Stats{n}.contrast);
        [source_keeper]=unique(reduced_Filtered_Stats{n}.source_of_variation);

    else
        [~,~,iright] = innerjoin(plotting_Data,reduced_Filtered_Stats{n});

        plotting_Data.(strcat('stratification_Dim',num2str(n))) = reduced_Filtered_Stats{n}.stratification(iright);
        plotting_Data.(strcat(pval_type,'_Dim',num2str(n))) = reduced_Filtered_Stats{n}.(pval_type)(iright);

        %check that straification of dims are the same

        [strat_keeper(n)]=unique(reduced_Filtered_Stats{n}.stratification);
        [contrast_keeper(n)]=unique(reduced_Filtered_Stats{n}.contrast);
        [source_keeper(n)]=unique(reduced_Filtered_Stats{n}.source_of_variation);

    end

    strat_keeper_value=unique(strat_keeper);
    contrast_keeper_value=unique(contrast_keeper);
    source_keeper_value=unique(source_keeper);

    if numel(source_keeper_value)>1 | numel(contrast_keeper_value)>1 | numel(strat_keeper_value)~=n
        error('Hey your system does not have the correct size for either source of variation, contrast, or stratification! Check those!');
    end

end
end