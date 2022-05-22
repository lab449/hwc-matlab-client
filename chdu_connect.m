function chdu = chdu_connect()
    fr = fopen('version.txt', 'r');
    current_hash = fscanf(fr, '%s');
    fclose(fr);
    try
        connect_options = weboptions('ContentType', 'auto', ...
               'CharacterEncoding', 'UTF-8');
        version_response = webread(strcat('http://127.0.0.1:5000','/matlab_client_version'), connect_options);
        if version_response.isError
            return
        else
            new_hash = version_response.data.md5;
            check_hash = strcmp(new_hash, current_hash);
%             disp(check_hash)
            if ~check_hash
                fr = fopen('version.txt', 'w');
                fwrite(fr, new_hash);
                fclose(fr);
                disp("Client updating!")
%                 websave(strcat('http://127.0.0.1:5000','/hwc-matlab-client/CHDU.m') ,strcat(obj.servername,'/hwc-matlab-client/CHDU.m'), obj.connect_options);
            end
        end
    catch
        disp('Can not get client version... Please try later')
        return
    end
    chdu = CHDU();
    ok = chdu.login();
    if ~ok
        fprintf('Invalid authentification data. Please use first the chdu_reset() and then repeat chdu_connect()\n')
        fprintf('CHDU session can not be started\n')
        chdu = nan;
    else
        disp('Connection established')
    end
end