function chdu = chdu_reset()
    fn = 'client/auth_config.json';
    if exist(fn, 'file') == 2
        delete(sprintf('%s',fn));
        fprintf('Deleting %s\n', fn)
    end
end
