  reference.start = [-10 -10]; % mm
  reference.width = [0.1 0.1]; % mm
  reference.data = rand(200);

  target.start = [-10 -10]; % mm
  target.width = [0.1 0.1]; % mm
  target.data = rand(200);

  percent = 3;
  dta = 0.5; % mm
  local = 0; % Perform global gamma
  
  %gamma = CalcGamma(reference, target, percent, dta, 'local', local, 'limit', 2*dta);

  inputpath = '\\10.213.72.56\fs_general\Samuele\test-gamma-ARC-CHECK\';
  
  % Measured
  measured = Tread_archeck_txt([inputpath, 'MapCHECK Measured\'], '11-Jan-2021-A.txt');
 
  % Calculated
  calculated = Tread_ArcCheck_snc([inputpath, 'TPS calculated\'], 'DCMTPS_Calculated(NORDIO LUIGI)_AC_EXTRACTED.snc');