classdef HWC
   properties
      auth_data struct
      connect_options weboptions
      auth_filename string
      servername string
      file_directory string
   end
   methods
       function obj = HWC(server)
           [obj, ok_code] = obj.connect(server);
           if ok_code.statusCode ~= 200
               error('Server error')
           end
           
           obj.file_directory = './files';
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
       function [obj, ok] = connect(obj, server)
           obj.servername = server;
           obj.connect_options = weboptions('ContentType', 'auto', ...
               'CharacterEncoding', 'UTF-8');
           ok = webread(strcat(obj.servername,'/api/ok'), obj.connect_options);
       end
       function ok = login(obj)
           ok = 1;
           request_msg.auth = obj.auth_data;
           response_msg = webwrite(strcat(obj.servername,'/api/login'), request_msg, obj.connect_options);
           if response_msg.isError
               error(response_msg.message)
               ok=0;
           end

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
           obj.auth_data.name = strip(input('Your full name: ', 's'));
           obj.auth_data.id = str2double(input('Your HDU ID: ', 's'));
           if isnan(obj.auth_data.id)
               error('Student id must be a number!')
           end
           obj.auth_data.id = int32(obj.auth_data.id);
           obj.auth_data.email = strip(input('Type your affiliated with university EMail: ', 's'));
           obj.auth_data.password = input('Password: ', 's');
           again_password = input('Retype your password: ', 's');
           if ~strcmp(again_password, obj.auth_data.password)
               error('Password does not match')
           end
           request_msg.auth = obj.auth_data;
           response_msg = webwrite(strcat(obj.servername,'/api/register'), request_msg, obj.connect_options);
           if response_msg.isError
               error(response_msg.message)
           end
           fid=fopen(obj.auth_filename,'w');
           fprintf(fid, jsonencode(obj.auth_data));
       end
       function task = get_task(obj, number)
           task = nan;
           request_msg.auth = obj.auth_data;
           request_msg.number = number;
           response_msg = webwrite(strcat(obj.servername,'/api/gettask'), request_msg, obj.connect_options);
           if response_msg.isError
               error(response_msg.message)
           end
           task = struct();
           task.number = number;
           task.parameters = response_msg.data.parameters;
           task.answers = response_msg.data.answers;
           task.files = response_msg.data.files;
           if class(task.files)=='ceil'
               for i=1:size(task.files,1)
                   disp(task.files)
                   [p, name, ext] = fileparts(task.files{i});
                   websave(fullfile(obj.file_directory, strcat(name, ext)),strcat(obj.servername,task.files), obj.connect_options);
               end
           elseif class(task.files)=='char'
               [p, name, ext] = fileparts(task.files);
               websave(fullfile(obj.file_directory, strcat(name, ext)),strcat(obj.servername,task.files), obj.connect_options);
           end
       end
       function score = send_task(obj, task)
           request_msg.auth = obj.auth_data;
           request_msg.task = task;
           response_msg = webwrite(strcat(obj.servername,'/api/send_task'), request_msg, obj.connect_options);
           if response_msg.isError
               error(response_msg.message)
           end
           if response_msg.message ~= ""
               disp(response_msg.message)
           end
           score = response_msg.data;
       end
   end
end