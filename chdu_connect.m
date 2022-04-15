function chdu = chdu_connect()
    fr = fopen('client/version.txt', 'r');
    current_hash = fscanf(fr, '%s');
    fclose(fr);
    try
        connect_options = weboptions('ContentType', 'auto', ...
               'CharacterEncoding', 'UTF-8');
        version_response = webread(strcat('http://127.0.0.1:5000','/client_version'), connect_options);
        if version_response.isError
            return
        else
            new_hash = version_response.data.md5;
            check_hash = strcmp(new_hash, current_hash);
%             disp(check_hash)
            if ~check_hash
                fr = fopen('client/version.txt', 'w');
                fwrite(fr, new_hash);
                fclose(fr);
%             websave(strcat('http://127.0.0.1:5000','/client/CHDU.m') ,strcat(obj.servername,'/client/CHDU.m'), obj.connect_options);
            end
        end
    catch
        disp('Can not get client version... Please try later')
        return
    end
    try
        chdu = CHDU();
        disp('Connection established')
    catch e
        disp(strcat('Error: \n', e))
        disp('Can not connect to server... Please try later')
        return
    end
end