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
        version_response = webread(strcat('http://hdu.vedyakov.com:5000','/matlab_client_version'), connect_options);
        if version_response.isError
            return
        else
            new_hash = version_response.data.md5;
            check_hash = strcmp(new_hash, current_hash);
            if ~check_hash
                websave('CHDU.m', 'https://raw.githubusercontent.com/ITMORobotics/hwc-matlab-client/main/CHDU.m')
                disp("Сient has been updated")
            end
        end
    catch
        disp('Can not get client version... Please try later')
        return
    end
    ok = 0;
    chdu = nan;
        chdu = CHDU();
    try
        ok = chdu.login();
    catch e
        disp('Error: ')
        disp(e)
        disp("Invalid registration info")
        return
    end
    if ~ok
        fprintf('Invalid authentification data. Please use first the chdu_reset() and then repeat chdu_connect()\n')
        fprintf('CHDU session can not be started\n')
    else
        disp('Connection established')
    end
end