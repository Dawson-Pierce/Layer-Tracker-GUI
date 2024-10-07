clear; clc; close all

%% Arrange Files

% file_name = '20181231_044516.mat';

runs{1}.file_name = '20181231_044516.mat';
runs{1}.data_idx = 1:size(load("20181231_044516.mat").wiener2_modified,2);
runs{1}.trim_vals = [0 700];

runs{2}.file_name = '20190107_213008.mat';
runs{2}.data_idx = 1:1000;
runs{2}.trim_vals = [0 550];

runs{3}.file_name = '20181219_035408.mat';
runs{3}.data_idx = 1000:1800;
runs{3}.trim_vals = [0 475];



%% Run through files

for k = 1:length(runs)

file_name = runs{k}.file_name;

load(file_name)

runs{k}.data = wiener2_modified;

runs{k}.truth = load(['Truth-', file_name]);

runs{k}.tracker = load(['TrackerResults-', file_name]);

addpath("_common\")

% data_idx = 1:size(data,2);
% trim_vals = [0 600];

% Lining up the truth data by interpolation 
new_x = cell(1);
new_y = cell(1);

for kk = 1:length(runs{k}.truth.t)
    [new_x{kk},new_y{kk}] = interp_layer(runs{k}.truth.t{kk}(1,:),runs{k}.truth.t{kk}(2,:),runs{k}.data);
end

t = cell(1);

for kk = 1:length(new_x)
    t{kk} = [new_x{kk}; new_y{kk}];
end


%% OSPA time

runs{k}.ospa_vals= zeros(length(runs{k}.data_idx),3);
ospa_c= 10;
ospa_p= 2;

for kk = 1:length(runs{k}.data_idx) % size(data,2)

    truth_x = [];
    tracker_x = [];

    for kkk = 1:length(t)
        truth_x = [truth_x new_y{kkk}(kk)];
    end

    for kkk = 1:length(runs{k}.tracker.s.full_tracks)
        % in case tracker didn't track all the way to the end, the cutoff
        % is like 98% of the length
        tracker_x = [tracker_x interp1(runs{k}.tracker.s.full_tracks{kkk}(1,:),runs{k}.tracker.s.full_tracks{kkk}(2,:),kk,"linear","extrap")];
        % tracker_x = [tracker_x s.full_tracks{kk}(2,k)];
    end

    % for kk = 1:length(s.full_tracks2)
    %     for kkk = 1:length(s.full_tracks2{kk})
    %         if ~isempty(s.full_tracks2{kk}{kkk})
    %             tracker_x = [tracker_x s.full_tracks2{kk}{kkk}(2,k)];
    %         end
    %     end
    % end

    [runs{k}.ospa_vals(kk,1),runs{k}.ospa_vals(kk,2),runs{k}.ospa_vals(kk,3)]= ospa_dist(truth_x,tracker_x,ospa_c,ospa_p);
end

end

%% ALL PLOTS

% figure;
% subplot(3,1,1); 
% plot(data_idx,ospa_vals(:,1),'k','LineWidth',1); grid on; % set(gca, ']XLim',[1 size(data,2)]); set(gca, 'YLim',[0 ospa_c]); 
% ylabel('OSPA Dist'); title('OSPA Plots')
% subplot(3,1,2); 
% plot(data_idx,ospa_vals(:,2),'k','LineWidth',1); grid on; % set(gca, 'XLim',[1 size(data,2)]); set(gca, 'YLim',[0 ospa_c]); 
% ylabel('OSPA Loc');
% subplot(3,1,3); 
% plot(data_idx,ospa_vals(:,3),'k','LineWidth',1); grid on; % set(gca, 'XLim',[1 size(data,2)]); set(gca, 'YLim',[0 ospa_c]); 
% ylabel('OSPA Card');
% 
% saveas(gca,'OSPA.png')
% 
% 
% figure;
% subplot(1,3,1);
% imagesc(data); colormap(1-gray); hold on
% for k = 1:length(s.full_tracks)
%     same_track_flag = 0;
%     for kk = 1:length(s.full_tracks2)
%         for kkk = 1:length(s.full_tracks2{kk})
%             if ~isempty(s.full_tracks2{kk}{kkk}) && all(abs(s.full_tracks{k}(2,:) - s.full_tracks2{kk}{kkk}(2,:)) < 3)
%                 same_track_flag = 1;
%             elseif same_track_flag ~= 1
%                 same_track_flag = 0;
%             end
%         end
%     end
%     if same_track_flag == 0
%         plot(s.full_tracks{k}(1,:),s.full_tracks{k}(2,:),'r','LineWidth',1)
%     end
% end
% xlabel("(a)")
% ylim(trim_vals)
% xlim([data_idx(1) data_idx(end)])
% 
% subplot(1,3,2);
% imagesc(data); colormap(1-gray); hold on
% for k = 1:length(s.full_tracks)
%     plot(s.full_tracks{k}(1,:),s.full_tracks{k}(2,:),'r','LineWidth',1)
% end
% 
% for k = 1:length(s.full_tracks2)
%     for kk = 1:length(s.full_tracks2{k})
%         if ~isempty(s.full_tracks2{k}{kk})
%             plot(s.full_tracks2{k}{kk}(1,:),s.full_tracks2{k}{kk}(2,:),'r','LineWidth',1)
%         end
%     end
% end
% xlabel("(b)")
% ylim(trim_vals)
% xlim([data_idx(1) data_idx(end)])
% 
% subplot(1,3,3);
% imagesc(data); colormap(1-gray); hold on
% for k = 1:length(t)
% plot(new_x{k},new_y{k},'r','LineWidth',1)
% end
% xlabel("(c)")
% ylim(trim_vals)
% xlim([data_idx(1) data_idx(end)])
% saveas(gca,'FullProcess.png')
% 
% figure;
% imagesc(data); colormap(1-gray); hold on
% for k = 1:length(s.full_tracks)
%     same_track_flag = 0;
%     for kk = 1:length(s.full_tracks2)
%         for kkk = 1:length(s.full_tracks2{kk})
%             if ~isempty(s.full_tracks2{kk}{kkk}) && all(abs(s.full_tracks{k}(2,:) - s.full_tracks2{kk}{kkk}(2,:)) < 3)
%                 same_track_flag = 1;
%             elseif same_track_flag ~= 1
%                 same_track_flag = 0;
%             end
%         end
%     end
%     if same_track_flag == 0
%         plot(s.full_tracks{k}(1,:),s.full_tracks{k}(2,:),'r','LineWidth',1)
%     end
% end
% ylim(trim_vals)
% xlim([data_idx(1) data_idx(end)])
% saveas(gca,'Innit-Tracker-Image.png')
% 
% figure;
% imagesc(data); colormap(1-gray); hold on
% for k = 1:length(s.full_tracks)
%     plot(s.full_tracks{k}(1,:),s.full_tracks{k}(2,:),'r','LineWidth',1)
% end
% 
% for k = 1:length(s.full_tracks2)
%     for kk = 1:length(s.full_tracks2{k})
%         if ~isempty(s.full_tracks2{k}{kk})
%             plot(s.full_tracks2{k}{kk}(1,:),s.full_tracks2{k}{kk}(2,:),'r','LineWidth',1)
%         end
%     end
% end
% ylim(trim_vals)
% xlim([data_idx(1) data_idx(end)])
% saveas(gca,'Full-Tracker-Image.png')
% 
% figure;
% imagesc(data); colormap(1-gray); hold on
% xlabel('Meters')
% ylabel('Meters')
% xlim([data_idx(1) data_idx(end)])
% saveas(gca,'IceLayers.png')
% 
% figure;
% imagesc(data); colormap(1-gray); hold on
% for k = 1:length(t)
% plot(new_x{k},new_y{k},'r','LineWidth',1)
% end
% ylim(trim_vals)
% xlim([data_idx(1) data_idx(end)])
% saveas(gca,'Truth-Tracks-Image.png')
% 
% ascope_idx = 34;
% [PKS,LOCS] = findpeaks(data(:,ascope_idx));
% [PKS,idx] = sort(PKS);
% LOCS = LOCS(idx);
% 
% figure; 
% plot(data(:,ascope_idx),'k','LineWidth',1.5); hold on; grid on
% scatter(LOCS,PKS,'ro')
% 
% arrow_length = 1;
% 
% ta = annotation('textarrow', [0.6 0.7], [0.85 0.9]);
% ta.String = 'Bed Detection';
% 
% ta2 = annotation('textarrow', [0.23 0.23], [0.8 0.65]);
% ta2.String = 'IL Detection';
% 
% % ta3 = annotation('textarrow', [0.48 0.48], [0.7 0.5]);
% % ta3.String = 'Clutter';
% 
% ta3 = annotation('textarrow', [0.6 0.63], [0.5 0.4]);
% ta3.String = 'Clutter';
% 
% saveas(gca,'ascope-example.png')
% 
% [detection1, ~] = anms_echogram(data,45,[0 600]);
% [detection2, non_surpressed_detection] = anms_echogram(data,20,[0 600]);
% figure;
% subplot(1,3,1)
% imagesc(data); hold on
% colormap (1-gray)
% for k = 1:1:size(data,2)
%     x = k*ones(size(non_surpressed_detection{1,k},2),1);
%     y = non_surpressed_detection{1,k}(:,:);
%     scatter(x, y, 'r.');
% end
% xlabel("(c)")
% ylim(trim_vals)
% xlim([data_idx(1) data_idx(end)])
% 
% subplot(1,3,2) 
% imagesc(data); hold on
% colormap (1-gray)
% for k = 1:1:size(data,2)
%     x = k*ones(size(detection1{1,k},2),1);
%     y = detection1{1,k}(:,:);
%     scatter(x, y, 'r.');
% end
% xlabel("(b)")
% ylim(trim_vals)
% xlim([data_idx(1) data_idx(end)])
% 
% subplot(1,3,3) 
% imagesc(data); hold on
% colormap (1-gray)
% for k = 1:1:size(data,2)
%     x = k*ones(size(detection2{1,k},2),1);
%     y = detection2{1,k}(:,:);
%     scatter(x, y, 'r.');
% end
% xlabel("(c)")
% ylim(trim_vals)
% xlim([data_idx(1) data_idx(end)])
% 
% saveas(gca,'ANMS-Detections.png')

f=figure;
f.Position = [10 50 1400 720];
% figure
for k = 1:length(runs)
    subplot(length(runs),4,4*(k-1)+1)
    imagesc(runs{k}.data(:,runs{k}.data_idx)); colormap(1-gray); hold on
    xlim([1,length(runs{k}.data_idx)])
    ylim(runs{k}.trim_vals)

    subplot(length(runs),4,4*(k-1)+2)
    imagesc(runs{k}.data(:,runs{k}.data_idx)); colormap(1-gray); hold on
    for kk = 1:length(runs{k}.truth.t)
        plot(runs{k}.truth.t{kk}(1,:),runs{k}.truth.t{kk}(2,:),'r','LineWidth',1)
    end
    xlim([1,length(runs{k}.data_idx)])
    ylim(runs{k}.trim_vals)

    subplot(length(runs),4,4*(k-1)+3)
    imagesc(runs{k}.data(:,runs{k}.data_idx)); colormap(1-gray); hold on
    for kk = 1:length(runs{k}.tracker.s.full_tracks)
        plot(runs{k}.tracker.s.full_tracks{kk}(1,:),runs{k}.tracker.s.full_tracks{kk}(2,:),'r','LineWidth',1)
    end
    xlim([1,length(runs{k}.data_idx)])
    ylim(runs{k}.trim_vals)

    subplot(length(runs),4,4*(k-1)+4)
    plot(1:length(runs{k}.data_idx),runs{k}.ospa_vals(:,2),'LineWidth',1); hold on; grid on
    xlim([1,length(runs{k}.data_idx)])

    if k == length(runs)
        subplot(k,4,4*(k-1)+1)
        xlabel('(a)')
        subplot(k,4,4*(k-1)+2)
        xlabel('(b)')
        subplot(k,4,4*(k-1)+3)
        xlabel('(c)')
        subplot(k,4,4*(k-1)+4)
        xlabel('(d)')
    end

end

%% Functions 

function [X,Y] = interp_layer(prev_X,prev_Y,data)
X = 1:size(data,2);
Y = interp1(prev_X,prev_Y,X,"linear","extrap");
end
