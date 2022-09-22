function hwc = hwc_connect(server)
    if nargin ~= 1
        server = 'localhost:5051';
    end
    import java.security.*;
    import java.math.*;
    import java.lang.String;

    md = MessageDigest.getInstance('MD5');
    hash = md.digest(double( fileread('HWC.m')));
    bi = BigInteger(1, hash);
    char(bi.toString(16));
    current_hash = char(String.format('%032x', bi));
    
    try
        connect_options = weboptions('ContentType', 'auto', ...
               'CharacterEncoding', 'UTF-8');

        websave('hwc_connect.m', strcat(server, '/clients/hwc-matlab-client/hwc_connect.m'));

        version_response = webread(strcat(server,'/api/matlab/client_version'), connect_options);
        new_hash = version_response.data.md5;
        check_hash = strcmp(new_hash, current_hash);
        if ~check_hash
            websave('HWC.m', strcat(server, '/clients/hwc-matlab-client/HWC.m'));
            disp("Сient has been updated")
        end
    catch
        disp('Can not get client version... Please try later')
        return
    end
    hwc = nan;
    hwc = HWC(server);
    ok = hwc.login();

    if ~ok
        fprintf('\nInvalid authentification data. Please repeat hwc_connect()\n')
        hwc_reset()
        fprintf('HWC session can not be started\n')
        hwc = nan;
        return 
    else
        disp('Connection established')
    end
end
