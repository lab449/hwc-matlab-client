classdef CHDU
   properties
      auth_data struct
      connect_options weboptions
      auth_filename string
      servername string
      file_directory string
   end
   methods
       function obj = CHDU()
           [obj, ok_code] = obj.chdu_connect();
           if ok_code.statusCode ~= 200
               fprintf('Server error')
               return
           end
           
           obj.file_directory = 'files';
           obj.auth_filename = 'auth_config.json';
           if exist(obj.auth_filename, 'file') == 2
               obj = obj.read_auth_config();
           else
               obj = obj.get_auth_data();
           end
           if ~exist(obj.file_directory, 'dir')
               mkdir(obj.file_directory);
           end
           addpath(obj.file_directory)
       end
       function [obj, ok] = chdu_connect(obj)
           obj.servername = 'http://hdu.vedyakov.com:5000';
           obj.connect_options = weboptions('ContentType', 'auto', ...
               'CharacterEncoding', 'UTF-8');
%            , ...
%                'CertificateFilename', 'client/hdu_checker_pub.pem');
           ok = webread(strcat(obj.servername,'/ok'), obj.connect_options);
       end
       function ok = login(obj)
           try
               request_msg.auth = obj.auth_data;
               response_msg = webwrite(strcat(obj.servername,'/login'), request_msg, obj.connect_options);
           catch e
               ok = 0;
           end
           ok = 1;
       end
       function obj = read_auth_config(obj)
           fid = fopen(obj.auth_filename); 
           str = char(fread(fid,inf)'); 
           fclose(fid);
           obj.auth_data = jsondecode(str);
       end
       function obj = get_auth_data(obj)
           obj.auth_data = struct;
           fprintf('\n\n***Registration***\n');
           obj.auth_data.name = input('Your full name: ', 's');
           obj.auth_data.id = input('Your HDU ID: ', 's');
           obj.auth_data.email = input('Type your affiliated with university EMail: ', 's');
           request_msg.auth = obj.auth_data;
           response_msg = webwrite(strcat(obj.servername,'/register'), request_msg, obj.connect_options);
           obj.auth_data.token = input('Key from EMail: ', 's');

           fid=fopen(obj.auth_filename,'w');
           fprintf(fid, jsonencode(obj.auth_data));
       end
       function task = get_task(obj, number)
           request_msg.auth = obj.auth_data;
           request_msg.number = number;
           response_msg = webwrite(strcat(obj.servername,'/gettask'), request_msg, obj.connect_options);
           task.number = number;
           task.parameters = response_msg.data.parameters;
           task.answers = response_msg.data.answers;
           task.files = response_msg.data.files;
           for i=1:size(task.files,1)
               [p, name, ext] = fileparts(task.files{i});
               websave(fullfile(obj.file_directory, strcat(name, ext)),strcat(obj.servername,task.files), obj.connect_options);
           end 
       end
       function score = send_task(obj, task)
           request_msg.auth = obj.auth_data;
           request_msg.task = task;
           response_msg = webwrite(strcat(obj.servername,'/send_task'), request_msg, obj.connect_options);
           if response_msg.message ~= ""
               disp(response_msg.message)
           end
           score = response_msg.data;
       end
   end
end