close all
clear all
warning('off','all');
sympref('HeavisideAtOrigin',1);
fontsize=18;
fontname = 'Palatino';
set(0,'defaultlinelinewidth',1.5);
set(0,'defaulttextinterpreter','Latex');
set(0, 'defaulttextfontsize', fontsize);
set(0, 'defaultaxesfontsize', fontsize);
set(0,'defaulttextfontname', fontname);
set(0,'defaultaxesfontname', fontname);


path = uigetdir();
listing = dir(path);
ftable = struct2table(listing);
filter = ftable.isdir == false;
ftable = ftable(filter,:);
files = fullfile(ftable.folder,ftable.name);
ftable.files_paths = files;
min_r = zeros(size(files));


l_t = length(files);
files_out = strrep(ftable.name, ',', '.');
dopant =  strings([l_t,1]);
amp = zeros([l_t,1]);
freq = zeros([l_t,1]);
Rs = zeros([l_t,1]);
data = {};
for i = 1:l_t
    data_from_filename = sscanf(files_out{i},'mem%f_sine_%fV_%fHz.txt');
    switch round(data_from_filename(1))
        case 1
            dopant(i) = "Tungsten";
            Rs(i) = 5.11;
        case 2 
            dopant(i) = "Tin";
            Rs(i) = 5.11;
        case 3
            dopant(i) = "Chromium";
            Rs(i) = 5.11;
        case 4
            dopant(i) = "Carbon";
            Rs(i) = 47.5;
    end
        amp(i) = data_from_filename(2);
        freq(i) = data_from_filename(3);
        data{i}.Amp = amp(i);
        data{i}.Freq = freq(i);
        data{i}.Dop =  dopant(i);
        data{i}.Rs = Rs(i);
end

for i   =  not_good
    stats = get_statistical_values(files{i},true,Rs(i),false);
    U_m = stats.U_m;
    I_m = stats.I_m;
    t = stats.t; 
    data{i}.U_m = U_m;
    data{i}.I_m = I_m;
    data{i}.t = t;
    [b_end_parameters,a,min_r(i)] = fit_VTEAM(U_m,I_m,t,Rs(i));
    data{i}.min_r = min_r(i);
    data{i}.param = b_end_parameters;
    data{i}.a = a;
    [data{i}.X,data{i}.G,data{i}.V,data{i}.I] = VTEAM_model(t, b_end_parameters, U_m,a,Rs(i));
    fprintf('Iteration: %d,\tFile: %s,\tcost function:%g\n', i,files_out{i},min_r(i));
end

ftable.min_r = min_r;
ftable.Amplituda = round(amp,1);
ftable.Domieszkowanie = dopant;
ftable.Czestotliwosc = round(freq);
table = ftable(:,8:11); 
writetable(table,'optim_MMS_od_zera.csv','WriteRowNames',true);
