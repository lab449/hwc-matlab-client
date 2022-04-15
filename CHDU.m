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
           [obj, ok] = obj.chdu_connect();

           obj.file_directory = 'files';
           obj.auth_filename = 'client/auth_config.json';
           if exist(obj.auth_filename, 'file') == 2
               obj = obj.read_auth_config();
           else
               obj = obj.get_auth_data();
           end
           if ~exist(obj.file_directory, 'dir')
               mkdir(obj.file_directory);
           end
           addpath(obj.file_directory)
           fprintf('CHDU session was started\n')
       end
       function [obj, ok] = chdu_connect(obj)
           obj.servername = 'http://127.0.0.1:5000';
           obj.connect_options = weboptions('ContentType', 'auto', ...
               'CharacterEncoding', 'UTF-8');
%            , ...
%                'CertificateFilename', 'client/hdu_checker_pub.pem');
           ok = webread(strcat(obj.servername,'/ok'), obj.connect_options);
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
           obj.auth_data.name = input('Your name: ', 's');
           obj.auth_data.id = input('Your ID: ', 's');
           obj.auth_data.email = input('Type your affiliated with university EMail: ', 's');
           request_msg.auth = obj.auth_data;
           response_msg = webwrite(strcat(obj.servername,'/register'), request_msg, obj.connect_options);
           if response_msg.isError == 1
               return
           end
           obj.auth_data.token = input('Key from EMail: ', 's');
           response_msg = webwrite(strcat(obj.servername,'/login'), request_msg, obj.connect_options);
           if response_msg.isError == 1
               return
           end
           fid=fopen(obj.auth_filename,'w');
           fprintf(fid, jsonencode(obj.auth_data));
       end
       function task = get_task(obj, number)
           request_msg.auth = obj.auth_data;
           request_msg.number = number;
           response_msg = webwrite(strcat(obj.servername,'/gettask'), request_msg, obj.connect_options);
           task.parameters = response_msg.data.parameters
           task.answers = response_msg.data.answers
           task.files = cell2mat(response_msg.data.files)
%            disp(task)
           for i=1:size(task.files,1)
               websave(strcat(obj.file_directory, task.files(i),'.pdf'),strcat(obj.servername,task.files), obj.connect_options);
           end 
       end
       function score = send_task(obj, task)
           request_msg.auth = obj.auth_data;
           request_msg.task = task;
           response_msg = webwrite(strcat(obj.servername,'/send_task'), request_msg, obj.connect_options);
           score = jsondecode(response_msg).Score;
       end
   end
end