function hwc = hwc_reset()
    fn = 'auth_config.json';
    if exist(fn, 'file') == 2
        delete(sprintf('%s',fn));
        fprintf('Deleting %s\n', fn)
    end
end
