function result = critical_timestamps(filePath)
    % Parse HDF5 file into structured data
    p = parse(filePath);

    % Helper: try evaluating expression, else return empty
    function out = tryEval(expr)
        try
            out = expr();
        catch
            out = [];
        end
    end

    encounteredtrue = false

    % Track signals
    signals = struct();
    signals.bms_ok                     = tryEval(@() getChangeTimestamps(p.acu_ok.bms_ok));
    signals.imd_ok                     = tryEval(@() getChangeTimestamps(p.acu_ok.imd_ok));
    signals.bspd_ok                    = tryEval(@() getChangeTimestamps(p.VCRData_s.shutdown_sensing_data.bspd_is_ok));
    signals.drivebrain_in_control      = tryEval(@() getChangeTimestamps(p.VCRData_s.status.drivebrain_is_in_control));
    signals.vn_locked                  = tryEval(@() getValueTimestamps(p.VNData.status.ins_mode, 2));
    signals.inv1_error                 = tryEval(@() getValueTimestamps(p.inv1_status.error, true));
    signals.inv2_error                 = tryEval(@() getValueTimestamps(p.inv2_status.error, true));
    signals.inv3_error                 = tryEval(@() getValueTimestamps(p.inv3_status.error, true));
    signals.inv4_error                 = tryEval(@() getValueTimestamps(p.inv4_status.error, true));
    signals.implaus_exceeded           = tryEval(@() getValueTimestamps(p.pedals_system_data.implaus_exceeded_max_duration, true));
    signals.brake_accel_implausibility = tryEval(@() getValueTimestamps(p.pedals_system_data.brake_accel_implausibility, true));
    signals.accel_implausible          = tryEval(@() getValueTimestamps(p.pedals_system_data.accel_implausible, true));
    signals.brake_implausible          = tryEval(@() getValueTimestamps(p.pedals_system_data.brake_implausible, true));

    
    % Define file name
    fileName = ['/data/mps_generated/' char(matlab.lang.internal.uuid()) '/critical_timestamps.mat'];
    fileLocation = fullfile(pwd, fileName);

    % Ensure all folders in the path exist
    folderPath = char(fileparts(fileLocation));
    if ~exist(folderPath, 'dir')
        mkdir(folderPath);  % Creates nested directories automatically, if needed
    end

    % Save the matrix to a MAT file using -v7.3 format for matfile support
    save(fileLocation, signals, '-v7.3');

    % Return
    result.type = 'mat';
    result.result = fileName;
end

function timestamps = getChangeTimestamps(ts)
    % Return timestamps where the signal changes
    data = ts.Data;
    time = ts.Timestamp;
    change_idx = [false; diff(data) ~= 0];
    timestamps = time(change_idx);
end
function timestamps = getValueTimestamps(ts, targetValue)
    data = ts.Data;
    time = ts.Timestamp;

    timestamps = [];
    wasMatching = false;

    for i = 1:length(data)
        if isequal(data(i), targetValue)
            if ~wasMatching
                timestamps(end+1) = time(i); %#ok<AGROW>
                wasMatching = true;
            end
        else
            wasMatching = false;
        end
    end
end
