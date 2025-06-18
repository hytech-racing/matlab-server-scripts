function result = critical_timestamps(filePath)
    % Parse HDF5 file into structured data
    p = parse(filePath);
    
    % Initialize result structure
    result = struct();

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
    result.bms_ok                     = tryEval(@() getChangeTimestamps(p.acu_ok.bms_ok));
    result.imd_ok                     = tryEval(@() getChangeTimestamps(p.acu_ok.imd_ok));
    result.bspd_ok                    = tryEval(@() getChangeTimestamps(p.VCRData_s.shutdown_sensing_data.bspd_is_ok));
    result.drivebrain_in_control     = tryEval(@() getChangeTimestamps(p.VCRData_s.status.drivebrain_is_in_control));
    result.vn_locked                  = tryEval(@() getValueTimestamps(p.VNData.status.ins_mode, 2));
    result.inv1_error                 = tryEval(@() getValueTimestamps(p.inv1_status.error, true));
    result.inv2_error                 = tryEval(@() getValueTimestamps(p.inv2_status.error, true));
    result.inv3_error                 = tryEval(@() getValueTimestamps(p.inv3_status.error, true));
    result.inv4_error                 = tryEval(@() getValueTimestamps(p.inv4_status.error, true));
    result.implaus_exceeded          = tryEval(@() getValueTimestamps(p.pedals_system_data.implaus_exceeded_max_duration, true));
    result.brake_accel_implausibility= tryEval(@() getValueTimestamps(p.pedals_system_data.brake_accel_implausibility, true));
    result.accel_implausible         = tryEval(@() getValueTimestamps(p.pedals_system_data.accel_implausible, true));
    result.brake_implausible         = tryEval(@() getValueTimestamps(p.pedals_system_data.brake_implausible, true));
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
