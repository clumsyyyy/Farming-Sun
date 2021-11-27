% note: SELALU INCLUDE FILE INI di fungsi modular
% predicate dibuat global jadi bisa diakses dimana saja

% ====== predicate global ======
:- dynamic(pos/2).          % posisi pemain
% arg 1: absis, arg 2: ordinat
:- dynamic(occupation/1).   % pekerjaan pemain (fisherman, farmer, rancher)
:- dynamic(level/1).        % level
:- dynamic(exp/1).          % exp
:- dynamic(farmLevel/1).    % level farming
:- dynamic(farmEXP/2).      % exp farming
:- dynamic(fishEXP/2).      % exp mancing
:- dynamic(ranchLevel/1).   % level ranching
:- dynamic(ranchEXP/2).     % exp ranching
% arg 1: level, lvlUpReq, exp
:- dynamic(gold/1).         % duit
:- dynamic(day/1).          % hari
:- dynamic(inventory/1).    % invent

% ======= predicate farming ======
:- dynamic(seed/5).
%:- dynamic(myplant/7).

% ======= predicate ranching ======
:- dynamic(livestock/2).
:- dynamic(ranchTimeMgmt/2).

% ======= predicate quest ======
:- dynamic(myquest/6). 
:- dynamic(rewardquest/2).

% ======= diary ========
:- dynamic(diary/2).