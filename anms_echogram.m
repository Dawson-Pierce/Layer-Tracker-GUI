function [detection, non_surpressed_detection] = anms_echogram(data,anms_surpression_cutoff,trim_vals)

bed_data = track_bed(data, 0.4, 70);

detection = cell(1,size(data,2));
non_surpressed_detection = detection;

% Perform ANMS
for k = 1:size(data,2)
    [peak_data,peak_loc] = findpeaks(data(:,k));    

    % Only save detection toward the top for initial testing
    trim_idx = (peak_loc > trim_vals(1))&(peak_loc < trim_vals(2));
    trim_bed_loc = peak_loc(trim_idx);
    trim_bed_data = peak_data(trim_idx);

    table = [trim_bed_data, trim_bed_loc];

    if size(table,1) > anms_surpression_cutoff
        surpressed_table = anms (table, anms_surpression_cutoff);
    else
        surpressed_table = table;
    end

    %detection{1,k} = trim_bed_loc;
    detection{1,k} = surpressed_table(:,2)';
    non_surpressed_detection{1,k} = trim_bed_loc';
    
end

%% Functions

function supressed_table = anms (table, num_peaks)
    table = sortrows(table, 1, "descend");

    temp = zeros(size(table,1), size(table,2) + 1);% Add column for surpression radius data

    % First peak initialization
    temp (1,1:2) = table(1,:);
    temp (1,4) = 10000;
    table(1,:) = [];

    % Iterate throught the rest of the table
    for i = 2:size(temp,1)
        temp (i, 1:2) = table (1,:);

        % Query distance from temp table
        dist = 10000;
        for j = 1:i-1
            cur_dist = abs(temp(i,2) - temp (j,2));
            if cur_dist < dist
                dist = cur_dist;
            end
        end
        temp (i,4) = dist;

        table (1,:) = [];
    end

    temp = sortrows(temp,4,"descend");

    supressed_table = temp(1:num_peaks, 1:2);
end
end

function layer_data = track_bed(data, range_cutoff, filter_window_ratio)
        cut_off_range_idx = round(size(data,1) * range_cutoff);
    
        data(1:cut_off_range_idx,:) = [];
    
        layer_data = [];
        for i = 1:size(data,2)
            cur_ascope = data(:,i);
            detrend_ascope = detrend(cur_ascope,3);
    
    
            [peak_val, peak_loc] = findpeaks(detrend_ascope);
            [~,max_loc] = max(peak_val);
            
            layer_data = horzcat(layer_data, [i; peak_loc(max_loc)]);
        end
        layer_data(2,:) = movmean(layer_data(2,:), size(layer_data,2)/filter_window_ratio);
        layer_data(2,:) = layer_data(2,:) + cut_off_range_idx;
end