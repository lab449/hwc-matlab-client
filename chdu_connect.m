function chdu = chdu_connect()
    import java.security.*;
    import java.math.*;
    import java.lang.String;

    md = MessageDigest.getInstance('MD5');
    hash = md.digest(double( fileread('CHDU.m')));
    bi = BigInteger(1, hash);
    char(bi.toString(16));
    current_hash = char(String.format('%032x', bi));

    try
        connect_options = weboptions('ContentType', 'auto', ...
               'CharacterEncoding', 'UTF-8');

        websave('chdu_connect.m', 'https://raw.githubusercontent.com/ITMORobotics/hwc-matlab-client/main/chdu_connect.m');

        version_response = webread(strcat('https://hdu.vedyakov.com','/api/matlab_client_version'), connect_options);
        new_hash = version_response.data.md5;
        check_hash = strcmp(new_hash, current_hash);
        if ~check_hash
            websave('CHDU.m', 'https://raw.githubusercontent.com/ITMORobotics/hwc-matlab-client/main/CHDU.m')
            disp("Сient has been updated")
        end
    catch
        disp('Can not get client version... Please try later')
        return
    end

    chdu = nan;
    chdu = CHDU();
    ok = chdu.login();

    if ~ok
        fprintf('\nInvalid authentification data. Please repeat chdu_connect()\n')
        chdu_reset()
        fprintf('CHDU session can not be started\n')
        chdu = nan;
        return 
    else
        disp('Connection established')
    end
end
